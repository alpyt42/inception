FROM debian:buster

RUN apt-get update && apt-get install -y mariadb-server

# Expose the default MariaDB port
EXPOSE 3306

# Copy the configuration file
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy the SQL file for initial database setup
COPY ./tools/initial_db.sql /docker-entrypoint-initdb.d/

# Start the MariaDB service and listen on all network interfaces
CMD ["mysqld", "--bind-address=0.0.0.0"]

# Execute the SQL file during container initialization
RUN service mysql start \
	&& mysql < /docker-entrypoint-initdb.d/initial_db.sql \
	&& rm -f /docker-entrypoint-initdb.d/initial_db.sql
