return {
  "monaqa/dial.nvim",
  keys = {
    {
      "<C-a>",
      mode = { "n" },
      function()
        require("dial.map").manipulate("increment", "normal")
      end,
    },
    {
      "<C-x>",
      mode = { "n" },
      function()
        require("dial.map").manipulate("decrement", "normal")
      end,
    },
    {
      "g<C-a>",
      mode = { "n" },
      function()
        require("dial.map").manipulate("increment", "gnormal")
      end,
    },
    {
      "g<C-x>",
      mode = { "n" },
      function()
        require("dial.map").manipulate("decrement", "gnormal")
      end,
    },
    {
      "<C-a>",
      mode = { "v" },
      function()
        require("dial.map").manipulate("increment", "visual")
      end,
    },
    {
      "<C-x>",
      mode = { "v" },
      function()
        require("dial.map").manipulate("decrement", "visual")
      end,
    },
    {
      "g<C-a>",
      mode = { "v" },
      function()
        require("dial.map").manipulate("increment", "gvisual")
      end,
    },
    {
      "g<C-x>",
      mode = { "v" },
      function()
        require("dial.map").manipulate("decrement", "gvisual")
      end,
    },
  },
  config = function()
    local augend = require("dial.augend")
    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,
        augend.date.alias["%Y-%m-%d"],
        augend.date.alias["%Y/%m/%d"],
        augend.constant.alias.bool,
        augend.constant.new({ elements = { "[ ]", "[x]" }, word = false }),
        augend.constant.new({ elements = { "true", "false" } }),
        augend.constant.new({ elements = { "yes", "no" } }),
        augend.constant.new({ elements = { "on", "off" } }),
        augend.constant.new({ elements = { "enable", "disable" } }),
        augend.constant.new({ elements = { "enabled", "disabled" } }),
        augend.constant.new({ elements = { "class", "module" } }),
        augend.constant.new({ elements = { "has_one", "has_many", "belongs_to" } }),
        augend.constant.new({ elements = { "if", "unless" } }),
        augend.constant.new({ elements = { "abstract!", "interface!" } }),
        augend.constant.new({ elements = { "extend", "include" } }),
        augend.constant.new({ elements = { "and", "or" } }),
        augend.constant.new({ elements = { "&&", "||" }, word = false }),
        augend.constant.new({ elements = { "==", "!=" }, word = false }),
        augend.constant.new({ elements = { "===", "!==" }, word = false }),
        augend.constant.new({ elements = { "let", "const" } }),
        augend.constant.new({ elements = { "public", "private", "protected" } }),
        augend.constant.new({ elements = { "pick", "drop", "reword", "edit", "squash", "fixup" } }),
        augend.semver.alias.semver,
        augend.hexcolor.new({ case = "lower" }),
      },
    })
  end,
}
