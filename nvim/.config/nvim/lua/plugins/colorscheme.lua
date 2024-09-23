return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        compile = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          if vim.g.neovide then
            return {}
          end
          return {
            Normal = { bg = "None", fg = colors.theme.ui.fg },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa-wave")
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require("nordic").setup({
        transparent_bg = false,
      })
      require("nordic").load()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon",
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.opt.background = "dark"
      vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    enabled = false,
    config = function()
      require("monokai-pro").setup({
        transparent_background = false,
        -- filter = "octagon",
        filter = "pro",
      })

      vim.cmd("colorscheme monokai-pro")
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      require("dracula").setup({
        transparent_bg = true,
      })
      vim.cmd.colorscheme("dracula")
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    enabled = true,
    config = function()
      vim.opt.background = "light"

      local base = {
        red = "#ff657a",
        maroon = "#F29BA7",
        peach = "#ff9b5e",
        yellow = "#eccc81",
        green = "#a8be81",
        teal = "#9cd1bb",
        sky = "#A6C9E5",
        sapphire = "#86AACC",
        blue = "#5d81ab",
        lavender = "#66729C",
        mauve = "#b18eab",
      }

      local extend_base = function(value)
        return vim.tbl_extend("force", base, value)
      end

      require("catppuccin").setup({
        integrations = {
          cmp = true,
          gitsigns = true,
          which_key = true,
          flash = true,
          dashboard = true,
          lsp_trouble = true,
          telescope = {
            enabled = true,
            style = "nvchad",
          },
          nvimtree = true,
          treesitter = true,
          notify = true,
          noice = true,
          neotest = true,
          mini = {
            enabled = true,
          },
        },
        term_colors = true,
        background = {
          dark = "mocha",
          light = "latte",
        },
        -- color_overrides = {
        --   latte = extend_base({
        --     text = "#202027",
        --     subtext1 = "#263168",
        --     subtext0 = "#4c4f69",
        --     overlay2 = "#737994",
        --     overlay1 = "#838ba7",
        --     base = "#fcfcfa",
        --     mantle = "#EAEDF3",
        --     crust = "#DCE0E8",
        --     pink = "#EA7A95",
        --     mauve = "#986794",
        --     red = "#EC5E66",
        --     peach = "#FF8459",
        --     yellow = "#CAA75E",
        --     green = "#87A35E",
        --   }),
        --   frappe = extend_base({
        --     text = "#fcfcfa",
        --     surface2 = "#535763",
        --     surface1 = "#3a3d4b",
        --     surface0 = "#30303b",
        --     base = "#202027",
        --     mantle = "#1c1d22",
        --     crust = "#171719",
        --   }),
        -- },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
