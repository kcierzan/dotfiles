(local vim _G.vim) ; make the compiler happy

(fn opt [option value]
  (tset vim.opt option value))

(fn colorscheme [colorscheme]
  (vim.cmd (.. :colorscheme " " colorscheme)))

(fn nil? [value]
  (= value nil))

(fn number? [val]
  (= (type val) :number))

(fn keys [tbl]
  (icollect [k _ (pairs tbl)] k))

(fn vals [tbl]
  (icollect [_ v (pairs tbl)] v))

(fn args-keys [...]
  (fcollect [i -1 (length [...]) 2]
            (. [...] i)))

(fn args-values [...]
  (fcollect [i 0 (length [...]) 2]
            (. [...] i)))

(fn table? [val]
  (= (type val) :table))

(fn string? [val]
  (= (type val) :string))

(fn function? [val]
  (= (type val) :function))

(fn boolean? [val]
  (= (type val) :boolean))

(fn nonzero? [val]
  (not= val 0))

(fn zero? [val]
  (= val 0))

(fn positive? [val]
  (> val 0))

(fn head [list]
  [(. list 1)])

(fn tail [list]
  (let [[_ & tail] list]
    tail))

(fn first [list]
  (. list 1))

(fn second [list]
  (. list 2))

(fn last [list]
  (. list (length list)))

(fn butlast [list]
  (let [target []]
    (each [i v (ipairs list) &until (= i (length list))]
      (table.insert target v))
    target))

(fn size [tbl]
  "Returns the number of keys in a table, regardless of type"
  (accumulate [sum 0
               _ _ (pairs tbl)]
              (+ sum 1)))

(fn present? [value]
  "Rails-like boolean casting"
  (if (= value false)
    false
    (and (table? value) (zero? (size value)))
    false
    (= value "")
    false
    (nil? value)
    false
    true))
    
(fn reverse [tbl]
  (let [reversed []
        size (length tbl)]
    (each [i v (ipairs tbl)]
      (tset reversed (- size (- i 1)) v))
    reversed))

(fn vim-global [variable value]
  (tset vim.g variable value))

(fn merge [...]
  "merge an arbitrary number of tables, string keys are clobbered, sequential keys are appended"
  (let [target {}
        args [...]]
    (each [_ tbl (ipairs args)]
      (each [i value (pairs tbl)]
        (if (number? i)
          (table.insert target value)
          (tset target i value))))
    target))

(fn git-workspace? []
  (let [filepath (vim.fn.expand "%:p:h")
        git-dir (vim.fn.finddir ".git" (.. filepath ";"))]
    (and git-dir (positive? (length git-dir)) (> (length filepath) (length git-dir)))))

(fn file-exists? [path]
  (= (vim.fn.empty (vim.fn.glob path)) 0))

(fn split [str delim]
  (vim.fn.split str delim))

(fn module-files [dir]
  (let [fennel-files (split (vim.fn.glob (.. dir "/*\\.fnl")) "\n")
        lua-files (split (vim.fn.glob (.. dir "/*\\.lua")) "\n")]
    (merge fennel-files lua-files)))

(fn pp [tbl]
  (let [fennel (require :fennel)]
    (print (fennel.view tbl))))

(fn pretty-print [tbl prefix]
  (let [indent (if (nil? prefix) "" prefix)]
    (each [k v (pairs tbl)]
      (if (table? v)
        (do
          (print (.. indent k ":"))
          (pretty-print v (.. indent "  ")))
        (print (.. indent k ": " (tostring v)))))))

(fn export-module [fennel-module]
  (let [dir (.. (vim.fn.stdpath :config) "/fnl/" fennel-module)
        files (module-files dir)
        names-exts (icollect [_ path (ipairs files)]
                            (last (split path "/")))
        filenames (icollect [_ filename (ipairs names-exts)]
                            (let [name (first (split filename "\\."))]
                              (if (not= name "init") name)))]
    (collect [_ file (ipairs filenames)]
             file (require (.. fennel-module "." file)))))

(fn buffer-not-empty? []
  (not= (vim.fn.empty (vim.fn.expand "%:t")) 1))

(fn window-wide? []
  (> (vim.fn.winwidth 0) 85))

(fn nmap [key cmd]
  (vim.api.nvim_set_keymap
    :n key cmd {:noremap true :silent true}))

(fn xmap [key cmd]
  (vim.api.nvim_set_keymap
    :x key cmd {:noremap true :silent true}))

(fn unmap [mode key]
  (vim.api.nvim_del_keymap mode key))

(fn neovide? []
  (vim.fn.exists "g:neovide"))

{: boolean?
 : butlast
 : colorscheme
 : file-exists?
 : args-keys
 : args-values
 : first
 : export-module
 : function?
 : git-workspace?
 : head
 : second
 : last
 : merge
 : nil?
 : nmap
 : neovide?
 : unmap
 : nonzero?
 : opt
 : present?
 : pretty-print
 : reverse
 : number?
 : string?
 : table?
 : keys
 : split
 : vals
 : size
 : tail
 : vim-global
 : window-wide?
 : xmap
 : zero?}
