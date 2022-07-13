(local file-exists? (. (require :utils) :file-exists?))

(fn clone-packer! [path]
  (vim.fn.system [:git
                  :clone
                  :--depth
                  "1"
                  :https://github.com/wbthomason/packer.nvim
                  path]))

(fn use-packages [packages]
  (let [packer (require :packer)]
    (packer.startup (fn [use]
                      (each [_ pkg (ipairs packages)]
                        (use pkg))))))

(fn bootstrap-packer! []
  "bootstrap packer and return whether it needed to be bootstrapped"
  (let [packer-path (.. (vim.fn.stdpath :data) "/site/pack/packer/start/packer.nvim")
        ?packer-installed (file-exists? packer-path)]
    (if ?packer-installed
      (do
        (pcall require :impatient)
        (pcall require :plugin.packer_compiled))
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
    (use-packages packages)))

(fn sync-packages! []
  (vim.cmd :PackerSync))

(fn def-pkg [name props]
  (let [pkg {}]
    (tset pkg 1 name)
    (each [k v (pairs props)]
      (tset pkg k v))
    pkg))

{: def-pkg
 : initialize-packer!
 : bootstrap-packer!
 : sync-packages!}
