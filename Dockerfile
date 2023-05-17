FROM php:8.1-fpm

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip

RUN docker-php-ext-install zip 

COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

COPY ./nette-blog/composer.* ./

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN composer install --no-interaction

COPY nette-blog/ /var/www/html

WORKDIR /var/www/html/

RUN composer dump-autoload --optimize



