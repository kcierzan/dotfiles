local lib = require("lib")
return {
  "michaelb/sniprun",
  branch = "master",
  enabled = true,
  build = "sh install.sh",
  cmd = { "SnipRun", "SnipInfo" },
  keys = {
    {
      "<leader>rr",
      function()
        lib.ex_cmd("Sniprun")
      end,
      desc = "run line",
    },
    {
      "<leader>rr",
      function()
        lib.ex_cmd("'<,'>Sniprun")
      end,
      desc = "run block",
    },
    {
      "<leader>ri",
      function()
        lib.ex_cmd("SnipInfo")
      end,
      desc = "info",
    },
    {
      "<leader>rc",
      function()
        lib.ex_cmd("SnipReset")
      end,
      desc = "reset",
    },
  },
  config = function()
    require("sniprun").setup({
      selected_interpreters = {
        "Lua_nvim",
      },
    })
  end,
}
