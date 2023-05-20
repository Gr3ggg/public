#!/bin/bash

if dpkg -s zsh &> /dev/null; then
    read -p "zsh est déjà installé. Voulez-vous le supprimer et le réinstaller ? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo apt remove -y zsh zsh-autosuggestions zsh-syntax-highlighting
    else
        exit 1
    fi
fi

sudo apt install -y zsh zsh-syntax-highlighting zsh-autosuggestions

sudo chsh -s $(which zsh) $USER

rm -f ~/.zshrc


force_color_prompt=yes
autoload -U colors && colors


echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

cat << 'EOF' >> ~/.zshrc



prompt_ipmachine() {
    local ip=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d'/' -f1)
    echo -n "${ip:-N/A}"
}

prompt_ipclient() {
    echo "${SSH_CLIENT%% *}" | awk '{$1=$1};1'
}

setopt PROMPT_SUBST

if [[ $EUID -eq 0 ]]; then
        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{black}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{black}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
else
        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{black}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{black}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
fi

alias l='ls -l'
alias ll='ls -la'
alias la='ls -lA'



EOF

echo "Installation terminée."
exec zsh
