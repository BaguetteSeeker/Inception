#!/bin/bash
set -e

WP_PATH="/var/www/html"

echo "Waiting for MariaDB to be ready..."
#until mariadb-admin ping -h"$WP_DB_HOST" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
until mariadb-admin -h"mariadb" ping --silent; do
    	sleep 2
done

# Read password from secret file
#if [ -n "$WORDPRESS_DB_PASSWORD_FILE" ] && [ -f "$WORDPRESS_DB_PASSWORD_FILE" ]; then
#    WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
#    export WORDPRESS_DB_PASSWORD
#fi

echo "Setting up WordPress..."

# Download and configure WordPress if not present
if [ ! -f "$WP_PATH/wp-config.php" ]; then
        echo "Downloading WordPress core via WP-CLI..."
    # WP-CLI won't run as root by default; you have to force with  --allow-root
    wp core download --allow-root --path="$WP_PATH"

    echo "Creating wp-config.php..."
    wp core config --allow-root \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="$WP_DB_HOST" \
        --path="$WP_PATH"

    echo "Executing WordPress core installation..."
    # Automatic site configuration required by the subject
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="${SITE_TITLE}" \
        --admin_user="${WP_ADMIN_NAME}" \
        --admin_password="${WP_ADMIN_PWD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="$WP_PATH"

    echo "Creating an extra WordPress user..."
    # Mostly used instead of admin
    wp user create "${WP_USER_NAME}" "${WP_USER_MAIL}" \
        --role=author \
	--user_pass="${WP_USER_PWD}" \
        --allow-root \
        --path="$WP_PATH"

    # Set secure permissions
    find "$WP_PATH" -type d -exec chmod 750 {} \;
    find "$WP_PATH" -type f -exec chmod 640 {} \;
    chown -R www-data:www-data "$WP_PATH"

    echo "WordPress setup complete."
else
    echo "WordPress already initialized, skipping setup."
fi

mkdir -p /run/php

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F

