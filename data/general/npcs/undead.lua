--Veins of the Earth
--Zireael

--Undead don't drop corpses

local Talents = require("engine.interface.ActorTalents")

local undead_desc = "It is immune to critical hits, poison, sleep effects, paralysis, stunning and disease. It is immune to mind-affecting effects such as charms, compulsions, phantasms."

--incorporeal, 1d4 Wisdom drain, hypnotism DC 16 in 4 tiles
newEntity{
        define_as = "BASE_NPC_ALLIP",
        type = "undead", subtype = "allip",
        image = "tiles/allip.png",
        display = 'N', color=colors.BLACK,
        body = { INVEN = 10 },
        desc = [[An incorporeal undead.]],
        uncommon_desc = [[It is dangerous to try to connect metally with an allip, be that through thought detection, mind control or telepathy as an allip's mind is so tortured as to damage any other mind that touches it.]],
        common_desc = [[Though it can cause no physical harm, an allip's touch can drain away a victim's willpower. Also, an allip babbles incoherently to itself, and those who hear this babble can become hypnotised. Allips cannot, however, speak intelligibly.]],
        base_desc = "This creature is an allip, the spectral remains of someone driven to suicide by madness"..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=1, dex=12, con=1, int=11, wis=11, cha=18, luc=6 },
        combat = { dam= {2,6} },
        name = "allip",
        level_range = {5, 15}, exp_worth = 900,
        rarity = 10,
        max_life = resolvers.rngavg(35,40),
        hit_die = 3,
        challenge = 5,
        infravision = 4,
        combat_protection = 4,
        skill_hide = 7,
        skill_intimidate = 3,
        skill_jump = 17,
        skill_listen = 6,
        skill_search = 3,
        skill_spot = 6,
}

--death gaze 3 squares Fort DC 15; immunity to electricity
newEntity{
        define_as = "BASE_NPC_BODAK",
        type = "undead",
        image = "tiles/bodak.png",
        display = 'U', color=colors.DARK_GRAY,
        body = { INVEN = 10 },
        desc = [[A thin, emaciated creature.]],
        uncommon_desc = [[Though resilient to physical blows, bodaks are vulnerable to cold iron weapons. They also loathe sunlight, for its merest touch burns their impure flesh.]],
        common_desc = [[These creatures are not particularly dangerous in a physical sense, but are deadly nonetheless, due to a gaze attack they can use to slay living creatures instantly. They also have immunity to electrical attacks and resistance to acid and fire. Bodaks retain fleeting memories of their previous lives and can typically communicate in any language they once knew.]],
        base_desc = "This creature is a bodak, the undead remnant of a humanoid destroyed by the touch of absolute evil."..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=13, dex=15, con=1, int=6, wis=12, cha=12, luc=6 },
        combat = { dam= {1,8} },
        name = "bodak",
        level_range = {10, nil}, exp_worth = 2400,
        rarity = 10,
        max_life = resolvers.rngavg(55,60),
        hit_die = 9,
        challenge = 8,
        infravision = 4,
        combat_natural = 8,
        skill_listen = 10,
        skill_movesilently = 8,
        skill_spot = 10,
        resists = {
                [DamageType.ACID] = 10,
                [DamageType.COLD] = 10,
        },
}

