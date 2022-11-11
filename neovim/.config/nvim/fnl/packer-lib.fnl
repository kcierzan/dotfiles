(import-macros {: require*} :macros)
(require* file-exists? [:lib :file-exists?]
          first [:lib :first]
          second [:lib :second]
          tail [:lib :second]
          merge [:lib :merge]
          vals [:lib :vals])

(fn clone-packer! [path]
  (vim.fn.system [:git
                  :clone
                  :--depth
                  "1"
                  :https://github.com/wbthomason/packer.nvim
                  path]))

(fn bootstrap-packer! []
  "bootstrap packer and return whether it needed to be bootstrapped"
  (let [packer-path (.. (vim.fn.stdpath :data) "/site/pack/packer/start/packer.nvim")
        ?packer-installed (file-exists? packer-path)]
    (if ?packer-installed
      (pcall require :plugin.packer_compiled)
      (clone-packer! packer-path))
    (not ?packer-installed)))

(fn initialize-packer! [packages]
  "init packer, startup packer, and install plugins if we just installed packer"
  (let [util (require :packer.util)
        packer (require :packer)]
    (packer.init {:compile_path (util.join_paths
                                  (vim.fn.stdpath :config)
                                  :lua
                                  :plugin
                                  :packer_compiled.lua)})
    (packer.startup (fn [use]
                      (each [_ pkg (ipairs packages)]
                        (use pkg))))))

(fn sync-packages! []
  (vim.cmd :PackerSync))

(fn to-use-args [plugins]
  (icollect [_ pkg (ipairs plugins)]
    (let [args {}]
      (tset args 1 pkg.repo)
      (tset pkg :repo nil)
      (merge args pkg))))

(fn use-plugins! [plugins]
  (fn []
    (let [?sync-packages (bootstrap-packer!)]
      (initialize-packer! (to-use-args plugins))
      (when ?sync-packages
        (sync-packages!)))))

{: use-plugins!}
