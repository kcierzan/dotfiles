# Dotfiles

## Installation

Paste the following in the terminal for a complete system bootstrap:

```bash
/usr/bin/env bash -c "$(curl -fsSL 'https://raw.githubusercontent.com/kcierzan/dotfiles/master/bootstrap/init.sh')"
```

This will clone this repository to `~/.dotfiles` and will symlink relevant config directories into `$HOME`.

Subsequent bootstrap runs can performed by running the bootstrap command from any directory:

```
$ bootstrap
```
