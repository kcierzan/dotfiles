#               __
#   ____  _____/ /_  __________
#  /_  / / ___/ __ \/ ___/ ___/
# _ / /_(__  ) / / / /  / /__
#(_)___/____/_/ /_/_/   \___/

source ~/.zsh_config

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

pyenv-virtualenv-init() {
    eval "$( command pyenv virtualenv-init - )"
    pyenv-virtualenv-init "$@"
}

# setup nvm
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
source $ZPLUG_HOME/init.zsh

# ------------ ZPLUG ------------------------
# zplug "bhilburn/powerlevel9k",           from:github,   use:powerlevel9k.zsh-theme, as:theme
zplug "zsh-users/zsh-autosuggestions",   use:zsh-autosuggestions.zsh
zplug "geometry-zsh/geometry"
zplug "unixorn/warhol.plugin.zsh"
zplug "zsh-users/zsh-syntax-highlighting"

zplug load

ZSH_HIGHLIGHT_STYLES[path]=none
# Source additional dotfiles
source ~/.aliases
source ~/.extra

# Maybe load geometry plugins
which geometry_plugin_register &> /dev/null
if [ $? -eq 0 ]; then
  source ~/.tag_plugin
  source ~/.vi_mode_plugin
fi
