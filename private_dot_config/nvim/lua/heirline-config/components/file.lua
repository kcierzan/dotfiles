local M = {}

local utils = require("heirline.utils")

function M.new(palette)
  local FileNameBlock = {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
      self.filetype = vim.api.nvim_buf_get_option(0, "filetype")
    end,
  }

  local FilePath = {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":t")

      if not filename then
        return ""
      end

      local rel_path = vim.fn.fnamemodify(self.filename, ":~:.:h")

      if rel_path == "." then
        return "./"
      end

      return rel_path .. "/"
    end,
    hl = { fg = palette.file_path_fg },
  }

  local FileName = {
    provider = function(self)
      local filename = vim.fn.fnamemodify(self.filename, ":t")

      if self.filetype == "oil" then
        return ""
      end

      if filename == "" then
        filename = "[No Name]"
      end
      return filename
    end,
    hl = { fg = palette.file_name_fg, bold = true },
  }

  local FileFlags = {
    {
      condition = function()
        return vim.bo.modified
      end,
      provider = " ●",
      hl = { fg = palette.modified_light_fg },
    },
    {
      condition = function()
        return not vim.bo.modifiable or vim.bo.readonly
      end,
      provider = "󰌾",
      hl = { fg = utils.get_highlight("Comment").fg },
    },
  }

  local FileNameModifier = {
    hl = function()
      if vim.bo.modified then
        return { fg = utils.get_highlight("Boolean").fg, bold = true, force = true }
      end
    end,
  }

  local FileEncoding = {
    provider = function()
      local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
      return enc ~= "utf-8" and enc:upper()
    end,
  }

  local FileFormat = {
    provider = function()
      local fmt = vim.bo.fileformat
      return fmt ~= "unix" and fmt:upper()
    end,
  }

  return utils.insert(
    FileNameBlock,
    utils.insert(FileNameModifier, { FilePath, FileName }),
    FileFlags,
    FileEncoding,
    FileFormat,
    { provider = "%<" }
  )
end

return M
