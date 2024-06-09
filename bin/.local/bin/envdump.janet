#!/usr/bin/env janet

(defn main [& args]
  (let [envvar-list (array/new (length (os/environ)))
        f (file/open (get args 1) :w)]
    (loop [[var value] :pairs (os/environ)]
      (array/push envvar-list (string "\"" var "=" value "\"")))
  (file/write f (string "(" (string/join envvar-list "\n") ")"))
  (file/flush f)
  (file/close f)))
