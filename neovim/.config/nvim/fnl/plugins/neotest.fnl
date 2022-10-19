(local def-pkg (. (require :pkg-utils) :def-pkg))

(def-pkg
  :nvim-neotest/neotest
  {:requires [:olimorris/neotest-rspec]
   :config
    (fn []
      (let [neotest (require :neotest)]
        (neotest.setup {:adapters [(require :neotest-rspec)]
                        :status {:signs false
                                 :virtual_text true}})))})
