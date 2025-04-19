return {
  "Wansmer/treesj",
  event = "VeryLazy",
  cond = true,
  opts = {
    use_default_keymaps = false,
  },
  keys = {
    {
      "gS",
      mode = { "n" },
      function()
        require("treesj").split()
      end,
      desc = "split multiline expression",
    },
    {
      "gJ",
      mode = { "n" },
      function()
        require("treesj").join()
      end,
      desc = "join multiline expression",
    },
  },
}
