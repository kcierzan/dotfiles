#!/usr/bin/env bash
set -euo pipefail

# Download zjstatus plugin for zellij
PLUGIN_DIR="$HOME/.config/zellij/plugins"
mkdir -p "$PLUGIN_DIR"

ZJSTATUS_URL="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm"
ZJSTATUS_PATH="$PLUGIN_DIR/zjstatus.wasm"

if [ ! -f "$ZJSTATUS_PATH" ]; then
  echo "Downloading zjstatus plugin..."
  curl -fsSL "$ZJSTATUS_URL" -o "$ZJSTATUS_PATH"
  echo "zjstatus installed to $ZJSTATUS_PATH"
else
  echo "zjstatus already installed"
fi
