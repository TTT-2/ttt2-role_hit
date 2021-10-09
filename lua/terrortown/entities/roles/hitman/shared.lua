if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_hit.vmt")

	-- if there is TTTC installed: sync classes
	util.AddNetworkString("TTT2HitmanSyncClasses")
end

function ROLE:PreInitialize()
	self.color = Color(240, 96, 72, 255)

	self.abbr = "hit"
	self.score.surviveBonusMultiplier = 0.5
	self.score.timelimitMultiplier = -0.5
	self.score.killsMultiplier = 2
	self.score.teamKillsMultiplier = -16
	self.score.bodyFoundMuliplier = 0
	self.preventFindCredits = true
	self.preventKillCredits = true
	self.preventTraitorAloneCredits = true

	self.defaultEquipment = SPECIAL_EQUIPMENT
	self.defaultTeam = TEAM_TRAITOR

	self.conVarData = {
		pct = 0.17,
		maximum = 1,
		minPlayers = 6,
		credits = 0,
		togglable = true,
		random = 50,
		traitorButton = 1,
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
	function ROLE:AddToSettingsMenu(parent)
		local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

		form:MakeCheckBox({
			serverConvar = "ttt2_hitman_target_chatreveal",
			label = "label_hitman_target_chatreveal"
		})

		form:MakeSlider({
			serverConvar = "ttt2_hitman_target_right_score_bonus",
			label = "label_hitman_target_right_score_bonus",
			min = 0,
			max = 10,
			decimal = 0
		})

		form:MakeSlider({
			serverConvar = "ttt2_hitman_target_wrong_score_penalty",
			label = "label_hitman_target_wrong_score_penalty",
			min = 0,
			max = 10,
			decimal = 0
		})
	end

	function ROLE:AddToSettingsMenuCreditsForm(parent)
		parent:MakeSlider({
			serverConvar = "ttt2_hitman_target_credit_bonus",
			label = "label_hitman_target_credit_bonus",
			min = 0,
			max = 10,
			decimal = 0
		})
	end

	net.Receive("TTT2HitmanSyncClasses", function(len)
		local target = net.ReadEntity()
		local class = net.ReadUInt(CLASS_BITS)

		if class == 0 then
			class = nil
		end

		target:SetClass(class)
	end)
end
