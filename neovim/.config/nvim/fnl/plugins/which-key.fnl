{:repo :folke/which-key.nvim
 :config (fn []
           (import-macros {: require*} :macros)
           (require* nmap [:lib :nmap]
                     xmap [:lib :xmap]
                     vim-global [:lib :vim-global]
                     neovide? [:lib :neovide?]
                     key-bindings [:key-bindings]
                     wk [:which-key])

           (wk.setup {:key_labels {:<cr> :RET}})
           (wk.register key-bindings)

           (nmap "grl" "<cmd>diffget<cr>")
           (nmap "grh" "<cmd>diffput<cr>")
           (xmap "grl" "<cmd>diffget<cr>")
           (xmap "grh" "<cmd>diffput<cr>")

           (when (neovide?)
            (nmap "<C-->" "<cmd>lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * (1/1.1)<cr>")
            (nmap "<C-=>" "<cmd>lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * 1.1<cr>")
            (nmap "<M-j>" "<C-w>j")
            (nmap "<M-k>" "<C-w>k")
            (nmap "<M-h>" "<C-w>h")
            (nmap "<M-l>" "<C-w>l"))

           (nmap "L" "<Nop>")
           (nmap "H" "<Nop>")
           (xmap "L" "<Nop>")
           (xmap "H" "<Nop>")

           (nmap "L" "g_")
           (nmap "H" "^")
           (xmap "L" "g_")
           (xmap "H" "^")

           (nmap "<C-l>" "<cmd>bnext<cr>")
           (nmap "<C-h>" "<cmd>bprev<cr>"))}
