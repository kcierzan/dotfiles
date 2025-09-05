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

local function force_treesitter_start()
  -- enable TS features explicitly (these used to be flaky)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = {
      "c",
      "cpp",
      "eruby",
      "go",
      "html",
      "javascript",
      "lua",
      "python",
      "ruby",
      "rust",
      "svelte",
      "typescript",
      "yaml",
    },
    callback = function()
      vim.cmd("TSBufEnable highlight")
      vim.cmd("TSBufEnable endwise")
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "templ", "typescriptreact" },
    callback = function()
      vim.treesitter.start()
    end,
  })
end

local function show_buffers_on_disk()
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    pattern = "*",
    command = "silent! checktime",
  })
end

function M.setup()
  start_terminals_in_insert()
  display_macro_recording_indicator()
  show_buffers_on_disk()
  if not vim.g.vscode then
    force_treesitter_start()
  end
end

return M
