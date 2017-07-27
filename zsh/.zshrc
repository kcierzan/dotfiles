#               __
#   ____  _____/ /_  __________
#  /_  / / ___/ __ \/ ___/ ___/
# _ / /_(__  ) / / / /  / /__
#(_)___/____/_/ /_/_/   \___/

# jump around
eval "$(fasd --init auto)"

# Enable rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi

# Load pyenv on shell start
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init - --no-rehash)"; fi

# Load pyenv-virtualenv on start
if which pyenv-virtualenv-init > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

# setup nvm
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

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
