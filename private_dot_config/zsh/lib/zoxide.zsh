if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"

  function _zoxide-zi-widget() {
    zle -I
    local result
    result="$(zoxide query --interactive </dev/tty)" && builtin cd -- "${result}"
    zle reset-prompt
  }
  zle -N _zoxide-zi-widget
  bindkey '^[j' _zoxide-zi-widget
fi
