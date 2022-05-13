(local package (. (require :utils) :package))
(local lspconfig (package :neovim/nvim-lspconfig))

(lspconfig.requires :folke/which-key.nvim :ms-jpq/coq_nvim)

(lspconfig.config
  (fn []
    (let [servers [:pyright 
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
                   :elixirls]
          on-attach (fn [_ bufnr]
                      (let [wk (require :which-key)]
                        (wk.register {:g {:d ["<cmd>lua vim.lsp.buf.definition()<cr>" "go to definition"]
                                          :D ["<cmd>lua vim.lsp.buf.declaration()<cr>" "go to declaration"]
                                          :h ["<cmd>lua vim.lsp.buf.hover()<cr>" "get hover info"]}} 
                                     {:buffer bufnr})))
          coq (require :coq)
          opts {:on_attach on-attach}
          coq-opts (coq.lsp_ensure_capabilities opts)]
      (each [_ lsp (ipairs servers)]
        (let [lspconf (require :lspconfig)
              server (. lspconf lsp)]
          (when (= server.name :sumneko_lua)
            (tset coq-opts :settings {:Lua {:diagnostics {:globals [:vim :awesome]}}}))
          (when (= server.name :solargraph)
            (tset coq-opts :settings {:solargraph {:diagnostics true}}))
            ;; (tset coq-opts :cmd ["bundle exec solargraph --stdio" "stdio"]))
          (server.setup coq-opts))))))

(lspconfig.to-params)