--Energy drain, trap essence, spell deflection (nothing or placing the spell-likes on cooldown) [banishment, chaos hammer, confusion, crushing despair, detect thoughts, dispel evil, dominate person, fear, geas/quest, holy word, hypnotism, imprisonment, magic jar, maze, suggestion, trap the soul, or any form of charm or compulsion.]
--Spell-likes:: confusion (DC 17), control undead (DC 20), ghoul touch (DC 15), lesser planar ally, ray of enfeeblement, spectral hand, suggestion (DC 16), true seeing. 
newEntity{
        define_as = "BASE_NPC_DEVOURER",
        type = "undead",
        image = "tiles/devourer.png",
        display = 'U', color=colors.LIGHT_BLUE,
        body = { INVEN = 10 },
        desc = [[A terrible bony creature.]],
        specialist_desc = [[A devourer's touch drains the life energy of its victim, inflicting a negative level with ever touch. It can even do this through the use of its spectral hand spell-like ability. Devourers are also resilient to magical attacks.
        As well as providing sustenance to the devourer, a trapped essence can also be used to power an array of spell-like abilities that the devourer has access to. Using the essence in this way diminishes its power and can eventually destroy it. As well as this, the devourer can also use the trapped essence to be the victim of certain spells that make it past its spell resistance, including all charms and compulsions, making these spells effectively useless against these creatures.]],
        uncommon_desc = [[The devourer is named for its ability to consume an enemy's life essence. The devourer reaches out and touches its victim, that is slain instantly if their body fails to resist the devourer's horrific magic. The slain creature's essence is trapped within the figure in the devourer's ribs which takes on the features of the victim. Only the most powerful magics can free the victim, though destroying the devourer has the same effect. Luckily, a devourer can only hold a single essence at a time.]],
        common_desc = [[This creature is a devourer, a horrific undead monster that can typically be found stalking prey on the Ethereal and Astral Planes. The tiny figure in its rib cage is the trapped essence of a slain opponent upon which it feeds to sustain its unnatural life.]],
        base_desc = "Though uncertain what this creature is, you are positive it is one of the undead and not native to the Material Plane. "..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=28, dex=10, con=1, int=16, wis=16, cha=17, luc=6 },
        combat = { dam= {1,6} },
        name = "devourer",
        level_range = {10, nil}, exp_worth = 2400,
        rarity = 20,
        max_life = resolvers.rngavg(75,80),
        hit_die = 12,
        challenge = 11,
        spell_resistance = 21,
        infravision = 4,
        combat_natural = 14,
        skill_climb = 15,
        skill_concentration = 18,
        skill_diplomacy = 2,
        skill_jump = 15,
        skill_listen = 15,
        skill_movesilently = 15,
        skill_search = 7,
        skill_spot = 15,
}

--Paralysis on hit DC 15 1d4 rounds; ghoul fever; AL CE
newEntity{
        define_as = "BASE_NPC_GHOUL",
        type = "undead",
        image = "tiles/ghoul.png",
        display = 'U', color=colors.GRAY,
        body = { INVEN = 10 },
        desc = [[A shuffling bloated creature.]],
        specialist_desc = [[There are other variations of ghouls, including the aquatic lacedon and the more powerful ghast.]],
        uncommon_desc = [[The bite or touch of a ghoul causes paralysis in its victim.]],
        common_desc = [[The bite of a ghoul infects the victim with a horrible disease called ghoul fever. Those who die from this disease rise again to become a ghoul themselves.]],
        base_desc = "Ghouls are undead who feast upon corpses and carrion. They are tough and intelligent creatures."..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=13, dex=15, con=1, int=13, wis=14, cha=12, luc=8 },
        combat = { dam= {1,6} },
        skill_balance = 4,
        skill_climb = 4,
        skill_hide = 4,
        skill_jump = 4,
        skill_movesilently = 4,
        skill_spot = 5,
}

newEntity{
        base = "BASE_NPC_GHOUL",
        name = "ghoul", color=colors.WHITE,
        level_range = {1, 4}, exp_worth = 300,
        rarity = 10,
        max_life = resolvers.rngavg(10,15),
        hit_die = 2,
        challenge = 1,

}

--Swim 30 ft.
newEntity{
        base = "BASE_NPC_GHOUL",
        image = "tiles/lacedon.png",
        name = "lacedon", color=colors.BLUE,
        level_range = {1, 4}, exp_worth = 300,
        rarity = 15,
        max_life = resolvers.rngavg(10,15),
        hit_die = 2,
        challenge = 1,
}

--Stench 2 squares DC 15 Fort; Toughness
newEntity{
        base = "BASE_NPC_GHAST",
        image = "tiles/ghast.png",
        name = "ghast", color=colors.DARK_BROWN,
        level_range = {1, 25}, exp_worth = 900,
        rarity = 10,
        max_life = resolvers.rngavg(25,30),
        hit_die = 4,
        challenge = 3,
        stats = { str=17, dex=17, con=1, int=13, wis=14, cha=16, luc=8 },
        combat = { dam= {1,8} },
}

