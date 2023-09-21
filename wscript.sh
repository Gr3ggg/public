#!/bin/bash

# script pour Debian
# copier/coller ds votre Shell: cd && rm -f wscript.sh && wget https://raw.githubusercontent.com/Gr3ggg/public/main/wscript.sh && chmod +x wscript.sh && ./wscript.sh


# Déterminer le shell actuel
shell=$(basename "$SHELL")
# Vérifier si l'alias existe déjà
alias_name="wscript"
alias_command="cd && rm -f wscript.sh && wget https://raw.githubusercontent.com/Gr3ggg/public/main/wscript.sh && chmod +x wscript.sh && ./wscript.sh"

if [ "$shell" = "bash" ]; then
    config_file="$HOME/.bashrc"
elif [ "$shell" = "zsh" ]; then
    config_file="$HOME/.zshrc"
else
    echo "Le shell actuel n'est pas pris en charge par ce script."
    exit 1
fi

# Vérifier si la ligne existe déjà dans le fichier de configuration
if ! grep -q "alias $alias_name='$alias_command'" "$config_file"; then
    echo "alias $alias_name='$alias_command'" >> "$config_file"
    echo "Alias ajouté dans le fichier $config_file. Veuillez ouvrir un nouveau terminal pour l'utiliser."
else
    echo "L'alias $alias_name existe déjà dans le fichier $config_file."
fi

declare -A scripts
scripts=(
    ["0"]="##### NON DOCKER #####"  # Ligne vide pour le saut de ligne souhaité
    ["1"]="vm_prepa|https://raw.githubusercontent.com/Gr3ggg/public/main/vm_prepa.sh"
    ["2"]="sshd|https://raw.githubusercontent.com/Gr3ggg/public/main/sshd.sh"
    ["3"]="bashrc|https://raw.githubusercontent.com/Gr3ggg/public/main/bashrc.sh"
    ["4"]="installohmyzsh|https://raw.githubusercontent.com/Gr3ggg/public/main/installohmyzsh.sh"
    ["5"]="choix_du_shell|https://raw.githubusercontent.com/Gr3ggg/public/main/shell.sh"
    ["6"]="unbound|https://raw.githubusercontent.com/Gr3ggg/public/main/unbound.sh"
    ["7"]="wireguard|https://raw.githubusercontent.com/Gr3ggg/public/main/wireguard.sh"
    ["8"]="openvpn|https://raw.githubusercontent.com/Gr3ggg/public/main/opnvpn.sh"
    ["9"]="nginx|https://raw.githubusercontent.com/Gr3ggg/public/main/nginx.sh"
    ["10"]="flarum|https://raw.githubusercontent.com/Gr3ggg/public/main/flarum.sh"

    ["49"]="##### DOCKER #####"  # Ligne vide pour le saut de ligne souhaité
    ["50"]="docker|https://raw.githubusercontent.com/Gr3ggg/public/main/docker.sh"
    ["51"]="it-tools_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/it-tools.sh"
    ["52"]="npm_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/npm.sh"
    ["53"]="mariadb_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/mariadb.sh"
    ["54"]="bookstack_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/bookstack.sh"
    ["55"]="memos_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/memos.sh"
    ["56"]="watchtower_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/watchtower.sh"
    ["57"]="speedtest_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/speedtest.sh"
    ["58"]="wg-easy_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/wg-easy.sh"
    ["59"]="wikijs_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/wikijs.sh"
    ["60"]="nextcloud_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/nextcloud.sh"
    ["61"]="homepage_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/homepage.sh"
    ["62"]="password-pusher_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/password-pusher.sh"
    ["63"]="stirling-pdf_docker|https://raw.githubusercontent.com/Gr3ggg/public/main/stirling-pdf.sh"
)

# Fonction pour exécuter un script depuis une URL
execute_script_from_url() {
    url=$1
    script_content=$(curl -s "$url")
    if [[ $? -eq 0 ]]; then
        # Crée un fichier temporaire pour écrire le contenu du script
        echo "$script_content" > temp_script.sh
        chmod +x temp_script.sh

        # Exécute le script temporaire dans un sous-shell en utilisant bash et redirige la sortie
        bash -c "./temp_script.sh"

        # Supprime le fichier temporaire après l'exécution
        rm temp_script.sh
    else
        echo "Échec de la récupération du script $url."
    fi
}

# Trier les numéros d'option
options_sorted=($(echo "${!scripts[@]}" | tr ' ' '\n' | sort -n))

# Afficher les options disponibles par ordre des numéros
echo "Choisissez une option :"
for option in "${options_sorted[@]}"; do
    IFS='|' read -r nom _ <<< "${scripts[$option]}"
    printf "%-2s -▶ %s\n" "$option" "$nom"
done


# Demander à l'utilisateur de choisir une option
read -p "Entrez le numéro de votre choix (ou appuyez sur Entrée pour quitter) : " choix

# Quitter le script si aucun choix n'est entré
if [[ -z "$choix" ]]; then
    echo "Au revoir!"
    exit 0
fi

# Vérifier si l'option est valide
if [[ -n "${scripts[$choix]}" ]]; then
    IFS='|' read -r nom url <<< "${scripts[$choix]}"
    # Exécuter le script correspondant en utilisant la fonction execute_script_from_url
    echo "Exécution du script $nom..."
    execute_script_from_url "$url"
else
    echo "Option invalide. Au revoir!"
fi
