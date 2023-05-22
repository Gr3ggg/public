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


echo "source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

cat << 'EOF' >> ~/.zshrc

force_color_prompt=yes
autoload -U colors && colors

prompt_ipmachine() {
    local ip=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d'/' -f1)
    echo -n "${ip:-N/A}"
}

prompt_ipclient() {
    echo "${SSH_CLIENT%% *}" | awk '{$1=$1};1'
}

setopt PROMPT_SUBST

#les USER & IP en rouge ou vert suivant le user

if [[ $EUID -eq 0 ]]; then

        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -[%F{red}$(prompt_ipmachine)%F{cyan}]-[%F{black}$(prompt_ipclient)%F{cyan}]- [%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{cyan}]\n╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
else
         PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -[%F{green}$(prompt_ipmachine)%F{cyan}]-[%F{black}$(prompt_ipclient)%F{cyan}]- [%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{cyan}]\n╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
fi



#les USER & crochets en rouge ou vert suivant le user

#if [[ $EUID -eq 0 ]]; then
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{black}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{black}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#else
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{black}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{black}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#fi


#les USER & IP & crochets en rouge ou vert suivant le user

#if [[ $EUID -eq 0 ]]; then
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{red}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{black}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#else
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{green}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{black}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#fi

RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)%F{cyan}[%F{magenta}%D{%d/%m/%Y %H:%M}%F{cyan}]'


    unsetopt ksharrays
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
    ZSH_HIGHLIGHT_STYLES[default]=none
    ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
    ZSH_HIGHLIGHT_STYLES[path]=underline
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
    ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[command-substitution]=none
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[process-substitution]=none
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
    ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
    ZSH_HIGHLIGHT_STYLES[assign]=none
    ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
    ZSH_HIGHLIGHT_STYLES[named-fd]=none
    ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
    ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
    ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout


alias l='ls -l'
alias ll='ls -la'
alias la='ls -lA'



alias upd='apt update'
alias upg='apt upgrade -y'
alias upa='apt update -y && apt upgrade -y && apt autoremove -y'

alias rwzsh='rm install_zsh.sh && wget https://github.com/Gr3ggg/public/raw/main/install_zsh.sh && chmod +x install_zsh.sh'
alias wzsh='wget https://github.com/Gr3ggg/public/raw/main/install_zsh.sh && chmod +x install_zsh.sh'


EOF

echo "Installation terminée."
exec zsh
