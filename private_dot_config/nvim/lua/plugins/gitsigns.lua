local lib = require("lib")

return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  config = true,
  keys = {
    { "<leader>gP", lib.ex_cmd("Gitsigns preview_hunk"), desc = "preview hunk" },
    { "<leader>gr", lib.ex_cmd("Gitsigns reset_hunk"), desc = "reset hunk" },
    { "<leader>gB", lib.ex_cmd("Gitsigns stage_buffer"), desc = "stage buffer" },
    { "<leader>gR", lib.ex_cmd("Gitsigns reset_buffer"), desc = "reset buffer" },
    { "<leader>gb", lib.ex_cmd("Gitsigns toggle_current_line_blame"), desc = "toggle blame" },
    { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"), desc = "stage hunk", mode = "v" },
    { "<leader>gr", lib.ex_cmd("'<,'>Gitsigns reset_hunk"), desc = "reset hunk", mode = "v" },
    { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"), desc = "stage hunk" },
    { "<leader>gp", lib.ex_cmd("Gitsigns nav_hunk next"), desc = "next hunk" },
    { "<leader>gn", lib.ex_cmd("Gitsigns nav_hunk prev"), desc = "prev hunk" },
  },
}
