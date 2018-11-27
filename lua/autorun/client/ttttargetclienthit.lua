-- Please ask me if you want to use parts of this code!
-- FG Addon Heading
local Version = "2.1 excluded (TTT2 - HITMAN Role)"

-- Table with addons
TTTFGAddons = TTTFGAddons or {}

table.insert(TTTFGAddons, "TTT Target for TTT2 HITMAN Role")

-- ConVar for disabling
local ChatMessage = CreateClientConVar("ttt_fgaddons_textmessage", "1", true, false, "Enables or disables the message in the chat. (Def: 1)")

-- Hook for printing
hook.Add("TTTBeginRound", "TTTBeginRound4TTTFGAddons", function()
	local String = ""

	for i = 1, #TTTFGAddons do
		if String == "" then
			String = TTTFGAddons[i]
		else
			String = String .. ", " .. TTTFGAddons[i]
		end
	end

	if ChatMessage:GetBool() then
		chat.AddText("TTT FG Addons: ", Color(255, 255, 255), "You are running " .. String .. ".")
		chat.AddText("TTT FG Addons: ", Color(255, 255, 255), "Be sure to check out the Settings in the ", Color(255, 0, 0), "F1", Color(255, 255, 255), " menu.")
		chat.AddText("TTT FG Addons: ", Color(255, 255, 255), "You can disable this message in the Settings (", Color(255, 0, 0), "F1", Color(255, 255, 255), ").")
	end
end)

-- default Variables and Tables
local Target = {}
local PrintTarget = ""
local Key_box2 = 0
local KeySelected2 = ""

-- request Targets
function SetHitTarget()
	if not TTT2 then return end

	local ply = LocalPlayer()

	if IsValid(ply) and not ply:IsSpec() and ply:IsActive() and ply:GetSubRole() == ROLE_HITMAN then
		net.Start("TTTTargetHit")
		net.SendToServer()
	end
end

hook.Add("TTT2UpdateSubrole", "T3SetR4T3TarClHit", SetHitTarget)

hook.Add("TTTBeginRound", "T3BegR4T3TarClHit", SetHitTarget)

-- Receive Targets
net.Receive("TTTTargetHit", function(len)
	Target = net.ReadEntity()

	local Bool = net.ReadBool()
	if not Bool then
		if Target:IsActive() then
			CLA = Target:GetSubRoleData().color
			CLB = Target:GetSubRoleData().dkcolor
		end

		PrintTarget = Target:GetName()
	else
		PrintTarget = " - "
	end
end)

-- Chat Messages
net.Receive("TTTTargetChatRevealHit", function()
	local Text = net.ReadString()

	chat.AddText("TTT Target: ", Color(255, 0, 0), Text, Color(255, 255, 255), " is HITMAN. (Revealed because he killed a nontarget)")
end)

net.Receive("TTTTargetChatHit", function()
	local Text = net.ReadString()

	chat.AddText("TTT Target: ", Color(255, 255, 255), Text)
end)

-- Creating Font
surface.CreateFont("HUDFont", {font = "Trebuchet24", size = 24, weight = 750})

-- ConVars
local PreviewRendering = CreateClientConVar("ttt_target_hud_preview", "0", true, false, "Renders the HUD. Def: 0")
local xPos = CreateClientConVar("ttt_target_hud_offset_x", "15", true, false, "The x offset of the HUD. Def: 15")
local yPos = CreateClientConVar("ttt_target_hud_offset_y", "180", true, false, "The y offset of the HUD. Def: 180")
local alignment = CreateClientConVar("ttt_target_hud_alignment", "0", true, false, "The alignment of the hud. (0 = bottom, left; 1 = top, left; 2 = top, right; 3 = bottom, right) Def: 0")

