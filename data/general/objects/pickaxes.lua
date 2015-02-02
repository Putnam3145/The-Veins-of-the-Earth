--Veins of the Earth
--Zireael

local Talents = require "engine.interface.ActorTalents"

newEntity{
	define_as = "BASE_DIGGER",
	slot = "TOOL",
	type = "tool", subtype="digger",
	image = "tiles/pickaxe.png",
	display = "\\", color=colors.STEEL_BLUE,
	encumber = 3,
	rarity = 20,
	desc = [[Allows you to dig.]],
	--Based on Qi Daozei
	digspeed = 10,
    use_no_wear = true,
--    use_no_energy = true, -- energy cost is handled by wait() below

    getEffectiveDigSpeed = function(self, who, show_message)
            return math.floor(self.digspeed * 2)
    end,

    -- Based on ToME's DIG_OBJECT
    use_simple = {
        name = "dig",
        use = function(self, who)
            local Map = require "engine.Map"
            local tg = {type="bolt", range=1, nolock=true}
            local x, y = who:getTarget(tg)
            if not x or not y then return nil end
            local feat = game.level.map(x, y, Map.TERRAIN)
            if not feat.dig then
                game.logPlayer(who, ("The %s is not diggable."):format(feat.name))
                return nil
            end

            -- Hack: Subtracting 1 is necessary to make turns taken match.
            -- I'm not sure why.
            local digspeed = self:getEffectiveDigSpeed(who, true) - 1

        --[[    local wait = function()
                local co = coroutine.running()
                local ok = false
                who:restInit(digspeed, "digging", "dug", function(cnt, max)
                    if cnt > max then ok = true end
                    coroutine.resume(co)
                end)
                coroutine.yield()
                if not ok then
                    game.logPlayer(who, "You have been interrupted!")
                    return false
                end
                return true
            end]]
        --    if wait() then
                who:project(tg, x, y, engine.DamageType.DIG, 1)
        --   end

        --    return true
            return {used = true}
        end,
    }
}

newEntity{ base = "BASE_DIGGER",
	name = "iron pickaxe",
	level_range = {1, 20},
--	cost = 3,
    cost = resolvers.value{silver=35},
	digspeed = 20,
}