-- Please ask me if you want to use parts of this code!
-- Add network
util.AddNetworkString("TTTTargetDeal")
util.AddNetworkString("TTTTargetChatDeal")
util.AddNetworkString("TTTTargetChatRevealDeal")

-- Default Values and Tables
local Targets = {}
local Target = {}
local TargetPly = {}
local CreditPercent = {}

-- convars
local CredBon = CreateConVar("ttt_target_credit_bonus", "0.5", FCVAR_SERVER_CAN_EXECUTE, "The credit bonus given when a Traitor kills his target. (0.1-1) Def: 0.5")
local ChatReveal = CreateConVar("ttt_target_chatreveal", "0", FCVAR_SERVER_CAN_EXECUTE, "Enables or disables if the Traitor should be revealed if he killed nontarget. Def: 0")

local RoundIsActive = false

-- select Targets
local function GetTargets()
	local Players = player.GetAll()
	local Targets = {}
	local i2 = 1

	for i = 1, #Players, 1 do
		if Players[i]:IsValid() and not Players[i]:IsSpec() and Players[i]:IsTerror() and Players[i]:Alive() and Players[i].GetRole and Players[i]:GetRole() and not Players[i]:HasTeamRole(TEAM_TRAITOR) then
			if Players[i]:GetRole() ~= ROLES.JESTER.index then
				Targets[i2] = Players[i]
				i2 = i2 + 1
			end
		end
	end

	return Targets
end

-- Player dies Hook
hook.Add("PlayerDeath", "PlayerDeath4TTTTargetDeal", function(ply, inflictor, attacker)
	if not ROLES then return end
	
	if Targets and Target then
		if Target[attacker] == ply then -- if attacker's target is the dead player
			-- Credit management + info Text
			if not CreditPercent[attacker] then
				CreditPercent[attacker] = 0
			end
			
			local val = math.min(math.max(math.floor(CredBon:GetFloat() * 10) / 10, 0), 1)

			CreditPercent[attacker] = CreditPercent[attacker] + val

			if val > 0 then 
				if CreditPercent[attacker] >= 1 then
					attacker:AddCredits(1)

					CreditPercent[attacker] = CreditPercent[attacker] - 1

					net.Start("TTTTargetChatDeal")
					net.WriteString("You recived one credit by killing your target. (Credit Parts: " .. CreditPercent[attacker] .. ")")
					net.Send(attacker)
				else
					net.Start("TTTTargetChatDeal")
					net.WriteString("You killed your target. (Credit Parts: " .. CreditPercent[attacker] .. ")")
					net.Send(attacker)
				end
			else
				net.Start("TTTTargetChatDeal")
				net.WriteString("You killed your target.")
				net.Send(attacker)
			end
		elseif ChatReveal:GetBool() and attacker:HasTeamRole(TEAM_TRAITOR) then -- Reveal Traitors
			net.Start("TTTTargetChatRevealDeal")
			net.WriteString(attacker:GetName())
			net.Broadcast()
		elseif TargetPly[ply] then -- info Textmessage
			net.Start("TTTTargetChatDeal")
			net.WriteString("Your target died.")
			net.Send(TargetPly[ply])
		end
	end
end)

-- check if sb dies
hook.Add("Think", "Think4TTTTargetDeal", function()
	if not ROLES then return end
	
	if RoundIsActive then
		for i = 1, #Targets do
			if Targets[i] and not (Targets[i]:IsValid() and not Targets[i]:IsSpec() and Targets[i]:IsTerror() and Targets[i]:Alive() and Targets[i].GetRole and Targets[i]:GetRole() and not Targets[i]:HasTeamRole(TEAM_TRAITOR)) then
				if TargetPly[Targets[i]] then
					local ply = TargetPly[Targets[i]]

					Target[TargetPly[Targets[i]]] = nil
					TargetPly[Targets[i]] = nil
					Targets = GetTargets()

					if #Targets > 0 then
						local Data = Targets[math.random(1, #Targets)]

						Target[ply] = Data
						TargetPly[Data] = ply

						net.Start("TTTTargetDeal")
						net.WriteEntity(Target[ply])
						net.WriteBool(false)
						net.Send(ply)
					else
						net.Start("TTTTargetDeal")
						net.WriteEntity(nil)
						net.WriteBool(true)
						net.Send(ply)
					end

					i = #Targets + 1
				else
					Targets[i] = nil
				end
			end
		end
	end
end)

-- reset every round
hook.Add("TTTBeginRound","TTTBeginRound4TTTTargetServerDeal", function()
	if not ROLES then return end
	
	Targets = {}
	CreditPercent = {}
	Target = {}
	TargetPly = {}
	RoundIsActive = true
end)

-- reset when round ends
hook.Add("TTTEndRound", "TTTEndRound4TTTTargetDeal", function(result)
	if not ROLES then return end
	
	RoundIsActive = false
	Targets = {}
	CreditPercent = {}
	Target = {}
	TargetPly = {}
end)

-- send Targets
net.Receive("TTTTargetDeal", function(len, ply)
	Targets = GetTargets()

	if #Targets > 0 then
		local Data = Targets[math.random(1, #Targets)]

		Target[ply] = Data
		TargetPly[Data] = ply

		net.Start("TTTTargetDeal")
		net.WriteEntity(Target[ply])
		net.WriteBool(false)
		net.Send(ply)
	else
		net.Start("TTTTargetDeal")
		net.WriteEntity(nil)
		net.WriteBool(true)
		net.Send(ply)
	end
end)
