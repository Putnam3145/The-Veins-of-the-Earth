--Veins of the Earth
--Zireael

local Talents = require("engine.interface.ActorTalents")

newEntity{
	define_as = "BASE_NPC_MAGBEAST",
	type = "magical beast",
	body = { INVEN = 10 },
	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	stats = { str=10, dex=10, con=10, int=10, wis=10, cha=10, luc=10 },
	combat = { dam= {1,6} },
	alignment = "neutral",
	--Hack! Monsters drop corpses now
	resolvers.inventory {
	full_id=true,
	{ name = "fresh corpse" }
	},
}

--Fly 80 ft.
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_EAGLE",
	display = 'e', color=colors.YELLOW,
	desc = [[A proud eagle.]],
	stats = { str=18, dex=17, con=12, int=10, wis=14, cha=10, luc=12 },
	name = "giant eagle", color=colors.YELLOW,
	image = "tiles/eagle.png",
	level_range = {5, 15}, exp_worth = 900,
	rarity = 8,
	max_life = resolvers.rngavg(25,30),
	hit_die = 4,
	challenge = 3,
	combat_natural = 2,
	skill_listen = 2,
	skill_spot = 13,
	skill_survival = 1,
	movement_speed_bonus = -0.66,
}

newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_SHOCKLIZARD",
	display = 'q', color=colors.LIGHT_BLUE,
	desc = [[A lizard with light blue markings on its back.]],
	stats = { str=10, dex=15, con=13, int=2, wis=12, cha=6, luc=12 },
	combat = { dam= {1,4} },
	name = "shocker lizard",
	level_range = {1, 20}, exp_worth = 300,
	rarity = 8,
	max_life = resolvers.rngavg(12,15),
	hit_die = 2,
	challenge = 2,
	infravision = 3,
	skill_climb = 11,
	skill_hide = 9,
	skill_jump = 7,
	skill_listen = 3,
	skill_spot = 3,
	skill_swim = 10,
}

newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_ANKHEG",
	image = "tiles/ankheg.png",
	display = 'B', color=colors.DARK_UMBER,
	desc = [[A large chitin-covered insect.]],
	stats = { str=21, dex=10, con=17, int=1, wis=13, cha=6, luc=6 },
	combat = { dam= {2,6} },
	name = "ankheg",
	level_range = {5, 15}, exp_worth = 900,
	rarity = 8,
	max_life = resolvers.rngavg(25,30),
	hit_die = 3,
	challenge = 3,
	combat_natural = 8,
	skill_climb = 3,
	skill_listen = 5,
	skill_spot = 2,
	uncommon_desc = [[These natural tunnellers can see in most conditions, and have a extra sense that allows them to detect the slightest of movements through the earth.]],
	common_desc = [[As well as its lethal bite with which it can latch on to its victims, an ankheg has a natural acidic vemon which coats its mandibles and can be spit over short distances. Once an ankheg spits however, it takes a number of hours for it to build up its acid once more.]],
	base_desc = [[This creature is an ankheg, a huge, burrowing insect with a dangerous bite and a tenacity matched only by its hunger. It can see in the dark. 
	The tough, chitinous carapace of an ankheg can be used in the crafting of certain exotic heavy armours. Though a tricky material to work with, a skilled smith might find relatively undamaged specimens useful.]],
}

--Poison, spells, web, shapechange
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_ARANEA",
	image = "tiles/aranea.png",
	display = 's', color=colors.DARK_RED,
	desc = [[A large spider.]],
	stats = { str=11, dex=15, con=14, int=14, wis=13, cha=14, luc=12 },
	name = "aranea",
	level_range = {10, nil}, exp_worth = 900,
	rarity = 8,
	max_life = resolvers.rngavg(20,25),
	hit_die = 3,
	challenge = 4,
	infravision = 4,
	combat_natural = 1,
	skill_climb = 10,
	skill_listen = 5,
	skill_spot = 5,
	skill_concentration = 6,
	uncommon_desc = [[All araneas have some sorcerous talents, usually preferring illusions and enchantments and avoiding fire spells.]],
	common_desc = [[In its spider or hybrid forms, an aranea can throw webs and has a poisonous bite that can weaken or incapacitate opponents. Most araneas speak Common and Sylvan.]],
	base_desc = [[This creature is an aranea, an intelligent, shapechanging spider. It can see in the dark and change shape.]],
}