--Improved grab, paralysing touch Fort DC 17 1d4x10 rounds
newEntity{
        define_as = "BASE_NPC_MOHRG",
        type = "undead",
        image = "tiles/UT/mohrg.png",
        display = 'U', color=colors.BLACK,
        body = { INVEN = 10 },
        desc = [[A terrible undead creature.]],

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=21, dex=19, con=1, int=11, wis=10, cha=10, luc=6 },
        combat = { dam= {1,6} },
        name = "mohrg",
        level_range = {10, nil}, exp_worth = 2400,
        rarity = 20,
        max_life = resolvers.rngavg(90,95),
        hit_die = 14,
        challenge = 8,
        infravision = 4,
        combat_natural = 9,
        skill_climb = 9,
        skill_hide = 17,
        skill_listen = 11,
        skill_movesilently = 17,
        skill_swim = 3,
        skill_spot = 15,
        alignment = "chaotic evil",
        resolvers.talents{ [Talents.T_DODGE]=1,
        [Talents.T_MOBILITY]=1,
        [Talents.T_ALERTNESS]=1 },
}

--Mummy rot Fort DC 16 1d6 CON & 1d6 CHA; fear for 1d4 rounds in LOS Will DC 16
--Toughness
newEntity{
        define_as = "BASE_NPC_MUMMY",
        type = "undead",
        image = "tiles/mummy.png",
        display = 'U', color=colors.GOLD,
        body = { INVEN = 10 },
        desc = [[An undead mummy swathed in bandages.]],
        specialist_desc = [[The touch of a mummy inflicts a horrible disease known as mummy rot. This incredibly fast-acting disease is not natural and is cured only by casting break enchantment or remove curse. This disease is highly resistant, though not immune, to healing spells. Sometimes, powerful individuals are preserved as greater mummies, retaining some of their skills and abilities that they had in life.]],
        uncommon_desc = [[The mere sight of a mummy invokes tremendous despair, which can paralyze its victims. Mummies are resistant to most weapons, but they are vulnerable to fire damage.]],
        common_desc = [[Mummies are used as guardians for great tombs or temple complexes, hunting down and destroying grave robbers. They never retreat.]],
        base_desc = "This withered and desiccated corpse, which is wrapped in funerary bandages, is a mummy. "..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=24, dex=10, con=1, int=6, wis=14, cha=15, luc=6 },
        combat = { dam= {1,6} },
        name = "mummy",
        level_range = {5, nil}, exp_worth = 1500,
        rarity = 15,
        max_life = resolvers.rngavg(50,55),
        hit_die = 8,
        challenge = 5,
        infravision = 4,
        combat_natural = 10,
        combat_dr = 5,
        skill_hide = 5,
        skill_listen = 6,
        skill_movesilently = 7,
        skill_spot = 6,
--        movement_speed_bonus = -0.33,
        movement_speed = 0.66,
        alignment = "lawful evil",
        resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Incorporeal; 1d6 STR damage; +2 turn resistance
newEntity{
        define_as = "BASE_NPC_SHADOW",
        type = "undead", subtype = "shadow",
        image = "tiles/shadow.png",
        display = 'N', color=colors.WHITE,
        body = { INVEN = 10 },
        desc = [[An incorporeal shadow.]],

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=1, dex=14, con=1, int=6, wis=12, cha=13, luc=6 },
        combat = { dam= {1,1} },
        name = "shadow",
        level_range = {5, 15}, exp_worth = 900,
        rarity = 10,
        max_life = resolvers.rngavg(15,20),
        hit_die = 3,
        challenge = 3,
        infravision = 4,
        combat_protection = 1,
        skill_hide = 6,
        skill_listen = 6,
        skill_search = 3,
        skill_spot = 6,
        alignment = "chaotic evil",
        resolvers.talents{ [Talents.T_ALERTNESS]=1,
        [Talents.T_DODGE]=1 
        },
}

--1d8 STR damage
newEntity{
        base = "BASE_NPC_SHADOW",
        stats = { str=1, dex=15, con=1, int=6, wis=12, cha=14, luc=6 },
        name = "greater shadow",
        level_range = {10, nil}, exp_worth = 2500,
        rarity = 20,
        max_life = resolvers.rngavg(55,60),
        hit_die = 9,
        challenge = 8,
        combat_protection = 2,
        skill_hide = 11,
        skill_listen = 8,
        skill_search = 5,
        skill_spot = 8,
        resolvers.talents{ [Talents.T_ALERTNESS]=1,
        [Talents.T_DODGE]=1,
        [Talents.T_MOBILITY]=1
        },
}

