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

# Démarrer le conteneur homepage
docker run -d -p 3000:3000 --name homepage --network npmproxy --restart unless-stopped -v /$HOME/docker/homepage:/app/config -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/gethomepage/homepage:latest