# DOCKER COMPOSE :

Ce fichier Docker compose est utilisé pour créer et exécuter plusieurs conteneurs Docker interconnectés pour déployer un environnement WordPress.

Voici une explication détaillée de chaque section du fichier :

La section "version" spécifie la version du format Docker Compose utilisée dans ce fichier. Dans ce cas, c'est la version 3.

La section "networks" définit le réseau Docker utilisé par les conteneurs. Dans cet exemple, un réseau appelé "inception_net" est créé avec le pilote de réseau "bridge". Ce réseau sera utilisé pour connecter les conteneurs entre eux.

La section "volumes" définit les volumes Docker utilisés par les conteneurs pour stocker des données persistantes. Deux volumes sont créés ici :

- "wp" est un volume local qui est lié au chemin "/home/alric/data/wordpress" sur l'hôte. Cela signifie que les fichiers de WordPress seront stockés dans ce répertoire.
- "db" est également un volume local lié au chemin "/home/alric/data/mariadb" sur l'hôte. Ce volume est utilisé par la base de données MariaDB pour stocker ses fichiers de données.

La section "services" définit les différents conteneurs à créer et exécuter.

Le premier service est "mariadb", qui représente la base de données MariaDB utilisée par WordPress. Quelques propriétés de ce service sont :

- "container_name" spécifie le nom du conteneur.
- "build" indique le chemin vers le répertoire contenant les fichiers nécessaires pour construire l'image du conteneur MariaDB.
- "env_file" spécifie le fichier d'environnement contenant les variables d'environnement nécessaires pour la configuration de MariaDB.
- "volumes" monte le volume "db" dans le conteneur MariaDB pour stocker les fichiers de données de la base de données.
- "networks" connecte ce conteneur au réseau "inception_net".
- "restart" indique que le conteneur doit être redémarré automatiquement en cas d'échec.

Le deuxième service est "wordpress", qui représente l'application WordPress elle-même. Les propriétés de ce service sont similaires à celles du service "mariadb". Il dépend du service "mariadb" car il a besoin de la base de données pour fonctionner. De plus, il monte le volume "wp" dans le conteneur pour stocker les fichiers de WordPress.

Le troisième service est "nginx", qui est un serveur web utilisé comme proxy inverse pour WordPress. Quelques propriétés spécifiques à ce service sont :

- "container_name" spécifie le nom du conteneur.
- "build" indique le chemin vers le répertoire contenant les fichiers nécessaires pour construire l'image du conteneur NGINX.
- "ports" mappe le port 443 de l'hôte sur le port 443 du conteneur. Cela permet d'accéder à WordPress via HTTPS.
- "depends_on" indique que ce service dépend du service "wordpress" car il doit attendre que WordPress soit prêt avant de démarrer.
- "volumes" monte également le volume "wp" dans le conteneur, permettant à NGINX d'accéder aux fichiers de WordPress.
- "networks" connecte ce conteneur au réseau "inception_net".
- "restart" indique que le conteneur doit être redémarré automatiquement en cas d'échec.

En résumé, ce fichier Docker Compose configure trois conteneurs interconnectés : MariaDB, WordPress et NGINX. MariaDB est utilisé comme base de données, WordPress comme application web et NGINX comme serveur web pour fournir un accès sécurisé à WordPress via HTTPS. Les volumes sont utilisés pour stocker les données de WordPress et de la base de données de manière persistante.

# Dockerfile pour MariaDB

Ce Dockerfile est utilisé pour construire une image Docker de MariaDB avec des configurations spécifiques.
L'image de base utilisée est `debian:buster`.

L'instruction suivante est utilisée pour installer le serveur MariaDB :
RUN apt-get update && apt-get install -y mariadb-server

Le port par défaut de MariaDB, qui est le port 3306, est exposé avec l'instruction suivante :
EXPOSE 3306

Deux fichiers sont copiés dans le conteneur pour la configuration de MariaDB :

