#!/bin/bash

set -e

mkdir -p /var/www/html
chown -R www-data:www-data /var/www/html

exec "$@"