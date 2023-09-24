#!/bin/sh
# https://github.com/Forceu/Gokapi/

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

# Démarrer le conteneur gokapi
docker run -d -p 53842:53842 --network npmproxy --name gokapi -v /root/docker/gokapi/data:/app/data -v /root/docker/gokapi/config:/app/config f0rc3/gokapi:latest
