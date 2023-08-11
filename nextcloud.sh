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
# Vérifier si l'utilisateur a les droits nécessaires pour exécuter Docker (nécessite d'être dans le groupe docker)
if ! groups | grep -q '\bdocker\b'; then
    echo "Vous n'avez pas les droits nécessaires pour exécuter Docker. Veuillez ajouter l'utilisateur au groupe docker ou exécuter ce script avec les privilèges de superutilisateur."
    exit 1
fi

# Démarrer le conteneur nextcloud
docker run -d --name nextcloud --network npmproxy -e TRUSTED_PROXIES=IPDUREVERSE -v /$HOME/docker/nextcloud/data:/var/www/html -p 8080:80 --restart unless-stopped nextcloud
