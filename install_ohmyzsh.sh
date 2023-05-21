#!/bin/bash

# Vérifier si l'utilisateur est root
if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être exécuté en tant que root" 
   exit 1
fi

# Mettre à jour le système
apt update
apt upgrade -y
Apt autoremove -y

# Installer les dépendances
apt install -y zsh git

# Changer le shell par défaut pour zsh
chsh -s $(which zsh)

# Télécharger et installer oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "L'installation de oh-my-zsh est terminée. Veuillez vous déconnecter et vous reconnecter pour utiliser zsh."

# Charger les modifications
exec zsh 

