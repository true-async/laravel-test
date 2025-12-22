#!/bin/bash
set -e

echo "=== FrankenPHP with TrueAsync PHP + MySQL 8.0 for Laravel ==="
echo "PHP Version: $(php -v | head -n1)"
echo "FrankenPHP Version: $(frankenphp version 2>&1 | head -n1)"
echo "MySQL Version: $(mysqld --version)"
echo ""

# Initialize MySQL if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
  echo "Initializing MySQL database..."
  mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL
echo "Starting MySQL..."
mysqld --user=mysql --datadir=/var/lib/mysql --socket=/var/run/mysqld/mysqld.sock &
MYSQL_PID=$!

# Wait for MySQL to be ready
echo "Waiting for MySQL to be ready..."
for i in {1..30}; do
  if mysqladmin ping -h localhost --silent 2>/dev/null; then
    echo "MySQL is ready"
    break
  fi
  sleep 1
done

# Configure MySQL (set root password, create database and user)
if [ -n "$MYSQL_ROOT_PASSWORD" ]; then
  mysql -u root <<-EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'localhost';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL
  echo "MySQL configured: database=${MYSQL_DATABASE}, user=${MYSQL_USER}"
fi

# Import database dump if exists and database is empty
DB_DUMP="/app/www/db.sql"
if [ -f "$DB_DUMP" ]; then
  echo "Found database dump at $DB_DUMP"
  TABLE_COUNT=$(mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} -e "SHOW TABLES;" 2>/dev/null | wc -l)
  if [ "$TABLE_COUNT" -le 1 ]; then
    echo "Importing database dump..."
    mysql -u root -p${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < "$DB_DUMP"
    echo "Database dump imported successfully"
  else
    echo "Database already contains tables, skipping import"
  fi
else
  echo "No database dump found at $DB_DUMP"
fi

# Configuration paths
CONFIG_FILE="${FRANKENPHP_CONFIG_FILE:-/app/www/Caddyfile}"

echo "Configuration: $CONFIG_FILE"
echo "Web Root: /app/www"
echo ""

# Check if configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Configuration file not found at $CONFIG_FILE"
  exit 1
fi

# Ensure storage directories have correct permissions
chown -R frankenphp:frankenphp /app/www/storage /app/www/bootstrap/cache
chmod -R 775 /app/www/storage /app/www/bootstrap/cache

# Create logs directory if it doesn't exist
mkdir -p /app/www/storage/logs
chown -R frankenphp:frankenphp /app/www/storage/logs

# Start FrankenPHP
echo "Starting FrankenPHP with TrueAsync support..."
cd /app/www

frankenphp run --config "$CONFIG_FILE" &
FRANKENPHP_PID=$!

echo ""
echo "========================================"
echo "Laravel TrueAsync Application is ready!"
echo "========================================"
echo "FrankenPHP: http://0.0.0.0:8080"
echo "           https://0.0.0.0:443"
echo "MySQL: localhost:3306"
echo "  - Database: ${MYSQL_DATABASE}"
echo "  - User: ${MYSQL_USER}"
echo "  - Password: ${MYSQL_PASSWORD}"
echo "========================================"
echo ""
echo "Logs:"
echo "  - Async debug: /app/www/storage/logs/async-debug.log"
echo "  - Laravel: /app/www/storage/logs/laravel.log"
echo "  - FrankenPHP access: /app/www/storage/logs/frankenphp-access.log"
echo "  - XDebug: /app/www/storage/logs/xdebug.log"
echo "========================================"
echo ""

# Wait for both processes
wait -n $FRANKENPHP_PID $MYSQL_PID
exit $?
