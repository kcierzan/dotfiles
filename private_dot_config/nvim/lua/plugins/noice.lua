return {
  "folke/noice.nvim",
  enabled = true,
  event = { "VeryLazy" },
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    cmdline = {
      enabled = true,
      -- view = "cmdline_popup",
      view = "cmdline",
    },
    presets = {
      long_message_to_split = true,
    },
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
        enabled = true,
      },
      progress = {
        enabled = true,
      },
      signature = {
        enabled = true,
      },
    },
    redirect = {
      view = "popup",
      filter = { event = "msg_show" },
    },
    routes = {
      {
        filter = { event = 'msg_show', kind = { 'shell_out', 'shell_err' } },
        view = 'split',
        opts = {
          level = 'info',
          skip = false,
          replace = false,
        },
      },
      -- Send long shell command output to a split
      {
        view = "split",
        filter = {
          event = "msg_show",
          kind = "",
          min_height = 4,
        },
      },
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
        view = "mini",
        filter = {
          find = "Directory changed to",
        },
      },
    },
  },
}
