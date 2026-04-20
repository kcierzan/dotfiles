HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p -- "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000
