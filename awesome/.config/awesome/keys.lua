local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local light = require("system.light")

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Mouse bindings
root.buttons(gears.table.join(
                awful.button({ }, 3, function () mymainmenu:toggle() end)

))

local bind_keys = function(...)
    local binds = {}
    for i, keymap in ipairs(arg) do
        for key, bindings in pairs(keymap) do
            for i, binding in ipairs(bindings) do
                table.insert(binds, create_map(
                                binding["description"],
                                binding["group"],
                                key,
                                binding["func"],
                                binding["modkeys"]
                ))
            end
        end
    end
    root.keys(binds)
end

local create_map = function(desc, group, func, key, modkeys)
    return awful.key(modkeys, key, func, {description=desc, group=group})
end

local zoom = function(direction)
    local screen = awful.screen.focused()
    local layout = awful.layout.get(screen)

    if direction == "top" then
        dir_func = awful.placement.top
    elseif direction == "bottom" then
        dir_func = awful.placement.bottom
    elseif direction == "right" then
        dir_func = awful.placement.right
    else
        dir_func = awful.placement.left
    end

    if direction == "top" or direction == "bottom" then
        max_func = awful.placement.maximize_horizontally
    else
        max_func = awful.placement.maximize_vertically
    end

    local f = awful.placement.scale + dir_func + max_func
    -- TODO: adjust these values to work better...
    f(client.focus, {margins=40, honor_workarea=true, honor_padding=true, to_percent = 0.5})
end

local globals = {
    s = {
        {
            description = "show help",
            group = "awesome",
            func = hotkeys_popup.show_help,
            modkeys = { modkey }
        }
    },
    v = {
        {
            description = "open clipboard manager",
            group = "user",
            func = function()
                awful.spawn.with_shell("clipmenu")
            end,
            modkeys = { modkey, "Shift" }
        }
    },
    r = {
        {
            description = "reload awesome",
            group = "awesome",
            func = awesome.restart,
            modkeys = { modkey, "Control" }
        }
    },
    q = {
        {
            description = "quit awesome",
            group = "awesome",
            func = awesome.quit,
            modkeys = { modkey, "Shift" }
        }
    },
    space = {
        {
            description = "rofi combi",
            group = "launcher",
            func = function()
                awful.spawn.with_shell("rofi -show combi -display-combi ''")
            end,
            modkeys = { modkey }
        }
    },
    Left = {
        {
            description = "view previous",
            group = "tag",
            func = awful.tag.viewprev,
            modkeys = { modkey }
        }
    },
    Right = {
        {
            description = "view next",
            group = "tag",
            func = awful.tag.viewnext,
            modkeys = { modkey }
        }
    },
    Return = {
        {
            description = "open a tmux terminal",
            group = "launcher",
            func = function()
                awful.spawn(terminal.." sh -c 'tmux new-session; zsh'")
            end,
            modkeys = { modkey }
        }
    },
    Escape = {
        {
            description = "show the exit screen",
            group = "awesome",
            func = function()
                exit_screen_show()
            end,
            modkeys = { modkey }
        }
    },
    Tab = {
        {
            description = "switch clients",
            group = "client",
            func = function()
                awful.client.focus.byidx(1)
            end,
            modkeys = { modkey }
        }
    },
}

globals["="] = {
    {
        description = "increase screen brightness",
        group = "awesome",
        func = function()
            light.change.brightness("+")
        end,
        modkeys = { modkey }
    },
    {
        description = "increase screen temperature",
        group = "awesome",
        func = function()
            light.change_temperature("+")
        end,
        modkeys = { modkey, "Shift" }
    }
}

globals["-"] = {
    {
        description = "decrase screen brightness",
        group = "awesome",
        func = function()
            light.change.brightness("-")
        end,
        modkeys = { modkey }
    },
    {
        description = "decrease screen temperature",
        group = "awesome",
        func = function()
            light.change.temperature("-")
        end,
        modkeys = { modkey, "Shift" }
    }
}

globals["\\"] = {
    {
        description = "toggle redshift",
        group = "awesome",
        func = function()
            light.toggle_redshift()
        end,
        modkeys = { modkey }
    }
}

local floating = {
    j = {
        {
            description = "warp to bottom",
            group = "client",
            func = function()
                zoom("bottom")
            end,
            modkeys = { modkey }
        }
    },
    k = {
        {
            description = "warp to top",
            group = "client",
            func = function()
                zoom("top")
            end,
            modkeys = { modkey }
        }
    },
    h = {
        {
            description = "warp to left",
            group = "client",
            func = function()
                zoom("left")
            end,
            modkeys = { modkey }
        }
    },
    l = {
        {
            description = "warp to right",
            group = "client",
            func = function()
                zoom("right")
            end,
            modkeys = { modkey }
        }
    }
}

local tiling = {
    j = {
        {
            description = "focus client (down)",
            group = "client",
            func = function()
                awful.client.focus.bydirection("down")
            end,
            modkeys = { modkey }
        },
        {
            description = "swap client (down)",
            group = "client",
            funct = function()
                awful.client.swap.bydirection("down")
            end,
            modkeys = { modkey, "Shift" }
        }

    },
    k = {
        {
            description = "focus client (up)",
            group = "client",
            func = function()
                awful.client.focus.bydirection("up")
            end,
            modkeys = { modkey }
        },
        {
            description = "swap client (up)",
            group = "client",
            func = function()
                awful.client.swap.bydirection("up")
            end,
            modkeys = { modkey, "Shift" }
        }
    },
    h = {
        {
            description = "focus client (left)",
            group = "client",
            func = function()
                awful.client.focus.bydirection("left")
            end,
            modkeys = { modkey }
        },
        {
            description = "swap client (left)",
            group = "client",
            func = function()
                awful.client.swap.bydirection("left")
            end,
            modkeys = { modkey, "Shift" }
        },
        {
            description = "decrease the number of columns",
            group = "layout",
            funct = function()
                awful.tag.incncol( -1, nil, true)
            end,
            modkeys = { modkey, "Control" }
        }
    },
    l = {
        {
            description = "focus client (right)",
            group = "client",
            func = function()
                awful.client.focus.bydirection("right")
            end,
            modkeys = { modkey }
        },
        {
            description = "swap client (right)",
            group = "client",
            func = function()
                awful.client.swap.bydirection("right")
            end,
            modkeys = { modkey, "Shift" }
        },
        {
            description = "increase the number of columns",
            group = "layout",
            funct = function()
                awful.tag.incncol( 1, nil, true)
            end,
            modkeys = { modkey, "Control" }
        }
    },
    p = {
        {
            description = "increase number of master clients",
            group = "client",
            func = function()
                awful.tag.incnmaster( 1, nil, true)
            end,
            modkeys = { modkey, "Shift" }
        }
    },
    n = {
        {
            description = "decrease number of master clients",
            group = "client",
            func = function()
                awful.tag.incnmaster(-1, nil, true)
            end,
            modkeys = { modkey, "Shift" }

        }
    }
}

tiling["]"] = {
    {
        description = "increase master width factor",
        group = "client",
        func = function()
            awful.tag.incmwface(0.05)
        end,
        modkeys = { modkey, "Shift" }
    }
}

tiling["["] = {
    {
        description = "decrease master width factor",
        group = "client",
        func = function()
            awful.tag.incmwface(-0.05)
        end,
        modkeys = { modkey, "Shift" }
    }
}

-- Key bindings
globalkeys = gears.table.join(
    -- This should replace the xbindkeys implementation
    -- TODO: map this to a better keybinding that doesn't conflict as easily
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Set keys
root.keys(globalkeys)
