(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :neovim/nvim-lspconfig
  {:requires [:williamboman/nvim-lsp-installer
              :folke/which-key.nvim
              :hrsh7th/cmp-nvim-lsp]
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
     (local lspconf (require :lspconfig))
     (local cmp-lsp (require :cmp_nvim_lsp))
     (local installer (require :nvim-lsp-installer))
     (local capabilities (cmp-lsp.update_capabilities
                           (vim.lsp.protocol.make_client_capabilities)))

     (local default-servers [:pyright
                             :bashls
                             :emmet_ls
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
                        ;; (tset opts :cmd [:solargraph :stdio])
                        opts)))

     (fn setup-servers []
       (each [_ server (ipairs default-servers)]
         (let [server (. lspconf server)]
          (server.setup {:on_attach on-attach
                         :capabilities capabilities})))
       (setup-lua)
       (setup-solargraph))
         

     (installer.setup)
     (setup-servers))})
