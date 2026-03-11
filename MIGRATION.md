# Nix-Darwin → Chezmoi Migration Plan

**Status**: Phase 1–5 complete, Phase 6 complete
**Source**: `~/.config/nix-darwin` (nix-darwin + home-manager)
**Target**: `~/.local/share/chezmoi` (chezmoi + age encryption)
**Scope**: Darwin (macOS) systems only

---

## Decisions Made

- **Zsh**: Removed entirely. Bash is the login shell; nushell is the interactive shell.
- **Plugin manager**: N/A — no zsh, bash uses direct `eval` integrations.
- **Licensed fonts**: Encrypted with age in chezmoi, installed to `~/Library/Fonts` via run script.
- **Emacs, Aerospace, Borders**: Excluded from chezmoi config.
- **Work profile**: `profile = "work"` in chezmoi data, conditionals in templates.
- **go-preview / go-rspec-switcher**: Built from source via `go install`.
- **claude-code**: Installed via Homebrew.
- **Neovim LSPs**: Managed by Mason (not Nix binaries).
- **Treesitter**: Managed by nvim-treesitter `:TSUpdate` (not Nix).
- **Theming**: Stylix removed; Kanso colorscheme for nvim, ghostty theme files.

---

## Phase 1: Package Management ✅ COMPLETE

- [x] Updated `.chezmoidata/packages.yaml` — comprehensive brew/cask list
  - Taps: nikitabobko/tap, FelixKratz/formulae, homebrew/cask-fonts
  - Work taps: betterment/betterbrew, raggi/ale (conditional)
  - ~60 brews (shared), ~20 work-only brews
  - ~18 casks, ~10 font casks
- [x] Updated `run_onchange_darwin-install-packages.sh.tmpl`
  - Taps section added
  - Work profile conditional (`{{ if eq .profile "work" }}`)
  - Font casks section added
- [x] Added `run_onchange_darwin-build-go-tools.sh.tmpl`
  - Builds go-preview and go-rspec-switcher from source
- [x] Added `profile = "work"` to `~/.config/chezmoi/chezmoi.toml`

---

## Phase 2: Neovim ✅ COMPLETE

- [x] Replaced chezmoi nvim config with nix-darwin version (more up-to-date)
  - All plugins: autopairs, dial, kanagawa, markview, neotest, obsidian,
    octo, parinfer-rust, sidekick, vscode-diff (new vs old chezmoi)
- [x] Treesitter: rewrote `treesitter.lua` to use `ensure_installed` + `:TSUpdate`
  - Merged grammar lists from both configs (~50 grammars)
  - Removed Nix treesitter loader (`nix-treesitter-parsers.lua`)
- [x] LSPs: re-enabled Mason
  - Created `mason.lua` with `ensure_installed` for all LSPs
  - `mason-lspconfig` with `automatic_installation = true`
  - `native-lsp.lua` depends on mason.nvim
  - `lsp.lua` (vim.lsp.config/enable) unchanged — servers expected on PATH
- [x] Removed `nix-plugins.lua` helper module
- [x] Fixed `sniprun.lua` — builds from source with `sh install.sh`
- [x] Fixed `parinfer-rust.lua` — builds with `cargo build --release`
- [x] Disabled `mini.base16` (Stylix-dependent), enabled `kanso.nvim` colorscheme

---

## Phase 3: Shell Configs ✅ COMPLETE

- [x] **Zsh removed entirely** — deleted `dot_zshrc.tmpl`, `encrypted_dot_zshenv.tmpl.age`,
  `private_dot_config/zsh/`, `private_dot_config/oh-my-posh/`
- [x] **Bash profile** (`encrypted_dot_bash_profile.tmpl.age`) — rewritten from nix
  - PATH with mise shims, homebrew, go, cargo, system
  - XDG base directories
  - Core env: EDITOR=nvim, VISUAL=nvim, PAGER=less
  - FZF config (default command, options, preview)
  - Build flags (LDFLAGS, CPPFLAGS for macOS libffi)
  - ANTHROPIC_API_KEY (encrypted)
  - GitHub token lazy-load via `gh auth token`
  - Template conditional for darwin-only settings
