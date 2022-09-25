#!/usr/bin/env bash

install_homebrew() {
  /usr/bin/env bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_fisher() {
  fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
}

install_brew_packages() {
  BREW_PREFIX="$(brew --prefix)"
  source ./homebrew_packages.sh
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
    jetbrains-toolbox
    kitty
    logseq
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
  fish_global EDITOR nvim
  fish_global VISUAL nvim
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

  if [ "$(uname)" = 'Darwin' ]; then
    [ ! -L "$TARGET" ] && ln -s "$HOME/.dotfiles/bootstrap/macstrap.sh" "$TARGET"
  else
    [ ! -L "$TARGET" ] && ln -s "$HOME/.dotfiles/bootstrap/archstrap.sh" "$TARGET"
  fi
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
