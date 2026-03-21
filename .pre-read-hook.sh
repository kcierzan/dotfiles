#!/usr/bin/env bash
# Pre-read-source-state hook. Runs before chezmoi reads the source directory,
# so it can fix up anything that would cause source state parsing to fail.

# --- 1. Check that 1Password CLI is available ---
if ! type op >/dev/null 2>&1; then
  echo "ERROR: 1Password CLI (op) is required but not installed." >&2
  echo "  macOS:      brew install 1password-cli && op signin" >&2
  echo "  Arch Linux: paru -S 1password-cli && op signin" >&2
  exit 1
fi

# --- 2. Ensure Git LFS objects are fetched ---
# If the repo was cloned without git-lfs installed, .age font files will be
# LFS pointer stubs. Detect this and fetch/checkout the real content so
# chezmoi can decrypt them.
CHEZMOI_SOURCE="${HOME}/.local/share/chezmoi"
if command -v git-lfs >/dev/null 2>&1; then
  # Check if any .age file looks like an LFS pointer
  lfs_pointer=$(find "$CHEZMOI_SOURCE" -name "*.age" -exec head -c 40 {} \; -quit 2>/dev/null)
  if [[ "$lfs_pointer" == version\ https://git-lfs* ]]; then
    echo "Detected LFS pointer stubs in .age files, fetching LFS objects..." >&2
    git -C "$CHEZMOI_SOURCE" lfs install
    git -C "$CHEZMOI_SOURCE" lfs fetch
    git -C "$CHEZMOI_SOURCE" lfs checkout
  fi
fi
