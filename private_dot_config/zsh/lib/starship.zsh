if (( $+commands[starship] )); then
  # The generated shell integration only changes when the Starship binary does.
  typeset starship_binary=${commands[starship]:A}
  typeset starship_init_cache="${XDG_CACHE_HOME:-$HOME/.cache}/starship/init-v1.zsh"

  if [[ ! -s "$starship_init_cache" || "$starship_binary" -nt "$starship_init_cache" ]]; then
    mkdir -p -- "${starship_init_cache:h}"
    "$starship_binary" init zsh --print-full-init |
      sed "s|^PROMPT2=.*$|PROMPT2='%F{8}∙%f '|" >| "$starship_init_cache"
  fi

  source "$starship_init_cache"
  unset starship_binary starship_init_cache
fi
