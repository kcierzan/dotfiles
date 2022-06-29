;; _____       __________ ________      ______
;; ___(_)_________(_)_  /____  __/_________  /
;; __  /__  __ \_  /_  __/__  /_ __  __ \_  / 
;; _  / _  / / /  / / /____  __/ _  / / /  /  
;; /_/  /_/ /_//_/  \__/(_)_/    /_/ /_//_/   

(local home-dir (os.getenv :HOME))
                                           
(let [options {:autowriteall true
               :backup false
               :clipboard :unnamedplus
               :cmdheight 2
               :completeopt [:menu :menuone :noselect]
               :conceallevel 0
               :cursorline true
               :expandtab true
               :fileencoding :utf-8
               :hlsearch true
               :ignorecase true
               :mouse :a
               :number true
               :numberwidth 4
               :pumheight 8
               :relativenumber false
               :scrolloff 8
               :shiftround true
               :shiftwidth 2
               :showmode false
               :showtabline 2
               :sidescrolloff 8
               :signcolumn :yes
               :smartcase true
               :smartindent true
               :splitbelow true
               :splitright true
               :swapfile false
               :tabstop 2
               :termguicolors true
               :timeoutlen 500
               :undodir (.. home-dir "/.undo")
               :undofile true
               :undolevels 100_000
               :updatetime 300
               :wrap true
               :writebackup false
               :guicursor "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor"}]
     (each [k v (pairs options)]
      (tset vim.opt k v)))

(let [vars {:python3_host_prog (.. home-dir "/.asdf/installs/python/3.10.4/bin/python")
            :tex_flavor :latex
            :mapleader " "
            :maplocalleader "+"
            :user_emmet_settings {:javascript.jsx {:extends :jsx}}}]
     (each [k v (pairs vars)]
      (tset vim.g k v)))

(vim.opt.shortmess:append :c)

(vim.cmd "set whichwrap+=<,>,[,],h,l")
(vim.cmd "set iskeyword+=-")
(vim.cmd "set formatoptions-=cro")

(let [signs {:Error " "
             :Warn " " 
             :Hint " " 
             :Info " "}]
     (each [status icon (pairs signs)]
      (let [hl (.. :DiagnosticSign status)]
       (vim.fn.sign_define hl {:text icon 
                               :texthl hl 
                               :numhl hl}))))

;; TODO: move these to a module
(tset _G :Nmap (fn [key cmd]
                 (vim.api.nvim_set_keymap 
                   :n key cmd {:noremap true :silent true})))

(tset _G :Xmap (fn [key cmd]
                 (vim.api.nvim_set_keymap 
                   :x key cmd {:noremap true :silent true})))

;; Bootstrap packer
(let [packer-path (.. (vim.fn.stdpath :data) "/site/pack/packer/start/packer.nvim")
      packer-installed? (= (vim.fn.empty (vim.fn.glob packer-path)) 0)]
  (if packer-installed?
    (do
      (pcall require :impatient)
      (pcall require :plugin.packer_compiled))
    (vim.fn.system [:git 
                    :clone 
                    :--depth 
                    "1" 
                    :https://github.com/wbthomason/packer.nvim 
                    packer-path])))

;; Set up plugins if we have packer installed
;; TODO: set up automatic plugin installation if we just bootstrapped packer
(let [(pack-installed? packer) (pcall require :packer)
      util (require :packer.util)]
  (when pack-installed?
    (packer.init {:compile_path (util.join_paths
                                  (vim.fn.stdpath :config)
                                  :lua
                                  :plugin
                                  :packer_compiled.lua)})
    (require :packages)))

;; auto write 
(let [group-id (vim.api.nvim_create_augroup :AutoWrite {:clear true})]
  (vim.api.nvim_create_autocmd [:BufEnter :FocusLost]
                               {:pattern "*"
                                :command :update
                                :group group-id}))

(vim.cmd "colorscheme thematic")