-- The HUD function (inspired by Health Bar in TTT)
local function HUD(name, xP, yP, al, ColorA, ColorB, value, maximum)
	-- Number or String?
	local valueNumber = value
	local number = true

	if maximum == 0 then
		valueNumber = 1
		maximum = 1
		number = false
	end

	-- Convert to numbers
	xP = xP:GetFloat()
	yP = yP:GetFloat()
	al = al:GetFloat()

	-- Get real X and Y (alignment)
	local x = 0
	local y = 0

	if al == 1 then
		x = xP
		y = yP
	elseif al == 2 then
		x = ScrW() - xP
		y = yP
	elseif al == 3 then
		x = ScrW() - xP
		y = ScrH() - yP
	else
		x = xP
		y = ScrH() - yP
	end

	if not hook.Run("HUDShouldDraw", "TTT2HitmanMarker", name, x, y, ColorA, ColorB, value, maximum) then return end

	-- Drawing
	draw.RoundedBox(8, x - 5, y - 10, 250, 60, Color(0, 0, 0, 200))
	draw.RoundedBox(8, x + 4, y + 4, 232, 27, ColorB)
	surface.SetDrawColor(ColorA)

	local tmp = 230 / maximum * valueNumber
	if tmp > 0 then
		surface.DrawRect(x + 12, y + 5, tmp - 14, 25)
		surface.DrawRect(x + 5, y + 13, 8, 9)
		surface.SetTexture(surface.GetTextureID("gui/corner8"))
		surface.DrawTexturedRectRotated(x + 9, y + 9, 8, 8, 0)
		surface.DrawTexturedRectRotated(x + 9, y + 26, 8, 8, 90)

		if tmp > 13 then
			surface.DrawRect(x + tmp - 3, y + 13, 8, 9)
			surface.DrawTexturedRectRotated(x + 1 + tmp, y + 9, 8, 8, 270)
			surface.DrawTexturedRectRotated(x + 1 + tmp, y + 26, 8, 8, 180)
		else
			surface.DrawRect(x + 5 + math.max(tmp - 8, 8), y + 5, 4, 25)
		end
	end

	-- Texts with shaddow
	if number then
		draw.SimpleText(math.floor(value), "HUDFont", x + 215, y + 7, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.SimpleText(math.floor(value), "HUDFont", x + 213, y + 5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	else
		draw.SimpleText(value, "HUDFont", x + 17, y + 7, Color(0, 0, 0), TEXT_ALIGN_LEFT)
		draw.SimpleText(value, "HUDFont", x + 15, y + 5, Color(255, 255, 255), TEXT_ALIGN_LEFT)
	end

	draw.SimpleText(name, "TabLarge", x + 194, y - 17, Color(255, 255, 255))
end

-- Painting of the HUD
hook.Add("HUDPaint", "HUDPaint4TTTTargetHit", function()
	if not TTT2 or not TEAM_SPEC then return end

	local ply = LocalPlayer()

	--colors
	if PreviewRendering:GetBool() then
		HUD("TARGET", xPos, yPos, alignment, Color(55, 55, 55, 255), Color(0, 0, 0, 255), "Target", 0)
	else
		local clA = CLA or Color(55, 55, 55, 255)
		local clB = CLB or Color(0, 0, 0, 255)

		if ply.Alive and ply:Alive() and ply:IsTerror() and not ply:IsSpec() and ply.GetSubRole and ply:GetSubRole() and ply:GetSubRole() == ROLE_HITMAN then
			HUD("TARGET", xPos, yPos, alignment, clA, clB, PrintTarget, 0)
		end
	end
end)

-- Settings
-- Presets
local function DefaultI()
	RunConsoleCommand("ttt_target_hud_alignment", "0")
	RunConsoleCommand("ttt_target_hud_offset_x", tostring(ScrW() * 0.5 - 125))
	RunConsoleCommand("ttt_target_hud_offset_y", "60")

	Key_box2:SetValue("Bottom, left")
end

local function DefaultII()
	RunConsoleCommand("ttt_target_hud_alignment", "0")
	RunConsoleCommand("ttt_target_hud_offset_x", "15")
	RunConsoleCommand("ttt_target_hud_offset_y", "180")

	Key_box2:SetValue("Bottom, left")
end

local function DefaultIII()
	RunConsoleCommand("ttt_target_hud_alignment", "3")
	RunConsoleCommand("ttt_target_hud_offset_x", "255")
	RunConsoleCommand("ttt_target_hud_offset_y", "60")

	Key_box2:SetValue("Bottom, right")
end

local function DefaultIV()
	RunConsoleCommand("ttt_target_hud_alignment", "0")
	RunConsoleCommand("ttt_target_hud_offset_x", "275")
	RunConsoleCommand("ttt_target_hud_offset_y", "60")

	Key_box2:SetValue("Bottom, left")
end

local function DefaultV()
	RunConsoleCommand("ttt_target_hud_alignment", "0")
	RunConsoleCommand("ttt_target_hud_offset_x", "275")
	RunConsoleCommand("ttt_target_hud_offset_y", "120")

	Key_box2:SetValue("Bottom, left")
end

local function DefaultVI()
	RunConsoleCommand("ttt_target_hud_alignment", "0")
	RunConsoleCommand("ttt_target_hud_offset_x", "275")
	RunConsoleCommand("ttt_target_hud_offset_y", "180")

	Key_box2:SetValue("Bottom, left")
end

-- Settings Hook
hook.Add("TTTSettingsTabs", "TTTTarget4TTTSettingsTabsHit", function(dtabs)
	if not TTT2 then return end

	local ply = LocalPlayer()

	if not IsValid(ply) or not ply.GetSubRole or ply:GetSubRole() ~= ROLE_HITMAN then return end

	local parent = dtabs:GetParent()

	function parent:OnClose()
		RunConsoleCommand("ttt_target_hud_preview", "0")
	end

	local settings_panel = vgui.Create("DPanelList", dtabs)
	settings_panel:StretchToParent(0, 0, dtabs:GetPadding() * 2, 0)
	settings_panel:EnableVerticalScrollbar(true)
	settings_panel:SetPadding(10)
	settings_panel:SetSpacing(10)

	dtabs:AddSheet("Target", settings_panel, "icon16/user_red.png", false, false, "The target settings")

	local AddonList = vgui.Create("DIconLayout", settings_panel)
	AddonList:SetSpaceX(5)
	AddonList:SetSpaceY(5)
	AddonList:Dock(FILL)
	AddonList:DockMargin(5, 5, 5, 5)
	AddonList:DockPadding(10, 10, 10, 10)

	-- General Settings
	local General_Settings = vgui.Create("DForm")
	General_Settings:SetSpacing(10)
	General_Settings:SetName("General settings")
	General_Settings:SetWide(settings_panel:GetWide() - 30)

	settings_panel:AddItem(General_Settings)

	General_Settings:CheckBox("Print chat message at the beginning of the round (TTT FG Addons)", "ttt_fgaddons_textmessage")

	-- HUD Positioning
	local settings_target_tab = vgui.Create("DForm")
	settings_target_tab:SetSpacing(10)
	settings_target_tab:SetName("HUD Positioning")
	settings_target_tab:SetWide(settings_panel:GetWide() - 30)

	settings_panel:AddItem(settings_target_tab)

	settings_target_tab:CheckBox("Show Preview", "ttt_target_hud_preview")

	Key_box2 = vgui.Create("DComboBox")

	if alignment == 1 then
		KeySelected2 = "Top, left"
	elseif alignment == 2 then
		KeySelected2 = "Top, right"
	elseif alignment == 3 then
		KeySelected2 = "Bottom, right"
	else
		KeySelected2 = "Bottom, left"
	end

	Key_box2:Clear()
	Key_box2:SetValue(KeySelected2)
	Key_box2:AddChoice("Bottom, left")
	Key_box2:AddChoice("Top, left")
	Key_box2:AddChoice("Top, right")
	Key_box2:AddChoice("Bottom, right")

	settings_target_tab:AddItem(Key_box2)

	function Key_box2:OnSelect(table_key_box, Ausgewaehlt, data_key_box)
		if Ausgewaehlt == "Bottom, left" then
			RunConsoleCommand("ttt_target_hud_alignment", "0")
		elseif Ausgewaehlt == "Top, left" then
			RunConsoleCommand("ttt_target_hud_alignment", "1")
		elseif Ausgewaehlt == "Top, right" then
			RunConsoleCommand("ttt_target_hud_alignment", "2")
		elseif Ausgewaehlt == "Bottom, right" then
			RunConsoleCommand("ttt_target_hud_alignment", "3")
		end

		KeySelected2 = Ausgewaehlt
	end

	settings_target_tab:NumSlider("X Offset", "ttt_target_hud_offset_x", 0, ScrW(), 0)
	settings_target_tab:NumSlider("Y Offset", "ttt_target_hud_offset_y", 0, ScrH(), 0)

	local Settings_text = vgui.Create("DLabel", General_Settings)
	Settings_text:SetText("Presets:")
	Settings_text:SetColor(Color(0, 0, 0))

	settings_target_tab:AddItem(Settings_text)

	local DefaultI_button = vgui.Create("DButton")
	DefaultI_button:SetText("Lower middle")
	DefaultI_button.DoClick = DefaultI

	settings_target_tab:AddItem(DefaultI_button)

	local DefaultII_button = vgui.Create("DButton")
	DefaultII_button:SetText("On top of role")
	DefaultII_button.DoClick = DefaultII

	settings_target_tab:AddItem(DefaultII_button)

	local DefaultIII_button = vgui.Create("DButton")
	DefaultIII_button:SetText("Lower right corner")
	DefaultIII_button.DoClick = DefaultIII

	settings_target_tab:AddItem(DefaultIII_button)

	local DefaultIV_button = vgui.Create("DButton")
	DefaultIV_button:SetText("Next to role")
	DefaultIV_button.DoClick = DefaultIV

	settings_target_tab:AddItem(DefaultIV_button)

	local DefaultV_button = vgui.Create("DButton")
	DefaultV_button:SetText("Next to role 2")
	DefaultV_button.DoClick = DefaultV

	settings_target_tab:AddItem(DefaultV_button)

	local DefaultVI_button = vgui.Create("DButton")
	DefaultVI_button:SetText("Next to role 3")
	DefaultVI_button.DoClick = DefaultVI

	settings_target_tab:AddItem(DefaultVI_button)

	settings_target_tab:SizeToContents()

	local Version_text = vgui.Create("DLabel", General_Settings)
	Version_text:SetText("Version: " .. Version .. " by Fresh Garry & Alf21")
	Version_text:SetColor(Color(100, 100, 100))

	settings_panel:AddItem(Version_text)
end)
