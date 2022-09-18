(local window-locations {})
(local bar-height 0)
(local gaps-width 32)
(local y-offset (+ bar-height gaps-width))
(var ?gaps false)

(fn set-window-location [window location]
  (tset window-locations (window:id) location))

(fn focused-window-frame-screen []
  (let [current-window (hs.window.focusedWindow)
        current-frame (current-window:frame)
        current-screen (-> current-window (: :screen) (: :frame))]
    (values current-window current-frame current-screen)))

(fn window-frame-screen [id]
  (let [current-window (hs.window id)
        current-frame (current-window:frame)
        current-screen (-> current-window (: :screen) (: :frame))]
    (values current-window current-frame current-screen)))

(fn screen-height [screen]
  (if ?gaps
    (- screen.h (* 2 gaps-width))
    screen.h))

(fn screen-y [screen]
  (if ?gaps
    (+ screen.y y-offset)
    screen.y))

(fn screen-x [screen]
  (if ?gaps
    (+ screen.x gaps-width)
    screen.x))

(fn screen-width [screen]
  (if ?gaps
    (- screen.w (* 2 gaps-width))
    screen.w))

(fn focused-center []
  (let [(window _ screen) (focused-window-frame-screen)]
    (window:centerOnScreen screen)))

(fn set-fullscreen [window frame screen]
  (set-window-location window :fullscreen)
  (tset frame :x (screen-x screen))
  (tset frame :y (screen-y screen))
  (tset frame :w (screen-width screen))
  (tset frame :h (screen-height screen))
  (window:setFrame frame))

(fn focused-fullscreen []
  (let [(window frame screen) (focused-window-frame-screen)]
    (set-fullscreen window frame screen)))

(fn left-half-gaps-rect [screen]
  (let [x gaps-width
        y y-offset
        width (- (/ screen.w 2) (* gaps-width 1.5))
        height (- screen.h (+ gaps-width y-offset))]
    (hs.geometry.rect x y width height)))

(fn right-half-gaps-rect [screen]
  (let [x (+ (/ screen.w 2) (/ gaps-width 2))
        y y-offset
        width (- (/ screen.w 2) (* gaps-width 1.5))
        height (- screen.h (+ gaps-width y-offset))]
    (hs.geometry.rect x y width height)))

(fn set-left-half [window screen]
  (set-window-location window :left-half)
  (if ?gaps
    (window:move (left-half-gaps-rect screen))
    (window:moveToUnit "[0,0,50,100]")))

(fn focused-left-half []
  (let [(window _ screen) (focused-window-frame-screen)]
    (set-left-half window screen)))

(fn set-right-half [window screen]
  (set-window-location window :right-half)
  (if ?gaps
    (window:move (right-half-gaps-rect screen))
    (window:moveToUnit "[50,0,100,100]")))

(fn focused-right-half []
  (let [(window _ screen) (focused-window-frame-screen)]
    (set-right-half window screen)))

(fn top-half-gaps-rect [screen]
  (let [x gaps-width
        y y-offset
        width (- screen.w (* 2 gaps-width))
        height (- (/ screen.h 2) (* gaps-width 1.5))]
    (hs.geometry.new x y width height)))

(fn set-top-half [window screen]
  (set-window-location window :top-half)
  (if ?gaps
    (window:move (top-half-gaps-rect screen))
    (window:moveToUnit "[0,0,100,50]"))) 
      
(fn focused-top-half []
  (let [(window _ screen) (focused-window-frame-screen)]
    (set-top-half window screen)))

(fn bottom-half-gaps-rect [screen]
  (let [y (+ (/ screen.h 2) (* 0.5 gaps-width))
        x gaps-width
        width (- screen.w (* 2 gaps-width))
        height (- (/ screen.h 2) (* 1.5 gaps-width))]
    (hs.geometry.new x y width height)))

(fn set-bottom-half [window screen]
  (set-window-location window :bottom-half)
  (if ?gaps
    (window:move (bottom-half-gaps-rect screen))
    (window:moveToUnit "[0,50,100,100]")))

(fn focused-bottom-half []
  (let [(window _ screen) (focused-window-frame-screen)]
    (set-bottom-half window screen)))

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
  (let [(window frame screen) (focused-window-frame-screen)]
    (if (frame-outside-bounds frame screen)
      (set-frame-big frame screen)
      (bigger-than-medium frame screen)
      (set-frame-medium frame screen)
      (bigger-than-small frame screen)
      (set-frame-small frame screen))
    (window:setFrame frame)))

(fn nudge-focused-left []
  (let [(window frame screen) (focused-window-frame-screen)]
    (tset frame :x (- frame.x (// screen.w 32)))
    (window:setFrame frame)))

(fn nudge-focused-right []
  (let [(window frame screen) (focused-window-frame-screen)]
    (tset frame :x (+ frame.x (// screen.w 32)))
    (window:setFrame frame)))

(fn nudge-focused-up []
  (let [(window frame screen) (focused-window-frame-screen)]
    (tset frame :y (- frame.y (// screen.h 32)))
    (window:setFrame frame)))

(fn nudge-focused-down []
  (let [(window frame screen) (focused-window-frame-screen)]
    (tset frame :y (+ frame.y (// screen.h 32)))
    (window:setFrame frame)))

(fn focused-to-next-screen []
  (let [(window frame screen) (focused-window-frame-screen)
        screen (window:screen)
        next-screen (screen:next)
        rect (frame:toUnitRect (screen:frame))]
    (window:move rect next-screen true 0)))

(fn focused-to-previous-screen []
  (let [(window frame screen) (focused-window-frame-screen)
        screen (window:screen)
        previous-screen (screen:previous)
        rect (frame:toUnitRect (screen:frame))]
    (window:move rect previous-screen true 0)))

(fn valid-window? [window frame screen]
  (not= screen nil))

(fn toggle-gaps []
  (set ?gaps (not ?gaps))
  (each [id position (pairs window-locations)]
    (let [(window frame screen) (window-frame-screen id)]
      (when valid-window? window
        (match position
          :fullscreen (set-fullscreen window frame screen)
          :top-half (set-top-half window screen)
          :bottom-half (set-bottom-half window screen)
          :right-half (set-right-half window screen)
          :left-half (set-left-half window screen)))))
  (hs.alert.show (.. "Gaps set to: " (tostring ?gaps))))

{: focused-center
 : focused-fullscreen
 : focused-left-half
 : focused-right-half
 : focused-top-half
 : focused-bottom-half
 : toggle-between-sizes
 : nudge-focused-left
 : nudge-focused-right
 : nudge-focused-up
 : nudge-focused-down
 : focused-to-next-screen
 : focused-to-previous-screen
 : toggle-gaps}
