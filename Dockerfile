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

# Copy the custom entrypoint script and set execution permissions
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set ownership and permissions for all files and directories (safe defaults at build time)
RUN chown -R www-data:www-data /var/www && \
    find /var/www -type f -exec chmod 644 {} \; && \
    find /var/www -type d -exec chmod 755 {} \;

# Install PHP dependencies (production)
RUN composer install --no-dev --optimize-autoloader

# Expose the port PHP-FPM listens on
EXPOSE 9000

# Use the entrypoint script to handle post-mount setup (e.g., permissions)
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
