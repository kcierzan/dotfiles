(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :nvim-treesitter/nvim-treesitter
  {:requires :nvim-orgmode/orgmode
   :run ":TSUpdate"
   :config
   (fn []
     (let [org (require :orgmode)
           configs (require :nvim-treesitter.configs)]
       (org.setup_ts_grammar)
       (configs.setup {:ensure_installed [:bash
                                          :c
                                          :clojure
                                          :cmake
                                          :commonlisp
                                          :cpp
                                          :css
                                          :dart
                                          :dockerfile
                                          :fennel
                                          :fish
                                          :go
                                          :haskell
                                          :html
                                          :java
                                          :julia
                                          :lua
                                          :make
                                          :markdown
                                          :org
                                          :php
                                          :python
                                          :ruby
                                          :rust
                                          :scheme
                                          :scss
                                          :svelte
                                          :typescript
                                          :vim
                                          :yaml]
                       :sync_install false
                       :highlight {:enable true}})))})
