#!/bin/sh

set -e

if [ ! -f ./wp-config.php ]; then
    curl -O https://wordpress.org/latest.tar.gz
    tar -xzvf latest.tar.gz
    mv wordpress/* .
    rm -rf latest.tar.gz
    rmdir wordpress

    sed -i "s/username_here/$WP_USER_LOGIN/g" wp-config-sample.php
    sed -i "s/password_here/$WP_USER_PASSWORD/g" wp-config-sample.php
    sed -i "s/localhost/$WP_URL/g" wp-config-sample.php
    sed -i "s/database_name_here/$WP_TITLE/g" wp-config-sample.php
    
    mv wp-config-sample.php wp-config.php
fi

sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g" /etc/php/7.3/fpm/pool.d/www.conf

exec "$@"
