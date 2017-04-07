#!/usr/bin/env bash

#          _                  __  
#    _____(_)_______    _____/ /_ 
#   / ___/ / ___/ _ \  / ___/ __ \
#  / /  / / /__/  __/ (__  ) / / /
# /_/  /_/\___/\___(_)____/_/ /_/ 
# Install themes, colors, and packages
                                
# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install oh-my-zsh
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Install spaceship zsh theme
git clone https://github.com/denysdovhan/spaceship-zsh-theme.git /tmp
mv /tmp/spaceship-zsh-theme/spaceship.zsh ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme

# Install base16 shell
# git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

# Install sublime text package control
# cp Package\ Control.sublime-package ~/Library/Application Support/Sublime Text 3/Installed Packages

# Install packages list - packages should be installed on sublime startup
# cp Package\ Control.sublime-settings ~/Library/Application Support/Sublime Text 3/Packages/User

# Install powerline fonts
mkdir ~/powerline-fonts && git clone https://github.com/powerline/fonts.git ~/powerline-fonts

