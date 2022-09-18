(local capslock (require :capslock))
(local watchers (require :fs-watchers))
(local windows (require :windows))

(tset hs.window :animationDuration 0.1)

(fn bind-key [modifiers key func]
  (hs.hotkey.bind modifiers key func nil func))

(bind-key [:ctrl :cmd] :H windows.nudge-focused-left)
(bind-key [:ctrl :cmd] :L windows.nudge-focused-right)
(bind-key [:ctrl :cmd] :J windows.nudge-focused-down)
(bind-key [:ctrl :cmd] :K windows.nudge-focused-up)

(bind-key [:shift :cmd] :H windows.focused-left-half)
(bind-key [:shift :cmd] :L windows.focused-right-half)
(bind-key [:shift :cmd] :J windows.focused-bottom-half)
(bind-key [:shift :cmd] :K windows.focused-top-half)

(bind-key [:cmd] :E windows.focused-center)
(bind-key [:shift :cmd] :E windows.toggle-between-sizes)
(bind-key [:shift :cmd] "[" windows.focused-to-previous-screen)
(bind-key [:shift :cmd] "]" windows.focused-to-next-screen)
(bind-key [:shift :cmd] :F windows.focused-fullscreen)
(bind-key [:shift :cmd] :G windows.toggle-gaps)

(capslock.setup!)
(watchers.reload-hs-on-change!)

(hs.alert.show "Config loaded")
