(local package (. (require :utils) :package))
(local installer (package :williamboman/nvim-lsp-installer))

(installer.config
  (fn []
    (let [installer (require :nvim-lsp-installer)
          required [:pyright
                    :solargraph
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
      (installer.setup {:ensure_installed required :automatic_installation true}))))

(installer.to-params)
