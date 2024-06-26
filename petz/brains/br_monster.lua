--
-- MONSTER BRAIN
--

function petz.monster_brain(self)

	local pos = self.object:get_pos() --pos of the petz

	kitz.vitals(self)

	if self.hp <= 0 then -- Die Behaviour
		petz.on_die(self)
		return
	end

	petz.check_ground_suffocation(self, pos)

	if kitz.timer(self, 1) then

		local prty = kitz.get_queue_priority(self)

		if prty < 40 and self.isinliquid then
			kitz.hq_liquid_recovery(self, 40)
			return
		end

		local player = kitz.get_nearby_player(self) --get the player close

		if prty < 30 then
			petz.env_damage(self, pos, 30) --enviromental damage: lava, fire...
		end

		-- hunt a prey
		if prty < 12 then -- if not busy with anything important
			if not self.tamed then
				local preys_list = petz.settings[self.type.."_preys"]
				if preys_list then
					local preys = string.split(preys_list, ',')
					for i = 1, #preys  do --loop  thru all preys
						--minetest.chat_send_player("singleplayer", "preys list="..preys[i])
						--minetest.chat_send_player("singleplayer", "node name="..node.name)
						local prey = kitz.get_closest_entity(self, preys[i])	-- look for prey
						if prey then
							self.max_speed = 2.5
							--minetest.chat_send_player("singleplayer", "got it")
							petz.hq_hunt(self, 12, prey) -- and chase it
							return
						end
					end
				end
			end
		end

		if prty < 10 then
			if player then
				local werewolf = false
				if petz.settings["lycanthropy"] then
					if petz.is_werewolf(player) then
						werewolf = true
					end
				end
				if (not(self.tamed) and not(werewolf)) or (self.tamed and self.status == "guard" and player:get_player_name() ~= self.owner) then
					local player_pos = player:get_pos()
					if vector.distance(pos, player_pos) <= self.view_range then	-- if player close
						self.max_speed = 2.5
						petz.hq_hunt(self, 10, player)
						return
					end
				end
			end
		end

		--Replace nodes by others
		if prty < 6 then
			petz.bh_replace(self)
		end

		-- Default Random Sound
		kitz.make_misc_sound(self, petz.settings.misc_sound_chance, petz.settings.max_hear_distance)

		--Roam default
		if kitz.is_queue_empty_high(self) then
			self.max_speed = 1.5
			kitz.hq_roam(self, 0)
		end

	end
end
