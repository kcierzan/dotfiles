{:repo :mhartington/formatter.nvim
 :config (fn []
           (let [util (require :formatter.util)
                 formatter (require :formatter)]
             (formatter.setup {:logging true
                               :log_level vim.log.levels.WARN
                               :filetype {:ruby (. (require :formatter.filetypes.ruby) :rubocop)}})))}
