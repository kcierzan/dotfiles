# Dotfiles

## macOS Installation

0. Install Xcode command line tools

```shell
xcode-select --install
```

1. Install brew

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2. Clone this repo.

```shell
git clone https://github.com/kcierzan/dotfiles.git ~/.dotfiles
```

2. Run the installation scripts.

```shell
./install/brew.sh && ./install/cask.sh
```

3. Symlink some dotfiles.

Each directory in this repo is symlinked to the home directory via `stow`.

We only need to pass some directories to `stow`. Like so:

```shell
stow zsh
stow tmux
stow scripts
stow neovim
stow misc
stow ncmpcpp
```
