#!/bin/bash

# Install homebrew
[ ! -f /usr/local/bin/brew ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap | grep -q 'universal-ctags' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'mopidy/mopidy' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'crisidev/chunkwm' || brew tap crisidev/homebrew-chunkwm
brew tap | grep -q 'railwaycat/emacsmacport' || brew tap railwaycat/emacsmacport

pkgs=(
asdf
awscli
bat
boxes
cling
cmake
cmatrix
cowsay
ctags
ddate
fasd
fd
figlet
findutils
fish
fortune
fzf
gawk
geoip
git
git-delta
gitui
global
glow
gnu-tar
gnu-which
grep
gzip
highlight
htop
httpie
jq
lsd
luarocks
lynx
make
mosh
neovim
nnn
openssh
pandoc
perl
php
postgresql
prettier
pv
rename
ripgrep
ruby
sassc
shellcheck
speedtest-cli
starship
stow
tree
wget
zoxide
zsh
)
# Install all brew packages
for pkg in "${pkgs[@]}"
do
	[ ! -d /usr/local/Cellar/$(basename $pkg) ] && brew install $pkg || echo "Already installed: $pkg"
done

[ -d /usr/local/Cellar/$(basename mpv) ] && brew linkapps mpv || echo "mpv not installed!"
