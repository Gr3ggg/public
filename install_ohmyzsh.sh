#!/bin/bash

# DL pour la suite
if [[ -e "modif_ohmyzsh.sh" ]]; then
  echo "Le fichier existe. Suppression en cours..."
  rm "modif_ohmyzsh.sh"
  echo "Le fichier a été supprimé avec succès."
else
  echo "Le fichier n'existe pas."
fi
wget https://github.com/Gr3ggg/public/raw/main/modif_ohmyzsh.sh && chmod +x modif_ohmyzsh.sh

# Vérification des dépendances
echo "Installation des dépendances..."
if [[ $(command -v git) && $(command -v zsh) ]]; then
  echo "Dépendances déjà installées."
else
  echo "Installation des dépendances..."
  sudo apt update
  sudo apt install -y git zsh
fi

# Changement du shell par défaut en Zsh
echo "Changement du shell par défaut en Zsh..."
chsh -s $(which zsh)

rm -rf /$HOME/.oh-my-zsh

# Installation d'Oh My Zsh
echo "Installation d'Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Terminé ! Veuillez redémarrer votre session ou ouvrir un nouvel onglet/terminal pour utiliser Oh My Zsh. ensuite executer cette commande ./modif_ohmyzsh.sh"
