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
  (let [{: present?} (require :lib)
        [mod function & args] [...]]
    (if (present? [(unpack args)])
      `((-> (require ,mod) (. ,function)) ,(unpack args))
      `((-> (require ,mod) (. ,function))))))

{: require*
 : req-call}
