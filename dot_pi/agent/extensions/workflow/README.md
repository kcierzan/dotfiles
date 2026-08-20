# Supervised workflow extension

## Quality gates

`/quality-check` records separate static-analysis, lint, and test results. Failed checks display their bounded diagnostic output in the transcript. It uses an explicit `.pi/workflow.json` when present; otherwise it discovers one unambiguous project ecosystem.

Built-in discovery:

| Project marker | Static analysis | Lint | Tests |
| --- | --- | --- | --- |
| `package.json` | `typecheck` or `check:types` script | `lint` script | `test` script |
| `go.mod` | `go vet ./...` | `golangci-lint run` when its config is present | `go test ./...` |
| `Gemfile` | Sorbet or Steep when configured | RuboCop when configured | RSpec, Rails test, or Rake test |
| `stack.yaml` | Stack build without running tests | HLint | Stack test |
| `*.cabal` | Cabal build | HLint | Cabal test |
| `*.odin` | Odin check | Explicit project configuration required | Odin test |

Discovery fails closed when a required tool is ambiguous or missing. Polyglot roots must use explicit configuration.

Example `.pi/workflow.json`:

```json
{
  "quality": {
    "static": { "command": "odin", "args": ["check", "src"] },
    "lint": { "command": "my-odin-lint", "args": ["src"] },
    "tests": { "command": "odin", "args": ["test", "tests"] }
  }
}
```

Commands are executable-and-argv data, not shell strings. Project configuration is honored only after Pi trusts the project.

## Development

`pnpm-workspace.yaml` explicitly denies the no-op `@google/genai` preinstall and advisory-only `protobufjs` postinstall scripts. This keeps pnpm's strict dependency-build policy enabled while making `pnpm install` and `pnpm check` reproducible.

## Human review

After quality checks and agent review pass, `/request-review` opens a read-only review surface. It preserves the complete unified diff and wraps long lines so all approved content remains inspectable.

- `Tab`: switch between diff and decision regions
- `↑`/`↓` or `j`/`k`: navigate
- `Ctrl+D`/`Ctrl+U`: move half a page
- `Space`/`b` or `Ctrl+F`/`Ctrl+B`: move a full page
- `g`/`G` or `Home`/`End`: jump to the start/end
- `Fn+↑`/`Fn+↓`: also works when macOS/Ghostty emits Page Up/Page Down
- `Enter`: choose the selected decision
- `c`: copy the displayed unified diff
- `Esc`: close while keeping review locked

Diff headers use OSC 8 `file://` links, which Ghostty renders as clickable local-file links with link previews enabled. The decision surface itself remains keyboard-driven so it does not take over Pi or Ghostty mouse selection and scrolling behavior.

The safe default is **Request changes**. Approval restores the tools active before review but never commits or pushes.

## Evidence-based retrospective

`/retro [optional focus]` starts a strictly read-only retrospective after implementation or an approved review. The model can inspect with only `read`, `grep`, `find`, and `ls`, then submit at most one configuration, instruction, or workflow-documentation improvement through a structured tool.

A proposal must contain:

- One safe relative target path and one matching unified-file diff
- Concrete evidence from the session or inspected files
- Rationale and expected benefit
- Risks and validation steps

The diff is recorded in the transcript and persisted with the session, but it is never applied. The target file's SHA-256 hash is captured so stale proposals cannot be approved.

- `/approve-retro`: record human approval and restore previous tools; do not apply the diff
- `/cancel-retro`: discard the proposal and restore previous tools

If the proposal is worth implementing, begin a separate `/plan` workflow. This prevents retrospective analysis from becoming autonomous self-modification.