--Petrifying gaze 3 squares Fort DC 13, Blind-Fight
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_BASILISK",
	image = "tiles/lizard.png",
	display = 'R', color=colors.UMBER,
	desc = [[A large dull brown reptile.]],
	stats = { str=15, dex=8, con=15, int=2, wis=12, cha=11, luc=8 },
	name = "basilisk",
	level_range = {5, 15}, exp_worth = 1200,
	rarity = 10,
	max_life = resolvers.rngavg(40,45),
	hit_die = 6,
	challenge = 5,
	infravision = 4,
	combat_natural = 7,
	skill_hide = 4,
	skill_listen = 6,
	skill_spot = 6,
	specialist_desc = [[A much greater threat than the average basilisk is a fiendish variant known as the abyssal greater basilisk. Not only larger and stronger, the gaze of these creatures is far more potent.]],
	uncommon_desc = [[A basilisk's usual prey includes small mammals, birds, reptiles and similar creatures which it waits to ambush, turns to stone and then eats at its leisure. They are omnivorous and able to consume theur petrified victims, which are often a clear sign of a nearby basilisk lair.]],
	common_desc = [[Though very dangerous, the gaze attack of the basilisk has a limited range of about ten paces. Coupled with the fact that these creatures are slow and sluggish, most opponents can escape these creatures if they so wish.]],
	base_desc = [[This eight-legged reptilian creature is a basilisk that can turn creatures to stone with a mere glance. It can see in the dark.]],
}

--Speed 40 ft. breath weapon 2 squares cooldown 10 7d6 electric Ref DC 19; constrict 2d8, rake 1d4, immunity to electricity, scent
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_BEHIR",
	image = "tiles/lizard.png",
	display = 'R', color=colors.DARK_BLUE,
	desc = [[A large reptile in various shades of blue.]],
	stats = { str=26, dex=13, con=21, int=7, wis=14, cha=12, luc=12 },
	combat = { dam= {2,4} },
	name = "behir",
	level_range = {10, nil}, exp_worth = 2400,
	rarity = 10,
	max_life = resolvers.rngavg(90,95),
	hit_die = 9,
	challenge = 8,
	infravision = 4,
	combat_natural = 9,
	skill_climb = 8,
	skill_hide = 4,
	skill_listen = 2,
	skill_spot = 2,
--	resolvers.talents{ [Talents.T_POWER_ATTACK]=1, },
	specialist_desc = [[Though fearsome to behold, behirs are not necesarily aggressive. They have a similar outlook on life as many animals, are only guaranteed to attack if they feel threatened or are exceptionally hungry. They are also intelligent enough to be able to determine if the foe they face is likely to be stronger than they are. One of the few things they feel passionate about is dragonkind, with whom they refuse to coexist with peacefully. If a dragon moves in on a behir's territory, the behir will either drive it away if it can, or if not then move off to find a new home.]],
	uncommon_desc = [[Close combat with behirs is inadvisable. As well as a nasty bite, these creatures are natural grapplers, can constrict opponents in the coils of their bodies and can inflict multiple rake attacks on grappled foes with their six pairs of legs.]],
	common_desc = [[These creatures have a nasty breath weapon in the form of a bolt of electricity. Much like a snake, they are also capable of oppening their gullets to swallow creatures whole. Though somewhat draconic in appearance, behirs are unrelated to those creatures, and typically speak just the common tongue.]],
	base_desc = [[This huge monster is a behir, a serpentine creature that can slither like a snake or expand its dozen legs to run upon. It can see in the dark.]],
}

--Blink, dimension door; speed 40 ft.
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_BLINKDOG",
	image = "tiles/wolf.png",
	display = 'd', color=colors.DARK_BLUE,
	desc = [[A faintly shimmering canine.]],
	stats = { str=10, dex=17, con=10, int=10, wis=13, cha=11, luc=12 },
	name = "blink dog",
	level_range = {1, 20}, exp_worth = 600,
	rarity = 10,
	max_life = resolvers.rngavg(20,25),
	hit_die = 4,
	challenge = 2,
	infravision = 4,
	combat_natural = 3,
	skill_sensemotive = 1,
	skill_listen = 2,
	skill_spot = 2,
	skill_survival = 3,
	specialist_desc = [[Blink dogs and displacer beasts are natural enemies and attack each other on sight.]],
	uncommon_desc = [[Blink dogs are capable of producing dimension door once per round.]],
	common_desc = [[Blink dogs are intelligent, but cannot speak except in their own language. They can be convinced to make excellent companions.]],
	base_desc = [[This creature is a blink dog, named for their natural ability to use blink, as the spell. It can see in the dark.]],
}

--Scent, tremorsense 4 squares
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_BULETTE",
	image = "tiles/lizard.png",
	display = 'B', color=colors.BROWN,
	desc = [[A terrifying beast with a shark's head.]],
	stats = { str=27, dex=15, con=20, int=2, wis=13, cha=6, luc=12 },
	combat = { dam= {2,8} },
	name = "bulette",
	level_range = {10, nil}, exp_worth = 600,
	rarity = 15,
	max_life = resolvers.rngavg(90,95),
	hit_die = 9,
	challenge = 7,
	infravision = 4,
	combat_natural = 10,
	skill_jump = 10,
	skill_listen = 8,
	skill_spot = 2,
	uncommon_desc = [[Despite their massive bulk, bulettes can leap into the air, which allows it to attack with all four of its claws at the same time.]],
	common_desc = [[Bulettes can and do eat anything -- except elves. It dislikes the taste of dwarves and avoids them in favor of other prey. Bulettes can detect the presence of creatures by the subtle vibrations they make on the ground.]],
	base_desc = [[This creature is a bulette, commonly known as the "landshark." It is a voracious predator that is universally shunned by all other creatures. It can see in the dark.]],
}

--Fly 50 ft., scent; breath weapon 3d8 Ref DC 17 in a random color
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_CHIMERA",
	image = "tiles/gorgon.png",
	display = 'B', color=colors.BLACK,
	desc = [[A terrifying beast with multiple heads.]],
	stats = { str=19, dex=13, con=17, int=4, wis=13, cha=10, luc=8 },
	combat = { dam= {2,6} },
	name = "chimera",
	level_range = {10, nil}, exp_worth = 2000,
	rarity = 15,
	max_life = resolvers.rngavg(70,75),
	hit_die = 9,
	challenge = 7,
	infravision = 4,
	combat_natural = 8,
	skill_listen = 8,
	skill_spot = 8,
	uncommon_desc = [[Chimeras can attack from the ground or while flying, using their claws, both sets of teeth, its horns, or its breath weapon. The damage and shape of its breath weapon depends on the variety of its dragon head.]],
	common_desc = [[A chimera’s draconic head may be that of a black, blue, green, red, or white dragon. Because of their three heads, chimeras have exceptionally good hearing and vision.]],
	base_desc = [[This draconic creature is a chimera. It can see in the dark.]],
}

--Fly 60 ft.; petrification DC 12 on hit
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_COCKATRICE",
	image = "tiles/lizard.png",
	display = 'B', color=colors.BROWN,
	desc = [[A small sandy-colored creature with a rooster's comb.]],
	stats = { str=6, dex=17, con=11, int=2, wis=13, cha=9, luc=12 },
	combat = { dam= {2,8} },
	name = "cockatrice",
	level_range = {10, nil}, exp_worth = 900,
	rarity = 15,
	max_life = resolvers.rngavg(25,30),
	hit_die = 5,
	challenge = 3,
	infravision = 4,
	skill_listen = 6,
	skill_spot = 6,
	resolvers.talents{ [Talents.T_DODGE]=1, },
	movement_speed_bonus = -0.33,
	uncommon_desc = [[Cockatrices are infamous for their ability to turn creatures to stone with their bite. They are immune to the bite of other cockatrices, but other methods of petrification affect them normally.]],
	common_desc = [[Cockatrices fiercely attack anything and everything they perceive to be a threat. Flocks of cockatrices attempt to overcome opponents through confusion, often flying straight into their faces.]],
	base_desc = [[ This hybrid avian creature is a cockatrice. It can see in the dark.]],
}

--Fly 30 ft.; darkness, improved grab, constrict 1d4, blindsight 6 squares
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_DARKMANTLE",
	image = "tiles/bat.png",
	display = 'B', color=colors.BLACK,
	desc = [[A monster which resembles a stalactite.]],
	stats = { str=16, dex=10, con=11, int=2, wis=13, cha=9, luc=12 },
	combat = { dam= {1,4} },
	name = "darkmantle",
	level_range = {1, nil}, exp_worth = 300,
	rarity = 10,
	max_life = resolvers.rngavg(5,10),
	hit_die = 1,
	challenge = 1,
	infravision = 4,
	skill_listen = 5,
	skill_hide = 10,
	skill_spot = 5,
	movement_speed_bonus = -0.33,
	uncommon_desc = [[ As well as having a natural camouflage that allows them to hide easily in underground caverns, darkmantles can also cause darkness once per day. Darkmantles see easily through this magical darkness through the use of bat-like sonar, though this can be disrupted by the use of the silence spell.]],
	common_desc = [[ Though small creatures, darkmantles are strong for their size, and make natural grapplers due to their tentacles and cloak-like skin. Typically attacking by dropping from above, a darkmantle that misses will usually fly back up to the roof of its chamber and try again.]],
	base_desc = [[This squid-like dark-skinned creature is a darkmantle, a subterranean predator that attacks by dropping onto its prey. It can see in the dark.]],
}

--Acid spray (4d8 2 squares cone or 8d8 4 squares line Ref DC 17, immunity to acid, scent
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_DIGESTER",
	image = "tiles/lizard.png",
	display = 'B', color=colors.LIGHT_BROWN,
	desc = [[An eternally hungry dinosaur-shaped monster.]],
	specialist_desc = [[When unable to rely on its acid attack, a digester can also attack with its talon-like claws. They have patches of colouration that help them to hide in most environments.]],
	uncommon_desc = [[As well as being able to deliver its acid in a cone-shaped spray, a digester can unleash a concentrated stream of acid upon an opponent it stands next too. This acid is particularly deadly to all but the strongest opponents.]],
	common_desc = [[This incredibly fast sprinter has a deadly acid attack that can reduce an average humanoid to a pile of glop in seconds. Luckily, this acid attack has a limited range and a digester has to wait a few seconds for its acid supplies to fill up for a follow-up attack.]],
	base_desc = [[This two-legged dinosaur-like creature is a digester, a predator native to warmer climes such as equatorial forests, jungles and deserts. It can see in the dark.]],

	stats = { str=17, dex=15, con=17, int=2, wis=12, cha=10, luc=8 },
	combat = { dam= {1,8} },
	name = "digester",
	level_range = {10, nil}, exp_worth = 1800,
	rarity = 10,
	max_life = resolvers.rngavg(65,70),
	hit_die = 8,
	challenge = 6,
	infravision = 4,
	combat_natural = 5,
	skill_jump = 18,
	skill_listen = 5,
	skill_hide = 7,
	skill_spot = 5,
	movement_speed_bonus = 0.66,
}

--Fly 30 ft.; roar 10 squares fatigue Will DC 15; scent
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_DRAGONNE",
	image = "tiles/lizard.png",
	display = 'D', color=colors.LIGHT_BROWN,
	desc = [[A scaled lion.]],
	uncommon_desc = [[ Although draconic in appearance, a dragonne lacks a breath weapon and its wings are useful for only short flights. In combat, it relies on its powerful pounce and exhausting roar to take down prey.]],
	common_desc = [[Although they have a reputation for being ruthless killers, it is largely underserved. Dragonnes only attack those who threaten its territory or its lair, and far prefer goats for food over humanoids, since they can’t fight back as readily.]],
	base_desc = [[This scaled, leonine creature is a dragonne, a mix of brass dragon and lion. It can see in the dark.]],

	stats = { str=19, dex=15, con=17, int=6, wis=12, cha=12, luc=10 },
	combat = { dam= {2,6} },
	name = "dragonne",
	level_range = {10, nil}, exp_worth = 2000,
	rarity = 10,
	max_life = resolvers.rngavg(75,80),
	hit_die = 9,
	challenge = 7,
	infravision = 4,
	combat_natural = 6,
	skill_listen = 10,
	skill_spot = 10,
	movement_speed_bonus = 0.33,
}

