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

# Demande à l'utilisateur de saisir l'URL du webhook
read -p "Entrez l'URL du webhook (ou appuyez sur Entrée pour continuer sans webhook) : " WEBHOOK

if [ -z "$WEBHOOK" ]; then
    # Lance le container SANS webhook
    docker run -d \
        --name watchtower \
        --volume /var/run/docker.sock:/var/run/docker.sock \
        --network npmproxy \
        --restart unless-stopped \
        containrrr/watchtower
else
    # Demande à l'utilisateur de saisir le nom
    read -p "Entrez le nom : " NAME
    
    if [ -z "$NAME" ]; then
        echo "Le nom est obligatoire lorsque le webhook est fourni."
        exit 1
    fi
    
    # Lance le container AVEC webhook
    docker run -d \
        --name watchtower \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -e TZ=Europe/Paris \
        -e WATCHTOWER_SCHEDULE="0 0 4 * * *" \
        -e WATCHTOWER_CLEANUP=true \
        -e WATCHTOWER_NOTIFICATION_SLACK_HOOK_URL="$WEBHOOK/slack" \
        -e WATCHTOWER_NOTIFICATION_SLACK_IDENTIFIER="watchtower-$NAME" \
        -e WATCHTOWER_NOTIFICATIONS=slack \
        --restart unless-stopped \
        --network npmproxy \
        containrrr/watchtower
fi
