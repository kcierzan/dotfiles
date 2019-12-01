local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local naughty = require("naughty")
local inspect = require("inspect")

local darksky_api_key = os.getenv("DARKSKY_API_KEY")

-- update every 10 minutes
local update_interval = 120

-- call the `weather` shell script periodically
function update_forecast()
  local days = {}
  local ip = helpers.http.get("https://ifconfig.me", true)["body"][1]
  local location = helpers.http.get("http://ip-api.com/json/" .. ip)["body"]
  location = helpers.decode(location)

  if not location then
    -- fallback to Philadelphia
    coords = "39.93,-75.18"
  else
    coords = tostring(location["lat"]) .. "," .. tostring(location["lon"])
  end

  local url = "https://api.darksky.net/forecast/" .. darksky_api_key .. "/" .. coords .. "?exclude=minutely"

  local body = helpers.http.get(url, true)["body"]
  body = helpers.decode(body)

  if not body then
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
gears.timer.start_new(update_interval, update_forecast)
