--[[
             ████████╗██╗  ██╗███████╗███╗   ███╗███████╗
             ╚══██╔══╝██║  ██║██╔════╝████╗ ████║██╔════╝
                ██║   ███████║█████╗  ██╔████╔██║█████╗  
                ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║██╔══╝  
                ██║   ██║  ██║███████╗██║ ╚═╝ ██║███████╗
                ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝
--]]

local gears                                     = require("gears")
local lain                                      = require("lain")
local awful                                     = require("awful")
local wibox                                     = require("wibox")
local dpi                                       = require("beautiful.xresources").apply_dpi

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Tags list
local tags                                      = require("themes.custom.tags")
local TagList                                   = require('widget.taglist')

-- Task list
local TaskList                                  = require('widget.tasklist')

-- Icons
-- Source : https://fontawesome.com/cheatsheet
local icons                                     = require('themes.custom.icons')

-- Load custom colors based on Base16
-- http://chriskempson.com/projects/base16/
local base16_colors                             = require("themes.custom.base16-colors")

local base16_palette = {
    base16_colors.default_dark,
    base16_colors.ocean,
    base16_colors.dracula
}
local color = base16_palette[2]

-- Theme options
local theme                                     = {}
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/custom"
theme.wallpaper                                 = theme.confdir .. "/wall.png"
theme.font                                      = "Noto Sans Regular 10"
theme.tasklist_font                             = "Noto Sans Regular 10"

-- Backgrounds
theme.bg_normal                                 = color.base00 --"00000000" -- Trasnparent
theme.bg_focus                                  = color.base01
theme.bg_urgent                                 = color.base02
theme.fg_normal                                 = color.base03
theme.fg_focus                                  = color.base07
theme.fg_urgent                                 = color.base08
theme.fg_minimize                               = color.base03

-- Border
theme.border_width                              = 2
theme.border_normal                             = color.base01
theme.border_focus                              = color.base00
theme.border_marked                             = color.base02

-- Taglist
theme.taglist_bg_normal                         = theme.bg_normal
theme.taglist_bg_focus =
  'linear:0,0:0,' ..
  dpi(28) ..
    ':0,' ..
      theme.bg_focus ..
        ':0.90,' .. theme.bg_focus .. ':0.90,' .. color.base08 .. ':1,' .. color.base08

-- Tasklist
theme.tasklist_font                             = 'Roboto medium 11'
theme.tasklist_bg_normal                        = theme.bg_normal
theme.tasklist_bg_focus =
  'linear:0,0:0,' ..
  dpi(28) ..
    ':0,' ..
      theme.bg_focus ..
        ':0.90,' .. theme.bg_focus .. ':0.90,' .. color.base08 .. ':1,' .. color.base08
theme.tasklist_bg_urgent                        = theme.bg_urgent
theme.tasklist_fg_normal                        = theme.fg_normal
theme.tasklist_fg_focus                         = theme.fg_focus
theme.tasklist_fg_urgent                        = theme.fg_normal
theme.tasklist_plain_task_name                  = true

-- Menu
theme.menu_height                               = 20
theme.menu_width                                = 140
-- theme.menu_bg_normal                            = "#000000"
-- theme.menu_bg_focus                             = "#000000"
-- theme.menu_border_width                         = 6
theme.awesome_icon                              = icons.awesome
theme.icon_theme                                = "Papirus Dark"

-- Title bar
theme.titlebar_bg_focus                         = color.base00
theme.titlebar_fg_focus                         = color.base06
theme.titlebar_bg_normal                        = color.base01
theme.titlebar_fg_normal                        = color.base04

--Layouts
theme.layout_floating                           = icons.floating
theme.layout_tile                               = icons.tile
theme.layout_tilebottom                         = icons.tilebottom
theme.layout_tileleft                           = icons.tileleft
theme.layout_tiletop                            = icons.tiletop

-- Titlebar
theme.titlebar_close_button_focus               = icons.close
theme.titlebar_close_button_normal              = icons.close
theme.titlebar_maximized_button_focus_inactive  = icons.plus
theme.titlebar_maximized_button_focus_active    = icons.plus

local markup = lain.util.markup

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local mytextclock = wibox.widget.textclock(markup(color.base04, "%A %d %B ") .. markup(color.base04, "|") .. markup(color.base04, " %H:%M "))
mytextclock.font = theme.font

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Terminus 10",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- ALSA volume
local vol_icon = wibox.widget.imagebox(icons.volume)
theme.volume = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup.fontfg(theme.font, color.base04, volume_now.level .. "% "))
    end
})

-- CPU
local cpu_icon = wibox.widget.imagebox(icons.cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, color.base04, cpu_now.usage .. "% "))
    end
})

-- MEM
local mem_icon = wibox.widget.imagebox(icons.memory)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, color.base04, mem_now.used .. "M "))
    end
})

-- MPD
local mpdicon = wibox.widget.imagebox()
theme.mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            mpdicon:set_image(icons.note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            --mpdicon:set_image() -- not working in 4.0
            mpdicon._private.image = nil
            mpdicon:emit_signal("widget::redraw_needed")
            mpdicon:emit_signal("widget::layout_changed")
        end
        widget:set_markup(markup.fontfg(theme.font, "#e54c62", artist) .. markup.fontfg(theme.font, "#b2b2b2", title))
    end
})

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           -- awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))
    
    -- Create the wibox
    s.mywibox = awful.wibar(
      {
        ontop = true,
        screen = s,
        height = dpi(28),
        width = s.geometry.width,
        stretch = false,
        bg = theme.bg_normal,
        fg = theme.fg_normal,
      }
    )

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mylayoutbox,
            TagList(s),
            s.mypromptbox,
            mpdicon,
            theme.mpd.widget,
        }, -- Middle widget
        TaskList(s),
        -- nil,
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            --netdownicon,
            --netdowninfo,
            --netupicon,
            --netupinfo.widget,
            wibox.container.margin(mem_icon, 4, 4, 4, 4),
            memory.widget,
            wibox.container.margin(cpu_icon, 4, 6, 6, 6),
            cpu.widget,
            wibox.container.margin(vol_icon, 4, 4, 4, 4),
            theme.volume.widget,
            mytextclock,
        },
    }
end

return theme
