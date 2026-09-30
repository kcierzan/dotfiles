; extends

((jsx_expression) @syntax.embedded
  (#syntax-profile? "flatwhite-simple")
  (#syntax-embedded-priority! @syntax.embedded))

((jsx_expression) @syntax.embedded.reset
  (#syntax-profile? "flatwhite-full"))

(jsx_expression
  ["{" "}"] @syntax.embedded.boundary
  (#syntax-embedded-priority! @syntax.embedded.boundary))
