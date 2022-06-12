(var send-escape? false)
(var prev-modifiers {})

(fn call-escape []
  (set send-escape? false)
  (hs.eventtap.keyStroke {} :ESCAPE))

(fn len [t]
  (var len 0)
  (each [_ _ (pairs t)]
    (set len (+ len 1)))
  len)

(fn mod-handler [event]
  (let [current-modifiers (event:getFlags)]
    (if (and (. current-modifiers :ctrl)
             (= (len current-modifiers) 1)
             (= (len prev-modifiers) 0))
        (set send-escape? true)
      (and (. prev-modifiers :ctrl)
           (= (len current-modifiers) 0)
           send-escape?)
      (call-escape)
      (set send-escape? false))
    (set prev-modifiers current-modifiers))
  false)

(fn non-mod-handler [_]
  (set send-escape? false)
  false)

(tset _G :mod-listener (-> (hs.eventtap.new [hs.eventtap.event.types.flagsChanged] mod-handler) (: :start)))
(tset _G :keydown-listener (-> (hs.eventtap.new [hs.eventtap.event.types.keyDown] non-mod-handler) (: :start)))
