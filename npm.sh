#!/bin/bash

# script pour Debian
# copier/coller ds votre Shell: cd && rm -f npm.sh && wget https://github.com/Gr3ggg/public/raw/main/npm.sh && chmod +x npm.sh && ./npm.sh

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

# Lancer la commande Docker
docker run -d --name npm -p 80:80 -p 443:443 -p 81:81 --network npmproxy -v "$HOME/docker/npm/data:/data" -v "$HOME/docker/npm/letsencrypt:/etc/letsencrypt" --restart unless-stopped jc21/nginx-proxy-manager:latest

echo "La commande Docker a été lancée avec succès !"