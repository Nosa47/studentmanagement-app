#!/bin/bash

# Fix permissions for Laravel storage and cache folders
echo "🔧 Fixing permissions..."
chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache
chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Optional: clear and cache config/views/routes (you can remove if not needed)
echo "⚙️ Running Laravel optimizations..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run the main container command
echo "🚀 Starting PHP-FPM..."
exec "$@"
