#!/usr/bin/env bash
DOTFILES_DIR="$HOME/.dotfiles"

eval "$(curl 'https://raw.githubusercontent.com/kcierzan/dotfiles/master/bootstrap/helpers.sh')"
eval "$(curl 'https://raw.githubusercontent.com/kcierzan/dotfiles/master/bootstrap/tasks.sh')"

task_inform "Bootstrapping developer tools"

clone_dotfiles() {
  [ ! -d "$DOTFILES_DIR" ] && subtask_exec "Cloning dotfiles repository" git clone 'https://github.com/kcierzan/dotfiles' "$DOTFILES_DIR"
  pushd "$DOTFILES_DIR" || exit 255
}

if [ "$(uname)" = 'Darwin' ]; 
then
  [ ! -d "$(xcode-select -p)" ] && subtask_exec "Installing developer tools" xcode-select --install
  clone_dotfiles
  source bootstrap/macstrap.sh
else 
  [ -z "$(which git)" ] && subtask_exec "Installing git" pacman -S git
  clone_dotfiles
  source bootstrap/archstrap.sh
fi
