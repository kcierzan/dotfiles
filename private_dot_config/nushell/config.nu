# config.nu — Nushell main configuration
# Managed by chezmoi

# Load mise activation module
use ("~/.config/nushell" | path join mise.nu)
use std

# Aliases
alias lg = lazygit
alias la = ls -la
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias myip = curl -4 ifconfig.co
alias be = bundle exec
alias zj = zellij
alias g = git
alias gs = git status
alias ga = git add
alias gaa = git add --all
alias gc = git commit -v
alias gcm = git commit -m
alias gco = git checkout
alias gd = git diff
alias gl = git pull
alias gp = git push
alias glog = git log --oneline --decorate --graph
alias tiltup = /opt/homebrew/bin/tilt up
alias zen = ^open -a "Zen Browser (Beta)" --args -P default

use secrets.nu

let fzf_options = [
    "--border",
    "--height=100%",
    "--inline-info",
    "--prompt='> '",
    "--pointer='> '",
    "--marker='* '",
    "--bind=ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down",
    "--preview-window='right,border-left,<70(up,66%,border-bottom)'"
  ]

# FZF
$env.FZF_DEFAULT_OPTS = $fzf_options | str join " "

# Lazy-load GitHub token
def --env ensure_github_token [] {
  if ($env.GITHUB_PERSONAL_ACCESS_TOKEN? | is-empty) {
    $env.GITHUB_PERSONAL_ACCESS_TOKEN = (gh auth token e> (std null-device))
  }
}

def git_branch_name []: nothing -> string {
  mut dir = (pwd)
  loop {
    if ($dir | path join ".git" | path exists) {
      return (git -C $dir branch --show-current)
    }
    let parent = ($dir | path dirname)
    if $parent == $dir { return "" }
    $dir = $parent
  }
  ""
}

def get_ssh_hostname [] {
  if ($env.SSH_CONNECTION? | is-not-empty) {
    return $"(ansi magenta)❲(hostname)❳(ansi reset)"
  }
}

def get_abbreviated_cwd []: nothing -> string {
  let cwd: string = (pwd)
  let home = $env.HOME
  let display = (
    if $cwd == $home { "~" }
    else if ($cwd | str starts-with $home) { $"~($cwd | str replace $home '')" }
    else { $cwd }
  )
  $"(ansi blue)($display)(ansi reset)"
}

$env.PROMPT_COMMAND = {|| [(get_ssh_hostname), (get_abbreviated_cwd)] | compact | str join " " | $in + (char newline) }
$env.PROMPT_COMMAND_RIGHT = {|| git_branch_name }
$env.PROMPT_INDICATOR = "λ "
$env.PROMPT_INDICATOR_VI_INSERT = "❯ "
$env.PROMPT_INDICATOR_VI_NORMAL = "◇ "

$env.config = {
  show_banner: false
  edit_mode: emacs

  history: {
    max_size: 50000
    sync_on_enter: true
    file_format: "sqlite"
  }

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
  }

  cursor_shape: {
    emacs: line
    vi_insert: line
    vi_normal: block
  }

  table: {
    mode: rounded
    index_mode: auto
    show_empty: true
    padding: { left: 1, right: 1 }
    trim: { methodology: wrapping, wrapping_try_keep_words: true }
    header_on_separator: false
  }

  error_style: "fancy"

  hooks: {
    env_change: {
      PWD: [{||
        if (which direnv | is-empty) { return }
        direnv export json | from json | default {} | load-env
        if ($env.PATH | describe) == "string" {
          $env.PATH = ($env.PATH | split row (char esep))
        }
      }]
    }
  }

  keybindings: [
    {
      name: lazygit
      modifier: alt
      keycode: char_v
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "lg" }]
    }
    {
      name: fuzzy_file
      modifier: control
      keycode: char_t
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "commandline edit --insert (fd --type f --hidden --exclude .git | fzf --height=40% --preview 'bat --color=always --style=numbers,changes {}' | str trim)" }]
    }
    {
      name: fuzzy_directory
      modifier: alt
      keycode: char_c
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "cd (fd --type d --hidden --exclude .git | fzf --height=40% --preview 'eza -1 --color=always {}' | str trim)" }]
    }
    {
      name: fuzzy_grep_files
      modifier: alt
      keycode: char_g
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "fuzzy_grep_files" }]
    }
    {
      name: fuzzy_find_files
      modifier: alt
      keycode: char_p
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "fuzzy_find_files" }]
    }
    {
      name: fuzzy_recent_dir
      modifier: alt
      keycode: char_j
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "zi" }]
    }
    {
      name: claude_code
      modifier: alt
      keycode: char_a
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "claude" }]
    }
    {
      name: run_task
      modifier: alt
      keycode: char_r
      mode: [emacs, vi_insert, vi_normal]
      event: [{ send: ExecuteHostCommand, cmd: "run-task" }]
    }
  ]
}

