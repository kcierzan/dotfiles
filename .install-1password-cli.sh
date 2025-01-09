#!/bin/sh

type op >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
  brew install 1password-cli
  ;;
Linux)
  paru -S 1password-cli
  ;;
*)
  echo "unsupported OS"
  exit 1
  ;;
esac
