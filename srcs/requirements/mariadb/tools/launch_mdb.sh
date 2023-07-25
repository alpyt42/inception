#!/bin/bash

set -e

service mysql start

if [ ! -d "/var/lib/mysql/$WP_TITLE" ]

then

mysql_secure_installation << EOF

n
y
y
y
y
EOF

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $WP_TITLE; GRANT ALL ON $WP_TITLE.* TO '$WP_USER_LOGIN'@'%' IDENTIFIED BY '$WP_USER_PASSWORD'; FLUSH PRIVILEGES;"

mysql -uroot -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;"

fi

mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

exec "$@"