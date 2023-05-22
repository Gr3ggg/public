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

# Créer un nouveau screen
screen_install="mon_screen"
screen -dmS "$screen_install"

# Attacher au screen et exécuter la commande
screen -S "$screen_install" -X stuff "sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" "$(printf \\r)" "

# Attendre 5 minutes
sleep 1m

# Tuer le screen
screen -S "$screen_install" -X quit

rm -rf /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -rf /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
rm -f ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting


cat << 'EOF' >> ~/.zshrc


export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

setopt EXTENDED_HISTORY
HISTFILE=/$HOME/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S"

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi


force_color_prompt=yes
autoload -U colors && colors


prompt_ipmachine() {
    local ip=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d'/' -f1)
    echo -n "${ip:-N/A}"
}

prompt_ipclient() {
    echo "${SSH_CLIENT%% *}" | awk '{$1=$1};1'
}


#les USERs  en rouge ou vert suivant le user

if [[ $EUID -eq 0 ]]; then

        PROMPT=$'%F{cyan}╭───────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -[%F{red}$(prompt_ipmachine)%F{cyan}]-[%F{black}$(prompt_ipclient)%F{cyan}]- [%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{cyan}]\n╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
else
        PROMPT=$'%F{cyan}╭───────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -[%F{green}$(prompt_ipmachine)%F{cyan}]-[%F{black}$(prompt_ipclient)%F{cyan}]- [%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{cyan}]\n╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
fi



#les USERs & crochets en rouge ou vert suivant le user

#if [[ $EUID -eq 0 ]]; then
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{black}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{black}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#else
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{black}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{black}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#fi


#les USERs & IPs & crochets en rouge ou vert suivant le user

#if [[ $EUID -eq 0 ]]; then
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{red}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{black}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#else
#        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{green}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{black}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
#fi

RPROMPT=$'%F{cyan}[%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)%F{cyan}]%F{cyan}[%F{magenta}%D{%d/%m/%Y %H:%M}%F{cyan}]'

    # enable syntax-highlighting
  if [ -f /$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && [ "$color_prompt" = yes ]; then
    # ksharrays breaks the plugin. This is fixed now but let's disable it in the
    # meantime.
    # https://github.com/zsh-users/zsh-syntax-highlighting/pull/689
    . /$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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

#  else
#    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
  fi

#alias l='ls -l'
#alias ll='ls -la'
#alias la='ls -lA'



alias upd='apt update'
alias upg='apt upgrade -y'
alias upa='apt update -y && apt upgrade -y && apt autoremove -y'

alias rwzsh='rm install_ohmyzsh.sh && wget https://github.com/Gr3ggg/public/raw/main/install_ohmyzsh.sh && chmod +x install_ohmyzsh.sh && ./install_ohmyzsh.sh'
alias wzsh='wget https://github.com/Gr3ggg/public/raw/main/install_ohmyzsh.sh && chmod +x install_ohmyzsh.sh && ./install_ohmyzsh.sh'


EOF

echo "L'installation de oh-my-zsh est terminée. Veuillez vous déconnecter et vous reconnecter pour utiliser zsh."

# Charger les installications
exec zsh && source ~/.zshrc
