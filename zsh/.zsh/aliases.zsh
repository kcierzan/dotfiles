#          ___                                 __
#   ____ _/ (_)___ _________  _________  _____/ /_
#  / __ `/ / / __ `/ ___/ _ \/ ___/_  / / ___/ __ \
# / /_/ / / / /_/ (__  )  __(__  ) / /_(__  ) / / /
# \__,_/_/_/\__,_/____/\___/____(_)___/____/_/ /_/

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"
alias la='ls -lah'

alias g="git"
alias gs="git status"
alias h="history"
alias j="jobs"

# Kill unattached tmux sessions
alias tkill="tmux ls | grep -v attached | awk '{ print $1 }' | sed 's/://' | cut -d ' ' -f1 | xargs -I {} tmux kill-session -t {}"

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Flush Directory Service cache
alias flush="dscacheutil -flushcache && killall -HUP mDNSResponder"

# View HTTP traffic
alias sniff="sudo ngrep -d 'en1' -t '^(GET|POST) ' 'tcp and port 80'"
alias httpdump="sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

alias https="http --default-scheme=https "

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias vim="nvim"
alias vi="nvim"
alias e="launch-emacs"

# Activate a python virtualenv
alias venv="source env/bin/activate"

# resize tmux windows
alias fit="tmux detach -a"

# Verbose tar.gz compression and expansion
alias tarc="tar -cvzf"
alias tarx="tar -xvzf"

# listen to some music
alias spo="ncmpcpp"

# Stop and remove all docker containers
alias dockstop="docker ps -a -q | xargs docker stop 2>&1"
alias dockrm="docker ps -a -q | xargs docker rm 2>&1"

# tmux
alias ta='tmux attach -t'
alias tad='tmux attach -d -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# Create a new directory and enter it
# Create a relative path to arg1 from ar2
relpath() {
    python -c "import os.path; print os.path.relpath('$1','${2:-$PWD}')";
}

# Determine size of a file or total size of a directory
fs() {
    if du -b /dev/null > /dev/null 2>&1; then
        local arg=-sbh;
    else
        local arg=-sh;
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@";
    else
        du $arg .[^.]* *;
    fi;
}

