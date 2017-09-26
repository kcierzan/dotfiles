#                __
#    ____  _____/ /_  __________
#   /_  / / ___/ __ \/ ___/ ___/
#  _ / /_(__  ) / / / /  / /__
# (_)___/____/_/ /_/_/   \___/

# Set up zsh completion ASAP
source ~/.zsh/completion.zsh

# Lazy load fasd
fasdinit() { eval "$( command fasd --init auto )" }
f() {fasdinit && fasd -f "$@"}
a() {fasdinit && fasd -a "$@"}
s() {fasdinit && fasd -si "$@"}
d() {fasdinit && fasd -d "$@"}
z() {fasdinit && fasd_cd -d "$@"}

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
zplug "zsh-users/zsh-autosuggestions",   use:zsh-autosuggestions.zsh
zplug "geometry-zsh/geometry"
# zplug "unixorn/warhol.plugin.zsh"
zplug "zsh-users/zsh-syntax-highlighting"
zplug load

# Don't underline paths in command line
ZSH_HIGHLIGHT_STYLES[path]=none

# Source additional dotfiles
source ~/.zsh/aliases.zsh
source ~/.zsh/extra.zsh

# Maybe load geometry prompt plugins
which geometry_plugin_register &> /dev/null
if [ $? -eq 0 ]; then
  source ~/.zsh/tag_plugin.zsh
  source ~/.zsh/vi_mode_plugin.zsh
fi

# Set iTerm2 title bar to One Dark background
echo -en "\033]6;1;bg;red;brightness;40\a"
echo -en "\033]6;1;bg;green;brightness;44\a"
echo -en "\033]6;1;bg;blue;brightness;52\a"

# Tmux is fun. We start it on interactive shell
if which tmux >/dev/null 2>&1; then
    # if no session is started, start a new session
    test -z ${TMUX} && tmux

    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
        tmux attach || break
    done
fi
