(local M {})

(fn M.opt [option value]
  (tset vim.opt option value))

(fn M.colorscheme [colorscheme]
  (vim.cmd (.. :colorscheme " " colorscheme)))

(fn M.vim-global [variable value]
  (tset vim.g variable value))

(fn M.bootstrap-packer []
  "bootstrap packer and return whether it needed to be bootstrapped"
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
                      packer-path]))
    (not packer-installed?)))

(fn M.initialize-packer [should-sync?]
  "init packer, startup packer, and install plugins if we just installed packer"
  (let [util (require :packer.util)
        packer (require :packer)]
    (packer.init {:compile_path (util.join_paths
                                  (vim.fn.stdpath :config)
                                  :lua
                                  :plugin
                                  :packer_compiled.lua)})
    (require :packages)
    (when should-sync?
      (vim.cmd :PackerSync))))

(fn M.package [repo]
  (let [self {}
        to-params (fn []
                    (tset self 1 repo)
                    self)
        requires (fn [...]
                   (tset self :requires [...])
                   (to-params))
        config (fn [config-func]
                 (tset self :config config-func)
                 (to-params))
        run (fn [run-str]
              (tset self :run run-str)
              (to-params))
        setup (fn [setup-func]
                (tset self :setup setup-func)
                (to-params))
        branch (fn [branch-str]
                 (tset self :branch branch-str)
                 (to-params))
        as (fn [as-str]
             (tset self :as as-str)
             (to-params))]
        
    {: requires
     : config
     : run
     : setup
     : branch
     : as
     : to-params}))

(fn M.use-packages [...]
  (let [packer (require :packer)
        args [...]]
    (packer.startup (fn [use]
                      (each [_ pkg (ipairs args)]
                        (use pkg))))))

(fn M.git-workspace? []
  (let [filepath (vim.fn.expand "%:p:h")
        git-dir (vim.fn.finddir ".git" (.. filepath ";"))]
    (and git-dir (> (length git-dir) 0) (> (length filepath) (length git-dir)))))

(fn M.buffer-not-empty? []
  (!= (vim.fn.empty (vim.fn.expand "%:t")) 1))

(fn M.window-wide? []
  (> (vim.fn.winwidth 0) 85))

(fn M.inkd-colors []
  (let [file-path (.. (os.getenv :INKD_DIR) :lualine.ink.lua)]
    (if (io.open file-path :r)
      (dofile file-path)
      (print "inkd theme not found! Make sure INKD_DIR is set and run `ink colors`"))))

(fn M.nmap [key cmd]
  (vim.api.nvim_set_keymap 
    :n key cmd {:noremap true :silent true}))

(fn M.xmap [key cmd]
  (vim.api.nvim_set_keymap 
    :x key cmd {:noremap true :silent true}))

M