--Blind-Fight; energy drain Fort DC 14
newEntity{
        define_as = "BASE_NPC_WIGHT",
        type = "undead", subtype = "wight",
        image = "tiles/wight.png",
        display = 'U', color=colors.BLUE,
        body = { INVEN = 10 },
        desc = [[A twisted shadow of a once-living creature.]],
        uncommon_desc = [[Although undead, wights are intelligent and can even speak.]],
        common_desc = [[The mere touch of a wight drains energy from living creatures. A humanoid slain by a wight becomes one themselves soon after, enslaved to the wight that spawned it. Wights are incredibly stealthy and easily can sneak up on most creatures.]],
        base_desc = "This walking corpse with malevolently burning eyes is a wight. "..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=12, dex=12, con=1, int=11, wis=13, cha=15, luc=6 },
        combat = { dam= {1,4} },
        name = "wight",
        level_range = {5, nil}, exp_worth = 900,
        rarity = 10,
        max_life = resolvers.rngavg(25,30),
        hit_die = 4,
        challenge = 3,
        infravision = 4,
        combat_natural = 4,
        skill_hide = 7,
        skill_listen = 9,
        skill_movesilently = 15,
        skill_spot = 9,
        alignment = "lawful evil",
        resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Fly 60 ft.; CON drain ; +2 turn res; unnatural aura; Blind-Fight feat
