FROM debian:buster

COPY ./tools/wordpress_start.sh /bin

RUN apt update -y && \
	apt install -y php php-fpm php-mysql curl && \
	mkdir /run/php && mkdir -p /var/www/html && chmod +x /bin/wordpress_start.sh

WORKDIR /var/www/html/

EXPOSE 9000

ENTRYPOINT ["wordpress_start.sh"]

CMD ["php-fpm7.3", "-F"]
