#!/bin/sh

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

# Démarrer le conteneur it-tools
docker run -d -p 8383:80 --network npmproxy --name it-tools --restart unless-stopped corentinth/it-tools:latest
