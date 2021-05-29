-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- More widgets, layouts and utilities 
local lain = require("lain")
-- Overview
local revelation = require("revelation")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")

local dpi = require('beautiful').xresources.apply_dpi

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        
        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/yaru/theme.lua")
revelation.init({tag_name = "Expo", charorder = "asdfqwer"})
-- local bling = require("bling")
-- bling.module.flash_focus.enable()

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "micro"
editor_cmd = terminal .. " -e " .. editor

naughty.config.defaults.border_width = beautiful.notification_border_width
naughty.config.padding = dpi(13)
naughty.config.spacing = dpi(5)
naughty.config.icon_formats = {"svg"}
naughty.config.icon_dirs = {"/usr/share/icons/Papirus/48x48/apps/", "/usr/share/icons/Papirus/48x48/devices/", "/usr/share/icons/Papirus/48x48/status/", "/usr/share/icons/Papirus/24x24@2x/panel/"}
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

lain.layout.termfair.nmaster = 3
lain.layout.termfair.center.nmaster = 3
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    -- lain.layout.termfair,
    -- lain.layout.termfair.center,
    -- lain.layout.cascade,
    -- lain.layout.cascade.tile,
    lain.layout.centerwork,
    -- lain.layout.centerwork.horizontal,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
    awful.layout.suit.floating,
    -- awful.layout.suit.magnifier,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -x man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart awesome", awesome.restart },
   { "quit awesome", function() awesome.quit() end },
   { "suspend", "systemctl suspend"},
   { "restart", "systemctl reboot"},
   { "shutdown", "systemctl poweroff"},
}


mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("  %a %d, %H:%M  ") 

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
					 awful.button({ }, 2, function (c) 
											  c:kill()                         
										  end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 300 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Toggle titlebar on or off depending on s. Creates titlebar if it doesn't exist
local function setTitlebar(client, s)
    if s then
        if client.titlebar == nil then
            client:emit_signal("request::titlebars", "rules", {})
        end
        awful.titlebar.show(client)
    else 
        awful.titlebar.hide(client)
    end
end

function notificationDisplayIcon(perc)
    if perc == 100 then
        return "notification-display-brightness-full"
    elseif perc >= 80 then
        return "notification-display-brightness-high"
    elseif perc >= 40 then
        return "notification-display-brightness-medium"
    else
        return "notification-display-brightness-low"
    end
end

local function notifyBacklight(mode)
	awful.spawn.with_line_callback('xbacklight ' .. mode .. ' 10 -time 0', {
		exit = function()
			awful.spawn.with_line_callback('xbacklight -get', {
				stdout = function(perc)
					if notification_display ~= nil then
						notification_display = naughty.notify ({
							replaces_id	= notification_display.id,
							text        = string.rep("■", math.ceil(perc * 0.3)),
							icon        = notificationDisplayIcon(tonumber(perc)),
							-- width	 = 345,
							timeout  	= t_out,
							preset   	= preset
						})
					else
						notification_display = naughty.notify ({
							text     = string.rep("■", math.ceil(perc * 0.3)),
							icon     = notificationDisplayIcon(tonumber(perc)),
							-- width	 = 345,
							timeout  = t_out,
							preset   = preset
						})
					end
				end,
			})
		end,
	})
end

function notificationAudioIcon(perc)
    if perc > 65 then
        return "notification-audio-volume-high"
    elseif perc >= 35 then
        return "notification-audio-volume-medium"
    else
        return "notification-audio-volume-low"
    end
end

local function notifySound(mode)
	awful.spawn.with_line_callback('pamixer --' .. mode .. ' 5', {
		exit = function()
			awful.spawn.with_line_callback('pamixer --get-volume', {
                stdout = function(perc)
					if notification_audio ~= nil then
						notification_audio = naughty.notify ({
							replaces_id	= notification_audio.id,
							text        = string.rep("■", math.ceil(perc * 0.3)),
							icon        = notificationAudioIcon(tonumber(perc)),
							timeout  	= t_out,
							preset   	= preset
						})
					else
						notification_audio = naughty.notify ({
							text     = string.rep("■", math.ceil(perc * 0.3)),
							icon        = notificationAudioIcon(tonumber(perc)),
							timeout  = t_out,
							preset   = preset
						})
					end
				end,
			})
		end,
	})
end

local function notifySoundMuted()
	awful.spawn.with_line_callback('pamixer --toggle-mute', {
		exit = function()
			awful.spawn.with_line_callback('pamixer --get-volume', {
                stdout = function(perc)
					awful.spawn.with_line_callback('pamixer --get-mute', {
                        stdout = function(isMuted)
                            -- if notification_audio ~= nil then
                            if notification_audio ~= nil then
                                if isMuted == 'true' then
                                    notification_audio = naughty.notify ({
                                        replaces_id	= notification_audio.id,
                                        fg          =   "#676767",
                                        text        = string.rep("■", math.ceil(perc * 0.3)),
                                        icon        = "notification-audio-volume-muted",
                                        timeout  	= t_out,
                                        preset   	= preset
                                    })
                                else
                                    notification_audio = naughty.notify ({
                                        replaces_id	= notification_audio.id,
                                        text        = string.rep("■", math.ceil(perc * 0.3)),
                                        icon        = "notification-audio-volume-high",
                                        timeout  	= t_out,
                                        preset   	= preset
                                    })    
                                end
                            else
                                if isMuted == 'true' then
                                    notification_audio = naughty.notify ({
                                        fg       =   "#676767",
                                        icon     = "notification-audio-volume-muted",
                                        timeout  = t_out,
                                        preset   = preset
                                    })
                                else
                                    notification_audio = naughty.notify ({
                                        text     = string.rep("■", math.ceil(perc * 0.3)),
                                        icon     = "notification-audio-volume-high",
                                        timeout  = t_out,
                                        preset   = preset
                                    })
                                end
                            end
                        end,
                    })
				end,
			})
		end,
	})
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
       	widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 3,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 1,
                right = 1,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
		},
    }
    
	
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 23}) --, opacity = 0.90
 	
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- RLeft widgets
            layout = wibox.layout.fixed.horizontal,
            -- mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            -- mykeyboardlayout,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    -- awful.button({ }, 5, awful.tag.viewprev),
    -- awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 1, function () awful.spawn("rofi -modi drun -show drun -theme grid.rasi") end),
    awful.button({ }, 3, function () mymainmenu:toggle() end)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
	-- gaps 
	awful.key({ modkey, }, "=", function () awful.tag.incgap(beautiful.useless_gap)    end,
	{description = "increase gap", group = "layout"}),
	awful.key({ modkey, }, "-", function () awful.tag.incgap(-beautiful.useless_gap)    end,
	{description = "decrease gap", group = "layout"}),
	awful.key({ modkey, }, "0", function () awful.screen.focused().selected_tag.gap = beautiful.useless_gap    end,
	{description = "restore gap", group = "layout"}),

	awful.key({ altkey,           }, "space",  revelation),
	awful.key({ modkey, altkey }, "space", function()
            revelation({rule={class="conky"}, is_excluded=true, 
            curr_tag_only=true}) end),
    
    awful.key({ modkey, "Control" }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey, "Control" }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
 	awful.key({ modkey, "Control", altkey  }, "Left", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
   	awful.key({ modkey, "Control", altkey  }, "Right", function () lain.util.tag_view_nonempty(1) end,
   			  {description = "view  previous nonempty", group = "tag"}),
              
	awful.key({ modkey, 		}, "BackSpace", function()
		if naughty.is_suspended() then
			naughty.notify({ title = "Do not disturb",
			 				 text = "Desativado",
			 				 icon = "preferences-desktop-notification-bell" })
		else
			naughty.notify({ title = "Do not disturb",
			 				 text = "Ativado",
			 				 icon = "notification-disabled" })
		end
		naughty.toggle()
	end, {description = "Do not disturb", group = "Notification"}),
	
	awful.key({ modkey, 		}, "Delete", function()
		naughty.destroy_all_notifications()
	end),
              
	-- Move client to prev/next tag and switch to it
	awful.key({ modkey, "Control" , "Shift" }, "Left",
	    function ()
	        -- get current tag
	        local t = client.focus and client.focus.first_tag or nil
	        if t == nil then
	            return
	        end
	        -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
	        local tag = client.focus.screen.tags[(t.name - 2) % 9 + 1]
	        awful.client.movetotag(tag)
	        awful.tag.viewprev()
	    end,
	        {description = "move client to previous tag and switch to it", group = "layout"}),
	awful.key({ modkey, "Control" , "Shift" }, "Right",
	    function ()
	        -- get current tag
	        local t = client.focus and client.focus.first_tag or nil
	        if t == nil then
	            return
	        end
	        -- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
	        local tag = client.focus.screen.tags[(t.name % 9) + 1]
	        awful.client.movetotag(tag)
	        awful.tag.viewnext()
	    end,
	        {description = "move client to next tag and switch to it", group = "layout"}),
	
	-- Window navigation (by id)
    awful.key({ modkey,           }, "Right",
            function ()
                awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
    awful.key({ modkey,           }, "Left",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    
    -- Window navigation (by direction)
    -- awful.key({ modkey }, "Down",
            -- function()
                -- awful.client.focus.bydirection("down")
                -- if client.focus then client.focus:raise() end
            -- end),
        -- awful.key({ modkey }, "Up",
            -- function()
                -- awful.client.focus.bydirection("up")
                -- if client.focus then client.focus:raise() end
            -- end),
        -- awful.key({ modkey }, "Left",
            -- function()
                -- awful.client.focus.bydirection("left")
                -- if client.focus then client.focus:raise() end
            -- end),
        -- awful.key({ modkey }, "Right",
            -- function()
                -- awful.client.focus.bydirection("right")
                -- if client.focus then client.focus:raise() end
            -- end),
    
    awful.key({ altkey,           }, "Escape",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Tab", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
   
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              -- {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
	awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ altkey, "Control" }, "Right", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
	awful.key({ altkey, "Control" }, "Left", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
              
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift"    }, "Return", function () awful.spawn(terminal .. " --drop-down") end,
              {description = "open a dropdown terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    -- awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              -- {description = "quit awControlesome", group = "awesome"}),

    awful.key({ modkey, altkey }, "Right",     function () awful.tag.incmwfact( 0.03)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, altkey }, "Left",     function () awful.tag.incmwfact(-0.03)          end,
              {description = "decrease master width factor", group = "layout"}),
	awful.key({ modkey, altkey }, "Up",     function () awful.client.incwfact( 0.10)          end,
              {description = "increase non-master width factor", group = "layout"}),
    awful.key({ modkey, altkey }, "Down",     function () awful.client.incwfact(-0.10)          end,
              {description = "decrease non-master width factor", group = "layout"}),
    awful.key({ modkey, altkey }, ",",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, altkey }, ".",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, altkey }, "]",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, altkey }, "[",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,        }, "Next", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey }, "Prior", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, }, "Up",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Launchers
	awful.key({ modkey },            "d",     function () awful.spawn("rofi -modi drun -show drun -theme grid.rasi") end,
	        {description = "open applications", group = "launcher"}),
	              
	awful.key({ modkey },            "a",     function () awful.spawn("rofi -modi window -show window -theme list.rasi") end,
		    {description = "show windows (all desktops)", group = "launcher"}),
	
	awful.key({ modkey },            "w",     function () awful.spawn("rofi -modi windowcd -show windowcd -theme list.rasi") end,
		    {description = "show windows (current desktop)", group = "launcher"}),
		              
	awful.key({ modkey },            "b",     function () awful.spawn("rofi -modi calc -show calc -theme list.rasi -no-show-match -no-sort") end,
			{description = "calculator", group = "launcher"}),
	
	awful.key({ modkey },            "e",     function () awful.spawn("rofi -show emoji -modi emoji -theme emoji.rasi") end,
			{description = "emoji picker", group = "launcher"}),

	awful.key({ modkey },            "g",     function () awful.spawn("rofi -modi file-browser -show file-browser -theme list.rasi") end,
			{description = "file browser", group = "launcher"}),
		
	awful.key({ modkey },            "c",     function () awful.spawn("clipmenu -p '' -theme list.rasi") end,
			{description = "clipboard", group = "launcher"}),
			
	-- awful.key({ altkey },            "backslash",     function () awful.spawn("hud") end,
			-- {description = "clipboard", group = "launcher"}),
	              		              	              	              		              	             
	-- sudo updatedb -U "$HOME" -e "$HOME/.config" -e "$HOME/.local" -e "$HOME/.cache"
	awful.key({ modkey },            "s",     function () awful.spawn.with_shell("~/.local/scripts/search.sh") end,
	        {description = "File searcher", group = "launcher"}),
	              		              
	awful.key({ modkey },            "m",     function () awful.spawn.with_shell("UDISKIE_DMENU_LAUNCHER='rofi' udiskie-dmenu -theme list.rasi -p 禍 -matching regex -dmenu -i -no-custom -multi-select") end,
			{description = "Mount devices", group = "launcher"}),
	              		              
	awful.key({ modkey },         "Escape",     function () awful.spawn.with_shell("~/.local/scripts/seltr.sh") end,
			{description = "Translate selected text", group = "launcher"}),
			
	awful.key({ modkey , "Shift" },  "q",     function () awful.spawn("rofi -modi 'power:~/.local/scripts/powermenu.sh' -show power -theme power.rasi") end,
		 	{description = "Power menu", group = "launcher"}),
             
	-- Apps
	awful.key({ altkey , "Shift" },  "n",     function () awful.spawn(terminal .. " -e nmtui") end),
	awful.key({ modkey , "Shift" },  "n",     function () awful.spawn("networkmanager_dmenu") end,
			 {description = "network launcher", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "f",     function () awful.spawn(terminal .. " -e ranger -T ranger") end,
				 {description = "ranger file manager", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "h",     function () awful.spawn(terminal .. " -e htop -T htop") end,
				 {description = "htop", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "c",     function () awful.spawn(terminal .. " -e micro") end,
				 {description = "micro text editor", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "v",     function () awful.spawn("code") end,
				 {description = "vs code", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "a",     function () awful.spawn("spotifyd") end,
				 {description = "spotifyd", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "s",     function () awful.spawn(terminal .. " -e spt -T Spotify -I spotify") end,
				 {description = "spotify", group = "launcher"}),
	awful.key({ modkey , "Shift" },  "w",     function () awful.spawn("brave --password-store=basic") end,
				 {description = "web browser", group = "launcher"}),
	
              
	-- Lockscreen
    awful.key({ modkey },            "l",     function () awful.spawn.with_shell("~/.local/scripts/lockscreen.sh") end,
        {description = "Lock Screen", group = "launcher"}),
        
    -- Bright Keys
    awful.key({}, "XF86MonBrightnessUp", function() notifyBacklight("+") end), 
    awful.key({}, "XF86MonBrightnessDown", function() notifyBacklight("-") end),
              
	-- Volume Keys
    awful.key({}, "XF86AudioRaiseVolume", function() notifySound("increase") end), 
    awful.key({}, "XF86AudioLowerVolume", function() notifySound("decrease") end), 
    awful.key({}, "XF86AudioMute", function() notifySoundMuted() end),
    
	-- Media Keys	
    -- awful.key({}, "XF86AudioPlay", function()
    awful.key({modkey}, "/", function()
        awful.spawn("playerctl --player=spotify,%any play-pause", false)
    end),
    -- awful.key({}, "XF86AudioNext", function()
    awful.key({modkey}, ".", function()
        awful.spawn("playerctl --player=spotify,%any next", false)
    end),
    -- awful.key({}, "XF86AudioPrev", function()
    awful.key({modkey}, ",", function()
        awful.spawn("playerctl --player=spotify,%any previous", false)
    end),
	   
	-- Screenshot
    awful.key({}, "Print", function () 
        awful.spawn.with_shell("maim ~/Imagens/Screenshots/Screenshot_$(date +%Y%m%d)_$(date +%H%M%S).png", false) end,
    {description = "Print desktop", group = "Screenshot"}),
    awful.key({ modkey }, "Print", function ()
        awful.spawn.with_shell("maim -i $(xdotool getactivewindow) ~/Imagens/Screenshots/Screenshot_$(date +%Y%m%d)_$(date +%H%M%S).png", false) end,
    {description = "Print window", group = "Screenshot"}),
    awful.key({ "Shift" }, "Print", nil, function ()
        awful.spawn.with_shell("maim -s ~/Imagens/Screenshots/Screenshot_$(date +%Y%m%d)_$(date +%H%M%S).png", false) end,
    {description = "Print area", group = "Screenshot"}),
    awful.key({ "Control" }, "Print", nil, function ()
        awful.spawn.with_shell("maim -s | xclip -selection c -t image/png", false) end,
    {description = "Print area to clipboard", group = "Screenshot"}),

	-- Kill app
    awful.key({ altkey, "Control" }, "Delete", nil, function ()
            awful.spawn("xkill") end,
    {description = "Kill App"}),

    -- awful.key({ modkey }, "x",
              -- function ()
                  -- awful.prompt.run {
                    -- prompt       = "Run Lua code: ",
                    -- textbox      = awful.screen.focused().mypromptbox.widget,
                    -- exe_callback = awful.util.eval,
                    -- history_path = awful.util.get_cache_dir() .. "/history_eval"
                  -- }
              -- end,
              -- {description = "lua execute prompt", group = "awesome"}),
	
    -- Menubar
  	-- awful.key({ modkey }, "p", function() menubar.show() end,
		  -- {description = "show the menubar", group = "launcher"}),
		  
	awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
        {description = "run prompt", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, altkey, "Shift" }, "Home",  function (c) c:relative_move( 40,   0, -80,   0) end,
        {description = "decreases width", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "End",   function (c) c:relative_move(-40,   0,  80,   0) end,
    	{description = "increases width", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "Prior", function (c) c:relative_move(  0, -40,   0,  80) end,
    	{description = "increases height", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "Next",  function (c) c:relative_move(  0,  40,   0, -80) end,
    	{description = "decreases height", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "Down",  function (c) c:relative_move(  0,  40,   0,   0) end,
	    {description = "move down", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "Up",    function (c) c:relative_move(  0, -40,   0,   0) end,
    	{description = "move up", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "Left",  function (c) c:relative_move(-40,   0,   0,   0) end,
    	{description = "move left", group = "floating window"}),
    awful.key({ modkey, altkey, "Shift" }, "Right", function (c) c:relative_move( 40,   0,   0,   0) end,
    	{description = "move right", group = "floating window"}),
   	awful.key({}, "XF86Cut", function()
			awful.spawn("xdotool key F11", false)
   	   	end),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
	awful.key({ modkey, 'Control' }, 't',	   function(c) awful.titlebar.toggle(c) 	  	end,
	          {description = 'toggle title bar', group = 'client'}),
    awful.key({ modkey, 		  }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey,           }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ altkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ altkey, "Control", "Shift" }, "Left",      function (c) c:move_to_screen(c.screen.index-1)   end,
              {description = "move to screen", group = "client"}),
	awful.key({ altkey, "Control", "Shift" }, "Right",      function (c) c:move_to_screen(c.screen.index+1)   end,
	              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
	awful.key({ modkey,           }, "y",      function (c) c.sticky = not c.sticky            end,
              {description = "toggle sticky window", group = "client"}),
    awful.key({ modkey,           }, "Down",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey, "Shift" }, "Up",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"})

    -- awful.key({ modkey, "Control" }, "m",
        -- function (c)
            -- c.maximized_vertical = not c.maximized_vertical
            -- c:raise()
        -- end ,
        -- {description = "(un)maximize vertically", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "m",
        -- function (c)
            -- c.maximized_horizontal = not c.maximized_horizontal
            -- c:raise()
        -- end ,
        -- {description = "(un)maximize horizontally", group = "client"})
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
        awful.key({ altkey }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag #.
        awful.key({ altkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
		-- Move client to tag # and switch to it.
		        awful.key({ modkey, "Shift" }, "#" .. i + 9,
		                  function ()
		                      if client.focus then
		                          local tag = client.focus.screen.tags[i]
		                          if tag then
		                              client.focus:move_to_tag(tag)
		                              tag:view_only()
		                          end
		                     end
		                  end,
		                  {description = "move client and switch to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, altkey, "Shift" }, "#" .. i + 9,
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

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    -- awful.button({ }, 2, function (c)
        -- c:emit_signal("request::activate", "mouse_click", {raise = true})
        -- awful.mouse.client.move(c)
    -- end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "_NET_WM_STATE_FULLSCREEN_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)



-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.centered+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
            "pinentry",
            "gnome-pomodoro",
            "nm-connection-editor",
            "pavucontrol",
            "file-roller",
		},
		class = {
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer",
            "Gnome-pomodoro",
            "Nm-connection-editor",
            "Pavucontrol",
            "File-roller",
            "Gnome-calculator"
		},
		-- Note that the name property shown in xprop might be set slightly after creation of the client
		-- and the name shown there might not match defined rules here.
		name = {
            "Event Tester",  -- xev.
            "Picture-in-picture",
            "Settings",
            "com.github.davidmhewitt.torrential",
		},
		role = {
            "AlarmWindow",  -- Thunderbird's calendar.
            "ConfigManager",  -- Thunderbird's about:config.
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            "xfce4-terminal-dropdown",
		}
    }, properties = { floating = true }},
      
      
    -- Add titlebars to normal clients and dialogs
    { rule_any = { type = { "normal", "dialog" }
        }, properties = { titlebars_enabled = false }
    },
    
    { rule_any = { role = { "popup" }
        }, properties = { hidden = true }
    },  
    -- Game clients
    {
        -- Most Steam windows (friends list, "Activate a new product", "An update
        -- is available", etc.) should be floating…
        rule_any = {class = {"^[Ss]team$"}, title = {"^[Ss]team$"}},
        -- …but not the main window
        exclude_any = { name = {"Steam"}}, -- TODO: Identify the main window
        properties = { floating = true, size_hints_honor = true, tag = " 6 " },
    },
    
   	{ rule_any = { name = { "Media viewer" }
  	}, properties = { ontop = true, fullscreen = true }},

    -- Rules
    { rule = { class= "qvidcap" },
	    properties = { floating = true, sticky = true, ontop = true, focus = false, placement = "bottom_right" } },
    { rule = { class= "MEGAsync" },
	    properties = { floating = true, placement = "top_right" } },
	{ rule = { class= "Nitrogen" },
		properties = { floating = true, placement = "top_right" } },
  	{ rule = { class = "Gcolor3" },
  	    properties = { floating = true, sticky = true} },
	{ rule = { class= "mpv" },
		callback = function(c) awful.layout.set(awful.layout.suit.max) end},
	{ rule = { class= "feh" },
		callback = function(c) awful.layout.set(awful.layout.suit.max) end},
	{ rule = { instance="viewnior", class= "Viewnior" },
		callback = function(c) awful.layout.set(awful.layout.suit.max) end},
	{ rule = { instance="chromium", class="Chromium" },
		properties = { tag = " 2 ", switchtotag = true } },
	{ rule = { instance="dragon-drag-and-drop", class="Dragon-drag-and-drop" },
		properties = { ontop = true, sticky = true } },
	{ rule = { instance="heimer", class="Heimer" },
		properties = { floating = false, fullscreen = false } },	
    { rule = { instance="pt.overleaf", class="Chromium" },
        properties = { tag = " 6 ", floating = false } },
    { rule = { instance="web.whatsapp.com", class="Brave-browser" },
    	properties = { tag = " 8 " } },
    { rule = { class="TelegramDesktop" },
    	properties = { floating = true, tag = " 8 " } },
    { rule = { class="Skype" },
    	properties = { tag = " 7 " } },
    { rule = { class="discord" },
    	properties = { tag = " 7 " } },
    { rule = { class="[Ss]potify" },
        properties = { tag = " 9 " } },
	{ rule = { class="okular" },
		properties = { tag = " 9 ", switchtotag = true } ,
		callback = function(c) 
			awful.layout.set(awful.layout.suit.max, awful.tag.find_by_name(awful.screen.focused(), " 9 "))
		end}
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)

-- Hook called when a client spawns
client.connect_signal("manage", function(c) 
    setTitlebar(c, c.first_tag.layout == awful.layout.suit.floating) --c.floating or 
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size=26}) : setup {
	    {
	        { -- Left
	            -- awful.titlebar.widget.iconwidget(c),
	            -- awful.titlebar.widget.floatingbutton (c),
	            buttons = buttons,
	            layout  = wibox.layout.fixed.horizontal
	        },
	        { -- Middle
	            { -- Title
	                align  = "left",
	                widget = awful.titlebar.widget.titlewidget(c)
	            },
	            buttons = buttons,
	            layout  = wibox.layout.flex.horizontal
	        },
	        { -- Right
	            awful.titlebar.widget.minimizebutton (c),
	            awful.titlebar.widget.maximizedbutton(c),
	            awful.titlebar.widget.closebutton    (c),
	            -- awful.titlebar.widget.stickybutton   (c),
	            -- awful.titlebar.widget.ontopbutton    (c),
	            layout = wibox.layout.fixed.horizontal()
	        },
	        layout = wibox.layout.align.horizontal
	    },
    	widget = wibox.container.margin,
    	left = 8
	}
end)

-- Show titlebars on tags with the floating layout
tag.connect_signal("property::layout", function(t)
    -- New to Lua ? 
    -- pairs iterates on the table and return a key value pair
    -- I don't need the key here, so I put _ to ignore it
    for _, c in pairs(t:clients()) do
        if t.layout == awful.layout.suit.floating then
            setTitlebar(c, true)
        else
            setTitlebar(c, false)
        end
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
