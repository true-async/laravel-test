# ===== FrankenPHP with TrueAsync PHP for Laravel (Linux x64 ZTS Release) =====
# Multi-stage build: builder + runtime
# Optimized for Laravel TrueAsync application

# ---------- BUILDER STAGE ----------
FROM ubuntu:24.04 AS builder

# Updated to use global-isolation branches
ARG PHP_BRANCH=true-async
ARG TRUEASYNC_BRANCH=main
ARG FRANKENPHP_BRANCH=true-async
ARG XDEBUG_BRANCH=true-async-86
ARG GO_VERSION=1.23.4

# ---------- 1. System toolchain & libraries ----------
RUN apt-get update && apt-get install -y \
    autoconf bison build-essential curl re2c git \
    cmake ninja-build wget dos2unix \
    libxml2-dev libssl-dev pkg-config libargon2-dev \
    libcurl4-openssl-dev libedit-dev libreadline-dev \
    libsodium-dev libsqlite3-dev libonig-dev libzip-dev \
    libpng-dev libjpeg-dev libwebp-dev libfreetype6-dev \
    libgmp-dev libldap2-dev libsasl2-dev libpq-dev \
    libmysqlclient-dev libbz2-dev libenchant-2-dev \
    libffi-dev libgdbm-dev liblmdb-dev libsnmp-dev \
    libtidy-dev libxslt1-dev libicu-dev libpsl-dev \
    libpcre2-dev

# ---------- 2. Install Go ----------
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:$PATH"
ENV GOTOOLCHAIN=local

# ---------- 3. libuv 1.49 ----------
RUN wget -q https://github.com/libuv/libuv/archive/v1.49.0.tar.gz \
    && tar -xf v1.49.0.tar.gz \
    && cd libuv-1.49.0 && mkdir build && cd build \
    && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF \
    && ninja && ninja install && ldconfig \
    && cd / && rm -rf libuv*

# ---------- 4. curl 8.10 ----------
RUN wget -q https://github.com/curl/curl/releases/download/curl-8_10_1/curl-8.10.1.tar.gz \
    && tar -xf curl-8.10.1.tar.gz \
    && cd curl-8.10.1 \
    && ./configure --prefix=/usr/local --with-openssl --enable-shared --disable-static \
    && make -j$(nproc) && make install && ldconfig \
    && cd / && rm -rf curl*

# ---------- 5. Clone repositories ----------
# Clone PHP with TrueAsync patches (global-isolation branch)
RUN git clone --depth=1 --branch=${PHP_BRANCH} https://github.com/true-async/php-src /usr/src/php-src

# Clone TrueAsync extension (global-isolation branch)
RUN git clone --depth=1 --branch=${TRUEASYNC_BRANCH} https://github.com/true-async/php-async /usr/src/php-async

# Clone FrankenPHP with TrueAsync support
RUN git clone --depth=1 --branch=${FRANKENPHP_BRANCH} https://github.com/true-async/frankenphp /usr/src/frankenphp

# Clone XDEBUG with TrueAsync support
RUN git clone --depth=1 --branch=${XDEBUG_BRANCH} https://github.com/true-async/xdebug /usr/src/xdebug

