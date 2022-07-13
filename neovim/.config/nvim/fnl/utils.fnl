(fn opt [option value]
  (tset vim.opt option value))

(fn colorscheme [colorscheme]
  (vim.cmd (.. :colorscheme " " colorscheme)))

(fn vim-global [variable value]
  (tset vim.g variable value))

(fn file-exists? [path]
  (= (vim.fn.empty (vim.fn.glob path)) 0))

(fn number? [val]
  (= (type val) :number))

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
    (and git-dir (> (length git-dir) 0) (> (length filepath) (length git-dir)))))

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

{: opt
 : colorscheme
 : vim-global
 : git-workspace?
 : window-wide?
 : file-exists?
 : nmap
 : merge
 : xmap}
