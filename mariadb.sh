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
read -p "Entrez le mot de passe ROOT de la base de données MySQL: " DBROOTPASS

# Démarrer le conteneur mariadb
docker run -d \
    --name db \
    -e MARIADB_ROOT_PASSWORD="$DBROOTPASS" \
    -p 3306:3306 \
    -v /$HOME/docker/mariadb/data:/var/lib/mysql \
    --restart always \
    --network npmproxy \
    mariadb

# Démarrer le conteneur adminer
docker run -d \
    --name adminer \
    -p 8081:8080 \
    --restart always \
    --network npmproxy \
    adminer
