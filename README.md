# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Supports macOS (primary) and Arch Linux.

## What's included

- Shell configs: `bash`, `fish`, `nushell`
- Editor: `neovim`, `zed`
- Terminal: `ghostty`, `zellij`
- CLI tools: `fzf`, `ripgrep`, `lazygit`, `yazi`, `starship`, `atuin`, `television`, `zoxide`, `bat`, `eza`, and more
- macOS: Hammerspoon, LinearMouse, Raycast, system defaults
- Package management via `brew bundle` (macOS) or `paru` (Arch)
- A theming system that propagates a single color scheme across all managed apps

---

## Fresh machine setup

### 1. Prerequisites

On a brand new machine, you need `chezmoi` and `git` before anything else.

**macOS:**
```sh
# Install Xcode command line tools (provides git)
xcode-select --install

# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"
```

**Arch Linux:**
```sh
pacman -S chezmoi git
```

### 2. Install Git LFS

Encrypted font files are tracked with Git LFS. It must be installed **before** `chezmoi init` so the clone smudges LFS pointers into real files.

**macOS:**
```sh
brew install git-lfs
git lfs install
```

**Arch Linux:**
```sh
pacman -S git-lfs
git lfs install
```

### 3. Install 1Password CLI

Secrets are pulled from 1Password at apply time. Install the CLI before initializing chezmoi so the pre-read hook can run.

**macOS:**
```sh
brew install 1password-cli
# Then sign in:
op signin
```

**Arch Linux:**
```sh
paru -S 1password-cli
op signin
```

### 4. Initialize and apply

```sh
chezmoi init --apply https://github.com/kcierzan/dotfiles.git
```

This will:
1. Clone the repo to `~/.local/share/chezmoi`
2. Fetch the **age private key** from 1Password automatically (no passphrase prompt — see [Encryption](#encryption))
3. On macOS, install Homebrew if missing
4. Run `brew bundle` to install all packages
5. Apply all dotfiles and run one-time setup scripts

> **Note:** The full apply can take a while on a fresh machine — Homebrew and all packages need to install first.

---

## Encryption

Sensitive files (shell secrets, fonts) are encrypted with [age](https://age-encryption.org) and committed to the repo as `.age` files.

### How it works

This repo uses **asymmetric age encryption**:

- An age keypair is generated once: `age-keygen`. The **public key** (recipient) lives in `~/.config/chezmoi/chezmoi.toml`. The **private key** lives only in 1Password — it is never committed to the repo.
- On first apply, `run_once_before_decrypt-private-key.sh.tmpl` fetches the private key from 1Password (`op://personal/chezmoi-age-key/password`) and writes it to `~/.config/chezmoi/chezmoi-key.txt` (mode `600`).
- All subsequent decryption happens automatically using that key. No passphrase is ever prompted.

This means the repo can be public without enabling offline attacks: there is no key material in the repo at all, only ciphertext and a public key.

### Bootstrap a new machine

The key prerequisite is that the 1Password CLI is authenticated **before** `chezmoi init` runs:

```sh
# 1. Install 1Password CLI
brew install 1password-cli   # macOS
# paru -S 1password-cli      # Arch

# 2. Sign in — this must succeed before chezmoi init
op signin

# 3. chezmoi fetches the age key automatically, then applies everything
chezmoi init --apply https://github.com/kcierzan/dotfiles.git
```

If `op` is not signed in when chezmoi runs, the bootstrap script exits with a clear error.

### Storing the private key in 1Password

The private key must exist at `op://personal/chezmoi-age-key/private-key` before bootstrapping a new machine. To store it:

```sh
# View your existing private key
cat ~/.config/chezmoi/chezmoi-key.txt

# In 1Password: create a new item called "chezmoi-age-key" in your Personal vault.
# The default "password" field should contain only the AGE-SECRET-KEY-... line.
```

### Adding a new encrypted file

```sh
# Encrypt and add a file
chezmoi add --encrypt ~/path/to/secret-file

# Edit an already-encrypted file
chezmoi edit ~/.bash_secrets
```

### Rotating the key

1. Generate a new age key: `age-keygen -o ~/.config/chezmoi/chezmoi-key.txt`
2. Update `recipient` in `~/.config/chezmoi/chezmoi.toml` with the new public key printed by `age-keygen`.
3. Re-encrypt all `.age` secrets: for each file, run `chezmoi edit <target>` (chezmoi re-encrypts with the new recipient on save) or manually: `chezmoi decrypt <src.age> | chezmoi encrypt > <new-src.age>`.
4. Update the stored private key in 1Password.
5. Push the updated `.age` files and `chezmoi.toml` recipient.

---

## Theming

A single value in `.chezmoidata/theme.yaml` controls the color scheme across all managed apps (Ghostty, Neovim, Zellij, Starship, bat, etc.):

```yaml
theme: doom-xcode
```

To switch themes, edit that file and run `chezmoi apply`. Available themes are defined in `.chezmoidata/themes.yaml`.

---

## Day-to-day usage

```sh
# Pull latest changes and apply
chezmoi update

# Edit a managed file
chezmoi edit ~/.bashrc

# See what would change before applying
chezmoi diff

# Apply changes
chezmoi apply
```

## Directory structure

```
.chezmoidata/        # Template data (packages, themes)
dot_*                # Dotfiles mapped to ~/.*
private_dot_config/  # ~/.config/* (mode 700)
private_dot_local/   # ~/.local/* (scripts, fonts, bins)
encrypted_*.age      # Age-encrypted secrets
run_once_*           # Scripts that run once on first apply
run_onchange_*       # Scripts that re-run when their content changes
```
