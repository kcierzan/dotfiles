# Use gnu tools on macOS
alias find='gfind'
alias sed='gsed'
alias grep='ggrep'
alias awk='gawk'
alias tar='gtar'
alias xargs="gxargs"
alias gzip='/usr/local/bin/gzip'

alias b='brew'
alias k='kubectl'
alias kx='kubectx'
alias pst='pbpaste'
alias cpy='pbcopy'

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# Use the ls_extended script
# alias le="ls_extended_macos"
# alias la="ls_extended_macos -lah"
alias le="lsd"
alias la="lsd -lah"
alias lt="lsd -a --tree"

# Change working directory to the top-most Finder window location
cdf() { # short for `cdfinder`
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# fuzzy upgrade brew packages
brewup() {
    brew update && brew outdated | fzf -m -n 1 --tac --header='Select formulae to upgrade' | xargs brew upgrade
}

ctags() {
    version=$(pyenv version | cut -d ' ' -f 1)
    if [ $version != system ]; then
        /usr/local/bin/ctags -R && /usr/local/bin/ctags --append tags -R $(pyenv prefix)
    else
        /usr/local/bin/ctags -R
    fi
}

etags() {
    version=$(pyenv version | cut -d ' ' -f 1)
    if [ $version != system ]; then
        /usr/local/bin/ctags -eR && /usr/local/bin/ctags -e --append tags -R $(pyenv prefix)
    else
        /usr/local/bin/ctags -eR
    fi
}

iterm-emit() {
    local template="\e]${1}\007"
    shift

    if [[ -n "$TMUX" || "$TERM" = tmux* ]]; then
        template="\ePtmux;\e${template}\e\\"
    fi
    printf "$template" "$@"
}

iterm-profile() {
    iterm-emit '1337;SetProfile=%s' "$1"
}
