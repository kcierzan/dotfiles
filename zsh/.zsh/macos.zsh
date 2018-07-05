# Use gnu tools on macOS
alias find='gfind'
alias sed='gsed'
alias grep='ggrep'
alias awk='gawk'
alias tar='gtar'
alias gzip='/usr/local/bin/gzip'

alias bbounce="brew services restart"
alias bstop="brew services stop"
alias bstart="brew services start"

# iTerm2 visor occasionally doesn't like C-l
alias cl='clear'
# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"

alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Lock the screen
alias afk="/usr/bin/open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

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
        /usr/local/bin/ctags && /usr/local/bin/ctags --append tags -R $(pyenv prefix)
    else
        /usr/local/bin/ctags -R
    fi
}

etags() {
    version=$(pyenv version | cut -d ' ' -f 1)
    if [ $version != system ]; then
        /usr/local/bin/ctags -e && /usr/local/bin/ctags -e --append tags -R $(pyenv prefix)
    else
        /usr/local/bin/ctags -eR
    fi
}
