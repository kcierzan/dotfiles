# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# Theme that doesn't suck
ZSH_THEME="pure"

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
# DISABLE_AUTO_TITLE="true"

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

# Include fasd for intelligent directory navigation and all sorts of cool fuzzy stuff
eval "$(fasd --init auto)"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vagrant docker pip osx httpie)

# User configuration
DEFAULT_USER="Kyle"

eval "$(rbenv init -)"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='subl --wait'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Pyenv Autocompletion
export PYENV_ROOT=/usr/local/var/pyenv

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias be="bundle exec"
alias j="cd .."
alias la="ls -lah"
alias gs="git status"
alias ga="git add"
alias commit="git commit -m"
alias copy="fc -e -|pbcopy"
function cl(){ cd "$@" && la; }

# Search the colo
#
# function searchcsh () {
#   for domainname in colo.lair int.prd.csh lbl.prd.csh svc.prd.csh int.csh lbl.csh svc.csh int.stg.csh lbl.stg.csh svc.stg.csh int.tst.csh lbl.tst.csh ;
#   do
#     dig -t AXFR $domainname | grep -v ";"
#   done
# }

# Alias GUI emacs app. Runs with --daemon on startup.
alias emacs='/usr/local/Cellar/emacs-plus/25.1/Emacs.app/Contents/MacOS/Emacs'
# Alias gui client to connect to daemon
alias e='f -e /usr/local/Cellar/emacs-plus/25.1/bin/emacsclient -c'
# Alias terminal client to connect to daemon
alias te='f -e /usr/local/Cellar/emacs-plus/25.1/bin/emacsclient -c -t'

#Alias Sublime to subl
alias subl="/usr/local/Caskroom/sublime-text3/3103/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

# bring up a bunch of AWeber VMs for sites or something
alias v-web='vagrant up v-web-public --provision'
alias v-cp='vagrant up v-web-controlpanel --provision'
alias v-ds='vagrant up v-datasource'
alias v-lb='vagrant up v-web-loadbalancer'
alias v-rlb='vagrant reload v-web-loadbalancer'
alias v-up='v-lb; v-ds; v-cp; v-web;'

export HOMEBREW_GITHUB_API_TOKEN="4f1202e0c3c0a1d3b5f12a621dec945116852046"
alias zshconfig="e ~/.zshrc"
alias ohmyzsh="e ~/.oh-my-zsh"
