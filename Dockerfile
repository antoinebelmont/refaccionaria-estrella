FROM php:8.2-apache

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y \
    git unzip zip curl gnupg2 \
    libzip-dev libpng-dev libonig-dev libxml2-dev \
    libicu-dev \
    && docker-php-ext-install pdo pdo_mysql zip intl

# Instala Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Instala Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Habilita mod_rewrite (útil para Laravel u otros frameworks)
RUN a2enmod rewrite

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Copia el código al contenedor
COPY ./src /var/www/html

# Da permisos
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html