--Burrow 10 ft.; immunity to cold, vulnerability to cold; 
--Weapon Focus, Improved Natural Attack; 1d8 cold on hit; 3 sq cone 15d6 cold Ref DC 22 half once per hour
--An explosion upon death: 12d6 cold & 8d6 physical in 10 sq ball Ref DC 22
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_FROST_WORM",
	image = "tiles/worm.png",
	display = 'w', color=colors.LIGHT_BLUE,
	desc = [[A huge bluish worm.]],
	stats = { str=26, dex=10, con=20, int=2, wis=11, cha=11, luc=10 },
	combat = { dam= {2,8} },
	name = "frost worm",
	level_range = {10, nil}, exp_worth = 3600,
	rarity = 10,
	max_life = resolvers.rngavg(145,150),
	hit_die = 14,
	challenge = 12,
	infravision = 4,
	combat_natural = 10,
	skill_hide = 3,
	skill_listen = 5,
	skill_spot = 5,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
	[Talents.T_IRON_WILL]=1
	},
	specialist_desc = [[The eggs of frost worms resemble simple oval-shaped spheres of ice, easily overlooked in the frost worm's lair. When a frost worm dies, it turns to ice and shatters, exploding over a large diameter.]],
	uncommon_desc = [[ Frost worms can produce a hypnotic trill that forces prey to stand motionless. A creature that resists this effect is immune for 24 hours.]],
	common_desc = [[Frost worms generate intense cold that damages creatures that touch it. They also can produce a breath weapon that deals cold damage.]],
	base_desc = [[This immense creature is a frost worm. It can see in the dark, is immune to cold and takes double damage from fire.]],
}

--Climb 40 ft.; scent, rend 2d4, Toughness
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_GIRALLON",
	image = "tiles/gorilla.png",
	display = 'Y', color=colors.WHITE,
	desc = [[A large gorilla covered in white fur.]],
	stats = { str=22, dex=17, con=14, int=2, wis=12, cha=7, luc=10 },
	combat = { dam= {1,4} },
	name = "girallon",
	level_range = {10, nil}, exp_worth = 1800,
	rarity = 10,
	max_life = resolvers.rngavg(55,60),
	hit_die = 14,
	challenge = 6,
	infravision = 4,
	combat_natural = 3,
	skill_climb = 8,
	skill_listen = 5,
	skill_spot = 5,
	movement_speed_bonus = 0.33,
	resolvers.talents{ [Talents.T_IRON_WILL]=1
	},
}

