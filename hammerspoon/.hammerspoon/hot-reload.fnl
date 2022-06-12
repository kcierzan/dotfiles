(fn is-lua-or-fennel? [file]
  (let [extension (file:sub -4)]
    (or (= extension ".lua") (= extension ".fnl"))))

(fn reload-config [files]
  (var should-reload false)
  (each [_ file (pairs files)]
    (if (is-lua-or-fennel? file)
      (set should-reload true)))
  (if should-reload
    (hs.reload)))

(let [home (os.getenv :HOME)
      config-dir (.. home "/.hammerspoon/")
      watcher (hs.pathwatcher.new config-dir reload-config)]
  (watcher:start))

