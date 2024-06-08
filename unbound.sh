#!/bin/bash

# Mise à jour du système
apt update && apt upgrade -y && apt autoremove -y

# Installation d'Unbound
apt install wget curl unbound apparmor -y

# Arrêt du service Unbound
systemctl stop unbound

# Récupérer l'adresse IPV4 de la machine
IP_MACHINEV4=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
# Récupérer l'adresse IPV6 de la machine
IP_MACHINEV6=$(ip -6 addr show eth0 | grep -oP '(?<=inet6\s)(?!fe80)[\da-fA-F:]+(::\d+)?' | grep -v fe80)

# Configuration d'Unbound
cat << EOF > /etc/unbound/unbound.conf.d/config.conf
server:
    # Adresses IP auxquelles Unbound écoutera les requêtes
    interface: $IP_MACHINEV4    # IPv4
    interface: $IP_MACHINEV6    # IPv6

    # Adresses IP auxquelles Unbound enverra les réponses
    outgoing-interface: $IP_MACHINEV4    # IPv4
    outgoing-interface: $IP_MACHINEV6    # IPv6

  port: 53
  do-ip4: yes
  do-ip6: yes
  do-udp: yes
  do-tcp: yes
  prefer-ip6: no
  # Set number of threads to use
  num-threads: 4
  access-control: 10.0.0.0/8 allow
  access-control: 172.16.0.0/12 allow
  access-control: 192.168.0.0/16 allow
  access-control: fe80::/10 allow
  access-control: fc00::/7 allow
  access-control: fd00::/8 allow
  access-control: 0.0.0.0/0 refuse
  access-control: ::/0 refuse
  do-daemonize: yes
  verbosity: 1
  # Hide DNS Server info
  hide-identity: yes
  hide-version: yes
  # Limit DNS Fraud and use DNSSEC
  harden-glue: yes
  harden-dnssec-stripped: yes
  use-caps-for-id: yes
  cache-min-ttl: 3600
  cache-max-ttl: 86400
  minimal-responses: yes
  prefetch: yes
  prefetch-key: yes
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

#forward-zone:
#  name: "."
#  forward-addr: 1.1.1.1@853
#  forward-addr: 1.0.0.1@853
#  forward-addr: 2606:4700:4700::1111
#  forward-addr: 2606:4700:4700::1001
#  forward-addr: https://dns.cloudflare.com/dns-query
#  forward-addr: tls://1dot1dot1dot1.cloudflare-dns.com
#  forward-addr: https://security.cloudflare-dns.com/dns-query
#  forward-addr: tls://security.cloudflare-dns.com

EOF

# Téléchargement des serveurs root
wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root
(crontab -l | grep -v "wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root" ; echo "0  0  1  */3  *  wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.root") | crontab -

# Définition des permissions sur le fichier de configuration et les serveurs root
chown unbound:unbound /etc/unbound/ -R
chown unbound:unbound /var/lib/unbound/root.hints
mkdir /var/log/unbound
chown unbound:unbound /var/log/unbound

# Récupérer l'adresse IP de la machine
IP_MACHINEV4=$(ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
IP_MACHINEV6=$(ip -6 addr show eth0 | grep -oP '(?<=inet6\s)(?!fe80)[\da-fA-F:]+(::\d+)?' | grep -v fe80)

# Vérifier si l'adresse IP est vide
if [ -z "$IP_MACHINEV4" ]; then
  echo "Impossible de récupérer l'adresse IP de la machine."
  exit 1
fi

# correction de bug
echo "/var/log/unbound/unbound.log rw," > /etc/apparmor.d/local/usr.sbin.unbound
apparmor_parser -r /etc/apparmor.d/usr.sbin.unbound

# Augmente la taille du tampon de réception maximale
  # Vérifie si la ligne "net.core.rmem_max = 1048576" existe déjà dans /etc/sysctl.conf
  if ! grep -q "net.core.rmem_max = 1048576" /etc/sysctl.conf; then
      # Ajoute la ligne à /etc/sysctl.conf
      echo "net.core.rmem_max = 1048576" >> /etc/sysctl.conf

      # Applique les modifications du fichier sysctl.conf
      sysctl -p
  fi

# Modifier le fichier /etc/resolv.conf
sed -i "1s/.*/domain server/" /etc/resolv.conf
sed -i "2s/.*/search server/" /etc/resolv.conf
sed -i "3s/.*/nameserver $IP_MACHINEV4/" /etc/resolv.conf
sed -i "4s/.*/nameserver $IP_MACHINEV6/" /etc/resolv.conf
sed -i '5d' /etc/resolv.conf
sed -i '6d' /etc/resolv.conf
sed -i '7d' /etc/resolv.conf
sed -i '8d' /etc/resolv.conf
sed -i '9d' /etc/resolv.conf
# Ajouter les autres serveurs DNS à la fin du fichier
# echo "#nameserver 1.1.1.1" >> /etc/resolv.conf
# echo "#nameserver 1.0.0.1" >> /etc/resolv.conf

# Démarrage du service Unbound
systemctl start unbound

# Vérification du statut du service
systemctl --no-pager status -l unbound

# Sourcing automatique du fichier de configuration
if [ "$shell" = "bash" ]; then
    exec bash
elif [ "$shell" = "zsh" ]; then
    exec zsh
fi

echo "L'installation de Unbound est terminée."
exit 0