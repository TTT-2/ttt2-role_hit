if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_hit.vmt")

	-- if there is TTTC installed: sync classes
	util.AddNetworkString("TTT2HitmanSyncClasses")
end

function ROLE:PreInitialize()
	self.color = Color(240, 96, 72, 255)

	self.abbr = "hit" -- abbreviation
	self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
	self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
	self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true

	self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
	self.defaultTeam = TEAM_TRAITOR

	self.conVarData = {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50,
		traitorButton = 1, -- can use traitor buttons
		shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

-- now link this subrole with its baserole
function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
end

local h_TTT2CheckCreditAward = "TTT2HitmanSpecialCreditReward"
local h_TTTCPostReceiveCustomClasses = "TTT2HitmanCanSeeClasses"

if SERVER then
	-- TODO improve networking. If TTTC is disabled, this doesn't need to be handled
	local function SendClassesToHitman(hitman)
		if not TTTC then return end

		for _, ply in ipairs(player.GetAll()) do
			if ply ~= hitman then
				net.Start("TTT2HitmanSyncClasses")
				net.WriteEntity(ply)
				net.WriteUInt(ply:GetCustomClass() or 0, CLASS_BITS)
				net.Send(hitman)
			end
		end
	end

	hook.Add("TTT2CheckCreditAward", h_TTT2CheckCreditAward, function(victim, attacker)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:IsActive() and attacker:GetSubRole() == ROLE_HITMAN then
			return false -- prevent awards
		end
	end)

	hook.Add("TTT2UpdateSubrole", h_TTTCPostReceiveCustomClasses, function(hitman, oldRole, role)
		if not TTTC then return end

		if hitman:IsActive() and role == ROLE_HITMAN then
			SendClassesToHitman(hitman)
		end
	end)

	hook.Add("TTTCPostReceiveCustomClasses", h_TTTCPostReceiveCustomClasses, function()
		if not TTTC then return end

		for _, hitman in ipairs(player.GetAll()) do
			if hitman:IsActive() and hitman:GetSubRole() == ROLE_HITMAN then
				SendClassesToHitman(hitman)
			end
		end
	end)
end

if CLIENT then
	net.Receive("TTT2HitmanSyncClasses", function(len)
		local target = net.ReadEntity()
		local class = net.ReadUInt(CLASS_BITS)

		if class == 0 then
			class = nil
		end

		target:SetClass(class)
	end)
end
