#!/bin/bash

read -p "Entrez le mot de passe : " YOURPASSWORD
read -p "Entrez votre IP PUBLIC : " IPPUBLIC


docker run -d \
    --name=wg-easy \
    -e WG_HOST=$IPPUBLIC \
    -e PASSWORD=$YOURPASSWORD \
    -v "$HOME/docker/wg-easy:/etc/wireguard" \
    -p 51820:51820/udp \
    -p 51821:51821/tcp \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    --sysctl net.ipv4.conf.all.src_valid_mark=1 \
    --sysctl net.ipv4.ip_forward=1 \
    --restart=unless-stopped \
    --network=npmproxy \
    weejewel/wg-easy
