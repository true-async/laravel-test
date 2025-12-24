<?php

use FrankenPHP\HttpServer;
use FrankenPHP\Request;
use FrankenPHP\Response;

set_time_limit(0);

// Laravel root directory
define('LARAVEL_ROOT', __DIR__);

// Logging function
function log_debug($message, $context = []) {
    $logPath = __DIR__ . '/storage/logs/async-debug.log';
    $timestamp = date('[Y-m-d H:i:s]');

    // Convert objects to detailed info
    array_walk_recursive($context, function(&$value) {
        if (is_object($value)) {
            $value = [
                '__class' => get_class($value),
                '__properties' => get_object_vars($value),
                '__methods' => get_class_methods($value)
            ];
        }
    });

    $contextStr = empty($context) ? '' : ' ' . json_encode($context, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
    @file_put_contents($logPath, "$timestamp $message$contextStr\n", FILE_APPEND);
}

log_debug("=== Entrypoint started ===");

// Register shutdown function to catch fatal errors
register_shutdown_function(function() {
    $error = error_get_last();
    if ($error !== null && in_array($error['type'], [E_ERROR, E_CORE_ERROR, E_COMPILE_ERROR])) {
        log_debug('FATAL ERROR', $error);
    }
});

// Set error handler
set_error_handler(function($errno, $errstr, $errfile, $errline) {
    log_debug("ERROR[$errno]", [
        'message' => $errstr,
        'file' => $errfile,
        'line' => $errline
    ]);
    return false; // Let PHP handle normally
});

// Set exception handler
set_exception_handler(function($exception) {
    log_debug('UNCAUGHT EXCEPTION', [
        'type' => get_class($exception),
        'message' => $exception->getMessage(),
        'file' => $exception->getFile(),
        'line' => $exception->getLine(),
        'trace' => $exception->getTraceAsString()
    ]);

    // Special handling for PDOException
    if ($exception instanceof PDOException) {
        error_log("[PDO EXCEPTION] " . $exception->getMessage() . "\n" . $exception->getTraceAsString());
    }
});

// Load Composer autoloader
require_once __DIR__ . '/vendor/autoload.php';
log_debug("Autoloader loaded");

// ============================================
// STATEFUL: Bootstrap Laravel ONCE (outside onRequest)
// ============================================
log_debug("Bootstrapping Laravel (ONCE)...");
$app = require __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);

// Replace DatabaseManager with CoroutineAwareDatabaseManager
$app->singleton('db', function ($app) {
    return new \App\Database\CoroutineAwareDatabaseManager($app, $app['db.factory']);
});

log_debug("Laravel bootstrapped successfully", [
    'app_class' => get_class($app),
    'kernel_class' => get_class($kernel)
]);

