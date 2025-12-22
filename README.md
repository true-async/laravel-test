# Laravel TrueAsync Docker with FrankenPHP

Docker container for Laravel application with TrueAsync PHP and FrankenPHP application server.

## Features

- **TrueAsync PHP** with async/await and coroutines support
- **FrankenPHP** modern application server built on Caddy
- **MySQL 8.0** database
- **XDebug** for debugging (port 9009)
- **Multi-stage build** for optimized image size
- **HTTPS support** with automatic certificates via Caddy
- **HTTP/2 and HTTP/3** support

## Quick Start

### Build the image

```bash
docker build -t laravel-frankenphp:latest .
```

### Run the container

```bash
docker run -d --name laravel-frankenphp -p 8080:8080 -p 443:443 -p 443:443/udp laravel-frankenphp:latest
```

With persistent MySQL data:
```bash
docker run -d --name laravel-frankenphp -p 8080:8080 -p 443:443 -p 443:443/udp -v laravel-mysql-data:/var/lib/mysql laravel-frankenphp:latest
```

### Access

- **Web Application (HTTP)**: http://localhost:8080
- **Web Application (HTTPS)**: https://localhost:443
- **MySQL**: localhost:3306
  - Database: `laravel_async`
  - User: `trueasync`
  - Password: `trueasync`
  - Root password: `root`

## Environment Variables

You can override MySQL settings:

```bash
docker run -d \
  -e MYSQL_ROOT_PASSWORD=mypassword \
  -e MYSQL_DATABASE=mydatabase \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypassword \
  laravel-frankenphp:latest
```

## Logs

View container logs:
```bash
docker logs -f laravel-frankenphp
```

Application logs inside container:
- Async debug: `/app/www/storage/logs/async-debug.log`
- Laravel: `/app/www/storage/logs/laravel.log`
- FrankenPHP access: `/app/www/storage/logs/frankenphp-access.log`
- XDebug: `/app/www/storage/logs/xdebug.log`

## Technical Details

### Components

- PHP: TrueAsync (global-isolation branch)
- TrueAsync extension: global-isolation branch
- FrankenPHP: true-async branch (built on Caddy)
- XDebug: true-async-86 branch
- MySQL: 8.0
- libuv: 1.49.0
- curl: 8.10.1
- Go: 1.23.4

### Architecture

FrankenPHP runs as a modern PHP application server with:
- **Worker mode** with TrueAsync support
- **Async threads**: 2 threads with buffer size 20 per thread
- **Coroutine-based request handling**: each request runs in its own coroutine
- **Efficient request processing**: event-driven architecture with libuv

### Configuration

The container automatically:
- Initializes MySQL database
- Imports database dump from `db.sql`
- Configures FrankenPHP from `Caddyfile`
- Sets up proper permissions for Laravel storage
- Starts FrankenPHP with TrueAsync worker mode

### Caddyfile Configuration

The application uses a Caddyfile for FrankenPHP configuration:
- 2 worker threads for optimal performance
- Async mode enabled with buffer size of 20 requests per thread
- All requests routed through the async entrypoint
- Access logging to `/app/www/storage/logs/frankenphp-access.log`

### Entrypoint

The `entrypoint.php` file uses FrankenPHP's TrueAsync API:
- `FrankenPHP\HttpServer::onRequest()` - registers the request handler
- `FrankenPHP\Request` - provides request information
- `FrankenPHP\Response` - allows sending responses

Each request is processed in a separate coroutine, enabling true async/await patterns in Laravel.

## Differences from NGINX Unit version

- **FrankenPHP** instead of NGINX Unit for better Go/PHP integration
- **Built-in HTTPS** support via Caddy
- **HTTP/3** support out of the box
- **Better performance** with worker mode and TrueAsync
- **Simplified configuration** via Caddyfile instead of JSON

## Development

### Custom Caddyfile

You can mount your own Caddyfile:

```bash
docker run -d \
  -v ./custom-Caddyfile:/app/www/Caddyfile \
  -p 8080:8080 \
  laravel-frankenphp:latest
```

### Debugging

XDebug is pre-configured and listens on port 9009. Configure your IDE to connect to:
- Host: `localhost`
- Port: `9009`

## License

MIT
