#!/usr/bin/env bash
# Enforce shell tool preferences for Claude Code
# Blocks: bare ruby (use mise exec ruby --)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

# Block bare 'ruby' without mise prefix
if echo "$COMMAND" | grep -qE '(^|[|;&(])[[:space:]]*ruby[[:space:]]' && ! echo "$COMMAND" | grep -q 'mise exec ruby --'; then
  echo "BLOCKED: Use 'mise exec ruby -- ruby' instead of bare 'ruby'. The built-in macOS Ruby is too old." >&2
  exit 2
fi

exit 0
