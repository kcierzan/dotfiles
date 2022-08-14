#!/usr/bin/env bash

THINGS3_APP_STORE_ID=904280696
TARGET_RUBY_VERSION='3.0.2'
TARGET_PYTHON_VERSION='3.10.5'
DOTFILES_DIR="$HOME/.dotfiles"

pushd "$DOTFILES_DIR" 1> /dev/null || exit 255

source bootstrap/helpers.sh
source bootstrap/tasks.sh

[ -z "$(which brew)" ] && subtask_exec "Installing homebrew" install_homebrew

is_tapped 'homebrew/cask' || subtask_exec "Tapping cask" brew tap homebrew/cask
is_tapped 'homebrew/cask-versions' || subtask_exec "Tapping cask versions" brew tap homebrew/cask-versions
is_tapped 'homebrew/cask-fonts' || subtask_exec "Tapping cask fonts" brew tap homebrew/cask-fonts
is_tapped 'homebrew/services' || subtask_exec "Tapping cask services" brew tap homebrew/services

# --------------------------------------------------------------
task_inform 'Installing applications'

subtask_exec 'Installing homebrew packages' install_brew_packages

subtask_exec 'Installing homebrew applications' install_casks

subtask_exec 'Upgrading homebrew packages' brew_upgrade

[ -z "$(which fennel)" ] && subtask_exec 'Installing fennel' luarocks install fennel

mas list | grep -q 'Things' || subtask_exec 'Installing Things' mas install "$THINGS3_APP_STORE_ID"

# TODO: install logic pro when --personal flag is set

# --------------------------------------------------------------
task_inform 'Setting up environment'

subtask_exec 'Symlinking dotfiles' stow_dot_dirs

[ "$SHELL" != "$(brew --prefix)/bin/fish" ] && subtask_exec "Changing $(whoami)'s shell to fish" chsh -s "$(which fish)"

subtask_exec "Setting fish global variables" set_fish_globals

[ -z "$(fish -c 'fisher -v')" ] && subtask_exec 'Installing fisher' install_fisher

[ ! -d ~/.inkd/ ] && subtask_exec "Bootstrapping inkd" bootstrap_inkd

subtask_exec "Installing asdf plugins" install_asdf_plugins

asdf list ruby | grep -q $TARGET_RUBY_VERSION && subtask_exec "Installing ruby $TARGET_RUBY_VERSION" asdf install ruby "$TARGET_RUBY_VERSION"
asdf list python | grep -q $TARGET_PYTHON_VERSION && subtask_exec "Installing python $TARGET_PYTHON_VERSION" asdf install python "$TARGET_PYTHON_VERSION"

subtask_exec "Setting global ruby version" asdf global ruby "$TARGET_RUBY_VERSION"

[ -z "$(asdf which bundler)" ] && subtask_exec "Installing bundler" asdf exec gem install bundler

subtask_exec "Setting global python version" asdf global python "$TARGET_PYTHON_VERSION"

# --------------------------------------------------------------
task_inform "Configuring applications"

subtask_exec 'Bootstrapping neovim' bootstrap_neovim

# TODO: set up alfred

# --------------------------------------------------------------
task_inform "Copying files"

subtask_exec "Copying fonts" copy_missing_fonts
