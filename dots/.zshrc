# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Clean themes are best themes
# ZSH_THEME="yutani"

# Uncomment the following line to use case-sensitive completion.
#
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Include fasd for all the dank jumping
eval "$(fasd --init auto)"

# Correct previous console commands
# eval "$(thefuck --alias)"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(fasd git docker pip osx httpie tmux zsh-syntax-highlighting colored-man-pages thefuck)
plugins=()

# User configuration
DEFAULT_USER="Kyle"

if which rbenv > /dev/null; then eval "$(rbenv init - --no-rehash)"; fi
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Disable path highlighting

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Load pyenv on shell start
if which pyenv > /dev/null 2>&1; then eval "$(pyenv init - --no-rehash)"; fi

# Load pyenv-virtualenv on start
if which pyenv-virtualenv-init > /dev/null 2>&1; then eval "$(pyenv virtualenv-init -)"; fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# fzf initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Base16 shell colors
# BASE16_SHELL=$HOME/.config/base16-shell/
# [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

POWERLEVEL9K_MODE='nerdfont-complete'

# Run zplug
export ZPLUG_HOME="/usr/local/opt/zplug"
source $ZPLUG_HOME/init.zsh

# ------------ ZPLUG ------------------------
zplug "mafredri/zsh-async",              from:github
zplug "bhilburn/powerlevel9k",           from:github,   use:powerlevel9k.zsh-theme, as:theme
# zplug "plugins/fasd",                    from:oh-my-zsh
# zplug "plugins/osx",                     from:oh-my-zsh
zplug "plugins/pip",                     from:oh-my-zsh
# zplug "plugins/httpie",                  from:oh-my-zsh
# zplug "plugins/tmux",                    from:oh-my-zsh
zplug "plugins/colored-man-pages",       from:oh-my-zsh
# zplug "plugins/thefuck",                 from:oh-my-zsh
zplug "unixorn/warhol.plugin.zsh"
zplug "zsh-users/zsh-syntax-highlighting"

zplug load

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

# Source additional dotfiles
source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.extra
