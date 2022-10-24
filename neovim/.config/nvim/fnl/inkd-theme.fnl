(import-macros {: require*} :macros)
(require* opt [:utils :opt]
          vim-global [:utils :vim-global])

(fn highlight [group color]
  (let [style (or (and color.style (.. "gui=" color.style)) "gui=NONE")
        fg (or (and color.fg (.. "guifg=" color.fg)) "guifg=NONE")
        bg (or (and color.bg (.. "guibg=" color.bg)) "guibg=NONE")
        sp (or (and color.sp (.. "guisp=" color.sp)) "")
        command (.. "highlight " group " " style " " fg " " bg " " sp)]
    (vim.cmd command)))

(fn groups []
  (let [theme-file (.. (os.getenv :INKD_DIR) :neovim.ink.lua)]
    (with-open [file-handle (io.open theme-file :r)]
               (if file-handle
                 (dofile theme-file)
                 (print "inkd theme not found! Make sure INKD_DIR is set and run `ink color <color> <shade>`")))))

(fn colorscheme []
  (vim.cmd "hi clear")
  (when (vim.fn.exists :syntax_on)
    (vim.cmd "syntax reset"))
  (opt :termguicolors true)
  (vim-global :colors_name :inkd)
  (each [group colors (pairs (groups))]
    (highlight group colors)))

(colorscheme)

{: colorscheme}
