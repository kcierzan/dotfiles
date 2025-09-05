---@class Pickers
local M = {}

local excludes = require("pickers.excludes")
local theme = require("pickers.theme-picker")

M.with_dynamic_excludes = excludes.with_dynamic_excludes
M.switch_theme = theme.switch_theme

---@type Pickers
return M
