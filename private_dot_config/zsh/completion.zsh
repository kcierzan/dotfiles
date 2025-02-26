#!/usr/bin/env zsh

# default lscolors
LS_COLORS=${LS_COLORS:-'di=34:ln=35:so=32:pi=33:ex=31:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}

# initialize completion
autoload -Uz compinit

if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# add hidden files
_comp_options+=(globdots)

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.config/zsh/.zcompcache"
# case-insensitive (all), partial word, and then substring completion
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:upper:]}={[:lower:]}'  'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# set formatting for completion menu tags
zstyle ':completion:*' menu select

zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:*:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{green}-- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d -- %f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''

# fuzzy match mistypes completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# use LS_COLORS for file/directory completion menu items
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


# lazy load completion styles
# zsh-defer load_completion_styles

unsetopt CASE_GLOB

# move the cursor to the end of the word after completion
setopt ALWAYS_TO_END

# perform path search on command names with slashes
setopt PATH_DIRS

# show completion menu on successive tab presses
setopt AUTO_MENU

# automatically list choices on ambiguous completions
setopt AUTO_LIST

# do not autoselect the first completion item
unsetopt MENU_COMPLETE

# disable start/stop characters in shell editor
unsetopt FLOW_CONTROL

# if completion param is a directory, add a trailing slash
setopt AUTO_PARAM_SLASH
