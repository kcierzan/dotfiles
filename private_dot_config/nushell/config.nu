# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

def fuzzy_find_files [] {
  let excludes = [
    "*.jpg"
    ".git"
    ".idea"
    ".keep"
    ".vscode"
    "node_modules"
    "tmp"
    "*.map"
    "*.pdf"
    "*.png"
    "*.pyc"
    "*.rbi"
  ]

  let exclude_args = ($excludes | each {|pat| ['--exclude', $pat]} | flatten)
  let files = (^fd
    --no-ignore
    --strip-cwd-prefix
    --hidden
    --type f
    ...$exclude_args
    "."
    | ^fzf
      --multi
      --exit-0
      --preview-window "right:60%"
      --preview "fzf-preview {}"
    | lines
  )

  if ($files | is-empty) {
    return
  }

  ^$env.EDITOR ...$files
}

def open_file_at_line [] {
  let input = $in
  if ($input | length) == 2 {
    ^env.EDITOR +($input | get 1) ($input | get 0)
  }
}

def fuzzy_grep_files [] {
  let exclude_dirs = [".git" "node_modules" "env"]
  let exclude_files = ["*.pyc" "*.dmp" "*.rbi"]

  let globs = ($exclude_dirs | append $exclude_files | each {|glob| ['--glob', "!{$glob}"]} | flatten)


  ^rg -n --hidden ...$globs "" |
  ^fzf +m --exit-0 --preview-window "right:60%" --delimiter ":" --nth "3.." --preview "fzf-preview {}" |
  if ($in | is-empty) {
    return
  } else {
    $in
    | split row ':'
    | get 0 1
    | reduce -f [] {|it, acc| $acc | append $it }
    | open_file_at_line
  }
}

def lg [] {
  ^lazygit
}

alias gs = git status
alias la = ls -la

let new_keybindings = [
  {
      name: fuzzy_find_files
      modifier: alt
      keycode: char_p
      mode: [emacs, vi_normal, vi_insert]
      event: { send: executehostcommand cmd: "fuzzy_find_files" }
  }
  {
      name: fuzzy_grep_files
      modifier: alt
      keycode: char_g
      mode: [emacs, vi_normal, vi_insert]
      event: { send: executehostcommand cmd: "fuzzy_grep_files" }
  }
  {
    name: lg
    modifier: alt
    keycode: char_v
    mode: [emacs, vi_normal, vi_insert]
    event: { send: executehostcommand cmd: "lg" }
  }
  {
    name: fuzzy_cd
    modifier: alt
    keycode: char_j
    mode: [emacs, vi_normal, vi_insert]
    event: { send: executehostcommand cmd: "__zoxide_zi" }
  }
]

$env.config.cursor_shape = {
  vi_normal: "block"
  vi_insert: "line"
  emacs: "line"
}

$env.config.keybindings = ($env.config.keybindings | append $new_keybindings)

source ~/.zoxide.nu
source ~/.oh-my-posh.nu
