(fn cmd [command]
  (.. "<cmd>" command "<cr>"))

(fn tscope-cmd [method]
  (cmd (.. "lua require('telescope.builtin')." method "()")))

(fn neotest-cmd [call]
  (cmd (.. "lua require('neotest')." call)))

(local rails-app-files-cmd (.. "<cmd>"
                               "Telescope find_files "
                               "find_command="
                               "fd,"
                               "--type,"
                               "f,"
                               "--hidden,"
                               "--strip-cwd-prefix,"
                               "-E,*.pyc,"
                               "-E,.git/,"
                               "-E,node_modules,"
                               "-E,**/spec/**/*,"
                               "-E,**/*migration*/**/*,"
                               "-E,**/vendor/**/*,"
                               "-E,**/migrate/**/*,"
                               "-E,*.jpg,"
                               "-E,*.png,"
                               "-E,*.ttf"
                               " prompt_prefix=💫"
                               "<cr>"))

{"<leader>"
 {"<cr>" ["org smart return"]
  :o {:name "+org"
      :a [:agenda]
      :c [:capture]
      :r [:refile]
      :o ["open at point"]
      :K ["move subtree up"]
      :J ["move subtree down"]
      :e [:export]
      :k ["capture kill"]
      :t ["set tags"]
      :A ["archive tag"]
      "'" ["edit special"]
      "$" ["archive subtree"]
      "," [:priority]
      "*" ["toggle heading"]
      :i {:name "+insert"
          :h ["insert heading at same level"]
          :T ["insert todo header"]
          :t ["insert todo at same level"]
          "." ["time stamp"]
          :s [:schedule]
          "!" ["time stamp inactive"]
          :d ["deadline"]}
      :x {:name "+clock"
          :i ["clock in"]
          :o ["clock out"]
          :q ["cancel clock"]
          :j ["go to clock"]
          :e ["set effort"]}}
  :f {:name "+find"
      :L {:name "+LSP"
          :r [(tscope-cmd :lsp_references) "references"]
          :s [(tscope-cmd :lsp_document_symbols) "buffer symbols"]
          :S [(tscope-cmd :lsp_workspace_symbols) "workspace symbols"]
          :i [(tscope-cmd :lsp_implementations) "implementations"]
          :d [(tscope-cmd :lsp_definitions) "definitions"]
          :c [(tscope-cmd :lsp_incoming_calls) "incoming calls"]}
      :O [(tscope-cmd :vim_options) "vim options"]
      :T [(tscope-cmd :filetypes) "filetypes"]
      :t [(tscope-cmd :help_tags) "help tags"]
      :a [(tscope-cmd :autocommands) "autocommands"]
      :b [(tscope-cmd :buffers) "buffers"]
      :c [(tscope-cmd :git_commits) "commits"]
      :f [(tscope-cmd :find_files) "files in current directory"]
      :g [(tscope-cmd :live_grep) "text in files"]
      :G [(cmd "Telescope grep_string search=") "super fuzzy grep"]
      :h [(tscope-cmd :highlights) "highlights"]
      :k [(tscope-cmd :keymaps) "keymaps"]
      :l [(tscope-cmd :current_buffer_fuzzy_find) "line in buffer"]
      :m [(tscope-cmd :man_pages) "man pages"]
      :o [(tscope-cmd :oldfiles) "oldfiles"]
      :p [(cmd "Telescope projects") "projects"]
      :F [rails-app-files-cmd "rails app files"]}
  :v {:name "+vim"
      :r [(cmd "lua ReloadConfig()") "reload config"] ;; FIXME
      :e [(cmd "edit ~/.config/nvim/fnl/init.fnl") "edit config"] ;; FIXME
      :s [(cmd "PackerSync") "packer sync"]
      :m [(cmd "Mason") "mason"]
      :c [(cmd "PackerCompile") "packer compile"]}
  :b {:name "+buffer"
      :C [(cmd "windo diffoff") "diff off"]
      :D [(cmd "Bdelete!") "force delete buffer"]
      :c [(cmd "windo diffthis") "diff buffer"]
      :d [(cmd "Bdelete") "delete buffer"]
      :r [(cmd "edit!") "reload buffer"]
      :s [(cmd "w") "write"]
      :y [(cmd "let @+ = expand(\"%:p\")") "yank buffer name"]
      :w [(cmd "%s/\\s\\+$//e") "trim trailing whitespace"]
      :f [(cmd "silent exec \"!bundle exec rubocop -A %:p\"") "run rubocop on buffer"]
      :a [(cmd "AV") "open alternate file in vertical split"]}
  :w {:name "+window"
      :S ["<C-w>J" "to horizontal split"]
      :V ["<C-w>H" "to vertical split"]
      :e ["<C-w>=" "equalize windows"]
      :j ["10<C-w>-" "decrease size"]
      :k ["10<C-w>+" "increase size"]
      :o ["<C-w>o" "delete other windows"]
      :r ["<C-w>r" "rotate windows"]
      :s [(cmd "sp") "split horizontal"]
      :v [(cmd "vsp") "split vertically"]}
  " " {:name "+terminal"
       "h" [(cmd "ToggleTerm direction=horizontal") "open lower terminal"]
       "v" [(cmd "ToggleTerm direction=vertical size=60") "open vertical terminal"]
       "f" [(cmd "ToggleTerm direction=float") "open floating terminal"]
       "t" [(cmd "ToggleTerm direction=tab") "open tab terminal"]}
  :i {:name "+interface"
      "#" [(cmd "set invnumber") "toggle line numbers"]
      "%" [(cmd "set invrelativenumber") "toggle relative line numbers"]
      :c [(cmd "nohlsearch") "clear search highlight"]
      :h [(cmd "ColorizerAttachToBuffer") "colorize buffer"]
      :l [(cmd "IndentBlanklineToggle") "toggle indentation lines"]
      :t [(cmd "NvimTreeToggle") "toggle tree"]
      :f [(cmd "NvimTreeFindFile") "show current file in tree"]
      :e [(cmd "Trouble") "show errors and warnings"]
      :H [(cmd "TSHighlightCapturesUnderCursor") "show highlights under cursor"]}
  :g {:name "+git"
      :b [(cmd "Git blame") "blame"]
      :c [(cmd "Git commit") "commit"]
      :d [(cmd "Gvdiff") "diff"]
      :m [(cmd "diffget //3") "get diff from merge buffer"]
      :n [(cmd "lua require('gitsigns').next_hunk()") "next hunk"]
      :p [(cmd "lua require('gitsigns').previous_hunk()") "previous hunk"]
      :r [(cmd "Gvdiffsplit!") "3-way diff"]
      :s [(cmd "Git") "status"]
      :t [(cmd "diffget //2") "get diff from target buffer"]}
  :t {:name "+test"
      :r [(neotest-cmd "run.run()") "run nearest test"]
      :f [(neotest-cmd "run.run(vim.fn.expand('%'))") "run current file"]
      :c [(neotest-cmd "run.stop()") "stop nearest test"]
      :p [(neotest-cmd "output_panel.toggle()") "toggle output panel"]
      :o [(neotest-cmd "output.open()") "show test results"]
      :t [(neotest-cmd "summary.open()") "show test suite structure"]
      :i [(neotest-cmd "output.open({ enter = true})") "open output of nearest test result"]}}}
