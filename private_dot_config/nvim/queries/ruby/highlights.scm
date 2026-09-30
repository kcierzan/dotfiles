; extends

((assignment left: (identifier) @variable.declaration)
  (#syntax-variable? @variable.declaration))

(call
  receiver: (_)
  method: (identifier) @function.method.call)

((interpolation) @syntax.embedded
  (#syntax-profile? "flatwhite-simple")
  (#syntax-embedded-priority! @syntax.embedded))

((interpolation) @syntax.embedded.reset
  (#syntax-profile? "flatwhite-full"))

(interpolation
  ["#{" "}"] @syntax.embedded.boundary
  (#syntax-embedded-priority! @syntax.embedded.boundary))
