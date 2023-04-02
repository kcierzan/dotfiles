return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "RRethy/nvim-treesitter-endwise"
  },
  build = "TSUpdate",
  event = "UIEnter",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "fish",
        "dockerfile",
        "go",
        "haskell",
        "html",
        "java",
        "julia",
        "lua",
        "make",
        "markdown",
        "php",
        "python",
        "ruby",
        "rust",
        "scss",
        "typescript",
        "vim",
        "yaml"
      },
      sync_install = false,
      highlight = { enable = true },
      endwise = { enable = true}
    })
  end
}
