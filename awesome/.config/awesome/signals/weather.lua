-- Provides:
-- signals::weather
--      temperature (integer)
--      summary (string)
--      icon_code (string)

local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")
local naughty = require("naughty")

local darksky_api_key = os.getenv("DARKSKY_API_KEY")

-- update every 10 minutes
local update_interval = 600

-- call the `weather` shell script periodically
function update_forecast()
  local days = {}
  local ip = helpers.https.get("https://ifconfig.me")["body"]
  local latlon_res = helpers.https.get("http://ip-api.com/json/" .. ip)["body"]

  if not (latlon_res) then
    -- fallback to Philadelphia
    local latlon = "39.93,-75.18"
  else
    local latlon = latlon_res["lat"] .. "," .. latlon_res["lon"]
  end

  local body = helpers.https.get(
    "https://api.darksky.net/forecast/"
    .. darksky_api_key
    .. "/"
    .. latlon
    .. "?=exclude=minutely")["body"]

  if not body then
    naughty.notify({title = "Fetch weather failed", text = "stopping weather callback"})
    return false
  end

    -- add the current weather info
    table.insert(days, {
        icon = body["currently"]["icon"],
        temperature = body["currently"]["temperature"],
        summary = body["hourly"]["summmary"]
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
