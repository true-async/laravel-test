# Laravel TrueAsync Docker

Docker container for Laravel application with TrueAsync PHP and NGINX Unit.

## Features

- **TrueAsync PHP** with async/await and coroutines support
- **NGINX Unit** application server
- **MySQL 8.0** database
- **XDebug** for debugging (port 9009)
- **Multi-stage build** for optimized image size

## Quick Start

### Build the image

```bash
docker build -t laravel-trueasync:latest .
```

### Run the container

```bash
docker run -d --name laravel-trueasync -p 8080:8080 laravel-trueasync:latest
```

With persistent MySQL data:
```bash
docker run -d --name laravel-trueasync -p 8080:8080 -v laravel-mysql-data:/var/lib/mysql laravel-trueasync:latest
```

### Access

- **Web Application**: http://localhost:8080
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
  laravel-trueasync:latest
```

## Logs

View container logs:
```bash
docker logs -f laravel-trueasync
```

Application logs inside container:
- Async debug: `/app/www/storage/logs/async-debug.log`
- Laravel: `/app/www/storage/logs/laravel.log`
- XDebug: `/app/www/storage/logs/xdebug.log`

## Technical Details

### Components

- PHP: TrueAsync (global-isolation branch)
- TrueAsync extension: global-isolation branch
- NGINX Unit: true-async branch
- XDebug: true-async-86 branch
- MySQL: 8.0
- libuv: 1.49.0
- curl: 8.10.1

### Configuration

The container automatically:
- Initializes MySQL database
- Imports database dump from `db.sql`
- Configures NGINX Unit from `unit-config.json`
- Sets up proper permissions for Laravel storage

## License

MIT
