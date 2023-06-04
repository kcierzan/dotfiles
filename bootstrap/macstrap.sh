#!/usr/bin/env bash
DOTFILES_DIR="$HOME/.dotfiles"

HOMEBREW_PACKAGES=(
  asdf
  bat
  bottom
  broot
  cling
  cmake
  direnv
  fd
  findutils
  fish
  fzf
  gawk
  git
  gnu-tar
  gnu-which
  grep
  gsed
  gzip
  jq
  lazygit
  lsd
  magic-wormhole
  make
  mas
  mosh
  'neovim --HEAD'
  openssh
  postgresql
  rename
  ripgrep
  ruby
  shellcheck
  speedtest-cli
  starship
  stow
  sqlite
  wget
  zoxide
)

source "$HOME/.dotfiles/bootstrap/helpers.sh"

install_homebrew() {
  /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

is_tapped() {
  brew tap | grep -q "$1"
}

install_fisher() {
  fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
}

install_brew_packages() {
  BREW_PREFIX="$(brew --prefix)"
  for pkg in "${HOMEBREW_PACKAGES[@]}"
  do
    [ ! -d "$BREW_PREFIX/Cellar/$(basename "$pkg")" ] \
      && brew install "$pkg" || subtask_inform "Already installed: $pkg"
  done
}

install_casks() {
  BREW_PREFIX="$(brew --prefix)"
  casks=(
    1password
    betterdisplay
    font-caskaydia-cove-nerd-font
    font-iosevka-aile
    font-iosevka-etoile
    font-iosevka-nerd-font
    font-iosevka-comfy
    hyperkey
    iina
    raycast
    rectangle
    scroll-reverser
    obsidian
    wezterm
  )
  for cask in "${casks[@]}"
  do
    [ ! -d "$BREW_PREFIX/Caskroom/$(basename "$cask")" ] \
      && brew install "$cask" || subtask_inform "Already installed: $cask"
  done
}

stow_dot_dirs() {
  dots=(
    fish
    jetbrains
    nvim
    starship
    surfingkeys
    wezterm
  )
  for dot in "${dots[@]}"
  do
    stow "$dot"
  done
}

set_fish_globals() {
  fish_global BAT_THEME base16
  fish_global EDITOR 'nvim'
  fish_global VISUAL 'nvim'
  fish_global STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
  fish_global LANG en_US.UTF-8
  fish_global FZF_PREVIEW_COMMAND 'bat --style=numbers --color=always {}'
  fish_global FZF_COMPLETION_TRIGGER '**'
  fish_global FZF_DEFAULT_OPTS '--color=fg:-1,bg:-1,fg+:4,bg+:-1,header:3,hl:-1,hl+:3,prompt:4,spinner:5,pointer:5,marker:4,info:4'
}

brew_upgrade() {
  brew update
  brew upgrade
  brew cleanup
}

brew_upgrade_outdated_casks() {
  brew outdated --cask --greedy --verbose | grep -v '(latest)' | awk '{print $1}' | xargs brew reinstall --cask
}

create_dot_dirs() {
  dotdirs=(
    "$HOME/.local/bin/"
    "$HOME/.config/fish/fish_functions/"
    )
  for dotdir in "${dotdirs[@]}"
  do
    mkdir -p "$dotdir"
  done
}

symlink_bootstrap_executable() {
  TARGET="$HOME/.local/bin/bootstrap"

  [ ! -L "$TARGET" ] && ln -s "$HOME/.dotfiles/bootstrap/macstrap.sh" "$TARGET"
  return 0
}

pushd "$DOTFILES_DIR" || exit 255

task_inform 'Installing applications'

subtask_exec "Updating macOS" softwareupdate --install --all

[ -z "$(which brew)" ] &&
  subtask_exec 'Installing homebrew' install_homebrew

is_tapped 'homebrew/cask' ||
  subtask_exec 'Tapping cask' brew tap homebrew/cask

is_tapped 'homebrew/cask-versions' ||
  subtask_exec 'Tapping cask versions' brew tap homebrew/cask-versions

is_tapped 'homebrew/cask-fonts' ||
  subtask_exec 'Tapping cask fonts' brew tap homebrew/cask-fonts

is_tapped 'homebrew/services' ||
  subtask_exec 'Tapping cask services' brew tap homebrew/services

subtask_exec 'Installing homebrew packages' install_brew_packages

subtask_exec 'Installing homebrew applications' install_casks

subtask_exec 'Upgrading homebrew packages' brew_upgrade

subtask_exec 'Upgrading outdated casks' brew_upgrade_outdated_casks

task_inform 'Setting up shell'

subtask_exec 'Creating dot directories' create_dot_dirs

subtask_exec 'Symlinking dotfiles' stow_dot_dirs

[ "$SHELL" != "$(brew --prefix)/bin/fish" ] &&
  subtask_exec "Changing $(whoami)'s shell to fish" chsh -s "$(which fish)"

subtask_exec 'Setting fish global variables' set_fish_globals

[ -z "$(fish -c 'fisher -v')" ] &&
  subtask_exec 'Installing fisher' install_fisher

subtask_exec 'Symlinking bootstrap script' symlink_bootstrap_executable

popd || exit 255
