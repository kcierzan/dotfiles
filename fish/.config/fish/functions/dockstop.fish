function dockstop
  docker ps -a -q | xargs docker stop 2>&1
end
