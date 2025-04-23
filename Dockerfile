FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy the Laravel application into the container
COPY . .

# Install dependencies
RUN composer install

# Expose the port the app will run on
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
