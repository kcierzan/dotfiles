;; Hammerspoon fennel config

(fn quit-hyperkey []
  (-?> (hs.application.find :Hyperkey) (: :kill)))

(fn start-hyperkey []
  (hs.application.open :Hyperkey))

(fn quit-focused-application []
  (let [focused-app (hs.application.frontmostApplication)]
    (if focused-app
        (focused-app:kill)
        (hs.alert.show "No focused application"))))

(fn create-execute-command [...]
  "Wrap each argument in double quotes and join with a space."
  (let [wrapped-elems (icollect [_ s (ipairs [...])]
                        (.. "\"" s "\""))]
    (table.concat wrapped-elems " ")))

(fn make-background-cmd [cmd]
  (.. cmd " &"))

(fn launch-emacs-dev [file]
  (let [cmd (create-execute-command "/Applications/Emacs.app/Contents/MacOS/Emacs"
                                    file
                                    "--init-directory"
                                    "~/.custom")
        bg-cmd (make-background-cmd cmd)]
    (os.execute bg-cmd)
    (os.execute "sleep 2")
    (-?> (hs.application.find :org.gnu.Emacs)
         (: :mainWindow)
         (: :focus))))

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
    (if (= data.eventType :added)
        (quit-hyperkey)
        (= data.eventType :removed)
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

(hs.hotkey.bind [:ctrl :alt :cmd] :C quit-focused-application)
(hs.hotkey.bind [:ctrl :alt :cmd] :T (lambda [] (launch-emacs-dev "~/.custom/init.el")))
