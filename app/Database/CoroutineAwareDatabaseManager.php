<?php

namespace App\Database;

use Illuminate\Database\DatabaseManager;
use PDOException;

class CoroutineAwareDatabaseManager extends DatabaseManager
{
    /**
     * Get a database connection instance.
     *
     * @param  string|null  $name
     * @return \Illuminate\Database\Connection
     */
    public function connection($name = null)
    {
        // If no name specified, use default
        if (is_null($name)) {
            $name = $this->getDefaultConnection();
        }

        // Get current coroutine ID
        $coroutine = \Async\current_coroutine();
        $coroutineId = $coroutine ? $coroutine->getId() : 0;

        // Create unique connection name for this coroutine
        $coroutineName = "{$name}_coroutine_{$coroutineId}";

        // If connection doesn't exist for this coroutine, create it
        if (!isset($this->connections[$coroutineName])) {
            error_log("[CoroutineDB] Creating new connection for coroutine {$coroutineId}");

            // Get base configuration
            $config = $this->configuration($name);

            // Set the coroutine-specific connection config
            $this->app['config']["database.connections.{$coroutineName}"] = $config;

            // Create the connection
            $this->connections[$coroutineName] = $this->configure(
                $this->factory->make($config, $coroutineName),
                $coroutineName
            );

            $pdoId = spl_object_id($this->connections[$coroutineName]->getPdo());
            error_log("[CoroutineDB] Created connection {$coroutineName} with PDO ID: {$pdoId}");
        } else {
            $pdoId = spl_object_id($this->connections[$coroutineName]->getPdo());
            error_log("[CoroutineDB] Reusing connection {$coroutineName} with PDO ID: {$pdoId}");
        }

        return $this->connections[$coroutineName];
    }

    /**
     * Purge connection for specific coroutine
     */
    public function purgeCoroutineConnection($coroutineId)
    {
        $name = $this->getDefaultConnection();
        $coroutineName = "{$name}_coroutine_{$coroutineId}";

        if (isset($this->connections[$coroutineName])) {
            error_log("[CoroutineDB] Purging connection for coroutine {$coroutineId}");
            $this->purge($coroutineName);
            unset($this->connections[$coroutineName]);
        }
    }
}