- [x] **Bashrc** (`dot_bashrc`) — comprehensive interactive config
  - Shell options: histappend, extglob, globstar, cdspell, autocd, etc.
  - Aliases: eza, bat, git, navigation, utilities
  - Functions: mkcd, extract, open_file_at_line, fuzzy_grep_files,
    fuzzy_find_files, fkill, jira (1Password token)
  - Tool integrations: direnv, mise, fzf, zoxide, atuin, starship, vivid, carapace
  - Work bootstrap sourcing
- [x] **Nushell** — updated from nix version
  - `env.nu.tmpl` — rewritten with proper PATH, tool init (mise, zoxide, atuin, carapace)
  - `config.nu` (encrypted) — full config with aliases, keybindings, custom commands,
    fuzzy finders, task runner, ANTHROPIC_API_KEY
- [x] **Starship** — `private_dot_config/starship.toml` with nerd font symbols
- [x] **`.hushlogin`** — suppress "Last login" message

---

## Phase 4: App Configs ✅ COMPLETE

- [x] **Git** — full `~/.config/git/config` from nix git.nix
  - Aliases, color, diff, merge, push, credential (gh), delta integration
  - `core.editor = nvim`
  - Kept existing `~/.config/git/ignore`
- [x] **Ghostty** — updated config (removed Stylix color generation)
  - Static config with kanso-zen theme, PragmataPro font
  - Nushell as default shell
  - Cursor-blaze shader copied
  - Existing kanso theme files preserved
- [x] **Zellij** — config.kdl from nix (without Stylix colors)
  - Ctrl+Space locked mode, tmux-mode commands (lazygit, claude, run-task)
  - zjstatus plugin download script (`run_once_install-zellij-plugins.sh`)
  - Default shell: `/opt/homebrew/bin/nu`
- [x] **Hammerspoon** — updated from nix
  - `init.lua`, `paperwm.lua`, `swipe.lua` from nix repo
  - Spoons download script (`run_once_install-hammerspoon-spoons.sh`)
  - Removed old `config.fnl`
- [x] **Television** — config + cable channels from nix
  - `config.toml` (theme changed from stylix to default)
  - Cable channels: dotfiles, files, mise-apps, mise-tasks, text
- [x] **Claude Code** — `dot_claude/settings.json` + hooks
- [x] **Pi** — `dot_pi/agent/settings.json` + ast-grep skill
- [x] **Zed** — `settings.json`, `keymap.json`, `debug.json` from nix
- [x] **LinearMouse** — `linearmouse.json` from nix
- [x] **Lazygit** — `config.yml` with openLink setting
- [x] **`.pryrc`** — Emacs compatibility settings from nix

### Not migrated (by design):
- Emacs (deferred)
- Aerospace (removed)
- Borders (removed)
- mpv (Linux-only, complex shader setup)
- SurfingKeys (browser extension, low priority)

---

## Phase 5: Fonts ✅ COMPLETE

- [x] **Licensed fonts** encrypted with age in chezmoi
  - Berkeley Mono TX-02 (4 .otf files)
  - PragmataPro (20 .ttf files — mono, liga, bold, italic, regular variants)
  - Stored at `private_dot_local/share/fonts/{BerkeleyMono,PragmataPro}/`
- [x] **Font install script** (`run_onchange_darwin-install-fonts.sh.tmpl`)
  - Copies decrypted fonts to `~/Library/Fonts/` on macOS
- [x] **Nerd fonts + system fonts** via Homebrew casks in packages.yaml
  - Symbols Only, Geist Mono, Commit Mono, Roboto Mono (nerd)
  - Crimson Pro, Roboto, Inter, Geist, EB Garamond, Merriweather (system)

---

## Phase 6: System Setup ✅ COMPLETE

