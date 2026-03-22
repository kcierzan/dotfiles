local function setup_toggles()
  if vim.g.vscode then
    return
  end

  local toggle = Snacks.toggle

  -- Neovim options configured in lua/options.lua
  toggle.option("spell", { name = "Spelling" }):map("<leader>us")
  toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
  toggle.option("cursorline", { name = "Cursor Line" }):map("<leader>uC")
  toggle.line_number({ name = "Line Numbers" }):map("<leader>ul")
  toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
  toggle.option("conceallevel", {
    name = "Conceal Level",
    off = 0,
    on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
  }):map("<leader>uc")
  toggle.option("background", {
    name = "Dark Background",
    off = "light",
    on = "dark",
    global = true,
  }):map("<leader>ub")

  -- Common snacks toggles
  toggle.diagnostics({ name = "Diagnostics" }):map("<leader>ud")
  toggle.inlay_hints({ name = "Inlay Hints" }):map("<leader>uh")
  toggle.treesitter({ name = "Treesitter Highlight" }):map("<leader>uT")
  toggle.indent({ name = "Indent Guides" }):map("<leader>ug")
  toggle.dim({ name = "Dimming" }):map("<leader>uD")
  toggle.scroll({ name = "Smooth Scroll" }):map("<leader>uS")
  toggle.words({ name = "LSP Words" }):map("<leader>uW")
  toggle.animate({ name = "Animations" }):map("<leader>ua")
  toggle.zen({ name = "Zen Mode" }):map("<leader>uz")
  toggle.zoom({ name = "Zoom" }):map("<leader>uZ")
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = require("keymaps").for_plugin("snacks"),
  --@type snacks.Config
  opts = {
    animate = { enabled = not vim.g.vscode, fps = 120, easing = "expo", duration = 10 },
    bigfile = { enabled = true },
    bufdelete = { enabled = not vim.g.vscode },
    gitbrowse = { enabled = not vim.g.vscode },
    dashboard = { enabled = not vim.g.vscode },
    debug = { enabled = not vim.g.vscode },
    indent = {
      indent = {
        only_scope = true,
        only_current = true,
        enabled = false,
        char = "▎",
      },
      scope = {
        char = "▎",
      },
      blank = {
        char = "▎",
      },
      enabled = false,
    },
    input = { enabled = not vim.g.vscode },
    lazygit = { enabled = not vim.g.vscode },
    notifier = { enabled = not vim.g.vscode },
    quickfile = { enabled = true },
    picker = {
      enabled = not vim.g.vscode,
      ui_select = true,
      sources = {
        zoxide = {
          confirm = function(picker, item)
            local dir = item.path or item.file or item.text
            if item.cwd and item.file and not dir:match("^/") then
              dir = item.cwd .. "/" .. item.file
            end

            vim.cmd.cd(vim.fn.fnameescape(dir))
            picker:close()
          end,
        },
      },
      actions = {
        -- Custom action: open file in main window but keep focus on picker
        peek = function(picker, item)
          if not item then
            return
          end
          local path = Snacks.picker.util.path(item)
          if not path then
            return
          end
          -- Open buffer in main window
          local buf = vim.fn.bufadd(path)
          vim.bo[buf].buflisted = true
          vim.api.nvim_win_set_buf(picker.main, buf)
          -- Set cursor position if available
          if item.pos and item.pos[1] > 0 then
            vim.api.nvim_win_set_cursor(picker.main, { item.pos[1], item.pos[2] })
          end
        end,
      },
      win = {
        input = {
          keys = {
            ["<a-Up>"] = { "history_back", mode = { "i", "n" } },
            ["<a-Down>"] = { "history_forward", mode = { "i", "n" } },
            ["<C-o>"] = { "peek", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["<C-o>"] = { "peek", mode = { "n" } },
          },
        },
      },
      formatters = {
        file = {
          truncate = 120, -- shorten the file path to roughly this length
          filename_first = false,
        },
      },
      matcher = {
        frecency = true,
      },
      layout = {
        preview = "main",
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.35,
          border = "top",
          title = "{title} {live} {flags}",
          title_pos = "left",
          { win = "input", height = 1, border = "bottom" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", width = 0.6, border = "left" },
          },
        },
      },
    },
    scope = {
      enabled = not vim.g.vscode,
      char = "▎",
    },
    scratch = { enabled = not vim.g.vscode },
    scroll = { enabled = not vim.g.vscode },
    statuscolumn = { enabled = not vim.g.vscode },
    terminal = { enabled = false },
    toggle = {
      enabled = not vim.g.vscode,
      which_key = true,
      notify = true,
    },
    words = { enabled = not vim.g.vscode },
    zen = { enabled = not vim.g.vscode },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
    setup_toggles()
  end,
}
