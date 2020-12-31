local Resize = require('resize')

hs.window.animationDuration = 0.05

hs.hotkey.bind(
  {"ctrl", "cmd"},
  "H",
  Resize.nudge_left,
  nil,
  Resize.nudge_left)

hs.hotkey.bind(
  {"ctrl", "cmd"},
  "L",
  Resize.nudge_right,
  nil,
  Resize.nudge_right)

hs.hotkey.bind(
  {"ctrl", "cmd"},
  "J",
  Resize.nudge_down,
  nil,
  Resize.nudge_down)

hs.hotkey.bind(
  {"ctrl", "cmd"},
  "K",
  Resize.nudge_up,
  nil,
  Resize.nudge_up)

hs.hotkey.bind({
  "cmd", "shift"},
  "H",
  Resize.left_half)

hs.hotkey.bind(
  {"cmd", "shift"},
  "L",
  Resize.right_half)

hs.hotkey.bind(
  {"cmd", "shift"},
  "J",
  Resize.bottom_half)

hs.hotkey.bind(
  {"cmd", "shift"},
  "K",
  Resize.top_half)

hs.hotkey.bind(
  {"cmd"},
  "E",
  Resize.center)

hs.hotkey.bind(
  {"cmd", "shift"},
  "E",
  Resize.resize_to_preset)

hs.hotkey.bind(
  {"cmd", "shift"},
  "F",
  Resize.fullscreen)

hs.hotkey.bind(
  {"cmd", "shift"},
  "]",
  Resize.send_to_next_screen)

hs.hotkey.bind(
  {"cmd", "shift"},
  "[",
  Resize.send_to_previous_screen)

local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

local reloadWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
