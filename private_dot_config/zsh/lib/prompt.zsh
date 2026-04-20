# prompt.zsh — Blazingly fast zsh prompt with git info + transient prompt
# Requires: Nerd Font · PROMPT_SUBST (options.zsh)
#
# Line 1:  [host:]~/path   branch [+staged !dirty ?untracked | ✔]
# Line 2:   (input)
# Transient:  (muted, single line)
#
# Colors: base16 — 1:red 2:green 3:yellow 4:blue 5:magenta 8:muted

# ── Icons (Nerd Font Powerline) ─────────────────────────────────────────────

typeset -g _pc="λ"
typeset -g _gb=$'\ue0a0' # U+E0A0  branch icon

# ── Precmd: rebuild prompt each cycle ───────────────────────────────────────

_prompt_precmd() {
  local ec=$?

  # ── Git info ────────────────────────────────────────────────────────────
  local git_info=''
  local raw
  if raw=$(command git status --porcelain -b 2>/dev/null); then
    local -a lines=("${(@f)raw}")
    if ((${#lines})); then
      # Branch name
      local hdr=${lines[1]#\#\# } branch
      case $hdr in
      'HEAD (no branch)')
        branch=":$(command git rev-parse --short HEAD 2>/dev/null || echo '?')"
        ;;
      'No commits yet on '*)
        branch=${hdr#No commits yet on }
        branch=${branch%%...*}
        ;;
      *)
        branch=${hdr%%...*}
        branch=${branch%%\ \[*}
        ;;
      esac

      # Count staged / modified / untracked (pure zsh, no forks)
      local s=0 m=0 u=0 ln
      for ln in "${lines[@]:1}"; do
        [[ -z $ln ]] && continue
        case ${ln[1]} in
        \?)
          ((u++))
          continue
          ;;
        ' ' | !) ;;
        *) ((s++)) ;;
        esac
        [[ ${ln[2]} != ' ' ]] && ((m++))
      done

      # Assemble git string
      git_info=" %F{5}${_gb} ${branch}%f"
      if ((s + m + u)); then
        ((s)) && git_info+=" %F{2}+${s}%f"
        ((m)) && git_info+=" %F{3}!${m}%f"
        ((u)) && git_info+=" %F{1}?${u}%f"
      else
        git_info+=" %F{2}✔%f"
      fi
    fi
  fi

  # ── Assemble prompt ────────────────────────────────────────────────────
  local host=''
  [[ -n $SSH_CONNECTION ]] && host='%F{3}%m%f%F{8}: %f'

  PROMPT="${host}%F{4}%~%f"$'\n'"%F{$((ec ? 1 : 2))}${_pc}%f "
  RPROMPT="${git_info}"
}

# ── Transient prompt (collapse on accept) ───────────────────────────────────

_prompt_accept_line() {
  PROMPT="%F{8}${_pc}%f "
  RPROMPT=''
  zle reset-prompt
  zle accept-line
}
zle -N _prompt_accept_line
bindkey '^M' _prompt_accept_line

# ── Register hook ───────────────────────────────────────────────────────────

autoload -Uz add-zsh-hook
add-zsh-hook precmd _prompt_precmd
