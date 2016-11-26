#!/usr/bin/env bash

# Install Pynthon and Python libraries using Homebrew.

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

#
brew install python
brew install python3
# Check to see if we have pip, if we do upgrade, if we don't, get it
if test ! $(which pip); then
    echo "Installing pip..."
    python get-pip.py
# Install virtualenv
# Install virtualenvwrapper
# Install pyenv
# Install flake8
# Install flask
