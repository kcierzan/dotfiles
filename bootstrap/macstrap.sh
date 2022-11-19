#!/usr/bin/env bash

THINGS3_APP_STORE_ID=904280696
GLOBAL_RUBY_VERSION='3.0.2'
GLOBAL_PYTHON_VERSION='3.10.5'
DOTFILES_DIR="$HOME/.dotfiles"

HOMEBREW_PACKAGES=(
  asdf
  awscli
  bat
  boxes
  cling
  cmake
  cmatrix
  cowsay
  ctags
  elixir
  elixir-ls
  fd
  figlet
  findutils
  fish
  fortune
  fzf
  gawk
  git
  git-delta
  gitui
  glow
  gnu-tar
  gnu-which
  grep
  gzip
  highlight
  htop
  httpie
  jq
  lsd
  luarocks
  magic-wormhole
  make
  mas
  mosh
  neovim
  nnn
  openssh
  pandoc
  postgresql
  prettier
  pv
  rename
  ripgrep
  ruby
  shellcheck
  sketchybar
  speedtest-cli
  starship
  stow
  wget
  xplr
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
    alfred
    font-iosevka-aile
    font-iosevka-etoile
    font-iosevka-ss08
    google-chrome
    google-drive
    hammerspoon
    iina
    kitty
    neovide
    scroll-reverser
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
    gitui
    hammerspoon
    jetbrains
    kitty
    neovim
    sketchybar
    starship
    surfingkeys
  )
  for dot in "${dots[@]}"
  do
    stow "$dot"
  done
}

bootstrap_neovim() {
  INKD_DIR="$HOME/.inkd/" nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
  INKD_DIR="$HOME/.inkd/" nvim --headless +PackerCompile +qa
}

install_asdf_plugins() {
  plugs=(
    python
    ruby
    julia
  )
  for plug in "${plugs[@]}"
  do
    asdf plugin list | grep -q "$plug" || asdf plugin add "$plug"
  done
}

set_fish_globals() {
  fish_global BAT_THEME base16
  fish_global EDITOR 'neovide --frame buttonless'
  fish_global VISUAL 'neovide --frame buttonless'
  fish_global STARSHIP_CONFIG "$HOME/.config/starship/starship.toml"
  fish_global INKD_DIR "$HOME/.inkd/"
  fish_global LANG en_US.UTF-8
  fish_global FZF_PREVIEW_COMMAND 'bat --style=numbers --color=always {}'
  fish_global FZF_COMPLETION_TRIGGER '**'
  fish_global FZF_DEFAULT_OPTS '--color=fg:-1,bg:-1,fg+:4,bg+:-1,header:3,hl:-1,hl+:3,prompt:4,spinner:5,pointer:5,marker:4,info:4'
}

copy_missing_fonts() {
  for f in fonts/*/*
  do
    [ -f "$HOME/Library/Fonts/$(basename "$f")" ] || cp "$f" "$HOME/Library/Fonts/"
  done
}

brew_upgrade() {
  brew update
  brew upgrade
  brew cleanup
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

install_audio_apps() {
  LOGIC_PRO_APP_STORE_ID=634148309
  brew install ocenaudio
  brew install audio-hijack
  mas install "$LOGIC_PRO_APP_STORE_ID"
}

clone_inkd() {
  git clone 'https://github.com/kcierzan/inkd' "$HOME/git/inkd"
}

build_and_install_inkd() {
  pushd "$HOME/git/inkd" || exit 255
  VERSION="$(grep 's.version' inkd.gemspec | cut -d'=' -f2 | tr -d "'" | xargs)"
  asdf exec gem build inkd.gemspec && asdf exec gem install "inkd-$VERSION.gem"
  popd || exit 255
}

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
    --runtimes)
      RUNTIMES=1
      option_inform 'Installing runtimes!'
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
  RUNTIMES=1
  FONTS=1
  CONFIG_SHELL=1
  EDITORS=1
fi

cd "$DOTFILES_DIR" || exit 255

# --------------------------------------------------------------
if [ -n "$APPS" ]; then
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

  is_tapped 'felixkratz/formulae' ||
    subtask_exec 'Tapping sketchybar' brew tap felixkratz/formulae

  subtask_exec 'Installing homebrew packages' install_brew_packages

  subtask_exec 'Installing homebrew applications' install_casks

  subtask_exec 'Upgrading homebrew packages' brew_upgrade

  [ -z "$(which fennel)" ] && 
    subtask_exec 'Installing fennel' luarocks install fennel

  mas list | grep -q 'Things' ||
    subtask_exec 'Installing Things' mas install "$THINGS3_APP_STORE_ID"
fi

# --------------------------------------------------------------
if [ -n "$CONFIG_SHELL" ]; then
  task_inform 'Setting up shell'

  subtask_exec 'Creating dot directories' create_dot_dirs

  subtask_exec 'Symlinking dotfiles' stow_dot_dirs

  [ -z "$(pgrep -i hammerspoon)" ] &&
    subtask_exec 'Starting hammerspoon' open /Applications/Hammerspoon.app

  [ "$SHELL" != "$(brew --prefix)/bin/fish" ] &&
    subtask_exec "Changing $(whoami)'s shell to fish" chsh -s "$(which fish)"

  subtask_exec 'Setting fish global variables' set_fish_globals

  [ -z "$(fish -c 'fisher -v')" ] &&
    subtask_exec 'Installing fisher' install_fisher

  subtask_exec 'Symlinking bootstrap script' symlink_bootstrap_executable
fi

# --------------------------------------------------------------
if [ -n "$RUNTIMES" ]; then
  task_inform 'Installing runtime support'

  subtask_exec 'Installing asdf plugins' install_asdf_plugins

  asdf list ruby | grep -q $GLOBAL_RUBY_VERSION &&
    subtask_exec "Installing ruby $GLOBAL_RUBY_VERSION" asdf install ruby "$GLOBAL_RUBY_VERSION"

  asdf list python | grep -q $GLOBAL_PYTHON_VERSION &&
    subtask_exec "Installing python $GLOBAL_PYTHON_VERSION" asdf install python "$GLOBAL_PYTHON_VERSION"

  subtask_exec 'Setting global ruby version' asdf global ruby "$GLOBAL_RUBY_VERSION"

  [ -z "$(asdf which bundler)" ] &&
    subtask_exec 'Installing bundler' asdf exec gem install bundler

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
