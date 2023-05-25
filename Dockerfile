FROM php:8.1-fpm

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libzip-dev \
    unzip

RUN docker-php-ext-install zip 

RUN useradd newuser
RUN usermod -a -G www-data newuser 
RUN usermod -u 1001 newuser

RUN chown -R newuser:www-data nette-blog/

COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

#COPY nette-blog/ /var/www/html

COPY --chown=newuser:www-data nette-blog/ /var/www/html

RUN chown -R newuser /var/www/html

ENV COMPOSER_ALLOW_SUPERUSER=1

WORKDIR /var/www/html/

RUN composer install --no-interaction

RUN composer dump-autoload --optimize

USER newuser





