--Veins of the Earth
--Zireael 2014


newEntity{
	define_as = "BASE_NPC_ENCOUNTER",
	type = "encounter",
	display = "!", color=colors.WHITE,
	level_range = {1, 4},
}

--Specific encounters
newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "drow couple",
	challenge = 2,
	rarity = 2,
	encounter_escort = {
	{ type="humanoid", name="drow", faction = "enemies", number=2},
  	},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "drow ambush party",
	rarity = 2,
	challenge = 3,
	encounter_escort = {
	{ type="humanoid", name="drow", faction = "enemies", number=3},
  	},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "kobold band",
	rarity = 2,
	challenge = 3,
	encounter_escort = {
	{ type="humanoid", name="kobold", number=3},
  	},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "goblin band",
	rarity = 2,
	challenge = 1,
	encounter_escort = {
	{ type="humanoid", name="goblin", number=3},
  	},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "mixed goblinoid warband",
	rarity = 2,
	challenge = 2,
	encounter_escort = {
	{ type="humanoid", name="goblin", number=3},
	{ type="humanoid", name="orc warrior", number=1},
  	},
}

--Vermin encounters
newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small colony of small spiders",
	rarity = 3,
	challenge = 2,
	encounter_escort = {
	{ type="vermin", name="small spider", number=2},
},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small colony of tiny spiders",
	rarity = 4,
	challenge = 2,
	encounter_escort = {
	{ type="vermin", name="tiny spider", number=8},
},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small colony of medium spiders",
	rarity = 5,
	challenge = 2,
	encounter_escort = {
	{ type="vermin", name="medium spider", number=2},
},	
}


newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "big colony of small spiders",
	rarity = 4,
	challenge = 3,
	encounter_escort = {
	{ type="vermin", name="small spider", number=5},
},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small swarm of small spiders",
	rarity = 5,
	challenge = 4,
	encounter_escort = {
	{ type="vermin", name="small spider", number=7},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "medium swarm of small spiders",
	rarity = 7,
	challenge = 4,
	encounter_escort = {
	{ type="vermin", name="small spider", number=9},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small colony of large spiders",
	rarity = 8,
	challenge = 4,
	encounter_escort = {
	{ type="vermin", name="large spider", number=2},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "large swarm of small spiders",
	rarity = 15,
	challenge = 5,
	encounter_escort = {
	{ type="vermin", name="small spider", number=11},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "large colony of medium spiders",
	rarity = 15,
	challenge = 5,
	encounter_escort = {
	{ type="vermin", name="medium spider", number=5},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "large colony of large spiders",
	rarity = 15,
	challenge = 7,
	encounter_escort = {
	{ type="vermin", name="large spider", number=5},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small colony of huge spiders",
	rarity = 20,
	challenge = 7,
	encounter_escort = {
	{ type="vermin", name="huge spider", number=2},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "large colony of huge spiders",
	rarity = 25,
	challenge = 10,
	encounter_escort = {
	{ type="vermin", name="huge spider", number=5},
},	
	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small plague of dire rats",
	rarity = 4,
	challenge = 3,
	encounter_escort = {
	{ type="vermin", name="dire rat", number=10},
},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "medium plague of dire rats",
	rarity = 6,
	challenge = 4,
	encounter_escort = {
	{ type="vermin", name="dire rat", number=14},
},
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "small plague of dire rats",
	rarity = 10,
	challenge = 5,
	encounter_escort = {
	{ type="vermin", name="dire rat", number=20},
},
}

--Outsiders
newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "mated pair of yeth hounds",
	rarity = 10,
	challenge = 5,
	encounter_escort = {
	{ type="outsider", name="yeth hound", number=2},
},	
}

newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "mated pair of barghests",
	rarity = 10,
	challenge = 6,
	encounter_escort = {
	{ type="outsider", name="barghest", number=2},
},	
}

--Magical beasts
newEntity{ base = "BASE_NPC_ENCOUNTER",
	name = "mated pair of behirs",
	rarity = 8,
	challenge = 10,
	encounter_escort = {
	{ type="magical_beast", name="behir", number=2},
},	
}