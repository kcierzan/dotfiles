function fzf-history --description "Search command history. Replace the command line with the selected line"
  builtin history merge 

  set command_with_ts (
    builtin history --null --show-time="%m-%d %H:%M:%S | " |
    fzf --read0 \
      --tiebreak=index \
      --query=(commandline) \
      # preview current command using fish_ident in a window at the bottom 3lines tall
      --preview="echo -- {4..} | fish_indent --ansi" \
      --preview-window="bottom:3:wrap" \
      | string collect
  )

  if test $status -eq 0
    set command_selected (string split --max 1 " | " $command_with_ts)[2]
    commandline --replace -- $command_selected
  end

  commandline --function repaint
end
