#!/bin/sh

echo "Choisissez un shell :"
echo "1. Bash"
echo "2. Zsh"

read choice

case $choice in
    1)
        echo "Vous avez choisi Bash."
        exec bash
        ;;
    2)
        echo "Vous avez choisi Zsh."
        exec zsh
        ;;
    *)
        echo "Choix invalide. Le script se termine."
        ;;
esac
