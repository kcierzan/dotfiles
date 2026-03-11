---@class Ghostty
local Ghostty = {}

---@type table<string, "light" | "dark">
local THEME_SHADES = {
  ["kanso-ink"] = "dark",
  ["kanso-mist"] = "dark",
  ["kanso-zen"] = "dark",
  ["kanso-pearl"] = "light",
  ["kanagawa-dragon"] = "dark",
  ["kanagawa-wave"] = "dark",
  ["kanagawa-lotus"] = "dark",
  ["catppuccin-mocha"] = "dark",
  ["catppuccin-xcode"] = "dark",
}

--- Read the variant ("dark" or "light") from the chezmoi-generated colors file.
--- This is used when the active ghostty theme is "base16" (managed by chezmoi).
---@return "light" | "dark"
local function get_base16_variant()
  local colors_path = vim.fn.stdpath("data") .. "/stylix-colors.lua"
  local ok, palette = pcall(dofile, colors_path)
  if ok and palette and palette.variant then
    return palette.variant == "light" and "light" or "dark"
  end
  return "dark"
end

---@return string?
local function get_ghostty_theme_name()
  if vim.g.vscode then
    return
  end

  local ok, result = pcall(function()
    return vim.system({ "ghostty", "+show-config" }):wait()
  end)

  if not ok then
    vim.schedule(function()
      vim.notify("ghostty: CLI not found in $PATH", vim.log.levels.WARN)
    end)
    return
  end

  if result.code == 0 then
    for line in result.stdout:gmatch("[^\r\n]+") do
      local theme_match = line:match("theme%s*=%s*(.+)")
      if theme_match then
        return theme_match:gsub("%s+", ""):gsub("\27%[[0-9;]*m", "") -- trim whitespace and strip ANSI codes
      end
    end
  end
end

---@return nil
local function set_shade_from_ghostty_theme()
  vim.g.ghostty_theme_name = get_ghostty_theme_name()
  local shade = THEME_SHADES[vim.g.ghostty_theme_name]
  if shade then
    vim.opt.background = shade
  elseif vim.g.ghostty_theme_name == "base16" then
    -- base16 theme is managed by chezmoi; read variant from generated colors file
    vim.opt.background = get_base16_variant()
  else
    vim.opt.background = "dark"
  end
end

---@return nil
function Ghostty.setup()
  set_shade_from_ghostty_theme()
end

---@type Ghostty
return Ghostty
