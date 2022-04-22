local packer_bootstrap
local fn = vim.fn
local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

local packer = require("packer")
local util = require("packer.util")

packer.init({
  compile_path = util.join_paths(vim.fn.stdpath("config"), "lua", "plugin", "packer_compiled.lua")
})

return packer.startup(function(use)
  use "wbthomason/packer.nvim"
  use "lewis6991/impatient.nvim"
  use "nvim-lua/plenary.nvim"
  use {
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
    requires = {"nvim-telescope/telescope.nvim"},
    config = function()
      require("telescope").setup {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--color=never",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--trim",
            "--glob",
            "!.git/"
          },

        },
        pickers = {
          find_files = {
            find_command = {
              "fd",
              "--type",
              "f",
              "--hidden",
              "--strip-cwd-prefix",
              "--exclude",
              "*.pyc",
              "--exclude",
              ".git/",
              "--exclude",
              "node_modules",
              "--exclude",
              "*.jpg",
              "--exclude",
              "*.png",
              "--exclude",
              "*.ttf",
              "--exclude",
              "*.gif",
              "--exclude",
              "*.zip",
            }
          }
        },
        extensions = {
          fzf = {
            fuzz = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
          }
        }
      }
      require("telescope").load_extension("fzf")
    end
  }
  use "neovim/nvim-lspconfig"
  use {
    "williamboman/nvim-lsp-installer",
    requires = {"ms-jpq/coq_nvim", "folke/which-key.nvim"},
    config = function ()
      local coq = require("coq")
      local lsp_installer = require("nvim-lsp-installer")
      local wk = require("which-key")
      lsp_installer.on_server_ready(function(server)
        local opts = coq.lsp_ensure_capabilities()
        opts.on_attach = function(_, bufnr)
          wk.register({
            g = {
              d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "go to definition"},
              D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "go to declaration"},
              h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "get hover info"}
            }
          },
          { buffer = bufnr })
        end
        if server.name == "sumneko_lua" then
          opts.settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "awesome" }
              }
            }
          }
        end
        server:setup(opts)
      end)
    end
  }
  use "nvim-lua/popup.nvim"
  use {
    "windwp/nvim-autopairs",
    config = function ()
      require("nvim-autopairs").setup{}
    end
  }
  use {
    "numToStr/Comment.nvim",
    config = function ()
      require("Comment").setup()
    end
  }
  use {
    "akinsho/bufferline.nvim",
    branch = "main",
    config = function ()
      require("bufferline").setup{
        options = {
          show_close_icon = false
        }
      }
      -- local bufline_bg = "#212226"
      -- local bufline_faded = "#393f4a"
      -- local bufline_fg = "#2c2e34"
      -- require("bufferline").setup{
      --   options = {
      --     separator_style = "slant",
      --     show_close_icon = false
      --   },
      --   highlights = {
      --     background = {
      --       guibg = bufline_faded,
      --     },
      --     close_button = {
      --       guibg = bufline_faded
      --     },
      --     separator = {
      --       guibg = bufline_faded,
      --       guifg = bufline_bg
      --     },
      --     separator_selected = {
      --       guifg = bufline_bg,
      --       guibg = bufline_fg
      --     },
      --     separator_visible = {
      --       guibg = bufline_faded,
      --       guifg = bufline_bg
      --     },
      --     fill = {
      --       guibg = bufline_bg,
      --     },
      --     buffer_visible = {
      --       guibg = bufline_faded,
      --     },
      --     close_button_visible = {
      --       guibg = bufline_faded
      --     },
      --     modified_visible = {
      --       guibg = bufline_faded
      --     },
      --     modified = {
      --       guibg = bufline_faded
      --     }
      --   }
      -- }
    end
  }
  use { "famiu/bufdelete.nvim" }
  use {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('evil_lualine')
    end
  }
  use {
    "ahmedkhalf/project.nvim",
    requires = {"nvim-telescope/telescope.nvim"},
    config = function ()
      require("project_nvim").setup{
        manual_mode = true
      }
      require("telescope").load_extension("projects")
    end
  }
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function ()
      require("indent_blankline").setup {
        buftype_exclude = { "terminal" },
        filetype_exclude = { "alpha" }
      }
    end
  }
  use {
    "goolord/alpha-nvim",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end
  }
  use {
    "folke/which-key.nvim",
    config = function()
      require("keys")
      require("which-key").setup {
        key_labels = {
          ["<cr>"] = "RET"
        }
      }
    end
  }
  use "lunarvim/colorschemes"
  use {
    "ms-jpq/coq_nvim",
    branch = "coq",
    setup = function()
      vim.g.coq_settings = { auto_start = "shut-up", keymap = { jump_to_mark = "<c-j>"} }
    end,
    config = function()
      require("coq")
    end
  }
  use {
    "ms-jpq/coq.artifacts",
    branch = "artifacts"
  }
  use {
    "ms-jpq/coq.thirdparty",
    branch = "3p",
    config = function()
      require("coq_3p") {
        { src = "nvimlua", short_name = "nLUA" },
        { src = "orgmode", short_name = "ORG" },
        { src = "copilot", short_name = "COP", accept_key = "<c-f>" }
      }
    end
  }
  use {
    "nvim-treesitter/nvim-treesitter",
    requires = { "nvim-orgmode/orgmode" },
    run = ":TSUpdate",
    config = function ()
      require("orgmode").setup_ts_grammar()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "clojure",
          "cmake",
          "commonlisp",
          "cpp",
          "css",
          "dart",
          "dockerfile",
          "fennel",
          "fish",
          "go",
          "haskell",
          "html",
          "java",
          "javascript",
          "json",
          "julia",
          "lua",
          "make",
          "markdown",
          "org",
          "php",
          "python",
          "ruby",
          "rust",
          "scheme",
          "scss",
          "svelte",
          "typescript",
          "vim",
          "yaml",
        },
        sync_install = false,
        highlight = {
          enable = true
        }
      }
    end
  }
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup{}
    end
  }
  use "kyazdani42/nvim-web-devicons"
  use {
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup{}
    end
  }
  -- TODO: include this theme in inkd
  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }
  use "ggandor/lightspeed.nvim"
  use {
    "machakann/vim-sandwich",
    config = function()
      vim.cmd("runtime macros/sandwich/keymap/surround.vim")
    end
  }
  use "folke/trouble.nvim"
  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup()
    end
  }
  use {
    "norcalli/nvim-colorizer.lua",
    config = function ()
      require("colorizer").setup()
    end
  }
  use {
    "nvim-orgmode/orgmode",
    config = function()
      require("orgmode").setup{}
    end
  }
  use {
    "tpope/vim-fugitive"
  }
  if packer_bootstrap then
    packer.sync()
  end
end)
