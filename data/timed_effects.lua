-- Veins of the Earth
-- Copyright (C) 2013 Zireael, Sebsebeleb
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


local Stats = require "engine.interface.ActorStats"

-- Basic Conditions

newEffect{
	name = "FELL",
	desc = "Fell to the ground",
	type = "physical",
	status = "detrimental",
	on_gain = function(self, err) return "#Target# fell!", "+Fell" end,
	on_lose = function(self, err) return "#Target# got up from the ground.", "-Fell" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("never_move", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("never_move", eff.tmpid)
	end,
}

newEffect{
	name = "SLEEP",
	desc = "Sleeping",
	type = "physical",
	status = "detrimental",
	on_gain = function(self, err) return "#Target# falls asleep!", "+Sleep" end,
	on_lose = function(self, err) return "#Target# wakes up.", "-Sleep" end,
	activate = function(self, eff)
		eff.tmpid = self:addTemporaryValue("sleep", 1)
	end,
	deactivate = function(self, eff)
		self:removeTemporaryValue("sleep", eff.tmpid)
	end,
}

newEffect{
	name = "BLIND",
	desc = "Blinded",
	long_desc = [[The character cannot see. He takes a -2 penalty to Armor Class and loses his Dexterity bonus to AC (if any). 
		All opponents are considered to have total concealment (50% miss chance) to the blinded character.]],
	type = "physical",
	status = "detrimental",
	on_gain = function(self, err) return "#Target# loses sight!", "+Blind" end,
	on_lose = function(self, err) return "#Target# regains sight.", "-Blind" end,

}

newEffect{
	name = "FATIGUE",
	desc = "Fatigued",
	long_desc = [["A fatigued character can neither run nor charge and takes a -2 penalty to Strength and Dexterity. Doing anything that would normally cause fatigue causes the fatigued character to become exhausted. After 8 hours of complete rest, fatigued characters are no longer fatigued.]],
	type = "physical",
	status = "detrimental",
	on_gain = function(self, err) return "#Target# is fatigued!", "+Fatigue" end,
	on_lose = function(self, err) return "#Target# is no longer fatigued", "-Fatigue" end,
	activate = function(self, eff)
		local stat = { [Stats.STAT_STR]=-2, [Stats.STAT_DEX]=-2 }
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end
}

newEffect{
	name = "ACIDBURN",
	desc = "Burning from acid",
	type = "physical",
	status = "detrimental",
	parameters = { power=1 },
	on_gain = function(self, err) return "#Target# is covered in acid!", "+Acid" end,
	on_lose = function(self, err) return "#Target# is free from the acid.", "-Acid" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.ACID).projector(eff.src or self, self.x, self.y, DamageType.ACID, eff.power)
	end,
}

--Magical radiation, Zireael
newEffect{
	name = "MAG_RADIATION",
	desc = "Magical radiation",
	type = "physical",
	status = "detrimental",
	parameters = { power=2 },
	on_gain = function(self, err) return "#Target# is enveloped by underground magical radiation!", "+Radiation" end,
	on_lose = function(self, err) return "#Target# is free from the radiation.", "-Radiation" end,
	on_timeout = function(self, eff)
		DamageType:get(DamageType.FORCE).projector(eff.src or self, self.x, self.y, DamageType.FORCE, eff.power)
	end,
}

--Sebsebeleb
newEffect{
	name = "RAGE",
	desc = "Raging!",
	type = "mental",
	on_gain = function(self, err) return "#Target# is in a furious rage!", "+Rage" end,
	on_lose = function(self, err) return "#Target# has calmed down from the rage", "-Rage" end,
	activate = function(self, eff)
		local inc = { [Stats.STAT_STR]=4, [Stats.STAT_DEX]=4 }
		self:effectTemporaryValue(eff, "inc_stats", inc)
		self:effectTemporaryValue(eff, "will_save", 2)
		self:effectTemporaryValue(eff, "combat_def", -2)
	end,
	deactivate = function(self, eff)
		self:setEffect(self.EFF_FATIGUE, 5, {})
	end
}

newEffect{
	name = "BLOOD_VENGANCE",
	desc = "Angry!",
	type = "mental",
	activate = function(self, eff)
		local inc = { [Stats.STAT_STR]=2, }
		self:effectTemporaryValue(eff, "inc_stats", inc)
	end,
}

--Poisons, Zireael
--Oil of taggit and drow poison are missing because I have no idea for unconsciousness now

--Nitharit secondary effect; black lotus primary and secondary; othur fumes secondary
newEffect{
	name = "POISON_3d6CON",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(3,6)
		local stat = { [Stats.STAT_CON]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

--Sassone primary effect
newEffect{
	name = "POISON_2d12hp",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,12)
--		local stat = { [Stats.STAT_CON]=-change}
--		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

--Sassone secondary effect; black adder primary & secondary; deathblade primary; demon fever
newEffect{
	name = "POISON_1d6CON",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,6)
		local stat = { [Stats.STAT_CON]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_MALYSS_PRI",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local stat = { [Stats.STAT_DEX]=-1}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_MALYSS_SEC",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,4)
		local stat = { [Stats.STAT_DEX]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Terinav root primary; giant wasp primary & secondary
newEffect{
	name = "POISON_1d6DEX",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,6)
		local stat = { [Stats.STAT_DEX]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_TERINAV_SEC",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,6)
		local stat = { [Stats.STAT_DEX]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

--No secondary effect
newEffect{
	name = "POISON_DRAGON_BILE",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(3,6)
		local stat = { [Stats.STAT_STR]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_TOADSTOOL_PRI",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local stat = { [Stats.STAT_WIS]=-1}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_TOADSTOOL_SEC",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change1 = rng.dice(2,6)
		local change2 = rng.dice(1,4)
		local stat = { [Stats.STAT_WIS]=-change1, [Stats.STAT_INT]=-change2 }
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Arsenic primary; othur fumes primary; greenblood oil primary; blue whinnis primary
newEffect{
	name = "POISON_1CON",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local stat = { [Stats.STAT_CON]=-1}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_ARSENIC_SEC",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,8)
		local stat = { [Stats.STAT_CON]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

--Poison moss primary; mindfire
newEffect{
	name = "POISON_1d4INT",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,4)
		local stat = { [Stats.STAT_INT]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_MOSS_SEC",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,6)
		local stat = { [Stats.STAT_INT]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Lich dust primary; shadow essence secondary; purple worm secondary
newEffect{
	name = "POISON_2d6STR",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,6)
		local stat = { [Stats.STAT_STR]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Lich dust secondary; large scorpion primary & secondary; purple worm primary; red ache
newEffect{
	name = "POISON_1d6STR",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,6)
		local stat = { [Stats.STAT_STR]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Dark reaver primary; wyvern primary & secondary; deathblade secondary
newEffect{
	name = "POISON_2d6CON",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,6)
		local stat = { [Stats.STAT_CON]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_DARK_REAVER_SEC",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change1 = rng.dice(1,6)
		local change2 = rng.dice(1,6)
		local stat = { [Stats.STAT_CON]=-change1, [Stats.STAT_STR]=-change2}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_UNGOL_DUST_PRI",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local stat = { [Stats.STAT_CHA]=-1}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_UNGOL_DUST_SEC",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,6)
		local stat = { [Stats.STAT_CHA]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_INSANITY_MIST_PRI",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,4)
		local stat = { [Stats.STAT_WIS]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_INSANITY_MIST_SEC",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(2,6)
		local stat = { [Stats.STAT_WIS]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

--Primary & secondary the same
newEffect{
	name = "POISON_SMALL_CENTIPEDE",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,2)
		local stat = { [Stats.STAT_DEX]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--No primary effect
newEffect{
	name = "POISON_BLOODROOT_SEC",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,4)
		local change2 = rng.dice(1,3)
		local stat = { [Stats.STAT_CON]=-change1, [Stats.STAT_WIS]=-change2}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_GREENBLOOD_SEC",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,2)
		local stat = { [Stats.STAT_STR]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Primary & secondary medium spider; blinding sickness, devil chills
newEffect{
	name = "POISON_1d4STR",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,4)
		local stat = { [Stats.STAT_STR]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "POISON_SHADOW_ESSENCE_PRI",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local stat = { [Stats.STAT_STR]=-1}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

--Diseases, Zireael
newEffect{
	name = "DISEASE_CACKLE_FEVER",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,6)
		local stat = { [Stats.STAT_WIS]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "DISEASE_FILTH_FEVER",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change1 = rng.dice(1,3)
		local change2 = rng.dice(1,3)
		local stat = { [Stats.STAT_DEX]=-change1, [Stats.STAT_CON]=-change2 }
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}

newEffect{
	name = "DISEASE_SHAKES",
	desc = "Poison",
	type = "physical",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,8)
		local stat = { [Stats.STAT_DEX]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}
--Slimy doom
newEffect{
	name = "POISON_1d4CON",
	desc = "Poison",
	type = "mental",
	status = "detrimental",
	activate = function(self, eff)
		local change = rng.dice(1,4)
		local stat = { [Stats.STAT_CON]=-change}
		self:effectTemporaryValue(eff, "inc_stats", stat)
	end,
}