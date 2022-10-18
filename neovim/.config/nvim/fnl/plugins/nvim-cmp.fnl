(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :hrsh7th/nvim-cmp
  {:requires [:onsails/lspkind.nvim]
   :config
    (fn []
      (import-macros {: require*} :macros)
      (require* cmp [:cmp]
                luasnip [:luasnip]
                lspkind [:lspkind]
                nil? [:utils :nil?]
                nonzero? [:utils :nonzero?])

      (local compare cmp.config.compare)
      (local border [["╭" :CmpBorder]
                     ["─" :CmpBorder]
                     ["╮" :CmpBorder]
                     ["│" :CmpBorder]
                     ["╯" :CmpBorder]
                     ["─" :CmpBorder]
                     ["╰" :CmpBorder]
                     ["│" :CmpBorder]])

      (let [autopairs (require :nvim-autopairs.completion.cmp)]
        (cmp.event:on :confirm_done (autopairs.on_confirm_done {:map_char {:tex ""}})))

      (fn has-words-before? []
        (let [[line col] (vim.api.nvim_win_get_cursor 0)
              before (vim.api.nvim_buf_get_lines 0 (- line 1) line true)
              lines-before (-> (. before 1)
                               (: :sub col col)
                               (: :match "%s"))]
          (and (nonzero? col) (nil? lines-before))))

      (fn tab-func [fallback]
        (if (cmp.visible)
          (cmp.select_next_item)
          (luasnip.expand_or_jumpable) ;; else if
          (luasnip.expand_or_jump)
          (has-words-before?) ;; else if
          (cmp.complete)
          ;; else
          (fallback)))

      (fn s-tab-func [fallback]
        (if (cmp.visible)
          (cmp.select_prev_item)
          (luasnip.jumpable -1)
          (luasnip.jump -1)
          (fallback)))

      (fn ctrl-n [fallback]
        (if (luasnip.expand_or_jumpable)
          (luasnip.expand_or_jump)
          (fallback)))

      (fn ctrl-p [fallback]
        (if (luasnip.expand_or_jumpable)
          (luasnip.jump -1)
          (fallback)))

      (local mapping {"<Tab>" (cmp.mapping tab-func [:i :s :c])
                      "<S-Tab>" (cmp.mapping s-tab-func [:i :s :c])
                      "<CR>" (cmp.mapping.confirm {:select false})
                      "<C-n>" (cmp.mapping ctrl-n [:i :s :c])
                      "<C-p>" (cmp.mapping ctrl-p [:i :s :c])})

      (fn telescope-buffer? []
        (= vim.bo.ft :TelescopePrompt))

      (fn popup-buffer? []
        (string.find (vim.api.nvim_buf_get_name 0) :s_popup:/))

      (fn comment? []
        (let [lnum (vim.fn.line ".")
              col (math.min lnum (length (vim.fn.getline ".")))]
          (each [_ syn-id (ipairs (vim.fn.synstack lnum col))]
            (let [syn-id (vim.fn.synIDtrans syn-id)]
              (= (vim.fn.synIDattr syn-id :name) :Comment)))))

      (fn enabled? []
        (not (or (telescope-buffer?) (popup-buffer?) (comment?))))

      (fn snippet-expand [args]
        (luasnip.lsp_expand args.body))

      (local sources [{:name :buffer
                       :priority 7
                       :keyword_length 3}
                      {:name :path
                       :priority 5}
                      {:name :rg
                       :priority 6}
                      {:name :calc
                       :priority 4}
                      {:name :nvim_lsp
                       :priority 9}
                      {:name :luasnip
                       :priority 8}
                      {:name :nvim_lsp_signature_help
                       :priority 10}])


      (fn format-menu [entry vim-item]
        (let [kind ((lspkind.cmp_format {:mode :symbol_text :maxwidth 50}) entry vim-item)
              strings (vim.split kind.kind "%s" {:trimempty true})]
          (tset kind :kind (.. " " (. strings 1) " "))
          (tset kind :menu (.. "    [" (. strings 2) "]"))
          kind))

      (cmp.setup {:window {:completion {:border border
                                        :winhighlight "Normal:Normal,FloatBorder:Normal,CursorLine:PmenuSel,Search:None"}
                           :documentation (cmp.config.window.bordered)}
                  :snippet {:expand snippet-expand}
                  :mapping mapping
                  :sources sources
                  :enabled enabled?
                  :completion {:keyword_length 2}
                  :formatting {:fields [:kind
                                        :abbr
                                        :menu]
                               :format format-menu}
                  :sorting {:priority_weight 1.0
                            :comparators [compare.locality
                                          compare.recently_used
                                          compare.score
                                          compare.offset
                                          compare.order]}
                  :experimental {:ghost_text true}})

      (cmp.setup.cmdline ":" {:sources [{:name :cmdline
                                         :group_index 1}
                                        {:name :cmdline_history
                                         :group_index 2}]
                              :mapping mapping})

      (cmp.setup.cmdline "/" {:sources [{:name :cmdline_history}
                                        {:name :buffer}]
                              :mapping mapping})

      ((. (require :luasnip.loaders.from_vscode) :lazy_load)))})
