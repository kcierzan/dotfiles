# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Supports macOS (primary) and Arch Linux.

## What's included

- Shell configs: `bash`, `nushell`
- Editor: `neovim`, `zed`
- Terminal: `ghostty`, `zellij`
- CLI tools: `fzf`, `ripgrep`, `lazygit`, `yazi`, `starship`, `atuin`, `television`, `zoxide`, `bat`, `eza`, and more
- macOS: Hammerspoon (PaperWM tiling), LinearMouse, Raycast, system defaults
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

### 2. Install 1Password CLI

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

### 3. Initialize and apply

```sh
chezmoi init --apply https://github.com/kcierzan/dotfiles.git
```

This will:
1. Clone the repo to `~/.local/share/chezmoi`
2. Prompt for the **age passphrase** to decrypt the private encryption key (see [Encryption](#encryption) below)
3. On macOS, install Homebrew if missing
4. Run `brew bundle` to install all packages
5. Apply all dotfiles and run one-time setup scripts

> **Note:** The full apply can take a while on a fresh machine — Homebrew and all packages need to install first.

### 4. Set the work/personal profile

Package installs and some configs are gated on a `profile` data key. After initializing, edit `~/.config/chezmoi/chezmoi.toml` and set:

```toml
[data]
  profile = "work"   # or "personal"
```

Then re-run `chezmoi apply` to pick up profile-specific packages and configs.

---

## Encryption

Sensitive files (`.bash_profile`, `nushell/config.nu`) are encrypted with [age](https://age-encryption.org) and committed to the repo as `.age` files.

### How it works

- The **age private key** itself is stored encrypted in the repo as `chezmoi-key.txt.age`, locked with a **passphrase** (not a key file).
- On first apply, chezmoi runs `run_once_before_decrypt-private-key.sh.tmpl`, which prompts for that passphrase and decrypts the private key to `~/.config/chezmoi/chezmoi-key.txt`.
- All subsequent decryption of secrets happens automatically using that key.

### First-time passphrase

The passphrase for `chezmoi-key.txt.age` is stored in **1Password**. Retrieve it from your vault before running `chezmoi init`.

### Adding a new encrypted file

```sh
# Encrypt and add a file
chezmoi add --encrypt ~/path/to/secret-file

# Edit an already-encrypted file
chezmoi edit ~/.bash_profile
```

### Rotating the key

1. Generate a new age key: `age-keygen -o new-key.txt`
2. Re-encrypt `chezmoi-key.txt.age` with the new passphrase: `age -p -o chezmoi-key.txt.age new-key.txt`
3. Re-encrypt all `.age` secrets in the repo with the new recipient.
4. Update `recipient` in `~/.config/chezmoi/chezmoi.toml`.
5. Store the new passphrase in 1Password.

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
