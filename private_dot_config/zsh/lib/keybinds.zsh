  bindkey -e  # use emacs keybinds

  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word
  bindkey '^[[Z' reverse-menu-complete
  bindkey '^P' history-substring-search-up
  bindkey '^N' history-substring-search-down

  autoload -Uz edit-command-line
  zle -N edit-command-line
  bindkey '^[m' edit-command-line

  bindkey '^[p' fuzzy-find-files-widget   # Alt-p: fuzzy find files
  bindkey '^[g' fuzzy-grep-files-widget   # Alt-g: fuzzy grep
  bindkey '^[v' lazygit-widget            # Alt-v: lazygit

  zle -N _zoxide-zi-widget
  bindkey '^[j' _zoxide-zi-widget

  # Rationalise dot — typing ... expands to ../.. inline
  function rationalise-dot() {
    local MATCH MBEGIN MEND
    if [[ $LBUFFER =~ '(^|/| |	)\.\.$' ]]; then
      LBUFFER+='/..'
    else
      zle self-insert
    fi
  }
  zle -N rationalise-dot
  bindkey '.' rationalise-dot
  bindkey -M isearch '.' self-insert