--Scent, trample 1d8 Ref DC 19 half; breath weapon cone 5 squares turn to stone
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_GORGON",
	image = "tiles/gorgon.png",
	display = 'q', color=colors.DARK_GRAY,
	desc = [[A large aggressive quadruped.]],
	stats = { str=21, dex=10, con=21, int=2, wis=12, cha=9, luc=10 },
	combat = { dam= {1,8} },
	name = "gorgon",
	level_range = {10, nil}, exp_worth = 2400,
	rarity = 10,
	max_life = resolvers.rngavg(80,85),
	hit_die = 8,
	challenge = 8,
	infravision = 4,
	combat_natural = 10,
	skill_listen = 8,
	skill_spot = 13,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
	[Talents.T_IRON_WILL]=1
	},
}

--scent; improved grab, rend 2d6; Cleave, Imp Bull Rush; 
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_GRAY_RENDER",
	image = "tiles/gorilla.png",
	display = 'h', color=colors.DARK_GRAY,
	desc = [[A large aggressive humanoid with long claws.]],
	stats = { str=23, dex=10, con=24, int=3, wis=12, cha=8, luc=10 },
	combat = { dam= {2,6} },
	name = "gray render",
	level_range = {10, nil}, exp_worth = 2400,
	rarity = 10,
	max_life = resolvers.rngavg(120,125),
	hit_die = 10,
	challenge = 8,
	infravision = 4,
	combat_natural = 9,
	skill_hide = 2,
	skill_spot = 9,
	skill_survival = 2,
--	resolvers.talents{ [Talents.T_POWER_ATTACK]=1 },
}

--Fly 80 ft.; pounce, rake 1d6
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_GRIFFON",
	image = "tiles/griffon.png",
	display = 'B', color=colors.GOLD,
	desc = [[A cross between a lion and an eagle.]],
	stats = { str=18, dex=15, con=16, int=5, wis=13, cha=8, luc=12 },
	combat = { dam= {2,6} },
	name = "griffon",
	level_range = {10, 25}, exp_worth = 1200,
	rarity = 15,
	max_life = resolvers.rngavg(60,65),
	hit_die = 7,
	challenge = 4,
	infravision = 4,
	combat_natural = 5,
	skill_jump = 4,
	skill_listen = 5,
	skill_spot = 9,
	resolvers.talents{ [Talents.T_IRON_WILL]=1 },
}

