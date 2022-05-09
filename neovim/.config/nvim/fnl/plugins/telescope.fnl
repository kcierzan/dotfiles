(local package (. (require :utils) :package))

(local telescope (package :nvim-telescope/telescope.nvim))

(telescope.requires :nvim-telescope/telescope-fzf-native.nvim)

(telescope.run :make)

(telescope.config 
  (fn []
    (let [tscope (require :telescope)]
      (tscope.setup {:defaults 
                     {:vimgrep_arguments [:rg
                                          :--no-heading
                                          :--color=never
                                          :--with-filename
                                          :--line-number
                                          :--column
                                          :--smart-case
                                          :--hidden
                                          :--trim
                                          :--glob
                                          "!.git/"]}
                     :pickers
                     {:find_files 
                      {:find_command [:fd
                                      :--type
                                      :f
                                      :--hidden
                                      :--strip-cwd-prefix
                                      :--exclude
                                      "*.pyc"
                                      :--exclude
                                      ".git/"
                                      :--exclude
                                      "*.jpg"
                                      :--exclude
                                      "*.png"
                                      :--exclude
                                      "*.ttf"
                                      :--exclude
                                      "*.gif"
                                      :--exclude
                                      "*.zip"]}}
                     :extensions 
                     {:fzf 
                      {:fuzzy true
                       :override_generic_sorter true
                       :override_file_sorter true
                       :case_mode :smart_case}}})
      (tscope.load_extension :fzf))))

(telescope.to-params)
