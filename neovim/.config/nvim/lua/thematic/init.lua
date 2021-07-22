local thematic = {}

function thematic.highlight(group, color)
   local style = color.style and 'gui=' .. color.style or 'gui=NONE'
   local fg = color.fg and 'guifg=' .. color.fg or 'guifg=NONE'
   local bg = color.bg and 'guibg=' .. color.bg or 'guibg=NONE'
   local sp = color.sp and 'guisp=' .. color.sp or ''
   vim.api.nvim_command('highlight ' .. group .. ' ' .. style .. ' ' .. fg ..
      ' ' .. bg..' '..sp)
end

function thematic.load_syntax()
  local syntax, pairs = dofile(os.getenv("HOME") .. "/.thematic/nvim-theme.lua")
  return syntax, pairs
end

function thematic.colorscheme()
   vim.api.nvim_command('hi clear')
   if vim.fn.exists('syntax_on') then
      vim.api.nvim_command('syntax reset')
   end
   vim.o.termguicolors = true
   vim.g.colors_name = 'thematic'
   local syntax, plugins = thematic.load_syntax()
   for group,colors in pairs(syntax) do
      thematic.highlight(group,colors)
   end
   for group, colors in pairs(plugins) do
      thematic.highlight(group, colors)
   end
end

thematic.colorscheme()

return thematic
