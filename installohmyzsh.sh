#!/bin/sh

# script pour Debian et Ubuntu
# copier/coller ds votre Shell: rm -f installohmyzsh.sh && wget https://github.com/Gr3ggg/public/raw/main/installohmyzsh.sh && chmod +x installohmyzsh.sh && ./installohmyzsh.sh

# Vérification des dépendances
echo "Installation des dépendances..."
if [[ $(command -v git) && $(command -v zsh) ]]; then
  echo "Dépendances déjà installées."
else
  echo "Installation des dépendances..."
  sudo apt update
  sudo apt install -y git zsh curl
fi

# Changement du shell par défaut en Zsh
echo "Changement du shell par défaut en Zsh..."
chsh -s $(which zsh)

rm -rf /$HOME/.oh-my-zsh
rm -f ~/.zshrc

# Installation d'Oh My Zsh
echo "Installation d'Oh My Zsh..."
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

rm -rf /$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
rm -rf /$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
rm -f ~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

cat << 'EOF' >> ~/.zshrc


export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gnzh"


# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 10

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

setopt EXTENDED_HISTORY
HISTFILE=/$HOME/.zsh_history
HISTSIZE=999999
SAVEHIST=999999
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes
autoload -U colors && colors

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

# pour debian et ubuntu
#prompt_ipmachine() {
#    local ip=$(ip route | awk '/link src/ {print $9}')
#    echo -n "${ip:-N/A}"
#}
# pour debian
prompt_ipmachine() {
    local ip=$(ip -o -4 addr list eth0 | awk '{print $4}' | cut -d'/' -f1)
    echo -n "${ip:-N/A}"
}

prompt_ipclient() {
    echo "${SSH_CLIENT%% *}" | awk '{$1=$1};1'
}

    #les USERs  en rouge ou vert suivant le user

    if [[ $EUID -eq 0 ]]; then

            PROMPT=$'%F{cyan}╭───────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -[%F{red}$(prompt_ipmachine)%F{cyan}]-[%F{magenta}$(prompt_ipclient)%F{cyan}]- [%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{cyan}]\n╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
    else
            PROMPT=$'%F{cyan}╭───────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -[%F{green}$(prompt_ipmachine)%F{cyan}]-[%F{magenta}$(prompt_ipclient)%F{cyan}]- [%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{cyan}]\n╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
    fi

        #les USERs & crochets en rouge ou vert suivant le user

        #if [[ $EUID -eq 0 ]]; then
        #        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{black}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{magenta}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
        #else
        #        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{black}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{magenta}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
        #fi

              #les USERs & IPs & crochets en rouge ou vert suivant le user

              #if [[ $EUID -eq 0 ]]; then
              #        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{red}[%F{red}$(prompt_ipmachine)%F{red}]%F{cyan}-%F{red}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{red}]%F{cyan}-%F{red}[%F{magenta}$(prompt_ipclient)%F{red}]%F{cyan}- %F{red}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{red}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
              #else
              #        PROMPT=$'%F{cyan}╭──────────────${debian_chroot:+($debian_chroot)──}(%B%(#.%F{red}%n.%F{green}%n)%F{green}@%F{blue}%m%b%F{cyan}) -%F{green}[%F{green}$(prompt_ipmachine)%F{green}]%F{cyan}-%F{green}[%F{magenta}%D{%d/%m/%Y %H:%M:%S}%F{green}]%F{cyan}-%F{green}[%F{magenta}$(prompt_ipclient)%F{green}]%F{cyan}- %F{green}[%B%F{yellow}%(6~.%-1~/…/%4~.%5~)%b%F{green}]\n%F{cyan}╰───%B%(#.%F{red}▶.%F{green}▶)%b%F{reset}'
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

  else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
  fi

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#alias l='ls -l'
#alias ll='ls -Ahl'
#alias la='ls -ahl'

alias upd='apt update'
alias upg='apt upgrade -y'
alias upa='apt update -y && apt upgrade -y && apt autoremove -y'

alias wzsh='rm -f installohmyzsh.sh && wget https://github.com/Gr3ggg/public/raw/main/installohmyzsh.sh && chmod +x installohmyzsh.sh && ./installohmyzsh.sh'

EOF

echo "L'installation de oh-my-zsh est terminée. Veuillez vous déconnecter et vous reconnecter pour utiliser zsh."

# Charger les modifications
exec zsh && source ~/.zshrc

exit 0