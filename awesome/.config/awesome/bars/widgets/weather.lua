local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local weather_unit = "°F"

local default_icon = ""
local clear_day_icon = ""
local clear_night_icon = ""
local rain_icon = ""
local snow_icon = ""
local sleet_icon = ""
local wind_icon = ""
local fog_icon = ""
local cloudy_icon = ""
local partly_cloudy_day_icon = ""
local partly_cloudy_night_icon = ""


local weather_temperature = wibox.widget {
  valign = "center",
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

local weather_description = wibox.widget {
  valign = "center",
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

local weather_icon = wibox.widget {
  valign = "center",
  font = beautiful.wibar_icomoon_font,
  widget = wibox.widget.textbox
}

local weather = wibox.widget {
  weather_icon,
  weather_temperature,
  weather_description,
  spacing = dpi(8),
  layout = wibox.layout.fixed.horizontal
}

function day_by_offset(offset)
  local days_of_week = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
  -- this will be a 1 based index
  local offset = offset - 1
  -- get the current day of the week (int)
  local today = os.date("*t").wday

  if today + offset > 7 then
    today = (today + offset) % 8
    return days_of_week[today + 1]
  end

  return days_of_week[today + offset]
end

forecast_menu = wibox {
  visible = false,
  ontop = true,
  opacity = beautiful.wibar_opacity,
  height = dpi(75),
  width = dpi(175),
  x = 500,
  y = 45,
  bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    gears.shape.infobubble(cr, dpi(175), dpi(75))
  end
}

local current = {}
local today_icon = wibox.widget.textbox()
local today_summary = wibox.widget.textbox()
local today_day = wibox.widget.textbox()
local today_high = wibox.widget.textbox()
local today_low = wibox.widget.textbox()
local tomorrow_icon = wibox.widget.textbox()
local tomorrow_summary = wibox.widget.textbox()
local tomorrow_day = wibox.widget.textbox()
local tomorrow_high = wibox.widget.textbox()
local tomorrow_low = wibox.widget.textbox()
local day3_icon = wibox.widget.textbox()
local day3_summary = wibox.widget.textbox()
local day3_day = wibox.widget.textbox()
local day3_high = wibox.widget.textbox()
local day3_low = wibox.widget.textbox()
local day4_icon = wibox.widget.textbox()
local day4_summary = wibox.widget.textbox()
local day4_day = wibox.widget.textbox()
local day4_high = wibox.widget.textbox()
local day4_low = wibox.widget.textbox()
local day5_icon = wibox.widget.textbox()
local day5_summary = wibox.widget.textbox()
local day5_day = wibox.widget.textbox()
local day5_high = wibox.widget.textbox()
local day5_low = wibox.widget.textbox()
local day6_icon = wibox.widget.textbox()
local day6_summary = wibox.widget.textbox()
local day6_day = wibox.widget.textbox()
local day6_high = wibox.widget.textbox()
local day6_low = wibox.widget.textbox()
local day7_icon = wibox.widget.textbox()
local day7_summary = wibox.widget.textbox()
local day7_day = wibox.widget.textbox()
local day7_high = wibox.widget.textbox()
local day7_low = wibox.widget.textbox()

local days = {
  wibox.widget {
    today_day,
    today_icon,
    today_summary,
    today_high,
    today_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  },

  wibox.widget {
    tomorrow_day,
    tomorrow_icon,
    tomorrow_summary,
    tomorrow_high,
    tomorrow_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  },

  wibox.widget {
    day3_day,
    day3_icon,
    day3_summary,
    day3_high,
    day3_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  },

  wibox.widget {
    day4_day,
    day4_icon,
    day4_summary,
    day4_high,
    day4_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  },

  wibox.widget {
    day5_day,
    day5_icon,
    day5_summary,
    day5_high,
    day5_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  },

  wibox.widget {
    day6_day,
    day6_icon,
    day6_summary,
    day6_high,
    day6_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  },

  wibox.widget {
    day7_day,
    day7_icon,
    day7_summary,
    day7_high,
    day7_low,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.background
  }
}

forecast_menu:setup {
  days[1],
  days[2],
  days[3],
  days[4],
  days[5],
  days[6],
  days[7],
  layout = wibox.layout.align.vertical,
  expand = "none"
}

function icon_code_to_char(icon_code)
  local icon
  local color
  if icon_code == "clear-day" then
    icon = clear_day_icon
    color = beautiful.xcolor3
  elseif icon_code == "clear-night" then
    icon = clear_night_icon
    color = beautiful.xcolor4
  elseif icon_code == "rain" then
    icon = rain_icon
    color = beautiful.xcolor4
  elseif icon_code == "snow" then
    icon = snow_icon
    color = beautiful.xcolor7
  elseif icon_code == "sleet" then
    icon = sleet_icon
    color = beautiful.xcolor7
  elseif icon_code == "wind" then
    icon = wind_icon
    color = beautiful.xcolor7
  elseif icon_code == "fog" then
    icon = fog_icon
    color = beautiful.xcolor7
  elseif icon_code == "partly-cloudy-day" then
    icon = partly_cloudy_day_icon
    color = beautiful.xcolor3
  elseif icon_code == "partly-cloudy-night" then
    icon = partly_cloudy_night_icon
    color = beautiful.xcolor7
  elseif icon_code == "cloudy" then
    icon = cloudy_icon
    color = beautiful.xcolor7
  else
    icon = default_icon
    color = beautiful.xcolor1
  end

  return helpers.colorize_text(icon, color)
end

awesome.connect_signal("signals::weather", function(temperature, summary, icon_code)
                         local icon
                         local color
                         local data = {}

                         -- round and strip the the .0 from the temperature
                         local temp = string.match(tostring(helpers.round(tonumber(temperature))), "-?[0-9]+")

                         -- Update current weather widget
                         weater_icon.markup = icon_code_to_char(data.current_icon)

                         -- This has to update every day in the forecast
                         -- iterate over the forcast table

                         if icon_code == "clear-day" then
                           icon = clear_day_icon
                           color = beautiful.xcolor3
                         elseif icon_code == "clear-night" then
                           icon = clear_night_icon
                           color = beautiful.xcolor4
                         elseif icon_code == "rain" then
                           icon = rain_icon
                           color = beautiful.xcolor4
                         elseif icon_code == "snow" then
                           icon = snow_icon
                           color = beautiful.xcolor7
                         elseif icon_code == "sleet" then
                           icon = sleet_icon
                           color = beautiful.xcolor7
                         elseif icon_code == "wind" then
                           icon = wind_icon
                           color = beautiful.xcolor7
                         elseif icon_code == "fog" then
                           icon = fog_icon
                           color = beautiful.xcolor7
                         elseif icon_code == "partly-cloudy-day" then
                           icon = partly_cloudy_day_icon
                           color = beautiful.xcolor3
                         elseif icon_code == "partly-cloudy-night" then
                           icon = partly_cloudy_night_icon
                           color = beautiful.xcolor7
                         elseif icon_code == "cloudy" then
                           icon = cloudy_icon
                           color = beautiful.xcolor7
                         else
                           icon = default_icon
                           color = beautiful.xcolor1
                         end

                         weather_icon.markup = helpers.colorize_text(icon, color)
                         weather_description.markup = summary
                         weather_temperature.markup = helpers.colorize_text(temp .. weather_unit, color)
end)

return weather