- [x] **macOS defaults** (`run_once_darwin-system-defaults.sh.tmpl`)
  - Dock: autohide, delay, tilesize, no recents
  - Finder: show extensions, path bar, status bar, search current folder
  - Keyboard: key repeat 2, initial repeat 15, full keyboard access
  - Interface: dark mode, save to disk
  - Trackpad: tap to click, three finger drag
  - Mouse: disable acceleration (flat profile)
  - WindowManager: disable click-to-show-desktop
- [x] **`.chezmoiignore`** — updated for cross-platform ignores

---

## Cleanup ✅ COMPLETE

- [x] Removed `dot_zshrc.tmpl`
- [x] Removed `encrypted_dot_zshenv.tmpl.age`
- [x] Removed `private_dot_config/zsh/`
- [x] Removed `private_dot_config/oh-my-posh/`
- [x] Removed `private_dot_config/aerospace/`
- [x] Removed `private_dot_config/borders/`
- [x] Removed `dot_functions.sh` (merged into bashrc)
- [x] Removed `dot_ideavimrc` (JetBrains not in config)
- [x] Removed `private_dot_config/lsd/` (replaced by eza)
- [x] Removed `private_dot_config/neovide/` (not in nix config)
- [x] Removed `nix-plugins.lua` from nvim config

---

## Remaining / Future Work

- [ ] **Git LFS for fonts** — consider adding `.gitattributes` with LFS tracking
  for the encrypted font `.age` files (they're binary, ~10-50KB each)
- [ ] **Emacs migration** — when ready, would need:
  - `use-package` with auto-install (replacing Nix-managed packages)
  - Tree-sitter grammars from treesit-auto
  - LSP via eglot or lsp-mode with Mason-like auto-install
  - Emacsclient.app bundle
- [ ] **SurfingKeys** — browser config (low priority)
- [ ] **mpv** — Linux-only, complex shader/VapourSynth setup
- [ ] **Nix removal** — once chezmoi is verified working:
  1. `darwin-rebuild switch` one last time with minimal config
  2. Remove nix-darwin config
  3. Optionally uninstall Determinate Nix
- [ ] **Test on fresh machine** — validate `chezmoi init && chezmoi apply` workflow
- [ ] **Input fonts** — may need manual install from input.djr.com (not in Homebrew)

---

## File Inventory

### Encrypted files (age)
- `encrypted_dot_bash_profile.tmpl.age` — PATH, env vars, ANTHROPIC_API_KEY
- `private_dot_config/nushell/encrypted_config.nu.age` — nushell config + API key
- `private_dot_local/share/fonts/BerkeleyMono/encrypted_*.age` — 4 font files
- `private_dot_local/share/fonts/PragmataPro/encrypted_*.age` — 20 font files
- `chezmoi-key.txt.age` — age private key (passphrase-protected)

### Template files
- `encrypted_dot_bash_profile.tmpl.age` — OS-conditional (darwin/linux)
- `private_dot_config/nushell/env.nu.tmpl` — OS-conditional PATH
- `run_onchange_darwin-install-packages.sh.tmpl` — profile-conditional packages
- `run_onchange_darwin-install-fonts.sh.tmpl` — darwin-only
- `run_onchange_darwin-build-go-tools.sh.tmpl` — darwin-only
- `run_once_darwin-system-defaults.sh.tmpl` — darwin-only

### Run scripts
- `run_once_before_decrypt-private-key.sh.tmpl` — decrypt age key
- `run_onchange_darwin-install-packages.sh.tmpl` — brew bundle
- `run_onchange_darwin-install-fonts.sh.tmpl` — copy fonts to ~/Library/Fonts
- `run_onchange_darwin-build-go-tools.sh.tmpl` — go install custom tools
- `run_once_darwin-system-defaults.sh.tmpl` — macOS defaults write
- `run_once_install-zellij-plugins.sh` — download zjstatus
- `run_once_install-hammerspoon-spoons.sh` — clone Spoons from GitHub
- `run_onchange_arch-install-packages.sh.tmpl` — arch linux (unchanged)
