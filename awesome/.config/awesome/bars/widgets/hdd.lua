local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local progress_widget = function()
  return wibox.widget {
    {
      id = "bar",
      max_value = 100,
      forced_height = 0.5,
      forced_width = dpi(100),
      border_width = 0,
      shape = helpers.rrect(4),
      bar_shape = helpers.rrect(4),
      background_color = beautiful.bg_lighter,
      widget = wibox.widget.progressbar
    },
    widget = wibox.container.margin,
    margins = dpi(2)
  }
end

local root_bar = progress_widget()
local media_bar = progress_widget()

local root_percentage = wibox.widget {
  font = "mono 8",
  forced_width = dpi(100),
  widget = wibox.widget.textbox

}

local media_percentage = wibox.widget {
  font = "mono 8",
  forced_width = dpi(100),
  widget = wibox.widget.textbox
}

local hdd = wibox.widget {
  {
    root_bar,
    root_percentage,
    layout = wibox.layout.fixed.horizontal
  },
  {
    media_bar,
    media_percentage,
    layout = wibox.layout.fixed.horizontal
  },
  layout = wibox.layout.fixed.vertical
}

awesome.connect_signal(
  "signals::hdd",
  function(root, media)
    local r = root:gsub("%%", "")
    local m = media:gsub("%%", "")
    local root_number = tonumber(r)
    local media_number = tonumber(m)
    root_bar.bar.value = root_number
    media_bar.bar.value = media_number
    root_percentage.markup = "/: " .. root
    media_percentage.markup = "/mnt/media: " .. media

    if root_number > 80 then
      root_bar.color = beautiful.xcolor1
    else
      root_bar.bar.color = beautiful.xcolor3
    end

    if media_number > 80 then
      media_bar.bar.color = beautiful.xcolor1
    else
      media_bar.bar.color = beautiful.xcolor3
    end
  end)
return hdd
