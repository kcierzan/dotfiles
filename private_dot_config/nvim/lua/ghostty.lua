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
  vim.opt.background = THEME_SHADES[vim.g.ghostty_theme_name] or "dark"
end

---@return nil
function Ghostty.setup()
  set_shade_from_ghostty_theme()
end

---@type Ghostty
return Ghostty
