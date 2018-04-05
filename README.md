# Dotfiles

I have used a lot of different tools on my (anti)productivity journey. This repo should
serve as a snapshot of my latest config sensibilities. Some configs are under much more
active development than others.

This collection currently only supports macOS.

Some of the ~~insanity~~ fun includes:

* [zsh](http://zsh.sourceforge.net/)
* [VS Code](https://code.visualstudio.com/)
* [iTerm2](https://iterm2.com/)
* [Emacs](https://www.gnu.org/software/emacs/)
* [Neovim](https://github.com/neovim/neovim)
* [fish](https://fishshell.com/)
* [tmux](https://github.com/tmux/tmux)
* [cVim](https://chrome.google.com/webstore/detail/cvim/ihlenndgcmojhcghmfjfneahoeklbjjh?hl=en)
* [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements)
* [chunkwm](https://github.com/koekeishiya/chunkwm)
* [khd](https://github.com/koekeishiya/khd)

## Installation

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

We're going to symlink our dotfiles to the home directory.
That way everything is under version control and we can do neat things like checkout branches to change a bunch of settings with a single command.
Setting up the symlinks is easy with GNU Stow.

We only need to pass some directories to `stow`. Like so:

```shell
stow zsh
stow tmux
stow scripts
stow neovim
stow misc
stow ncmpcpp
```
