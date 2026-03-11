local M = {}

local SUPPORTED_THEMES = {
  "kanso-zen",
  "kanso-ink",
  "kanso-mist",
  "kanso-pearl",
}

local GHOSTTY_CONFIG_PATH = vim.fn.expand("~/.config/ghostty/config")

---@return string?
local function get_current_theme()
  local file = io.open(GHOSTTY_CONFIG_PATH, "r")
  if not file then
    return nil
  end

  for line in file:lines() do
    local theme = line:match("^theme%s*=%s*(.+)")
    if theme then
      file:close()
      return theme:gsub("%s+$", "") -- trim trailing whitespace
    end
  end

  file:close()
  return nil
end

---@param new_theme string
---@return boolean success
local function update_ghostty_theme(new_theme)
  local file = io.open(GHOSTTY_CONFIG_PATH, "r")
  if not file then
    vim.notify("Could not open ghostty config file", vim.log.levels.ERROR)
    return false
  end

  local lines = {}
  local theme_updated = false

  for line in file:lines() do
    if line:match("^theme%s*=") then
      table.insert(lines, "theme = " .. new_theme)
      theme_updated = true
    else
      table.insert(lines, line)
    end
  end
  file:close()

  -- If no theme line was found, add it at the beginning
  if not theme_updated then
    table.insert(lines, 1, "theme = " .. new_theme)
  end

  -- Write back to file
  file = io.open(GHOSTTY_CONFIG_PATH, "w")
  if not file then
    vim.notify("Could not write to ghostty config file", vim.log.levels.ERROR)
    return false
  end

  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()

  return true
end

local function reload_ghostty_config()
  local applescript = [[
tell application "Ghostty"
    activate
    tell application "System Events"
        key code 43 using {shift down, command down}
    end tell
end tell
]]

  local cmd = { "osascript", "-e", applescript }
  vim.system(cmd, {}, function(result)
    if result.code ~= 0 then
      vim.schedule(function()
        vim.notify("Failed to reload Ghostty config: " .. (result.stderr or ""), vim.log.levels.ERROR)
      end)
    end
  end)
end

---@param new_theme string
local function reload_plugins(new_theme)
  vim.schedule(function()
    vim.cmd("colorscheme " .. new_theme)

    vim.defer_fn(function()
      -- Send OSC sequence to query cursor color
      -- This requests the terminal to report its cursor color
      io.write("\027]12;?\027\\")
      io.flush()

      vim.cmd("Lazy reload heirline.nvim")
      vim.cmd("Lazy reload tiny-inline-diagnostic.nvim")
    end, 200)
  end)
end

---Create picker items from themes list
---@return table[]
local function create_theme_items()
  local current_theme = get_current_theme()
  local items = {}

  for i, theme in ipairs(SUPPORTED_THEMES) do
    table.insert(items, {
      idx = i,
      text = theme,
      theme = theme,
      is_current = theme == current_theme,
    })
  end

  return items
end

---Format function for theme picker
---@param item table
---@return table
local function format_theme_item(item)
  local prefix = item.is_current and "● " or "  "
  local hl_group = item.is_current and "Special" or nil

  return {
    { prefix .. item.text, hl_group },
  }
end

---Confirm action for theme selection
---@param picker table
---@param item table?
local function confirm_theme_change(picker, item)
  picker:close()
  if not item then
    return
  end

  if update_ghostty_theme(item.theme) then
    reload_ghostty_config()
    reload_plugins(item.theme)
  else
    vim.notify("Failed to update Ghostty theme", vim.log.levels.ERROR)
  end
end

---Show the current theme when picker opens
---@param picker table
local function on_picker_show(picker)
  -- Find and scroll to current theme
  for i, item in ipairs(picker:items()) do
    if item.is_current then
      picker.list:view(i)
      break
    end
  end
end

---Create the Ghostty theme picker
function M.switch_theme()
  return Snacks.picker.pick({
    items = create_theme_items(),
    title = "Ghostty Themes",
    format = format_theme_item,
    confirm = confirm_theme_change,
    on_show = on_picker_show,
    layout = { preset = "vscode" },
    sort = { fields = { "is_current:desc", "text" } }, -- Current theme first, then alphabetical
    matcher = { sort_empty = true },
  })
end

return M
