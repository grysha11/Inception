#!/bin/bash
set -e

# wait for mariadb tcp port to be reachable
wait_for_db() {
  echo "Waiting for mariadb on mariadb:3306..."
  for i in {1..30}; do
    if bash -c ">/dev/tcp/mariadb/3306" 2>/dev/null; then
      echo "mariadb reachable"
      return 0
    fi
    sleep 2
  done
  echo "Timed out waiting for mariadb"
  return 1
}

wait_for_db

# If wp-config.php missing, try to set up WP
if [ ! -f "wp-config.php" ]; then
    # If directory is empty -> download core. If files exist, skip download to avoid "already present" error.
    if [ -z "$(ls -A .)" ]; then
        echo "Directory empty — downloading WordPress core..."
        wp core download --allow-root
    else
        echo "Directory not empty — skipping wp core download"
    fi

    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb:3306

    echo "Installing WordPress..."
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
# ...existing code...