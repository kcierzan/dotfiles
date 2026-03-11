return {
  "michaelb/sniprun",
  build = "sh install.sh",
  cmd = { "SnipRun", "SnipInfo" },
  keys = require("keymaps").for_plugin("sniprun"),
  config = function()
    require("sniprun").setup({
      selected_interpreters = {
        "Lua_nvim",
      },
    })
  end,
}
