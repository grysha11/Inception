#!/bin/bash
set -e

if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root

    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306

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