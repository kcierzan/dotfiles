---
name: hashline-editing
description: Opt into stale-write protection for concurrent text editing with `hashline_read` and `hashline_edit`.
---

# Hashline Editing

Use Pi's built-in `read` and `edit` by default. Choose this workflow only when stale-write protection is useful, such as multiple agents editing concurrently.

1. `hashline_read` each existing text file first. Copy its exact `[path#TAG]` and use only displayed, current line numbers.
2. Send one `hashline_edit` call with a `patch` containing one section per file.
3. Do not automatically re-read. Use `hashline_read` again after a stale-tag error, for sensitive verification, or before an edit needing current content or line numbers.

```text
[path#TAG]
PUT 10.=12:
+replacement
PUT >18:
+inserted after line 18
CUT 25.=27
```

- `PUT N.=M:` replaces inclusive original lines; every body row starts with `+` (`+` is blank content, `++x` writes `+x`).
- `CUT N.=M` deletes; `PUT <N:` inserts before; `PUT >N:` inserts after; `PUT >$:` appends.
- Keep ranges tight and non-overlapping; do not include unchanged context. Never guess or reuse a stale tag.
- Use built-in `read` for images and ordinary inspection, built-in `edit` for ordinary edits, and `write` for new files. `hashline_edit` only changes existing text files and normalizes BOM/CRLF to UTF-8/LF.
- Files over 4 MiB cannot receive anchors. Treat stale, unknown-tag, invalid-range, overlap, and duplicate-section errors as non-mutating.
