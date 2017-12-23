function dockrmi
  docker ps -a -q | xargs docker rm 2>&1
end