# Custom commands

def --env mkcd [dir: string] { mkdir $dir; cd $dir }

def extract [file: string] {
  if ($file | path exists) {
    match ($file | path parse | get extension) {
      "gz" => {
        if ($file | str ends-with ".tar.gz") or ($file | str ends-with ".tgz") { tar xzf $file }
        else { gunzip $file }
      }
      "bz2" => {
        if ($file | str ends-with ".tar.bz2") or ($file | str ends-with ".tbz2") { tar xjf $file }
        else { bunzip2 $file }
      }
      "tar" => { tar xf $file }
      "zip" => { unzip $file }
      "rar" => { unrar e $file }
      "7z" => { 7z x $file }
      "Z" => { uncompress $file }
      _ => { print $"'($file)' cannot be extracted" }
    }
  } else {
    print $"'($file)' is not a valid file"
  }
}

def open_file_at_line [file: string, line: int] {
  let editor = ($env.EDITOR | str downcase)
  if ($editor | str contains "nvim") or ($editor | str contains "micro") {
    ^$env.EDITOR $"+($line)" $file
  } else {
    ^$env.EDITOR $"($file):($line)"
  }
}

def fuzzy_grep_files [] {
  let selected = (
    rg -n --hidden --glob "!.git" --glob "!node_modules" --glob "!env" --glob "!*.pyc" --glob "!*.dmp" --glob "!*.rbi" ""
    | fzf +m --exit-0 --delimiter ":" --nth "3.." --preview "bat --color=always --style=numbers --highlight-line {2} {1}" --preview-window "right,border-left,<70(up,66%,border-bottom)" --bind "alt-enter:execute(zed {1}:{2})+abort"
    | str trim
  )
  if ($selected | is-not-empty) {
    let parts = ($selected | split column ":" | first)
    let file = ($parts | get column0)
    let line = ($parts | get column1 | into int)
    open_file_at_line $file $line
  }
}

def fuzzy_find_files [] {
  let bat_preview = "bat --color=always --style=numbers,changes {}"
  # ctrl-h toggles hidden files on/off; state is tracked via the prompt text
  let toggle_hidden = "ctrl-h:transform:if echo {fzf_prompt} | grep -q '(all)'; then echo 'reload(fd --strip-cwd-prefix --type f --no-hidden --exclude .git --exclude node_modules --exclude tmp --exclude .idea --exclude .vscode --exclude .keep .)+change-prompt(files> )'; else echo 'reload(fd --strip-cwd-prefix --type f --hidden --exclude .git --exclude node_modules --exclude tmp --exclude .idea --exclude .vscode --exclude .keep .)+change-prompt(files (all)> )'; fi"
  let files = (
    fd --strip-cwd-prefix --hidden --type f --exclude "*.jpg" --exclude ".git" --exclude ".idea" --exclude ".keep" --exclude ".vscode" --exclude "node_modules" --exclude "tmp" --exclude "*.map" --exclude "*.pdf" --exclude "*.png" --exclude "*.pyc" --exclude "*.rbi" "."
    | fzf --multi --exit-0 --prompt "files (all)> " --preview $bat_preview --preview-window "right,border-left,<70(up,66%,border-bottom)" --bind $toggle_hidden --bind "alt-enter:execute(zed {})+abort"
    | str trim
  )
  if ($files | is-not-empty) {
    ^$env.EDITOR ...($files | lines)
  }
}

def fkill [] {
  let processes = (
    ps | where name != "nu" | select pid name cpu mem
    | each { |row| $"($row.pid | fill -a right -w 8) ($row.name | fill -w 30) CPU:($row.cpu | math round -p 1)% MEM:($row.mem)" }
    | str join "\n"
  )
  let result = ($processes | fzf --multi --preview-window "up:3:wrap" --header "Enter: SIGTERM | Alt-Enter: SIGKILL" --expect "alt-enter" | str trim)
  if ($result | is-empty) { return }
  let lines = ($result | lines)
  let key = ($lines | first)
  let selections = ($lines | skip 1)
  if ($selections | is-empty) { return }
  let pids = ($selections | each { |line| $line | str trim | split words | first | into int })
  if $key == "alt-enter" {
    print $"Force killing \(SIGKILL): ($pids | str join ' ')"
    $pids | each { |pid| try { ^kill -9 ($pid | into string) } }
  } else {
    print $"Killing \(SIGTERM): ($pids | str join ' ')"
    $pids | each { |pid| try { ^kill ($pid | into string) } }
  }
  null
}

def ff [] { fuzzy_find_files }
def fg [] { fuzzy_grep_files }

