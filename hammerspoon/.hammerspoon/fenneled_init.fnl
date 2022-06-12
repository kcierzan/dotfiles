(require :hot-reload)
(require :capslock)
(local windows (require :windows))

(tset hs.window :animationDuration 0.1)

(fn bind-key [modifiers key func]
  (hs.hotkey.bind modifiers key func nil func))

(bind-key [:ctrl :cmd] :H windows.nudge-left)
(bind-key [:ctrl :cmd] :L windows.nudge-right)
(bind-key [:ctrl :cmd] :J windows.nudge-down)
(bind-key [:ctrl :cmd] :K windows.nudge-up)

(bind-key [:shift :cmd] :H windows.left-half)
(bind-key [:shift :cmd] :L windows.right-half)
(bind-key [:shift :cmd] :J windows.bottom-half)
(bind-key [:shift :cmd] :K windows.top-half)

(bind-key [:cmd] :E windows.center)
(bind-key [:shift :cmd] :E windows.toggle-between-sizes)
(bind-key [:shift :cmd] "[" windows.send-to-previous-screen)
(bind-key [:shift :cmd] "]" windows.send-to-next-screen)
(bind-key [:shift :cmd] :F windows.fullscreen) 

(hs.alert.show "Config loaded")
