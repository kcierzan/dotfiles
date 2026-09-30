; extends

["const" "let" "var"] @keyword.storage

((variable_declarator name: (identifier) @variable.declaration)
  (#syntax-variable? @variable.declaration))

((template_substitution) @syntax.embedded
  (#syntax-profile? "flatwhite-simple")
  (#syntax-embedded-priority! @syntax.embedded))

((template_substitution) @syntax.embedded.reset
  (#syntax-profile? "flatwhite-full"))

(template_substitution
  ["${" "}"] @syntax.embedded.boundary
  (#syntax-embedded-priority! @syntax.embedded.boundary))
