#!/bin/bash

# Install homebrew
[ ! -f /usr/local/bin/brew ] && ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap | grep -q 'universal-ctags' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'mopidy/mopidy' || brew tap universal-ctags/universal-ctags
brew tap | grep -q 'crisidev/chunkwm' || brew tap crisidev/homebrew-chunkwm
brew tap | grep -q 'railwaycat/emacsmacport' || brew tap railwaycat/emacsmacport

pkgs=(
 "emacs-mac --with-official-icon --with-gnutls --with-imagemagick --with-no-title-bars"
 "ffmpeg --with-rtmpdump --with-openssl --with-libass --with-libbs2b --with-rubberband"
 "koekeishiya/formulae/khd"
 "libass --without-harfbuzz"
 "mpv --with-vapoursynth --with-libarchive --with-bundle"
 "universal-ctags --HEAD"
 ansiweather
 bash
 bat
 boxes
 ccat
 coreutils
 curl
 ddate
 fasd
 ffms2
 figlet
 findutils
 fontforge
 fortune
 fzf
 gawk
 gcc
 git
 gmime
 gnu-sed
 gnu-tar
 gnu-which
 gnutls
 gpg-agent
 gpgme
 grc
 ggrep
 gzip
 htop
 httpie
 hub
 jq
 less
 mpc
 mpd
 neovim
 ngrep
 node
 nvm
 pv
 pyenv
 pyenv-virtualenv
 python
 python3
 ranger
 rbenv
 readline
 ripgrep
 rsync
 ruby
 sqlite
 ssh-copy-id
 stow
 tcpdump
 tmux
 weechat
 xz
 youtube-dl
 zplug
 zsh
)
# Install all brew packages
for pkg in "${pkgs[@]}"
do
	[ ! -d /usr/local/Cellar/$(basename $pkg) ] && brew install $pkg || echo "Already installed: $pkg"
done

[ -d /usr/local/Cellar/$(basename mpv) ] && brew linkapps mpv || echo "mpv not installed!"
