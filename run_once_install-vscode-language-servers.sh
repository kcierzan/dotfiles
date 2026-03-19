#!/usr/bin/env bash
set -euo pipefail

if ! command -v npm &>/dev/null; then
  echo "npm not found, skipping"
  exit 0
fi

if [[ "$(uname)" == "Linux" ]]; then
  sudo npm install -g vscode-langservers-extracted
else
  npm install -g vscode-langservers-extracted
fi
