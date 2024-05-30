;; Hammerspoon fennel config

(fn quit-hyperkey []
  (-?> (hs.application.find "Hyperkey") (: "kill")))

(fn start-hyperkey []
  (hs.application.open "Hyperkey"))

(fn quit-focused-application []
  (let [focused-app (hs.application.frontmostApplication)]
    (if focused-app
        (focused-app:kill)
        (hs.alert.show "No focused application"))))

(fn keyboard-connected? []
  (let [devices (hs.usb.attachedDevices)]
    (var connected? false)
    (each [_ device (ipairs devices) &until connected?]
      (when (= device.productName "Keychron Q1 Pro")
        (set connected? true)))
    connected?))

(fn handle-keyboard-connection [data]
  (when (and data.productName
             (string.match data.productName "Keychron Q1 Pro"))
    (if (= data.eventType "added")
          (quit-hyperkey)
          (= data.eventType "removed")
          (start-hyperkey))))

(fn fennel-file? [file]
  (= ".fnl" (string.sub file -4)))

(fn lua-file? [file]
  (= ".lua" (string.sub file -4)))

(fn hotreload [files]
  (var reload? false)
  (each [_ file (pairs files)]
    (when (or (lua-file? file)
              (fennel-file? file))
      (set reload? true)))
  (when reload?
    (hs.reload)))

(set _G.config-watcher
     (hs.pathwatcher.new hs.configdir hotreload))

(set _G.usb-watcher
     (hs.usb.watcher.new handle-keyboard-connection))

(_G.config-watcher:start)
(_G.usb-watcher:start)

(if (keyboard-connected?)
    (quit-hyperkey)
    (start-hyperkey))

(hs.hotkey.bind ["ctrl" "alt" "cmd"] "C" quit-focused-application)
