function fh
  commandline (history | cat | fzf +s | gsed 's/ *[0-9]* *//')
end
