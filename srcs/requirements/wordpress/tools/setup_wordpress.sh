#!/bin/bash
set -e

WP_PATH="/var/www/html"

echo "Waiting for MariaDB to be ready..."
#until mariadb-admin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
until mariadb-admin ping -h"mariadb" --silent; do
    	sleep 2
done

# Read password from secret file
if [ -n "$WORDPRESS_DB_PASSWORD_FILE" ] && [ -f "$WORDPRESS_DB_PASSWORD_FILE" ]; then
    WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")
    export WORDPRESS_DB_PASSWORD
fi

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
        --dbhost="mariadb:3306" \
        --path="$WP_PATH"

    echo "Executing WordPress core installation..."
    # C'est cette étape WP-CLI qui valide l'automatisation complète exigée par le sujet
    wp core install --allow-root \
        --url="${WORDPRESS_URL}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --path="$WP_PATH"

    echo "Creating an extra WordPress user..."
    # Souvent demandé pour ne pas utiliser uniquement le compte admin
    wp user create "${WORDPRESS_USER}" "${WORDPRESS_USER_EMAIL}" \
        --role=author \
        --user_pass="${WORDPRESS_USER_PASSWORD}" \
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

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F

