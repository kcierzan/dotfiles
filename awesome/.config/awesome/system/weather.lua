local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local weather_unit = "°F"

local default_icon = ""
local clear_day_icon = ""
local clear_night_icon = ""
local rain_icon = ""
local snow_icon = ""
local sleet_icon = ""
local wind_icon = ""
local fog_icon = ""
local cloudy_icon = ""
local partly_cloudy_day_icon = ""
local partly_cloudy_night_icon = ""


local weather_temperature = wibox.widget {
  text = "  ",
  valign = "center",
  widget = wibox.widget.textbox
}

local weather_description = wibox.widget {
  text = "Loading weather...",
  valign = "center",
  widget = wibox.widget.textbox
}

local weather_icon = wibox.widget {
  valign = "center",
  font = "icomoon 45",
  widget = wibox.widget.textbox
}

local weather = wibox.widget {
  weather_icon,
  weather_description,
  weather_temperature,
  spacing = dpi(8),
  layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("signals::weather", function(temperature, summary, icon_code)
                         local icon
                         local color

                         -- round and strip the the .0 from the temperature
                         local temp = string.match(tostring(helpers.round(temperature)), "-?[0-9]+")

                         if string.find(icon_code, "clear-day") then
                           icon = clear_day_icon
                           color = beautiful.xcolor3
                         elseif string.find(icon_code, "clear-night") then
                           icon = clear_night_icon
                           color = beautiful.xcolor4
                         elseif string.find(icon_code, "rain") then
                           icon = rain_icon
                           color = beautiful.xcolor4
                         elseif string.find(icon_code, "snow") then
                           icon = snow_icon
                           color = beautiful.xcolor7
                         elseif string.find(icon_code, "sleet") then
                           icon = sleet_icon
                           color = beautiful.xcolor7
                         elseif string.find(icon_code, "wind") then
                           icon = wind_icon
                           color = beautiful.xcolor7
                         elseif string.find(icon_code, "fog") then
                           icon = fog_icon
                           color = beautiful.xcolor7
                         elseif string.find(icon_code, "partly-cloudy-day") then
                           icon = partly_cloudy_day_icon
                           color = beautiful.xcolor3
                         elseif string.find(icon_code, "partly-cloud-night") then
                           icon = partly_cloudy_night_icon
                           color = beautiful.xcolor7
                         elseif string.find(icon_code, "cloudy") then
                           icon = cloudy_icon
                           color = beautiful.xcolor7
                         else
                           icon = default_icon
                           color = beautiful.xcolor1
                         end

                         weather_icon.markup = helpers.colorize_text(icon, color)
                         weather_description.markup = description
                         weather_temperature.markup = helpers.colorize_text(temp .. weather_unit, color)
end)

return weather
