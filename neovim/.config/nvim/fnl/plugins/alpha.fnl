{:repo :goolord/alpha-nvim
 :config (fn []
           (let [alpha (require :alpha)
                 dash (require :alpha.themes.dashboard)
                 headers (. (require :headers) :imgs)]
             (tset dash :section :header :val headers.saturn_plus)
             (tset dash :section :buttons :val
                   [(dash.button "e" "  New file" ":ene <BAR> startinsert <CR>")
                    (dash.button "SPC f f" "  Find file")
                    (dash.button "SPC f o" "  Recently opened files")
                    (dash.button "SPC f p" "  Recent projects")
                    (dash.button "SPC f t" "  Help Tags")
                    (dash.button "q" "  Quit" ":qa<CR>")])
             (let [title {:type :text
                          :opts {:position :center
                                 :hl :Type}
                          :val :NEOVIM}]
              (tset dash :config :layout
                    [{:type :padding
                      :val 2}
                     dash.section.header
                     {:type :padding
                      :val 2}
                     title
                     {:type :padding
                      :val 2}
                     dash.section.buttons])
              (alpha.setup dash.config))))}
