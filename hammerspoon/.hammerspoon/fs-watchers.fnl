(fn lua-or-fennel-file? [file]
  (let [extension (file:sub -4)]
    (or (= extension ".lua") (= extension ".fnl"))))

(fn reload-config! [files]
  (var ?reload false)
  (each [_ file (pairs files)] :until (= ?reload true)
    (when (lua-or-fennel-file? file)
      (set ?reload true)))
  (when ?reload
    (hs.reload)))

(fn reload-hs-on-change! []
  (let [home (os.getenv :HOME)
        config-dir (.. home "/.hammerspoon/")
        watcher (hs.pathwatcher.new config-dir reload-config!)]
    (watcher:start)))
 
{: reload-hs-on-change!}