//
// The function, the entry point, is called from NGINX UNIT.
//
HttpServer::onRequest(function (Request $request, Response $response) use ($app, $kernel) {

    log_debug('=== REQUEST START ===', [
        'method' => $request->getMethod(),
        'uri' => $request->getUri()
    ]);

    $method = $request->getMethod();
    $uri = $request->getUri();
    $path = parse_url($uri, PHP_URL_PATH);

    // Check for static files (CSS, JS, images, etc.)
    if (preg_match('/\.(css|js|png|jpg|jpeg|gif|svg|ico|woff|woff2|ttf|eot|json|xml)$/i', $path)) {
        $filePath = __DIR__ . '/public' . $path;

        if (file_exists($filePath) && is_file($filePath)) {
            log_debug("Serving static file", ['path' => $filePath]);

            // MIME types mapping
            $mimeTypes = [
                'css' => 'text/css',
                'js' => 'application/javascript',
                'png' => 'image/png',
                'jpg' => 'image/jpeg',
                'jpeg' => 'image/jpeg',
                'gif' => 'image/gif',
                'svg' => 'image/svg+xml',
                'ico' => 'image/x-icon',
                'woff' => 'font/woff',
                'woff2' => 'font/woff2',
                'ttf' => 'font/ttf',
                'eot' => 'application/vnd.ms-fontobject',
                'json' => 'application/json',
                'xml' => 'application/xml',
            ];

            $ext = strtolower(pathinfo($filePath, PATHINFO_EXTENSION));
            $contentType = $mimeTypes[$ext] ?? 'application/octet-stream';

            $response->setStatus(200);
            $response->setHeader('Content-Type', $contentType);
            $response->setHeader('Cache-Control', 'public, max-age=3600');
            $response->write(file_get_contents($filePath));
            $response->end();
            return;
        }
    }

    // Start output buffering
    ob_start();

    try {
        // Get current coroutine ID for logging
        $coroutine = \Async\current_coroutine();
        $coroutineId = $coroutine ? $coroutine->getId() : 0;

        log_debug("Processing request in coroutine", [
            'coroutine_id' => $coroutineId,
            'total_coroutines' => count(\Async\get_coroutines())
        ]);

        $parsedUrl = parse_url($uri);
        $queryString = $parsedUrl['query'] ?? '';
        $queryParams = [];
        if ($queryString !== '') {
            parse_str($queryString, $queryParams);
        }

        $_GET = $queryParams;
        $_REQUEST = array_merge($queryParams, $_POST ?? []);
        $_SERVER['QUERY_STRING'] = $queryString;

        // Create Laravel Request from globals
        $laravelRequest = Illuminate\Http\Request::capture();

        log_debug("Processing request through kernel");

        // Process request through Laravel kernel (using shared kernel)
        $laravelResponse = $kernel->handle($laravelRequest);

        log_debug("Request processed", [
            'status' => $laravelResponse->getStatusCode()
        ]);

        // Convert Laravel Response to async Response
        $response->setStatus($laravelResponse->getStatusCode());

        // Set headers
        foreach ($laravelResponse->headers->all() as $name => $values) {
            foreach ($values as $value) {
                $response->setHeader($name, $value);
            }
        }

        // Write content
        $response->write($laravelResponse->getContent());
        $response->end();

        log_debug("Response sent");

        // Terminate Laravel kernel (cleanup)
        $kernel->terminate($laravelRequest, $laravelResponse);

        // Purge this coroutine's DB connection (if our custom manager is in use)
        $db = $app->make('db');
        if (method_exists($db, 'purgeCoroutineConnection')) {
            $db->purgeCoroutineConnection($coroutineId);
        }

        log_debug("Request completed", [
            'coroutine_id' => $coroutineId
        ]);

    } catch (Throwable $e) {
        log_debug('REQUEST ERROR', [
            'message' => $e->getMessage(),
            'file' => $e->getFile(),
            'line' => $e->getLine(),
            'trace' => $e->getTraceAsString()
        ]);

        ob_end_clean();

        // Send error response
        $response->setStatus(500);
        $response->setHeader('Content-Type', 'text/html; charset=UTF-8');

        if (env('APP_DEBUG', false)) {
            // Show detailed error in debug mode
            $html = '<!DOCTYPE html><html><head><title>Error 500</title></head><body>';
            $html .= '<h1>Error 500 - Internal Server Error</h1>';
            $html .= '<p><strong>Message:</strong> ' . htmlspecialchars($e->getMessage()) . '</p>';
            $html .= '<p><strong>File:</strong> ' . htmlspecialchars($e->getFile()) . ':' . $e->getLine() . '</p>';
            $html .= '<pre>' . htmlspecialchars($e->getTraceAsString()) . '</pre>';
            $html .= '</body></html>';
            $response->write($html);
        } else {
            // Generic error in production
            $response->write('<h1>Internal Server Error</h1>');
        }

        $response->end();
        return;
    } finally {
        // Always reset globals to avoid leaking state across coroutines
        $_GET = [];
        $_REQUEST = [];
        unset($_SERVER['QUERY_STRING']);
    }

    // Clean output buffer
    ob_end_clean();

    log_debug('=== REQUEST END ===');
});

log_debug("Request handler registered, waiting for connections...");
