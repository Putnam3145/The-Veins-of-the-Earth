newTalentType{ passive=true, type="druid/druid", name="druid", description="Druid Feats" }

newTalent{
	name = "Wild Shape",
	type = {"druid/druid", 1},
	mode = 'sustained',
	points = 1,
--	cooldown = 30,
	tactical = { BUFF = 5 },
	range = 0,
--	requires_target = true,
	activate = function(self)
		if not self then return nil end

		local effect = self:talentDialog(require('mod.dialogs.GetChoice').new("Choose the animal form",{
            {name="Baboon", desc="", effect=self.EFF_WILD_SHAPE_BABOON},
            {name="Crocodile", desc="", effect=self.EFF_WILD_SHAPE_CROCODILE},
        }, function(result, item)
            self:talentDialogReturn(result and item.effect)
            game:unregisterDialog(self:talentDialogGet())
        end))

        if not effect then return nil end

        self:setEffect(effect, 600, {})
		return true
	end,
	deactivate = function(self)
		if self:hasEffect(self.EFF_WILD_SHAPE_BABOON) then self:removeEffect(self.EFF_WILD_SHAPE_BABOON, false, true) end
		if self:hasEffect(self.EFF_WILD_SHAPE_CROCODILE) then self:removeEffect(self.EFF_WILD_SHAPE_CROCODILE, false, true) end

		self.replace_display = nil
		self:removeAllMOs()
		game.level.map:updateMap(self.x, self.y)

		return true
	end,
	info = function(self, t)
		return ([[You can change your shape to an animal. The Hit Dice of the assumed form cannot exceed your own Hit Dice, with a cap of 5.]])
	end,
}
