# Dotfiles

## macOS Installation

0. Install xcode command line tools

```shell
xcode-select --install
```

1. Install brew

MacOS has ([for now](https://tidbits.com/2019/06/25/apple-to-deprecate-scripting-languages-in-future-versions-of-macos/))
 ruby installed by default. It should be available in the default `$PATH`.

```shell
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2. Clone this repo.

`git` should be installed and in your `$PATH` after successful completion of
`xcode-select --install`.

```shell
git clone https://github.com/kcierzan/dotfiles.git ~/.dotfiles
```

2. Run the installation scripts.

```shell
./install/brew.sh && ./install/cask.sh
```

3. Symlink some dotfiles.

The files in this repo are managed by symlinking the files from ~/.dotfiles to
their proper locations. This is accomplished via [GNU
Stow](https://www.gnu.org/software/stow/). The directories and files
in this repo are constucted such that running:

```shell
stow zsh
```

from this directory will symlink all the `zsh` files where `zsh` expects them.
