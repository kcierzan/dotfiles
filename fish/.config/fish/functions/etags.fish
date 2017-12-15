function etags
  set -l version (pyenv version | cut -d ' ' -f 1)
  if [ $version != system ]
    /usr/local/bin/ctags -e; and /usr/local/bin/ctags -e --append tags -R (pyenv prefix)
  else
    /usr/local/bin/ctags -eR
  end
end
