#!/bin/bash

# Set correct permissions after volume mount
#chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
#chmod -R ug+rwx /var/www/storage /var/www/bootstrap/cache

# Run the original CMD (php-fpm)
#exec "$@"
