local awful                                     = require('awful')
local wibox                                     = require('wibox')
local gears                                     = require('gears')
local beautiful                                 = require('beautiful')
local icons                                     = require('themes.custom.icons')
local dpi                                       = require('beautiful').xresources.apply_dpi
local clickable_container                       = require('widget.clickable-container')
local capi                                      = {button = _G.button}

--- Common method to create buttons.
-- @tab buttons
-- @param object
-- @treturn table
local function create_buttons(buttons, object)
  if buttons then
    local btns = {}
    for _, b in ipairs(buttons) do
      -- Create a proxy button object: it will receive the real
      -- press and release events, and will propagate them to the
      -- button object the user provided, but with the object as
      -- argument.
      local btn = capi.button {modifiers = b.modifiers, button = b.button}
      btn:connect_signal(
        'press',
        function()
          b:emit_signal('press', object)
        end
      )
      btn:connect_signal(
        'release',
        function()
          b:emit_signal('release', object)
        end
      )
      btns[#btns + 1] = btn
    end

    return btns
  end
end

local function list_update(w, buttons, label, data, objects)
  -- update the widgets, creating them if needed
  w:reset()
  for i, o in ipairs(objects) do
    local cache = data[o]
    local ib, cb, tb, cbm, bgb, tbm, ibm, tt, l, ll, bg_clickable
    if cache then
      ib = cache.ib
      tb = cache.tb
      bgb = cache.bgb
      tbm = cache.tbm
      ibm = cache.ibm
      tt  = cache.tt
    else
      ib = wibox.widget.imagebox()
      tb = wibox.widget.textbox()
      -- Icon for close button
      cb =
        clickable_container(
        wibox.container.margin(
          wibox.widget.imagebox(icons.close),
          4,
          4,
          4,
          4
        )
      )
      -- Container for icon close button
      cb.shape = gears.shape.circle
      cbm = wibox.container.margin(cb, dpi(4), dpi(8), dpi(1), dpi(1))
      cbm:buttons(
        gears.table.join(
          awful.button(
            {},
            1,
            nil,
            function()
              o.kill(o)
            end
          )
        )
      )
      bg_clickable = clickable_container()
      bgb = wibox.container.background()
      tbm = wibox.container.margin(tb, dpi(4), dpi(4))
      ibm = wibox.container.margin(ib, dpi(6), dpi(6), dpi(6), dpi(6))
      l = wibox.layout.fixed.horizontal()
      ll = wibox.layout.fixed.horizontal()

      -- All of this is added in a fixed widget
      l:fill_space(true)
      l:add(ibm)
      l:add(tbm)
      ll:add(l)
      ll:add(cbm)

      bg_clickable:set_widget(ll)
      -- And all of this gets a background
      bgb:set_widget(bg_clickable)

      l:buttons(create_buttons(buttons, o))

      -- Tooltip to display whole title, if it was truncated
      tt = awful.tooltip({
        objects = {tb},
        mode = 'outside',
        align = 'bottom',
        delay_show = 1,
      })

      data[o] = {
        ib = ib,
        tb = tb,
        bgb = bgb,
        tbm = tbm,
        ibm = ibm,
        tt  = tt
      }
    end

    local text, bg, bg_image, icon, args = label(o, tb)
    args = args or {}

     -- The text might be invalid, so use pcall.
     if text == nil or text == '' then
      tbm:set_margins(0)
    else
      -- truncate when title is too long
      local textOnly = text:match('>(.-)<')
      if (textOnly:len() > 24) then
        text = text:gsub('>(.-)<', '>' .. textOnly:sub(1, 21) .. '...<')
        tt:set_text(textOnly)
        tt:add_to_object(tb)
      else
        tt:remove_from_object(tb)
      end
      if not tb:set_markup_silently(text) then
        tb:set_markup('<i>&lt;Invalid text&gt;</i>')
      end
    end
    bgb:set_bg(bg)
    if type(bg_image) == 'function' then
      -- TODO: Why does this pass nil as an argument?
      bg_image = bg_image(tb, o, nil, objects, i)
    end
    bgb:set_bgimage(bg_image)
    if icon then
      ib.image = icon
    else
      ibm:set_margins(0)
    end

    bgb.shape = args.shape
    bgb.shape_border_width = args.shape_border_width
    bgb.shape_border_color = args.shape_border_color

    w:add(bgb)
  end
end

local tasklist_buttons =  awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end)
)

local taskList = function(s)
  return awful.widget.tasklist{
        screen = s, 
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        update_function = list_update,
        layout = wibox.layout.fixed.horizontal()
    }
end

return taskList