- `50-server.cnf` est copié dans `/etc/mysql/mariadb.conf.d/` pour personnaliser les paramètres de MariaDB.
- `initial_db.sql` est copié dans `/docker-entrypoint-initdb.d/` pour exécuter un script SQL lors de la création de la base de données initiale.

> Script initial_db.sql pour la base de données WordPress

Ce script SQL est utilisé pour créer et configurer la base de données WordPress. La première instruction crée une base de données appelée "wordpress" si elle n'existe pas déjà :
CREATE DATABASE IF NOT EXISTS wordpress;

Création de l'utilisateur : La deuxième instruction crée un utilisateur appelé "ale-cont" avec un mot de passe "12345" :
CREATE USER IF NOT EXISTS 'ale-cont'@'%' IDENTIFIED BY '12345';

Attribution des privilèges: La troisième instruction accorde tous les privilèges sur la base de données "wordpress" à l'utilisateur "ale-cont" :
GRANT ALL PRIVILEGES ON wordpress.* TO 'ale-cont'@'%';

Rafraîchissement des privilèges: L'instruction suivante met à jour les privilèges pour prendre en compte les modifications récentes :
FLUSH PRIVILEGES;

Modification du mot de passe de l'utilisateur root: Enfin, l'instruction modifie le mot de passe de l'utilisateur "root" sur l'instance locale de la base de données MariaDB. Le mot de passe est défini comme "root12345" :
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root12345';


La commande par défaut à exécuter lorsque le conteneur démarre est la suivante :
CMD ["mysqld", "--bind-address=0.0.0.0"]

Cela démarre le démon MariaDB en écoutant sur toutes les interfaces réseau.

La base de données est initialisée en exécutant le script SQL `initial_db.sql` lors du démarrage du conteneur. Les étapes suivantes sont effectuées :

- Démarrage du service MySQL.
- Exécution du script SQL `initial_db.sql` avec la commande `mysql < /docker-entrypoint-initdb.d/initial_db.sql`.
- Suppression du fichier `initial_db.sql` du répertoire d'initialisation.

# DOCKERFILE pour NGINX
- RUN apt-get update && apt-get install -y nginx openssl

Cette instruction met à jour les packages disponibles dans l'image de base à l'aide de apt-get update, puis installe NGINX et OpenSSL en utilisant apt-get install -y nginx openssl. L'option -y est utilisée pour confirmer automatiquement les prompts de confirmation lors de l'installation.
- EXPOSE 443

Cette instruction expose le port 443, qui est le port par défaut pour les connexions HTTPS utilisées par NGINX. Cela permettra à d'autres conteneurs ou à l'hôte d'accéder à NGINX via HTTPS.
- COPY ./conf/default /etc/nginx/sites-enabled/default

Cette instruction copie le fichier de configuration default depuis le répertoire local ./conf vers le répertoire /etc/nginx/sites-enabled/ dans le conteneur. Ce fichier de configuration est utilisé pour définir les paramètres du serveur virtuel par défaut de NGINX.
- COPY ./tools/nginx_start.sh /var/www
- RUN chmod +x /var/www/nginx_start.sh

Ces instructions copient le script nginx_start.sh depuis le répertoire local ./tools vers le répertoire /var/www dans le conteneur. Ensuite, elles modifient les permissions du script en utilisant chmod +x pour le rendre exécutable.
- ENTRYPOINT [ "/var/www/nginx_start.sh" ]

Cette instruction définit le point d'entrée du conteneur en exécutant le script nginx_start.sh situé dans /var/www lorsqu'il démarre. Le point d'entrée est le premier élément à être exécuté lorsque le conteneur est lancé.
- CMD ["nginx", "-g", "daemon off;"]

Cette instruction définit la commande par défaut à exécuter lorsque le conteneur démarre. Ici, elle exécute le processus NGINX en utilisant la commande nginx -g "daemon off;". Cela permet à NGINX de s'exécuter en mode non daemon (Respect du modèle de conteneurisation : Les conteneurs sont conçus pour être légers et éphémères. L'exécution d'un processus en mode démon peut entraîner des problèmes lors de la gestion des ressources, du nettoyage des conteneurs et de la coordination entre les conteneurs.) et de rester actif dans le premier plan du conteneur.

