#                     _____         _____      __  
#   _________  ____  / __(_)___ _  / __(_)____/ /_ 
#  / ___/ __ \/ __ \/ /_/ / __ `/ / /_/ / ___/ __ \
# / /__/ /_/ / / / / __/ / /_/ / / __/ (__  ) / / /
# \___/\____/_/ /_/_/ /_/\__, (_)_/ /_/____/_/ /_/ 
#                       /____/                     

# change iterm2 title bar color
echo -en "\033]6;1;bg;red;brightness;46\a"
echo -en "\033]6;1;bg;green;brightness;52\a"
echo -en "\033]6;1;bg;blue;brightness;64\a"

# set environment variables
source ~/.config/fish/env.fish

set -U fish_cursor_default block
set -U fish_cursor_insert line
set -U fish_cursor_visual underscore
set -U fish_cursor_unknown block
fish_vi_cursor

# don't show vi mode in prompt
function fish_mode_prompt
end

function fish_vi_cursor
end

function fish_greeting
  fortune; and echo ''
end

# try to attach to a tmux session on startup
if test -z $TMUX
    set -x TMUX_SESSION (tmux ls | grep -vm1 attached | cut -d: -f1) # get the id of a deattached session
    if test -z $TMUX_SESSION # if not available create a new one
        tmux new-session
    else
        tmux attach-session -t $TMUX_SESSION # if available attach to it
    end
end

eval (python -m virtualfish)