newEntity{
        define_as = "BASE_NPC_WRAITH",
        type = "undead", subtype = "wraith",
        image = "tiles/wraith.png",
        display = 'N', color=colors.YELLOW,
        body = { INVEN = 10 },
        desc = [[An incorporeal wraith.]],
        specialist_desc = [[Wraiths are powerless in sunlight and flee from it. When exposed to sunlight, they cannot attack and can barely move. Larger and far more powerful versions, called dread wraiths, are sometimes seen.]],
        uncommon_desc = [[The mere touch of a wraith drains the target's Constitution, granting the wraith additional unlife. A humanoid slain by a wraith becomes one itself soon after death. Wraiths are resistant to turning attempts.]],
        common_desc = [[Animals balk at the presence of a wraith and flee if they come within 30 feet of one. They are highly intelligent and speak both Common and Infernal.]],
        base_desc = "This sinister incorporeal creature is a wraith. "..undead_desc.."",

        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=1, dex=16, con=1, int=14, wis=14, cha=15, luc=6 },
        combat = { dam= {1,4} },
        name = "wraith",
        level_range = {5, nil}, exp_worth = 1500,
        rarity = 15,
        max_life = resolvers.rngavg(30,35),
        hit_die = 5,
        challenge = 5,
        infravision = 4,
        combat_protection = 2,
        skill_diplomacy = 2,
        skill_hide = 8,
        skill_intimidate = 8,
        skill_listen = 10,
        skill_search = 8,
        skill_sensemotive = 6,
        skill_spot = 10,
        alignment = "lawful evil",
        resolvers.talents{ [Talents.T_ALERTNESS]=1 },
}

--Blind-Fight, Spring Attack
newEntity {
        base = "BASE_NPC_WRAITH",
        stats = { str=1, dex=28, con=1, int=17, wis=18, cha=24, luc=6 },
        combat = { dam= {2,6} },
        name = "dread wraith",
        level_range = {10, nil}, exp_worth = 3300,
        max_life = resolvers.rngavg(100,105),
        hit_die = 16,
        challenge = 11,
        combat_protection = 6,
        skill_hide = 15,
        skill_intimidate = 20,
        skill_knowledge = 19,
        skill_listen = 21,
        skill_search = 19,
        skill_sensemotive = 19,
        skill_spot = 21,
        resolvers.talents{ [Talents.T_DODGE]=1,
        [Talents.T_MOBILITY]=1
        },
}


--immunity to cold
--Summon undead  The undead arrive in 1d10 rounds and serve for 1 hour
--Spell-likes: At will—contagion (DC 18), deeper darkness, detect magic, greater dispel magic, haste, see invisibility, and unholy blight (DC 18); 
newEntity{
        define_as = "BASE_NPC_NIGHTSHADE",
        type = "undead",
        image = "tiles/nightshade.png",
        display = 'U', color=colors.DARK_BLUE,
        body = { INVEN = 10 },
        ai = "dumb_talented_simple", ai_state = { talent_in=3, },
        stats = { str=48, dex=10, con=1, int=20, wis=20, cha=18, luc=6 },
        combat = { dam= {4,6} },
        rarity = 35,
        level_range = {20, nil},
        infravision = 4,
        combat_dr = 15,
        skill_diplomacy = 2,
        alignment = "chaotic evil",
}

--Burrow 60 ft; tremorsense 6 squares; 
--Poison pri & sec 2d6 STR Fort DC 22; improved grab; swallow whole, energy drain; Blind-Fight, Imp Crit x2
-- 9-16 shadows, 3-6 greater shadows, or 2-4 dread wraiths.
--Spell-likes: 3/day—confusion (DC 18), hold monster (DC 19), invisibility; 1/day—cone of cold (DC 19), finger of death (DC 21), plane shift (DC 21). 
newEntity{
        define_as = "BASE_NPC_NIGHTSHADE",
        color=colors.DARK_BLUE,
        desc = [[An undead horror the color of night with a stinging tail.]],
        name = "nightcrawler",
        exp_worth = 5500,        
        max_life = resolvers.rngavg(210,215),
        hit_die = 25,
        challenge = 18,
        combat = { dam= {2,6} },
        combat_natural = 25,
        spell_resistance = 31,
        skill_concentration = 25,
        skill_hide = 16,
        skill_knowledge = 25,
        skill_movesilently = 28,
        skill_search = 27,
        skill_sensemotive = 17,
        skill_spellcraft = 30,
        skill_spot = 27,
        resolvers.talents{ [Talents.T_IRON_WILL]=1,
--        [Talents.T_POWER_ATTACK]=1,
        [Talents.T_COMBAT_CASTING]=1,
        },
}

--Fly 20 ft; immunity to cold; fear 4 squares Will DC 24
--Cleave, Imp Disarm, Quicken Spell-like (unholy blight)
--Summon undead -  7-12 shadows, 2-5 greater shadows, or 1-2 dread wraiths.
--Spell-likes: 3/day—confusion (DC 18), hold monster (DC 19), invisibility; 1/day—cone of cold (DC 19), finger of death (DC 21), plane shift (DC 21). 
newEntity{
        define_as = "BASE_NPC_NIGHTSHADE",
        display = 'U', color=colors.BLUE,
        desc = [[An undead human-shaped horror the color of night.]],
        stats = { str=38, dex=14, con=1, int=20, wis=20, cha=18, luc=6 },
        name = "nightwalker",
        exp_worth = 4800,
        max_life = resolvers.rngavg(175,180),
        hit_die = 21,
        challenge = 16,
        combat_natural = 20,
        spell_resistance = 29,
        skill_concentration = 23,
        skill_diplomacy = 2,
        skill_hide = 16,
        skill_knowledge = 24,
        skill_listen = 24,
        skill_movesilently = 24,
        skill_search = 24,
        skill_sensemotive = 24,
        skill_spellcraft = 27,
        skill_spot = 25,
--[[       resolvers.talents{ [Talents.T_POWER_ATTACK]=1,
        [Talents.T_COMBAT_EXPERTISE]=1
        },]] 
}

--Fly 60 ft; immunity to cold; magic drain [item] Fort DC 22
--Imp Crit, Combat Reflexes
--Summon undead -  5-12 shadows, 2-4 greater shadows, or 1 dread wraith. 
--Spell-likes: at will- invisibility; 3/day—cone of cold (DC 19), confusion (DC 18), hold monster (DC 19); 1/day—finger of death (DC 21), mass hold monster (DC 23), plane shift (DC 21).
newEntity{
        define_as = "BASE_NPC_NIGHTSHADE",
        color=colors.BLACK,
        desc = [[An undead bat-shaped horror the color of night.]],
        stats = { str=31, dex=18, con=1, int=18, wis=20, cha=18, luc=6 },
        combat = { dam= {2,6} },
        name = "nightwing",
        exp_worth = 4200,
        max_life = resolvers.rngavg(140,145),
        hit_die = 17,
        challenge = 14,
        combat_natural = 16,
        spell_resistance = 29,
        skill_concentration = 20,
        skill_diplomacy = 2,
        skill_hide = 12,
        skill_listen = 20,
        skill_movesilently = 20,
        skill_search = 20,
        skill_sensemotive = 24,
        skill_spellcraft = 27,
        skill_spot = 25,
        resolvers.talents{ [Talents.T_DODGE]=1 },
}
