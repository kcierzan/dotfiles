(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :folke/which-key.nvim
  {:config
    (fn []
      (local {: nil?
              : nmap
              : xmap
              : merge} (require :utils))
      (local wk (require :which-key))
      (local keys {"<leader>" {"<cr>" ["org smart return"]
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
                                       :e ["set effort"]}}}})

      (fn leader-prefix [prefix name]
        (when (nil? (. (. keys :<leader>) prefix))
          (tset keys :<leader> prefix {:name (.. "+" name)}))
        (fn [key command description]
          (let [prefixed (. keys :<leader> prefix)
                merged (merge prefixed {key [command description]})]
            (tset keys :<leader> prefix merged))))

      (local leader-f (leader-prefix :f "find"))
      (local leader-v (leader-prefix :v "vim"))
      (local leader-b (leader-prefix :b "buffer"))
      (local leader-w (leader-prefix :w "window"))
      (local leader-i (leader-prefix :i "interface"))
      (local leader-g (leader-prefix :g "git"))
      (local leader-o (leader-prefix :o "org"))

      (leader-f :O "<cmd>lua require('telescope.builtin').vim_options()<cr>" "vim options")
      (leader-f :T "<cmd>lua require('telescope.builtin').filetypes()<cr>" "filetypes")
      (leader-f :a "<cmd>lua require('telescope.builtin').autocommands()<cr>" "autocommands")
      (leader-f :b "<cmd>lua require('telescope.builtin').buffers()<cr>" "open buffers")
      (leader-f :c "<cmd>lua require('telescope.builtin').git_commits()<cr>" "git commits")
      (leader-f :f "<cmd>lua require('telescope.builtin').find_files()<cr>" "files in current directory")
      (leader-f :g "<cmd>lua require('telescope.builtin').live_grep()<cr>" "text in files")
      (leader-f :G "<cmd>Telescope grep_string search=<cr>" "super fuzzy grep")
      (leader-f :h "<cmd>lua require('telescope.builtin').highlights()<cr>" "highlights")
      (leader-f :k "<cmd>lua require('telescope.builtin').keymaps()<cr>" "keymaps")
      (leader-f :l "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>" "lines in buffer")
      (leader-f :m "<cmd>lua require('telescope.builtin').man_pages()<cr>" "man pages")
      (leader-f :o "<cmd>lua require('telescope.builtin').oldfiles()<cr>" "recent files")
      (leader-f :p "<cmd>Telescope projects<cr>" "projects")
      (leader-f :t "<cmd>lua require('telescope.builtin').help_tags()<cr>" "help tags")
      (leader-f :F
                (.. "<cmd>"
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
                    "<cr>")
                "rails application files")

      (leader-v :r "<cmd>so ~/.config/nvim/init.lua<cr>" "reload config")
      (leader-v :e "<cmd>edit ~/.config/nvim/fnl/init_fennel.fnl<cr>" "edit config")
      (leader-v :s "<cmd>PackerSync<cr>" "packer sync")
      (leader-v :c "<cmd>PackerCompile<cr>" "packer compile")

      (leader-b :C "<cmd>windo diffoff<cr>" "diff off")
      (leader-b :D "<cmd>Bdelete!<cr>" "force delete buffer")
      (leader-b :c "<cmd>windo diffthis<cr>" "diff buffer")
      (leader-b :d "<cmd>Bdelete<cr>" "delete buffer")
      (leader-b :r "<cmd>edit!<cr>" "reload buffer")
      (leader-b :s "<cmd>w<cr>" "write")
      (leader-b :y "<cmd>let @+ = expand(\"%:p\")<cr>" "yank buffer name")
      (leader-b :w "<cmd>%s/\\s\\+$//e<cr>" "trim trailing whitespace")
      (leader-b :f "<cmd>silent exec \"!bundle exec rubocop -A %:p\"<cr>" "run rubocop on buffer")

      (leader-w :S "<C-w>J" "to horizontal split")
      (leader-w :V "<C-w>H" "to vertical split")
      (leader-w :e "<C-w>=" "equalize windows")
      (leader-w :j "10<C-w>-" "decrease size")
      (leader-w :k "10<C-w>+" "increase size")
      (leader-w :o "<C-w>o" "delete other windows")
      (leader-w :r "<C-w>r" "rotate windows")
      (leader-w :s "<cmd>sp<cr>" "split horizontally")
      (leader-w :v "<cmd>vsp<cr>" "split vertically")

      (leader-i "#" "<cmd>set invnumber<cr>" "toggle line numbers")
      (leader-i "%" "<cmd>set invrelativenumber<cr>" "toggle relative line numbers")
      (leader-i :c "<cmd>nohlsearch<cr>" "clear search highlight")
      (leader-i :h "<cmd>ColorizerAttachToBuffer<cr>" "colorize buffer")
      (leader-i :l "<cmd>IndentBlanklineToggle<cr>" "toggle indentation lines")
      (leader-i :t "<cmd>NvimTreeToggle<cr>" "toggle tree")
      (leader-i :f "<cmd>NvimTreeFindFile<cr>" "show current file in tree")

      (leader-g :b "<cmd>Git blame<cr>" "blame")
      (leader-g :c "<cmd>Git commit<cr>" "commit")
      (leader-g :d "<cmd>Gvdiff<cr>" "diff")
      (leader-g :m "<cmd>diffget //3<cr>" "get diff from merge buffer")
      (leader-g :n "<cmd>lua require('gitsigns').next_hunk()<cr>" "next hunk")
      (leader-g :p "<cmd>lua require('gitsigns').previous_hunk()<cr>" "previous hunk")
      (leader-g :r "<cmd>Gvdiffsplit!<cr>" "3-way diff")
      (leader-g :s "<cmd>Git<cr>" "status")
      (leader-g :t "<cmd>diffget //2<cr>" "get diff from target buffer")

      (wk.setup {:key_labels {:<cr> :RET}})
      (wk.register keys)

      (nmap "grl" "<cmd>diffget<cr>")
      (nmap "grh" "<cmd>diffput<cr>")
      (xmap "grl" "<cmd>diffget<cr>")
      (xmap "grh" "<cmd>diffput<cr>")

      (nmap "L" "<Nop>")
      (nmap "H" "<Nop>")
      (xmap "L" "<Nop>")
      (xmap "H" "<Nop>")

      (nmap "L" "g_")
      (nmap "H" "^")
      (xmap "L" "g_")
      (xmap "H" "^")

      (nmap "<Leader>q" "<cmd>q<cr>")
      (nmap "<Leader>Q" "<cmd>q!<cr>")
      (nmap "<C-l>" "<cmd>bnext<cr>")
      (nmap "<C-h>" "<cmd>bprev<cr>"))})
