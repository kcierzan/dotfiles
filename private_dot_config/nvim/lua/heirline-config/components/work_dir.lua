local M = {}

function M.new(palette)
  return {
    provider = function()
      local cwd = vim.fn.getcwd(0)
      local icon = require("mini.icons").get("directory", cwd)
      icon = (vim.fn.haslocaldir(0) == 1 and "[local] " or "") .. icon .. " "
      cwd = vim.fn.fnamemodify(cwd, ":~")
      cwd = vim.fn.fnamemodify(cwd, ":t")
      local conditions = require("heirline.conditions")
      if not conditions.width_percent_below(#cwd, 0.25) then
        cwd = vim.fn.pathshorten(cwd)
      end
      return icon .. cwd
    end,
    hl = { fg = palette.cwd_fg },
  }
end

return M
