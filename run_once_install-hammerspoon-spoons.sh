#!/usr/bin/env bash
set -euo pipefail

# Only run on macOS — Hammerspoon is Darwin-only
[[ "$(uname)" == "Darwin" ]] || exit 0

# Download Hammerspoon Spoons from GitHub
SPOONS_DIR="$HOME/.hammerspoon/Spoons"
mkdir -p "$SPOONS_DIR"

install_spoon() {
  local name="$1" repo="$2" rev="$3"
  local dest="$SPOONS_DIR/${name}.spoon"

  if [ -d "$dest" ]; then
    echo "$name already installed"
    return
  fi

  echo "Installing $name from $repo..."
  local tmpdir
  tmpdir=$(mktemp -d)
  git clone --depth 1 "https://github.com/${repo}.git" "$tmpdir" 2>/dev/null
  if [ -n "$rev" ]; then
    (cd "$tmpdir" && git fetch --depth 1 origin "$rev" && git checkout "$rev") 2>/dev/null
  fi
  cp -r "$tmpdir" "$dest"
  rm -rf "$tmpdir"
  echo "$name installed"
}

install_spoon "PaperWM" "mogenson/PaperWM.spoon" ""
install_spoon "WarpMouse" "mogenson/WarpMouse.spoon" ""
install_spoon "Swipe" "mogenson/Swipe.spoon" ""

echo "All Spoons installed"
