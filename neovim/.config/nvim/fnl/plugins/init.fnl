(import-macros {: require*
                : req-call} :macros)
(require* export-module [:lib :export-module]
          use-plugins! [:packer-lib :use-plugins!]
          merge [:lib :merge]
          vals [:lib :vals])

(local plugins [{:repo :windwp/nvim-autopairs
                 :config (fn [] (req-call :nvim-autopairs :setup))}

                {:repo :numToStr/Comment.nvim
                 :config (fn [] (req-call :Comment :setup))}

                {:repo :akinsho/bufferline.nvim
                 :branch :main
                 :config (fn []
                           (req-call :bufferline
                                     :setup
                                     {:options {:show_close_icon false
                                                :show_buffer_close_icons false
                                                :indicator {:style :none}
                                                :separator_style {"" ""}
                                                :offsets [{:filetype :NvimTree
                                                           :text "File Explorer"
                                                           :highlight :Directory
                                                           :separator true}]}}))}

                {:repo :ahmedkhalf/project.nvim
                 :requires [:nvim-telescope/telescope.nvim]
                 :config (fn []
                           (req-call :project_nvim :setup {:manual_mode true})
                           (req-call :telescope :load_extension :projects))}

                {:repo :lukas-reineke/indent-blankline.nvim
                 :config (fn []
                           (req-call :indent_blankline :setup {:buftype_exclude [:terminal]
                                                               :filetype_exclude [:alpha]}))}

                {:repo :lewis6991/gitsigns.nvim
                 :config (fn [] (req-call :gitsigns :setup))}

                {:repo :kyazdani42/nvim-tree.lua
                 :config (fn []
                           (req-call :nvim-tree 
                                     :setup 
                                     {:view {:adaptive_size true
                                             :mappings {:list [{:key :u :action :dir_up}]}}
                                      :renderer {:group_empty true}}))}

                {:repo :folke/zen-mode.nvim
                 :config (fn [] (req-call :zen-mode :setup))}

                {:repo :NvChad/nvim-colorizer.lua
                 :config (fn [] (req-call :colorizer :setup))}

                {:repo :nvim-orgmode/orgmode
                 :config (fn [] (req-call :orgmode :setup))}

                {:repo :eraserhd/parinfer-rust
                 :run "cargo build --release"}

                {:repo :kylechui/nvim-surround
                 :config (fn [] (req-call :nvim-surround :setup))}

                {:repo :ggandor/leap.nvim
                 :config (fn [] (req-call :leap :add_default_mappings))}

                {:repo :knubie/vim-kitty-navigator
                 :run "cp ./*.py ~/.config/kitty"
                 :setup (fn []
                          (tset _G :kitty_navigator_no_mappings 1))
                 :config (fn []
                           (let [nmap (. (require :lib) :nmap)]
                            (nmap :<A-j> ":KittyNavigateDown<cr>")
                            (nmap :<A-k> ":KittyNavigateUp<cr>")
                            (nmap :<A-h> ":KittyNavigateLeft<cr>")
                            (nmap :<A-l> ":KittyNavigateRight<cr>")))}

                {:repo :kyazdani42/nvim-web-devicons
                 :config (fn []
                           (let [devicons (require :nvim-web-devicons)
                                 fnl {:fnl {:icon "🥬"
                                            :name :Fennel}}]
                             (if (devicons.has_loaded)
                               (devicons.set_icon fnl)
                               (devicons.setup {:override fnl}))))}

                {:repo :folke/noice.nvim
                 :event :VimEnter
                 :requires ["MunifTanjim/nui.nvim" "rcarriga/nvim-notify"]
                 :config (fn []
                           (req-call :noice
                                     :setup
                                     {:routes [{:filter {:event :msg_show
                                                         :kind ""
                                                         :find :written}
                                                :opts {:skip true}}
                                               {:view :notify
                                                :filter {:event :msg_showmode}}
                                               {:filter {:error true
                                                         :find :Pattern}
                                                :opts {:skip true}}
                                               {:filter {:warning true
                                                         :find "search hit"}
                                                :opts {:skip true}}
                                               {:filter {:find "go up one level"}
                                                :opts {:skip true}}
                                               {:filter {:find "quit with exit code"
                                                         :warning true}
                                                :opts {:skip true}}]}))}

                {:repo :L3MON4D3/LuaSnip
                 :requires :rafamadriz/friendly-snippets
                 :config (fn [] (req-call :luasnip.loaders.from_vscode :lazy_load))}
    
                {:repo :williamboman/mason-lspconfig.nvim
                 :config (fn []
                           (req-call :mason-lspconfig
                                     :setup
                                     {:ensure_installed [:pyright
                                                         :bashls
                                                         :tsserver
                                                         :jsonls
                                                         :rust_analyzer
                                                         :solargraph
                                                         :svelte
                                                         :dockerls
                                                         :clojure_lsp
                                                         :ruby_ls
                                                         :elixirls
                                                         :sumneko_lua
                                                         :emmet_ls]}))}

                {:repo :williamboman/mason.nvim
                 :config (fn [] (req-call :mason :setup))}

                {:repo :wbthomason/packer.nvim}
                {:repo :lewis6991/impatient.nvim}
                {:repo :antoinemadec/FixCursorHold.nvim}
                {:repo :RRethy/nvim-treesitter-endwise}
                {:repo :pechorin/any-jump.vim}
                {:repo :mg979/vim-visual-multi}
                {:repo :nvim-lua/plenary.nvim}
                {:repo :rafamadriz/friendly-snippets}
                {:repo :saadparwaiz1/cmp_luasnip}
                {:repo :hrsh7th/cmp-buffer}
                {:repo :hrsh7th/cmp-cmdline}
                {:repo :hrsh7th/cmp-path}
                {:repo :hrsh7th/cmp-calc}
                {:repo :hrsh7th/cmp-nvim-lsp-signature-help}
                {:repo :hrsh7th/cmp-nvim-lsp}
                {:repo :lukas-reineke/cmp-rg}
                {:repo :onsails/lspkind.nvim}
                {:repo :nvim-lua/popup.nvim}
                {:repo :famiu/bufdelete.nvim}
                {:repo :folke/trouble.nvim}
                {:repo :bakpakin/fennel.vim}
                {:repo :Olical/conjure}
                {:repo :rktjmp/hotpot.nvim}
                {:repo :tpope/vim-rhubarb}
                {:repo :tpope/vim-projectionist}
                {:repo :tpope/vim-repeat}
                {:repo :tpope/vim-fugitive}])

{:use! (use-plugins! (merge plugins (vals (export-module :plugins))))}
