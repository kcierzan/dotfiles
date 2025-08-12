local Neovide = {}

local lib = require("lib")

local function set_config_vars()
  -- TODO: move this to neovide
  vim.g.neovide_input_macos_option_key_is_meta = "both"
  vim.g.neovide_cursor_animation_length = 0.2
  vim.g.neovide_position_animation_length = 0.1
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_refresh_rate = 100
  vim.g.neovide_floating_corner_radius = 0.3
  vim.g.neovide_padding_top = 20
  vim.g.neovide_padding_bottom = 20
  vim.g.neovide_padding_right = 20
  vim.g.neovide_padding_left = 20
  vim.opt.linespace = 12
end

local function set_keybinds()
  vim.api.nvim_set_keymap("t", "<D-v>", [[<C-\><C-n>:lua require('neovide').paste()<CR>]], {
    noremap = true,
    silent = true,
  })
  -- make command + v work for paste
  lib.imap("<D-v>", "<C-r>+")
  lib.cmap("<D-v>", "<C-r>+")
  lib.nmap("<D-v>", '"+p')

  if vim.g.neovide then
    -- map cmd + =/- to increase the neovide text size
    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
      vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    vim.keymap.set("n", "<D-=>", function()
      change_scale_factor(1.05)
    end)
    vim.keymap.set("n", "<D-->", function()
      change_scale_factor(1 / 1.05)
    end)
  end
end

function Neovide.setup()
  set_config_vars()
  set_keybinds()
end

function Neovide.paste()
  local keys = vim.api.nvim_replace_termcodes('<C-\\><C-N>"+pi', true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

return Neovide
