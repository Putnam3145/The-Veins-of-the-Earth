require "engine.class"

local Dialog = require "engine.ui.Dialog"
local Birther = require "engine.Birther"

local SurfaceZone = require "engine.ui.SurfaceZone"
local Textzone = require "engine.ui.Textzone"
local Button = require "engine.ui.Button"
local Tab = require 'engine.ui.Tab'

local Textbox = require "engine.ui.Textbox"
local Checkbox = require "engine.ui.Checkbox"
local ListColumns = require "engine.ui.ListColumns"

local Stats = require "engine.interface.ActorStats"
local Talents = require "engine.interface.ActorTalents"
local Player = require "mod.class.Player"

--Required for the premades
local Savefile = require "engine.Savefile"
local Module = require "engine.Module"
local CharacterVaultSave = require "engine.CharacterVaultSave"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"

local NameGenerator = require "engine.NameGenerator"

local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Birther))

--For stats
local _points_text = "Points left: #00FF00#%d#WHITE#"
local _perks_text = "#LIGHT_BLUE#%s#WHITE#"

function _M:init(title, actor, order, at_end, quickbirth, w, h)
    self.quickbirth = quickbirth
    self.actor = actor
    self.order = order
    self.at_end = at_end

    self.reroll = false
    
    self.font = core.display.newFont("/data/font/VeraMono.ttf", 12)
    Dialog.init(self, "Character Creation", math.max(game.w * 0.7, 950), game.h*0.8, nil, nil, font)

    --Birther stuff
    self.descriptors = {}
    self.descriptors_by_type = {}

    --UI starts here

    --Name stuff
    self.c_name = Textbox.new {
    title = 'Name: ',
    text = game.player_name or 'player',
    chars = 30,
    max_len = 50,
    fct = function() end,
    on_change = function()
      self:updateDescriptors()
      self:updateUI()
    end,
    on_mouse = function(button)
     if button == "right" then self:randomName() end
    end,
  }
    
    --Tabs
    self.t_stats = Tab.new {
    title = 'Stats',
    default = true,
    fct = function() end,
    on_change = function(s) if s then self:switchTo('stats') end end,
    }

    self.t_general = Tab.new {
    title = 'General (m/m/m)',
    default = true,
    fct = function() end,
    on_change = function(s) if s then self:switchTo('general') end end,
    }
    self.t_optional = Tab.new {
    title = 'Optional (m/m)',
    default = false,
    fct = function() end,
    on_change = function(s) if s then self:switchTo('optional') end end,
    }

    self.vs = Separator.new { dir='vertical', size=self.iw }

     
    --COMMON STUFF
    self.c_legend = Textzone.new{width=self.iw/4, auto_height=true, text=[[
    List legend:
    #GOLD#Gold#LAST# is your current choice.
    #SANDY_BROWN#Brown#LAST# is recommended for new players.
    #LIGHT_GREEN#Green#LAST# is recommended based on your stats.
    #LIGHT_BLUE#Light blue#LAST# would grant you small additional bonuses based on your race.
    #CRIMSON#Red#LAST# is a bad choice!
    ]]}

    self.c_desc = TextzoneList.new{width=self.iw - ((self.iw/6)*4)-20, height = self.ih*0.4, scrollbar=true, text="Hello from description"}

    -- Buttons at the bottom of the screen
    self.c_premade = Button.new{text="Load premade", fct=function() self:loadPremadeUI() end}
    self.c_save = Button.new{text="     Play!     ", fct=function() self:atEnd() end}
    self.c_cancel = Button.new{text="Cancel", fct=function() self:cancel() end}

    --STATS TAB
    self:onSetupPB()

    self.starting_unused_stats = 20
    self.unused_stats = self.unused_stats or self.starting_unused_stats
    self.c_points = Textzone.new{width=self.iw/6, height=15, no_color_bleed=true, text=_points_text:format(self.unused_stats)}

    self:generateStats()
    self.c_stats = ListColumns.new{
        width=self.iw/6,
        height=200,
        all_clicks=true,
        columns={
            {name="Stat", width=40, display_prop="name"},
            {name="Value", width=50, display_prop="val"},
        },
        list=self.list_stats,
        fct=function(item, _, v)
            self:incStat(v == "left" and 1 or -1, item.stat_id)
        end,
        select=function(item, sel)
            self.sel = sel
            -- extract the actual val from the formatted string containing it
            self.val = string.match(item.val, "%d+")
            self.id = item.stat_id
            self:updateDesc(item)
        end
    }

    self.c_reroll = Button.new{text="Reroll", width=45, fct=function() self:onRoll() end}
    self.c_reset = Button.new{text="Reset",  width=45, fct=function() self:onReset() end}

    self:generatePerkText()
    self.c_perk_text = Textzone.new{auto_width=true, auto_height=true, text="#SANDY_BROWN#STARTING PERK: #LAST#"}
    self.c_perk_note = Textzone.new{auto_width=true, auto_height=true, text=_perks_text:format(self.actor.perk)}
    self.c_perk = List.new{
        width=self.iw/6,
        height=100,
        nb_items=#self.list_perk,
        list=self.list_perk,
        fct=function() end,
        select=function(item, sel)
            self:updateDesc(item)
        end
    }

    self.c_tut = Textzone.new{width=self.iw - ((self.iw/6)*4)-20, auto_height=true, text=[[
Press #00FF00#Reroll#FFFFFF# to determine stats randomly.
#00FF00#Left click#FFFFFF# on a stat to increase it.
#00FF00#Right click#FFFFFF# on a stat to decrease it.
Press #00FF00#Reset#FFFFFF# to return stats to the base values if you wish to try assigning them manually again.
]], scrollbar = true}

    
    --GENERAL TAB
    --Make UI work
    self:setDescriptor("base", "base")
    self:setDescriptor("sex", "Female")

    self.c_female = Checkbox.new{title="Female", default=true,
        fct=function() end,
        on_change=function(s) self.c_male.checked = not s self:setDescriptor("sex", s and "Female" or "Male") end
    }
    self.c_male = Checkbox.new{title="Male", default=false,
        fct=function() end,
        on_change=function(s) self.c_female.checked = not s self:setDescriptor("sex", s and "Male" or "Female") end
    }


    --Create lists
    --NOTE: Don't add more columns due to problems with more than 2 columns requiring scrolling
    self:generateLists()

    local lists_top = self.t_general.h + 15 + self.c_name.h + 35
    local lists_height = self.ih - lists_top - self.c_save.h - 20 

    self.c_class_text = Textzone.new{auto_width=true, auto_height=true, text="#SANDY_BROWN#Class: #LAST#"}
    self.c_class = List.new{width=self.iw/6, height = lists_height, nb_items=#self.list_class, list=self.list_class, fct=function(item) self:ClassUse(item) end, select=function(item,sel) self:updateDesc(item) end, scrollbar=true}--self:on_select(item,sel) end}

    self.c_race_text = Textzone.new{auto_width=true, auto_height=true, text="#SANDY_BROWN#Race: #LAST#"}
    self.c_race = List.new{width=self.iw/6, height = lists_height, nb_items=#self.list_race, list=self.list_race, fct=function(item) self:RaceUse(item) end, select=function(item,sel) self:updateDesc(item) end, scrollbar=true} --self:on_select(item,sel) end}

    --OPTIONAL TAB
    --NOTE: No text here requires scrolling. hence 3 columns

    local lists_height_opt = self.ih*0.75

    self.c_alignment_text = Textzone.new{auto_width=true, auto_height=true, text="#SANDY_BROWN#Alignment: #LAST#"}
    self.c_alignment = List.new{width=self.iw/6, height = lists_height_opt, nb_items=#self.list_alignment, list=self.list_alignment, fct=function(item) self:AlignmentUse(item) end, select=function(item,sel) self:on_select(item,sel) end, scrollbar=true}

    self:generateDeities()
    self.c_deity_text = Textzone.new{auto_width=true, auto_height=true, text="#SANDY_BROWN#Deity: #LAST#"}
    self.c_deity = List.new{width=self.iw/6, height = lists_height_opt, nb_items=#self.list_deity, list=self.list_deity, fct=function(item) self:DeityUse(item) end, select=function(item,sel) self:on_select(item,sel) end, scrollbar=true}

    self:generateBackgrounds()
    self.c_background_text = Textzone.new{auto_width=true, auto_height=true, text="#SANDY_BROWN#Background: #LAST#"}
    self.c_background = List.new{width=self.iw/6, height = lists_height_opt, nb_items=#self.list_background, list=self.list_background, fct=function(item) self:BackgroundUse(item) end, select=function(item,sel) self:on_select(item,sel) end, scrollbar=true}

    self:updateTab('all')
    self.t_stats:select()
end


function _M:switchTo(tab)
    self.t_stats.selected = tab == 'stats'
    self.t_general.selected = tab == 'general'
    self.t_optional.selected = tab == 'optional'

    self:drawDialog(tab)
end

--From ToME 2 by Zizzo
function _M:updateTab(tab)
  -- Convenient shorthand alias
  local dbt = self.descriptors_by_type

    if tab == 'all' then
        self:updateTab('general')
        self:updateTab('optional')
    elseif tab == "general" then
        local c1 = dbt.race and '*' or '_'
        local c2 = dbt.class and '*' or '_'
        self.t_general.title = ('General (%s/%s)'):format(c1, c2)
        self.t_general:generate()
    elseif tab == "optional" then
        local c1 = dbt.alignment and '*' or '_'
        local c2 = dbt.deity and '*' or '_'
        local c3 = dbt.background and '*' or '_'
        self.t_optional.title = ('Optional (%s/%s/%s)'):format(c1, c2, c3)
        self.t_optional:generate()
    else end
end 

function _M:drawDialog(tab)
    --Helpers for GENERAL tab
    local lists_top = self.t_general.h + 15 + self.c_name.h + 35
    

    if tab == 'stats' then
    self:loadUI{
        --Top line
        {left=0, top=0, ui=self.t_stats},
        {left=self.t_stats, top=0, ui=self.t_general},
        {left=self.t_general, top=0, ui=self.t_optional},
        {left=0, top=self.t_general, ui=self.vs },
        --First line (stats)
        {left=0, top=self.t_general.h + 15, ui=self.c_points},
        {left=0, top=self.t_general.h + 15 + self.c_points.h, ui=self.c_stats},
        {left=self.c_stats.w + 5, top = self.t_general.h + 15, ui=self.c_reset},
        {left=self.c_stats.w +5, top = self.t_general.h + 15 + self.c_reset.h + 5, ui=self.c_reroll},
        {left=self.c_stats.w + 5 + self.c_reroll.w + 20, top = self.t_general.h + 15, ui=self.c_perk_text },
        {left=self.c_stats.w + 5 + self.c_reroll.w + 20, top = self.t_general.h + 35, ui=self.c_perk_note },
        {left=self.c_stats.w + 5 + self.c_reroll.w + 20, top = self.t_general.h + 35, ui=self.c_perk },
        --Instruction
        {right=0, top=self.t_general.h + 15, ui=self.c_tut},
        {right=0, top=self.t_general.h + 15 + self.c_tut.h, ui=Separator.new{dir="vertical", size=self.iw - ((self.iw/6)*4)-20}},
        {right=0, top=self.t_general.h + 15 + self.c_tut.h + 15, ui=self.c_desc},
        --Buttons
        {left=0, bottom=0, ui=self.c_cancel},
        {left=self.c_cancel, bottom=0, ui=self.c_premade},
        {right=0, bottom=0, ui=self.c_save},
        {left=0, bottom=self.c_save.h + 5, ui=Separator.new{dir="vertical", size=self.iw - 10}},
    }

    self:setFocus(self.c_stats)

    self:updateUI()
    self:setupUI()


    elseif tab == 'general' then
    self:loadUI{
        --Top line
        {left=0, top=0, ui=self.t_stats},
        {left=self.t_stats, top=0, ui=self.t_general},
        {left=self.t_general, top=0, ui=self.t_optional},
        {left=0, top=self.t_general, ui=self.vs },
        -- First line
        {left=0, top=self.vs, ui=self.c_name},
        {left=self.c_name, top=self.vs, ui=self.c_female},
        {left=self.c_female, top=self.vs, ui=self.c_male},

        {left=0, top=self.t_general.h + 10 + self.c_name.h + 25, ui=Separator.new{dir="vertical", size=((self.iw/6)*4)}},

        --Third line (lists)
        {left=0, top=lists_top, ui=self.c_race_text},
        {left=0, top=self.c_race_text, ui=self.c_race},
        {left=self.c_race, top=lists_top, ui=self.c_class_text},
        {left=self.c_race, top=self.c_class_text, ui=self.c_class},
        

        --Instructions and description  
        {right=0, top = self.t_general.h + 15, ui=self.c_legend },
        {right=0, top=self.c_name.h + self.c_legend.h + 5, ui=Separator.new{dir="vertical", size=self.iw - ((self.iw/6)*4)-20}},
        {right=0, top=self.c_name.h + self.c_legend.h + 15, ui=self.c_desc},

        --Buttons
        {left=0, bottom=0, ui=self.c_cancel},
        {left=self.c_cancel, bottom=0, ui=self.c_premade},
        {right=0, bottom=0, ui=self.c_save},
        {left=0, bottom=self.c_save.h + 5, ui=Separator.new{dir="vertical", size=self.iw - 10}},

    }
    self:setFocus(self.c_name)

    self:updateUI()
    self:setupUI()

--    self.key:addBind("EXIT", function() game:unregisterDialog(self) end)
    
    elseif tab == "optional" then
        self:loadUI{
        --Top line
        {left=0, top=0, ui=self.t_stats},
        {left=self.t_stats, top=0, ui=self.t_general},
        {left=self.t_general, top=0, ui=self.t_optional},
        {left=0, top=self.t_general, ui=self.vs },

        --First line (lists)
        {left=0, top=self.vs, ui=self.c_alignment_text},
        {left=0, top=self.c_alignment_text, ui=self.c_alignment},
        {left=self.c_alignment, top=self.vs, ui=self.c_background_text},
        {left=self.c_alignment, top=self.c_background_text, ui=self.c_background},
        {left=self.c_background, top=self.vs, ui=self.c_deity_text},
        {left=self.c_background, top=self.c_deity_text, ui=self.c_deity},
        --Description & legend
        {right=0, top = self.t_general.h + 15, ui=self.c_legend },
        {right=0, top=self.c_name.h + self.c_legend.h + 5, ui=Separator.new{dir="vertical", size=self.iw - ((self.iw/6)*4)-20}},
        {right=0, top=self.c_name.h + self.c_legend.h + 15, ui=self.c_desc},
        --Buttons
        {left=0, bottom=0, ui=self.c_cancel},
        {left=self.c_cancel, bottom=0, ui=self.c_premade},
        {right=0, bottom=0, ui=self.c_save},
        {left=0, bottom=self.c_save.h + 5, ui=Separator.new{dir="vertical", size=self.iw - 10}},
    }

    self:setFocus(self.c_background)
    
    self:updateUI()
    self:setupUI()
    end
end

--COMMON stuff
function _M:updateDescriptors()
    self.descriptors = {}
    --Tab 1
    table.insert(self.descriptors, self.birth_descriptor_def.base[self.descriptors_by_type.base])
    table.insert(self.descriptors, self.birth_descriptor_def.sex[self.descriptors_by_type.sex])
    table.insert(self.descriptors, self.birth_descriptor_def.race[self.descriptors_by_type.race])
    table.insert(self.descriptors, self.birth_descriptor_def.class[self.descriptors_by_type.class])  
    table.insert(self.descriptors, self.birth_descriptor_def.alignment[self.descriptors_by_type.alignment])
    --Tab 2
    table.insert(self.descriptors, self.birth_descriptor_def.background[self.descriptors_by_type.background]) 
    table.insert(self.descriptors, self.birth_descriptor_def.deity[self.descriptors_by_type.deity]) 
end

function _M:setDescriptor(key, val)
    if key then
        self.descriptors_by_type[key] = val
        print("[BIRTHER] set descriptor", key, val)
    end
    self:updateDescriptors()

    self:updateUI()  
end

function _M:updateUI()
  local ok = self.c_name.text:len() >= 2
  for _, type in ipairs(self.order) do
    if not self.descriptors_by_type[type] then
      ok = false
      break;
    end
  end
  self:toggleDisplay(self.c_save, ok)
end

function _M:isDescriptorAllowed(d, ignore_type)
    self:updateDescriptors()

    if type(ignore_type) == "string" then
        ignore_type = {[ignore_type] = true}
    end
    ignore_type = ignore_type or {}

    local allowed = true
    local type = d.type
    print("[BIRTHER] checking allowance for ", d.name)
    for j, od in ipairs(self.descriptors) do
            if od.descriptor_choices and od.descriptor_choices[type] then
                local what = util.getval(od.descriptor_choices[type][d.name], self) or util.getval(od.descriptor_choices[type].__ALL__, self)
                if what and what == "allow" then
                    allowed = true
                elseif what and (what == "never" or what == "disallow") then
                    allowed = false
                elseif what and what == "forbid" then
                    allowed = nil
                end
                print("[BIRTHER] test against ", od.name, "=>", what, allowed)
                if allowed == nil then break end
            end
    end
return allowed
end


--GENERAL tab stuff

--To do at end/on finish
function _M:atEnd()
    self:checkNew(function() 

    game:unregisterDialog(self)
    self.actor:setName(self.c_name.text)
    self:apply()
    self.at_end()
    print("[BIRTHER] Finished!")

    --Display game options
    game:registerDialog(require("mod.dialogs.GameOptions").new(true))
 
end)
end

function _M:cancel()
    util.showMainMenu()
end

--Name stuffs 
function _M:checkNew(fct)
    local savename = self.c_name.text:gsub("[^a-zA-Z0-9_-.]", "_")
    if fs.exists(("/save/%s/game.teag"):format(savename)) then
        Dialog:yesnoPopup("Overwrite character?", "There is already a character with this name, do you want to overwrite it?", function(ret)
            if not ret then fct() end
        end, "No", "Yes")
    else
        fct()
    end
end

function _M:okclick()
    local name = self.c_name.text

    if name:len() < self.min or name:len() > self.max then
        Dialog:simplePopup("Error", ("Must be between %i and %i characters."):format(self.min, self.max))
        return
    end

    self:checkNew(name, function()
        game:unregisterDialog(self)
        self.action(name)
    end)
end

--Add tip for naming
function _M:on_focus(id, ui)
    if self.focus_ui and self.focus_ui.ui == self.c_name then self.c_desc:switchItem(self.c_name, "This is the name of your character.\nRight mouse click to generate a random name based on race and sex.") end
end

--List stuff
function _M:updateDesc(item)
    if item and item.desc then
       if self.c_desc then self.c_desc:switchItem(item, item.desc) end
    end
end

--[[function _M:use(item)
end]]

function _M:on_select(item,sel)
--    if self.c_desc then self.updateDesc(item) end
    if self.c_desc then self.c_desc:switchItem(item, item.desc) end
    self.selection = sel    
end

function _M:update()
    local sel = self.selection
    self:generateLists() -- Slow! Should just update the one changed and sort again
    self.c_class.list = self.list_class
    self.c_race.list = self.list_race
    self.c_alignment.list = self.list_alignment
    self.c_background.list = self.list_background
    self.c_class:generate()
    self.c_race:generate()
    self.c_alignment:generate()
    self.c_background:generate()
    self:updateTab('all')
end

function _M:updateRaces()
    local sel = self.selection
    self:generateRaces()
    self.c_race.list = self.list_race
    self.c_race:generate()
    self:updateTab('general')
end

function _M:updateClasses()
    local sel = self.selection
    self:generateClasses()
    self.c_class.list = self.list_class
    self.c_class:generate()
    self:updateTab('general')
end

function _M:updateAlignment()
    local sel = self.selection
    self:generateAlignment()
    self.c_alignment.list = self.list_alignment
    self.c_alignment:generate()
    self:updateTab("general")
end

--Helper functions yaay for beginner players!
function _M:isNewbieSuggested(d)
    self:updateDescriptors()

    if self.actor:getWis() >= 13 and d.name == "Cleric" then return true end
    if d.name == "Paladin" then return true end
    if d.name == "Ranger" then return true end

    return false
end


function _M:isBadChoice(d)
    self:updateDescriptors()

    if self.actor:getWis() <= 10 and d.name == "Cleric" then return true end
    if self.actor:getCha() <= 10 and d.name == "Shaman" then return true end
    if self.actor:getCha() <= 10 and d.name == "Sorcerer" then return true end
    if self.actor:getInt() <= 10 and d.name == "Wizard" then return true end

    return false
end

function _M:isFavoredClass(d)
    self:updateDescriptors()

    if not self.sel_race then end

    if self.sel_race.name == "Half-Orc" and d.name == "Barbarian" then return true end
    if self.sel_race.name == "Orc" and d.name == "Barbarian" then return true end
    if self.sel_race.name == "Half-Elf" and d.name == "Bard" then return true end
    if self.sel_race.name == "Gnome" and d.name == "Bard" then return true end
    if self.sel_race.name == "Drow" and self.c_female.checked and d.name == "Cleric" then return true end
    if self.sel_race.name == "Lizardfolk" and d.name == "Druid" then return true end
    if self.sel_race.name == "Dwarf" and d.name == "Fighter" then return true end
    if self.sel_race.name == "Duergar" and d.name == "Fighter" then return true end
    if self.sel_race.name == "Elf" and d.name == "Ranger" then return true end
    if self.sel_race.name == "Deep gnome" and d.name == "Rogue" then return true end
    if self.sel_race.name == "Kobold" and d.name == "Rogue" then return true end
    if self.sel_race.name == "Drow" and self.c_male.checked and d.name == "Wizard" then return true end

    return false
end

function _M:isSuggestedClass(d)
    self:updateDescriptors()

    if self.actor:getStr() >= 15 and d.name == "Barbarian" then return true end
    if self.actor:getStr() >= 15 and d.name == "Fighter" then return true end
    if self.actor:getDex() >= 15 and d.name == "Rogue" then return true end
    if self.actor:getCon() >= 15 and d.name == "Barbarian" then return true end
    if self.actor:getCon() >= 15 and d.name == "Fighter" then return true end
    if self.actor:getInt() >= 14 and d.name == "Wizard" then return true end
    if self.actor:getWis() >= 14 and d.name == "Cleric" then return true end
    if self.actor:getCha() >= 14 and d.name == "Sorcerer" then return true end
    if self.actor:getCha() >= 14 and d.name == "Shaman" then return true end

    return false
end  

function _M:isSuggestedBackground(d)
    self:updateDescriptors()

    if not self.sel_class then return end

    if self.sel_class.name == "Barbarian" and d.name == "Brawler" then return true end
    if self.sel_class.name == "Cleric" and d.name == "Spellcaster" then return true end
    if self.sel_class.name == "Druid" and d.name == "Spellcaster" then return true end
    if self.sel_class.name == "Fighter" and d.name == "Tough guy" then return true end
    if self.sel_class.name == "Rogue" and d.name == "Sneaky thief" then return true end
    if self.sel_class.name == "Shaman" and d.name == "Spellcaster" then return true end
    if self.sel_class.name == "Sorcerer" and d.name == "Spellcaster" then return true end
    if self.sel_class.name == "Wizard" and d.name == "Spellcaster" then return true end

    if self.sel_class.name == "Monk" and d.name == "Born hero" then return true end
    if self.sel_class.name == "Bard" and d.name == "Born hero" then return true end
    if self.sel_class.name == "Ranger" and d.name == "Born hero" then return true end
    if self.sel_class.name == "Warlock" and d.name == "Born hero" then return true end


    return false
end



--Generate the lists
function _M:generateLists()
    self:generateClasses()
    self:generateRaces()
    self:generateBackgrounds()
    self:generateAlignment()
    --For optional tab
    self:generateDeities()
end


function _M:generateRaces()
    local list = {}
    for i, d in ipairs(Birther.birth_descriptor_def.race) do
        if self:isDescriptorAllowed(d) then
          local color 
          if self.sel_race and self.sel_race.name == d.name then color = {255, 215, 0}
          else color = {255, 255, 255} end

          list[#list+1] = {name=d.name, color = color, desc=d.desc, d = d}
        end
    end
    self.list_race = list
end 

function _M:generateClasses()
    local list = {}
    for i, d in ipairs(Birther.birth_descriptor_def.class) do
        if self:isDescriptorAllowed(d) then
          local color
            if self.sel_class and self.sel_class.name == d.name then color = {255, 215, 0}
            elseif self:isBadChoice(d) then color = {201, 0, 0}
            elseif self:isNewbieSuggested(d) then color = {244, 164, 96}
            elseif self:isSuggestedClass(d) then color = {0, 255, 0}
            elseif self.sel_race and self:isFavoredClass(d) then color = {81, 221, 255}
            else color = {255, 255, 255} end

          list[#list+1] = {name=d.name, color = color, desc=d.desc, d = d}
        end
    end
    self.list_class = list
end 

function _M:generateAlignment()
    local list = {}
    for i, d in ipairs(Birther.birth_descriptor_def.alignment) do
        if self:isDescriptorAllowed(d) then
          local color 
          if self.sel_alignment and self.sel_alignment.name == d.name then color = {255, 215, 0}
          else color = {255, 255, 255} end

          list[#list+1] = {name=d.name, color = color, desc=d.desc, d = d}
        end
    end
    self.list_alignment = list
end   

function _M:RaceUse(item, sel)
    if not item then return end
    self.sel_race = nil
    self:setDescriptor("race", item.name)
    self.sel_race = item
    self:updateRaces()
    self:updateClasses()
end

function _M:ClassUse(item, sel)
    if not item then return end
    self.sel_class = nil
    self:setDescriptor("class", item.name)
    self.sel_class = item
    self:updateClasses()
    self:updateBackgrounds()
    self:updateAlignment()
    self:updateDeity()
end

function _M:AlignmentUse(item, sel)
    if not item then return end
    self.sel_alignment = nil
    self:setDescriptor("alignment", item.name)
    self.sel_alignment = item
    self:updateAlignment()
end

--STATS TAB
--Ensure stats at start
function _M:onSetupPB()
    for i, s in ipairs(self.actor.stats_def) do
        self.actor.stats[i] = 10
    end

    self.reroll = false
end

--Display random perk
--Warning: ONLY WORKS FOR PERKS that are talents!
function _M:generatePerkText()
    local list = {}
    for j, t in pairs(self.actor.talents_def) do
        if self.actor:knowTalent(t.id) then

            list[#list+1] = {
                name = "#LIGHT_BLUE#"..t.name.."#WHITE#",
            --    desc = player:getTalentFullDescription(t):toString(),
                desc = ("%s"):format(t.info(self.actor,t)),
                }
        end
    end
    self.list_perk = list
end

function _M:generateStats()
    local list = {}

    list = 
    {
            {name="STR", val=self.actor:birthColorStats('str'), stat_id=self.actor.STAT_STR, desc="#GOLD#Strength (STR)#LAST# is important for melee fighting."},
            {name="DEX", val=self.actor:birthColorStats('dex'), stat_id=self.actor.STAT_DEX, desc="You'll want to increase #GOLD#Dexterity (DEX)#LAST# if you want to play a ranger or a rogue. It's less important for fighters, who wear heavy armor."},
            {name="CON", val=self.actor:birthColorStats('con'), stat_id=self.actor.STAT_CON, desc="#GOLD#Constitution (CON)#LAST# is vital for all characters, since it affects your hitpoints."},
            {name="INT", val=self.actor:birthColorStats('int'), stat_id=self.actor.STAT_INT, desc="#GOLD#Intelligence (INT)#LAST# is a key attribute for wizards, since it affects their spellcasting. If it's lower than #LIGHT_RED#9#LAST#, you won't be able to cast spells if you're a wizard."},
            {name="WIS", val=self.actor:birthColorStats('wis'), stat_id=self.actor.STAT_WIS, desc="#GOLD#Wisdom (WIS)#LAST# is a key attribute for clerics and rangers, since it affects their spellcasting. If it's lower than #LIGHT_RED#9#LAST#, you won't be able to cast spells if you're a divine spellcaster."},
            {name="CHA", val=self.actor:birthColorStats('cha'), stat_id=self.actor.STAT_CHA, desc="#GOLD#Charisma (CHA)#LAST# is a key attribute for shamans or sorcerers, since it affects their spellcasting. If it's lower than #LIGHT_RED#9#LAST#, you won't be able to cast spells."},
            {name="#SLATE#LUC#LAST#", val=self.actor:birthColorStats('luc'), stat_id=self.actor.STAT_LUC, desc="#GOLD#Luck (LUC)#LAST# is special stat introduced in #TAN#Incursion#LAST# and borrowed by #SANDY_BROWN#the Veins of the Earth.#LAST# It's not implemented yet."},
        }

    self.list_stats = list
end

function _M:getCost(val)
    --Handle differing costs (Pathfinder style)
    -- 7 = -4; 8 = -2; 9 = -1; 10 = 0; 11 = 1; 12 = 2; 13 = 3; 14 = 5; 15 = 7; 16 = 10; 17 = 13; 18 = 17
    local costs = { -4, -2, -1, 0, 1, 2, 3, 5, 7, 10, 13, 17 }

    return costs[val-6]
end

function _M:incStat(v, id)
    print("inside incStat. self.sel is", self.sel)
    print("inside incStat. id is", self.id)
    print("inside incStat. val is", self.val)

    local id = self.id
    local val = self.val

    if self.reroll then return end

    --Limits
    if self.actor.stats[id] + v > 18 then
        self:simplePopup("Max stat value reached", "You cannot increase a stat above 18.")
        return
    end
    if self.actor.stats[id] + v < 7 then
        self:simplePopup("Min stat value reached", "You cannot decrease a stat below 7.")
        return
    end
    local delta = self:getCost(tonumber(val) + v) - self:getCost(tonumber(val))
    if delta > self.unused_stats then
        self:simplePopup("Not enough stat points", "You have no stat points left.")
        return
    end

    local sel = self.sel
--  self.actor.stats[id] = self.actor.stats[id] + v

    self.actor:incStat(sel, v)
    self.unused_stats = self.unused_stats - delta
    self.c_stats.list[sel].val = self.actor.stats[id]
    self.c_stats:generate()
    self.c_stats.sel = sel
    self.c_stats:onSelect()
    self.c_points.text = _points_text:format(self.unused_stats)
    self.c_points:generate()
    self:StatUpdate()
    self:updateClasses()
end

function _M:StatUpdate()
    self.c_stats.key:addBinds{
    --    ACCEPT = function() self.key:triggerVirtual("EXIT") end,
        MOVE_LEFT = function() self:simplePopup("Press Reset", "Press Reset if you find the current selections too high!") end,
        MOVE_RIGHT = function() self:incStat(1) end,
    }
end



--Roller stuff now
function _M:onRoll()
    local player = self.actor
    --Unlearn any talent you might know to ensure you get only 1 perk ever
    for j, t in pairs(player.talents_def) do
            if player:knowTalent(t.id) then
            player:unlearnTalent(t.id) end
    end

    --scrap old perk
    if self.actor.perk ~= "" then self.actor.perk = "" end
    player:randomPerk()

    --Generate stats
    for i, s in ipairs(self.actor.stats_def) do
        self.actor.stats[i] = rng.dice(3,6)
    end

    self.reroll = true
    
    --Make sure that the highest stat is not <= than 13 and that the sum of all modifiers isn't <= 0
    local player = self.actor
    local mod_sum = player:getStrMod() + player:getDexMod() + player:getConMod() + player:getIntMod() + player:getWisMod() + player:getChaMod() 
    if mod_sum <= 0 or table.max{player:getStr(), player:getDex(), player:getCon(), player:getInt(), player:getWis(), player:getCha()} <= 13 then self:onRoll()
    else 
        self:generateStats()
        self.c_stats.list = self.list_stats
        self.c_stats:generate() 
        self:updateClasses()
        --update perks display
        self.c_perk_note.text = _perks_text:format(self.actor.perk)
        self.c_perk_note:generate()
        self:generatePerkText()
        self.c_perk.list = self.list_perk
        self.c_perk:generate()
        --Stop pb shenanigans
        self.unused_stats = 0
        self.c_points.text = _points_text:format(self.unused_stats)
        self.c_points:generate()
    end
end

function _M:onReset()
    self.unused_stats = self.starting_unused_stats
    self.c_points.text = _points_text:format(self.unused_stats)
    self.c_points:generate()
    self:onSetupPB()
    self:generateStats()
    self.c_stats.list = self.list_stats
    self.c_stats:generate()
    self:updateClasses()
end

--Optional tab stuff
function _M:generateBackgrounds()
    local list = {}
    for i, d in ipairs(Birther.birth_descriptor_def.background) do
        if self:isDescriptorAllowed(d) then
          local color 
          if self.sel_background and self.sel_background.name == d.name then color = {255, 215, 0}
          elseif self.sel_class and self:isSuggestedBackground(d) then color = {81, 221, 255}
          else color = {255, 255, 255} end

          list[#list+1] = {name=d.name, color = color, desc=d.desc, d = d}
        end
    end
    self.list_background = list
end

function _M:updateBackgrounds()
    local sel = self.selection
    self:generateBackgrounds()
    self.c_background.list = self.list_background
    self.c_background:generate()
    self:updateTab("optional")
end

function _M:BackgroundUse(item, sel)
    if not item then return end
    self.sel_background = nil
    self:setDescriptor("background", item.name)
    self.sel_background = item
    self:updateBackgrounds()
end

function _M:generateDeities()
    local list = {}
    for i, d in ipairs(Birther.birth_descriptor_def.deity) do
        if self:isDescriptorAllowed(d) then
          local color 
          if self.sel_deity and self.sel_deity.name == d.name then color = {255, 215, 0}
          else color = {255, 255, 255} end

          list[#list+1] = {name=d.name, color = color, desc=d.desc, d = d}
        end
    end
    self.list_deity = list
end 

function _M:updateDeity()
    local sel = self.selection
    self:generateDeities()
    self.c_deity.list = self.list_deity
    self.c_deity:generate()
    self:updateTab("optional")
end


function _M:DeityUse(item, sel)
    if not item then return end
    self.sel_deity = nil
    self:setDescriptor("deity", item.name)
    self.sel_deity = item
    self:updateDeity()
end



-- Disable stuff from the base Birther
function _M:updateList() end
function _M:selectType(type) end

function _M:on_register()
    --Castler fix for Textbox input
    game:onTickEnd(function() self.key:unicodeInput(true) end)


    if __module_extra_info.auto_quickbirth then
        local qb_short_name = __module_extra_info.auto_quickbirth:gsub("[^a-zA-Z0-9_-.]", "_")
        local lss = Module:listVaultSavesForCurrent()
        for i, pm in ipairs(lss) do
            if pm.short_name == qb_short_name then
                self:loadPremade(pm)
                break
            end
        end
    end
end


--Adjusted from ToME 4 - load premade
function _M:loadPremade(pm)
   local fallback = pm.force_fallback

    -- Load the entities directly
    if not fallback and pm.module_version and pm.module_version[1] == game.__mod_info.version[1] and pm.module_version[2] == game.__mod_info.version[2] and pm.module_version[3] == game.__mod_info.version[3] then
        savefile_pipe:ignoreSaveToken(true)
        local qb = savefile_pipe:doLoad(pm.short_name, "entity", "engine.CharacterVaultSave", "character")
        savefile_pipe:ignoreSaveToken(false)

        -- Load the player directly
        if qb then
            game:unregisterDialog(d)
            game.player = qb
            self:loadedPremade()
        else
            fallback = true
        end
    else
        fallback = true
    end

    -- Do nothing
    if fallback then
        local ok = 0    
    end
end

--Taken from ToME 4
function _M:loadPremadeUI()
    local lss = Module:listVaultSavesForCurrent()
    local d = Dialog.new("Characters Vault", 600, 550)

    local sel = nil
    local desc = TextzoneList.new{width=220, height=400}
    local list list = List.new{width=350, list=lss, height=400,
        fct=function(item)
            local oldsel, oldscroll = list.sel, list.scroll
            if sel == item then self:loadPremade(sel) game:unregisterDialog(d) end
            if sel then sel.color = nil end
            item.color = colors.simple(colors.LIGHT_GREEN)
            sel = item
            list:generate()
            list.sel, list.scroll = oldsel, oldscroll
        end,
        select=function(item) desc:switchItem(item, item.description) end
    }
    local sep = Separator.new{dir="horizontal", size=400}

    local load = Button.new{text=" Load ", fct=function() if sel then self:loadPremade(sel) game:unregisterDialog(d) end end}
    local close = Button.new{text="Close", fct=function() game:unregisterDialog(d) game:registerDialog(self) end }
    local del = Button.new{text="Delete", fct=function() if sel then
        self:yesnoPopup(sel.name, "Really delete premade: "..sel.name, function(ret) if ret then
            local vault = CharacterVaultSave.new(sel.short_name)
            vault:delete()
            vault:close()
            lss = Module:listVaultSavesForCurrent()
            list.list = lss
            list:generate()
            sel = nil
        end end)
    end end}

    d:loadUI{
        {left=0, top=0, ui=list},
        {left=list.w, top=0, ui=sep},
        {right=0, top=0, ui=desc},

        {left=0, bottom=0, ui=load},
        {left=load.w + 5, bottom=0, ui=del},
        {right=0, bottom=0, ui=close},
    }
    d:setupUI(true, true)


    game:unregisterDialog(self)
    game:registerDialog(d)
end

function _M:loadedPremade()

    game:unregisterDialog(self)
--    game:unregisterDialog(d)

    game:changeLevel(1, "tunnels")

    Map:setViewerActor(self.player)
    game:setupDisplayMode()

    game.always_target = true

    game.creating_player = true

--[[  self.creating_player = true
    game:changeLevel(1, "tunnels")
    print("[PLAYER BIRTH] resolve...")
    game.player:resolve()
    game.player:resolve(nil, true)
    game.player.changed = true
    game.player.energy.value = game.energy_to_act
    game.paused = true
        
    print("[PLAYER BIRTH] resolved!")]]


    game.player:onPremadeBirth()
    local d = require("engine.dialogs.ShowText").new("Welcome to Veins of the Earth", "intro-"..game.player.starting_intro, {name=game.player.name}, nil, nil, function()
--self.player:playerLevelup() 
    game.creating_player = false

    game.player:levelPassives()
    game.player.changed = true
    end, true)
    game:registerDialog(d)
end

--Random names
function _M:randomName()

local random_name = {
  --Expanded with some Incursion names that matched the theme
  human_male = {
  syllablesStart ="Aethelmed, Aeron, Courynn, Blath, Bran, Lander, Luth, Daelric, Darvin, Dorn, Evendur, Grim, Jon, Helm, Morn, Randal, Lynneth, Rowan, Sealmyd, Borivik, Fyodor, Grigor, Ivor, Pavel, Vladislak, Anton, Marcon, Pieron, Rimardo, Romero, Salazar, Khalid, Rasheed, Zasheir, Pradir, Rajaput, Sikhir, Aoth, Ehput-Ki, Kethoth, Ramas, So-Kehur, Sammal, Kierny, Rathmere, Michealis, Matthais, Achrim, David, Quinn, Abrash, Pavrash, Vorkai",
  syllablesEnd ="Dulsaer, Jacerryl, Telstaer, Uthelienn, Wyndael, Pashar, Aporos, Nathos, Zora, Amblecrown, Duskman, Dundragon, Evenwood, Greycastle, Tallstag",
  rules = "$s $e",
  },
  --Expanded with some Incursion names that matched the theme
  human_female = {
  syllablesStart ="Ariadne, Courynna, Daelra, Lynneth, Betha, Kethra, Miri, Rowan, Shandri, Shandril, Sealmyd, Smylla, Wydda, Fyevarra, Immith, Shevarra, Tammith, Katernin, Dona, Luisa, Marta, Selise, Mara, Natali, Olga, Zofia, Jaheira, Zasheira, Nismet, Ril, Tiket, Chathi, Nephis, Sefris, Thola",
  syllablesEnd ="Dulsaer, Jacerryl, Telstaer, Uthelienn, Wyndael, Pashar, Aporos, Nathos, Zora, Amblecrown, Duskman, Dundragon, Evenwood, Greycastle, Tallstag, Ringal, Wernast, Onhalm, Faravis, Ferholm, Oswin, Hisham, Ullast, Senovise, Achabald",
  rules = "$s $e",
  },
  halfelf_male = {
  syllablesStart ="Aethelmed, Aeron, Courynn, Lander, Luth, Daelric, Darvin, Dorn, Evendur, Jon, Joneleth, Helm, Morn, Randal, Lynneth, Rowan, Sealmyd, Romero, Salazar, Khalid, Zasheir, Pradir, Rajaput, Sikhir, Aoth, Kethoth, Ramas, So-Kehur",
  syllablesEnd ="Dulsaer, Jacerryl, Telstaer, Uthelienn, Wyndael, Pashar, Aporos, Nathos, Zora, Amblecrown, Duskman, Dundragon, Evenwood, Greycastle, Tallstag, Moonblade, Moonflower, Eveningstar",
  rules = "$s $e",
  },

  halfelf_female = {
  syllablesStart ="Ariadne, Courynna, Lynneth, Miri, Rowan, Sealmyd, Shandri, Shandril, Smylla, Wydda, Fyevarra, Immith, Shevarra, Tammith, Katernin, Dona, Luisa, Selise, Mara, Natali, Zofia, Jaheira, Zasheira, Nismet, Ril, Nephis, Sefris, Laele, Larynda, Talice, Malice",
  syllablesEnd ="Dulsaer, Jacerryl, Telstaer, Uthelienn, Pashar, Aporos, Nathos, Zora, Amblecrown, Duskman, Dundragon, Evenwood, Greycastle, Tallstag, Moonblade, Moonflower, Eveningstar",
  rules = "$s $e",
  },

  --Expanded with some Incursion names that matched the theme
  elf_male = {
  syllablesStart ="Aravilar, Faelar, Saevel, Rhistel, Taeghen, Iliphar, Othorion, Aramil, Enialis, Ivellios, Laucian, Quarion, Selasia, Faridhir, Semirathis, Agorna, Disead, Cassius, Lachin, Tesserath, Amakiir, Holimion, Meliamne, Siannodel, Ilphukiir, Naofindel, Dios, Celebrand",
  syllablesMiddle = "Moon, Evening, Star, Gem, Diamond, Silver, Night, Blossom, Gold",
  syllablesEnd ="flower, blade, star, fall, whisper, dew, frond, child, heel, breeze, brook, petal",
  rules = "$s $m$e",
  },

  --Expanded with some Incursion names that matched the theme
  elf_female = {
  syllablesStart ="Hacathra, Imizael, Jhaumrithe, Quamara, Talindra, Vestele, Alea, Eoslin, Sephira, Selasia, Anastrianna, Antinua, Drusilia, Felosial, Ielenia, Lia, Qillathe, Silaqui, Valanthe, Xanaphia, Amastacia, Galanodel, Liadon, Xiloscient, Iosefel, Samariel, Morwen, Raelin, Vaegwal",
  syllablesMiddle = "Moon, Evening, Star, Gem, Diamond, Silver, Night, Blossom, Gold",
  syllablesEnd ="flower, blade, star, fall, whisper, dew, frond, child, heel, breeze, brook, petal",
  rules = "$s $m$e",
  },

  drow_male = { 
  syllablesStart ="Alak, Drizzt, Ilmryn, Khalazza, Merinid, Mourn, Nym, Pharaun, Rizzen, Solaufein, Sorn, Veldrin, Tebryn, Zaknafein, Dhauntel, Gomur'ss, Sornrak, Sszerin, Adinirahc, Belgos, Antatlab, Calimar, Duagloth, Elkantar, Filraen, Gelroos, Houndaer, Ilphrin, Kelnozz, Krondorl, Nalfein, Nilonim, Ryltar, Olgoloth, Quevven, Ryld, Sabrar, Nadal, Tarlyn, Tsabrak, Urlryn, Valas, Vorn, Vuzlyn, Zakfienal",
  syllablesMiddle = "",
  syllablesEnd ="Abaeir, Aleanrahel, Arabani, Arkhenneld, Auvryndar, Baenre, Coloara, Despana, Freth, Glannath, Helviiryn, Hune, Illistyn, Jaelre, Kilsek, Khalazza, Noquar, Pharn, Seerear, Vrinn, Xiltyn, Zauvirr, Zuavirr, Drannor, Alerae, Aleanana, Barriund, Eilsarn, Eilsath, Freana, Hlath, Hunath, Hlarae, Maeund, Melrae, Maearn, Maeani, Melath, Melund, Melth, Oussani, Oussvirr, Orlyth, Torana, Zauneld, Argith, Blundyth, Cormrael, Dhuunyl, Elpragh, Gellaer, Ghaun, Hyluan, Jhalavar, Olonrae, Philliom, Quavein, Ssambra, Tilntarn, Uloavae, Zolond, Zaphresz",
  rules = "$s $m$e",
  },

  drow_female = { 
  syllablesStart ="Akordia, Chalithra, Chalinthra, Eclavdra, Faere, Nedylene, Phaere, Qilue, SiNafay, Waerva, Umrae, Yasraena, Viconia, Veldrin, Vlondril, Akorae, Ilmiira, Ilphyrr, Inala, Luavrae, Nullynrae, Talthrae, Yasril, Aunrae, Burryna, Charinida, Chessintra, Dhaunae, Dilynrae, Drisinil, Drisnil, Elvraema, Faeryl, Ginafae, Haelra, Halisstra, Imrae, Inidil, Irae, Iymril, Jhaelryna, Minolin, Molvayas, Nathrae, Olorae, Quave, Sabrae, Shi'nayne, Ssapriina, Talabrina, Wuyondra, Xullrae, Xune, Zesstra",
  syllablesMiddle = "",
  syllablesEnd ="Abaeir, Aleanrahel, Arabani, Arkhenneld, Auvryndar, Baenre, Coloara, Despana, Freth, Glannath, Helviiryn, Hune, Illistyn, Jaelre, Kilsek, Khalazza, Noquar, Pharn, Seerear, Vrinn, Xiltyn, Zauvirr, Zuavirr, Drannor, Alerae, Aleanana, Barriund, Eilsarn, Eilsath, Freana, Hlath, Hunath, Hlarae, Maeund, Melrae, Maearn, Maeani, Melath, Melund, Melth, Oussani, Oussvirr, Orlyth, Torana, Zauneld, Argith, Blundyth, Cormrael, Dhuunyl, Elpragh, Gellaer, Ghaun, Hyluan, Jhalavar, Olonrae, Philliom, Quavein, Ssambra, Tilntarn, Uloavae, Zolond, Zaphresz",
  rules = "$s $m$e",
  },

  --Expanded with some Incursion names that matched the theme
  halforc_male = {
  syllablesStart ="Durth, Fang, Gothog, Harl, Orrusk, Orik, Thog, Dench, Feng, Gell, Henk, Holg, Imsh, Kesh, Ront, Shump, Thokk, Vang, Lothgar, Grognard, Shagga, Mogg, Shobri, Rathak, Volgar, Krang, Hurk, Ulgen, Varag, Maasdi, Garta, Zol",
  syllablesEnd ="Dummik, Horthor, Lammar, Turnskull, Ulkrunnar, Zorgar",
  rules = "$s $e",
  },

  --Expanded with some Incursion names that matched the theme
  halforc_female = {
  syllablesStart ="Creske, Duvaega, Neske, Orvaega, Varra, Yeskarra, Baggi, Engong, Myev, Neega, Ovak, Ownka, Shautha, Rutha, Wargi, Wesk, Dultha, Ruulam, Tautha, Vooga, Ilnush, Sawmi, Lenk, Lisva, Suubi, Rangka, Gaashi, Vuulga",
  syllablesEnd ="Horthor, Lammar, Turnskull, Ulkrunnar, Zorgar",
  rules = "$s $e",
  },

  --Names taken from Incursion
  kobold_male = { 
  syllablesStart = "Izi, Vucha, Tizzit, Zik, Zzas, Olik, Szissrit, Viska, Kissi, Wixel, Zichna, Ezzan, Kitz, Quizzit, Zazel, Igniz, Zigrat, Gizgaz, Rozrim, Zorbin, Aztan, Uzi, Ognin",
  syllablesEnd = "",
  rules = "$s $e",
  },

  kobold_female = { 
  syllablesStart = "Izi, Vucha, Tizzit, Zik, Zzas, Olik, Szissrit, Viska, Kissi, Wixel, Zichna, Ezzan, Kitz, Quizzit, Zazel, Igniz, Zigrat, Gizgaz, Rozrim, Zorbin, Aztan, Uzi, Ognin",
  syllablesEnd = "",
  rules = "$s $e",
  },


  --Expanded with some Incursion names that matched the theme
  dwarf_male = {
  syllablesStart ="Barundar, Dorn, Jovin, Khondar, Roryn, Storn, Thorik, Barendd, Brottor, Eberk, Einkil, Oskar, Ragnar, Rurik, Taklinn, Traubon, Ulfgar, Veit, Balderk, Dankil, Gorunn, Holderhek, Loderr, Lutgehr, Ungart, Orgil, Maenlin, Shaldar, Holdgen, Urthak, Gromlin, Makki",
  syllablesMiddle = "Blade, Crown, Skull, Stone, Battle, Gold, Gord, Forge, Iron, Axe, Ash, Mountain, Sky, Wind, Bright, Steel, True, Oaken, Blood, Deep",
  syllablesEnd ="bite, shield, dark, rivver, hammer, clan, driver, brother, cleft, keeper, rager, fury, forge, breaker, axe, blade, strike, stone",
  rules = "$s $m$e",
  },

  --Expanded with some Incursion names that matched the theme
  dwarf_female = {
  syllablesStart ="Belmara, Dorna, Sambril, Artin, Audhild, Dagnal, Diesa, Gunnloda, Hlin, Ilde, Liftrasa, Sannl, Torgga, Rumnahiem, Esgelt, Sansi, Terra, Relnan, Holdgen, Shamlir, Vaslin",
  syllablesMiddle = "Blade, Crown, Skull, Stone, Battle, Gold, Gord, Forge, Iron, Axe, Ash, Mountain, Sky, Wind, Bright, Steel, True, Oaken, Blood, Deep",
  syllablesEnd ="bite, shield, dark, rivver, hammer, clan, driver, brother, cleft, keeper, rager, fury, forge, breaker, axe, blade, strike, stone",
  rules = "$s $m$e",
  },

  duergar_male = {
  syllablesStart ="Barundar, Dorn, Jovin, Khondar, Roryn, Storn, Thorik",
  syllablesMiddle = "Blade, Crown, Skull, Stone, Battle, Dark, Gold, Gord, Forge, Iron, Axe, Ash, Mountain, Steel, True, Oaken, Blood, Deep",
  syllablesEnd = "bite, shield, dark, rivver, hammer, clan, driver, brother, cleft, keeper, rager, fury, forge, breaker, axe, blade, strike, stone",
  rules = "$s $m$e",
  },

  duergar_female = {
  syllablesStart = "Belmara, Dorna, Sambril",
  syllablesMiddle = "Blade, Crown, Skull, Stone, Battle, Dark, Gold, Gord, Forge, Iron, Axe, Ash, Mountain, Steel, True, Oaken, Blood, Deep",
  syllablesEnd = "bite, shield, dark, rivver, hammer, clan, driver, brother, cleft, keeper, rager, fury, forge, breaker, axe, blade, strike, stone",
  rules = "$s $m$e",
  },

  --Names taken from Incursion
  gnome_male = {
  syllablesStart = "Brundner, Ferris, Boddynock, Dimble, Fonkin, Gerbo, Jebeddo, Namfoodle, Nailo, Roondar, Seebo, Zook",
--  syllablesMiddle = "Black, Great, Riven, White",
  syllablesEnd = "Baren, Daergal, Folkor, Garrick, Nackle, Murnig, Ningel, Raulnor, Scheppen, Turen, Aleslosh, Ashhearth, Badger, Cloak, Doublelock, Filchbatter, Fnipper, Oneshoe, Sparklegem, Stumbleduck",
  rules = "$s $e",
  },
  gnome_female = {
  syllablesStart = "Eliss, Lissa, Meree, Nathee, Bimpnottin, Caramip, Duvamil, Ellywick, Loopmottin, Mardnab, Roywin, Shamil, Waywocket",
--  syllablesMiddle = "Black, Great, Riven, White",
    syllablesEnd = "Baren, Daergal, Folkor, Garrick, Nackle, Murnig, Ningel, Raulnor, Scheppen, Turen, Aleslosh, Ashhearth, Badger, Cloak, Doublelock, Filchbatter, Fnipper, Oneshoe, Sparklegem, Stumbleduck",
  rules = "$s $e",
  },

  --Expanded with some Incursion names that matched the theme
  halfling_male = {
  syllablesStart = "Dalabrac, Halandar, Omberc, Roberc, Thiraury, Willimac, Cade, Eldon, Garret, Lyle, Milo, Osborn, Roscoe, Wellby, Randy, Mitchel, Fairday, Hennit, Fenwell, Tristan, Geory, Gabe, Tanis, Brandy, Regis, Sheldon, Milton, Sanderson",
  syllablesMiddle = "Bramble, Dar, Harding, Merry, Starn, Brush, Bush, Good, Green, High, Under, Hill, Leaf, Tea, Thorn, Toss, Winter, Snow, Brandy, Stone, Tree, Blue",
  syllablesEnd = "foot, dragon, dale, mar, hap, gather, bother, barrel, bottle, hill, valley, topple, gallow, cobble, bough, crest, son, glide, field, hearth, buck, spirit, wine, top",
  rules = "$s $m$e",
  },

  --Expanded with some Incursion names that matched the theme
  halfling_female = {
  syllablesStart = "Deldira, Melinden, Olpara, Rosinden, Tara, Cora, Euphemia, Jillian, Lavinia, Merla, Portia, Seraphina, Verna, Agatha, Cecily, Gaimoina, Melody, Corianne, Jadis, Mabeline, Adele, Amile, Whitney",
  syllablesMiddle = "Bramble, Dar, Harding, Merry, Starn, Brush, Bush, Good, Green, High, Under, Hill, Leaf, Tea, Thorn, Toss, Winter, Snow, Brandy, Stone, Tree, Blue",
  syllablesEnd = "foot, dragon, dale, mar, hap, gather, bother, barrel, bottle, hill, valley, topple, gallow, cobble, bough, crest, son, glide, field, hearth, buck, spirit, wine, top",
  rules = "$s $m$e",
  }
} 

  local player = game.player
  self:updateDescriptors()

    if not self.sel_race then 
        self:simplePopup("No race selected", "You can't pick a name without a race selected!")
        return end

    if self.sel_race.name == "Human" then
      if self.c_female.checked then 
      local ng = NameGenerator.new(random_name.human_female) 
      self.c_name:setText(ng:generate()) 
      else local ng = NameGenerator.new(random_name.human_male)
        self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Half-Elf" or self.sel_race.name == "Half-Drow" then 
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.halfelf_female)
        self.c_name:setText(ng:generate()) 
      else
      local ng = NameGenerator.new(random_name.halfelf_male) 
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Elf" then
      if self.c_female.checked then
      local ng = NameGenerator.new(random_name.elf_female)
      self.c_name:setText(ng:generate()) 
      else 
      local ng = NameGenerator.new(random_name.elf_male)
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Half-Orc" or self.sel_race.name == "Orc" or self.sel_race.name == "Lizardfolk" then 
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.halforc_female)
        self.c_name:setText(ng:generate())
      else
      local ng = NameGenerator.new(random_name.halforc_male)
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Dwarf" then 
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.dwarf_female)
        self.c_name:setText(ng:generate()) 
      else 
      local ng = NameGenerator.new(random_name.dwarf_male) 
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Drow" then 
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.drow_female)
        self.c_name:setText(ng:generate()) 
      else
      local ng = NameGenerator.new(random_name.drow_male)
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Duergar" then 
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.duergar_female)
        self.c_name:setText(ng:generate())
      else
      local ng = NameGenerator.new(random_name.duergar_male) 
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race == "Deep gnome" or self.sel_race.name == "Gnome" then 
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.gnome_female)
        self.c_name:setText(ng:generate()) 
      else
      local ng = NameGenerator.new(random_name.gnome_male) 
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Halfling" then
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.halfling_female)
        self.c_name:setText(ng:generate()) 
      else
      local ng = NameGenerator.new(random_name.halfling_male) 
      self.c_name:setText(ng:generate()) end
    elseif self.sel_race.name == "Kobold" then
      if self.c_female.checked then
        local ng = NameGenerator.new(random_name.kobold_female)
        self.c_name:setText(ng:generate()) 
      else--if self.c_male.checked then
      local ng = NameGenerator.new(random_name.kobold_male) 
      self.c_name:setText(ng:generate()) end
    end

--    self.c_name:setText(namegen:generate())
end


--- Apply all birth options to the actor
function _M:apply()
    self.actor.descriptor = {}
    local stats, inc_stats = {}, {}
    for i, d in ipairs(self.descriptors) do
        print("[BIRTHER] Applying descriptor "..(d.name or "none"))
        self.actor.descriptor[d.type or "none"] = (d.name or "none")

        if d.copy then
            local copy = table.clone(d.copy, true)
            -- Append array part
            while #copy > 0 do
                local f = table.remove(copy)
                table.insert(self.actor, f)
            end
            -- Copy normal data
            table.merge(self.actor, copy, true)
        end
        if d.copy_add then
            local copy = table.clone(d.copy_add, true)
            -- Append array part
            while #copy > 0 do
                local f = table.remove(copy)
                table.insert(self.actor, f)
            end
            -- Copy normal data
            table.mergeAdd(self.actor, copy, true)
        end
        -- Change stats
        if d.stats then
            for stat, inc in pairs(d.stats) do
                stats[stat] = (stats[stat] or 0) + inc
            end
        end
        if d.inc_stats then
            for stat, inc in pairs(d.inc_stats) do
                inc_stats[stat] = (inc_stats[stat] or 0) + inc
            end
        end
        if d.talents_types then
            local tt = d.talents_types
            if type(tt) == "function" then tt = tt(self) end
            for t, v in pairs(tt) do
                local mastery
                if type(v) == "table" then
                    v, mastery = v[1], v[2]
                else
                    v, mastery = v, 0
                end
                self.actor:learnTalentType(t, v)
                self.actor.talents_types_mastery[t] = (self.actor.talents_types_mastery[t] or 0) + mastery
            end
        end
        if d.talents then
            for tid, lev in pairs(d.talents) do
                for i = 1, lev do
                    self.actor:learnTalent(tid, true)
                end
            end
        end
        if d.experience then self.actor.exp_mod = self.actor.exp_mod * d.experience end
        if d.body then
            self.actor.body = d.body
            self.actor:initBody()
        end
        if self.applyingDescriptor then self:applyingDescriptor(i, d) end
    end

    -- Apply stats now to not be overridden by other things
    for stat, inc in pairs(stats) do
        self.actor:incStat(stat, inc)
    end
    for stat, inc in pairs(inc_stats) do
        self.actor:incIncStat(stat, inc)
    end
end
