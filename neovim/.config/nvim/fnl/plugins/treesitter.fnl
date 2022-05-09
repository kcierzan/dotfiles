(local pkg (. (require :utils) :package))
(local treesitter (pkg :nvim-treesitter/nvim-treesitter))

(treesitter.requires :nvim-orgmode/orgmode)

(treesitter.run ":TSUpdate")

(treesitter.config (fn []
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
                                       :highlight {:enable true}}))))

(treesitter.to-params)
