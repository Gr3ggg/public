#!/bin/bash

# Mettre à jour le système et installer Docker
sudo apt update && sudo apt upgrade -y
curl -sSL https://get.docker.com | sh

# Ajouter l'utilisateur courant au groupe Docker pour éviter d'utiliser 'sudo' avec les commandes Docker
sudo usermod -aG docker $(whoami)

# Créer le volume Docker pour Portainer
docker volume create portainer_data

# Créer le réseau Docker pour Portainer
docker network create npmproxy --subnet 172.18.0.0/16

# Démarrer le conteneur Portainer avec les options spécifiées
docker run -d -p 9443:9443 --network npmproxy --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Récupérer l'adresse IP de la machine
IP_MACHINE=$(hostname -I | awk '{print $1}')

# Afficher l'URL pour se connecter à Portainer
echo "Pour vous connecter à Portainer, accédez à: https://$IP_MACHINE:9443/"

echo "Veuillez vous reconnecter !!!"

# Attendre 5 secondes
sleep 3

sudo reboot