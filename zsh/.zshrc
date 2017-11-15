#                __
#    ____  _____/ /_  __________
#   /_  / / ___/ __ \/ ___/ ___/
#  _ / /_(__  ) / / / /  / /__
# (_)___/____/_/ /_/_/   \___/

# Set up zsh completion ASAP
source ~/.zsh/completion.zsh

# Cache fasd init files
fasd_cache="$HOME/.fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# Lazy load rbenv
rbenv() { eval "$( command rbenv init - --no-rehash )" && rbenv "$@" }

# Lazy load pyenv-virtualenv
pyenv-virtualenv-init() {
    eval "$( command pyenv virtualenv-init - )"
    pyenv-virtualenv-init "$@"
}

# Lazy load nvm
nvm() {
    (( $+commands[brew] )) && {
        local pfx=$(brew --prefix)
        [[ -f "$pfx/opt/nvm/nvm.sh" ]] && source "$pfx/opt/nvm/nvm.sh"
        nvm "$@"
  }
}

# Initialize fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Initialize zplug
source $ZPLUG_HOME/init.zsh

# ------------ ZPLUG PLUGINS ------------------------
zplug "zsh-users/zsh-autosuggestions", use:zsh-autosuggestions.zsh
# zplug "geometry-zsh/geometry"
# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zplug "denysdovhan/spaceship-zsh-theme", use:spaceship.zsh, from:github, as:theme
zplug "zsh-users/zsh-syntax-highlighting"
zplug load

# Set variable vi-style cursor 
source ~/.zsh/vi_cursor.zsh

# Don't underline paths in command line
export ZSH_HIGHLIGHT_STYLES[path]=none
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
export ZSH_AUTOSUGGEST_USE_ASYNC='1'

# Source additional dotfiles
source ~/.zsh/aliases.zsh
source ~/.zsh/extra.zsh

# Maybe load geometry prompt plugins
which geometry_plugin_register &> /dev/null
if [ $? -eq 0 ]; then
  source ~/.zsh/tag_plugin.zsh
  source ~/.zsh/vi_mode_plugin.zsh
fi

# Set iTerm2 menu bar color
source ~/.zsh/nord-itermbar.zsh

if [[ -z "$TMUX" ]] ;then
    ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        tmux new-session
    else
        tmux attach-session -t "$ID" # if available attach to it
    fi
fi

