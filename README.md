# Dotfiles

I like to use quite a few tools for fun and profit. This is my attempt to
gather and manage them which, although being useful for setting up a
development environment, has become something of a zen activity in and of
itself.

The general philosophy here is thus:

* Move fast
* Look good
* Stay modular
* Use the right tool for the job

This setup revolves around macOS, zsh, and a couple very old text editors.
Some day, things will work on Arch Linux.

## From Scratch

1. Install Xcode command line tools.

```Shell
xcode-select --install
```

2. Clone this repo to your home directory.

```Shell
git clone https://github.com/kcierzan/dotfiles.git ~/.dotfiles
```

3. Install brew casks and formulae. (These scripts also install brew if you
don't already have it installed.)

```Shell
./install/brew.sh && ./install/cask.sh
```

4. You should now have GNU Stow installed. Stow will handle symlinking the
folders and files here to your home directory. For example, in order to create
symlinks in your home folder for the included zsh dotfiles, punch in the
following:

```Shell
stow zsh
```

**Notes**: I have tried to make each directory self-contained, however the
included tmux theme depends on a script in the .scripts directory.
