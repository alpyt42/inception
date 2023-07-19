#!/bin/bash

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Wordpress: setting up..."

    # Copy wordpress tmp to html
    cp -R /tmp/wordpress/* /var/www/html/;

    # Create wp-config.php file with database informations
    wp-cli.phar config create \
    --dbname=$DB_NAME \
    --dbuser=$DB_USER \
    --dbpass=$DB_PASSWORD \
    --dbhost=$DB_HOST \
    --dbprefix=wp_ \
    --path=/var/www/html/ \
    --allow-root;

    # Install wordpress and add superadmin user
    wp-cli.phar core install \
    --url=$WP_URL \
    --title=$WP_TITLE \
    --admin_user=$WP_SUPERADMIN_USER \
    --admin_email=$WP_SUPERADMIN_EMAIL \
    --admin_password=$WP_SUPERADMIN_PASSWORD \
    --path=/var/www/html/ \
    --allow-root ;

    # Create admin user
    wp-cli.phar user create $WP_ADMIN_USER $WP_ADMIN_EMAIL \
    --user_pass=$WP_ADMIN_PASSWORD \
    --role=administrator \
    --path=/var/www/html/ \
    --allow-root ;

    # Install Redis Object Cache plugin
    wp-cli.phar config set --allow-root --path=/var/www/html --anchor="/**#@+" --separator="\n\n" WP_REDIS_HOST redis
    wp-cli.phar config set --allow-root --path=/var/www/html --anchor="/**#@+" --separator="\n\n" --raw WP_REDIS_PASSWORD $REDIS_PASSWORD
    wp-cli.phar config set --allow-root --path=/var/www/html --anchor="/**#@+" --separator="\n\n" --raw WP_REDIS_PORT 6379
    wp-cli.phar config set --allow-root --path=/var/www/html --anchor="/**#@+" --separator="\n\n" --raw WP_REDIS_TIMEOUT 1
    wp-cli.phar config set --allow-root --path=/var/www/html --anchor="/**#@+" --separator="\n\n" --raw WP_REDIS_READ_TIMEOUT 1
    wp-cli.phar config set --allow-root --path=/var/www/html --anchor="/**#@+" --separator="\n\n" --raw WP_REDIS_DATABASE 0

    wp-cli.phar plugin install redis-cache \
    --activate \
    --path=/var/www/html/ \
    --allow-root ;

    wp-cli.phar redis enable \
    --path=/var/www/html/ \
    --allow-root ;

	# Change owner of wordpress files
    chown -R www-data:www-data /var/www/html;
    chmod -R 755 /var/www/html;

	echo "Wordpress: set up!"
fi

exec "$@"