# ---------- 6. Copy async extension into PHP source ----------
RUN mkdir -p /usr/src/php-src/ext/async \
    && cp -r /usr/src/php-async/* /usr/src/php-src/ext/async/

# ---------- 6.1. Fix Windows line endings ----------
RUN dos2unix /usr/src/php-src/ext/async/config.m4 || true

# ---------- 7. Configure & build PHP ----------
WORKDIR /usr/src/php-src

RUN ./buildconf --force && \
    ./configure \
    --prefix=/usr/local \
    --enable-embed \
    --with-pdo-mysql=mysqlnd --with-mysqli=mysqlnd \
    --with-pgsql --with-pdo-pgsql --with-pdo-sqlite \
    --without-pear \
    --enable-gd --with-jpeg --with-webp --with-freetype \
    --enable-exif --with-zip --with-zlib \
    --enable-soap --enable-xmlreader --with-xsl --with-tidy --with-libxml \
    --enable-sysvsem --enable-sysvshm --enable-shmop --enable-pcntl \
    --with-readline \
    --enable-mbstring --with-curl --with-gettext \
    --enable-sockets --with-bz2 --with-openssl --with-gmp \
    --enable-bcmath --enable-calendar --enable-ftp --with-enchant \
    --enable-sysvmsg --with-ffi --enable-dba --with-lmdb --with-gdbm \
    --enable-snmp --enable-intl --with-ldap --with-ldap-sasl \
    --enable-werror \
    --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d \
    --disable-debug --enable-zts \
    --enable-async && \
    make -j$(nproc) && make install

# Verify phpize is available
RUN phpize --version && php-config --version

# ---------- 8. Build XDEBUG extension ----------
WORKDIR /usr/src/xdebug

RUN phpize && \
    ./configure && \
    make -j$(nproc) && \
    make install

# ---------- 9. PHP configuration ----------
RUN mkdir -p /etc/php.d && echo "opcache.enable_cli=1" > /etc/php.d/opcache.ini

# Configure XDEBUG
RUN echo "zend_extension=xdebug.so" > /etc/php.d/xdebug.ini && \
    echo "xdebug.mode=debug" >> /etc/php.d/xdebug.ini && \
    echo "xdebug.start_with_request=yes" >> /etc/php.d/xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /etc/php.d/xdebug.ini && \
    echo "xdebug.client_port=9009" >> /etc/php.d/xdebug.ini && \
    echo "xdebug.log=/app/www/storage/logs/xdebug.log" >> /etc/php.d/xdebug.ini && \
    echo "xdebug.log_level=7" >> /etc/php.d/xdebug.ini

# ---------- 10. Install e-dant/watcher (for file watching in FrankenPHP) ----------
WORKDIR /usr/local/src/watcher
RUN curl -s https://api.github.com/repos/e-dant/watcher/releases/latest | \
    grep tarball_url | \
    awk '{ print $2 }' | \
    sed 's/,$//' | \
    sed 's/"//g' | \
    xargs curl -L | \
    tar xz --strip-components 1 && \
    cmake -S . -B build -DCMAKE_BUILD_TYPE=Release && \
    cmake --build build && \
    cmake --install build && \
    ldconfig

# ---------- 11. Build FrankenPHP ----------
WORKDIR /usr/src/frankenphp

# Set up CGO flags for PHP embedding
ENV CGO_CFLAGS="$(php-config --includes)"
ENV CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)"

# Build FrankenPHP with TrueAsync support
RUN cd caddy/frankenphp && \
    go build -tags "trueasync,nowatcher" -o frankenphp && \
    cp frankenphp /usr/local/bin/frankenphp && \
    chmod +x /usr/local/bin/frankenphp

# ---------- RUNTIME STAGE ----------
FROM ubuntu:24.04 AS runtime

# Install only runtime dependencies + MySQL 8.0
RUN apt-get update && apt-get install -y --no-install-recommends \
    libxml2 libssl3 libargon2-1 \
    libcurl4 libedit2 libreadline8 \
    libsodium23 libsqlite3-0 libonig5 libzip4 \
    libpng16-16 libjpeg8 libwebp7 libfreetype6 \
    libgmp10 libldap2 libsasl2-2 libpq5 \
    libmysqlclient21 libbz2-1.0 libenchant-2-2 \
    libffi8 libgdbm6 liblmdb0 libsnmp40 \
    libtidy5deb1 libxslt1.1 libicu74 libpsl5 \
    libpcre2-8-0 libstdc++6 \
    ca-certificates curl \
    mysql-server-8.0 \
    && rm -rf /var/lib/apt/lists/*

# Create frankenphp user and group with fixed UID/GID
RUN groupadd -r -g 999 frankenphp && useradd -r -g frankenphp -u 999 frankenphp

# Create mysql directories and set permissions
RUN mkdir -p /var/run/mysqld /var/lib/mysql /var/log/mysql \
    && chown -R mysql:mysql /var/run/mysqld /var/lib/mysql /var/log/mysql \
    && chmod 755 /var/run/mysqld

# Copy built PHP and libraries from builder
COPY --from=builder /usr/local /usr/local
COPY --from=builder /etc/php.d /etc/php.d

# Copy watcher library
COPY --from=builder /usr/local/lib/libwatcher* /usr/local/lib/

# Create runtime directories with proper permissions
RUN mkdir -p /app/www /config/caddy /data/caddy /etc/caddy \
    && chown -R frankenphp:frankenphp /app /config /data

# Update library cache
RUN ldconfig

# Set PATH
ENV PATH="/usr/local/bin:/usr/local/sbin:$PATH"
ENV GODEBUG=cgocheck=0

# Verify installations
RUN php -v && frankenphp version

WORKDIR /app

# MySQL environment variables (can be overridden)
ENV MYSQL_ROOT_PASSWORD=root \
    MYSQL_DATABASE=laravel_async \
    MYSQL_USER=trueasync \
    MYSQL_PASSWORD=trueasync

# Expose HTTP, HTTPS, MySQL and XDEBUG ports
EXPOSE 8080 443 443/udp 3306 9009

# Copy startup script
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Copy application files
COPY app /app/www/app
COPY routes /app/www/routes
COPY config /app/www/config
COPY database /app/www/database
COPY public /app/www/public
COPY resources /app/www/resources
COPY bootstrap /app/www/bootstrap
COPY storage /app/www/storage
COPY entrypoint.php /app/www/entrypoint.php
COPY Caddyfile /app/www/Caddyfile
COPY .env /app/www/.env
COPY artisan /app/www/artisan
COPY composer.json /app/www/composer.json
COPY composer.lock /app/www/composer.lock

# Copy database dump
COPY db.sql /app/www/db.sql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
WORKDIR /app/www
RUN composer install --no-dev --optimize-autoloader --ignore-platform-reqs

# Set ownership and permissions for Laravel storage directories
RUN chown -R frankenphp:frankenphp /app/www \
    && chmod -R 775 /app/www/storage \
    && chmod -R 775 /app/www/bootstrap/cache

# Define volumes for configuration and MySQL data
VOLUME ["/var/lib/mysql"]

WORKDIR /app

# Note: Running as root to manage both MySQL and FrankenPHP services
# MySQL requires specific user permissions which are handled in the startup script

# Start using startup script
CMD ["/app/start.sh"]
