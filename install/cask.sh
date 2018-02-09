#!/bin/bash

# Setup cask taps
brew tap | grep -q 'caskroom/cask' || brew tap caskroom/cask
brew tap | grep -q 'caskroom/versions' || brew tap caskroom/versions
brew tap | grep -q 'caskroom/fonts' || brew tap caskroom/fonts

casks=(
  1password
  alfred
  docker
  firefoxnightly
  flux
  font-fantasquesansmono-nerd-font
  font-fira-sans
  font-firacode-nerd-font
  font-hack-nerd-font
  font-inconsolata-nerd-font
  font-iosevka
  font-iosevka-nerd-font
  font-lekton-nerd-font
  font-merriweather
  font-monoid-nerd-font
  font-mononoki-nerd-font
  font-mplus-nerd-font
  font-profont-nerd-font
  font-roboto
  font-roboto-condensed
  font-robotomono-nerd-font
  font-sharetechmono-nerd-font
  fontforge
  google-drive
  handbrake
  iterm2-nightly
  karabiner-elements
  moom
  transmission
  vagrant
  vagrant-manager
  virtualbox
  xquartz
)

# Install all brew casks
for cask in "${casks[@]}"
do
	[ ! -d /usr/local/Caskroom/$(basename $cask) ] && brew cask install $cask || echo "Already installed: $cask"
done