En résumé, ce Dockerfile construit une image Docker de NGINX basée sur Debian Buster, installe NGINX et OpenSSL, copie les fichiers de configuration et de script nécessaires, expose le port 443, définit le point d'entrée pour exécuter le script nginx_start.sh, et configure la commande par défaut pour exécuter NGINX.

## file 'default'
- listen 443 ssl; et listen [::]:443 ssl;

Ces directives indiquent à NGINX d'écouter sur le port 443 (HTTPS) pour les connexions sécurisées SSL/TLS.

server_name ale-cont.42.fr; : Cette directive spécifie le nom du serveur virtuel. Dans cet exemple, le serveur virtuel est configuré pour répondre aux requêtes pour le domaine ale-cont.42.fr.
- ssl on; : Cette directive active le support SSL pour le serveur virtuel.

ssl_protocols TLSv1.3; : Cette directive spécifie les protocoles SSL/TLS autorisés. Dans cet exemple, seul le protocole TLS version 1.3 est autorisé.

- ssl_certificate /etc/ssl/certs/nginx.crt;
- ssl_certificate_key /etc/ssl/private/nginx.key;

Ces directives indiquent les chemins des certificat SSL et de la clé privée utilisés par le serveur virtuel. Dans cet exemple, les certificat et clé sont situés respectivement dans /etc/ssl/certs/nginx.crt et /etc/ssl/private/nginx.key.

- root /var/www/html;

Cette directive spécifie le répertoire racine où les fichiers du site web seront servis. Dans cet exemple, le répertoire /var/www/html est défini comme répertoire racine.

- location / { ... }

Cette directive définit les règles de traitement pour l'URI de base (ex: /). Dans cet exemple, elle utilise la directive try_files pour tenter de résoudre les URI vers des fichiers statiques (ex: HTML, CSS) ou vers un fichier 404 si le fichier n'est pas trouvé. Elle définit également les fichiers index à rechercher (ex: index.php, index.html) et active l'auto-index pour afficher la liste des fichiers du répertoire si aucun fichier index n'est trouvé.

- location ~ \.php$ { ... }

Cette directive définit les règles de traitement pour les fichiers PHP. Elle utilise également la directive try_files pour tenter de résoudre les URI vers des fichiers PHP ou vers un fichier 404 si le fichier n'est pas trouvé. Elle inclut les paramètres FastCGI, spécifie l'adresse et le port (wordpress:9000) où le service FastCGI est exécuté, et configure les paramètres SCRIPT_FILENAME, SCRIPT_NAME et PATH_INFO utilisés par FastCGI pour le traitement des scripts PHP.

En résumé, ce fichier de configuration définit les paramètres du serveur virtuel par défaut de NGINX pour écouter les connexions HTTPS sur le port 443, activer SSL/TLS, spécifier les certificats SSL et clés privées, définir le répertoire racine du site web, et configurer les règles de traitement pour les URI de base et les fichiers PHP.

## nginx_start.sh
Ces lignes vérifient si le fichier du certificat SSL existe (nginx.crt). Si le fichier n'existe pas, cela signifie qu'aucun certificat SSL n'est configuré. Dans ce cas, le script génère un certificat SSL autofirmé à l'aide de la commande openssl req. Il spécifie des paramètres tels que la durée de validité du certificat (-days 365), la taille de la clé privée (rsa:4096), les chemins de sortie pour la clé privée (-keyout) et le certificat (-out), et les informations du sujet (-subj). Les informations du sujet indiquent les détails du certificat tels que le pays (/C), la localité (/L), l'organisation (/O), l'unité organisationnelle (/OU), et le nom commun (/CN).

# DOCKERFILE pour wordpress

- COPY ./tools/wordpress_start.sh /bin
> Cette ligne copie le fichier wordpress_start.sh du répertoire tools local vers le répertoire /bin de l'image Docker. Il sera utilisé pour démarrer WordPress.

