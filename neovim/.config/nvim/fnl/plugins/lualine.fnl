{:repo :nvim-lualine/lualine.nvim
 :config (fn []
          (local {: git-workspace?
                  : buffer-not-empty?
                  : window-wide?} (require :lib))
          (local lualine (require :lualine))

          (fn inkd-lualine-colors []
            (let [file-path (.. (os.getenv :INKD_DIR) :lualine.ink.lua)]
              (if (io.open file-path :r)
                (dofile file-path)
                (print "inkd theme not found! Make sure INKD_DIR is set and run `ink colors`"))))

          (local colors (inkd-lualine-colors))
          (local config {:options {:component_separators ""
                                   :section_separators ""
                                   :globalstatus true
                                   :theme {:normal {:c {:fg colors.fg
                                                        :bg colors.bg}}
                                           :inactive {:c {:fg colors.fg
                                                          :bg colors.bg}}}}
                         :sections {:lualine_a {}
                                    :lualine_b {}
                                    :lualine_y {}
                                    :lualine_z {}
                                    :lualine_c {}
                                    :lualine_x {}}
                         :inactive_sections {:lualine_a {}
                                             :lualine_b {}
                                             :lualine_y {}
                                             :lualine_z {}
                                             :lualine_c {}
                                             :lualine_x {}}})

          (fn component [name properties]
            (let [component {}]
              (tset component 1 name)
              (each [k v (pairs properties)]
                (tset component k v))
              component))

          (fn ins-left [name properties]
            (let [component (component name properties)]
              (table.insert config.sections.lualine_c component)))

          (fn ins-right [name properties]
            (let [component (component name properties)]
              (table.insert config.sections.lualine_x component)))

          (fn edit-mode []
            (let [cube ""
                  hex-empty ""
                  hex-full ""
                  mode (vim.fn.mode)
                  modes {:n :NORMAL
                         :no "OPERATOR PENDING"
                         :v :VISUAL
                         :V "VISUAL LINE"
                         "^V" "VISUAL BLOCK"
                         :s :SELECT
                         :S "SELECT LINE"
                         "^S" "SELECT BLOCK"
                         :i :INSERT
                         :ic "INSERT COMPLETION"
                         :ix "INSERT COMPLETION"
                         :R :REPLACE
                         :Rv "VIRTUAL REPLACE"
                         :c :COMMAND
                         :cv "VIM EX"
                         :ce :EX
                         :r "HIT ENTER"
                         "r?" :CONFIRM
                         "!" :SHELL
                         :t :TERMINAL}]
              (var mode-str "")
              (if (or (= mode :i) (= mode :ic) (= mode :ix))
                (set mode-str cube)
                (or (= mode :n) (= mode :no) (= mode :t) (= mode "!"))
                (set mode-str hex-empty)
                (set mode-str hex-full))
              (.. mode-str " " (. modes mode))))

          (fn get-lsp-for-buffer [clients buf-ft]
            (var name :NONE)
            (each [_ client (ipairs clients) :until (not= name :NONE)]
              (let [filetypes client.config.filetypes
                    buffer-for-ft? (not= (vim.fn.index filetypes buf-ft) -1)]
                (when (and filetypes buffer-for-ft?)
                  (set name client.name))))
            name)

          (fn lsp-name []
            (let [buf-ft (vim.api.nvim_buf_get_option 0 :filetype)
                  clients (vim.lsp.get_active_clients)
                  clients? (fn [clnts] (and (not= (next clnts) nil) clnts))]
              (-?> clients (clients?) (get-lsp-for-buffer buf-ft))))

          (fn show-lsp-info? []
            (let [clients (vim.lsp.get_active_clients)]
              (and (window-wide?) (not= (next clients) nil))))

          (fn edit-mode-colors []
            (let [colors {:n colors.blue
                          :i colors.green
                          :v colors.violet
                          "^V" colors.blue
                          :V colors.blue
                          :c colors.magenta
                          :no colors.red
                          :s colors.orange
                          :S colors.orange
                          "^S" colors.orange
                          :ic colors.yellow
                          :R colors.violet
                          :cv colors.red
                          :ce colors.red
                          :r colors.cyan
                          :rm colors.cyan
                          "r?" colors.cyan
                          "!" colors.red
                          :t colors.red}]
              {:fg (. colors (vim.fn.mode))
               :gui :bold}))

          (fn progress-bar []
            (let [blocks ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"]
                  curr-line (. (vim.api.nvim_win_get_cursor 0) 1)
                  lines (vim.api.nvim_buf_line_count 0)
                  block-index (+ 1 (math.floor (* (/ curr-line lines) 7)))]
              (string.rep (. blocks block-index) 2)))

;; -------------  LEFT HAND SECTIONS -----------------------

          (ins-left (fn [] "▊")
                    {:color {:fg colors.blue}
                     :padding {:left 0 :right 1}})

          (ins-left edit-mode
                    {:color edit-mode-colors
                     :padding {:left 0
                               :right 1}})

          (ins-left :filetype
                    {:icon_only true
                     :colored true
                     :padding {:left 0 :right 1}})

          (ins-left :filename
                    {:cond buffer-not-empty?
                     :path 1
                     :color {:fg colors.fg}
                     :padding {:left 0 :right 0}})

;; -------------  RIGHT HAND SECTIONS -----------------------

          (ins-right :diagnostics
                     {:sources [:nvim_diagnostic]
                      :symbols {:error " "
                                :warn " "
                                :info " "}
                      :diagnostics_color {:color_error {:fg colors.red}
                                          :color_warn {:fg colors.yellow}
                                          :color_info {:fg colors.cyan}}})
          (ins-right lsp-name
                     {:icon "力"
                      :color {:fg colors.cyan
                              :gui :bold}
                      :cond show-lsp-info?})

          (ins-right :branch
                     {:icon ""
                      :color {:fg colors.violet
                              :gui :bold}
                      :cond git-workspace?})

          (ins-right :diff
                     {:symbols {:added " "
                                :modified "柳"
                                :removed " "}
                      :diff_color {:added {:fg colors.green}
                                   :modified {:fg colors.orange}
                                   :removed {:fg colors.red}}
                      :cond window-wide?})

          (ins-right :fileformat
                     {:icons_enabled true
                      :color {:fg colors.blue
                              :gui :bold}
                      :cond window-wide?})

          (ins-right progress-bar
                     {:color {:fg colors.blue :bg colors.bg}
                      :padding {:right 0 :left 1}
                      :cond window-wide?})

          (ins-right :progress
                     {:color {:fg colors.blue :bg colors.bg}
                      :padding {:right 0 :left 1}
                      :cond window-wide?})

          (ins-right (fn [] "▊")
                     {:color {:fg colors.blue}
                      :padding {:left 1}})

          (lualine.setup config))}
