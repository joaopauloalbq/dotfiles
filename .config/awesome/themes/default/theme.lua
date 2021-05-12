---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "Noto Sans 11"

theme.bg_normal     = "#353535"
theme.bg_focus      = "#5b5b5b"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#2a2a2a"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.useless_gap   = dpi(4)
theme.border_width  = dpi(0)
theme.border_normal = "#000000"
theme.border_focus  = "#5b5b5b"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_bg_focus = theme.bg_normal
theme.hotkeys_label_fg = "#fafafa"
theme.hotkeys_modifiers_fg = "#fafafa"
theme.hotkeys_description_font = theme.font
theme.hotkeys_font = theme.font
-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]
theme.notification_bg = "#454545"
theme.notification_border_color = "#404040"
-- theme.notification_height = dpi(60)
theme.notification_width = dpi(350)
theme.notification_icon_size = dpi(48)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "~/.config/awesome/themes/default/submenu.png"
theme.menu_height = dpi(26)
theme.menu_width  = dpi(200)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "~/.config/awesome/themes/default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "~/.config/awesome/themes/default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = "~/.config/awesome/themes/default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = "~/.config/awesome/themes/default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = "~/.config/awesome/themes/default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "~/.config/awesome/themes/default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "~/.config/awesome/themes/default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "~/.config/awesome/themes/default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "~/.config/awesome/themes/default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "~/.config/awesome/themes/default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "~/.config/awesome/themes/default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "~/.config/awesome/themes/default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "~/.config/awesome/themes/default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = "~/.config/awesome/themes/default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = "~/.config/awesome/themes/default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = "~/.config/awesome/themes/default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = "~/.config/awesome/themes/default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "~/.config/awesome/themes/default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "~/.config/awesome/themes/default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "~/.config/awesome/themes/default/titlebar/maximized_focus_active.png"

theme.wallpaper = "~/.wallpaper"

-- You can use your own layout icons like this:
theme.layout_fairh = "~/.config/awesome/themes/default/layouts/fairhw.png"
theme.layout_fairv = "~/.config/awesome/themes/default/layouts/fairvw.png"
theme.layout_floating  = "~/.config/awesome/themes/default/layouts/floatingw.png"
theme.layout_magnifier = "~/.config/awesome/themes/default/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/themes/default/layouts/maxw.png"
theme.layout_fullscreen = "~/.config/awesome/themes/default/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/themes/default/layouts/tilebottomw.png"
theme.layout_tileleft   = "~/.config/awesome/themes/default/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/themes/default/layouts/tilew.png"
theme.layout_tiletop = "~/.config/awesome/themes/default/layouts/tiletopw.png"
theme.layout_spiral  = "~/.config/awesome/themes/default/layouts/spiralw.png"
theme.layout_dwindle = "~/.config/awesome/themes/default/layouts/dwindlew.png"
theme.layout_cornernw = "~/.config/awesome/themes/default/layouts/cornernww.png"
theme.layout_cornerne = "~/.config/awesome/themes/default/layouts/cornernew.png"
theme.layout_cornersw = "~/.config/awesome/themes/default/layouts/cornersww.png"
theme.layout_cornerse = "~/.config/awesome/themes/default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Papirus-Dark-Maia"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
