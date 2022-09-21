;; TODO: Make this look decent on a notched macbook
(local window-locations {})
(local bar-height 40)
(local gaps-width 16)
(local y-offset (+ bar-height gaps-width))
(var ?gaps false)

(fn set-window-location [window location]
  (tset window-locations (window:id) location))

(fn focused-window []
  (values (hs.window.focusedWindow)
          (-?> (hs.window.focusedWindow) (: :frame))
          (-?> (hs.window.focusedWindow) (: :screen) (: :frame))))

(fn window-by-id [id]
  (values (hs.window id)
          (-?> (hs.window id) (: :frame))
          (-?> (hs.window id) (: :screen) (: :frame))))

(fn focused-center []
  (let [(window _ screen) (focused-window)]
    (window:centerOnScreen screen)))

(fn set-fullscreen-gaps [window frame screen]
  (set-window-location window :fullscreen)
  (tset frame :x (+ screen.x gaps-width))
  (tset frame :y (+ screen.y y-offset))
  (tset frame :w (- screen.w (* 2 gaps-width)))
  (tset frame :h (- screen.h (+ gaps-width y-offset)))
  (window:setFrame frame))

(fn set-fullscreen [window frame screen]
  (set-window-location window :fullscreen)
  (tset frame :x screen.x)
  (tset frame :y screen.y)
  (tset frame :w screen.w)
  (tset frame :h screen.h)
  (window:setFrame frame))

(fn size-fullscreen [window frame screen]
  (if ?gaps
    (set-fullscreen-gaps window frame screen)
    (set-fullscreen window frame screen)))

(fn focused-fullscreen []
  (let [(window frame screen) (focused-window)]
    (size-fullscreen window frame screen)))

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
  (let [(window _ screen) (focused-window)]
    (set-left-half window screen)))

(fn set-right-half [window screen]
  (set-window-location window :right-half)
  (if ?gaps
    (window:move (right-half-gaps-rect screen))
    (window:moveToUnit "[50,0,100,100]")))

(fn focused-right-half []
  (let [(window _ screen) (focused-window)]
    (set-right-half window screen)))

(fn top-half-gaps-rect [screen]
  (let [x gaps-width
        y y-offset
        width (- screen.w (* 2 gaps-width))
        height (- (/ screen.h 2) (* gaps-width 1.5))]
    (hs.geometry.rect x y width height)))

(fn set-top-half [window screen]
  (set-window-location window :top-half)
  (if ?gaps
    (window:move (top-half-gaps-rect screen))
    (window:moveToUnit "[0,0,100,50]")))

(fn focused-top-half []
  (let [(window _ screen) (focused-window)]
    (set-top-half window screen)))

(fn bottom-half-gaps-rect [screen]
  (let [y (+ (/ screen.h 2) y-offset)
        x gaps-width
        width (- screen.w (* 2 gaps-width))
        height (- (/ screen.h 2) y-offset)]
    (hs.geometry.rect x y width height)))

(fn set-bottom-half [window screen]
  (set-window-location window :bottom-half)
  (if ?gaps
    (window:move (bottom-half-gaps-rect screen))
    (window:moveToUnit "[0,50,100,100]")))

(fn focused-bottom-half []
  (let [(window _ screen) (focused-window)]
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
  (let [(window frame screen) (focused-window)]
    (if (frame-outside-bounds frame screen)
      (set-frame-big frame screen)
      (bigger-than-medium frame screen)
      (set-frame-medium frame screen)
      (bigger-than-small frame screen)
      (set-frame-small frame screen))
    (window:setFrame frame)))

(fn nudge-focused-left []
  (let [(window frame screen) (focused-window)]
    (tset frame :x (- frame.x (// screen.w 32)))
    (window:setFrame frame)))

(fn nudge-focused-right []
  (let [(window frame screen) (focused-window)]
    (tset frame :x (+ frame.x (// screen.w 32)))
    (window:setFrame frame)))

(fn nudge-focused-up []
  (let [(window frame screen) (focused-window)]
    (tset frame :y (- frame.y (// screen.h 32)))
    (window:setFrame frame)))

(fn nudge-focused-down []
  (let [(window frame screen) (focused-window)]
    (tset frame :y (+ frame.y (// screen.h 32)))
    (window:setFrame frame)))

(fn focused-to-next-screen []
  (let [(window frame screen) (focused-window)
        screen (window:screen)
        next-screen (screen:next)
        rect (frame:toUnitRect (screen:frame))]
    (window:move rect next-screen true 0)))

(fn focused-to-previous-screen []
  (let [(window frame screen) (focused-window)
        screen (window:screen)
        previous-screen (screen:previous)
        rect (frame:toUnitRect (screen:frame))]
    (window:move rect previous-screen true 0)))

(fn valid-window? [window screen]
  (and (not= screen nil) (not= window nil)))

(fn refresh-window! [id position]
  (let [(window frame screen) (window-by-id id)]
    (when (valid-window? window screen)
      (match position
        :fullscreen (size-fullscreen window frame screen)
        :top-half (set-top-half window screen)
        :bottom-half (set-bottom-half window screen)
        :right-half (set-right-half window screen)
        :left-half (set-left-half window screen)))))

(fn on-off [x]
  (if x "ON" "OFF"))

(fn toggle-gaps []
  (set ?gaps (not ?gaps))
  (each [id position (pairs window-locations)]
    (refresh-window! id position))
  (hs.alert.show (.. "Gaps: " (on-off ?gaps))))

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
