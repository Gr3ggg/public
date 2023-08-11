#!/bin/bash

# Vérifier que le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en tant que root. Essayez avec sudo."
  exit 1
fi

# Chemin du fichier sshd_config
sshd_config="/etc/ssh/sshd_config"

# Sauvegarder le fichier sshd_config
cp "$sshd_config" "${sshd_config}.backup"

# Fonction pour redémarrer le service SSH
restart_ssh() {
  service ssh restart
  echo "Le service SSH a été redémarré."
}

# Fonction pour modifier la configuration
modify_config() {
  option="$1"
  # Modifier la ligne correspondant à "#PermitRootLogin" ou "PermitRootLogin"
  sed -i -E "s/^#?PermitRootLogin .*/PermitRootLogin $option/" "$sshd_config"
  restart_ssh
  echo "PermitRootLogin configuré avec l'option : $option"
}

# Fonction pour modifier le port SSH
modify_port() {
  new_port="$1"
# Modifier la ligne correspondant à "#Port" ou "Port"
  sed -i -E "s/^#?Port .*/Port $new_port/" "$sshd_config"
  restart_ssh
  echo "Port configuré avec l'option : $new_port"
}

# Afficher le menu
echo "Choisissez une option :"
echo "1. Désactiver complètement l'accès root (le compte root ne pourra pas se connecter)"
echo "2. Autoriser l'accès root en utilisant un mot de passe ou une clé SSH"
echo "3. Autoriser l'accès root uniquement avec une clé SSH (désactiver l'authentification par mot de passe)"
echo "4. Modifier le port SSH par défaut"
echo "5. Quitter"
read -p "Entrez le numéro de l'option : " choice

case $choice in
  1)
    modify_config "no" "PermitRootLogin"
    ;;
  2)
    modify_config "yes" "PermitRootLogin"
    ;;
  3)
    modify_config "prohibit-password" "PermitRootLogin"
    ;;
  4)
    read -p "Entrez le nouveau port SSH : " new_port
    modify_port "$new_port"
    ;;
  5)
    echo "Opération annulée. Aucun changement n'a été effectué."
    ;;
  *)
    echo "Option invalide. Le script a été annulé."
    ;;
esac