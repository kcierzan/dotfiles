local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
local light = require("system.backlight")
local exit = require("system.exit")
local naughty = require("naughty")

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

local function generate_tag_bindings()
    local tag_bindings = {}
    for i = 1, 9 do
        tag_bindings = gears.table.join(tag_bindings,
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
    return tag_bindings
end

local function bind_keys(globalkeys, ...)
    local binds = {}
    for _, keymap in ipairs({...}) do
        for key, bindings in pairs(keymap) do
            for _, binding in ipairs(bindings) do
                binds = gears.table.join(
                    binds,
                    awful.key(
                        binding.modkeys,
                        key,
                        binding.func,
                        {
                            description = binding.description,
                            group = binding.group
                        }
                    )
                )
            end
        end
    end
    binds = gears.table.join(binds, globalkeys)
    root.keys(binds)
end

local function zoom (direction)
    local screen = awful.screen.focused()

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
    -- TODO: the percent value should be parameterized
    f(client.focus, {margins=40, honor_workarea=true, honor_padding=true, to_percent=0.5})
end

local function nudge (c, direction)
    if direction == "left" then
        c.x = c.x - c.screen.geometry.width / 32
    elseif direction == "right" then
        c.x = c.x + c.screen.geometry.width / 32
    elseif direction == "up" then
        c.y = c.y - c.screen.geometry.height / 32
    elseif direction == "down" then
        c.y = c.y + c.screen.geometry.height / 32
    end
end

local function unminimize ()
    local c = awful.client.restore()
    if c then
        c:emit_signal("request:activate", "key.unminimize", {raise = true})
    end
end

local function show_rofi ()
    awful.spawn.with_shell("rofi -show combi -display-combi '' -display-drun ''")
end

local function set_window_mode_bindings ()
    if awful.layout.getname() == "floating" then
        bind_keys(generate_tag_bindings(), global_bindings, floating_bindings)
    else
        bind_keys(generate_tag_bindings(), global_bindings, tiling_bindings)
    end
end

local function switch_window_mode ()
    awful.layout.inc(-1)
    set_window_mode_bindings()
end

local function switch_tag (direction)
    if direction == "next" then
        awful.tag.viewnext()
    else
        awful.tag.viewprev()
    end
    set_window_mode_bindings()
end

local function toggle_client_size (c)
    if c.width == c.screen.geometry.width * 2/5 then
        c.width = c.screen.geometry.width * 4/5
        c.height = c.screen.geometry.height * 4/5
    elseif c.width == c.screen.geometry.width * 4/5 then
        c.width = c.screen.geometry.width * 3/5
        c.height = c.screen.geometry.height * 3/5
    elseif c.width == c.screen.geometry.width * 3/5 then
        c.width = c.screen.geometry.width * 2/5
        c.height = c.screen.geometry.height * 2/5
    else
        c.width = c.screen.geometry.width * 4/5
        c.height = c.screen.geometry.height * 4/5
    end
end

local function bindings_to_button_list (keymap)
    local button_list = {}
    for key, bindings in pairs(keymap) do
        for _, binding in ipairs(bindings) do
            button_list = gears.table.join(
                button_list,
                awful.key(binding.modkeys, key, binding.func, {description = binding.description, group = binding.group })
            )
        end
    end
    return button_list
end

local function open_tmux_terminal ()
    awful.spawn(terminal .. " sh -c 'tmux new-session; zsh'")
end

tiling_bindings = {
    j = { { description = "focus client (down)"              , group = "client", func = function() awful.client.focus.bydirection("down") end , modkeys = { modkey } },
          { description = "swap client (down)"               , group = "client", func = function() awful.client.swap.bydirection("down") end  , modkeys = { modkey, "Shift" } } },
    k = { { description = "focus client (up)"                , group = "client", func = function() awful.client.focus.bydirection("up") end   , modkeys = { modkey } },
          { description = "swap client (up)"                 , group = "client", func = function() awful.client.swap.bydirection("up") end    , modkeys = { modkey, "Shift" } } },
    h = { { description = "focus client (left)"              , group = "client", func = function() awful.client.focus.bydirection("left") end , modkeys = { modkey } },
          { description = "swap client (left)"               , group = "client", func = function() awful.client.swap.bydirection("left") end  , modkeys = { modkey, "Shift" } }  ,
          { description = "decrease the number of columns"   , group = "layout", func = function() awful.tag.incncol( -1, nil, true) end      , modkeys = { modkey, "Control" } } },
    l = { { description = "focus client (right)"             , group = "client", func = function() awful.client.focus.bydirection("right") end, modkeys = { modkey } },
          { description = "swap client (right)"              , group = "client", func = function() awful.client.swap.bydirection("right") end , modkeys = { modkey, "Shift" } }  ,
          { description = "increase the number of columns"   , group = "layout", func = function() awful.tag.incncol( 1, nil, true) end       , modkeys = { modkey, "Control" } } },
    p = { { description = "increase number of master clients", group = "client", func = function() awful.tag.incnmaster( 1, nil, true) end    , modkeys = { modkey, "Shift" } } }  ,
    n = { { description = "decrease number of master clients", group = "client", func = function() awful.tag.incnmaster(-1, nil, true) end    , modkeys = { modkey, "Shift" } } }
}
tiling_bindings["]"] = { { description = "increase master width factor", group = "client", func = function() awful.tag.incmwfact(0.05) end, modkeys = { modkey, "Shift" } } }
tiling_bindings["["] = { { description = "decrease master width factor", group = "client", func = function() awful.tag.incmwfact(-0.05) end, modkeys = { modkey, "Shift" } } }

global_bindings = {
    s = { { description = "show help", group = "awesome", func = hotkeys_popup.show_help                           , modkeys = { modkey } } },
    v = { { description = "open clipboard manager", group = "user"    , func = function() awful.spawn.with_shell("clipmenu") end , modkeys = { modkey      , "Shift" } } }   ,
    r = { { description = "reload awesome"        , group = "awesome" , func = awesome.restart                                   , modkeys = { modkey      , "Control" } } } ,
    q = { { description = "quit awesome"          , group = "awesome" , func = awesome.quit                                      , modkeys = { modkey      , "Shift" } } }   ,
    space = { { description = "rofi combi"            , group = "launcher", func = show_rofi                                         , modkeys = { modkey } }  ,
              { description = "toggle layout"         , group = "awesome" , func = function() switch_window_mode() end , modkeys = { modkey      , "Control" } } } ,
    Left = { { description = "view previous"         , group = "tag"     , func = function() switch_tag("previous") end             , modkeys = { modkey } } },
    Right = { { description = "view next"             , group = "tag"     , func = function() switch_tag("next") end                 , modkeys = { modkey } } },
    Return = { { description = "open a tmux terminal"  , group = "launcher", func = open_tmux_terminal                                , modkeys = { modkey } } },
    Escape = { { description = "show the exit screen"  , group = "awesome" , func = function() exit.exit_screen_show() end            , modkeys = { modkey } } },
    Tab = { { description = "switch clients"        , group = "client"  , func = function() awful.client.focus.byidx(1) end        , modkeys = { modkey } } },
    n = { { description = "unminimize client"     , group = "client"  , func = unminimize                                        , modkeys = { modkey      , "Control" } } }
}
global_bindings["="] = {
    { description = "increase screen brightness", group = "awesome", func = function() light.change_brightness("+") end, modkeys = { modkey } },
    { description = "increase screen temperature", group = "awesome", func = function() light.change_temperature("+") end, modkeys = { modkey, "Shift" } }
}
global_bindings["-"] = {
    { description = "decrease screen brightness", group = "awesome", func = function() light.change_brightness("-") end, modkeys = { modkey } },
    { description = "decrease screen temperature", group = "awesome", func = function() light.change_temperature("-") end, modkeys = { modkey, "Shift" } }
}
global_bindings["\\"] = { { description = "toggle redshift", group = "awesome", func = function() light.toggle_redshift() end, modkeys = { modkey } } }

floating_bindings = {
    j = { { description = "focus client (down)" , group = "client", func = function() awful.client.focus.bydirection("down") end , modkeys = { modkey } },
          { description = "warp to bottom"      , group = "client", func = function() zoom("bottom") end                         , modkeys = { modkey    , "Shift" } } },
    k = { { description = "focus client (up)"   , group = "client", func = function() awful.client.focus.bydirection("up") end   , modkeys = { modkey } },
          { description = "warp to top"         , group = "client", func = function() zoom("top") end                            , modkeys = { modkey    , "Shift" } } },
    h = { { description = "focus client (left)" , group = "client", func = function() awful.client.focus.bydirection("left") end , modkeys = { modkey } },
          { description = "warp to left"        , group = "client", func = function() zoom("left") end                           , modkeys = { modkey    , "Shift" } } },
    l = { { description = "focus client (right)", group = "client", func = function() awful.client.focus.bydirection("right") end, modkeys = { modkey } },
          { description = "warp to right"       , group = "client", func = function() zoom("right") end                          , modkeys = { modkey    , "Shift" } } }
}

client_bindings = {
    f = { {description = "toggle fullscreen"         , group = "client", func = function(c) c.fullscreen = not c.fullscreen c:raise() end                    , modkeys = { modkey } } },
    c = { {description = "close"                     , group = "client", func = function(c) c:kill() end                                                     , modkeys = { modkey       , "Control"} } }   ,
    Tab = { {description = "toggle floating"         , group = "client", func = awful.client.floating.toggle                                                 , modkeys = { modkey      , "Control" } } }  ,
    Return = { { description = "move to master"      , group = "client", func = function(c) c:swap(awful.client.getmaster()) end                             , modkeys = { modkey      , "Shift" } } }    ,
    o = { { description = "move to screen"           , group = "client", func = function(c) c:move_to_screen() end                                           , modkeys = { modkey } } },
    t = { { description = "toggle keep on top"       , group = "client", func = function(c) c.ontop = not c.ontop end                                        , modkeys = { modkey } } },
    n = { { description = "minimize"                 , group = "client", func = function(c) c.minimized = true end                                           , modkeys = { modkey } } },
    m = { { description = "(un)maximize vertically"  , group = "client", func = function(c) c.maximized_vertical = not c.maximized_vertical c:raise() end    , modkeys = { modkey, "Shift" } },
          { description = "(un)maximize horizontally", group = "client", func = function(c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end, modkeys = { modkey      , "Control"} }     ,
          { description = "(un)maximize"             , group = "client", func = function(c) c.maximized = not c.maximized end                                , modkeys = { modkey } } },
    u = { { description = "resize client"            , group = "client", func = function(c) toggle_client_size(c) end                                        , modkeys = { modkey      , "Shift" } }      ,
          { description = "center client"            , group = "client", func = function(c) awful.placement.centered(c) end                                  , modkeys = { modkey } } },
    h = { { description = "nudge a client left"      , group = "client", func = function(c) nudge(c, "left") end                                             , modkeys = { modkey, "Control"} } },
    j = { { description = "nudge a client down"      , group = "client", func = function(c) nudge(c, "down") end                                             , modkeys = { modkey, "Control"} } },
    k = { { description = "nudge a client up"        , group = "client", func = function(c) nudge(c, "up") end                                               , modkeys = { modkey, "Control"} } },
    l = { { description = "nudge a client right"     , group = "client", func = function(c) nudge(c, "right") end                                            , modkeys = { modkey, "Control"} } }
}

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = bindings_to_button_list(client_bindings),
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          -- "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },
    { rule_any = {name = { "Renoise" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}

bind_keys(generate_tag_bindings(), global_bindings, floating_bindings)
