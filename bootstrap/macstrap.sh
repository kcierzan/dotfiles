#!/usr/bin/env bash

THINGS3_APP_STORE_ID=904280696
GLOBAL_RUBY_VERSION='3.0.2'
GLOBAL_PYTHON_VERSION='3.10.5'
DOTFILES_DIR="$HOME/.dotfiles"

source bootstrap/helpers.sh
source bootstrap/tasks.sh

for arg in "$@"
do
  case "$arg" in
    --audio)
      AUDIO=1
      option_inform 'Installing audio applications!'
      ;;
    --apps)
      APPS=1
      option_inform 'Installing applications!'
      ;;
    --asdf)
      ASDF=1
      option_inform 'Installing asdf runtimes!'
      ;;
    --editors)
      EDITORS=1
      option_inform 'Bootstrapping editors!'
      ;;
    --fonts)
      FONTS=1
      option_inform 'Installing missing fonts!'
      ;;
    --shell)
      CONFIG_SHELL=1
      option_inform 'Configuring shell!'
      ;;
    *)
      echo "Invalid option: $arg"
      exit 255
      ;;
  esac 
done

if [ $# -eq 0 ]; then
  APPS=1
  ASDF=1
  FONTS=1
  CONFIG_SHELL=1
  EDITORS=1
fi

pushd "$DOTFILES_DIR" 1> /dev/null || exit 255

# --------------------------------------------------------------
if [ -n "$APPS" ]; then
  task_inform 'Installing applications'

  [ -z "$(which brew)" ] && subtask_exec 'Installing homebrew' install_homebrew

  is_tapped 'homebrew/cask' || subtask_exec 'Tapping cask' brew tap homebrew/cask
  is_tapped 'homebrew/cask-versions' || subtask_exec 'Tapping cask versions' brew tap homebrew/cask-versions
  is_tapped 'homebrew/cask-fonts' || subtask_exec 'Tapping cask fonts' brew tap homebrew/cask-fonts
  is_tapped 'homebrew/services' || subtask_exec 'Tapping cask services' brew tap homebrew/services

  subtask_exec 'Installing homebrew packages' install_brew_packages

  subtask_exec 'Installing homebrew applications' install_casks

  subtask_exec 'Upgrading homebrew packages' brew_upgrade

  [ -z "$(which fennel)" ] && subtask_exec 'Installing fennel' luarocks install fennel

  mas list | grep -q 'Things' || subtask_exec 'Installing Things' mas install "$THINGS3_APP_STORE_ID"

  subtask_exec "Updating macOS" softwareupdate --install --all
fi

# --------------------------------------------------------------
if [ -n "$CONFIG_SHELL" ]; then
  task_inform 'Setting up shell'

  subtask_exec 'Creating dot directories' create_dot_dirs

  subtask_exec 'Symlinking dotfiles' stow_dot_dirs

  [ -z "$(pgrep -i hammerspoon)" ] && subtask_exec 'Starting hammerspoon' open /Applications/Hammerspoon.app

  [ "$SHELL" != "$(brew --prefix)/bin/fish" ] && subtask_exec "Changing $(whoami)'s shell to fish" chsh -s "$(which fish)"

  subtask_exec 'Setting fish global variables' set_fish_globals

  [ -z "$(fish -c 'fisher -v')" ] && subtask_exec 'Installing fisher' install_fisher

  subtask_exec 'Symlinking bootstrap script' symlink_bootstrap_executable
  
fi

# --------------------------------------------------------------
if [ -n "$ASDF" ]; then
  task_inform 'Installing language support'

  subtask_exec 'Installing asdf plugins' install_asdf_plugins

  asdf list ruby | grep -q $GLOBAL_RUBY_VERSION && subtask_exec "Installing ruby $GLOBAL_RUBY_VERSION" asdf install ruby "$GLOBAL_RUBY_VERSION"
  asdf list python | grep -q $GLOBAL_PYTHON_VERSION && subtask_exec "Installing python $GLOBAL_PYTHON_VERSION" asdf install python "$GLOBAL_PYTHON_VERSION"

  subtask_exec 'Setting global ruby version' asdf global ruby "$GLOBAL_RUBY_VERSION"

  [ -z "$(asdf which bundler)" ] && subtask_exec 'Installing bundler' asdf exec gem install bundler

  if [ ! -d ~/.inkd/ ]; then
    [ ! -d ~/git/inkd/ ] &&
      subtask_exec 'Cloning inkd' clone_inkd &&
      subtask_exec 'Building inkd' build_and_install_inkd
    subtask_exec 'Setting theme to one dark' asdf exec ink color one dark
  fi

  subtask_exec 'Setting global python version' asdf global python "$GLOBAL_PYTHON_VERSION"
fi

# --------------------------------------------------------------
if [ -n "$EDITORS" ]; then
  task_inform 'Configuring editors'
  subtask_exec 'Bootstrapping neovim' bootstrap_neovim
fi

# --------------------------------------------------------------
if [ -n "$FONTS" ]; then
  task_inform 'Installing fonts'
  subtask_exec 'Copying missing fonts' copy_missing_fonts
fi

# --------------------------------------------------------------
if [ -n "$AUDIO" ]; then
  task_inform 'Bootstrapping audio environment'
  subtask_exec 'Installing applications' install_audio_apps
fi
