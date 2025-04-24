FROM php:8.2-fpm

# Install system dependencies & clean up
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy the Laravel application into the container
COPY . .

# Set ownership and permissions for all files and directories
RUN chown -R www-data:www-data /var/www && \
    find /var/www -type f -exec chmod 644 {} \; && \
    find /var/www -type d -exec chmod 755 {} \; && \
    chmod -R ug+rwx /var/www/storage /var/www/bootstrap/cache

# Install dependencies (production only)
RUN composer install --no-dev --optimize-autoloader

# Expose the port the app will run on
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]
