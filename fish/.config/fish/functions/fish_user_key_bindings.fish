function fish_user_key_bindings
  fish_vi_key_bindings
  bind -M insert \cu forward-char
  bind -M insert \cr history-search-forward
  bind -M insert \cp up-or-search
  bind -M insert \cn down-or-search
  bind -M insert -m default jk backward-char force-repaint
  bind -M insert -m default kj backward-char force-repaint
end

