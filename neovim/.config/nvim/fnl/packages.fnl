;; ------------------- utility functions -------------------------------
(local pkg (. (require :utils) :package))

(fn use-packages [...]
  (let [packer (require :packer)
        args [...]]
    (packer.startup (fn [use]
                      (each [_ pkg (ipairs args)]
                        (use pkg))))))

;; ------------ set up packages with basic configuration ---------------  

(local autopairs (pkg :windwp/nvim-autopairs))
(autopairs.config 
  (fn []
    (let [pairs (require :nvim-autopairs)]
      (pairs.setup))))

(local comment-nvim (pkg :numToStr/Comment.nvim))
(comment-nvim.config 
  (fn []
    (let [cmt (require :Comment)]
      (cmt.setup))))

(local bufferline (pkg :akinsho/bufferline.nvim))
(bufferline.branch :main)
(bufferline.config 
  (fn []
    (let [bl (require :bufferline)]
      (bl.setup {:options {:show_close_icon false}}))))

(local project (pkg :ahmedkhalf/project.nvim))
(project.requires :nvim-telescope/telescope.nvim)
(project.config 
  (fn []
    (let [prj (require :project_nvim)
          telescope (require :telescope)]
      (prj.setup {:manual_mode true})
      (telescope.load_extension :projects))))

(local indent-bl (pkg :lukas-reineke/indent-blankline.nvim))
(indent-bl.config 
  (fn []
    (let [bl (require :indent_blankline)]
      (bl.setup {:buftype_exclude [:terminal]
                 :filetype_exclude [:alpha]}))))

(local alpha (pkg :goolord/alpha-nvim))
(alpha.config 
  (fn []
    (let [a (require :alpha)
          dash (require :alpha.themes.dashboard)]
      (a.setup dash.config))))

(local which-key (pkg :folke/which-key.nvim))
(which-key.config 
  (fn []
    (let [wk (require :which-key)]
      (require :keys)
      (wk.setup {:key_labels {:<cr> :RET}}))))

(local gitsigns (pkg :lewis6991/gitsigns.nvim))
(gitsigns.config 
  (fn []
    (let [signs (require :gitsigns)]
      (signs.setup))))

(local tree (pkg :kyazdani42/nvim-tree.lua))
(tree.config 
  (fn []
    (let [tree (require :nvim-tree)]
      (tree.setup))))

(local zen (pkg :folke/zen-mode.nvim))
(zen.config 
  (fn []
    (let [zen (require :zen-mode)]
      (zen.setup))))

(local colorizer (pkg :norcalli/nvim-colorizer.lua))
(colorizer.config 
  (fn []
    (let [colors (require :colorizer)]
      (colors.setup))))

(local org (pkg :nvim-orgmode/orgmode))
(org.config 
  (fn []
    (let [org (require :orgmode)]
      (org.setup))))

(local parinfer (pkg :eraserhd/parinfer-rust))
(parinfer.run "cargo build --release")

(local sandwich (pkg :machakann/vim-sandwich))
(sandwich.config 
  (fn []
    (vim.cmd "runtime macros/sandwich/keymap/surround.vim")))

(local lualine (pkg :nvim-lualine/lualine.nvim))
(lualine.config
  (fn []
    (require :evil_lualine)))

(local vim-kitty-nav (pkg :knubie/vim-kitty-navigator))
(vim-kitty-nav.setup
  (fn []
    (tset _G :kitty_navigator_no_mappings 1)))
(vim-kitty-nav.config
  (fn []
    (Nmap :<A-j> ":KittyNavigateDown<cr>")
    (Nmap :<A-k> ":KittyNavigateUp<cr>")
    (Nmap :<A-h> ":KittyNavigateLeft<cr>")
    (Nmap :<A-l> ":KittyNavigateRight<cr>")))
(vim-kitty-nav.run "cp ./*.py ~/.config/kitty/")

(local nvim-web-devicons (pkg :kyazdani42/nvim-web-devicons))
(nvim-web-devicons.config
  (fn []
    (let [icons (require :nvim-web-devicons)]
      (icons.setup {:override {:fnl {:icon "🥬" :name :Fennel}}}))))

;; --------------------- set up plugins with packer --------------------------

(use-packages
  :wbthomason/packer.nvim
  :lewis6991/impatient.nvim
  :nvim-lua/plenary.nvim
  :L3MON4D3/LuaSnip
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
  (lualine.to-params)
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
