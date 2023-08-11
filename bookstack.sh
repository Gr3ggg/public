#!/bin/bash

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    echo "Docker n'est pas installé. Veuillez installer Docker avant de continuer."
    exit 1
fi

# Vérifier si le réseau "npmproxy" existe
if ! docker network inspect npmproxy &> /dev/null; then
    echo "Le réseau 'npmproxy' n'existe pas. Assurez-vous de le créer."
    exit 1
fi

# Demander les variables à l'utilisateur
read -p "Entrez l'URL de l'application BookStack: " URL
read -p "Entrez le mot de passe ROOT de la base de données MySQL: " DBROOTPASS
read -p "Entrez le nom d'utilisateur de la base de données: " DBUSER
read -p "Entrez le mot de passe de l'utilisateur de la base de données: " DBPASS
read -p "Entrez le nom de la base de données BookStack: " DBNAME

# Obtenez l'ID de l'utilisateur et l'ID de groupe de celui qui exécute le script
IDPUID=1000
IDGUID=1000

# Démarrer le conteneur MariaDB
docker run -d \
  --name bookstack_db \
  -e PUID=$IDPUID \
  -e PGID=$IDGUID \
  -e MYSQL_ROOT_PASSWORD="$DBROOTPASS" \
  -e TZ=Europe/Paris \
  -e MYSQL_DATABASE="$DBNAME" \
  -e MYSQL_USER="$DBUSER" \
  -e MYSQL_PASSWORD="$DBPASS" \
  -v /$HOME/docker/bookstack/bookstack_db_data:/config \
  --restart unless-stopped \
  --network npmproxy \
  lscr.io/linuxserver/mariadb

# Démarrer le conteneur BookStack
docker run -d \
  --name bookstack \
  -e PUID=$IDPUID \
  -e PGID=$IDGUID \
  -e APP_URL="$URL" \
  -e DB_HOST=bookstack_db \
  -e DB_PORT=3306 \
  -e DB_USER="$DBUSER" \
  -e DB_PASS="$DBPASS" \
  -e DB_DATABASE="$DBNAME" \
  -v /$HOME/docker/bookstack/bookstack_app_data:/config \
  -p 6875:80 \
  --restart unless-stopped \
  --network npmproxy \
  --link bookstack_db:bookstack_db \
  lscr.io/linuxserver/bookstack
