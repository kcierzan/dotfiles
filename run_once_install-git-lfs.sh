#!/usr/bin/env bash
set -euo pipefail

# Install Git LFS filters into the global git config.
# Required so that encrypted font .age files (tracked via LFS) are fetched
# as real files rather than LFS pointer stubs on clone.

if ! command -v git-lfs >/dev/null 2>&1; then
  echo "git-lfs not found, skipping"
  exit 0
fi

git lfs install
echo "Git LFS initialized"
