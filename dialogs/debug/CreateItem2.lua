--Veins of the Earth
-- Zireael 2014

--based on Zizzo's ToME port

require 'engine.class'
local Dialog = require 'engine.ui.Dialog'
local List = require 'engine.ui.List'
local Button = require 'engine.ui.Button'
local Numberbox = require 'engine.ui.Numberbox'

local Ego = require 'mod.class.Ego'

module(..., package.seeall, class.inherit(Dialog))

function _M:init()
  self.ego_names = {}

  Dialog.init(self, 'Create Object', 800, 600)

  self:generateList()

  self.c_items = List.new {
    width = 400,
    nb_items = 10,
--    display_prop = 'display',
    list = self.list,
    scrollbar = true,
    fct = function(item) self:selectItem(item) end,
  }
  self.c_pfx_egos = List.new {
    width = 200,
    nb_items = 10,
    display_prop = 'display',
    list = {},
    scrollbar = true,
    fct = function(item) self:selectEgo(item, self.c_pfx_egos, 'prefix') end,
  }
  self.c_sfx_egos = List.new {
    width = 200,
    nb_items = 10,
    display_prop = 'display',
    list = {},
    scrollbar = true,
    fct = function(item) self:selectEgo(item, self.c_sfx_egos, 'suffix') end,
  }
  self.c_nitems = Numberbox.new {
    title = 'Number: ',
    number = 1,
    min = 1,
    max = 100,
    chars = 3,
    fct = function(text) end,
  }
  self.c_create = Button.new {
    text = 'Create',
    fct = function() self:createItem() end,
  }
  self.c_cancel = Button.new {
    text = 'Cancel',
    fct = function() self.key:triggerVirtual('EXIT') end,
  }


  self:loadUI {
    { left=0, top=0, ui=self.c_items},
    { left=0, top=self.c_items.h, ui=self.c_nitems },
    { right=0, top=0, ui=self.c_sfx_egos },
    { right=self.c_sfx_egos.w, top=0, ui=self.c_pfx_egos },
    { right=0, bottom=0, ui=self.c_cancel },
    { right=self.c_cancel.w, bottom=0, ui=self.c_create },
  }

  self:setupUI()
  self:updateButton()

  self.key:addBinds {
    EXIT = function() game:unregisterDialog(self) end,
  }

end

function _M:onRegister()
  game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:readyToCreate()
  return self.sel_item and self.c_nitems.number
end

function _M:updateButton()
  self:toggleDisplay(self.c_create, self:readyToCreate())
end

function _M:setDisplayText(item, which)
  local sel = which
  if type(sel) == 'string' then
    sel = (item.id and item.id == self.ego_names[which]) or
      (not item.id and not self.ego_names[which])
  end
  item.display = sel and '#{bold}#'..item.name..'#{normal}#' or item.name
end

function _M:selectItem(item)
  if self.sel_item then
    self:setDisplayText(self.sel_item, false)
    self.c_items:drawItem(self.sel_item)
  end
  self.sel_item = item
  if self.sel_item then
    self:setDisplayText(self.sel_item, true)
    self.c_items:drawItem(self.sel_item)
  end
  self:updateButton()
  if not self.sel_item.unique then
  self:setupEgoLists()
  end
end

function _M:setupEgoLists()
  if not self.sel_item or not self.sel_item.e then
    self.c_pfx_egos.list = {}
    self.c_pfx_egos:generate()
    self.c_sfx_egos.list = {}
    self.c_sfx_egos:generate()
    self.ego_names = {}
    return
  end

  local Ego = require 'mod.class.Ego'

  local pfx_egos = { { name = 'No prefix ego' } }
  local sfx_egos = { { name = 'No suffix ego' } }

  for _, ego in ipairs(Ego:allowedEgosFor(self.sel_item.e)) do
    if ego.define_as then
    local dst = ego.prefix and pfx_egos or ego.suffix and sfx_egos
    local item = { name = ego.name, id = ego.define_as }
    dst[item.id] = item
    table.insert(dst, item)
    game.log("Inserted ego: "..item.name)
    end
  end
  self.ego_names = {}
  for _, item in ipairs(pfx_egos) do self:setDisplayText(item, 'prefix') end
  for _, item in ipairs(sfx_egos) do self:setDisplayText(item, 'suffix') end

  self.c_pfx_egos.list = pfx_egos
  self.c_pfx_egos:generate()
  self.c_sfx_egos.list = sfx_egos
  self.c_sfx_egos:generate()
end

function _M:selectEgo(item, c_egos, which)
  local egos = c_egos.list
  local prev_sel = self.ego_names[which] and egos[self.ego_names[which]] or egos[1]
  self.ego_names[which] = item.id
  self:setDisplayText(prev_sel, which)
  c_egos:drawItem(prev_sel)
  self:setDisplayText(item, which)
  c_egos:drawItem(item)
end

function _M:createItem()
  if not self:readyToCreate() then return end
  game:unregisterDialog(self)

    

    local qty = self.c_nitems.number
  --  local o = game.zone:finishEntity(game.level, 'object', self.sel_item.e)
    local o = game.zone:makeEntity(game.level, "object", {name = self.sel_item.name, ego_chance=-1000}, nil, true)
    o:setNumber(qty)

    if self.ego_names.prefix or self.ego_names.suffix then
        o.force_ego = {}
        for _, id in pairs(self.ego_names) do table.insert(o.force_ego, id) end
    end

    Ego:placeForcedEgos(o)

    game.zone:addEntity(game.level, o, 'object', game.player.x, game.player.y)
end

--Generate item list
function _M:generateList()
    local list = {}

    for i, e in ipairs(game.zone.object_list) do
        if e.name and e.rarity then
            local color
            if e.unique then color = {255, 215, 0}
            else color = {255, 255, 255} end

            list[#list+1] = {name=e.name, unique=e.unique, e=e}
        end
    end
    table.sort(list, function(a,b)
        if a.unique and not b.unique then return true
        elseif not a.unique and b.unique then return false end
        return a.name < b.name
    end)

    local chars = {}
    for i, v in ipairs(list) do
        v.name = v.name
        chars[self:makeKeyChar(i)] = i
    end
    list.chars = chars

    self.list = list
end