(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :williamboman/nvim-lsp-installer
  {:config
   (fn []
     (let [installer (require :nvim-lsp-installer)
           required [:pyright
                     :bashls
                     :emmet_ls
                     :tsserver
                     :jsonls
                     :sumneko_lua
                     :rust_analyzer
                     :svelte
                     :dockerls
                     :clojure_lsp
                     :elixirls]]
       (installer.setup {:automatic_installation false})))})
