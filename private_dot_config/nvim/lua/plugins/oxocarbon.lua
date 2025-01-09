return {
  "nyoom-engineering/oxocarbon.nvim",
  lazy = false,
  enabled = false,
  priority = 1000,
  config = function()
    vim.opt.background = "dark" -- set this to dark or light
    vim.cmd.colorscheme("oxocarbon")
    vim.api.nvim_set_hl(0, "TelescopeMatching", { link = "@function", bold = true })
  end,
}
