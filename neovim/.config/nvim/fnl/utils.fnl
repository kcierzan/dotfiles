(local M {})

(fn M.package [repo]
  (let [self {}
        to-params (fn []
                    (tset self 1 repo)
                    self)
        requires (fn [...]
                   (tset self :requires [...])
                   (to-params))
        config (fn [config-func]
                 (tset self :config config-func)
                 (to-params))
        run (fn [run-str]
              (tset self :run run-str)
              (to-params))
        setup (fn [setup-func]
                (tset self :setup setup-func)
                (to-params))
        branch (fn [branch-str]
                 (tset self :branch branch-str)
                 (to-params))
        as (fn [as-str]
             (tset self :as as-str)
             (to-params))]
        
    {: requires
     : config
     : run
     : setup
     : branch
     : as
     : to-params}))

M