--Fly 100 ft.; scent
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_HIPPOGRIFF",
	image = "tiles/griffon.png",
	display = 'B', color=colors.BROWN,
	desc = [[A cross between a horse and an eagle.]],
	stats = { str=18, dex=15, con=16, int=2, wis=13, cha=8, luc=12 },
	combat = { dam= {1,4} },
	name = "hippogriff",
	level_range = {1, 25}, exp_worth = 600,
	rarity = 15,
	max_life = resolvers.rngavg(25,30),
	hit_die = 3,
	challenge = 2,
	infravision = 4,
	combat_natural = 3,
	skill_listen = 3,
	skill_spot = 7,
	movement_speed_bonus = 0.66,
	resolvers.talents{ [Talents.T_DODGE]=1 },
}

--Scent, scare Will DC 13
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_KRENSHAR",
	image = "tiles/cat.png",
	display = 'c', color=colors.WHITE,
	desc = [[A feline carnivore.]],
	specialist_desc = [[Krenshar cubs raised in captivity can be domesticated (if not truly tamed), producing fierce and loyal companions.]],
	uncommon_desc = [[The skin on a krenshar’s face is extremely flexible. A krenshar can pull this skin back, exposiring the skull beneath to frighten prey.]],
	common_desc = [[Krenshars are social creatures that hunt in small packs or prides. They possess a sharp cunning that sometimes seems eerily intelligent.]],
	base_desc = [[This strange, catlike creature is a krenshar. It can see in the dark.]],

	stats = { str=11, dex=14, con=11, int=6, wis=13, cha=8, luc=12 },
	name = "krenshar",
	level_range = {1, 25}, exp_worth = 300,
	rarity = 15,
	max_life = resolvers.rngavg(10,15),
	hit_die = 2,
	challenge = 1,
	infravision = 4,
	combat_natural = 3,
	skill_hide = 2,
	skill_jump = 9,
	skill_listen = 2,
	skill_movesilently = 4,
	movement_speed_bonus = 0.33,
}

--Wisdom drain 1d4; Spring Attack
--Spell-likes: At will—disguise self, ventriloquism; 3/day—charm monster (DC 15), major image (DC 14), mirror image, suggestion (DC 14); 1/day—deep slumber (DC 14). 
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_LAMIA",
	image = "tiles/cat.png",
	display = 'c', color=colors.DARK_YELLOW,
	desc = [[A feline creature.]],
	stats = { str=18, dex=15, con=12, int=13, wis=15, cha=12, luc=12 },
	combat = { dam= {1,4} },
	name = "lamia",
	level_range = {5, 25}, exp_worth = 1800,
	rarity = 15,
	max_life = resolvers.rngavg(55,60),
	hit_die = 9,
	challenge = 6,
	infravision = 4,
	combat_natural = 6,
	skill_bluff = 13,
	skill_concentration = 9,
	skill_diplomacy = 2,
	skill_hide = 8,
	skill_intimidate = 2,
	skill_spot = 9,
	alignment = "chaotic evil",
	movement_speed_bonus = 0.88,
	resolvers.talents{ [Talents.T_DODGE]=1,
	[Talents.T_MOBILITY]=1,
	[Talents.T_IRON_WILL]=1,
	},
	specialist_desc = [[Lamias can employ charm monster, deep slumber, disguise self, major image, mirror image, suggestion, and ventriloquism as spell-like abilities.]],
	uncommon_desc = [[The touch of a lamia drains Wisdom from its victims. They try to use this power early on to make foes more susceptible to mind-affecting effects, such as charm monster and suggestion.]],
	common_desc = [[Lamias are wicked and cruel beings that exist just to cause misery in others. They set up elaborate traps and ambushes to lure in potential victims.]],
	base_desc = [[This centaurlike cross between a human and a lion is a lamia. It can see in the dark.]],
}

--Fly 60 ft.; magic circle against evil; pounce, rake 1d6, spells as Clr7; Blind-Fight
--Spell-likes: 2/day—greater invisibility (self only); 1/day—dimension door. 
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_LAMMASU",
	image = "tiles/cat.png",
	display = 'c', color=colors.GOLD,
	desc = [[A creature with a lion's body and a humanoid head with an impressive headdress.]],
	stats = { str=23, dex=12, con=17, int=16, wis=17, cha=14, luc=12 },
	name = "lammasu",
	level_range = {10, 25}, exp_worth = 2400,
	rarity = 15,
	max_life = resolvers.rngavg(55,60),
	hit_die = 7,
	challenge = 8,
	infravision = 4,
	combat_natural = 9,
	skill_concentration = 10,
	skill_diplomacy = 2,
	skill_knowledge = 10,
	skill_listen = 10,
	skill_sensemotive = 10,
	skill_spot = 12,
	alignment = "lawful good",
	resolvers.talents{ [Talents.T_IRON_WILL]=1 },
}

--Fly 50 ft; scent; spikes 1d4 range 30 ft.; Weapon Focus
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_MANTICORE",
	image = "tiles/gorgon.png",
	display = 'B', color=colors.BLACK,
	desc = [[A manticore.]],
	stats = { str=20, dex=15, con=19, int=7, wis=12, cha=9, luc=8 },
	combat = { dam= {2,4} },
	name = "manticore",
	level_range = {5, 25}, exp_worth = 1500,
	rarity = 15,
	max_life = resolvers.rngavg(55,60),
	hit_die = 6,
	challenge = 5,
	infravision = 4,
	combat_natural = 5,
	skill_listen = 4,
	skill_spot = 8,
	alignment = "lawful evil",
}

