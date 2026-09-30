# Neovim syntax profiles

The palette picker remains `<leader>vt`. Select syntax with `<leader>vs` or
`:SyntaxPicker`. Moving through the list previews a profile in open buffers;
Enter saves it; Escape restores the profile from before opening the picker,
using the latest palette. The dot marks the confirmed selection.

`:SyntaxProfile {id}` selects and saves directly. IDs are `current`,
`zenbones`, `flatwhite-simple`, `flatwhite-full`, `noctis`, `oxocarbon`, `mariana`,
`catppuccin`, and `moe`.
Completion is available. Current is the default. The state file contains only a
JSON string at `stdpath("state") .. "/syntax-profile.json"`. Invalid state warns
and selects Current. Preview never writes state; a failed save restores the last
confirmed choice. Each running instance keeps its own selection.

## Palette and profile application

`theme.lua` loads and validates the sixteen palette colors and variant once per
application. It restores the preceding profile's owned groups, runs mini.base16,
applies UI overrides from `highlights.lua`, and applies the active syntax
profile. The palette watcher retains its existing behavior. Base16 groups and
Heirline's colors are independent of the syntax choice.

A profile is a Lua module returning `id`, `name`, `description`, and
`highlights(palette)`. The function returns ordinary Neovim highlight tables.
Add a module and an entry in `lua/syntax/init.lua` to register another profile.
The common helpers provide parent links, neutral syntax defaults, and semantic
roles; they are optional for new profiles.

## Sources and Base16 correspondence

These are category/style adaptations, not copies of upstream RGB palettes.
Base16's accent names describe convention; an arbitrary palette can assign
different hues or contrasts. No upstream contrast ratio is guaranteed.

**Current** preserves the pre-existing generic, Ruby, Lua, Zig, Nix and LSP
mappings. The extraction was compared against all original overrides.

