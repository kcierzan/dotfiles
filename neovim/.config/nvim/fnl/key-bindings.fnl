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

{"<leader>" {"<cr>" ["org smart return"]
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
                     :r ["<cmd>lua require('telescope.builtin').lsp_references()<cr>" "references"]
                     :s ["<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>" "buffer symbols"]
                     :S ["<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<cr>" "workspace symbols"]
                     :i ["<cmd>lua require('telescope.builtin').lsp_implementations()<cr>" "implementations"]
                     :d ["<cmd>lua require('telescope.builtin').lsp_definitions()<cr>" "definitions"]
                     :c ["<cmd>lua require('telescope.builtin').lsp_incoming_calls()<cr>" "incoming calls"]}
                 :O ["<cmd>lua require('telescope.builtin').vim_options()<cr>" "vim options"]
                 :T ["<cmd>lua require('telescope.builtin').filetypes()<cr>" "filetypes"]
                 :a ["<cmd>lua require('telescope.builtin').autocommands()<cr>" "autocommands"]
                 :b ["<cmd>lua require('telescope.builtin').buffers()<cr>" "buffers"]
                 :c ["<cmd>lua require('telescope.builtin').git_commits()<cr>" "commits"]
                 :f ["<cmd>lua require('telescope.builtin').find_files()<cr>" "files in current directory"]
                 :g ["<cmd>lua require('telescope.builtin').live_grep()<cr>" "text in files"]
                 :G ["<cmd>Telescope grep_string search=<cr>" "super fuzzy grep"]
                 :h ["<cmd>lua require('telescope.builtin').highlights()<cr>" "highlights"]
                 :k ["<cmd>lua require('telescope.builtin').keymaps()<cr>" "keymaps"]
                 :l ["<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>" "line in buffer"]
                 :m ["<cmd>lua require('telescope.builtin').man_pages()<cr>" "man pages"]
                 :o ["<cmd>lua require('telescope.builtin').oldfiles()<cr>" "oldfiles"]
                 :p ["<cmd>Telescope projects<cr>" "projects"]
                 :F [rails-app-files-cmd "rails app files"]}
             :v {:name "+vim"
                 :r ["<cmd>so ~/.config/nvim/init.lua<cr>" "reload config"]
                 :e ["<cmd>edit ~/.config/nvim/fnl/init_fennel.fnl<cr>" "edit config"]
                 :s ["<cmd>PackerSync<cr>" "packer sync"]
                 :c ["<cmd>PackerCompile<cr>" "packer compile"]}
             :b {:name "+buffer"
                 :C ["<cmd>windo diffoff<cr>" "diff off"]
                 :D ["<cmd>Bdelete!<cr>" "force delete buffer"]
                 :c ["<cmd>windo diffthis<cr>" "diff buffer"]
                 :d ["<cmd>Bdelete<cr>" "delete buffer"]
                 :r ["<cmd>edit!<cr>" "reload buffer"]
                 :s ["<cmd>w<cr>" "write"]
                 :y ["<cmd>let @+ = expand(\"%:p\")<cr>" "yank buffer name"]
                 :w ["<cmd>%s/\\s\\+$//e<cr>" "trim trailing whitespace"]
                 :f ["<cmd>silent exec \"!bundle exec rubocop -A %:p\"<cr>" "run rubocop on buffer"]
                 :a ["<cmd>AV<cr>" "open alternate file in vertical split"]}
             :w {:name "+window"
                 :S ["<C-w>J" "to horizontal split"]
                 :V ["<C-w>H" "to vertical split"]
                 :e ["<C-w>=" "equalize windows"]
                 :j ["10<C-w>-" "decrease size"]
                 :k ["10<C-w>+" "increase size"]
                 :o ["<C-w>o" "delete other windows"]
                 :r ["<C-w>r" "rotate windows"]
                 :s ["<cmd>sp<cr>" "split horizontal"]
                 :v ["<cmd>vsp<cr>" "split vertically"]}
             :i {:name "+interface"
                 "#" ["<cmd>set invnumber<cr>" "toggle line numbers"]
                 "%" ["<cmd>set invrelativenumber<cr>" "toggle relative line numbers"]
                 :c ["<cmd>nohlsearch<cr>" "clear search highlight"]
                 :h ["<cmd>ColorizerAttachToBuffer<cr>" "colorize buffer"]
                 :l ["<cmd>IndentBlanklineToggle<cr>" "toggle indentation lines"]
                 :t ["<cmd>NvimTreeToggle<cr>" "toggle tree"]
                 :f ["<cmd>NvimTreeFindFile<cr>" "show current file in tree"]
                 :e ["<cmd>Trouble<cr>" "show errors and warnings"]
                 :H ["<cmd>TSHighlightCapturesUnderCursor<cr>" "show highlights under cursor"]}
             :g {:name "+git"
                 :b ["<cmd>Git blame<cr>" "blame"]
                 :c ["<cmd>Git commit<cr>" "commit"]
                 :d ["<cmd>Gvdiff<cr>" "diff"]
                 :m ["<cmd>diffget //3<cr>" "get diff from merge buffer"]
                 :n ["<cmd>lua require('gitsigns').next_hunk()<cr>" "next hunk"]
                 :p ["<cmd>lua require('gitsigns').previous_hunk()<cr>" "previous hunk"]
                 :r ["<cmd>Gvdiffsplit!<cr>" "3-way diff"]
                 :s ["<cmd>Git<cr>" "status"]
                 :t ["<cmd>diffget //2<cr>" "get diff from target buffer"]}
             :t {:name "+test"
                 :r ["<cmd>lua require('neotest').run.run()<cr>" "run nearest test"]
                 :f ["<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>" "run current file"]
                 :c ["<cmd>lua require('neotest').run.stop()<cr>" "stop nearest test"]
                 :o ["<cmd>lua require('neotest').output.open()<cr>" "show test results"]
                 :t ["<cmd>lua require('neotest').summary.open()<cr>" "show test suite structure"]
                 :i ["<cmd>lua require('neotest').output.open({ enter = true})<cr>" "open output of nearest test result"]}}}
