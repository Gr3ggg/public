#!/bin/sh

sudo apt update && sudo apt upgrade -y

curl -sSL https://get.docker.com | sh

sudo usermod -aG docker $(whoami)

exit

docker volume create portainer_data

docker network create npmproxy --subnet 172.18.0.0/16

docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Pour se connecter: http://<ip_server>:9443/