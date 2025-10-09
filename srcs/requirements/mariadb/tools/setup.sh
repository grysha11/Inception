#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

echo "Starting MariaDB..."
mariadbd --user=mysql --datadir=/var/lib/mysql &

until mariadb-admin ping --silent; do
  echo "Waiting for MariaDB to start..."
  sleep 2
done

echo "Running MariaDB setup..."
mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
CREATE USER IF NOT EXISTS \`${WP_ADMIN_USER}\`@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${WP_ADMIN_USER}\`@'%';
FLUSH PRIVILEGES;
EOF

echo "MariaDB setup complete. Keeping process in foreground."
wait
