if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_hit.vmt")

	-- if there is TTTC installed: sync classes
	util.AddNetworkString("TTT2HitmanSyncClasses")
end

function ROLE:PreInitialize()
	self.color = Color(240, 96, 72, 255) -- ...
	self.dkcolor = Color(172, 35, 13, 255) -- ...
	self.bgcolor = Color(53, 177, 90, 255) -- ...
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
		shopFallback = SHOP_FALLBACK_TRAITOR
	}
end

-- now link this subrole with its baserole
function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_TRAITOR)
	
	if CLIENT then
		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", self.name, "Hitman")
		LANG.AddToLanguage("English", "info_popup_" .. self.name, [[You are a Hitman!
Try to get some credits!]])
		LANG.AddToLanguage("English", "body_found_" .. self.abbr, "This was a Hitman...")
		LANG.AddToLanguage("English", "search_role_" .. self.abbr, "This person was a Hitman!")
		LANG.AddToLanguage("English", "target_" .. self.name, "Hitman")
		LANG.AddToLanguage("English", "ttt2_desc_" .. self.name, [[The Hitman is a Traitor (who works together with the other traitors) and the goal is to kill all other roles except the other traitor roles ^^
The Hitman is just able to collect some credits if he kills his target.]])

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage("Deutsch", self.name, "Hitman")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. self.name, [[Du bist ein Hitman!
Versuche ein paar Credits zu bekommen!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. self.abbr, "Er war ein Hitman...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. self.abbr, "Diese Person war ein Hitman!")
		LANG.AddToLanguage("Deutsch", "target_" .. self.name, "Hitman")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. self.name, [[Der Hitman ist ein Verräter (der mit den anderen Verräter-Rollen zusammenarbeitet) und dessen Ziel es ist, alle anderen Rollen (außer Verräter-Rollen) zu töten ^^
Er kann nur Credits sammeln indem er sein Ziel tötet.]])
	end
end

local h_TTT2CheckCreditAward = "TTT2HitmanSpecialCreditReward"
local h_TTTCPostReceiveCustomClasses = "TTT2HitmanCanSeeClasses"

if SERVER then
	local function SendClassesToHitman(hitman)
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
		if hitman:IsActive() and role == ROLE_HITMAN then
			SendClassesToHitman(hitman)
		end
	end)

	hook.Add("TTTCPostReceiveCustomClasses", h_TTTCPostReceiveCustomClasses, function()
		for _, hitman in ipairs(player.GetAll()) do
			if hitman:IsActive() and hitman:GetSubRole() == ROLE_HITMAN then
				SendClassesToHitman(hitman)
			end
		end
	end)
else
	net.Receive("TTT2HitmanSyncClasses", function(len)
		local target = net.ReadEntity()
		local class = net.ReadUInt(CLASS_BITS)

		if class == 0 then
			class = nil
		end

		target:SetClass(class)
	end)
end
