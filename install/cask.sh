#!/bin/bash

# Setup cask taps
brew tap | grep -q 'homebrew/cask' || brew tap homebrew/cask
brew tap | grep -q 'homebrew/cask-versions' || brew tap homebrew/cask-versions
brew tap | grep -q 'homebrew/cask-fonts' || brew tap homebrew/cask-fonts
brew tap | grep -q 'homebrew/cask-services' || brew tap homebrew/services

casks=(
  1password
  alfred
  docker
  font-inter
  font-roboto
  font-robotomono-nerd-font
  hammerspoon
  jetbrains-toolbox
  karabiner-elements
  kitty
  vagrant
)

# Install all brew casks
for cask in "${casks[@]}"
do
	[ ! -d /usr/local/Caskroom/$(basename $cask) ] && brew install $cask || echo "Already installed: $cask"
done
