local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")
local gears = require("gears")
local awful = require("awful")

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

function render_temperature(temperature)
  local color
  -- round and strip the the .0 from the temperature
  local temp = string.match(
    tostring(helpers.round(tonumber(temperature))),
    "-?[0-9]+")

  if tonumber(temp) < 40 then
    color = beautiful.xcolor4
  elseif tonumber(temp) < 60 then
    color = beautiful.xcolor7
  elseif tonumber(temp) < 80 then
    color = beautiful.xcolor3
  elseif tonumber(temp) < 100 then
    color = beautiful.xcolor5
  else
    color = beautiful.xcolor1
  end

  return helpers.colorize_text(temp .. weather_unit, color)
end


local current_temperature = wibox.widget {
  valign = "center",
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

local current_summary = wibox.widget {
  valign = "center",
  font = beautiful.wibar_font,
  widget = wibox.widget.textbox
}

local current_icon = wibox.widget {
  valign = "center",
  font = beautiful.wibar_icomoon_font,
  widget = wibox.widget.textbox
}

local current_weather = wibox.widget {
  current_icon,
  current_temperature,
  current_summary,
  spacing = dpi(8),
  layout = wibox.layout.fixed.horizontal
}

current_weather:buttons(gears.table.join(
    awful.button({}, 1, function()
      forecast_menu.visible = not forecast_menu.visible
    end)
  ))

forecast_menu = wibox {
  visible = false,
  ontop = true,
  opacity = beautiful.wibar_opacity,
  height = dpi(440),
  width = dpi(425),
  x = 2575,
  y = 45,
  bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    gears.shape.infobubble(cr, dpi(425), dpi(440))
  end
}

local today_icon       = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local tomorrow_icon    = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local day2_icon        = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local day3_icon        = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local day4_icon        = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local day5_icon        = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local day6_icon        = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}
local day7_icon        = wibox.widget {font = "icomoon 28", widget = wibox.widget.textbox}

local today_summary    = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local tomorrow_summary = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local day2_summary     = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local day3_summary     = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local day4_summary     = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local day5_summary     = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local day6_summary     = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}
local day7_summary     = wibox.widget {font = "mono 8", widget = wibox.widget.textbox}

local today_day        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local today_high       = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local today_low        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local tomorrow_day     = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local tomorrow_high    = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local tomorrow_low     = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day2_day         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day2_high        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day2_low         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day3_day         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day3_high        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day3_low         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day4_day         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day4_high        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day4_low         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day5_day         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day5_high        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day5_low         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day6_day         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day6_high        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day6_low         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day7_day         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day7_high        = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}
local day7_low         = wibox.widget {font = beautiful.wibar_font, widget = wibox.widget.textbox}

local days = {
  wibox.widget {
    today_icon,
    {
        today_high,
        today_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      today_day,
      today_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    tomorrow_icon,
    {
        tomorrow_high,
        tomorrow_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      tomorrow_day,
      tomorrow_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    day2_icon,
    {
        day2_high,
        day2_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      day2_day,
      day2_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    day3_icon,
    {
        day3_high,
        day3_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      day3_day,
      day3_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    day4_icon,
    {
        day4_high,
        day4_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      day4_day,
      day4_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    day5_icon,
    {
        day5_high,
        day5_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      day5_day,
      day5_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    day6_icon,
    {
        day6_high,
        day6_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      day6_day,
      day6_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  },

  wibox.widget {
    day7_icon,
    {
        day7_high,
        day7_low,
        spacing = dpi(6),
        layout = wibox.layout.fixed.vertical
    },
    {
      day7_day,
      day7_summary,
      layout = wibox.layout.fixed.vertical,
      spacing = dpi(6)
    },
    spacing = dpi(16),
    layout = wibox.layout.fixed.horizontal,
    expand = "none",
    widget = wibox.container.background
  }
}

forecast_menu:setup {
  {
    days[1],
    days[2],
    days[3],
    days[4],
    days[5],
    days[6],
    days[7],
    days[8],
    layout = wibox.layout.fixed.vertical,
    expand = "none",
    spacing = dpi(12)
  },
  widget = wibox.container.margin,
  margins = 40
}

-- all widgets are updated every 10 minutes
awesome.connect_signal("signals::weather", function(data)
                        if data.error then
                          naughty.notify({title = "Error", text = "Fetch weather failed"})
                          return
                        end
                         -- update current weather widget
                         current_icon.markup = icon_code_to_char(data.current_icon)
                         current_summary.markup = data.current_summary
                         current_temperature.markup = render_temperature(data.current_temp)

                         -- update today
                        today_icon.markup = icon_code_to_char(data.today_icon)
                        today_day.markup = "Today"
                        today_summary.markup = data.today_summary
                        today_high.markup = render_temperature(data.today_high)
                        today_low.markup = render_temperature(data.today_low)

                        -- update tomorrow
                        tomorrow_icon.markup = icon_code_to_char(data.tomorrow_icon)
                        tomorrow_day.markup = "Tomorrow"
                        tomorrow_summary.markup = data.tomorrow_summary
                        tomorrow_high.markup = render_temperature(data.tomorrow_high)
                        tomorrow_low.markup = render_temperature(data.tomorrow_low)

                        day2_icon.markup = icon_code_to_char(data.day2_icon)
                        day2_day.markup = day_by_offset(2)
                        day2_summary.markup = data.day2_summary
                        day2_high.markup = render_temperature(data.day2_high)
                        day2_low.markup = render_temperature(data.day2_low)

                        day3_icon.markup = icon_code_to_char(data.day3_icon)
                        day3_day.markup = day_by_offset(3)
                        day3_summary.markup = data.day3_summary
                        day3_high.markup = render_temperature(data.day3_high)
                        day3_low.markup = render_temperature(data.day3_low)

                        day4_icon.markup = icon_code_to_char(data.day4_icon)
                        day4_day.markup = day_by_offset(4)
                        day4_summary.markup = data.day4_summary
                        day4_high.markup = render_temperature(data.day4_high)
                        day4_low.markup = render_temperature(data.day4_low)

                        day5_icon.markup = icon_code_to_char(data.day5_icon)
                        day5_day.markup = day_by_offset(5)
                        day5_summary.markup = data.day5_summary
                        day5_high.markup = render_temperature(data.day5_high)
                        day5_low.markup = render_temperature(data.day5_low)

                        day6_icon.markup = icon_code_to_char(data.day6_icon)
                        day6_day.markup = day_by_offset(6)
                        day6_summary.markup = data.day6_summary
                        day6_high.markup = render_temperature(data.day6_high)
                        day6_low.markup = render_temperature(data.day6_low)

                        day7_icon.markup = icon_code_to_char(data.day7_icon)
                        day7_day.markup = day_by_offset(7)
                        day7_summary.markup = data.day7_summary
                        day7_high.markup = render_temperature(data.day7_high)
                        day7_low.markup = render_temperature(data.day7_low)

end)

return current_weather
