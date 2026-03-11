---
name: ast-grep
description: Structural code search and rewriting using AST patterns with ast-grep (sg). Use when searching for code patterns across a codebase, refactoring by pattern, finding all usages of a construct, or performing structural find-and-replace that grep/regex cannot handle reliably.
---

# ast-grep

`sg` (ast-grep) performs structural code search and rewriting. Unlike regex, it understands syntax trees, so patterns match regardless of whitespace or formatting, and won't match inside strings or comments.

## Quick Reference

```bash
# Search for a pattern
sg run -p 'console.log($$$ARGS)' --lang js

# Search in a specific directory
sg run -p 'console.log($$$ARGS)' --lang js src/

# Rewrite: replace console.log with logger.info
sg run -p 'console.log($$$ARGS)' -r 'logger.info($$$ARGS)' --lang js

# Run a rule file
sg scan -r rules/no-console.yml

# Run all rules in a directory
sg scan -r rules/

# Interactive rewrite (prompts before each replacement)
sg run -p 'PATTERN' -r 'REPLACEMENT' --lang LANG --interactive
```

## Pattern Syntax

Patterns are code snippets with special metavariables:

| Metavariable | Matches |
|---|---|
| `$VAR` | Any single AST node (and captures it) |
| `$_` | Any single AST node (unnamed capture) |
| `$$$ARGS` | Zero or more AST nodes (rest/variadic) |
| `$$VAR` | One or more nodes (experimental) |

### Examples by Language

**JavaScript/TypeScript:**
```
console.log($$$ARGS)              # any console.log call
await $PROMISE                    # any await expression
import $NAME from '$MODULE'       # named import
const $VAR = useState($INIT)      # React useState
$OBJ?.[$KEY]                      # optional chaining
```

**Python:**
```
print($$$ARGS)                    # any print call
def $NAME($$$PARAMS): $$$BODY     # any function definition
import $MODULE                    # simple import
$VAR = $EXPR                      # assignment
```

**Ruby:**
```
puts $$$ARGS                      # puts call
def $NAME($$$PARAMS)\n  $$$BODY\nend   # method definition
$VAR.map { |$ITEM| $$$BODY }      # map block
```

## YAML Rule Format

For reusable, shareable rules (save as `.yml` in a rules directory):

```yaml
id: no-console-log
language: JavaScript
rule:
  pattern: console.log($$$ARGS)
message: "Avoid console.log in production code"
severity: warning
note: "Use a proper logger instead"
fix: logger.info($$$ARGS)
```

### Composite Rules

```yaml
id: prefer-strict-equality
language: JavaScript
rule:
  any:
    - pattern: $A == $B
    - pattern: $A != $B
message: "Use === and !== instead of == and !="
```

### Rules with Constraints

```yaml
id: no-empty-catch
language: JavaScript
rule:
  pattern: |
    try { $$$TRY } catch ($E) {}
message: "Empty catch block swallows errors"
```

## Supported Languages

`--lang` flag values: `js`, `ts`, `jsx`, `tsx`, `python`, `rust`, `go`, `ruby`, `java`, `c`, `cpp`, `cs`, `html`, `css`, `json`, `yaml`, `toml`, `nix`, `bash`, `lua`, `kotlin`, `swift`, `scala`, `php`

## Common Workflows

### 1. Find All Usages of a Pattern

```bash
# Find all .unwrap() calls in Rust
sg run -p '.unwrap()' --lang rust

# Find all React hooks
sg run -p 'use$HOOK($$$ARGS)' --lang tsx src/

# Find all TODO comments (structural)
sg run -p '// TODO: $$$TEXT' --lang js
```

### 2. Safe Refactoring

```bash
# Rename a function call throughout the codebase
sg run -p 'oldFunction($$$ARGS)' -r 'newFunction($$$ARGS)' --lang ts --interactive

# Convert .then() chains to async/await (identify first)
sg run -p '$PROMISE.then($$$CALLBACKS)' --lang js

# Update import paths
sg run -p "import $NAME from 'old-module'" -r "import $NAME from 'new-module'" --lang ts
```

## Tips

- **Multi-line patterns**: Use `|` in YAML or newlines in shell with quotes for multi-line patterns
- **Case sensitivity**: Patterns are case-sensitive by default
- **Strictness**: `sg run` is lenient; YAML rules can use `strictness` field
- **Performance**: `sg scan` runs rules in parallel; much faster than sequential grep
- **Dry run**: Omit `-r` (rewrite) to preview matches before committing a rewrite
