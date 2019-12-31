local ltn12 = require("ltn12")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local naughty = require("naughty")
-- install socket
local http = require("socket.http")
-- install luasec and point it to openssl
local https = require("ssl.https")
-- install rxi-json-lua
local json = require("rxi-json-lua")

local helpers = {}

-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

helpers.colorize_text = function(txt, fg)
   return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end

helpers.bold_text = function(txt)
  return "<b>" .. txt .. "</b>"
end


helpers.pad_text_end = function(txt, padding)
   spaces = ""
   for i = 1, padding do
      spaces = spaces .. " "
   end
   return txt .. spaces
end

helpers.pad = function(padding)
   spaces = ""
   for i = 1, padding do
      spaces = spaces .. " "
   end
   local pad = wibox.widget.textbox(spaces)
   return pad
end

-- how does a language get by without this?
helpers.round = function(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

  -- split a string by colons
helpers.split = function(input, delimiter)
  local lines = {}
  for line in input:gmatch("[^" .. delimiter .. "]+") do
    table.insert(lines, line)
  end
  return lines
end

-- Add a hover cursor to a widget by changing the cursor on
-- mouse::enter and mouse::leave
-- You can find the names of the available cursors by opening any
-- cursor theme and looking in the "cursors folder"
-- For example: "hand1" is the cursor that appears when hovering over
-- links
function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal("mouse::enter", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = hover_cursor
        end
    end)

    w:connect_signal("mouse::leave", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = original_cursor
        end
    end)
end

helpers.sleep = function(seconds)
  os.execute("sleep " .. tonumber(seconds))
end

helpers.http = {}

helpers.http.get = function(url, ssl, retries)
  local headers = {
    ["Accept"] = "application/json"
  }
  local body = {}
  local attempts = 0
  if ssl then
    _, code, headers, status = https.request {
      url = url,
      headers = headers,
      sink = ltn12.sink.table(body)
    }
  else
    _, code, headers, status = http.request {
      url = url,
      headers = headers,
      sink = ltn12.sink.table(body)
    }
  end

  while retries and tonumber(code) >= 500 and attempts < 6 do
    helpers.sleep(3)
    naughty.notify({
        title = "Fetch: " .. url .. " failed with code: " .. code,
        text = "Body: " .. table.concat(body, " "),
        timeout = 0
      })
    if ssl then
      _, code, headers, status = https.request {
        url = url,
        headers = headers,
        sink = ltn12.sink.table(body)
      }
    else
      _, code, headers, status = http.request {
        url = url,
        headers = headers,
        sink = ltn12.sink.table(body)
      }
    end
    attempts = attempts + 1
  end

  return {
    code = code,
    headers = headers,
    status = status,
    body = body
  }
end


helpers.decode = function(body_table)
  return json.decode(table.concat(body_table))
end

helpers.widget = {}

helpers.widget.progress = function()
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

return helpers
