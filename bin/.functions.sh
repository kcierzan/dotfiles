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
    local pid
    # Use a subshell to capture the output of ps piped through fzf into awk to get PIDs
    pids=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

    # Check if PID is not empty and not just spaces
    if [[ -n "$pids" ]]; then
        for pid in $pids; do
            kill -9 "$pid"
        done
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
    # File exclusions and search command
    local format_for_editor
    local linefile
    local excludes='!.git,!node_modules,*.pyc,!env,*.dmp'
    local get_files="rg -n --hidden -g \"$excludes\" . 2>/dev/null"
    local filter_files="fzf +m --exit-0 --preview-window=up:80% --delimiter ':' --nth 3.. --preview 'fzf-preview {}'"

    case "$EDITOR" in
        nvim | 'neovide --frame buttonless')
            format_for_editor='gawk -F: '\''{print "+"$2" "$1}'\'
            ;;
        code)
            format_for_editor='gawk -F: '\''{print "-g "$1":"$2}'\'
            ;;
        subl)
            format_for_editor='gawk -F: '\''{print $1":"$2}'\'
            ;;
    esac

    # Execute the file search, selection, and parsing
    linefile=$(eval "$get_files | $filter_files | $format_for_editor")

    if xargs --help 2>&1 | grep -q "\-d"; then
      xargs_command="xargs"
    else
      xargs_command="gxargs"
    fi

    if [ -n "$linefile" ]; then
        echo "$linefile" | tr ' ' '\n' | $xargs_command -d '\n' "$EDITOR"
    fi
}

timeshell() {
    # Temporary file to store the profiling start time
    START_TIME_FILE=$(mktemp)

    # Record the start time
    date +%s%N > "$START_TIME_FILE"

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
