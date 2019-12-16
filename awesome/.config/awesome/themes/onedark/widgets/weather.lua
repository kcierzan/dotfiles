local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")
local gears = require("gears")
local awful = require("awful")

local weather_unit = "°F"

local forecast_icon_font = "icomoon 28"
local summary_font = "mono 8"

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

day_by_offset = function(offset)
  local days_of_week = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
  -- this will be a 1 based index
  local off = offset - 1
  -- get the current day of the week (int)

  if os.date("*t").wday + off > 7 then
    return days_of_week[((os.date("*t").wday + off) % 7)]
  end

  return days_of_week[os.date("*t").wday + off]
end

local icon_code_to_char = function(icon_code)
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

local render_temperature = function(temperature)
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

current_weather = wibox.widget {
  current_icon,
  current_temperature,
  current_summary,
  spacing = dpi(8),
  layout = wibox.layout.fixed.horizontal
}

local popup_height = dpi(425)
local popup_width = dpi(425)
forecast_menu = wibox {
  visible = false,
  ontop = true,
  opacity = beautiful.wibar_opacity,
  height = popup_height,
  width = popup_width,
  x = dpi(1700),
  y = beautiful.wibar_popup.y_pos,
  bg = beautiful.bg_normal,
  shape = function(cr, width, height)
    -- width, height, radius, arrow size, arrow position
    gears.shape.infobubble(
      cr,
      popup_width,
      popup_height,
      beautiful.wibar_popup.radius)
  end
}

current_weather:connect_signal("mouse::enter", function()
  forecast_menu.visible = true
end)

current_weather:connect_signal("mouse::leave", function()
  forecast_menu.visible = false
end)


-- all widgets are updated every 10 minutes
awesome.connect_signal("signals::weather", function(day_data)
  local rendered_days = {}
  for i, day in ipairs(day_data) do
    -- update the current info
    if i == 1 then
      current_icon.markup = icon_code_to_char(day["icon"])
      current_summary.markup = day["summary"]
      current_temperature.markup = render_temperature(day["temperature"])
    else
      -- update the forecast
      local icon = wibox.widget {
        markup = icon_code_to_char(day["icon"]),
        font = forecast_icon_font,
        widget = wibox.widget.textbox
      }
      local summary = wibox.widget {
        markup = day["summary"],
        font = summary_font,
        widget = wibox.widget.textbox
      }
      local day_name = wibox.widget {
        font = beautiful.wibar_font,
        widget = wibox.widget.textbox
      }
      local low = wibox.widget {
        markup = render_temperature(day["low"]),
        font = beautiful.wibar_font,
        widget = wibox.widget.textbox
      }
      local high = wibox.widget {
        markup = render_temperature(day["high"]),
        font = beautiful.wibar_font,
        widget = wibox.widget.textbox
      }

      -- update "Today"
      if i == 2 then
        day_name.markup = "Today"
      -- update "Tomorrow"
      elseif i == 3 then
        day_name.markup = "Tomorrow"
      else
        -- 1 would return the current day
        day_name.markup = day_by_offset(i - 1)
      end

      table.insert(rendered_days, wibox.widget {
          icon,
          {
            high,
            low,
            spacing = dpi(6),
            layout = wibox.layout.fixed.vertical
          },
          {
            day_name,
            summary,
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(6)
          },
          spacing = dpi(16),
          layout = wibox.layout.fixed.horizontal,
          expand = "none",
          widget = wibox.container.background
        })

    end
  end

  forecast_menu:setup {
    {
      rendered_days[1],
      rendered_days[2],
      rendered_days[3],
      rendered_days[4],
      rendered_days[5],
      rendered_days[6],
      rendered_days[7],
      rendered_days[8],
      layout = wibox.layout.fixed.vertical,
      expand = "none",
      spacing = beautiful.wibar_popup.spacing
    },
    widget = wibox.container.margin,
    margins = beautiful.wibar_popup.margins
  }
end)

return current_weather
