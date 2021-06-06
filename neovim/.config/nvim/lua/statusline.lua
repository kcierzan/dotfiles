local theme = dofile(os.getenv("HOME") .. "/.thematic/galaxyline-colors.lua")
local bars = dofile(os.getenv("HOME") .. "/.thematic/galaxyline-separators.lua")

local gl = require('galaxyline')
local gls = gl.section
local diagnostic = require('galaxyline.provider_diagnostic')

gl.short_line_list = {
  'LuaTree',
  'vista',
  'dbui',
  'dashboard',
  'term',
  'fugitive',
  'fugitiveblame',
  'packer'
}

local function buffer_not_empty()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local function has_width_gt(cols)
  return vim.fn.winwidth(0) / 2 > cols
end

local function has_signify_diff()
  if vim.fn.exists('*sy#repo#get_stats') then
    local diff = vim.fn['sy#repo#get_stats']()
    if diff[1] < 1 or diff[2] < 1 or diff[3] < 1 then
      return true
    end
  end
  return false
end

local function checkwidth()
  return buffer_not_empty() and has_width_gt(30)
end

local sep_hl = {theme.line_bg, theme.bg}

local lsl_sep_collapse = {
  LsLeftSeparator = {
    provider = function() return " " end,
    highlight = {theme.line_bg, theme.bg},
    condition = checkwidth,
  }
}

local lsl_coc_separator = {
  LslCocSep = {
    provider = function()
      local spaced = " " .. bars.ls_left_separator
      return spaced
    end,
    highlight = {theme.line_bg, theme.bg},
  }
}

local lsl_diff_separator = {
  LslDiffSep = {
    provider = function()
      local spaced = " " .. bars.ls_left_separator
      return spaced
    end,
    highlight = {theme.line_bg, theme.bg},
    condition = function() return checkwidth() and has_signify_diff() end,
  }
}

local lsl_sep_fixed = {
  LslSeparator = {
    provider = function()
      local spaced = " " .. bars.ls_left_separator
      return spaced
    end,
    highlight = {theme.line_bg, theme.bg},
    condition = buffer_not_empty,
  }
}

gls.left = {
  {
    FirstElement = {
      provider = function() return ' ' end,
      highlight = {theme.blue, theme.line_bg}
    }
  },
  {
    ViMode = {
    provider = function()
      local alias = {
          n = 'NORMAL',
          i = 'INSERT',
          c = 'COMMAND',
          V = 'VISUAL',
          [''] = 'VISUAL',
          v ='VISUAL',
          ['r?'] = ':CONFIRM',
          rm = '--MORE',
          R = 'REPLACE',
          Rv = 'VIRTUAL',
          s = 'SELECT',
          S = 'SELECT',
          ['r']  = 'HIT-ENTER',
          [''] = 'SELECT',
          t = 'TERMINAL',
          ['!']  = 'SHELL',
      }
      local mode_color = {
          n = theme.blue,
          i = theme.green,
          v=theme.magenta,
          [''] = theme.magenta,
          V=theme.blue,
          c = theme.red,
          no = theme.magenta,
          s = theme.orange,
          S=theme.orange,
          [''] = theme.orange,
          ic = theme.yellow,
          R = theme.magenta,
          Rv = theme.magenta,
          cv = theme.red,
          ce=theme.red,
          r = theme.cyan,
          rm = theme.cyan,
          ['r?'] = theme.cyan,
          ['!']  = theme.green,
          t = theme.green,
      }
      local vim_mode = vim.fn.mode()
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim_mode] .. ' guibg=' .. theme.line_bg)
      return alias[vim_mode] .. ' '
    end,
    separator = bars.ls_right_separator,
    separator_highlight = sep_hl
    }
  },
  lsl_sep_fixed,
  {
    FileIcon = {
      provider = 'FileIcon',
      condition = buffer_not_empty,
      highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, theme.line_bg},
    }
  },
  {
    FileName = {
      provider = 'FileName',
      condition = buffer_not_empty,
      highlight = {theme.fg, theme.line_bg, 'bold'},
      separator = "| ",
      separator_highlight = {theme.fg, theme.line_bg, 'bold'},
    }
  },
  {
    FileSize = {
      provider = 'FileSize',
      condition = buffer_not_empty,
      highlight = { theme.fg, theme.line_bg},
      separator = bars.ls_right_separator,
      separator_highlight = sep_hl
    }
  },
  lsl_sep_collapse,
  {
    GitIcon = {
      provider = function() return '  ' end,
      condition = checkwidth,
      highlight = {theme.red, theme.line_bg},
    }
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = checkwidth,
      highlight = {theme.fg, theme.line_bg},
      separator = bars.ls_right_separator,
      separator_highlight = sep_hl,
    }
  },
  lsl_diff_separator,
  {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = function() return checkwidth() and has_signify_diff() end,
      highlight = {theme.green, theme.line_bg},
      icon = ' ',
    }
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = function() return checkwidth() and has_signify_diff() end,
      highlight = {theme.blue, theme.line_bg},
      icon = ' ',
    }
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = function() return checkwidth() and has_signify_diff() end,
      highlight = {theme.red, theme.line_bg},
      icon = ' ',
      separator = bars.ls_right_separator,
      separator_highlight = sep_hl,
    }
  },
  lsl_coc_separator,
  {
    CocHint = {
      provider = diagnostic.get_diagnostic_hint,
      highlight = {theme.green, theme.line_bg},
      icon = ' ',
      separator = ' ',
      separator_highlight = {theme.line_bg, theme.line_bg},
    }
  },
  {
    CocInfo = {
      provider = diagnostic.get_diagnostic_info,
      highlight = {theme.blue, theme.line_bg},
      icon = ' ',
      separator = ' ',
      separator_highlight = {theme.line_bg, theme.line_bg},
    }
  },
  {
    CocWarning = {
      provider = diagnostic.get_diagnostic_warn,
      highlight = {theme.yellow, theme.line_bg},
      icon = ' ',
      separator = ' ',
      separator_highlight = {theme.line_bg, theme.line_bg},
    }
  },
  {
    CocStatus = {
      provider = diagnostic.get_diagnostic_error,
      highlight = {theme.red, theme.line_bg},
      separator = bars.ls_right_separator,
      separator_highlight = sep_hl,
      icon = ' ',
    }
  },
}

gls.right = {
  lsl_sep_fixed,
  {
    LineInfo = {
      provider = 'LineColumn',
      highlight = {theme.fg, theme.line_bg},
    }
  },
  {
    Space = {
      provider = function() return ' ' end,
      highlight = {theme.line_bg, theme.line_bg},
    }
  }
}
