local M = {}

local utils = require("heirline.utils")

function M.new()
  return {
    provider = function()
      local wc = vim.api.nvim_eval("wordcount()")
      if wc["visual_words"] then
        return wc["visual_words"] .. " words"
      else
        return wc["words"] .. " words"
      end
    end,
    update = { "CursorMoved" },
    hl = { fg = utils.get_highlight("Function").fg },
  }
end

return M
