#!/bin/bash
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

echo "Preparing database initialization..."

cat << EOF > /tmp/init_db.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
-- Create user if not exists, or update password if they do
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
-- Also allow root remote access (optional, but helpful for debugging)
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Data folder is empty. Installing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
else
    echo "Data folder already exists. Skipping installation..."
fi

echo "Starting MariaDB..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --init-file=/tmp/init_db.sql