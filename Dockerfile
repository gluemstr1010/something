FROM php:8.1-fpm

RUN adduser --disabled-password --gecos '' newuser \
    && adduser newuser sudo \
    && echo '%sudo ALL=(ALL:ALL) ALL' >> /etc/sudoers

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip

RUN docker-php-ext-install zip 

COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

#COPY ./nette-blog/composer.* ./
COPY nette-blog/ /var/www/html

RUN chown newuser temp log

USER newuser

ENV COMPOSER_ALLOW_SUPERUSER=1

#COPY nette-blog/ /var/www/html

WORKDIR /var/www/html/

RUN composer install --no-interaction

RUN composer dump-autoload --optimize







