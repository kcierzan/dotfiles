local lib = require("lib")

return {
  {
    "echasnovski/mini.comment",
    keys = { "gc", "v", "V" },
    cond = true,
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    version = false,
    cond = true,
    event = "VeryLazy",
    keys = {
      {
        "S",
        mode = { "x" },
        function()
          require("mini.surround").add("visual")
        end,
      },
    },
    opts = {
      custom_surroundings = {
        d = {
          input = { "%b{}" },
          output = {
            left = "do\n",
            right = "\nend",
          },
        },
      },
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
      },
    },
  },
  {
    "echasnovski/mini.operators",
    keys = { "g=", "gx", "gm", "gr", "gs" },
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.icons",
    lazy = false,
    version = false,
    config = function()
      require("mini.icons").setup({})
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
  {
    "echasnovski/mini.ai",
    version = false,
    cond = true,
    keys = { "a", "i", "g" },
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    cond = true,
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.indentscope",
    enabled = false,
    version = false,
    event = "BufReadPre",
    opts = {
      symbol = "▎",
    },
  },
  {
    "echasnovski/mini.diff",
    enabled = false,
    version = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.bufremove",
    enabled = false,
    keys = { { "<leader>bd", lib.ex_cmd("bd"), desc = "delete" } },
    opts = {},
  },
}
