# Dockerfile

FROM php:8.4-fpm

# Install dependencies for PHP and necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    libzip-dev \
    curl \
    git \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring xml zip gd

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy the Laravel project files into the container
COPY . /var/www

# Install Composer dependencies
RUN composer install

# Fix permissions for Laravel storage folder
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
