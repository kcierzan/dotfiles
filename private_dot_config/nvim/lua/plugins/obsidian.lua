return {
  "obsidian-nvim/obsidian.nvim",
  cmd = "Obsidian",
  ft = "markdown",
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "work-notes",
        path = "~/Documents/betterment"
      },
      {
        name = "home-pc-vault",
        path = "~/home-pc-vault"
      }
    }
  }
}