**Zenbones** follows the syntax and Tree-sitter roles from
[Zenbones](https://github.com/zenbones-theme/zenbones.nvim). It restricts code
to the neutral `base03`, `base04`, and `base05` slots. Comments and literals use
italics, statements and special symbols use bold, TODO-style markup adds an
underline, and ordinary identifiers/functions are separated by contrast. The
palette's accent colors remain available to diagnostics and other UI groups but
are not used for syntax semantics.

**Flatwhite Simple / Full** follow the original
[base category rules](https://github.com/biletskyy/flatwhite-syntax/blob/master/styles/languages/_base.less)
and [language rules](https://github.com/biletskyy/flatwhite-syntax/tree/master/styles/languages).
Text is neutral. Strings/regex use green (`base0B`), numbers/language constants
teal (`base0C`), symbols blue (`base0D`), control keywords/tags purple (`base0E`),
and embedded code or Ruby special methods orange (`base09`). Comments and tag
attributes retain italic styling.

Backgrounds blend `base00` with orange at 18%, green at 19%, teal at 15%, blue at
20%, and purple at 15%. Foregrounds blend 85% `base05` with 15% of the accent.
Each RGB channel is interpolated and rounded. Simple paints the whole embedded
expression orange. Full paints its boundaries orange and preserves inner token
styles. Simple regions and both variants' boundaries use
`vim.hl.priorities.semantic_tokens + 3`, below diagnostics. Full's neutral region
reset uses normal Tree-sitter priority so inner captures can supply their own
backgrounds. Secondary upstream shades share their family's Base16 accent.
Framework-specific Ruby scopes without equivalent parser captures are omitted.

When the palette matches `doom-flatwhite`, the profiles use Flatwhite's original
primary foreground/background pairs instead of interpolation: orange
`#5b5143`/`#f7e0c3`, green `#525643`/`#e2e9c1`, teal
`#465953`/`#d2ebe3`, blue `#4c5361`/`#dde4f2`, and purple
`#614c61`/`#f1ddf1`. The palette already supplies the original cream canvas,
neutral text, comments, and secondary accents. This pairing therefore preserves
the upstream color treatment as well as its category and embedded-region rules.
All other Base16 palettes continue to use the portable blends described above.

**Noctis** follows its
[documented roles](https://github.com/liviuschera/noctis#syntax-colors) and
[TextMate rules](https://github.com/liviuschera/noctis/blob/master/src/syntax.mjs).
Its green string shades share `base0B`; comments use `base03`; purple literals
use `base0E`; pink keywords/operators use `base08`; orange declarations, tags
and language variables use `base09`; cyan calls use `base0C`; blue method calls
use `base0D`; yellow constants/attributes use `base0A`; warm variables, parameters,
properties and type annotations share `base0F`. Keywords/operators and parameters
are bold, type annotations italic, and punctuation neutral/bold. Separate source
shades for warm variables versus properties collapse to one slot. The semantic
layer is an adaptation: the inspected upstream syntax build uses TextMate rules.

**Oxocarbon** follows its
[actual Neovim definitions](https://github.com/nyoom-engineering/oxocarbon.nvim/blob/main/lua/oxocarbon/init.lua),
including purple strings, bold pink function captures, cyan methods, neutral
members/parameters, pink properties, and blue keywords. Source accent slots
`base07`/`base08` map to Base16 `base0C`, `base09`/`base11`/`base15` to `base0D`,
`base10`/`base12` to `base08`, `base13` to `base0B`, and `base14` to `base0E`.
Source neutral `base04` maps to `base05`; comment `base03` remains `base03`.
Its old `@method`, `@parameter`, `@field`, `@namespace`, `@float`, `@conditional`,
and `@string.regex` names become current capture names. Separate cyan/blue/pink
shades collapse; the modern member capture uses the old field role, while
`@property` and semantic property declarations retain the property role.

**Mariana** follows `Mariana.sublime-color-scheme` in the installed Sublime Text
`Color Scheme - Default.sublime-package` (inspected 2026-09-29). Green maps to
`base0B`, blue/blue-vibrant to `base0D`, blue5 to `base0C`, blue6 to `base04`,
orange/orange2/orange3 and red2 to `base09`, pink to `base0E`, red to `base08`,
white to `base07`, ordinary text to `base05`, and comments to `base03`.
Definitions use cyan, calls blue, parameters/types orange, members/storage red,
and constants/keywords pink. Built-ins and storage types retain italics.
Brackets, separators, and interpolation boundaries keep distinct punctuation
roles. Closely related orange shades and the red-orange operator shade collapse.

**Catppuccin** follows the syntax and Tree-sitter definitions from the
[Catppuccin Neovim revision pinned by this configuration](https://github.com/catppuccin/nvim/tree/c89184526212e04feffbddda9d06b041a8fca416/lua/catppuccin/groups).
Green maps to `base0B`; peach to `base09`; blue and lavender to `base0D`; mauve
to `base0E`; yellow to `base0A`; teal, sky, and sapphire to `base0C`; pink and
red to `base08`; flamingo and maroon to `base0F`; text to `base05`; overlays to
`base03`/`base04`. This retains green strings, peach literals, blue functions,
mauve keywords, yellow types/modules, cyan operators, pink escapes/macros, warm
parameters/symbols, neutral variables, and the default italic treatment for
comments, conditionals, modules, tag attributes, and built-in types. Related
Catppuccin shades necessarily collapse onto shared Base16 accents.

**Moe** follows the default font-lock roles in
[Moe Dark](https://github.com/kuanyui/moe-theme.el/blob/dev/moe-dark-theme.el)
and [Moe Light](https://github.com/kuanyui/moe-theme.el/blob/dev/moe-light-theme.el).
Magenta maps to `base0E`, green to `base0B`, yellow to `base0A`, red to
`base08`, cyan to `base0C`, orange to `base09`, blue to `base0D`, and purple to
`base0F`. This retains magenta strings, green keywords, cyan types, orange
variables, blue constants, and purple built-ins. Functions use yellow in the
dark variant and red in the light variant, matching the respective originals.
Moe's multiple shades per hue collapse to one Base16 accent; its specialized
mode-line, Org, completion, and pastel background treatments remain outside the
syntax profile.

## Grammar and semantic limits

The query files use `; extends`, retaining installed captures for definitions,
calls, parameters, members, constants and JSX. They add direct variable
bindings, Ruby receiver methods, Ruby/TypeScript/TSX interpolation regions and
boundaries, and the missing Lua/TypeScript storage-keyword distinction needed
by Mariana. TSX inherits the TypeScript additions. Lua has no native string
interpolation. Ruby assignments approximate declarations; Tree-sitter cannot
identify the first assignment semantically. Destructured bindings and
framework-specific roles continue to use installed captures. Function-valued
bindings and uppercase constants keep their existing captures.

LSP remains enabled. For the added profiles, generic symbol colors that would
erase finer Tree-sitter distinctions are cleared. Declaration/definition,
readonly, built-in/default-library, and deprecated semantic roles remain active.
Oxocarbon's semantic links use modern capture names, with declaration modifiers
retaining its upstream function role. Deprecation adds strikethrough without
replacing a symbol's syntax color. Languages and servers that do not expose a
particular distinction cannot reproduce that source scope. Sublime grammar
scopes are translated into available Neovim captures; Sublime grammars are not
installed or substituted for Neovim parsers.

## Validation

Run from this repository with installed mini.base16, Snacks, Heirline, and
Tree-sitter queries/parsers:

```sh
NVIM_LOG_FILE=/tmp/syntax-check.log nvim --headless -u NONE -i NONE -n -l tests/nvim-syntax/check.lua
python tests/nvim-syntax/render.py
```

The render check needs `pynvim`, Pillow, and macOS Menlo. It attaches a real
Neovim UI, validates rendered backgrounds and semantic declaration/call colors,
and writes screenshots to a temporary directory. Its in-process LSP server uses
Neovim's actual semantic-token engine. The headless check covers restoration,
UI isolation, real Snacks callbacks, watcher changes during preview, restart
persistence, malformed/unknown state, and failed writes.

Ruby and Lua were installed locally. Contrary to the plan's assumption,
TypeScript and TSX were absent. They were built only in `/tmp` from the installed
nvim-treesitter registry's pinned revision
`75b3874edb2dc714fb1fd77a32013d0f8699989f` for these checks. An isolated parser
runtime can be supplied with `NVIM_SYNTAX_PARSER_RTP=/path/to/site` for both tests.
Install those parsers in the normal Neovim environment to use their query
extensions there.
