local Vscode = {}

function Vscode.setup()
  -- communicate the full mode to vscode
  if vim.g.vscode then
    local vscode = require("vscode")

    vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
      callback = function()
        vscode.call("setContext", {
          args = { "neovim.fullMode", vim.fn.mode(1) },
        })
      end,
    })
  else
    -- always display the file as it exists on disk
    vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
      pattern = "*",
      command = [[if &readonly==0 && filereadable(bufname('%')) | silent update | endif]],
    })
    -- reset the cursor to a pipe shape on exit
    vim.api.nvim_create_autocmd("VimLeave", {
      pattern = "*",
      command = "set guicursor=a:ver25",
    })
  end
end

return Vscode
