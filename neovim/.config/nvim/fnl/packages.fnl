(local {: package
        : use-packages} (require :utils))

(local autopairs (package :windwp/nvim-autopairs))
(autopairs.config 
  (fn []
    (let [pairs (require :nvim-autopairs)]
      (pairs.setup))))

(local comment-nvim (package :numToStr/Comment.nvim))
(comment-nvim.config 
  (fn []
    (let [cmt (require :Comment)]
      (cmt.setup))))

(local bufferline (package :akinsho/bufferline.nvim))
(bufferline.branch :main)
(bufferline.config 
  (fn []
    (let [bl (require :bufferline)]
      (bl.setup {:options {:show_close_icon false}}))))

(local project (package :ahmedkhalf/project.nvim))
(project.requires :nvim-telescope/telescope.nvim)
(project.config 
  (fn []
    (let [prj (require :project_nvim)
          telescope (require :telescope)]
      (prj.setup {:manual_mode true})
      (telescope.load_extension :projects))))

(local indent-bl (package :lukas-reineke/indent-blankline.nvim))
(indent-bl.config 
  (fn []
    (let [bl (require :indent_blankline)]
      (bl.setup {:buftype_exclude [:terminal]
                 :filetype_exclude [:alpha]}))))

(local alpha (package :goolord/alpha-nvim))
(alpha.config 
  (fn []
    (let [a (require :alpha)
          dash (require :alpha.themes.dashboard)]
      (a.setup dash.config))))

(local which-key (package :folke/which-key.nvim))
(which-key.config 
  (fn []
    (let [wk (require :which-key)]
      (require :keys)
      (wk.setup {:key_labels {:<cr> :RET}}))))

(local gitsigns (package :lewis6991/gitsigns.nvim))
(gitsigns.config 
  (fn []
    (let [signs (require :gitsigns)]
      (signs.setup))))

(local tree (package :kyazdani42/nvim-tree.lua))
(tree.config 
  (fn []
    (let [tree (require :nvim-tree)]
      (tree.setup))))

(local zen (package :folke/zen-mode.nvim))
(zen.config 
  (fn []
    (let [zen (require :zen-mode)]
      (zen.setup))))

(local colorizer (package :norcalli/nvim-colorizer.lua))
(colorizer.config 
  (fn []
    (let [colors (require :colorizer)]
      (colors.setup))))

(local org (package :nvim-orgmode/orgmode))
(org.config 
  (fn []
    (let [org (require :orgmode)]
      (org.setup))))

(local parinfer (package :eraserhd/parinfer-rust))
(parinfer.run "cargo build --release")

(local sandwich (package :machakann/vim-sandwich))
(sandwich.config 
  (fn []
    (vim.cmd "runtime macros/sandwich/keymap/surround.vim")))

(local vim-kitty-nav (package :knubie/vim-kitty-navigator))
(vim-kitty-nav.setup
  (fn []
    (tset _G :kitty_navigator_no_mappings 1)))
(vim-kitty-nav.config
  (fn []
    (local {: nmap} (require :utils))
    (nmap :<A-j> ":KittyNavigateDown<cr>")
    (nmap :<A-k> ":KittyNavigateUp<cr>")
    (nmap :<A-h> ":KittyNavigateLeft<cr>")
    (nmap :<A-l> ":KittyNavigateRight<cr>")))
(vim-kitty-nav.run "cp ./*.py ~/.config/kitty/")

(local nvim-web-devicons (package :kyazdani42/nvim-web-devicons))
(nvim-web-devicons.config
  (fn []
    (let [icons (require :nvim-web-devicons)]
      (icons.setup {:override {:fnl {:icon "🥬" :name :Fennel}}}))))

(local luasnip (package :L3MON4D3/LuaSnip))
(luasnip.requires :rafamadriz/friendly-snippets)
(luasnip.config
  (fn []
    (let [snippets (require :luasnip.loaders.from_vscode)]
      (snippets.lazy_load))))

;; --------------------- set up plugins with packer --------------------------
(use-packages
  :wbthomason/packer.nvim
  :lewis6991/impatient.nvim
  :nvim-lua/plenary.nvim
  :rafamadriz/friendly-snippets
  (luasnip.to-params)
  :saadparwaiz1/cmp_luasnip
  :hrsh7th/cmp-buffer
  :hrsh7th/cmp-cmdline
  :hrsh7th/cmp-path
  :hrsh7th/cmp-calc
  :hrsh7th/cmp-nvim-lsp-signature-help
  :hrsh7th/cmp-nvim-lsp
  :lukas-reineke/cmp-rg
  :onsails/lspkind.nvim
  (require :plugins.telescope)
  (require :plugins.lspconfig)
  (require :plugins.treesitter)
  (require :plugins.lsp-installer)
  :nvim-lua/popup.nvim
  (alpha.to-params)
  (comment-nvim.to-params)
  (autopairs.to-params)
  (bufferline.to-params)
  (project.to-params)
  (indent-bl.to-params)
  (which-key.to-params)
  (require :plugins.nvim-cmp)
  (gitsigns.to-params)
  (tree.to-params)
  (org.to-params)
  (parinfer.to-params)
  (sandwich.to-params)
  (zen.to-params)
  (colorizer.to-params)
  (require :plugins.lualine)
  (vim-kitty-nav.to-params)
  (nvim-web-devicons.to-params)
  :famiu/bufdelete.nvim
  :ggandor/lightspeed.nvim
  :folke/trouble.nvim
  :bakpakin/fennel.vim
  :Olical/conjure
  :rktjmp/hotpot.nvim
  :tpope/vim-rhubarb
  :tpope/vim-fugitive)
