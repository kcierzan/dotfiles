local M = {}

local utils = require("heirline.utils")

function M.new()
  return {
    condition = function()
      return vim.fn.reg_recording() ~= ""
    end,
    provider = "󰑋 ",
    hl = { fg = utils.get_highlight("DiagnosticError").fg },
    utils.surround({ "[", "]" }, nil, {
      provider = function()
        return vim.fn.reg_recording()
      end,
      hl = { fg = utils.get_highlight("Delimiter").fg },
    }),
    update = {
      "RecordingEnter",
      "RecordingLeave",
    },
  }
end

return M
