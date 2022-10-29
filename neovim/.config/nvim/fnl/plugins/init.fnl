(import-macros {: require*} :macros)
(require* export-module [:utils :export-module]
          use-plugins! [:pkg-utils :use-plugins!]
          merge [:utils :merge]
          vals [:utils :vals])

(local plugins [{:repo :windwp/nvim-autopairs
                 :config (fn []
                           (let [autopairs (require :nvim-autopairs)]
                             (autopairs.setup)))}

                {:repo :numToStr/Comment.nvim
                 :config (fn []
                           (let [cmt (require :Comment)]
                             (cmt.setup)))}

                {:repo :akinsho/bufferline.nvim
                 :branch :main
                 :config (fn []
                           (let [bl (require :bufferline)]
                             (bl.setup {:options {:show_close_icon false
                                                  :show_buffer_close_icons false
                                                  :indicator {:style :none}
                                                  :separator_style {"" ""}
                                                  :offsets [{:filetype :NvimTree
                                                             :text "File Explorer"
                                                             :highlight :Directory
                                                             :separator true}]}})))}

                {:repo :ahmedkhalf/project.nvim
                 :requires [:nvim-telescope/telescope.nvim]
                 :config (fn []
                           (let [prj (require :project_nvim)
                                 telescope (require :telescope)]
                             (prj.setup {:manual_mode true})
                             (telescope.load_extension :projects)))}

                {:repo :lukas-reineke/indent-blankline.nvim
                 :config (fn []
                           (let [bl (require :indent_blankline)]
                             (bl.setup {:buftype_exclude [:terminal]
                                        :filetype_exclude [:alpha]})))}

                {:repo :lewis6991/gitsigns.nvim
                 :config (fn []
                           (let [signs (require :gitsigns)]
                             (signs.setup)))}

                {:repo :kyazdani42/nvim-tree.lua
                 :config (fn []
                           (let [tree (require :nvim-tree)]
                             (tree.setup {:view {:adaptive_size true
                                                 :mappings {:list [{:key :u :action :dir_up}]}}
                                          :renderer {:group_empty true}})))}

                {:repo :folke/zen-mode.nvim
                 :config (fn []
                           (let [zen (require :zen-mode)]
                             (zen.setup)))}

                {:repo :NvChad/nvim-colorizer.lua
                 :config (fn []
                           (let [colors (require :colorizer)]
                             (colors.setup)))}

                {:repo :nvim-orgmode/orgmode
                 :config (fn []
                           (let [org (require :orgmode)]
                             (org.setup)))}

                {:repo :eraserhd/parinfer-rust
                 :run "cargo build --release"}

                {:repo :machakann/vim-sandwich
                 :config (fn []
                           (vim.cmd "runtime macros/sandwich/keymap/surround.vim"))}

                {:repo :ggandor/leap.nvim
                 :config (fn []
                           (let [leap (require :leap)]
                             (leap.add_default_mappings)))}

                {:repo :knubie/vim-kitty-navigator
                 :run "cp ./*.py ~/.config/kitty"
                 :setup (fn []
                          (tset _G :kitty_navigator_no_mappings 1))
                 :config (fn []
                           (let [nmap (. (require :utils) :nmap)]
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
                           (let [noice (require :noice)]
                             (noice.setup)))}

                {:repo :L3MON4D3/LuaSnip
                 :requires :rafamadriz/friendly-snippets
                 :config (fn []
                           (let [snippets (require :luasnip.loaders.from_vscode)]
                             (snippets.lazy_load)))}

                {:repo :wbthomason/packer.nvim}
                {:repo :lewis6991/impatient.nvim}
                {:repo :antoinemadec/FixCursorHold.nvim}
                {:repo :RRethy/nvim-treesitter-endwise}
                {:repo :pechorin/any-jump.vim}
                {:repo :mg979/vim-visual-multi}
                {:repo :nvim-lua/plenary.nvim}
                {:repo :williamboman/nvim-lsp-installer}
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
