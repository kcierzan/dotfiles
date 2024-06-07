if [[ "$(tty)" = "/dev/tty1" && "$(uname)" = "Linux" ]]; then
    exec Hyprland
fi
