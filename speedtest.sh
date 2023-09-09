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
    -p 8765:80 \
    -e TZ=Europe/Paris \
    -e PGID=1000 \
    -e PUID=1000 \
    -e OOKLA_EULA_GDPR=true \
    -l "logging-driver=json-file" \
    -l "logging-opt max-file=10" \
    -l "logging-opt max-size=200k" \
    --restart=unless-stopped \
    --network=npmproxy \
    henrywhitaker3/speedtest-tracker
