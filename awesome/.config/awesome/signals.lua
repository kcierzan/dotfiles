local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local naughty = require("naughty")
local inspect = require("inspect")

local cpu_update_interval            = 1
local ram_update_interval            = 1
local traffic_update_interval        = 1
local hdd_update_interval            = 5
local wifi_update_interval           = 60
local number_updates_update_interval = 60
local weather_update_interval        = 300
local last_update_update_interval    = 300
local bluetooth_update_interval      = 5

local darksky_api_key = os.getenv("DARKSKY_API_KEY")

-- cpu
awful.widget.watch("cpu", cpu_update_interval, function(widget, stdout)
  awesome.emit_signal("signals::cpu", stdout:gsub("%s+", ""))
end)

-- hdd
awful.widget.watch("hdd", hdd_update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")
                     local root = lines[1]
                     local media = lines[2]

                     awesome.emit_signal("signals::hdd", root, media)
end)

-- ram
awful.widget.watch("ram", ram_update_interval, function(widget, stdout)
  awesome.emit_signal("signals::ram", stdout:gsub("%s+", ""))
end)

-- wifi
awful.widget.watch("wifi", wifi_update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")
                     local network_name = lines[1]
                     local strength = lines[2]

                     awesome.emit_signal("signals::wifi", network_name, strength)
end)

-- traffic
awful.widget.watch("traffic", traffic_update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")
                     local down = lines[1]
                     local up = lines[2]

                     awesome.emit_signal("signals::traffic", down, up)
end)

-- last update
awful.widget.watch("lastupdate", last_update_update_interval, function(widget, stdout)
  awesome.emit_signal("signals::last_pacman_update", stdout:gsub("%s+", ""))
end)

-- weather
local update_forecast = function()
  local days = {}
  local ip_address = helpers.http.get("https://ifconfig.me", true, true)["body"][1]

  if not ip_address then
    naughty.notify({
      title = "Fetch ip for weather failed",
      text = "Stopping weather updates",
      timeout = 0
    })
    return false
  end

  local location = helpers.http.get("http://ip-api.com/json/" .. ip_address, false, true)["body"]
  location = helpers.decode(location)

  if not location then
    -- fallback to Philadelphia
    coords = "39.93,-75.18"
  else
    coords = tostring(location["lat"]) .. "," .. tostring(location["lon"])
  end

  local url = "https://api.darksky.net/forecast/" .. darksky_api_key .. "/" .. coords .. "?exclude=minutely"

  local body = helpers.http.get(url, true, true)["body"]
  body = helpers.decode(body)

  if not body or next(body) == nil then
    naughty.notify({
      title = "Fetch weather failed",
      text = "Stopping weather updates",
      timeout = 0
    })
    return false
  end
  -- add the current weather info
  table.insert(days, {
      icon = body["currently"]["icon"],
      temperature = body["currently"]["temperature"],
      summary = body["hourly"]["summary"]
    })

  -- add the rest of the forecast data
  for i, day in ipairs(body["daily"]["data"]) do
    table.insert(days, {
        icon = day["icon"],
        summary = day["summary"],
        low = day["temperatureLow"],
        high = day["temperatureHigh"]
      })
  end
  awesome.emit_signal("signals::weather", days)
  return true
end

-- TODO: call on initial load
gears.timer.start_new(weather_update_interval, update_forecast)

-- number pacman updates
-- TODO: fix this success check
local success = true
local get_updates = function()
  awful.spawn.easy_async_with_shell(
    "checkupdates | wc -l",
    function(stdout)
      local num_updates = stdout:gsub("%s+", "")
      if not num_updates then
        success = false
        naughty.notify({
            title = "checkupdates failed",
            text = "Stopping pacman package updates"
          })
        return
      end
      awesome.emit_signal("signals::number_pacman_updates", num_updates)
    end
    )
  return success
end

gears.timer.start_new(number_updates_update_interval, get_updates)

-- TODO: Does this work?
local get_paired_devices = function()
  awful.spawn.easy_async_with_shell(
    "bluetoothctl paired-devices | cut -d' ' -f 3-",
    function(stdout)
      local devices = stdout:gsub("%s", "")
      if not devices then
        naughty.notify({
            title = "bluetooth check failed",
            text = "stopping bluetooth check"
          })
        return
      end
      awesome.emit_signal("signals::bluetooth_devices", devices)
    end
    )
  return success
end

gears.timer.start_new(bluetooth_update_interval, get_paired_devices)