--Fly 70 ft; 
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_OWL_GIANT",
	image = "tiles/owl.png",
	display = 'b', color=colors.BROWN,
	desc = [[A giant owl.]],
	uncommon_desc = [[Giant owl young can be trained to accept a rider. Giant owl eggs thus demand exorbitant prices on the open market.]],
	common_desc = [[A giant owl can see extremely well by moonlight. They speak Sylvan and Common.]],
	base_desc = [[This massive night hunter is a giant owl, a noble creature as intelligent as a human. It can see in the dark.]],

	stats = { str=18, dex=17, con=12, int=10, wis=14, cha=10, luc=12 },
	name = "giant owl",
	level_range = {5, 25}, exp_worth = 900,
	rarity = 15,
	max_life = resolvers.rngavg(25,30),
	hit_die = 4,
	challenge = 3,
	infravision = 2,
	combat_natural = 2,
	skill_knowledge = 2,
	skill_listen = 15,
	skill_movesilently = 5,
	skill_spot = 8,
	movement_speed_bonus = -0.88,
	alignment = "neutral good",
	resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Scent, improved grab
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_OWLBEAR",
	image = "tiles/owlbear.png",
	display = 'B', color=colors.LIGHT_BROWN,
	desc = [[A giant owlbear.]],
	stats = { str=21, dex=12, con=21, int=2, wis=12, cha=10, luc=10 },
	name = "owlbear",
	level_range = {5, 25}, exp_worth = 1200,
	rarity = 15,
	max_life = resolvers.rngavg(50,55),
	hit_die = 5,
	challenge = 4,
	infravision = 2,
	combat_natural = 4,
	skill_listen = 7,
	skill_spot = 7,
	resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Scent
--Spell-likes: At will—detect good and detect evil within a 60-foot radius.
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_PEGASUS",
	image = "tiles/pegasus.png",
	display = 'q', color=colors.WHITE,
	desc = [[A beautiful winged horse.]],
	stats = { str=18, dex=15, con=16, int=10, wis=13, cha=13, luc=12 },
	name = "pegasus",
	level_range = {5, 25}, exp_worth = 900,
	rarity = 15,
	max_life = resolvers.rngavg(30,35),
	hit_die = 4,
	challenge = 3,
	infravision = 4,
	combat_natural = 2,
	skill_diplomacy = 2,
	skill_listen = 7,
	skill_sensemotive = 7,
	skill_spot = 7,
	alignment = "chaotic good",
	resolvers.talents{ [Talents.T_IRON_WILL]=1 },
}

--Climb 20 ft; Poison pri & sec 1d8 CON Fort DC 17, ethereal jaunt
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_PHASE_SPIDER",
	image = "tiles/spider.png",
	display = 's', color=colors.GREEN,
	desc = [[A spider with green markings.]],
	uncommon_desc = [[A phase spider can shift into or out of the Ethereal Plane without warning. Its usual tactic is to suddenly appear on the Material Plane, bite a victim, and then immediately retreat to the Ethereal Plane, where it waits for the creature to die before returning to feed.]],
	common_desc = [[A phase spider is fairly intelligent and its bite delivers a deadly venom.]],
	base_desc = [[Judging by its markings, this monstrous arachnid is a phase spider. It can see in the dark.]],

	stats = { str=17, dex=17, con=16, int=7, wis=13, cha=10, luc=12 },
	name = "phase spider",
	level_range = {5, 25}, exp_worth = 1500,
	rarity = 15,
	max_life = resolvers.rngavg(40,45),
	hit_die = 5,
	challenge = 5,
	infravision = 4,
	combat_natural = 2,
	skill_climb = 8,
	skill_movesilently = 8,
	skill_spot = 3,
	movement_speed_bonus = 0.33,
}

--Burrow 20 ft. swim 10 ft.; improved grab, swallow whole, tremorsense 4 squares
--Poison pri 1d6 STR sec 2d6 STR Fort DC 25
--Cleave, Imp Bull Rush, Awesome Blow, Weapon Focus
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_PURPLE_WORM",
	image = "tiles/worm_purple.png",
	display = 'w', color=colors.RED,
	desc = [[A giant purple worm.]],
	stats = { str=17, dex=17, con=16, int=7, wis=13, cha=10, luc=12 },
	combat = { dam= {2,8} },
	name = "purple worm",
	level_range = {15, nil}, exp_worth = 1500,
	rarity = 25,
	max_life = resolvers.rngavg(200,205),
	hit_die = 16,
	challenge = 12,
	infravision = 4,
	combat_natural = 11,
	skill_listen = 19,
	skill_swim = 8,
	movement_speed_bonus = -0.33,
--	resolvers.talents{ [Talents.T_POWER_ATTACK]=1 },
}

--Trample 2d6, vorpal tusks; fast healing 10, scent
--Awesome Blow, Diehard, Endurance, Imp Bull Rush
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_RAZOR_BOAR",
	image = "tiles/boar.png",
	display = 'B', color=colors.BROWN,
	desc = [[A boar with razor sharp tusks.]],
	stats = { str=27, dex=13, con=17, int=2, wis=14, cha=9, luc=12 },
	name = "razor boar",
	level_range = {5, 25}, exp_worth = 3000,
	rarity = 15,
	max_life = resolvers.rngavg(125,130),
	hit_die = 10,
	challenge = 5,
	infravision = 4,
	combat_natural = 16,
	combat_dr = 5,
	spell_resistance = 21,
	skill_listen = 6,
	skill_survival = 6,
	skill_spot = 6,
	movement_speed_bonus = 0.66,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
