AddCSLuaFile("autorun/client/ttttargetclienthit.lua")

-- Please ask me if you want to use parts of this code!
-- Add network
util.AddNetworkString("TTTTargetHit")
util.AddNetworkString("TTTTargetChatHit")
util.AddNetworkString("TTTTargetChatRevealHit")

-- Default Values and Tables
local Targets = {}
local Target = {}
local TargetPly = {}
local CreditPercent = {}

-- convars
local CredBon = CreateConVar("ttt_target_credit_bonus", "2", FCVAR_SERVER_CAN_EXECUTE, "The credit bonus given when a Traitor kills his target. (Def: 2)")
local ChatReveal = CreateConVar("ttt_target_chatreveal", "1", FCVAR_SERVER_CAN_EXECUTE, "Enables or disables if the Traitor should be revealed if he killed nontarget (Def: 1)")

-- select Targets
local function GetTargets()
	local targets = {}

	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and not ply:IsSpec() and ply:IsActive() and ply.GetSubRole and ply:GetSubRole() and not ply:HasTeam(TEAM_TRAITOR) and (
			not ROLE_JESTER or ply:GetSubRole() ~= ROLE_JESTER
		) and ply:GetBaseRole() ~= ROLE_DETECTIVE then
			table.insert(targets, ply)
		end
	end

	return targets
end

local function HitmanDeathHook(ply, inflictor, attacker)
	if Target then
		local b = true

		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetSubRole() == ROLE_HITMAN and (not attacker.IsGhost or not attacker:IsGhost()) then
			if Target[attacker] == ply then -- if attacker's target is the dead player
				-- Credit management + info Text
				if not CreditPercent[attacker] then
					CreditPercent[attacker] = 0
				end

				local val = CredBon:GetFloat()
				local valInt = CredBon:GetInt()

				CreditPercent[attacker] = CreditPercent[attacker] + val

				local cr = CreditPercent[attacker]

				if val > 0 then
					if cr >= 1 then
						attacker:AddCredits(cr - val + valInt)

						CreditPercent[attacker] = CreditPercent[attacker] - valInt

						net.Start("TTTTargetChatHit")
						net.WriteString("You received " .. (cr - val + valInt) .. " credit(s) by killing your target.")
						net.Send(attacker)
					else
						net.Start("TTTTargetChatHit")
						net.WriteString("You killed your target. (Credit Parts: " .. CreditPercent[attacker] .. ")")
						net.Send(attacker)
					end
				else
					net.Start("TTTTargetChatHit")
					net.WriteString("You killed your target.")
					net.Send(attacker)
				end

				b = false
			elseif ChatReveal:GetBool() and attacker ~= ply then -- Reveal Hitman
				net.Start("TTTTargetChatRevealHit")
				net.WriteString(attacker:GetName())
				net.Broadcast()

				b = false
			end
		end

		if b and (not ply.IsGhost or not ply:IsGhost()) and TargetPly[ply] and Target[TargetPly[ply]] == ply then -- info Textmessage
			net.Start("TTTTargetChatHit")
			net.WriteString("Your target died.")
			net.Send(TargetPly[ply])
		end
	end
end

local function HitmanThink()
	if GetRoundState() == ROUND_ACTIVE then
		for _, target in ipairs(Targets) do
			if not target or not IsValid(target) or target:IsSpec() or not target:IsTerror() or not target:Alive() or not target.GetSubRole or not target:GetSubRole() or target:HasTeam(TEAM_TRAITOR) then
				local ply = TargetPly[target]
				if ply and Target[ply] == target then
					TargetPly[target] = nil
					Targets = GetTargets()

					if #Targets > 0 then
						local Data = Targets[math.random(1, #Targets)]

						Target[ply] = Data
						TargetPly[Data] = ply

						net.Start("TTTTargetHit")
						net.WriteEntity(Data)
						net.Send(ply)
					else
						Target[ply] = nil

						net.Start("TTTTargetHit")
						net.WriteEntity(nil)
						net.Send(ply)
					end

					break
				elseif ply and Target[ply] ~= target then
					TargetPly[target] = nil
				end
			end
		end
	end
end

-- reset when round ends
hook.Add("TTTEndRound", "TTTEndRound4TTTTargetHit", function(result)
	if not TTT2 then return end

	Targets = {}
	CreditPercent = {}
	Target = {}
	TargetPly = {}
end)

local function HitmanTargetRoleChanged(ply, old, new)
	if IsValid(TargetPly[ply]) and TargetPly[ply]:IsPlayer() and TargetPly[ply]:GetSubRole() == ROLE_HITMAN and new == ROLE_JESTER then
		hitman = TargetPly[ply]
		TargetPly[ply] = nil
		Targets = GetTargets()

		if #Targets > 0 then
			local Data = Targets[math.random(1, #Targets)]

			Target[hitman] = Data
			TargetPly[Data] = hitman

			net.Start("TTTTargetHit")
			net.WriteEntity(Data)
			net.Send(hitman)
		else
			Target[hitman] = nil

			net.Start("TTTTargetHit")
			net.WriteEntity(nil)
			net.Send(hitman)
		end
	end
end

-- send Targets
net.Receive("TTTTargetHit", function(len, ply)
	if not Target[ply] then
		Targets = GetTargets()

		if #Targets > 0 then
			local Data = Targets[math.random(1, #Targets)]

			Target[ply] = Data
			TargetPly[Data] = ply

			net.Start("TTTTargetHit")
			net.WriteEntity(Data)
			net.Send(ply)
		else
			net.Start("TTTTargetHit")
			net.WriteEntity(nil)
			net.Send(ply)
		end
	else
		net.Start("TTTTargetHit")
		net.WriteEntity(Target[ply])
		net.Send(ply)
	end
end)

local h_Think = "Think4TTTTargetHit"
local h_PlayerDeath = "PlayerDeath4TTTTargetHit"
local h_TTT2UpdateSubrole = "TargetRoleChanged"

hook.Add("TTT2ToggleRole", "TTT2ToggleHitmanHooksSV", function(roleData, state)
	if roleData == HITMAN then
		if state then
			hook.Add("Think", h_Think, HitmanThink)
			hook.Add("PlayerDeath", h_PlayerDeath, HitmanDeathHook)
			hook.Add("TTT2UpdateSubrole", h_TTT2UpdateSubrole, HitmanTargetRoleChanged)
		else
			hook.Remove("Think", h_Think)
			hook.Remove("PlayerDeath", h_PlayerDeath)
			hook.Remove("TTT2UpdateSubrole", h_TTT2UpdateSubrole)
		end
	end
end)
