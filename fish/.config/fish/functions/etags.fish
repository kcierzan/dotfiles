function etags
  if [ -n $VIRTUAL_ENV ]
    /usr/local/bin/ctags -e; and /usr/local/bin/ctags -e --append tags -R (echo -n $VIRTUAL_ENV)
  else
    /usr/local/bin/ctags -eR
  end
end
