#!/bin/sh

set -e

DOMAIN_NAME=${DOMAIN_NAME}

DB_HOST=$(grep 'DB_HOST=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_PATH=$(grep 'WP_PATH=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_DB_NAME=$(grep 'WP_DB_NAME=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_DB_USER=$(grep 'WP_DB_USER=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_DB_PASS=$(cat /run/secrets/db_password)
WP_TITLE=$(grep 'WP_TITLE=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_ADMIN_USER=$(grep 'WP_ADMIN_USER=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)
WP_ADMIN_EMAIL=$(grep 'WP_ADMIN_EMAIL=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_USER=$(grep 'WP_USER=' /run/secrets/credentials  | cut -d '=' -f 2 | tr -d ' \r\n')
WP_USER_EMAIL=$(grep 'WP_USER_EMAIL=' /run/secrets/credentials | cut -d '=' -f 2 | tr -d ' \r\n')
WP_USER_PASS=$(cat /run/secrets/wp_user_pass)

while ! mariadb -h${DB_HOST} -u${WP_DB_USER} -p${WP_DB_PASS} ${WP_DB_NAME} &>/dev/null; do
	echo "En attente de la disponibilité de la base de données..."
	sleep 3
done

if [ -f "/var/www/html/wordpress/wp-config.php" ]; then
	echo "wordpress already configured"
else
	echo "[WP config] Setting up WordPress..."
    echo "[WP config] Updating WP-CLI..."
    wp cli update --allow-root
    echo "[WP config] Creating wp-config.php..."
	wp config create --dbname=${WP_DB_NAME} --dbuser=${WP_DB_USER} --dbpass=${WP_DB_PASS} --dbhost=${DB_HOST} --path=${WP_PATH}/wordpress --allow-root
    echo "[WP config] Installing WordPress core..."
    wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASS} --admin_email=${WP_ADMIN_EMAIL} --path=${WP_PATH}/wordpress --allow-root
    echo "[WP config] Creating WordPress default user..."
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASS} --role=subscriber --path=${WP_PATH}/wordpress --allow-root
    echo "[WP config] Installing WordPress theme..."
    wp theme install bravada --path=${WP_PATH}/wordpress --activate --allow-root
fi

exec /usr/sbin/php-fpm82 -F -R
