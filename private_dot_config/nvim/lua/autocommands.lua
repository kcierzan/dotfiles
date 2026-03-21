local M = {}

local function start_terminals_in_insert()
  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.cmd("startinsert")
    end,
  })
end

local function display_macro_recording_indicator()
  local macro_group = vim.api.nvim_create_augroup("MacroRecording", { clear = true })
  vim.api.nvim_create_autocmd("RecordingLeave", {
    group = macro_group,
    callback = function()
      print("Macro recording stopped")
    end,
  })
end

local function show_buffers_on_disk()
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    pattern = "*",
    command = "silent! checktime",
  })
end
--
local function auto_highlight_treesitter()
  -- Enable treesitter highlighting for all filetypes (uses Neovim's built-in feature)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      -- Skip special buffers
      if vim.bo.buftype ~= "" then
        return
      end
      -- Enable treesitter highlighting if a parser exists for this filetype
      local ok = pcall(vim.treesitter.start)
      if ok then
        -- Disable legacy syntax highlighting
        vim.bo.syntax = ""
      end
    end,
  })

  -- Enable treesitter-based indentation (experimental, skip ruby as before)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      if vim.bo.buftype ~= "" or vim.bo.filetype == "ruby" then
        return
      end
      local _ = pcall(function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end)
    end,
  })
end

function M.setup()
  start_terminals_in_insert()
  display_macro_recording_indicator()
  show_buffers_on_disk()
  auto_highlight_treesitter()
end

return M
