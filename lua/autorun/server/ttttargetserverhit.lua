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
local ChatReveal = CreateConVar("ttt_target_chatreveal", "0", FCVAR_SERVER_CAN_EXECUTE, "Enables or disables if the Traitor should be revealed if he killed nontarget (Def: 0)")

-- select Targets
local function GetTargets()
	local targets = {}

	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and not ply:IsSpec() and ply:IsActive() and ply.GetRole and ply:GetRole() and not ply:HasTeamRole(TEAM_TRAITOR) then
			if not ROLES.JESTER or ply:GetRole() ~= ROLES.JESTER.index then
				table.insert(targets, ply)
			end
		end
	end

	return targets
end

-- Player dies Hook
hook.Add("PlayerDeath", "PlayerDeath4TTTTargetHit", function(ply, inflictor, attacker)
	if not ROLES then return end
	
	if Target then
		local b = true
	
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetRole() == ROLES.HITMAN.index then
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
			elseif ChatReveal:GetBool() then -- Reveal Hitman
				net.Start("TTTTargetChatRevealHit")
				net.WriteString(attacker:GetName())
				net.Broadcast()
				
				b = false
			end
		end
		
		if b and TargetPly[ply] and Target[TargetPly[ply]] == ply then -- info Textmessage
			net.Start("TTTTargetChatHit")
			net.WriteString("Your target died.")
			net.Send(TargetPly[ply])
		end
	end
end)

-- check if sb dies
hook.Add("Think", "Think4TTTTargetHit", function()
	if not ROLES then return end
	
	if GetRoundState() == ROUND_ACTIVE then
		for _, target in ipairs(Targets) do
			if not target or not IsValid(target) or target:IsSpec() or not target:IsTerror() or not target:Alive() or not target.GetRole or not target:GetRole() or target:HasTeamRole(TEAM_TRAITOR) then
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
						net.WriteBool(false)
						net.Send(ply)
					else
						Target[ply] = nil
					
						net.Start("TTTTargetHit")
						net.WriteEntity(nil)
						net.WriteBool(true)
						net.Send(ply)
					end
					
					break
				elseif ply and Target[ply] ~= target then
					TargetPly[target] = nil
				end
			end
		end
	end
end)

-- reset when round ends
hook.Add("TTTEndRound", "TTTEndRound4TTTTargetHit", function(result)
	if not ROLES then return end
	
	Targets = {}
	CreditPercent = {}
	Target = {}
	TargetPly = {}
end)

-- send Targets
net.Receive("TTTTargetHit", function(len, ply)
	if not Target[ply] then
		Targets = GetTargets()

		PrintTable(Targets)

		if #Targets > 0 then
			local Data = Targets[math.random(1, #Targets)]

			Target[ply] = Data
			TargetPly[Data] = ply

			net.Start("TTTTargetHit")
			net.WriteEntity(Data)
			net.WriteBool(false)
			net.Send(ply)
		else
			net.Start("TTTTargetHit")
			net.WriteEntity(nil)
			net.WriteBool(true)
			net.Send(ply)
		end
	end
end)
