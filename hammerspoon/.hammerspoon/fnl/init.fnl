(local capslock (require :fnl.capslock))
(local watchers (require :fnl.fs-watchers))
(local wm (require :fnl.wm))

(tset hs.window :animationDuration 0.1)

(fn bind-key [modifiers key func]
  (hs.hotkey.bind modifiers key func nil func))

(bind-key [:ctrl :cmd] :H wm.nudge-focused-left)
(bind-key [:ctrl :cmd] :L wm.nudge-focused-right)
(bind-key [:ctrl :cmd] :J wm.nudge-focused-down)
(bind-key [:ctrl :cmd] :K wm.nudge-focused-up)

(bind-key [:shift :cmd] :H wm.focused-left-half)
(bind-key [:shift :cmd] :L wm.focused-right-half)
(bind-key [:shift :cmd] :J wm.focused-bottom-half)
(bind-key [:shift :cmd] :K wm.focused-top-half)

(bind-key [:cmd] :E wm.focused-center)
(bind-key [:shift :cmd] :E wm.toggle-between-sizes)
(bind-key [:shift :cmd] "[" wm.focused-to-previous-screen)
(bind-key [:shift :cmd] "]" wm.focused-to-next-screen)
(bind-key [:shift :cmd] :F wm.focused-fullscreen)
(bind-key [:shift :cmd] :G wm.toggle-gaps)

(capslock.setup!)
(watchers.reload-hs-on-change!)

(hs.alert.show "Config loaded")
