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

# Lance le container speedtest
docker run -d \
    --name=speedtest \
    -v "$HOME/docker/speedtest:/config" \
    -p 8181:80 \
    --restart=unless-stopped \
    --network=npmproxy \
    ghcr.io/alexjustesen/speedtest-tracker:latest
