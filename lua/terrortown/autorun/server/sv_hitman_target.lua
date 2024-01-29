CreateConVar("ttt2_hitman_target_credit_bonus", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_hitman_target_chatreveal", 0, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_hitman_target_right_score_bonus", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})
CreateConVar("ttt2_hitman_target_wrong_score_penalty", 1, {FCVAR_ARCHIVE, FCVAR_NOTIFY})

local function CanBeTarget(ply, target, blacklisted)
	return target:IsActive()
		and not target:IsInTeam(ply)
		and not (target.IsGhost and target:IsGhost())
		and target ~= blacklisted
		and hook.Run("TTT2CanBeHitmanTarget", ply, target) ~= false
end

local function GetTargets(ply, blacklisted)
	local targets = {}
	local policingRoles = {}

	if not IsValid(ply)
		or not ply:IsActive()
		or (ply.IsGhost and ply:IsGhost())
		or ply:GetSubRole() ~= ROLE_HITMAN
	then
		return targets
	end

	local plys = player.GetAll()

	for i = 1, #plys do
		local p = plys[i]

		if not CanBeTarget(ply, p, blacklisted) then continue end

		local pRoleData = p:GetSubRoleData()

		if pRoleData.isPolicingRole and pRoleData.isPublicRole then
			policingRoles[#policingRoles + 1] = p
		else
			targets[#targets + 1] = p
		end
	end

	if #targets < 1 then
		targets = policingRoles
	end

	return targets
end

local function SelectNewTarget(ply, blacklisted)
	local targets = GetTargets(ply, blacklisted)

	if #targets > 0 then
		ply:SetTargetPlayer(targets[math.random(1, #targets)])
	else
		ply:SetTargetPlayer(nil)

		LANG.Msg(ply, "ttt2_hitman_target_unavailable", nil, MSG_MSTACK_PLAIN)
	end
end

local function HitmanTargetDied(ply, attacker, dmgInfo)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	local wasTargetKill = false

	if IsValid(attacker)
		and attacker:IsPlayer()
		and attacker:GetSubRole() == ROLE_HITMAN
		and attacker:GetTargetPlayer()
		and (not attacker.IsGhost or not attacker:IsGhost())
	then
		events.Trigger(EVENT_TARGET_KILL, ply, attacker, dmgInfo, attacker:GetTargetPlayer() == ply)

		if attacker:GetTargetPlayer() == ply then -- if attacker's target is the dead player
			wasTargetKill = true

			local val = GetConVar("ttt2_hitman_target_credit_bonus"):GetInt()

			if val > 0 and attacker:IsActive() then
				attacker:AddCredits(val)

				LANG.Msg(attacker, "ttt2_hitman_target_killed_credits", {amount = val}, MSG_MSTACK_ROLE)
			else
				LANG.Msg(attacker, "ttt2_hitman_target_killed", nil, MSG_MSTACK_ROLE)
			end
		elseif GetConVar("ttt2_hitman_target_chatreveal"):GetBool() and attacker ~= ply then -- Reveal Hitman
			LANG.MsgAll("ttt2_hitman_chat_reveal", {playername = attacker:Nick()}, MSG_MSTACK_WARN)
		end
	end

	local plys = player.GetAll()

	for i = 1, #plys do
		local plyHitman = plys[i]

		if plyHitman:GetSubRole() ~= ROLE_HITMAN
			or (plyHitman.IsGhost and plyHitman:IsGhost())
		then continue end

		local target = plyHitman:GetTargetPlayer()

		if IsValid(target)
			and (not target:IsActive()
				or target == ply
				or (target.IsGhost and target:IsGhost())
			)
		then
			if not wasTargetKill then
				LANG.Msg(plyHitman, "ttt2_hitman_target_died", nil, MSG_MSTACK_PLAIN)
			end

			SelectNewTarget(plyHitman, ply)
		end
	end
end
hook.Add("DoPlayerDeath", "HitmanTargetDied", HitmanTargetDied)

-- select a new target if the hitman has no target and a player respawned
local function HitmanTargetSpawned(ply)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	local plys = player.GetAll()

	for i = 1, #plys do
		local plyHitman = plys[i]

		if plyHitman:GetSubRole() ~= ROLE_HITMAN
			or (plyHitman.IsGhost and plyHitman:IsGhost())
			or IsValid(plyHitman:GetTargetPlayer())
		then continue end

		SelectNewTarget(plyHitman)
	end
end
hook.Add("PlayerSpawn", "HitmanTargetSpawned", HitmanTargetSpawned)

local function HitmanTargetDisconnected(ply)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	local plys = player.GetAll()

	for i = 1, #plys do
		local plyHitman = plys[i]

		if plyHitman:GetSubRole() ~= ROLE_HITMAN
			or (plyHitman.IsGhost and plyHitman:IsGhost())
			or plyHitman:GetTargetPlayer() ~= ply
		then continue end

		SelectNewTarget(plyHitman, ply)
	end
end
hook.Add("PlayerDisconnected", "HitmanTargetDisconnected", HitmanTargetDisconnected)

local function HitmanTargetRoleChanged(ply, old, new)
	if GetRoundState() ~= ROUND_ACTIVE then return end

	-- handle target of the role itself
	if new == ROLE_HITMAN then
		SelectNewTarget(ply)
	elseif old == ROLE_HITMAN then
		ply:SetTargetPlayer(nil)
	end

	-- handle role changes of the target
	local plys = player.GetAll()

	for i = 1, #plys do
		local plyHitman = plys[i]

		if plyHitman:GetSubRole() ~= ROLE_HITMAN
			or (plyHitman.IsGhost and plyHitman:IsGhost())
			or CanBeTarget(plyHitman, ply)
		then continue end

		SelectNewTarget(plyHitman)
	end
end
hook.Add("TTT2UpdateSubrole", "HitmanTargetRoleChanged", HitmanTargetRoleChanged)

local function HitmanGotSelected()
	local plys = player.GetAll()

	for i = 1, #plys do
		local plyHitman = plys[i]

		if plyHitman:GetSubRole() ~= ROLE_HITMAN
			or (plyHitman.IsGhost and plyHitman:IsGhost())
		then continue end

		SelectNewTarget(plyHitman)
	end
end
hook.Add("TTTBeginRound", "HitmanGotSelected", HitmanGotSelected)
