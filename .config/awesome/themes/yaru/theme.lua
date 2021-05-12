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
theme.bg_urgent     = "#F06C6C"
theme.bg_minimize   = "#272727"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#ededed" --#aaaaaa"
theme.fg_focus      = "#ededed"
theme.fg_urgent     = "#ededed"
theme.fg_minimize   = "#dedede"

theme.useless_gap   = dpi(3) --3
theme.border_width  = dpi(0)
theme.border_normal = "#424242"
theme.border_focus  = "#047B7B" 
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the yaru one when
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

theme.titlebar_bg_normal = "#2c2c2c"
theme.titlebar_bg_focus = "#2c2c2c"
theme.hotkeys_label_fg = "#ededed"
theme.hotkeys_modifiers_fg = "#ededed"
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
-- theme.notification_height = dpi(60)
theme.notification_border_width = dpi(0)
theme.notification_bg = "#444445"
theme.notification_border_color = "#444445"
theme.notification_icon_size = dpi(48)
theme.notification_width = dpi(345)

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = "~/.config/awesome/themes/yaru/submenu.png"
theme.menu_height = dpi(28)
theme.menu_width  = dpi(200)
theme.menu_border_width  = dpi(0)
theme.menu_bg_normal  = "#3F3F3F"
theme.menu_border_color  = "#2c2c2c"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = "~/.config/awesome/themes/yaru/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = "~/.config/awesome/themes/yaru/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = "~/.config/awesome/themes/yaru/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = "~/.config/awesome/themes/yaru/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = "~/.config/awesome/themes/yaru/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = "~/.config/awesome/themes/yaru/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = "~/.config/awesome/themes/yaru/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = "~/.config/awesome/themes/yaru/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = "~/.config/awesome/themes/yaru/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = "~/.config/awesome/themes/yaru/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = "~/.config/awesome/themes/yaru/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = "~/.config/awesome/themes/yaru/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = "~/.config/awesome/themes/yaru/titlebar/sepa.png"
theme.titlebar_floating_button_focus_inactive  = "~/.config/awesome/themes/yaru/titlebar/sepa.png"
theme.titlebar_floating_button_normal_active = "~/.config/awesome/themes/yaru/titlebar/sepa.png"
theme.titlebar_floating_button_focus_active  = "~/.config/awesome/themes/yaru/titlebar/sepa.png"

theme.titlebar_maximized_button_normal_inactive = "~/.config/awesome/themes/yaru/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = "~/.config/awesome/themes/yaru/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = "~/.config/awesome/themes/yaru/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = "~/.config/awesome/themes/yaru/titlebar/maximized_focus_active.png"

theme.wallpaper = "~/.wallpaper"

-- You can use your own layout icons like this:
theme.layout_fairh = "~/.config/awesome/themes/yaru/layouts/fairhw.png"
theme.layout_fairv = "~/.config/awesome/themes/yaru/layouts/fairvw.png"
theme.layout_floating  = "~/.config/awesome/themes/yaru/layouts/floatingw.png"
theme.layout_magnifier = "~/.config/awesome/themes/yaru/layouts/magnifierw.png"
theme.layout_max = "~/.config/awesome/themes/yaru/layouts/maxw.png"
theme.layout_fullscreen = "~/.config/awesome/themes/yaru/layouts/fullscreenw.png"
theme.layout_tilebottom = "~/.config/awesome/themes/yaru/layouts/tilebottomw.png"
theme.layout_tileleft   = "~/.config/awesome/themes/yaru/layouts/tileleftw.png"
theme.layout_tile = "~/.config/awesome/themes/yaru/layouts/tilew.png"
theme.layout_tiletop = "~/.config/awesome/themes/yaru/layouts/tiletopw.png"
theme.layout_spiral  = "~/.config/awesome/themes/yaru/layouts/spiralw.png"
theme.layout_dwindle = "~/.config/awesome/themes/yaru/layouts/dwindlew.png"
theme.layout_cornernw = "~/.config/awesome/themes/yaru/layouts/cornernww.png"
theme.layout_cornerne = "~/.config/awesome/themes/yaru/layouts/cornernew.png"
theme.layout_cornersw = "~/.config/awesome/themes/yaru/layouts/cornersww.png"
theme.layout_cornerse = "~/.config/awesome/themes/yaru/layouts/cornersew.png"
theme.layout_centerwork = "~/.config/awesome/themes/yaru/layouts/centerwork.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- System tray
theme.systray_icon_spacing = 5

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Papirus-Dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
