ifile() {
  local file
  local get_files
  local excludes=(.git node_modules '*.pyc' tmp)

  get_files="fd . --no-ignore --strip-cwd-prefix --hidden --type f"

  for exclude in "${excludes[@]}"; do
    get_files+=" --exclude='$exclude'"
  done

  local filter_files="fzf -m --exit-0 --preview-window=up:80% --preview 'fzf-preview {}'"
  local cmd="$get_files 2>/dev/null | $filter_files"

  file=$(eval "$cmd")

  if [ -n "$file" ]; then
    eval "$EDITOR" "$file"
  fi
}

ikill() {
  local pids
  # Use a subshell to capture the output of ps piped through fzf into awk to get PIDs
  pids=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

  if [[ -n "$pids" ]]; then
    for pid in $pids; do
      if [[ -n "$pid" ]]; then
        echo "${pid}" | xargs kill -9
      fi
    done
  else
    echo "No PIDs selected"
  fi
}

ibranch() {
  local branch

  branch=$(git branch --all | rg -v HEAD | fzf +m)

  if [[ -n "$branch" && "$branch" != "" ]]; then
    git checkout "$(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")"
  fi
}

igrep() {
  local rg_command="rg -n --hidden"
  local exclude_dirs=(".git" "node_modules" "env")
  local exclude_files=("*.pyc" "*.dmp")

  # Build exclude arguments
  for dir in "${exclude_dirs[@]}"; do
    rg_command+=" --glob '!$dir'"
  done
  for file in "${exclude_files[@]}"; do
    rg_command+=" --glob '!$file'"
  done
  local fzf_command="fzf +m --exit-0 --preview-window=up:80% --delimiter : --nth 3.. --preview 'fzf-preview {}'"
  # local vscode_awk_command="awk -F: '{print \"-g \" \$1 \":\" \$2}'"
  local awk_command="awk -F: '{print \$1 \":\" \$2}'"

  # Execute the search and selection in one pipeline
  local selected_file
  selected_file=$(eval "$rg_command . 2>/dev/null | $fzf_command | $awk_command")

  if [ -n "$selected_file" ]; then
    # Determine the appropriate xargs command
    local xargs_command
    if xargs --help 2>&1 | grep -q -- "-d"; then
      xargs_command="xargs -d '\n'"
    else
      xargs_command="gxargs -d '\n'"
    fi

    # Open the selected file(s) in VS Code
    # echo "$selected_file" | tr ' ' '\n' | eval "$xargs_command code"

    # Open the selected file(s) in neovim
    echo "$selected_file" | while IFS=: read -r file line; do
      nvim "+$line" "$file"
    done
  fi
}

timeshell() {
  # Temporary file to store the profiling start time
  START_TIME_FILE=$(mktemp)

  # Record the start time
  date +%s%N >"$START_TIME_FILE"

  # Start Zsh with a command to measure the end time and calculate the difference
  zsh -i -c "
    END_TIME=\$(date +%s%N)
    START_TIME=\$(cat $START_TIME_FILE)
    TOTAL_TIME=\$(echo \"scale=3; (\$END_TIME - \$START_TIME) / 1000000000\" | bc)
    echo \"Total Zsh startup time: \${TOTAL_TIME}s\"
    "

  # Clean up temporary file
  rm "$START_TIME_FILE"

}
