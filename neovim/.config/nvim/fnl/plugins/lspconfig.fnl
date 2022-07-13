(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :neovim/nvim-lspconfig
  {:requires :folke/which-key.nvim
   :setup
    (fn []
      (let [signs {:Error " "
                    :Warn " "
                    :Hint " "
                    :Info " "}]
        (each [status icon (pairs signs)]
          (let [hl (.. :DiagnosticSign status)]
            (vim.fn.sign_define hl {:text icon
                                    :texthl hl
                                    :numhl hl})))))
   :config
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
           cmp-lsp (require :cmp_nvim_lsp)
           capabilities (cmp-lsp.update_capabilities (vim.lsp.protocol.make_client_capabilities))]
       (each [_ lsp (ipairs servers)]
         (let [lspconf (require :lspconfig)
               server (. lspconf lsp)
               opts {:on_attach on-attach
                     :capabilities capabilities}]
           (if (= server.name :sumneko_lua)
             (tset opts :settings {:Lua {:diagnostics {:globals [:vim :awesome]}}}))
           (if (= server.name :solargraph)
             (do
               (tset opts :settings {:solargraph {:diagnostics true}})
               (tset opts :cmd ["bundle" "exec" "solargraph" "stdio"])))
           (server.setup opts)))))})
