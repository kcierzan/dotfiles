return {
  "webhooked/kanso.nvim",
  lazy = false,
  name = "kanso",
  priority = 1000,
  config = function()
    require("kanso").setup({
      theme = "zen",
      background = {
        dark = "ink",
        light = "pearl",
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          WinSeparator = { fg = colors.palette.inkBlack2 },
          WhichKey = { fg = colors.palette.fujiGray },
          BlinkCmpKind = { bg = colors.palette.zen3, fg = "NONE" },
          BlinkCmpKindText = { fg = theme.ui.fg, bg = colors.palette.zen3 },
          BlinkCmpKindMethod = { fg = theme.syn.fun, bg = colors.palette.zen3 },
          BlinkCmpKindFunction = { fg = theme.syn.fun, bg = colors.palette.zen3 },
          BlinkCmpKindConstructor = { fg = theme.syn.special1, bg = colors.palette.zen3 },
          BlinkCmpKindField = { fg = theme.syn.parameter, bg = colors.palette.zen3 },
          BlinkCmpKindVariable = { fg = theme.ui.fg_dim, bg = colors.palette.zen3 },
          BlinkCmpKindClass = { fg = theme.syn.type, bg = colors.palette.zen3 },
          BlinkCmpKindInterface = { fg = theme.syn.type, bg = colors.palette.zen3 },
          BlinkCmpKindModule = { fg = theme.syn.preproc, bg = colors.palette.zen3 },
          BlinkCmpKindProperty = { fg = theme.syn.parameter, bg = colors.palette.zen3 },
          BlinkCmpKindUnit = { fg = theme.syn.number, bg = colors.palette.zen3 },
          BlinkCmpKindValue = { fg = theme.syn.string, bg = colors.palette.zen3 },
          BlinkCmpKindEnum = { fg = theme.syn.type, bg = colors.palette.zen3 },
          BlinkCmpKindKeyword = { fg = theme.syn.keyword, bg = colors.palette.zen3 },
          BlinkCmpKindSnippet = { fg = theme.syn.special1, bg = colors.palette.zen3 },
          BlinkCmpKindColor = { fg = theme.syn.special1, bg = colors.palette.zen3 },
          BlinkCmpKindFile = { fg = theme.syn.string, bg = colors.palette.zen3 },
          BlinkCmpKindReference = { fg = theme.syn.special1, bg = colors.palette.zen3 },
          BlinkCmpKindFolder = { fg = theme.syn.string, bg = colors.palette.zen3 },
          BlinkCmpKindEnumMember = { fg = theme.syn.constant, bg = colors.palette.zen3 },
          BlinkCmpKindConstant = { fg = theme.syn.constant, bg = colors.palette.zen3 },
          BlinkCmpKindStruct = { fg = theme.syn.type, bg = colors.palette.zen3 },
          BlinkCmpKindEvent = { fg = theme.syn.type, bg = colors.palette.zen3 },
          BlinkCmpKindOperator = { fg = theme.syn.operator, bg = colors.palette.zen3 },
          BlinkCmpKindTypeParameter = { fg = theme.syn.type, bg = colors.palette.zen3 },
          BlinkCmpKindCopilot = { fg = theme.syn.string, bg = colors.palette.zen3 },
          Pmenu = { bg = colors.palette.zen2 },
        }
      end,
    })
    vim.cmd.colorscheme("kanso")
  end,
}
