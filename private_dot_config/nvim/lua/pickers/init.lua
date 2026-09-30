---@class Pickers
local M = {}

local excludes = require("pickers.excludes")
local terminals = require("pickers.terminals")
local theme = require("pickers.theme-picker")

M.with_dynamic_excludes = excludes.with_dynamic_excludes
M.switch_theme = theme.switch_theme
M.switch_syntax = require("pickers.syntax-picker").switch_syntax
M.terminals = terminals.pick

---@type Pickers
return M
