#!/bin/sh

docker run -d --name npm -p 80:80 -p 443:443 -p 81:81  -v /$HOME/docker/npm/data:/data -v /$HOME/docker/npm/letsencrypt:/etc/letsencrypt --restart unless-stopped jc21/nginx-proxy-manager:latest
