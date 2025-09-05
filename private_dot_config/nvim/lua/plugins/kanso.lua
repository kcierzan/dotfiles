return {
  "webhooked/kanso.nvim",
  lazy = false,
  name = "kanso",
  priority = 1000,
  config = function()
    local theme_from_ghostty = vim.split(vim.g.ghostty_theme_name, "-")[2]
    local dark_theme = "zen"
    if vim.tbl_contains({ "zen", "ink", "mist" }, theme_from_ghostty) then
      dark_theme = theme_from_ghostty
    end

    require("kanso").setup({
      -- theme = "pearl",
      background = {
        dark = dark_theme,
        light = "pearl",
      },
      overrides = function(colors)
        local theme = colors.theme
        local overrides = {
          WinSeparator = { fg = theme.ui.bg_p2 },
          WhichKey = { fg = theme.ui.fg_dim },
          BlinkCmpKind = { bg = theme.ui.special, fg = "NONE" },
          BlinkCmpKindText = { fg = theme.ui.fg, bg = theme.ui.special },
          BlinkCmpKindMethod = { fg = theme.syn.fun, bg = theme.ui.special },
          BlinkCmpKindFunction = { fg = theme.syn.fun, bg = theme.ui.special },
          BlinkCmpKindConstructor = { fg = theme.syn.special1, bg = theme.ui.special },
          BlinkCmpKindField = { fg = theme.syn.parameter, bg = theme.ui.special },
          BlinkCmpKindVariable = { fg = theme.ui.fg_dim, bg = theme.ui.special },
          BlinkCmpKindClass = { fg = theme.syn.type, bg = theme.ui.special },
          BlinkCmpKindInterface = { fg = theme.syn.type, bg = theme.ui.special },
          BlinkCmpKindModule = { fg = theme.syn.preproc, bg = theme.ui.special },
          BlinkCmpKindProperty = { fg = theme.syn.parameter, bg = theme.ui.special },
          BlinkCmpKindUnit = { fg = theme.syn.number, bg = theme.ui.special },
          BlinkCmpKindValue = { fg = theme.syn.string, bg = theme.ui.special },
          BlinkCmpKindEnum = { fg = theme.syn.type, bg = theme.ui.special },
          BlinkCmpKindKeyword = { fg = theme.syn.keyword, bg = theme.ui.special },
          BlinkCmpKindSnippet = { fg = theme.syn.special1, bg = theme.ui.special },
          BlinkCmpKindColor = { fg = theme.syn.special1, bg = theme.ui.special },
          BlinkCmpKindFile = { fg = theme.syn.string, bg = theme.ui.special },
          BlinkCmpKindReference = { fg = theme.syn.special1, bg = theme.ui.special },
          BlinkCmpKindFolder = { fg = theme.syn.string, bg = theme.ui.special },
          BlinkCmpKindEnumMember = { fg = theme.syn.constant, bg = theme.ui.special },
          BlinkCmpKindConstant = { fg = theme.syn.constant, bg = theme.ui.special },
          BlinkCmpKindStruct = { fg = theme.syn.type, bg = theme.ui.special },
          BlinkCmpKindEvent = { fg = theme.syn.type, bg = theme.ui.special },
          BlinkCmpKindOperator = { fg = theme.syn.operator, bg = theme.ui.special },
          BlinkCmpKindTypeParameter = { fg = theme.syn.type, bg = theme.ui.special },
          BlinkCmpKindCopilot = { fg = theme.syn.string, bg = theme.ui.special },
          Pmenu = { bg = theme.ui.bg_p2 },
          PmenuSel = { bg = theme.ui.bg_search },
        }
        if vim.opt.background._value == "light" then
          overrides["Cursor"] = { bg = theme.ui.fg, fg = theme.ui.bg }
          overrides["Substitute"] = { bg = theme.term[2], fg = theme.ui.bg }
        end

        return overrides
      end,
    })
    vim.cmd.colorscheme("kanso")
  end,
}
