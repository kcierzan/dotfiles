local M = {}

function M.setup()
  local lib = require("lib")
  vim.g.mapleader = " "
  lib.nmap("+", "<Nop>")
  vim.g.maplocalleader = "+"

  -- these don't do anything useful
  lib.nmap("L", "<Nop>")
  lib.nmap("H", "<Nop>")
  lib.xmap("L", "<Nop>")
  lib.xmap("H", "<Nop>")

  -- shift + hl replaces ^ and g_
  lib.nmap("L", "g_")
  lib.nmap("H", "^")
  lib.xmap("L", "g_")
  lib.xmap("H", "^")
  lib.omap("H", "^")
  lib.omap("L", "g_")

  -- ctrl + hl to cycle buffers
  lib.nmap("<C-l>", lib.ex_cmd("bnext"))
  lib.nmap("<C-h>", lib.ex_cmd("bprev"))

  -- alt + hjkl moves between splits
  lib.nmap("<A-h>", "<C-w>h")
  lib.nmap("<A-j>", "<C-w>j")
  lib.nmap("<A-k>", "<C-w>k")
  lib.nmap("<A-l>", "<C-w>l")

  -- Modern LSP keybindings with descriptions
  vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "LSP hover" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.incoming_calls, { desc = "Incoming calls" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
  vim.keymap.set("n", "gR", vim.lsp.buf.rename, { desc = "LSP rename" })
  vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code action" })
  vim.keymap.set("n", "]e", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  vim.keymap.set("n", "[e", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  lib.nmap("]g", lib.ex_cmd("Gitsigns next_hunk"))
  lib.nmap("[g", lib.ex_cmd("Gitsigns prev_hunk"))

  -- TODO: move this into luasnip config
  vim.api.nvim_set_keymap("i", "<C-,>", "<Nop>", { noremap = true, silent = true })
end

return M
