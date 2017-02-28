#!/usr/bin/env bash

#     __                             __  
#    / /_  ________ _      __  _____/ /_ 
#   / __ \/ ___/ _ \ | /| / / / ___/ __ \
#  / /_/ / /  /  __/ |/ |/ / (__  ) / / /
# /_.___/_/   \___/|__/|__(_)____/_/ /_/ 
# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

#Install ZSH
brew install zsh
# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
#Add ZSH to the list of shells
sudo bash -c 'echo /usr/local/bin/zsh >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/zsh

# Install more recent versions of some OS X tools.
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install homebrew/x11/xpdf
brew install xz
brew install wireshark
brew install open-mpi

# Install other useful binaries.
brew install ack
brew install dark-mode
# brew install exiv2
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras
brew install hub
brew install imagemagick --with-webp
brew install lua
brew install lynx
brew install p7zip
brew install pigz
brew install pv
brew install rename
brew install speedtest_cli
brew install ssh-copy-id
brew install tree
brew install webkit2png
brew install zopfli
brew install pkg-config libffi
brew install pandoc
brew install the_silver_searcher
brew install neofetch
brew install ddate
brew install fasd
brew install fzf
brew install htop
brew install neovim
brew install httpie
brew install tmux
brew install node
brew install postgresql
brew install pyenv
brew install python
brew install python3
brew install reattach-to-user-namespace
brew install ripgrep
brew install stow

# Install Heroku
brew install heroku-toolbelt
heroku update

# Install Cask
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

# Core casks
brew cask install iterm2

# Development tool casks
brew cask install --appdir="/Applications" virtualbox
brew cask install --appdir="/Applications" vagrant

# Misc casks
brew cask install amethyst
brew cask install alfred
brew cask install blockblock
brew cask install docker
brew cask install dash
brew cask install honer
brew cask install google-chrome
brew cask install pycharm-ce
brew cask install google-drive
brew cask install slack
brew cask install dropbox
brew cask install transmission
brew cask install ubersicht
brew cask install sublime-text
brew cask install pablodraw
brew cask install 1password
brew cask install flux
brew cask install keka
brew cask install vlc
brew cask install spotify

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

# Remove outdated versions from the cellar.
brew cleanup