# JIRA_OP_PATH must be set in secrets.nu, e.g.:
#   $env.JIRA_OP_PATH = "op://Employee/jira-token/credential"
def --env --wrapped jira [...args] {
  if ($env.JIRA_API_TOKEN? | is-empty) {
    $env.JIRA_API_TOKEN = (op read $env.JIRA_OP_PATH | str trim)
  }
  $env.JIRA_PAGER = "less -+F"
  ^jira ...$args
}

const monorepo_path = "~/src/for_business"

# Fuzzy-pick a Rails app in the monorepo (identified by Gemfile presence).
# Must be called from within $monorepo_path.
def fuzzy_mise_apps []: nothing -> string {
  (
    fd --max-depth 2 --type f -g "Gemfile" .
    | lines
    | each { |p| $p | path dirname | path basename }
    | sort
    | str join (char newline)
    | fzf --ansi --prompt "app> "
        --preview "eza -1 --color=always {}"
        --preview-window "right,border-left,<70(up,66%,border-bottom)"
    | str trim
  )
}

# Fuzzy-pick a mise task. Preview shows the task's TOML definition via bat.
# Must be called from within $monorepo_path.
def fuzzy_mise_tasks []: nothing -> string {
  # --delimiter '\s\s+' splits on 2+ spaces so {1}=name, {2}=description
  (
    mise tasks
    | fzf --ansi --prompt "task> " --delimiter "\\s\\s+" --nth 1
          --preview "grep -A 8 -E '^\\[tasks\\.\"?{1}\"?\\]' $HOME/src/for_business/mise.local.toml | bat --color=always --style=plain --language=toml"
          --preview-window "right,border-left,<70(up,66%,border-bottom)"
    | str trim
    | split words
    | first
  )
}

def run-task [--all, --watch] {
  cd $monorepo_path
  let app = if $all { null } else {
    let picked = (fuzzy_mise_apps)
    if ($picked | is-empty) { return }
    $picked
  }
  let task = (fuzzy_mise_tasks)
  if ($task | is-empty) { return }
  let cmd = if $watch { "watch" } else { "run" }
  if $app != null {
    print $"(ansi cyan)APP=($app) mise ($cmd) ($task)(ansi reset)"
    with-env { APP: $app } { mise $cmd $task }
  } else {
    print $"(ansi cyan)mise ($cmd) ($task)(ansi reset)"
    mise $cmd $task
  }
}

def tasks [] { cd $monorepo_path; fuzzy_mise_tasks }

def checks [] {
  cd $monorepo_path
  let app = (fuzzy_mise_apps)
  if ($app | is-empty) { return }
  with-env { APP: $app } { zellij --layout checks }
}

# Switch the active chezmoi color theme interactively via fzf.
# Reads available themes from ~/.local/share/chezmoi/.chezmoidata/themes.yaml,
# prompts with fzf, writes the selection to theme.yaml, then runs chezmoi apply.
def theme-switch [] {
  let themes_file = ($env.HOME | path join ".local/share/chezmoi/.chezmoidata/themes.yaml")
  let theme_file  = ($env.HOME | path join ".local/share/chezmoi/.chezmoidata/theme.yaml")

  # Build a list of "key  |  Display Name" lines for fzf
  let themes = (open $themes_file | get themes | transpose key value
    | each { |row| $"($row.key)\t($row.value.name)" })

  # Prompt with fzf; display "Name  (key)" in the menu
  let selection = (
    $themes
    | to text
    | fzf
        --with-nth 2..
        --delimiter "\t"
        --prompt "Theme > "
        --no-preview
    | str trim
  )

  if ($selection | is-empty) {
    print "No theme selected."
    return
  }

  let theme_key = ($selection | split column "\t" key name | get key.0)

  # Re-write theme.yaml, preserving the comment header
  let header = "# Global theme selector
# Change this value to switch the active color theme across all managed apps.
# Available themes are defined in themes.yaml (ported from nix-darwin themes/).
# Run `chezmoi apply` after changing to regenerate all themed config files.
#
# Example values:
#   oxocarbon-dark, oxocarbon-light
#   tokyo-night-moon
#   gruvbox-material-dark-medium, gruvbox-material-light-medium
#   everforest-dark-medium
#   doom-one, doom-dracula, doom-gruvbox, doom-nord, doom-monokai-pro
#   dracula, dracula-pro
#   monokai-pro, monokai-classic
#   modus-vivendi-dark, modus-vivendi-tinted, modus-operandi-tinted"

  $"($header)\ntheme: ($theme_key)\n" | save --force $theme_file

  print $"(ansi green)Theme set to:(ansi reset) ($theme_key)"
  print $"(ansi cyan)Running chezmoi apply…(ansi reset)"
  chezmoi apply
}

source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/atuin.nu
source ~/.config/nushell/carapace.nu
