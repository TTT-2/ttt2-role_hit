EVENT.base = "kill"

if CLIENT then
	EVENT.icon = Material("vgui/ttt/vskin/events/target_kill")

	function EVENT:GetText()
		local killText = self.BaseClass.GetText(self)

		if self.event.wasTarget then
			killText[#killText + 1] = {
				string = "desc_target_kill_hit_right"
			}
		else
			killText[#killText + 1] = {
				string = "desc_target_kill_hit_wrong"
			}
		end

		return killText
	end
end

if SERVER then
	function EVENT:Trigger(victim, attacker, dmgInfo, wasTarget)
		-- store in table if it was a target or not
		self.wasTarget = wasTarget

		-- mark the player so that the original kill event can be canceled
		victim.wasHitmanDeath = true

		return self.BaseClass.Trigger(self, victim, attacker, dmgInfo)
	end

	function EVENT:CalculateScore()
		self.BaseClass.CalculateScore(self)

		local score = self:GetPlayerScore(self.event.attacker.sid64)

		-- modify score reference
		if self.wasTarget then
			score.score_hit_right = GetConVar("ttt2_hitman_target_right_score_bonus"):GetInt()
		else
			score.score_hit_wrong = -1 * GetConVar("ttt2_hitman_target_wrong_score_penalty"):GetInt()
		end

		-- since Trigger already calls CalculateScore via Add, we can not edit the event
		-- table beforehand. Therefore we now add the wasTarget flag here so it
		-- is automatically synced to the client.
		self.event.wasTarget = self.wasTarget
	end
end

function EVENT:Serialize()
	return self.event.victim.nick .. " has been killed by a hitman."
end

-- don't add the normal kill event if a target_kill event is added
hook.Add("TTT2OnTriggeredEvent", "cancel_hitman_kill_event", function(type, eventData)
	if type ~= EVENT_KILL then return end

	local ply = player.GetBySteamID64(eventData.victim.sid64)

	if not IsValid(ply) or not ply.wasHitmanDeath then return end

	ply.wasHitmanDeath = nil

	return false
end)
