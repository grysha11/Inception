#!/bin/bash
set -e

echo "Waiting for MariaDB to become available..."
until nc -z mariadb 3306; do
    echo "MariaDB is unavailable - sleeping"
    sleep 2
done
echo "MariaDB is up and running. Proceeding with WordPress setup."

# Check if wp-config.php exists (meaning installation has run once)
if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root

    # **NEW METHOD: Create config file by modifying the sample**
    mv wp-config-sample.php wp-config.php

    # Replace placeholders with environment variables using sed
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php
    sed -i "s/localhost/mariadb/g" wp-config.php

    # Generate unique salts for security
    wp config shuffle-salts --allow-root

    # Run the core installation
    wp core install --allow-root \
        --url=${DOMAIN_NAME} \
        --title="Inception Project" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email="user@example.com"

    # Create the second user
    wp user create --allow-root \
        ${WP_SECOND_USER} \
        user2@example.com \
        --role=author \
        --user_pass=${WP_SECOND_USER_PASSWORD}
fi

# Finally, execute the CMD (php-fpm) to keep the container running
exec "$@"