(fn opt [option value]
  (tset vim.opt option value))

(fn colorscheme [colorscheme]
  (vim.cmd (.. :colorscheme " " colorscheme)))

(fn nil? [value]
  (= value nil))

(fn number? [val]
  (= (type val) :number))

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

(fn positive? [val]
  (> val 0))

(fn present? [value]
  (if (number? value)
    true
    (and (string? value) (positive? (length value)))
    true
    (function? value)
    true
    (and (table? value) (positive? (length value)))
    true
    (and (boolean? value) (= value true))
    true
    false))

(fn vim-global [variable value]
  (tset vim.g variable value))

(fn file-exists? [path]
  (= (vim.fn.empty (vim.fn.glob path)) 0))

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

{: boolean?
 : colorscheme
 : file-exists?
 : function?
 : git-workspace?
 : merge
 : nil?
 : nmap
 : nonzero?
 : opt
 : number?
 : string?
 : table?
 : vim-global
 : window-wide?
 : xmap}
