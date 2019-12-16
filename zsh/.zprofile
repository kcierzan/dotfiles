# Executes commands at login pre-zshrc.


# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='nvim'
export ALTERNATE_EDITOR=''
export VISUAL='nvim'
export PAGER='bat -p'

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Ensure path arrays do not contain duplicates.
typeset -gu cdpath fpath mailpath path

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# start X on linux
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && [ $OSTYPE = "linux-gnu" ]; then
    exec startx
fi
