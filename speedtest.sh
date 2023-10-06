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

# Exécutez le conteneur de base de données MariaDB
docker run -d --name speedtest-tracker-db --network npmproxy \
    -e MYSQL_DATABASE=speedtest_tracker \
    -e MYSQL_USER=speedyy \
    -e MYSQL_PASSWORD=passsword \
    -e MYSQL_RANDOM_ROOT_PASSWORD=true \
    -v /root/docker/speedtest-tracker/speedtest-db:/var/lib/mysql \
    mariadb:10

# Attendez quelques secondes pour la base de données MariaDB pour démarrer complètement
sleep 10

# Exécutez le conteneur principal Speedtest Tracker
docker run -d --name speedtest-tracker --network npmproxy \
    -e PUID=1000 \
    -e PGID=1000 \
    -e DB_CONNECTION=mysql \
    -e DB_HOST=db \
    -e DB_PORT=3306 \
    -e DB_DATABASE=speedtest_tracker \
    -e DB_USERNAME=speedyy \
    -e DB_PASSWORD=passsword \
    -e TZ=Europe/Paris \
    -p 8181:80 \
    -v /etc/localtime:/etc/localtime:ro \
    -v /root/docker/speedtest-tracker/config:/config \
    -v /root/docker/speedtest-tracker/web:/etc/ssl/web \
    --restart unless-stopped \
    ghcr.io/alexjustesen/speedtest-tracker:latest
