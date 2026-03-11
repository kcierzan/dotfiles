return {
  "pwntester/octo.nvim",
  enabled = true,
  cmd = { "Octo" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    picker = "snacks",
  },
}
