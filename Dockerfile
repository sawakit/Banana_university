FROM php:7.2-apache

# System Dependencies.
RUN apt-get update && apt-get install -y \
                git \
                imagemagick \
                libicu-dev \
                # Required for SyntaxHighlighting
                python3 \
        --no-install-recommends && rm -r /var/lib/apt/lists/*

# Install the PHP extensions we need
RUN docker-php-ext-install mbstring mysqli opcache intl

# Install the default object cache.
RUN pecl channel-update pecl.php.net \
        && pecl install apcu \
        && docker-php-ext-enable apcu

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
                echo 'opcache.memory_consumption=128'; \
                echo 'opcache.interned_strings_buffer=8'; \
                echo 'opcache.max_accelerated_files=4000'; \
                echo 'opcache.revalidate_freq=60'; \
                echo 'opcache.fast_shutdown=1'; \
                echo 'opcache.enable_cli=1'; \
        } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# SQLite Directory Setup
RUN mkdir -p /var/www/data \
        && chown -R www-data:www-data /var/www/data
RUN mkdir -p /var/www/html/images \
        && chown -R www-data:www-data /var/www/html/images