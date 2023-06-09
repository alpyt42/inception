# Use Debian Buster as the base image
FROM debian:buster

# Install necessary packages
RUN apt-get update && apt-get install -y mariadb-server

# Copy the configuration files
COPY my.cnf /etc/mysql/my.cnf

# Expose the default MariaDB port
EXPOSE 3306

# Start the MariaDB service
CMD ["mysqld"]