function cdp
  set dir (ls ~/git | fzf)

  if [ -d ~/git/$dir ]
    cd ~/git/$dir
  end
end
