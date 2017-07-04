# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
COMPLETION_WAITING_DOTS="true"

# jump around
eval "$(fasd --init auto)"

# Add plugins with zplug instead
plugins=()

# User configuration
DEFAULT_USER="Kyle"

# Enable rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi

# setup oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Load pyenv on shell start
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init - --no-rehash)"; fi

# Load pyenv-virtualenv on start
if which pyenv-virtualenv-init > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

# Enable vi editing mode and show in prompt
function zle-keymap-select {
  VIMODE="${${KEYMAP/vicmd/ M:command}/(main|viins)/}"
  zle reset-prompt
}

zle -N zle-keymap-select
bindkey -v
set show-mode-in-prompt on

# Vi mode breaks uparrow completion. Fix it.
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# Enable changing cursor shapes and blinking
function print_dcs
{
  print -n -- "\EP$1;\E$2\E\\"
}

function set_cursor_shape
{
  if [ -n "$TMUX" ]; then
    # tmux will only forward escape sequences to the terminal if surrounded by
    # a DCS sequence
    print_dcs tmux "\E]50;CursorShape=$1\C-G"
  else
    print -n -- "\E]50;CursorShape=$1\C-G"
  fi
}

function zle-keymap-select zle-line-init
{
  case $KEYMAP in
    vicmd)
      set_cursor_shape 0 # block cursor
      ;;
    viins|main)
      set_cursor_shape 1 # line cursor
      ;;
  esac
  zle reset-prompt
  zle -R
}

function zle-line-finish
{
  set_cursor_shape 0 # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

# fzf initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

POWERLEVEL9K_MODE='nerdfont-complete'

# Run zplug
export ZPLUG_HOME="/usr/local/opt/zplug"
source $ZPLUG_HOME/init.zsh

# ------------ ZPLUG ------------------------
zplug "mafredri/zsh-async",              from:github
zplug "bhilburn/powerlevel9k",           from:github,   use:powerlevel9k.zsh-theme, as:theme
zplug "plugins/pip",                     from:oh-my-zsh
zplug "plugins/colored-man-pages",       from:oh-my-zsh
zplug "unixorn/warhol.plugin.zsh"
zplug "zsh-users/zsh-syntax-highlighting"

zplug load

# Source additional dotfiles
source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.extra
