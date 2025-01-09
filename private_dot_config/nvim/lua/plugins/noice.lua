return {
  "folke/noice.nvim",
  enabled = true,
  event = { "VeryLazy" },
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    messages = {
      enabled = true,
      view = "notify",
      view_error = "notify",
      view_warn = "notify",
      view_history = "messages",
      view_search = "virtualtext",
    },
    lsp = {
      hover = {
        enabled = false,
      },
      progress = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
    },
    routes = {
      {
        filter = {
          warning = true,
          find = "Failed to attach",
        },
        opts = { skip = true },
      },
      {
        view = "mini",
        filter = {
          event = "msg_showmode",
        },
      },
      {
        filter = {
          error = true,
          find = "Pattern",
        },
        opts = { skip = true },
      },
      {
        filter = {
          warning = true,
          find = "search hit",
        },
        opts = { skip = true },
      },
      {
        filter = {
          find = "go up one level",
        },
        opts = { skip = true },
      },
      {
        filter = {
          find = "quit with exit code",
          warning = true,
        },
        opts = { skip = true },
      },
      {
        view = "mini",
        filter = {
          find = "Directory changed to",
        },
      },
    },
  },
}
