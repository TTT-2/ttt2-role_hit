if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/icon_hit.vmt")
	resource.AddFile("materials/vgui/ttt/sprite_hit.vmt")
end

hook.Add("Initialize", "TTT2InitCRoleHit", function()
	-- important to add roles with this function,
	-- because it does more than just access the array ! e.g. updating other arrays
	AddCustomRole("HITMAN", { -- first param is access for ROLES array => ROLES["HITMAN"] or ROLES["HITMAN"]
		color = Color(255, 51, 51, 255), -- ...
		dkcolor = Color(255, 51, 51, 255), -- ...
		bgcolor = Color(255, 51, 51, 200), -- ...
		name = "hitman", -- just a unique name for the script to determine
		printName = "Hitman", -- The text that is printed to the player, e.g. in role alert
		abbr = "hit", -- abbreviation
		team = TEAM_TRAITOR, -- the team name: roles with same team name are working together
		visibleForTraitors = true, -- other traitors can see this role / sync them with traitors
		shop = true,
		defaultEquipment = SPECIAL_EQUIPMENT, -- here you can set up your own default equipment
		surviveBonus = 0.5, -- bonus multiplier for every survive while another player was killed
		scoreKillsMultiplier = 5, -- multiplier for kill of player of another team
		scoreTeamKillsMultiplier = -16, -- multiplier for teamkill
		--showOnConfirm = true -- shows the player on death to each client (e.g. on scoreboard)
		preventFindCredits = true,
		preventKillCredits = true
	}, {
		pct = 0.17, -- necessary: percentage of getting this role selected (per player)
		maximum = 1, -- maximum amount of roles in a round
		minPlayers = 6, -- minimum amount of players until this role is able to get selected
		togglable = true, -- option to toggle a role for a client if possible (F1 menu)
		random = 50,
		shopFallback = SHOP_FALLBACK_TRAITOR
	})
end)

-- if sync of roles has finished
hook.Add("TTT2_FinishedSync", "HitmanInitT", function(ply, first)
    if first then -- just on first init !
        if CLIENT then
            -- setup here is not necessary but if you want to access the role data, you need to start here
            -- setup basic translation !
            LANG.AddToLanguage("English", ROLES.HITMAN.name, "Hitman")
            LANG.AddToLanguage("English", "info_popup_" .. ROLES.HITMAN.name, [[You are a Hitman! 
Try to get some credits!]])
            LANG.AddToLanguage("English", "body_found_" .. ROLES.HITMAN.abbr, "This was a Hitman...")
            LANG.AddToLanguage("English", "search_role_" .. ROLES.HITMAN.abbr, "This person was a Hitman!")
            LANG.AddToLanguage("English", "target_" .. ROLES.HITMAN.name, "Hitman")
            LANG.AddToLanguage("English", "ttt2_desc_" .. ROLES.HITMAN.name, [[The Hitman is a Traitor (who works together with the other traitors) and the goal is to kill all other roles except the other traitor roles ^^ 
The Hitman is just able to collect some credits if he kills his target.]])
            
            -- optional for toggling whether player can avoid the role
            LANG.AddToLanguage("English", "set_avoid_" .. ROLES.HITMAN.abbr, "Avoid being selected as Hitman!")
            LANG.AddToLanguage("English", "set_avoid_" .. ROLES.HITMAN.abbr .. "_tip", "Enable this to ask the server not to select you as Hitman if possible. Does not mean you are Traitor more often.")
            
            ---------------------------------

            -- maybe this language as well...
            LANG.AddToLanguage("Deutsch", ROLES.HITMAN.name, "Hitman")
            LANG.AddToLanguage("Deutsch", "info_popup_" .. ROLES.HITMAN.name, [[Du bist ein Hitman! 
Versuche ein paar Credits zu bekommen!]])
            LANG.AddToLanguage("Deutsch", "body_found_" .. ROLES.HITMAN.abbr, "Er war ein Hitman...")
            LANG.AddToLanguage("Deutsch", "search_role_" .. ROLES.HITMAN.abbr, "Diese Person war ein Hitman!")
            LANG.AddToLanguage("Deutsch", "target_" .. ROLES.HITMAN.name, "Hitman")
            LANG.AddToLanguage("Deutsch", "ttt2_desc_" .. ROLES.HITMAN.name, [[Der Hitman ist ein Verräter (der mit den anderen Verräter-Rollen zusammenarbeitet) und dessen Ziel es ist, alle anderen Rollen (außer Verräter-Rollen) zu töten ^^ 
Er kann nur Credits sammeln indem er sein Ziel tötet.]])
            
            LANG.AddToLanguage("Deutsch", "set_avoid_" .. ROLES.HITMAN.abbr, "Vermeide als Hitman ausgewählt zu werden!")
            LANG.AddToLanguage("Deutsch", "set_avoid_" .. ROLES.HITMAN.abbr .. "_tip", "Aktivieren, um beim Server anzufragen, nicht als Hitman ausgewählt zu werden. Das bedeuted nicht, dass du öfter Traitor wirst!")
        end
    end
end)
    
if SERVER then
	hook.Add("TTT2CheckCreditAward", "TTT2HitmanSpecialCreditReward", function(victim, attacker)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:IsActiveRole(ROLES.HITMAN.index) and not victim:IsTeamMember(attacker) then
			if victim == attacker.targetPlayer then
				attacker:AddCredits(1)
			end
		end
	end)
	
	-- if there is TTTC installed: sync classes
	util.AddNetworkString("TTT2HitmanSyncClasses")
	hook.Add("TTTCPostReceiveCustomClasses", "TTT2HitmanCanSeeClasses", function()
		for _, hitman in ipairs(player.GetAll()) do
			if hitman:IsActiveRole(ROLES.HITMAN.index) then
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
		
		local client = LocalPlayer()
		
		target:SetCustomClass(class)
	end)

	-- modify roles table of rolesetup addon
	hook.Add("TTTAModifyRolesTable", "ModifyRoleHitToTraitor", function(rolesTable)
		for role in pairs(rolesTable) do
			if role == ROLES.HITMAN.index then
				roles[ROLE_INNOCENT] = roles[ROLE_INNOCENT] + roles[ROLES.HITMAN.index]
			end
		end
	end)
end
