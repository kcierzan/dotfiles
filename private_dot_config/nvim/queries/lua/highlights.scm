; extends

"local" @keyword.storage

((variable_declaration
  (assignment_statement
    (variable_list name: (identifier) @variable.declaration)))
  (#syntax-variable? @variable.declaration))
