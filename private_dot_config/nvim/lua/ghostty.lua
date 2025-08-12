---@class Ghostty
local Ghostty = {}

---@type table<string, "light" | "dark">
local THEME_SHADES = {
  ["kanso-ink"] = "dark",
  ["kanso-mist"] = "dark",
  ["kanso-zen"] = "dark",
  ["kanso-pearl"] = "light",
  ["catppuccin-mocha"] = "dark",
  ["catppuccin-xcode"] = "dark",
}

---@return string?
local function get_ghostty_theme_name()
  local ghostty_config = vim.system({ "ghostty", "+show-config" }):wait()
  if ghostty_config.code == 0 then
    for line in ghostty_config.stdout:gmatch("[^\r\n]+") do
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
  vim.opt.background = THEME_SHADES[vim.g.ghostty_theme_name] or "dark"
end

---@return nil
function Ghostty.setup()
  set_shade_from_ghostty_theme()
end

---@type Ghostty
return Ghostty
