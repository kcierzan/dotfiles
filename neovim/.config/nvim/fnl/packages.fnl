(local bootstrap-packer! (. (require :pkg-utils) :bootstrap-packer!))
(local def-pkg (. (require :pkg-utils) :def-pkg))
(local initialize-packer! (. (require :pkg-utils) :initialize-packer!))
(local merge (. (require :utils) :merge))
(local sync-packages! (. (require :pkg-utils) :sync-packages!))

(local packages
  [(def-pkg
     :windwp/nvim-autopairs
     {:config (fn []
                (let [autopairs (require :nvim-autopairs)]
                  (autopairs.setup)))})
   (def-pkg
     :numToStr/Comment.nvim
     {:config (fn []
                (let [cmt (require :Comment)]
                  (cmt.setup)))})
   (def-pkg
     :akinsho/bufferline.nvim
     {:branch :main
      :config (fn []
                (let [bl (require :bufferline)]
                  (bl.setup {:options {:show_close_icon :false}})))})
   (def-pkg
     :ahmedkhalf/project.nvim
     {:requires :nvim-telescope/telescope.nvim
      :config (fn []
                (let [prj (require :project_nvim)
                      telescope (require :telescope)]
                  (prj.setup {:manual_mode true})
                  (telescope.load_extension :projects)))})
   (def-pkg
     :lukas-reineke/indent-blankline.nvim
     {:config (fn []
                (let [bl (require :indent_blankline)]
                  (bl.setup {:buftype_exclude: [:terminal]
                             :filetype_exclude [:alpha]})))})
   (def-pkg
     :goolord/alpha-nvim
     {:config (fn []
                (let [alpha (require :alpha)
                      dash (require :alpha.themes.dashboard)]
                  (alpha.setup dash.config)))})

   (def-pkg
     :lewis6991/gitsigns.nvim
     {:config (fn []
                (let [signs (require :gitsigns)]
                  (signs.setup)))})

   (def-pkg
     :kyazdani42/nvim-tree.lua
     {:config (fn []
                (let [tree (require :nvim-tree)]
                  (tree.setup)))})

   (def-pkg
     :folke/zen-mode.nvim
     {:config (fn []
                (let [zen (require :zen-mode)]
                  (zen.setup)))})

   (def-pkg
     :norcalli/nvim-colorizer.lua
     {:config (fn []
                (let [colors (require :colorizer)]
                  (colors.setup)))})

   (def-pkg
     :nvim-orgmode/orgmode
     {:config (fn []
                (let [org (require :orgmode)]
                  (org.setup)))})

   (def-pkg
     :eraserhd/parinfer-rust
     {:run "cargo build --release"})

   (def-pkg
     :machakann/vim-sandwich
     {:config (fn []
                (vim.cmd "runtime macros/sandwich/keymap/surround.vim"))})

   (def-pkg
     :knubie/vim-kitty-navigator
     {:setup (fn []
               (tset _G :kitty_navigator_no_mappings 1))
      :config (fn []
                (let [nmap (. (require :utils) :nmap)]
                 (nmap :<A-j> ":KittyNavigateDown<cr>")
                 (nmap :<A-k> ":KittyNavigateUp<cr>")
                 (nmap :<A-h> ":KittyNavigateLeft<cr>")
                 (nmap :<A-l> ":KittyNavigateRight<cr>")))
      :run "cp ./*.py ~/.config/kitty"})

   (def-pkg
     :kyazdani42/nvim-web-devicons
     {:config (fn []
                (let [icons (require :nvim-web-devicons)]
                  (icons.setup {:override {:fnl {:icon "🥬"
                                                 :name :Fennel}}})))})
   (def-pkg
     :L3MON4D3/LuaSnip
     {:requires :rafamadriz/friendly-snippets
      :config (fn []
                (let [snippets (require :luasnip.loaders.from_vscode)]
                  (snippets.lazy_load)))})])

(local basic-packages
  [:wbthomason/packer.nvim
   :lewis6991/impatient.nvim
   :nathom/filetype.nvim
   :vim-ruby/vim-ruby
   :tpope/vim-rails
   :nvim-lua/plenary.nvim
   :williamboman/nvim-lsp-installer
   :rafamadriz/friendly-snippets
   :saadparwaiz1/cmp_luasnip
   :hrsh7th/cmp-buffer
   :hrsh7th/cmp-cmdline
   :hrsh7th/cmp-path
   :hrsh7th/cmp-calc
   :hrsh7th/cmp-nvim-lsp-signature-help
   :hrsh7th/cmp-nvim-lsp
   :lukas-reineke/cmp-rg
   :onsails/lspkind.nvim
   :nvim-lua/popup.nvim
   :famiu/bufdelete.nvim
   :ggandor/lightspeed.nvim
   :folke/trouble.nvim
   :bakpakin/fennel.vim
   :Olical/conjure
   :rktjmp/hotpot.nvim
   :tpope/vim-rhubarb
   :tpope/vim-fugitive])

(local module-packages
  [:telescope
   :nvim-cmp
   :lspconfig
   :treesitter
   :which-key
   :lualine])

(fn require-module-packages [modules]
  (accumulate [packages []
               _ module (ipairs modules)]
              (do
                (table.insert packages (require (.. :plugins. module)))
                packages)))

(fn configure! []
  (let [?sync-packages (bootstrap-packer!)
        packages (merge basic-packages
                        packages
                        (require-module-packages module-packages))]
    (initialize-packer! packages)
    (when ?sync-packages
      (sync-packages!))))

{: configure!}
