(require :caps-to-ctrl-esc)

(local windows (require :windows))

(tset hs.window :animationDuration 0.1)

(fn bind [modifiers key func]
  (hs.hotkey.bind modifiers key func nil func))

(bind [:ctrl :cmd] :H windows.nudge-left)
(bind [:ctrl :cmd] :L windows.nudge-right)
(bind [:ctrl :cmd] :J windows.nudge-down)
(bind [:ctrl :cmd] :K windows.nudge-up)

(bind [:shift :cmd] :H windows.left-half)
(bind [:shift :cmd] :L windows.right-half)
(bind [:shift :cmd] :J windows.bottom-half)
(bind [:shift :cmd] :K windows.top-half)

(bind [:cmd] :E windows.center)
(bind [:shift :cmd] :E windows.toggle-between-sizes)
(bind [:shift :cmd] "[" windows.send-to-previous-screen)
(bind [:shift :cmd] "]" windows.send-to-next-screen)
(bind [:shift :cmd] :F windows.fullscreen) 

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

(hs.alert.show "Config loaded")
