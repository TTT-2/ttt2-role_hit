if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_hit.vmt")
	resource.AddFile("materials/vgui/ttt/sprite_hit.vmt")
end

-- important to add roles with this function,
-- because it does more than just access the array ! e.g. updating other arrays
InitCustomRole("HITMAN", { -- first param is access for ROLES array => ROLES["HITMAN"] or ROLES.HITMAN or HITMAN
		color = Color(255, 51, 51, 255), -- ...
		dkcolor = Color(255, 51, 51, 255), -- ...
		bgcolor = Color(255, 51, 51, 200), -- ...
		name = "hitman", -- just a unique name for the script to determine
		abbr = "hit", -- abbreviation
		defaultTeam = TEAM_TRAITOR, -- the team name: roles with same team name are working together
		defaultEquipment = SPECIAL_EQUIPMENT, -- here you can set up your own default equipment
		surviveBonus = 0.5, -- bonus multiplier for every survive while another player was killed
		scoreKillsMultiplier = 5, -- multiplier for kill of player of another team
		scoreTeamKillsMultiplier = -16, -- multiplier for teamkill
		preventFindCredits = true,
		preventKillCredits = true,
		preventTraitorAloneCredits = true
	}, {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		credits = 0, -- the starting credits of a specific role
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50,
		shopFallback = SHOP_FALLBACK_TRAITOR
})

-- now link this subrole with its baserole
hook.Add("TTT2BaseRoleInit", "TTT2ConBRTWithHit", function()
	SetBaseRole(HITMAN, ROLE_TRAITOR)
end)

-- if sync of roles has finished
hook.Add("TTT2FinishedLoading", "HitmanInitT", function()
	if CLIENT then
		-- setup here is not necessary but if you want to access the role data, you need to start here
		-- setup basic translation !
		LANG.AddToLanguage("English", HITMAN.name, "Hitman")
		LANG.AddToLanguage("English", "info_popup_" .. HITMAN.name, [[You are a Hitman!
Try to get some credits!]])
		LANG.AddToLanguage("English", "body_found_" .. HITMAN.abbr, "This was a Hitman...")
		LANG.AddToLanguage("English", "search_role_" .. HITMAN.abbr, "This person was a Hitman!")
		LANG.AddToLanguage("English", "target_" .. HITMAN.name, "Hitman")
		LANG.AddToLanguage("English", "ttt2_desc_" .. HITMAN.name, [[The Hitman is a Traitor (who works together with the other traitors) and the goal is to kill all other roles except the other traitor roles ^^
The Hitman is just able to collect some credits if he kills his target.]])

		---------------------------------

		-- maybe this language as well...
		LANG.AddToLanguage("Deutsch", HITMAN.name, "Hitman")
		LANG.AddToLanguage("Deutsch", "info_popup_" .. HITMAN.name, [[Du bist ein Hitman!
Versuche ein paar Credits zu bekommen!]])
		LANG.AddToLanguage("Deutsch", "body_found_" .. HITMAN.abbr, "Er war ein Hitman...")
		LANG.AddToLanguage("Deutsch", "search_role_" .. HITMAN.abbr, "Diese Person war ein Hitman!")
		LANG.AddToLanguage("Deutsch", "target_" .. HITMAN.name, "Hitman")
		LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. HITMAN.name, [[Der Hitman ist ein Verräter (der mit den anderen Verräter-Rollen zusammenarbeitet) und dessen Ziel es ist, alle anderen Rollen (außer Verräter-Rollen) zu töten ^^
Er kann nur Credits sammeln indem er sein Ziel tötet.]])
	end
end)

if SERVER then
	hook.Add("TTT2CheckCreditAward", "TTT2HitmanSpecialCreditReward", function(victim, attacker)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:IsActive() and attacker:GetSubRole() == ROLE_HITMAN then
			return false -- prevent awards
		end
	end)

	-- if there is TTTC installed: sync classes
	util.AddNetworkString("TTT2HitmanSyncClasses")
	hook.Add("TTTCPostReceiveCustomClasses", "TTT2HitmanCanSeeClasses", function()
		for _, hitman in ipairs(player.GetAll()) do
			if hitman:IsActive() and hitman:GetSubRole() == ROLE_HITMAN then
				for _, ply in ipairs(player.GetAll()) do
					net.Start("TTT2HitmanSyncClasses")
					net.WriteEntity(ply)
					net.WriteUInt(ply:GetCustomClass() - 1, CLASS_BITS)
					net.Send(hitman)
				end
			end
		end
	end)
else
	net.Receive("TTT2HitmanSyncClasses", function(len)
		local target = net.ReadEntity()
		local class = net.ReadUInt(CLASS_BITS) + 1

		target:SetCustomClass(class)
	end)
end