- RUN apt update -y && \
    apt install -y php php-fpm php-mysql curl && \
    mkdir /run/php && mkdir -p /var/www/html && chmod +x /bin/wordpress_start.sh

Cette ligne exécute plusieurs commandes lors de la construction de l'image

- apt update -y

Met à jour les référentiels de packages de l'image de base.
- apt install -y php php-fpm php-mysql curl

Installe les packages PHP, PHP-FPM, PHP MySQL et Curl.
- mkdir /run/php

Crée le répertoire /run/php utilisé par PHP-FPM.

- mkdir -p /var/www/html

Crée le répertoire /var/www/html où seront stockés les fichiers de WordPress.
- chmod +x /bin/wordpress_start.sh

Rend le fichier wordpress_start.sh exécutable.
- WORKDIR /var/www/html/

Cette ligne définit le répertoire de travail (working directory) de l'image Docker. Toutes les commandes suivantes seront exécutées à partir de ce répertoire.
- EXPOSE 9000

Cette ligne expose le port 9000. Cela permettra de lier ce port avec d'autres conteneurs ou avec le système hôte.
- ENTRYPOINT ["wordpress_start.sh"]

Cette ligne définit le point d'entrée de l'image Docker. Lorsque le conteneur est démarré, le script wordpress_start.sh sera exécuté.
- CMD ["php-fpm7.3", "-F"]

Cette ligne spécifie la commande par défaut à exécuter lorsque le conteneur est démarré. Dans ce cas, il lance le serveur PHP-FPM en écoutant le port 9000 et en mode "daemon off" (-F).
En résumé, ce Dockerfile construit une image Docker pour WordPress basée sur Debian Buster. Il installe les packages PHP nécessaires, configure les répertoires, expose le port 9000 et définit le script wordpress_start.sh comme point d'entrée pour démarrer WordPress.

# wordpress_start.sh

- set -e

Cette ligne active l'option -e du shell, ce qui signifie que le script s'arrêtera immédiatement si une commande échoue.

- if [ ! -f ./wp-config.php ]; then
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

>Ces lignes vérifient si le fichier wp-config.php existe. 
Si le fichier n'existe pas, cela signifie que WordPress n'est pas encore installé.
Téléchargement de la dernière version de WordPress à partir du site officiel.
Extraction des fichiers de l'archive compressée.
Déplacement des fichiers extraits à la racine du répertoire de travail.
Suppression de l'archive compressée et du répertoire wordpress inutile.
Remplacement des valeurs de configuration par défaut dans le fichier wp-config-sample.php :
Remplacement de username_here par la valeur de la variable d'environnement $WP_USER_LOGIN.
Remplacement de password_here par la valeur de la variable d'environnement $WP_USER_PASSWORD.
Remplacement de localhost par la valeur de la variable d'environnement $WP_URL.
Remplacement de database_name_here par la valeur de la variable d'environnement $WP_TITLE.

Renommage du fichier wp-config-sample.php en wp-config.php.
- sed -i "s/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g" /etc/php/7.3/fpm/pool.d/www.conf

Cette ligne modifie le fichier de configuration /etc/php/7.3/fpm/pool.d/www.conf pour remplacer la directive listen = /run/php/php7.3-fpm.sock par listen = 9000. Cela permet à PHP-FPM d'écouter les connexions sur le port 9000 au lieu d'utiliser un socket UNIX.
- exec "$@"

Cette ligne exécute les arguments en ligne de commande passés au script. Cela permet d'exécuter les commandes spécifiées lors du démarrage du conteneur, après avoir appelé ce script. Cette étape est importante pour lancer le serveur PHP-FPM et démarrer WordPress.
En résumé, le script wordpress_start.sh vérifie si WordPress est déjà installé. S'il ne l'est pas, il télécharge et extrait la dernière version de WordPress, met à jour le fichier de configuration wp-config.php avec les valeurs des variables d'environnement appropriées, et modifie la configuration de PHP-FPM pour utiliser le port 9000. Ensuite, il exécute les commandes passées en ligne de commande pour démarrer WordPress.


https://github.com/alexnik42/inception/
https://github.com/Florian-A/Inception