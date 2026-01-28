#!/bin/bash
set -e

echo "Waiting for MariaDB to become available..."
until nc -z mariadb 3306; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is up and running. Proceeding with WordPress setup."

if [ ! -f "wp-config.php" ]; then
    if [ ! -f "index.php" ]; then
        wp core download --allow-root
    fi

    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb:3306

    wp config shuffle-salts --allow-root

    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="Inception Project" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email="user@example.com"

    wp user create --allow-root \
        ${WP_SECOND_USER} \
        user2@example.com \
        --role=author \
        --user_pass=${WP_SECOND_USER_PASSWORD}
fi

exec "$@"