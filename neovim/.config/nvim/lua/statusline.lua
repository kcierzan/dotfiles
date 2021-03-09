local colors = {
  bg = '#32302f',
  line_bg = '#45403d',
  fg = '#ddc7a1',
  green = '#a9b665',
  yellow = '#d8a657',
  cyan = '#89b482',
  blue = '#7daea3',
  orange = '#e78a4e',
  magenta = '#d3869b',
  red = '#ea6962'
}

local gl = require('galaxyline')
local gls = gl.section
local ls_right_separator = ""
local ls_left_separator = ""

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
    if diff[1] ~= -1 or diff[2] ~= -1 or diff[3] ~= -1 then
      return true
    end
  end
  return false
end

local function checkwidth()
  return buffer_not_empty() and has_width_gt(30)
end

local function has_diagnostic_info()
  local has_info, _ = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if has_info then return true end
  return false
end

local sep_hl = {colors.line_bg, colors.bg}


local lsl_sep_collapse = {
  LsLeftSeparator = {
    provider = function() return " " end,
    highlight = {colors.line_bg, colors.bg},
    condition = checkwidth,
  }
}

local lsl_coc_separator = {
  LslCocSep = {
    provider = function() return " " end,
    highlight = {colors.line_bg, colors.bg},
    condition = has_diagnostic_info,
  }
}

local lsl_diff_separator = {
  LslDiffSep = {
    provider = function() return " " end,
    -- provider = function() return has_signify_diff() end,
    highlight = {colors.line_bg, colors.bg},
    condition = function() return checkwidth() and has_signify_diff() end,
  }
}

local lsl_sep_fixed = {
  LslSeparator = {
    provider = function() return " " end,
    highlight = {colors.line_bg, colors.bg},
    condition = buffer_not_empty,
  }
}

gls.left = {
  {
    FirstElement = {
      provider = function() return ' ' end,
      highlight = {colors.blue, colors.line_bg}
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
          n = colors.blue,
          i = colors.green,
          v=colors.magenta,
          [''] = colors.magenta,
          V=colors.blue,
          c = colors.red,
          no = colors.magenta,
          s = colors.orange,
          S=colors.orange,
          [''] = colors.orange,
          ic = colors.yellow,
          R = colors.magenta,
          Rv = colors.magenta,
          cv = colors.red,
          ce=colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ['r?'] = colors.cyan,
          ['!']  = colors.green,
          t = colors.green,
      }
      local vim_mode = vim.fn.mode()
      vim.api.nvim_command('hi GalaxyViMode guifg=' .. mode_color[vim_mode] .. ' guibg=' .. colors.line_bg)
      return alias[vim_mode] .. ' '
    end,
    separator = ls_right_separator,
    separator_highlight = sep_hl
    }
  },
  lsl_sep_fixed,
  {
    FileIcon = {
      provider = 'FileIcon',
      condition = buffer_not_empty,
      highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color, colors.line_bg},
    }
  },
  {
    FileName = {
      provider = 'FileName',
      condition = buffer_not_empty,
      highlight = {colors.fg, colors.line_bg, 'bold'},
      separator = "| ",
      separator_highlight = {colors.fg, colors.line_bg, 'bold'},
    }
  },
  {
    FileSize = {
      provider = 'FileSize',
      condition = buffer_not_empty,
      highlight = { colors.fg, colors.line_bg},
      separator = ls_right_separator,
      separator_highlight = sep_hl
    }
  },
  lsl_sep_collapse,
  {
    GitIcon = {
      provider = function() return '  ' end,
      condition = checkwidth,
      highlight = {colors.red, colors.line_bg},
    }
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = checkwidth,
      highlight = {colors.fg, colors.line_bg},
      separator = ls_right_separator,
      separator_highlight = sep_hl,
    }
  },
  lsl_diff_separator,
  {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = function() return checkwidth() and has_signify_diff() end,
      highlight = {colors.green, colors.line_bg},
      icon = ' ',
    }
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = function() return checkwidth() and has_signify_diff() end,
      highlight = {colors.blue, colors.line_bg},
      icon = ' ',
    }
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = function() return checkwidth() and has_signify_diff() end,
      highlight = {colors.red, colors.line_bg},
      icon = ' ',
      separator = ls_right_separator,
      separator_highlight = sep_hl,
    }
  },
  lsl_coc_separator,
  {
    CocHint = {
      provider = 'DiagnosticHint',
      highlight = {colors.green, colors.line_bg},
      icon = ' ',
      condition = has_diagnostic_info,
      separator = ' ',
      separator_highlight = {colors.line_bg, colors.line_bg},
    }
  },
  {
    CocInfo = {
      provider = 'DiagnosticInfo',
      highlight = {colors.blue, colors.line_bg},
      icon = ' ',
      condition = has_diagnostic_info,
      separator = ' ',
      separator_highlight = {colors.line_bg, colors.line_bg},
    }
  },
  {
    CocWarning = {
      provider = 'DiagnosticWarn',
      highlight = {colors.yellow, colors.line_bg},
      icon = ' ',
      condition = has_diagnostic_info,
      separator = ' ',
      separator_highlight = {colors.line_bg, colors.line_bg},
    }
  },
  {
    CocStatus = {
      provider = 'DiagnosticError',
      highlight = {colors.red, colors.line_bg},
      separator = ls_right_separator,
      separator_highlight = sep_hl,
      icon = ' ',
      condition = has_diagnostic_info,
    }
  },
}

gls.right = {
  lsl_sep_fixed,
  {
    LineInfo = {
      provider = 'LineColumn',
      highlight = {colors.fg, colors.line_bg},
    }
  },
  {
    Space = {
      provider = function() return ' ' end,
      highlight = {colors.line_bg, colors.line_bg},
    }
  }
}
