FROM debian:buster

RUN apt update -y
RUN apt install nginx -y
RUN apt install openssl -y
RUN mkdir -p /etc/nginx/ssl
RUN apt install OpenSSL -y
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/L=Lyon/O=42/OU=ale-cont/CN=ale-cont.42.fr"
RUN mkdir -p /var/run/nginx
# RUN chmod 755 /var/www/html
# RUN chown -R www-data:www-data /var/www/html

# COPY conf/nginx.conf /etc/nginx/sites-available/default

# EXPOSE 8080

# CMD [ "nginx", "-g", "daemon off;" ]