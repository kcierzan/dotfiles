-- Eviline config for lualine
-- Author: shadmansaleh
-- Credit: glepnir
local lualine = require('lualine')

-- Color table for highlights
-- stylua: ignore
local function get_colors()
  local file_path = os.getenv("INKD_DIR") .. "lualine.ink.lua"
  if io.open(file_path, "r") then
    return dofile(file_path)
  else
    print('inkd theme not found for lualine!. Make sure INKD_DIR is set and run `ink colors`.')
  end
end

local colors = get_colors()

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 85
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = '',
    section_separators = '',
    theme = {
      -- We are going to use lualine_c an lualine_x as left and
      -- right section. Both are highlighted by c theme .  So we
      -- are just setting default looks o statusline
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = {},
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x ot right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left {
  function()
    return '▊'
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
}

ins_left {
  -- mode component
  function()
    local cube = ''
    local hex_empty = ''
    local hex_full = ''
    local mode = vim.fn.mode()

    local modes = {
      n = "NORMAL",
      no = "OPERATOR PENDING",
      v = "VISUAL",
      V = "VISUAL LINE",
      ['^V'] = "VISUAL BLOCK",
      s = "SELECT",
      S = "SELECT LINE",
      ['^S'] = "SELECT BLOCK",
      i = "INSERT",
      ic = "INSERT COMPLETION",
      ix = "INSERT COMPLETION",
      R = "REPLACE",
      Rv = "VIRTUAL REPLACE",
      c = "COMMAND",
      cv = "VIM EX",
      ce = "EX",
      r = "HIT ENTER",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      t = "TERMINAL"
    }

    local mode_str = ""
    if mode == "i" or mode == "ic" or mode == "ix" then
      mode_str = cube
    elseif mode == "n" or mode == "no" or mode == "t" or mode == "!" then
      mode_str = hex_empty
    else
      mode_str = hex_full
    end

    return mode_str .. " " .. modes[mode]
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [''] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [''] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ['r?'] = colors.cyan,
      ['!'] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()], gui = "bold" }
  end,
  padding = { left = 0, right = 1 }
}

ins_left {
  'filetype',
  icon_only = true,
  colored = false,
  color = { fg = colors.blue, gui = 'bold' },
  padding = { left = 0, right = 1}
}

ins_left {
  'filename',
  cond = conditions.buffer_not_empty,
  path = 1,
  color = { fg = colors.blue },
  padding = { left = 0, right = 0}
}


ins_right {
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
}

local function show_lsp_info()
  local clients = vim.lsp.get_active_clients()
  return conditions.hide_in_width() and next(clients) ~= nil
end

ins_right {
  function()
    local msg = 'NONE'
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return client.name
      end
    end
    return msg
  end,
  icon = '力',
  color = { fg = colors.orange, gui = 'bold' },
  cond = show_lsp_info
}

ins_right {
  'fileformat',
  icons_enabled = true,
  color = { fg = colors.cyan, gui = 'bold' },
  cond = conditions.hide_in_width,
}

ins_right {
  'fileformat',
  icons_enabled = false,
  color = { fg = colors.cyan, gui = 'bold' },
  padding = { left = 0, right = 1 },
  cond = conditions.hide_in_width
}


ins_right {
  'branch',
  icon = '',
  color = { fg = colors.violet, gui = 'bold' },
}

ins_right {
  'diff',
  -- Is it me or the symbol for modified us really weird
  symbols = { added = ' ', modified = '柳 ', removed = ' ' },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
}

ins_right {
  function()
    local blocks = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' }
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)

    return string.rep(blocks[math.floor(curr_line / lines * 7) + 1], 2)
  end,
  color = { fg = colors.blue, bg = colors.bg },
  padding = { right = 0, left = 1 },
  cond = conditions.hide_in_width
}

ins_right {
  'progress',
  color = { fg = colors.blue, gui = 'bold' },
  padding = { right = 0, left = 0 },
  cond = conditions.hide_in_width
}

ins_right {
  function()
    return '▊'
  end,
  color = { fg = colors.blue },
  padding = { left = 1 },
}

-- Now don't forget to initialize lualine
lualine.setup(config)
