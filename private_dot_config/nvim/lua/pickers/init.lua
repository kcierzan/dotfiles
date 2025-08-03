---@class Pickers
local M = {}

local excludes = require("pickers.excludes")

M.with_dynamic_excludes = excludes.with_dynamic_excludes

---@type Pickers
return M
