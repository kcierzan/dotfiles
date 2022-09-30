-- TODO: build in some hooks for plugins that do just-in-time themeing and
-- override the actual colorscheme set in init.lua
local thematic = {}

function thematic.highlight(group, color)
  local style = color.style and 'gui=' .. color.style or 'gui=NONE'
  local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
  local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
  local sp = color.sp and 'guisp=' .. color.sp or ''
  local command = 'highlight ' .. group .. ' ' .. style .. ' ' .. fg ..
  ' ' .. bg ..' '.. sp
  vim.api.nvim_command(command)
end

function thematic.load_syntax()
  local file_path = os.getenv("INKD_DIR") .. "neovim.ink.lua"
  if io.open(file_path, "r") then
    return dofile(file_path)
  else
    print('inkd theme not found!. Make sure INKD_DIR is set and run `ink colors`.')
  end
end

function thematic.colorscheme()
  vim.api.nvim_command('hi clear')
  if vim.fn.exists('syntax_on') then
    vim.api.nvim_command('syntax reset')
  end
  vim.o.termguicolors = true
  vim.g.colors_name = 'thematic'
  local highlights = thematic.load_syntax()
  for group, colors in pairs(highlights) do
    thematic.highlight(group, colors)
  end
end

thematic.colorscheme()

return thematic
