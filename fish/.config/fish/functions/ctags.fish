function ctags
  if [ -n $VIRTUAL_ENV ]
    /usr/local/bin/ctags; and /usr/local/bin/ctags --append tags -R (echo -n $VIRTUAL_ENV)
  else
    /usr/local/bin/ctags -R
  end
end
