local M = {}

local function load_catppuccin_mocha()
  return require("catppuccin.palettes").get_palette("mocha")
end

local function create_kanso_palette_loader(shade)
  return function()
    return require("kanso.colors").setup({ theme = shade }).palette
  end
end

local palettes = {
  ["catppuccin-mocha"] = load_catppuccin_mocha,
  ["kanso-ink"] = create_kanso_palette_loader("ink"),
  ["kanso-mist"] = create_kanso_palette_loader("mist"),
  ["kanso-pearl"] = create_kanso_palette_loader("pearl"),
  ["kanso-zen"] = create_kanso_palette_loader("zen"),
}

local function get_catppuccin_colors(scheme_colors)
  local utils = require("heirline.utils")
  return {
    segment_bg = scheme_colors.surface0,
    normal_mode_fg = scheme_colors.green,
    insert_mode_fg = scheme_colors.yellow,
    file_path_fg = scheme_colors.overlay1,
    file_name_fg = scheme_colors.text,
    modified_light_fg = scheme_colors.yellow,
    lsp_fg = scheme_colors.yellow,
    cwd_fg = scheme_colors.mauve,
    branch_fg = scheme_colors.cyan,
    override_sp = scheme_colors.surface2,
    statusline_bg = utils.get_highlight("Statusline").bg,
  }
end

local function get_kanso_colors()
  local utils = require("heirline.utils")
  return {
    segment_bg = utils.get_highlight("Cursorline").bg,
    insert_mode_fg = utils.get_highlight("String").fg,
    normal_mode_fg = utils.get_highlight("Function").fg,
    file_path_fg = utils.get_highlight("Operator").fg,
    file_name_fg = utils.get_highlight("Normal").fg,
    modified_light_fg = utils.get_highlight("Special").fg,
    lsp_fg = utils.get_highlight("Special").fg,
    cwd_fg = utils.get_highlight("Number").fg,
    branch_fg = utils.get_highlight("Type").fg,
    override_sp = utils.get_highlight("Operator").fg,
    statusline_bg = utils.get_highlight("Statusline").bg,
  }
end

local function get_kanso_pearl_colors()
  local utils = require("heirline.utils")
  local colors = get_kanso_colors()
  colors.file_name_fg = utils.get_highlight("Operator").fg
  colors.file_path_fg = utils.get_highlight("Normal").fg
  colors.segment_bg = utils.get_highlight("Pmenu").bg
  return colors
end

function M.get_scheme_colors()
  local theme_name = vim.g.ghostty_theme_name
  local palette_loader = palettes[theme_name]

  if not palette_loader then
    error("Unknown theme: " .. tostring(theme_name))
  end

  return palette_loader()
end

function M.get_colors()
  local theme_name = vim.g.ghostty_theme_name
  local scheme_colors = M.get_scheme_colors()

  if theme_name == "catppuccin-mocha" or theme_name == "catppuccin-xcode" then
    return get_catppuccin_colors(scheme_colors)
  elseif theme_name == "kanso-pearl" then
    return get_kanso_pearl_colors()
  elseif theme_name:match("^kanso%-") then
    return get_kanso_colors()
  else
    error("Unknown theme: " .. tostring(theme_name))
  end
end

return M

