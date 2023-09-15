#!/bin/sh

echo "Choisissez un shell :"
echo "1. Bash"
echo "2. Zsh"

read choice

case $choice in
    1)
        echo "Vous avez choisi Bash."
        chsh -s /bin/bash   # Change le shell par défaut de l'utilisateur en Bash
        exec bash
        ;;
    2)
        echo "Vous avez choisi Zsh."
        chsh -s /bin/zsh   # Change le shell par défaut de l'utilisateur en Zsh
        exec zsh
        ;;
    *)
        echo "Choix invalide. Le script se termine."
        ;;
esac
