#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
zsh_env=$HOME/.zshenv

# merge in defaults and keymaps

if [ -f "$zsh_env"  ]; then
    source "$zsh_env"
fi

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi


if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# turn off the cheesy graphics card led
nvidia-led no-animation 0

# run keybinding script
# setkeys

# configure the firewire interface and start jack
start-jack

# make the mouse disappear on keystrokes
xbanish&

# start the compositor
picom --experimental-backends &

# start the wm
exec awesome
