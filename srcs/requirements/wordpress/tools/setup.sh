#!/bin/sh

if [ ! -f "/var/www/html/wp-config.php" ];then 
cd /var/www/html
DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
wp core --allow-root download --path="/var/www/html"

    wp config create --allow-root \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="$DB_HOST" \
        --skip-check \
        --path="/var/www/html"

    wp core install --allow-root \
        --url="$WP_DOMAIN_NAME" \
        --title="$WP_SITE_NAME" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --path="/var/www/html"

wp user create --allow-root $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD --path="/var/www/html"
wp config set WP_HOME "https://$WP_DOMAIN_NAME" --allow-root
wp config set WP_SITEURL "https://$WP_DOMAIN_NAME" --allow-root
wp search-replace "http://$WP_DOMAIN_NAME" "https://$WP_DOMAIN_NAME" --all-tables --allow-root
fi

exec "$@"