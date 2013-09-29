--Veins of the Earth
--Zireael

newBirthDescriptor {
	type = 'background',
	name = "Brawler",
	desc = 'Brawlers use their strength to full extent.\n\n Spend 4 skill points on Jump. Pick Power Attack as your first feat.',
	copy_add = {
	skill_points = -4,
	skill_intimidate = 4,
	},
	talents = {
		[ActorTalents.T_POWER_ATTACK]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Tough guy",
	desc = 'You are really hard to kill.\n\n Spend 4 skill points on Tumble and Swim each. Pick Power Attack as your first feat.',
	copy_add = {
	skill_points = -8,
	skill_intimidate = 4,
	skill_swim = 4,
	},
	talents = {
		[ActorTalents.T_TOUGHNESS]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Master of one",
	desc = 'You have focused on your weapon of choice.\n\n Spend 4 skill points on Jump and Swim each. Pick Weapon Focus as your first feat.',
	copy_add = {
	skill_points = -8,
	skill_jump = 4,
	skill_swim = 4,
	},
	talents = {
		[ActorTalents.T_WEAPON_FOCUS]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Exotic fighter",
	desc = 'You have learned how to use exotic weaponry.\n\n Spend 4 skill points on Jump and Swim each. Pick Exotic Weapon Proficiency as your first feat.',
	copy_add = {
	skill_points = -8,
	skill_jump = 4,
	skill_swim = 4,
	},
	talents = {
		[ActorTalents.T_EXOTIC_WEAPON_PROFICIENCY]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Fencing duelist",
	desc = 'You prefer dexterity to brute force.\n\n Spend 4 skill points on Tumble and Bluff each. Pick Finesse as your first feat.',
	copy_add = {
	skill_points = -8,
	skill_tumble = 4,
	skill_bluff = 4,
	},
	talents = {
		[ActorTalents.T_FINESSE]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Nimble fighter",
	desc = 'Instead of charging blindly into battle, you dance around your opponent.\n\n Spend 4 skill points on Tumble. Pick Dodge as your first feat.',
	copy_add = {
	skill_points = -4,
	skill_tumble = 4,
	},
	talents = {
		[ActorTalents.T_DODGE]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Smart fighter",
	desc = 'You use your head instead of fighting mindlessly.\n\n Spend 4 skill points on Intuition and Swim. Pick Combat Expertise as your first feat.',
	copy_add = {
	skill_points = -8,
	skill_intuition = 4,
	skill_swim = 4,
	},
	talents = {
		[ActorTalents.T_COMBAT_EXPERTISE]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Savage",
	desc = 'You were raised in the wild.\n\n Spend 4 skill points on Survival and Swim. Pick Power Attack as your first feat.',
	copy_add = {
	skill_points = -8,
	skill_survival = 4,
	skill_swim = 4,
	},
	talents = {
		[ActorTalents.T_POWER_ATTACK]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Smart brainiac",
	desc = 'You utilize your brain to its fullest.\n\n Spend 4 skill points on Intuition. Pick Iron Will as your first feat.',
	copy_add = {
	skill_points = -4,
	skill_intuition = 4,
	},
	talents = {
		[ActorTalents.T_IRON_WILL]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Sneaky thief",
	desc = 'You prefer sneaking around the opponents to face-to-face combat.\n\n Spend 4 skill points on Hide and Move Silently each. Pick Stealthy as the first feat.',
	copy_add = {
	skill_points = -8,
	skill_hide = 4,
	skill_movesilently = 4,
	},
	talents = {
		[ActorTalents.T_STEALTHY]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Magical thief",
	desc = 'You love playing with all those magic trinkets.\n\n Spend 4 skill points on Use Magic Device and Intuition each. Pick Magical Aptitude as the first feat.',
	copy_add = {
	skill_points = -8,
	skill_usemagic = 4,
	skill_intuition = 4,
	},
	talents = {
		[ActorTalents.T_MAGICAL_APTITUDE]=1,
	},
}

newBirthDescriptor {
	type = 'background',
	name = "Spellcaster",
	desc = 'Spells are your strength.\n\n Spend 4 skill points on Concentration. Pick Combat Casting as your first feat.',
	copy_add = {
	skill_points = -4,
	skill_concentration = 4,
	},
	talents = {
		[ActorTalents.T_COMBAT_CASTING]=1,
	},
}

--Filler (or for those who want to customize the character completely)
newBirthDescriptor {
	type = 'background',
	desc = 'Pick this option if you want to customize your character later or if none of the backgrounds appeal to you.\n\n You gain a feat point and none of the skill points are used up.',
	name = "None",
	copy_add = {
	feat_point = 1,
	}
}