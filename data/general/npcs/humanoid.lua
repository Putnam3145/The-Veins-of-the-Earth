-- Veins of the Earth
-- Zireael
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.


local Talents = require("engine.interface.ActorTalents")

newEntity{
	define_as = "BASE_NPC_HUMANOID",
	type = "humanoid",
	body = { INVEN = 10, MAIN_HAND = 1, OFF_HAND = 1, BODY = 1, HELM = 1 },
	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	ego = "/data/general/npcs/templates/humanoid.lua", egos_chance = { prefix=10, suffix=70},
	--Hack! Monsters drop corpses now
	resolvers.inventory {
	full_id=true,
	{ name = "fresh corpse" }
	},
}

newEntity{ base = "BASE_NPC_HUMANOID",
	define_as = "BASE_NPC_KOBOLD",
	type = "humanoid", subtype = "kobold",
	display = "k", color=colors.WHITE,
    desc = [[Ugly and green!]],
	stats = { str=9, dex=13, con=10, int=10, wis=9, cha=8, luc=12 },
	combat = { dam= {1,6} },
	infravision = 3,
	skill_hide = 4,
	skill_listen = 1,
	skill_spot = 1,
	skill_search = 1,
	skill_movesilently = 1,
        }

newEntity{ base = "BASE_NPC_KOBOLD",
	name = "kobold", color=colors.GREEN,
	level_range = {1, 4}, exp_worth = 75,
	rarity = 6,
	max_life = resolvers.rngavg(5,9),
	hit_die = 4,
	challenge = 1/2,
	resolvers.equip{
		full_id=true,
		{ name = "short spear" },
	},
}

newEntity{ base = "BASE_NPC_HUMANOID",
	define_as = "BASE_NPC_ORC",
	type = "humanoid", subtype = "orc",
	display = 'o', color=colors.GREEN,
	desc = [[An ugly orc.]],
	stats = { str=17, dex=11, con=12, int=8, wis=7, cha=6, luc=10 },
	combat = { dam= {1,4} },
	infravision = 2,
	skill_listen = 2,
	skill_spot = 2,
}

newEntity{
	base = "BASE_NPC_ORC",
	name = "orc warrior", color=colors.GREEN,
	level_range = {1, 4}, exp_worth = 150,
	rarity = 8,
	max_life = resolvers.rngavg(4,7),
	hit_die = 1,
	challenge = 1,
	resolvers.equip{
		full_id=true,
		{ name = "studded leather armor" },
		{ name = "falchion" },
	},
}

newEntity{ base = "BASE_NPC_HUMANOID",
	define_as = "BASE_NPC_TIEFLING", 
	type = "humanoid", subtype = "planetouched",
	display = 'h', color=colors.RED,
	desc = [[A horned tiefling.]],
	stats = { str=13, dex=13, con=12, int=12, wis=9, cha=6, luc=14 },
	combat = { dam= {1,6} },
	darkvision = 3,
	skill_bluff = 6,
	skill_hide = 4,

}

newEntity{
	base = "BASE_NPC_TIEFLING",
	name = "tiefling", color=colors.RED,
	level_range = {1, 4}, exp_worth = 150,
	rarity = 10,
	max_life = resolvers.rngavg(4,7),
	hit_die = 1,
	challenge = 1,
	resolvers.equip{
		full_id=true,
		{ name = "studded leather armor" },
		{ name = "rapier" },
	},
}

newEntity{ base = "BASE_NPC_HUMANOID",
	define_as = "BASE_NPC_GOBLIN",
	type = "humanoid", subtype = "goblin",
	display = 'g', color=colors.GREEN,
	desc = [[A dirty goblin.]],
	stats = { str=11, dex=13, con=12, int=10, wis=9, cha=6, luc=8 },
	combat = { dam= {1,6} },
	darkvision = 3,
	skill_hide = 4,
	skill_movesilently = 4,
	skill_listen = 2,
	skill_spot = 1,
}

newEntity{
	base = "BASE_NPC_GOBLIN",
	name = "goblin", color=colors.OLIVE_DRAB,
	level_range = {1, 4}, exp_worth = 50,
	rarity = 3,
	max_life = resolvers.rngavg(4,7),
	hit_die = 1,
	challenge = 1/3,
	resolvers.equip{
		full_id=true,
		{ name = "leather armor" },
		{ name = "light wooden shield" },
		{ name = "morningstar" },
	},
}

newEntity{ base = "BASE_NPC_HUMANOID",
	define_as = "BASE_NPC_DROW",
	type = "humanoid", subtype = "drow",
	display = 'h', color=colors.BLACK,
	desc = [[A dark silhouette.]],
	stats = { str=13, dex=13, con=10, int=12, wis=9, cha=10, luc=10 },
	combat = { dam= {1,6} },
	darkvision = 6,
	skill_hide = 1,
	skill_movesilently = 1,
	skill_listen = 2,
	skill_search = 3,
	skill_spot = 2,
}

newEntity{
	base = "BASE_NPC_DROW",
	name = "drow", color=colors.BLACK,
	level_range = {1, nil}, exp_worth = 150,
	rarity = 3,
	max_life = resolvers.rngavg(3,5),
	hit_die = 1,
	challenge = 1,
	resolvers.equip{
		full_id=true,
		{ name = "chain shirt" },
		{ name = "light metal shield" },
		{ name = "rapier" },
	},
}

newEntity{ base = "BASE_NPC_HUMANOID",
	define_as = "BASE_NPC_HUMAN",
	type = "humanoid", subtype = "human",
	display = 'h', color=colors.WHITE,
	desc = [[A lost human.]],
	stats = { str=11, dex=11, con=12, int=11, wis=9, cha=9, luc=10 },
	combat = { dam= {1,6} },
	lite = 3,
}

newEntity{
	base = "BASE_NPC_HUMAN",
	name = "human", color=colors.WHITE,
	level_range = {1, 5}, exp_worth = 150,
	rarity = 5,
	max_life = resolvers.rngavg(5,8),
	hit_die = 1,
	challenge = 1,
	resolvers.equip{
		full_id=true,
		{ name = "chainmail" },
		{ name = "light metal shield" },
		{ name = "longsword" },
	},
}
