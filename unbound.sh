#!/bin/bash

# Mise à jour du système
apt update
apt upgrade -y

# Installation d'Unbound
apt install unbound -y

# Arrêt du service Unbound
systemctl stop unbound

# Configuration d'Unbound
cat << EOF > /etc/unbound/unbound.conf
server:
  interface: 0.0.0.0
  access-control: 10.0.0.0/8 allow
  access-control: 0.0.0.0/0 refuse
  do-daemonize: yes
  verbosity: 3
  hide-identity: yes
  hide-version: yes
  num-threads: 4
  minimal-responses: yes
  do-ip6: yes
  prefetch: yes
  prefetch-key: yes
  rrset-roundrobin: yes
  use-caps-for-id: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  use-caps-for-id: yes
  auto-trust-anchor-file: "/var/lib/unbound/root.key"
  val-clean-additional: yes
  do-not-query-localhost: no
  private-domain: "example.com"
  local-zone: "example.com." static
  local-data: "example.com. IN A 192.168.1.100"
  local-data-ptr: "192.168.1.100 example.com"
  cache-max-ttl: 86400
  cache-min-ttl: 3600


root-hints: "/var/lib/unbound/root.hints"

forward-zone:
  name: "."
  forward-addr: 1.1.1.1
  forward-addr: 1.0.0.1
  forward-addr: 2606:4700:4700::1111
  forward-addr: 2606:4700:4700::1001
EOF

# Téléchargement des serveurs root
wget -O /var/lib/unbound/root.hints https://www.internic.net/domain/named.cache

# Définition des permissions sur le fichier de configuration et les serveurs root
chown unbound:unbound /etc/unbound/unbound.conf
chown unbound:unbound /var/lib/unbound/root.hints

# Démarrage du service Unbound
systemctl start unbound

# Vérification du statut du service
systemctl status unbound
