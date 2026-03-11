-- For `plugins.lua` users.
return {
  "OXY2DEV/markview.nvim",
  -- this plugin cannot be lazy loaded as per docs
  lazy = false,
  -- Completion for `blink.cmp`
  dependencies = { "saghen/blink.cmp" },
}
