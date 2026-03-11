WarpMouse = hs.loadSpoon("WarpMouse")
WarpMouse:start()

PaperWM = hs.loadSpoon("PaperWM")
PaperWM:bindHotkeys({
  -- switch to a new focused window in tiled grid
  focus_left          = { { "alt", "cmd", "ctrl" }, "h" },
  focus_right         = { { "alt", "cmd", "ctrl" }, "l" },
  focus_up            = { { "alt", "cmd", "ctrl" }, "k" },
  focus_down          = { { "alt", "cmd", "ctrl" }, "j" },

  -- switch windows by cycling forward/backward
  -- (forward = down or right, backward = up or left)
  -- focus_prev           = { { "alt", "cmd" }, "k" },
  -- focus_next           = { { "alt", "cmd" }, "j" },

  -- move windows around in tiled grid
  swap_left           = { { "alt", "cmd", "shift", "ctrl" }, "h" },
  swap_right          = { { "alt", "cmd", "shift", "ctrl" }, "l" },
  swap_up             = { { "alt", "cmd", "shift", "ctrl" }, "k" },
  swap_down           = { { "alt", "cmd", "shift", "ctrl" }, "j" },

  -- position and resize focused window
  center_window       = { { "alt", "cmd", "ctrl" }, "return" },
  full_width          = { { "alt", "cmd", "ctrl" }, "f" },
  cycle_width         = { { "alt", "cmd" }, "w" },
  reverse_cycle_width = { { "ctrl", "alt", "cmd" }, "w" },
  cycle_height        = { { "alt", "cmd", "shift", "ctrl" }, "r" },
  -- reverse_cycle_height = { { "ctrl", "alt", "cmd", "shift" }, "r" },

  -- increase/decrease width
  increase_width      = { { "alt", "cmd", "ctrl" }, "=" },
  decrease_width      = { { "alt", "cmd", "ctrl" }, "-" },

  -- move focused window into / out of a column
  slurp_in            = { { "alt", "cmd", "ctrl" }, "i" },
  barf_out            = { { "alt", "cmd", "ctrl" }, "o" },

  -- move the focused window into / out of the tiling layer
  toggle_floating     = { { "alt", "cmd", "ctrl" }, "space" },

  -- focus the first / second / etc window in the current space
  -- focus_window_1      = { { "cmd", "shift" }, "1" },
  -- focus_window_2      = { { "cmd", "shift" }, "2" },
  -- focus_window_3      = { { "cmd", "shift" }, "3" },
  -- focus_window_4      = { { "cmd", "shift" }, "4" },
  -- focus_window_5      = { { "cmd", "shift" }, "5" },
  -- focus_window_6      = { { "cmd", "shift" }, "6" },
  -- focus_window_7      = { { "cmd", "shift" }, "7" },
  -- focus_window_8      = { { "cmd", "shift" }, "8" },
  -- focus_window_9      = { { "cmd", "shift" }, "9" },

  -- switch to a new Mission Control space
  switch_space_l      = { { "alt", "cmd", "ctrl" }, "," },
  switch_space_r      = { { "alt", "cmd", "ctrl" }, "." },
  switch_space_1      = { { "alt", "cmd", "ctrl" }, "1" },
  switch_space_2      = { { "alt", "cmd", "ctrl" }, "2" },
  switch_space_3      = { { "alt", "cmd", "ctrl" }, "3" },
  switch_space_4      = { { "alt", "cmd", "ctrl" }, "4" },
  switch_space_5      = { { "alt", "cmd", "ctrl" }, "5" },
  switch_space_6      = { { "alt", "cmd", "ctrl" }, "6" },
  switch_space_7      = { { "alt", "cmd", "ctrl" }, "7" },
  switch_space_8      = { { "alt", "cmd", "ctrl" }, "8" },
  switch_space_9      = { { "alt", "cmd", "ctrl" }, "9" },

  -- move focused window to a new space and tile
  move_window_1       = { { "alt", "cmd", "shift", "ctrl" }, "1" },
  move_window_2       = { { "alt", "cmd", "shift", "ctrl" }, "2" },
  move_window_3       = { { "alt", "cmd", "shift", "ctrl" }, "3" },
  move_window_4       = { { "alt", "cmd", "shift", "ctrl" }, "4" },
  move_window_5       = { { "alt", "cmd", "shift", "ctrl" }, "5" },
  move_window_6       = { { "alt", "cmd", "shift", "ctrl" }, "6" },
  move_window_7       = { { "alt", "cmd", "shift", "ctrl" }, "7" },
  move_window_8       = { { "alt", "cmd", "shift", "ctrl" }, "8" },
  move_window_9       = { { "alt", "cmd", "shift", "ctrl" }, "9" }
})
PaperWM.drag_window = { "cmd", "ctrl", "alt" }
PaperWM:start()
