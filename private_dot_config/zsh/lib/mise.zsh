if (( $+commands[mise] )); then
  # Don't activate mise if the bootstrap directory exists as the config files
  # in there will set up mise and this will just slow down shell startup
  [[ ! -d "$HOME/.bootstrap" ]] && eval "$(mise activate zsh)"
fi
