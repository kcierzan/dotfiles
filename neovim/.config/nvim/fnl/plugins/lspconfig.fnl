{:repo :neovim/nvim-lspconfig
 :requires [:williamboman/mason-lspconfig.nvim
            :folke/which-key.nvim
            :hrsh7th/cmp-nvim-lsp]
 :setup (fn []
          (let [signs {:Error " "
                        :Warn " "
                        :Hint " "
                        :Info " "}]
            (each [status icon (pairs signs)]
              (let [hl (.. :DiagnosticSign status)]
                (vim.fn.sign_define hl {:text icon
                                        :texthl hl
                                        :numhl hl})))))
 :config (fn []
           (import-macros {: require*} :macros)
           (require* lspconf [:lspconfig]
                     cmp-lsp [:cmp_nvim_lsp])

           (vim.diagnostic.config {:virtual_text false
                                   :signs true
                                   :underline true})
              
           (local capabilities (cmp-lsp.default_capabilities
                                 (vim.lsp.protocol.make_client_capabilities)))

           (local default-servers [:pyright
                                   :bashls
                                   :tsserver
                                   :jsonls
                                   :rust_analyzer
                                   :svelte
                                   :dockerls
                                   :clojure_lsp])

           (fn on-attach [_ bufnr]
             (let [wk (require :which-key)]
               (wk.register {:g {:d ["<cmd>lua vim.lsp.buf.definition()<cr>" "go to definition"]
                                 :D ["<cmd>lua vim.lsp.buf.declaration()<cr>" "go to declaration"]
                                 :h ["<cmd>lua vim.lsp.buf.hover()<cr>" "get hover info"]}}
                           {:buffer bufnr})))

           (fn configure-lsp [lsp-name config]
             (let [server (. lspconf lsp-name)
                   opts {:on_attach on-attach
                         :capabilities capabilities}
                   opts (config opts)]
               (server.setup opts)))

           (fn setup-lua []
             (configure-lsp :sumneko_lua
                            (fn [opts]
                              (tset opts :settings {:Lua {:diagnostics {:globals [:vim :awesome :hs]}}})
                              opts)))

           (fn setup-solargraph []
             (configure-lsp :solargraph
                            (fn [opts]
                              (tset opts :settings {:solargraph {:diagnostics true}})
                              (tset opts :cmd [:bundle :exec :solargraph :stdio])
                              opts)))

           (fn setup-ruby-lsp []
             (configure-lsp :ruby_ls
                            (fn [opts]
                              (tset opts :init_options {:enabledFeatures [:codeActions
                                                                          :diagnostics
                                                                          :documentHighlights
                                                                          :documentSymbols
                                                                          :formatting
                                                                          :inlayHint]})
                              ;; Neovim does not support the latest version of the language server protocol
                              ;; that allows for language server update pushing. This is a workaround
                              ;; that sets up a callback to poll ruby-lsp for diagnostic info.
                              (tset opts :on_attach (fn [client bufnr]
                                                      (on-attach client bufnr)
                                                      (vim.api.nvim_create_autocmd 
                                                        [:BufEnter :BufWritePre :CursorHold]
                                                        {:buffer bufnr
                                                         :callback 
                                                         (fn []
                                                           (let [params (vim.lsp.util.make_text_document_params bufnr)]
                                                             (client.request :textDocument/diagnostic
                                                                             {:textDocument params}
                                                                             (fn [err result]
                                                                               (if (not err)
                                                                                 (vim.lsp.diagnostic.on_publish_diagnostics nil 
                                                                                                                            (vim.tbl_extend 
                                                                                                                              :keep 
                                                                                                                              params 
                                                                                                                              {:diagnostics result.items}) 
                                                                                                                            {:client_id client.id}))))))})))
                                                      
                              (tset opts :cmd [:bundle :exec :ruby-lsp])
                              opts)))

           (fn setup-elixirls []
             (configure-lsp :elixirls
                            (fn [opts]
                              (tset opts :cmd [:elixir-ls])
                              (tset opts :settings {:elixirls {:diagnostics true}})
                              opts)))

           (fn setup-emmet []
             (configure-lsp :emmet_ls
                            (fn [opts]
                              (tset opts :filetypes [:html :typescriptreact :javascriptreact :css :sass :scss :less :eruby :heex])
                              opts)))

           (fn setup-servers []
             (each [_ server (ipairs default-servers)]
               (let [server (. lspconf server)]
                (server.setup {:on_attach on-attach
                               :capabilities capabilities})))
             (setup-lua)
             (setup-elixirls)
             (setup-emmet)
             (setup-ruby-lsp)
             (setup-solargraph))

           (setup-servers))}
