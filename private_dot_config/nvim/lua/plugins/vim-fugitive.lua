local lib = require("lib")

return {
  enabled = false,
  "tpope/vim-fugitive",
  dependencies = { "tpope/vim-rhubarb" },
  keys = {
    { "<leader>go", lib.ex_cmd("'<,'>GBrowse"), desc = "open in github", mode = "v" },
    {
      "<leader>gd",
      lib.ex_cmd("Gvdiffsplit"),
      desc = "diff staged & working tree",
    },
    { "<leader>gc", lib.ex_cmd("Gvdiffsplit!"), desc = "3 way merge" },
    { "<leader>go", lib.ex_cmd("GBrowse"), desc = "open in github" },
    { "<leader>gs", lib.ex_cmd("Git"), desc = "status" },
  },
  cmd = {
    "Git",
    "GBrowse",
    "GDelete",
    "GMove",
    "Gread",
    "Gwrite",
    "Gvdiffsplit",
    "Gdiffsplit",
    "Gedit",
  },
}
