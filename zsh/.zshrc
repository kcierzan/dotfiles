#               __
#   ____  _____/ /_  __________
#  /_  / / ___/ __ \/ ___/ ___/
# _ / /_(__  ) / / / /  / /__
#(_)___/____/_/ /_/_/   \___/

# jump around
f() {
    eval "$( command fasd --init auto )"
    fasd -f "$@"
}
a() {
    eval "$( command fasd --init auto )"
    fasd -a "$@"
}
s() {
    eval "$( command fasd --init auto )"
    fasd -si "$@"
}
d() {
    eval "$( command fasd --init auto )"
    fasd -d "$@"
}
z() {
    eval "$( command fasd --init auto )"
    fasd_cd -d "$@"
}

# Enable rbenv
rbenv() {
    eval "$( command rbenv init - --no-rehash )"
    rbenv "$@"
}

# Load pyenv on shell start
pyenv() {
    eval "$(command pyenv init - --no-rehash)"
    pyenv "$@"
}

# Load pyenv-virtualenv on start
# if which pyenv-virtualenv-init > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

pyenv-virtualenv-init() {
    eval "$( command pyenv virtualenv-init - )"
    pyenv-virtualenv-init "$@"
}

# setup nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
    (( $+commands[brew] )) && {
        local pfx=$(brew --prefix)
        [[ -f "$pfx/opt/nvm/nvm.sh" ]] && source "$pfx/opt/nvm/nvm.sh"
        nvm "$@"
  }
}

# fzf initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

POWERLEVEL9K_MODE='nerdfont-complete'

# Run zplug
export ZPLUG_HOME="/usr/local/opt/zplug"
source $ZPLUG_HOME/init.zsh

# ------------ ZPLUG ------------------------
zplug "bhilburn/powerlevel9k",           from:github,   use:powerlevel9k.zsh-theme, as:theme
zplug "unixorn/warhol.plugin.zsh"
zplug "zsh-users/zsh-autosuggestions",   use:zsh-autosuggestions.zsh
zplug "zsh-users/zsh-syntax-highlighting"

zplug load

# Source additional dotfiles
source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.extra
source ~/.config.zsh
