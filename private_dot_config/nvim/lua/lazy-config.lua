local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

function M.setup()
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
end

function M.load_plugins()
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup("plugins", {
    defaults = {
      lazy = true,
      cond = not vim.g.vscode,
    },
    performance = {
      cache = {
        enabled = true,
      },
    },
  })
end

return M
