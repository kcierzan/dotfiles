#!/usr/bin/env bash
set -euo pipefail

# Install Git LFS filters into the global git config.

if ! command -v git-lfs >/dev/null 2>&1; then
  echo "git-lfs not found, skipping"
  exit 0
fi

git lfs install
echo "Git LFS initialized"
