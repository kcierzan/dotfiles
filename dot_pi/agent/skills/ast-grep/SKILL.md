---
name: ast-grep
description: Use ast-grep for syntax-aware code search, usage discovery, and verified structural refactors when text search is insufficient.
---

# ast-grep

Use `ast-grep`, not the deprecated `sg` alias. It matches syntax trees, so it is appropriate for code constructs but not ordinary text or comments.

## Search

Start with the narrowest relevant path and an explicit language:

```bash
ast-grep run -p 'console.log($$$ARGS)' --lang js src/
ast-grep run -p '$OBJ.$METHOD($$$ARGS)' --lang ts src/
ast-grep run -p 'await $EXPR' --lang ts src/
```

Patterns are valid code snippets. Metavariables must be uppercase:

| Metavariable | Matches |
|---|---|
| `$VAR` | one AST node, captured |
| `$_` | one AST node, not captured |
| `$$$ARGS` | zero or more nodes, captured |

Use normal text search for comments, prose, exact identifiers embedded within another identifier, and other non-syntactic queries. Do not assume an AST pattern matched: inspect its results before acting.

## Rewrite safely

First search without a rewrite. Then preview the exact rewrite on a narrow path:

```bash
ast-grep run -p 'oldFunction($$$ARGS)' -r 'newFunction($$$ARGS)' --lang ts src/
```

Apply only after reviewing the preview:

```bash
ast-grep run -p 'oldFunction($$$ARGS)' -r 'newFunction($$$ARGS)' --lang ts src/ --interactive
# Or apply every reviewed match:
ast-grep run -p 'oldFunction($$$ARGS)' -r 'newFunction($$$ARGS)' --lang ts src/ --update-all
```

Run the relevant formatter, type check, and tests after an applied rewrite.

## Reusable rules

Use a YAML rule for a reusable check. Run one standalone rule with `--rule`; use `scan` without `--rule` only when the repository has an `sgconfig.yml` that discovers its rules.

```yaml
id: no-console-log
language: JavaScript
rule:
  pattern: console.log($$$ARGS)
message: Avoid console.log in production code
severity: warning
fix: logger.info($$$ARGS)
```

```bash
ast-grep scan --rule rules/no-console-log.yml src/
ast-grep scan src/ # uses the repository's sgconfig.yml
```

For uncertain patterns, inspect parsing instead of guessing:

```bash
ast-grep run -p 'PATTERN' --lang ts --debug-query=ast
```
