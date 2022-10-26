#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"

eval "$(curl -fsSL 'https://raw.githubusercontent.com/kcierzan/dotfiles/master/bootstrap/helpers.sh')"

task_inform "Bootstrapping developer tools"

clone_dotfiles() {
  [ ! -d "$DOTFILES_DIR" ] && subtask_exec "Cloning dotfiles repository" git clone 'https://github.com/kcierzan/dotfiles' "$DOTFILES_DIR"
  cd "$DOTFILES_DIR" || exit 255
}

[ ! -d "$(xcode-select -p)" ] && subtask_exec "Installing developer tools" xcode-select --install
clone_dotfiles
source bootstrap/macstrap.sh
