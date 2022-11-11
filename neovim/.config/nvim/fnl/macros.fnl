(fn require* [...]
  (let [{: args-keys
         : args-values
         : first
         : tail} (require :lib)]
    (fn nested-req [paths]
      (icollect [_ path (ipairs paths)]
                `(. (require ,(first path)) ,(unpack (tail path)))))
    `(local ,(args-keys ...) ,(nested-req (args-values ...)))))

(fn req-call [...]
  (let [{: first
         : second
         : tail
         : present?} (require :lib)
        args (tail (tail [...]))]
    (if (present? args)
      `((-> (require ,(first [...])) (. ,(second [...]))) ,(unpack args))
      `((-> (require ,(first [...])) (. ,(second [...])))))))

{: require*
 : req-call}
