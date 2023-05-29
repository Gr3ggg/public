#!/bin/bash

# copier/coller ds votre Shell: rm -f unbound.sh && wget https://github.com/Gr3ggg/public/raw/main/unbound.sh && chmod +x unbound.sh && ./unbound.sh
# Déterminer le shell actuel
shell=$(basename "$SHELL")

# Vérifier le shell et sourcer le fichier de configuration approprié
if [ "$shell" = "bash" ]; then
    echo "alias wunbound='cd && rm -f unbound.sh && wget https://github.com/Gr3ggg/public/raw/main/unbound.sh && chmod +x unbound.sh && ./unbound.sh'" >> ~/.bashrc
    source ~/.bashrc
elif [ "$shell" = "zsh" ]; then
    echo "alias wunbound='cd && rm -f unbound.sh && wget https://github.com/Gr3ggg/public/raw/main/unbound.sh && chmod +x unbound.sh && ./unbound.sh'" >> ~/.zshrc
    source ~/.zshrc
fi

# Mise à jour du système
apt update
apt upgrade -y

# Installation d'Unbound
apt install wget unbound -y

# Arrêt du service Unbound
systemctl stop unbound

# Récupérer l'adresse IP de la machine
IP_machine=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Configuration d'Unbound
cat << EOF > /etc/unbound/unbound.conf
server:
  interface: $IP_machine
  port: 53
  do-ip4: yes
  do-ip6: yes
  do-udp: yes
  do-tcp: yes
  access-control: 0.0.0.0/0 allow       ## mettre votre reseau local ipv4
  access-control: ::/64 allow           ## mettre votre reseau local ipv6
  #access-control: 0.0.0.0/0 refuse     ## décommenter si reseau local renseigné
  #access-control: ::/0 refuse          ## décommenter si reseau local renseigné
  do-daemonize: yes
  verbosity: 3
  hide-identity: yes
  hide-version: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  auto-trust-anchor-file: "/var/lib/unbound/root.key"
  use-caps-for-id: yes
  cache-min-ttl: 3600
  cache-max-ttl: 86400
  minimal-responses: yes
  prefetch: yes
  prefetch-key: yes
  num-threads: 6
  rrset-roundrobin: yes
  msg-cache-slabs: 16
  rrset-cache-slabs: 16
  infra-cache-slabs: 16
  key-cache-slabs: 16
  rrset-cache-size: 256m
  msg-cache-size: 128m
  so-rcvbuf: 1m
  unwanted-reply-threshold: 10000
  do-not-query-localhost: yes
  val-clean-additional: yes
  logfile: "/var/log/unbound/unbound.log"
  log-queries: yes
  log-time-ascii: yes

  #private-domain: "example.com"                      ## a modifier
  #local-zone: "example.com." static                  ## a modifier
  #local-data: "example.com. IN A 192.168.1.100"      ## a modifier
  #local-data-ptr: "192.168.1.100 example.com"        ## a modifier

root-hints: "/var/lib/unbound/root.hints"

#forward-zone:
#  name: "."
#  forward-addr: 1.1.1.1
#  forward-addr: 1.0.0.1
#  forward-addr: 2606:4700:4700::1111
#  forward-addr: 2606:4700:4700::1001

##je bloque cetaines pubs
local-zone: "doubleclick.net" redirect
local-data: "doubleclick.net A 127.0.0.1"
local-zone: "googlesyndication.com" redirect
local-data: "googlesyndication.com A 127.0.0.1"
local-zone: "googleadservices.com" redirect
local-data: "googleadservices.com A 127.0.0.1"
local-zone: "google-analytics.com" redirect
local-data: "google-analytics.com A 127.0.0.1"
local-zone: "ads.youtube.com" redirect
local-data: "ads.youtube.com A 127.0.0.1"
local-zone: "adserver.yahoo.com" redirect
local-data: "adserver.yahoo.com A 127.0.0.1"
local-zone: "ask.com" redirect
local-data: "ask.com A 127.0.0.1"

EOF

# Téléchargement des serveurs root
wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache

# Définition des permissions sur le fichier de configuration et les serveurs root
chown unbound:unbound /etc/unbound/unbound.conf
chown unbound:unbound /var/lib/unbound/root.hints
mkdir /var/log/unbound
chown unbound:unbound /var/log/unbound

# Récupérer l'adresse IP de la machine
IP_machine=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Vérifier si l'adresse IP est vide
if [ -z "$IP_machine" ]; then
  echo "Impossible de récupérer l'adresse IP de la machine."
  exit 1
fi

# Modifier le fichier /etc/resolv.conf
sed -i "1s/.*/domain server/" /etc/resolv.conf
sed -i "2s/.*/search server/" /etc/resolv.conf
sed -i "3s/.*/nameserver $IP_machine/" /etc/resolv.conf

# Ajouter les autres serveurs DNS à la fin du fichier
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
echo "#nameserver 1.0.0.1" >> /etc/resolv.conf

# Démarrage du service Unbound
systemctl start unbound

# Vérification du statut du service
systemctl status unbound

# Sourcing automatique du fichier de configuration
if [ "$shell" = "bash" ]; then
    exec bash
elif [ "$shell" = "zsh" ]; then
    exec zsh
fi