--	[Talents.T_POWER_ATTACK]=1 
	},
}

--Burrow 20 ft; swallow whole; tremorsense 5 squares; heat - 8d6 fire dam 1 sq radius
--Awesome Blow, Imp Bull Rush
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_REMORHAZ",
	image = "tiles/remorhaz.png",
	display = 'B', color=colors.LIGHT_BLUE,
	desc = [[A frost worm with a glowing tail end.]],
	stats = { str=26, dex=13, con=21, int=5, wis=12, cha=10, luc=12 },
	combat = { dam= {2,8} },
	name = "remorhaz",
	level_range = {10, nil}, exp_worth = 3000,
	rarity = 25,
	max_life = resolvers.rngavg(70,75),
	hit_die = 7,
	challenge = 7,
	infravision = 4,
	combat_natural = 9,
	skill_listen = 7,
	skill_spot = 7,
--	resolvers.talents{ [Talents.T_POWER_ATTACK]=1 },
	uncommon_desc = [[Remorhazes subsist on frost giants, polar bears, elk, and other large arctic creatures. Giants sometimes train or entice remorhazes to guard their lairs.]],
	common_desc = [[Remorhazes can swallow their prey whole and can sense the presence of creatures due to the vibrations they make on the ground. When enraged, the remorhaz produces an incredible heat that chars flesh and can even melt weapons.]],
	base_desc = [[This terrifying blend of insect and reptile is a remorhaz. It can see in the dark.]],
}

--Strand range 5 squares - drag 1 sq closer each round; 2d8 STR damage Fort DC 18; Weapon Focus
--Immunity to electricity, vulnerability to fire
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_ROPER",
	image = "tiles/worm.png",
	display = 'B', color=colors.GRAY,
	desc = [[A gray stone with strands.]],
	stats = { str=19, dex=13, con=17, int=12, wis=16, cha=12, luc=12 },
	combat = { dam= {2,6} },
	name = "roper",
	level_range = {15, nil}, exp_worth = 3600,
	rarity = 25,
	max_life = resolvers.rngavg(80,85),
	hit_die = 10,
	challenge = 12,
	spell_resistance = 30,
	infravision = 4,
	combat_natural = 13,
	skill_climb = 8,
	skill_hide = 9,
	skill_listen = 12,
	skill_spot = 12,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
	[Talents.T_IRON_WILL]=1
	},
	specialist_desc = [[The strands of a roper can sap an opponent's strength. These strands have an incredible reach and grow back if severed.]],
	uncommon_desc = [[Both the shape and coloration of ropers make them extremely difficult to locate in their natural environment.]],
	common_desc = [[Ropers are remarkably intelligent, if evil, creatures. They are immune to electricity, resistant to cold, and vulnerable to fire.]],
	base_desc = [[This curious underground dweller is a roper. It can see in the dark.]],
}

--Swim 40 ft., hold breath (6xCON), scent, rend 2d6
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_SEA_CAT",
	image = "tiles/cat.png",
	display = 'c', color=colors.LIGHT_BLUE,
	desc = [[A sea lion with strong paws.]],
	uncommon_desc = [[A sea cat tries to strike its victim with both claws, then rends the creature’s flesh.]],
	common_desc = [[A sea cat cannot breathe underwater, but it can hold its breath for more than ten minutes.]],
	base_desc = [[This creature is a sea cat, a vicious aquatic predator that combines the body of a sea lion with the head and forepaws of a great cat. It can see in the dark.]],

	stats = { str=19, dex=12, con=17, int=2, wis=13, cha=10, luc=12 },
	name = "sea cat",
	level_range = {5, nil}, exp_worth = 1200,
	rarity = 15,
	max_life = resolvers.rngavg(50,55),
	hit_die = 6,
	challenge = 4,
	infravision = 4,
	combat_natural = 7,
	skill_listen = 7,
	skill_swim = 8,
	skill_spot = 6,
	movement_speed_bonus = -0.88,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
	[Talents.T_IRON_WILL]=1 
	},
}

--Fly 40 ft., blood drain 1d4 CON when grappling
--TOO SMALL to drop corpse
newEntity{ 
	define_as = "BASE_NPC_STIRGE",
	type = "magical beast",
	image = "tiles/stirge.png",
	display = 'w', color=colors.LIGHT_RED,
	body = { INVEN = 10 },
	desc = [[A tiny flying creature.]],
	uncommon_desc = [[If a victim dies before a stirge is satiated, it detaches and seeks a new target.]],
	common_desc = [[Stirges are little threats singly, but they travel in large colonies. The long proboscis of the stirge allows it to attach to its victim, making it extremely difficult to remove. Stirges drain blood from their victims.]],
	base_desc = [[This strange flying creature is a stirge. It can see in the dark.]],

	ai = "dumb_talented_simple", ai_state = { talent_in=3, },
	stats = { str=3, dex=19, con=10, int=1, wis=12, cha=6, luc=10 },
	combat = { dam= {1,1} },
	name = "stirge",
	level_range = {1, nil}, exp_worth = 150,
	rarity = 15,
	max_life = resolvers.rngavg(4,6),
	hit_die = 6,
	challenge = 1/2,
	infravision = 4,
	skill_hide = 10,
	skill_listen = 3,
	skill_spot = 3,
	movement_speed_bonus = -0.88,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
	[Talents.T_FINESSE]=1 
	},
	alignment = "neutral",
}

