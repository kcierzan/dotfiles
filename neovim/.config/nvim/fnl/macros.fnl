(fn require* [...]
  (let [{: args-keys
         : args-values
         : first
         : tail} (require :utils)]
    (fn nested-req [paths]
      (icollect [_ path (ipairs paths)]
                `(. (require ,(first path)) ,(unpack (tail path)))))
    `(local ,(args-keys ...) ,(nested-req (args-values ...)))))

{: require*}
