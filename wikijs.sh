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

docker run -d \
  --name=wikijs \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Paris \
  -e DB_TYPE=sqlite \ 
  -p 3000:3000 \
  -v /$HOME/docker/wikijs/config:/config \
  -v /$HOME/docker/wikijs/data:/data \
  --restart unless-stopped \
  --network npmproxy \
  lscr.io/linuxserver/wikijs:latest