--Fly 60 ft; scent; freedom of movement; implant, poison pri none sec paralysis 1d8+5 weeks
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_SPIDER_EATER",
	image = "tiles/eagle.png",
	display = 'b', color=colors.LIGHT_RED,
	desc = [[A boar with razor sharp tusks.]],
	stats = { str=21, dex=13, con=21, int=2, wis=12, cha=10, luc=10 },
	combat = { dam= {1,8} },
	name = "spider eater",
	level_range = {5, nil}, exp_worth = 1500,
	rarity = 15,
	max_life = resolvers.rngavg(40,45),
	hit_die = 4,
	challenge = 5,
	infravision = 4,
	combat_natural = 3,
	skill_listen = 9,
	skill_spot = 10,
	resolvers.talents{ [Talents.T_ALERTNESS]=1,
	[Talents.T_DODGE]=1 
	},
}

--Magic circle against evil; immunity to poison, charm, and compulsion; scent, wild empathy
--Spell-likes: detect evil at will, 1/day greater teleport, cure moderate wounds; 3/day cure light wounds
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_UNICORN",
	image = "tiles/newtiles/unicorn.png",
	display = 'b', color=colors.LIGHT_RED,
	desc = [[A beautiful unicorn.]],
	stats = { str=20, dex=17, con=21, int=10, wis=21, cha=24, luc=18 },
	combat = { dam= {1,8} },
	name = "unicorn",
	level_range = {5, nil}, exp_worth = 900,
	rarity = 15,
	max_life = resolvers.rngavg(40,45),
	hit_die = 4,
	challenge = 3,
	infravision = 4,
	combat_natural = 5,
	skill_jump = 16,
	skill_listen = 5,
	skill_movesilently = 5,
	skill_spot = 5,
	skill_survival = 2,
	movement_speed_bonus = 0.88,
	alignment = "chaotic good",
	resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--1d6 cold damage, scent, trip; breath weapon 2 sq cone cooldown 2 4d6 cold Ref DC 16 half
--Immunity to cold, vulnerability to fire
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_WINTER_WOLF",
	image = "tiles/wolf.png",
	display = 'w', color=colors.LIGHT_BLUE,
	desc = [[A white-blue wolf.]],
	uncommon_desc = [[Winter wolves are so named because their bite produces freezing cold. They have a breath weapon -- a cone of cold. Winter wolves are immune to cold and vulnerable to fire.]],
	common_desc = [[Like regular wolves, winter wolves can make trip attacks after a successful bite attack. They are remarkably intelligent and can speak Common and Giant.]],
	base_desc = [[This is a winter wolf. It can see in the dark. It is immune to cold but takes double damage from fire.]],

	stats = { str=18, dex=13, con=16, int=9, wis=13, cha=10, luc=10 },
	combat = { dam= {1,8} },
	name = "winter wolf",
	level_range = {5, nil}, exp_worth = 1500,
	rarity = 15,
	max_life = resolvers.rngavg(50,55),
	hit_die = 6,
	challenge = 5,
	infravision = 4,
	combat_natural = 6,
	skill_listen = 5,
	skill_movesilently = 6,
	skill_spot = 5,
	movement_speed_bonus = 0.66,
	alignment = "neutral evil",
	resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Trip, scent
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_WORG",
	image = "tiles/wolf.png",
	display = 'w', color=colors.LIGHT_BROWN,
	desc = [[A large brownish-gray wolf.]],
	stats = { str=17, dex=15, con=15, int=6, wis=14, cha=10, luc=10 },
	combat = { dam= {1,6} },
	name = "worg",
	level_range = {5, nil}, exp_worth = 600,
	rarity = 15,
	max_life = resolvers.rngavg(30,35),
	hit_die = 4,
	challenge = 2,
	infravision = 4,
	combat_natural = 2,
	skill_hide = 2,
	skill_listen = 4,
	skill_movesilently = 4,
	skill_spot = 4,
	movement_speed_bonus = 0.66,
	alignment = "neutral evil",
	resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Fly 60 ft;  Multiattack, Snatch; Blind (blindsight 10 sq)
--Sonic lance 6d6 hit sonic 5 sq range; explosion 2d6 physical rad 1 sq
--vulnerability to sonic, immune to gaze attacks, visual effects, illusions
newEntity{ base = "BASE_NPC_MAGBEAST",
	define_as = "BASE_NPC_YRTHAK",
	image = "tiles/UT/gargoyle.png",
	display = 'Y', color=colors.LIGHT_BROWN,
	desc = [[A large blind gargoyle with a long tongue.]],
	uncommon_desc = [[Yrthaks can focus their sonic power at the ground, a wall, or other large object, creating a massive explosion that causes a shower of stones and debris.]],
	common_desc = [[Yrthaks are blind, but sense their environment through other means. They are immune to gaze attacks, illusions, and other effects that rely on sight. Yrthaks can produce a powerful blast of energy that deals sonic damage.]],
	base_desc = [[This strange, eyeless reptilian creature is an yrthak.]],

	stats = { str=20, dex=14, con=17, int=7, wis=13, cha=11, luc=10 },
	combat = { dam= {2,8} },
	name = "yrthak",
	level_range = {10, nil}, exp_worth = 2700,
	rarity = 25,
	max_life = resolvers.rngavg(100,105),
	hit_die = 12,
	challenge = 9,
	combat_natural = 6,
	skill_listen = 11,
	skill_movesilently = 8,
	movement_speed_bonus = -0.33,
	alignment = "neutral",
}