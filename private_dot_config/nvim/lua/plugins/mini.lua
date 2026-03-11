local lib = require("lib")

return {
  {
    "nvim-mini/mini.comment",
    keys = { "gc", "v", "V" },
    cond = true,
    version = false,
    opts = {},
  },
  {
    "nvim-mini/mini.surround",
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
    "nvim-mini/mini.operators",
    keys = { "g=", "gx", "gm", "gr", "gs" },
    -- conflicts with new lsp bindings
    enabled = false,
    version = false,
    opts = {},
  },
  {
    "nvim-mini/mini.icons",
    lazy = false,
    version = false,
    config = function()
      require("mini.icons").setup({})
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
  {
    "nvim-mini/mini.ai",
    version = false,
    cond = true,
    keys = { "a", "i", "g" },
    opts = {},
  },
  {
    "nvim-mini/mini.pairs",
    enabled = false,
    version = false,
    cond = true,
    event = "InsertEnter",
    opts = {},
  },
  {
    "nvim-mini/mini.indentscope",
    enabled = false,
    version = false,
    event = "BufReadPre",
    opts = {
      symbol = "▎",
    },
  },
  {
    "nvim-mini/mini.diff",
    enabled = false,
    version = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-mini/mini.bufremove",
    enabled = false,
    keys = {
      { "<leader>wd", lib.ex_cmd("bd"), desc = "delete" },
    },
    opts = {},
  },
  {
    "nvim-mini/mini.base16",
    version = "*",
    enabled = false, -- Disabled: requires Stylix-generated colors from Nix
    lazy = false,
    priority = 1000, -- Load before other plugins to ensure colorscheme is available
    config = function()
      -- Load the auto-generated Stylix color palette from XDG data directory
      -- This file is managed by Nix and regenerated on each rebuild
      local colors_path = vim.fn.stdpath("data") .. "/stylix-colors.lua"
      local ok, palette = pcall(dofile, colors_path)
      if ok and palette and next(palette) ~= nil then
        require("mini.base16").setup({ palette = palette })
      else
        -- Fallback: Stylix colors not available, use a default palette
        vim.notify("Stylix colors not available at " .. colors_path, vim.log.levels.WARN)
        return
      end

      -- Load and apply highlight overrides from repo-local file
      -- Edit lua/stylix-highlights.lua to customize (no rebuild needed)
      local hok, highlights = pcall(require, "stylix-highlights")
      if hok and highlights and highlights.get_overrides then
        local function apply_overrides()
          for group, attrs in pairs(highlights.get_overrides()) do
            vim.api.nvim_set_hl(0, group, attrs)
          end
        end

        -- create our own base16 highlight groups
        highlights.create_base16_hl_groups()

        -- Apply immediately after colorscheme setup
        apply_overrides()

        -- Reapply on colorscheme changes (persistence)
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = vim.api.nvim_create_augroup("StylixHighlightOverrides", { clear = true }),
          callback = apply_overrides,
        })
      end
    end,
  },
}
