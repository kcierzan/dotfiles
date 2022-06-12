(fn get-state []
  (let [current-window (hs.window.focusedWindow)
        current-frame (current-window:frame)
        current-screen (-> current-window (: :screen) (: :frame))]
    [current-window current-frame current-screen]))

(fn center []
  (let [[window _ screen] (get-state)]
    (window:centerOnScreen screen)))

(fn fullscreen []
  (let [[window frame screen] (get-state)]
    (tset frame :x screen.x)
    (tset frame :y screen.x)
    (tset frame :w screen.w)
    (tset frame :h screen.h)
    (window:setFrame frame)))

(fn left-half []
  (let [[window] (get-state)]
    (window:moveToUnit "[0,0,50,100]")))

(fn right-half []
  (let [[window] (get-state)]
    (window:moveToUnit "[50,0,100,100]")))

(fn top-half []
  (let [[window] (get-state)]
    (window:moveToUnit "[0,0,100,50]")))

(fn bottom-half []
  (let [[window] (get-state)]
    (window:moveToUnit "[0,50,100,100]")))

(fn frame-outside-bounds [frame screen]
  (let [frame-is-small (<= frame.w (* screen.w (/ 2 5)))
        frame-is-big (> frame.w (* screen.w (/ 4 5)))]
    (or frame-is-small frame-is-big)))

(fn bigger-than-medium [frame screen]
  (> frame.w (* screen.w (/ 3 5))))

(fn bigger-than-small [frame screen]
  (> frame.w (* screen.w (/ 2 5))))

(fn set-frame-big [frame screen]
  (tset frame :w (* screen.w (/ 4 5))) 
  (tset frame :h (* screen.h (/ 4 5))))

(fn set-frame-medium [frame screen]
  (tset frame :w (* screen.w (/ 3 5)))
  (tset frame :h (* screen.h (/ 3 5))))

(fn set-frame-small [frame screen]
  (tset frame :w (* screen.w (/ 2 5)))
  (tset frame :h (* screen.h (/ 2 5))))

(fn toggle-between-sizes []
  (let [[window frame screen] (get-state)]
    (if (frame-outside-bounds frame screen)
      (set-frame-big frame screen)
      (bigger-than-medium frame screen)
      (set-frame-medium frame screen)
      (bigger-than-small frame screen)
      (set-frame-small frame screen))
    (window:setFrame frame)))

(fn nudge-left []
  (let [[window frame screen] (get-state)]
    (tset frame :x (- frame.x (// screen.w 32)))
    (window:setFrame frame)))

(fn nudge-right []
  (let [[window frame screen] (get-state)]
    (tset frame :x (+ frame.x (// screen.w 32)))
    (window:setFrame frame)))

(fn nudge-up []
  (let [[window frame screen] (get-state)]
    (tset frame :y (- frame.y (// screen.h 32)))
    (window:setFrame frame)))

(fn nudge-down []
  (let [[window frame screen] (get-state)]
    (tset frame :y (+ frame.y (// screen.h 32)))
    (window:setFrame frame)))

(fn send-to-next-screen []
  (let [[window frame] (get-state)
        screen (window:screen)
        next-screen (screen:next)
        rect (frame:toUnitRect (screen:frame))]
    (window:move rect next-screen true 0)))

(fn send-to-previous-screen []
  (let [[window frame] (get-state)
        screen (window:screen)
        previous-screen (screen:previous)
        rect (frame:toUnitRect (screen:frame))]
    (window:move rect previous-screen true 0)))

{:center center
 :fullscreen fullscreen
 :left-half left-half
 :right-half right-half
 :top-half top-half
 :bottom-half bottom-half
 :toggle-between-sizes toggle-between-sizes
 :nudge-left nudge-left
 :nudge-right nudge-right
 :nudge-up nudge-up
 :nudge-down nudge-down
 :send-to-next-screen send-to-next-screen
 :send-to-previous-screen send-to-previous-screen} 
