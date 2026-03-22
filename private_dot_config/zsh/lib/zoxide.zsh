if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"

  function _zoxide-zi-widget() {
    zle -I
    zi
    zle reset-prompt
  }

  zle -N _zoxide-zi-widget
  bindkey '^[j' _zoxide-zi-widget
fi
