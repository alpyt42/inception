CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'ale-cont'@'%' IDENTIFIED BY '12345';
GRANT ALL PRIVILEGES ON wordpress.* TO 'ale-cont'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root12345';