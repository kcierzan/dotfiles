function findfile --description 'Fuzzy file finder'
    set preview_cmd 'if test "(file --mime {} | string match -r \'binary\')" != binary
                         preview {} 2> /dev/null | head -2000
                     else
                         echo {} is a binary file
                     end'
    set excludes '"{.git,node_modules,*.pyc}"'
    set get_files fd . --no-ignore --strip-cwd-prefix --hidden --type f --exclude $excludes 2>/dev/null
    set filter_files fzf -m --exit-0 --preview-window=up:80% --preview (string join "'" "$preview" "'")
    set cmd "$get_files | $filter_files"

    set file (eval $cmd)

    if test -n "$file"
        eval $EDITOR $file
    end
end
