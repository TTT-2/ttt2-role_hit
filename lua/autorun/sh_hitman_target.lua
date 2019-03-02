if SERVER then
	AddCSLuaFile()

	-- convars
	local creditsBonus = CreateConVar("ttt2_hitman_target_credit_bonus", "1", FCVAR_SERVER_CAN_EXECUTE, "The credit bonus given when a Traitor kills his target. (Def: 2)")
	local chatReveal = CreateConVar("ttt2_hitman_target_chatreveal", "0", FCVAR_SERVER_CAN_EXECUTE, "Enables or disables if the Traitor should be revealed if he killed nontarget (Def: 0)")

	-- select Targets
	local function GetTargets(ply)
		local targets = {}
		local detes = {}

		for _, pl in ipairs(player.GetAll()) do
			if pl:IsActive() and not pl:IsInTeam(ply) then
				if pl:IsRole(ROLE_DETECTIVE) then
					detes[#detes + 1] = pl
				else
					targets[#targets + 1] = pl
				end
			end
		end

		if #targets == 0 then
			targets = detes
		end

		return targets
	end

	local function SelectNewTarget(ply, targets)
		targets = GetTargets(ply)

		if #targets > 0 then
			ply:SetTargetPlayer(targets[math.random(1, #targets)])
		else
			ply:SetTargetPlayer(nil)
		end
	end

	local function HitmanTargetChanged(ply, _, attacker)
		if GetRoundState() == ROUND_ACTIVE then
			if IsValid(attacker) and attacker:IsPlayer() and attacker:GetSubRole() == ROLE_HITMAN and (not attacker.IsGhost or not attacker:IsGhost()) and IsValid(attacker:GetTargetPlayer()) then
				if attacker:GetTargetPlayer() == ply then -- if attacker's target is the dead player
					local val = creditsBonus:GetInt()
					local text = ""

					if val > 0 and attacker:IsActive() then
						attacker:AddCredits(val)

						text = "You received " .. val .. " credit(s) for eleminating your target."
					else
						text = "You've killed your target!"
					end

					attacker:ChatPrint(text)

					if attacker:IsActive() then
						SelectNewTarget(attacker)
					end
				elseif chatReveal:GetBool() and attacker ~= ply then -- Reveal Sidekick
					local text = attacker:Nick() .. " is a " .. string.upper(attacker:GetSubRoleData().name) .. "!"

					for _, pl in ipairs(player.GetAll()) do
						pl:ChatPrint(text)
					end
				end
			end

			for _, pl in ipairs(player.GetAll()) do
				if (not IsValid(attacker) or pl ~= attacker) and (not pl.IsGhost or not pl:IsGhost()) and IsValid(pl:GetTargetPlayer()) and pl:GetTargetPlayer() == ply and pl:IsActive() then
					pl:ChatPrint("Your target died...") -- info Textmessage

					SelectNewTarget(pl)
				end
			end
		end
	end
	hook.Add("PlayerDeath", "PlayerHitmanTargetDeath", HitmanTargetChanged)

	local function HitmanTargetSpawned(ply)
		if GetRoundState() == ROUND_ACTIVE then
			for _, v in ipairs(player.GetAll()) do
				if ply ~= v and v:IsActive() and v:GetSubRole() == ROLE_HITMAN and (not v.IsGhost or not v:IsGhost()) and (not IsValid(v:GetTargetPlayer()) or not v:GetTargetPlayer():IsActive()) then
					local targets = GetTargets(v)
					if #targets > 0 then -- avoid sending useless network message
						SelectNewTarget(v, targets)
					end
				end
			end

			if ply:GetSubRole() == ROLE_HITMAN and (not ply.IsGhost or not ply:IsGhost()) and (not IsValid(ply:GetTargetPlayer()) or not ply:GetTargetPlayer():IsActive()) then
				SelectNewTarget(ply)
			end
		end
	end
	hook.Add("PlayerSpawn", "PlayerHitmanTargetSpawn", HitmanTargetSpawned)

	local function HitmanTargetDisconnected(ply)
		if GetRoundState() == ROUND_ACTIVE then
			for _, v in ipairs(player.GetAll()) do
				if v:GetTargetPlayer() == ply and v:IsActive() and v:GetSubRole() == ROLE_HITMAN and (not v.IsGhost or not v:IsGhost()) then
					SelectNewTarget(v)
				end
			end
		end
	end
	hook.Add("PlayerDisconnected", "PlayerHitmanTargetDisconnected", HitmanTargetDisconnected)

	local function HitmanTargetRoleChanged(ply, old, new)
		if GetRoundState() == ROUND_ACTIVE then
			if new == ROLE_HITMAN then
				SelectNewTarget(ply)
			elseif old == ROLE_HITMAN then
				ply:SetTargetPlayer(nil)
			end

			for _, v in ipairs(player.GetAll()) do
				if v:GetTargetPlayer() == ply and v:IsActive() and v:GetSubRole() == ROLE_HITMAN and (not v:GetTargetPlayer() or not v:IsGhost()) and v:IsInTeam(ply) then
					SelectNewTarget(v)
				end
			end
		end
	end
	hook.Add("TTT2UpdateSubrole", "HitmanTargetRoleChanged", HitmanTargetRoleChanged)
end
