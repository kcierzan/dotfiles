function httpdump
  sudo tcpdump -i -en1 -s -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""
end
