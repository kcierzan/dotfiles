function ctags
  set -l version (pyenv version | cut -d ' ' -f 1)
  if [ $version != system ]
    /usr/local/bin/ctags; and /usr/local/bin/ctags --append tags -R (pyenv prefix)
  else
    /usr/local/bin/ctags -R
  end
end