# Compare original and gzipped file size
gz() {
    local origsize=$(wc -c < "$1");
    local gzipsize=$(gzip -c "$1" | wc -c);
    local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
    printf "orig: %d bytes\n" "$origsize";
    printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Syntax-highlight JSON strings or files
# Usage: `json '{"foo":42}'` or `echo '{"foo":42}' | json`
json() {
    if [ -t 0 ]; then
        python -mjson.tool <<< "$*" | pygmentize -l javascript;
    else # pipe
        python -mjson.tool | pygmentize -l javascript;
    fi;
}

# Run `dig` and display the most useful info
digga() {
    dig +nocmd "$1" any +multiline +noall +answer;
}

# UTF-8-encode a string of Unicode symbols
escape() {
    printf "\\\x%s" $(printf "$@" | xxd -p -c1 -u);
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# Decode \x{ABCD}-style Unicode escape sequences
unidecode() {
    perl -e "binmode(STDOUT, ':utf8'); print \"$@\"";
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# Get a character’s Unicode code point
codepoint() {
    perl -e "use utf8; print sprintf('U+%04X', ord(\"$@\"))";
    # print a newline unless we’re piping the output to another program
    if [ -t 1 ]; then
        echo ""; # newline
    fi;
}

# Recursive filename search and edit
#   - CTRL-o     open with `open` command
#   - CTRL-v     open with vsocde
#   - CTRL-x     prompt for deletion
#   - ENTER      edit with neovim
ff() {
  local out file key
  IFS=$'\n'
  out=($(fzf --exit-0 --expect=ctrl-o,ctrl-x,ctrl-v --preview-window=right:50% --preview '[[ $(file --mime {}) =~ binary ]] &&
                  echo {} is a binary file ||
                  (highlight -O ansi -l {} ||
                  pygmentize -g {} ||
                  cat {}) 2> /dev/null | head -2000'))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
      if [ "$key" = ctrl-o ]; then
          open "$file"
      elif [ "$key" = ctrl-x ]; then
          rm -i "$file"
      elif [ "$key" = ctrl-v ]; then
          code "$file"
      else
          $EDITOR "$file"
      fi
  fi
}

fd() {
    local out dir key
    IFS=$'\n' out="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort --expect=ctrl-o,ctrl-x,ctrl-v,ctrl-e +m)"
    key=$(head -1 <<< "$out")
    dir=$(head -2 <<< "$out" | tail -1)
    if [ -d "$dir" ]; then
        if [ "$key" = ctrl-o ]; then
            open "$dir"
        elif [ "$key" = ctrl-v ]; then
            cd "$dir" && code "$dir"
        elif [ "$key" = ctrl-e ]; then
            $EDITOR "$dir"
        elif [ "$key" = ctrl-x ]; then
            rm -ir "$dir"
        else
            cd "$dir"
        fi
    fi
}

# fuzzy search through git log
flog() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --header "Press CTRL-S to toggle sort" \
      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                 xargs -I % sh -c 'git show --color=always % | head -$LINES'" \
      --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'nvim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
}

# show terminal colors
termcol () {
  for code ({000..255}) print -P -- "$code: %F{$code}Isn't this a fun color?%f"
}

# Color less
cl () {
  pygmentize -g $1 | less -r
}

# display a directory tree in style
tre () {
  exa --group-directories-first --all -T -L $1
}

# benchmark of zsh startup
timeshell() {
  for i in $(seq 1 10); do /usr/bin/time zsh -i -c exit; done
}

pf() {
  fd && ff
}

hdi() {
  howdoi $* -c -n 3
}

redraw-prompt() {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
# zle -N redraw-prompt

# browse files in a new pane
range() {
  tmux split-window -c "#{pane_current_path}" "ranger"
}

# fuzzy sshs into known hosts
sshs() {
  ~/.scripts/sshs -m
}

# fuzzy checkout a git branch
fb() {
  local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" |
            fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    zle && { zle reset-prompt; zle -R }
}



# Recent directory search and edit
#   - CTRL-o    open with `open` command
#   - CTRL-v    cd and open with vscode
#   - CTRL-x    prompt for recursive deletion
#   - ENTER     cd
recentdir() {
    local out dir key
    IFS=$'\n' out="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort --expect=ctrl-o,ctrl-x,ctrl-v,ctrl-e +m)"
    key=$(head -1 <<< "$out")
    dir=$(head -2 <<< "$out" | tail -1)
    if [ -d "$dir" ]; then
        if [ "$key" = ctrl-o ]; then
            open "$dir"
        elif [ "$key" = ctrl-v ]; then
            cd "$dir" && code "$dir"
        elif [ "$key" = ctrl-e ]; then
            cd "$dir" && $EDITOR "$dir"
        elif [ "$key" = ctrl-x ]; then
            rm -ir "$dir"
        else
            cd "$dir"
        fi
    fi
    # zle redraw-prompt
}

# Edit a frecent file
fr() {
  local file out key
  IFS=$'\n'
  out=($(sed '1d' ~/.cache/neomru/file |
         fzf --query="$1" --exit-0  --expect=ctrl-o,ctrl-x,ctrl-v --preview-window=right:50% --preview '[[ $(file --mime {}) =~ binary ]] &&
                   echo {} is a binary file ||
                   (highlight -O ansi -l {} ||
                   pygmentize -g {} ||
                   cat {}) 2> /dev/null | head -2000'))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
      if [ "$key" = ctrl-o ]; then
          open "$file"
      elif [ "$key" = ctrl-x ]; then
          rm -i "$file"
      elif [ "$key" = ctrl-v ]; then
          code "$file"
      else
          $EDITOR "$file"
      fi
  fi
}

findfile() {
  local out file key
  IFS=$'\n'
  out=($(rg ${1:-.} --files --no-ignore --hidden --follow --glob "!.git/*" -g "!*.pyc" 2> /dev/null | fzf +m --exit-0 --expect=ctrl-o,ctrl-x,ctrl-v --preview-window=right:50% --preview '[[ $(file --mime {}) =~ binary ]] &&
                  echo {} is a binary file ||
                  (highlight -O ansi -l {} ||
                  pygmentize -g {} ||
                  cat {}) 2> /dev/null | head -2000'))
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
      if [ "$key" = ctrl-o ]; then
          open "$file"
      elif [ "$key" = ctrl-x ]; then
          rm -i "$file"
      elif [ "$key" = ctrl-v ]; then
          code "$file"
      else
          $EDITOR "$file"
      fi
  fi
}

# fzf based process killer
fkill() {
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        kill -${1:-9} $pid
    fi
}

# set up some macOS specific aliases
if [[ $OSTYPE == 'darwin'* ]]; then
    source ~/.zsh/macos.zsh
fi
