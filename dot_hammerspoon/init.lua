-- Hammerspoon configuration

-- Reload config hotkey
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "r", function()
  hs.reload()
end)

-- Hyperkey management
local function quitHyperkey()
  local app = hs.application.find("Hyperkey")
  if app then
    app:kill()
  end
end

local function startHyperkey()
  hs.application.open("Hyperkey")
  hs.timer.doAfter(0.5, function()
    local app = hs.application.find("Hyperkey")
    if app then
      local win = app:mainWindow()
      if win then
        win:close()
      end
    end
  end)
end

-- Quit focused application
local function quitFocusedApplication()
  local focusedApp = hs.application.frontmostApplication()
  if focusedApp then
    focusedApp:kill()
  else
    hs.alert.show("No focused application")
  end
end

-- Keyboard detection
local function keyboardConnected()
  local devices = hs.usb.attachedDevices()
  -- local products = ""
  -- local ret = false
  for _, device in ipairs(devices) do
    -- products = products .. "|" .. device.productName
    if string.find(device.productName, "Keychron") then
      return true
    end
  end
  -- hs.alert.show(products)
  return false
end

local function handleKeyboardConnection(data)
  if data.productName and string.find(data.productName, "Keychron") then
    if data.eventType == "added" then
      quitHyperkey()
    elseif data.eventType == "removed" then
      startHyperkey()
    end
  end
end

-- Hot reload on config changes
local function isLuaFile(file)
  return string.sub(file, -4) == ".lua"
end

local function hotreload(files)
  for _, file in pairs(files) do
    if isLuaFile(file) then
      hs.reload()
      return
    end
  end
end

-- Set up watchers
_G.configWatcher = hs.pathwatcher.new(hs.configdir, hotreload)
_G.usbWatcher = hs.usb.watcher.new(handleKeyboardConnection)

_G.configWatcher:start()
_G.usbWatcher:start()

-- Initial keyboard state check
if keyboardConnected() then
  quitHyperkey()
else
  startHyperkey()
end

-- Open Ghostty or create new window
local function openGhosttyWindow()
  local app = hs.application.find("Ghostty")
  if app then
    -- Ghostty is running, activate and open new window
    app:activate()
    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({ "cmd" }, "n")
    end)
  else
    -- Ghostty is not running, start it
    hs.application.open("Ghostty")
  end
end

-- Hotkey bindings
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "q", openGhosttyWindow)
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "C", quitFocusedApplication)
