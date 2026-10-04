export LS_COLORS="$(vivid generate "$HOME/.config/vivid/themes/base16.yml")"

theme-switch() {
  command theme-switch "$@" || return
  export LS_COLORS="$(vivid generate "$HOME/.config/vivid/themes/base16.yml")"
}
