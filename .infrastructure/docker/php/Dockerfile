FROM php:8.3-cli-alpine

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    zip \
    unzip \
    bash \
    make

# Install PHP extensions
RUN install-php-extensions \
    mbstring \
    zip \
    pdo_mysql \
    opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Expose port (default 8000, can be overridden via env)
EXPOSE 8000

# Start PHP built-in server
CMD ["sh", "-c", "php -S 0.0.0.0:${PHP_SERVER_PORT:-8000} -t public"]
