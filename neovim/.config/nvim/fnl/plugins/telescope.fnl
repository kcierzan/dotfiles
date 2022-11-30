(import-macros {: require*} :macros)

{:repo :nvim-telescope/telescope.nvim
 :requires :nvim-telescope/telescope-fzf-native.nvim
 :run :make
 :config (fn []
           (fn _G.ProjectGrep []
             (require* file-exists? [:lib :file-exists?])
             (let [git-cmd "git rev-parse --show-toplevel"
                   git-dir (-> (vim.fn.system git-cmd) (: :gsub "\n" ""))
                   ?in-git-dir (file-exists? git-dir)
                   tscope (require :telescope.builtin)]
               (if ?in-git-dir
                (tscope.live_grep {:cwd git-dir})
                (tscope.live_grep))))
               
           (let [tscope (require :telescope)]
              (tscope.setup {:defaults
                             {:vimgrep_arguments [:rg
                                                  :--no-heading
                                                  :--color=never
                                                  :--with-filename
                                                  :--line-number
                                                  :--column
                                                  :--smart-case
                                                  :--hidden
                                                  :--trim
                                                  :--glob
                                                  "!.git/"]
                              :layout_strategy :vertical
                              :layout_config {:vertical {:width {:padding 0}
                                                         :height {:padding 0}
                                                         :preview_height 0.70}}}
                             :pickers
                             {:find_files
                               {:find_command [:fd
                                               :--type
                                               :f
                                               :--hidden
                                               :--strip-cwd-prefix
                                               :--exclude
                                               "*.pyc"
                                               :--exclude
                                               ".git/"
                                               :--exclude
                                               "*.jpg"
                                               :--exclude
                                               "*.png"
                                               :--exclude
                                               "*.ttf"
                                               :--exclude
                                               "*.gif"
                                               :--exclude
                                               "*.zip"]
                                :lsp_references {:fname_width 60}
                                :lsp_workspace_symbols {:fname_width 60}
                                :lsp_document_symbols {:fname_width 60}}}
                             :extensions {:fzf
                                           {:fuzzy true
                                            :override_generic_sorter true
                                            :override_file_sorter true
                                            :case_mode :smart_case}}})
            (tscope.load_extension :fzf)))}
