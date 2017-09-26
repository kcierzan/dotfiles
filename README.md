# Dotfiles
I'm a (recovering) dotfile obsessive doing web-y, python-y stuff on macOS.
I like it when stuff works like vi.

If that sounds like you, give some of this stuff a whirl.
Batteries aren't necessarily included.

Also, most of this probably won't work on Linux. Windows is *right out*.

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
./install/brew.sh $$ ./install/cask.sh
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

4. The kitchen sink.

A number of applications I have taken to use plists or proprietary configuration files.
These are a pain because they are often arcane, unreadable, and liable to break on updates.
They are as follows:

#### Alfred
    * Open Alfred -> Advanced -> Set Sync Folder -> ~/.dotfiles/alfred
    * Install [alfred-devdocs](https://github.com/yannickglt/alfred-devdocs) workflow.
    * Install [colors](http://www.packal.org/workflow/colors) workflow.
#### Moom
    * `cp moom/com.manytricks.Moom.plist ~/Library/Preferences/com.manytricks.Moom.plist`.
#### Sublime Text
    * `cp -R sublime/User ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/`.
    * install [package control](https://packagecontrol.io/installation).
#### Pycharm CE
    * Open Pycharm CE > File > Import Settings > select .jar file
    * [This](https://github.com/yurtaev/idea-one-dark-theme) is a good theme...
    * Install ideavim plugin
    * Symlink .ideavimrc with `stow pycharm`.
#### Things
    * Mac app store
#### Bear
    * Mac app store
