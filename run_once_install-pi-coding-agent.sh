#!/usr/bin/env bash
set -euo pipefail

if ! command -v npm &>/dev/null; then
  echo "npm not found, skipping"
  exit 0
fi

npm install -g @mariozechner/pi-coding-agent
