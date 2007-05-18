------------------------------------------
--	Nurfed General Functions
------------------------------------------

-- Locals
local invite
local pingflood = {}
local afkstring = Nurfed:formatgs(RAID_MEMBERS_AFK, true)
local ingroup = Nurfed:formatgs(ERR_ALREADY_IN_GROUP_S, true)

-- Default Options
NURFED_SAVED = NURFED_SAVED or {}
NURFED_BINDINGS = NURFED_BINDINGS or {}

NURFED_DEFAULT["chatfade"] = 1
NURFED_DEFAULT["chatprefix"] = false
NURFED_DEFAULT["chatbuttons"] = false
NURFED_DEFAULT["chatfadetime"] = 120
NURFED_DEFAULT["autoinvite"] = 1
NURFED_DEFAULT["invitetext"] = 1
NURFED_DEFAULT["keyword"] = "invite"
NURFED_DEFAULT["readycheck"] = 1
NURFED_DEFAULT["ping"] = 1
NURFED_DEFAULT["raidgroup"] = 1
NURFED_DEFAULT["raidclass"] = 1
NURFED_DEFAULT["repair"] = 1
NURFED_DEFAULT["repairlimit"] = 20
NURFED_DEFAULT["timestamps"] = 1
NURFED_DEFAULT["timestampsformat"] = "[%I:%M:%S]"
NURFED_DEFAULT["traineravailable"] = 1
NURFED_DEFAULT["raidclicks"] = 1
NURFED_DEFAULT["hidecasting"] = 1
NURFED_DEFAULT["squareminimap"] = false
NURFED_DEFAULT["raidsize"] = 5
NURFED_DEFAULT["lock"] = { "CENTER", "Minimap", "CENTER", -12, -80 }

local wowmenu = {
	{ CHARACTER, function() ToggleCharacter("PaperDollFrame") end },
	{ SPELLBOOK, function() ToggleSpellBook(BOOKTYPE_SPELL) end },
	{ TALENTS, function() ToggleTalentFrame() end },
	{ QUESTLOG_BUTTON, function() ToggleQuestLog() end },
	{ FRIENDS, function() ToggleFriendsFrame() end },
	{ LFG_TITLE, function() ToggleLFGParentFrame() end },
	{ BINDING_NAME_TOGGLEGAMEMENU, function() MainMenuMicroButton:Click() end },
	{ KNOWLEDGE_BASE, function() ToggleKnowledgeBaseFrame() end },
	{ KEYRING, function() ToggleKeyRing() end },
}

local onenter = function()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT")
	GameTooltip:AddLine("Nurfed UI", 0, 0.75, 1)
	GameTooltip:AddLine("Right Click - Toggle Menu", 0.75, 0.75, 0.75)
	if NRF_LOCKED then
		GameTooltip:AddLine("Left Click - |cffff0000Unlock|r UI", 0.75, 0.75, 0.75)
	else
		GameTooltip:AddLine("Left Click - |cff00ff00Lock|r UI", 0.75, 0.75, 0.75)
	end
	GameTooltip:AddLine("Middle Click - WoW Micro Menu", 0.75, 0.75, 0.75)
	GameTooltip:AddLine("Ctrl + Drag moves your Action Bars.", 0, 1, 0)
	GameTooltip:Show()
end

local onclick = function(button)
	if button == "LeftButton" then
		NRF_LOCKED = this:GetChecked()
		local icon = getglobal(this:GetName().."icon")
		if NRF_LOCKED then
			icon:SetTexture(NRF_IMG.."locked")
		else
			icon:SetTexture(NRF_IMG.."unlocked")
		end
		PlaySound("igMainMenuOption")
		onenter()
	else
		this:SetChecked(NRF_LOCKED)
		if button == "RightButton" then
			Nurfed_ToggleOptions()
		elseif button == "MiddleButton" then
			local drop = Nurfed_LockButtondropdown
			local info = {}
			if not drop.initialize then
				drop.displayMode = "MENU"
				drop.initialize = function()
					info.text = "WoW Menu"
					info.isTitle = 1
					info.notCheckable = 1
					UIDropDownMenu_AddButton(info)
					info = {}

					for _, v in ipairs(wowmenu) do
						info.text = v[1]
						info.func = v[2]
						info.notCheckable = 1
						UIDropDownMenu_AddButton(info)
					end
				end
			end
			ToggleDropDownMenu(1, nil, drop, "cursor")
		end
	end
end

local onupdate = function(self)
	if self.isMoving then
		local square = Nurfed:getopt("squareminimap")
		local xpos, ypos = GetCursorPosition()
		local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()

		xpos = xmin - xpos/Minimap:GetEffectiveScale() + 70
		ypos = ypos / Minimap:GetEffectiveScale() - ymin - 70
		local angle = math.deg(math.atan2(ypos, xpos))

		if square then
			xpos = 110 * cos(angle)
			ypos = 110 * sin(angle)
			xpos = math.max(-82, math.min(xpos,84))
			ypos = math.max(-86, math.min(ypos,82))
		else
			xpos = 80 * cos(angle)
			ypos = 80 * sin(angle)
		end
		self:SetPoint("TOPLEFT", "Minimap", "TOPLEFT", 52-xpos, ypos-52)
	end
end

local createbars = function()
	CreateFrame("Frame", "Nurfed_bags", UIParent)
	Nurfed_bags:SetClampedToScreen(true)
	Nurfed_bags:SetMovable(true)
	Nurfed_bags:SetWidth(37)
	Nurfed_bags:SetHeight(37)
	if not Nurfed_bags:IsUserPlaced() then Nurfed_bags:SetPoint("CENTER", 0, 0) end

	CreateFrame("Frame", "Nurfed_micro", UIParent)
	Nurfed_micro:SetClampedToScreen(true)
	Nurfed_micro:SetMovable(true)
	Nurfed_micro:SetWidth(29)
	Nurfed_micro:SetHeight(37)
	if not Nurfed_micro:IsUserPlaced() then Nurfed_micro:SetPoint("CENTER", 0, 0) end

	CreateFrame("Frame", "Nurfed_stance", UIParent)
	Nurfed_stance:SetClampedToScreen(true)
	Nurfed_stance:SetMovable(true)
	Nurfed_stance:SetWidth(30)
	Nurfed_stance:SetHeight(30)
	if not Nurfed_stance:IsUserPlaced() then Nurfed_stance:SetPoint("CENTER", 0, 0) end

	CreateFrame("Frame", "Nurfed_petbar", UIParent, "SecureStateDriverTemplate")
	Nurfed_petbar:SetAttribute("unit", "pet")
	Nurfed_petbar:SetClampedToScreen(true)
	Nurfed_petbar:SetMovable(true)
	Nurfed_petbar:SetWidth(30)
	Nurfed_petbar:SetHeight(30)
	if not Nurfed_petbar:IsUserPlaced() then Nurfed_petbar:SetPoint("CENTER", 0, 0) end
end

local updatebind = function(key, selectedBinding, oldKey)
	NURFED_BINDINGS[key] = nil
end

local onevent = function()
	if event == "CHAT_MSG_WHISPER" then
		local invite = Nurfed:getopt("autoinvite")
		if invite and (IsPartyLeader() or IsRaidLeader() or IsRaidOfficer() or (GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0)) then
			local text = string.lower(arg1)
			local keyword = string.lower(Nurfed:getopt("keyword"))
			if (string.find(text, "^"..keyword)) then
				InviteUnit(arg2)
				lastinvite = GetTime()
			end
		end
	elseif event == "MINIMAP_PING" then
		local show = Nurfed:getopt("ping")
		if show then
			local name = UnitName(arg1)
			if name ~= UnitName("player") and not pingflood[name] then
				Nurfed:print(name.." Ping.", nil, 1, 1, 0)
				pingflood[name] = GetTime()
			end
		end
	elseif event == "CHAT_MSG_SYSTEM" then
		if arg1 == READY_CHECK_ALL_READY or string.find(arg1, afkstring) then
			local readycheck = Nurfed:getopt("readycheck")
			if readycheck then
				SendChatMessage(arg1, "RAID")
			end
		else
			local invitetext = Nurfed:getopt("invitetext")
			if invitetext and (IsPartyLeader() or IsRaidLeader() or IsRaidOfficer()) then
				if string.find(arg1, ERR_GROUP_FULL, 1, true) and lastinvite then
					local lastTell = ChatEdit_GetLastTellTarget(DEFAULT_CHAT_FRAME.editBox)
					if lastTell ~= "" then
						SendChatMessage("Party Full", "WHISPER", this.language, lastTell)
					end
				else
					local result = { string.find(arg1, ingroup) }
					if (result[1]) then
						SendChatMessage("Drop group and resend '"..Nurfed:getopt("keyword").."'", "WHISPER", this.language, result[3])
					end
				end
			end
		end
	elseif event == "MERCHANT_SHOW" then
		local repair = Nurfed:getopt("repair")
		if repair then
			local limit = tonumber(Nurfed:getopt("repairlimit"))
			local money = tonumber(math.floor(GetMoney() / COPPER_PER_GOLD))
			if money >= limit then
				local repairAllCost, canRepair = GetRepairAllCost()
				if canRepair then
					RepairAllItems()
					local gold = math.floor(repairAllCost / (COPPER_PER_SILVER * SILVER_PER_GOLD))
					local silver = math.floor((repairAllCost - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
					local copper = math.fmod(repairAllCost, COPPER_PER_SILVER)
					Nurfed:print("|cffffffffSpent|r |c00ffff66"..gold.."g|r |c00c0c0c0"..silver.."s|r |c00cc9900"..copper.."c|r |cffffffffOn Repairs.|r")
				end
			end
		end
	elseif event == "TRAINER_SHOW" then
		local avail = Nurfed:getopt("traineravailable")
		if avail then SetTrainerServiceTypeFilter("unavailable",0) end
	elseif event == "ADDON_LOADED" then
		if arg1 == "Blizzard_InspectUI" then
			InspectPaperDollFrame:SetScript("OnShow", Nurfed_InspectOnShow)
		elseif arg1 == "Blizzard_BindingUI" then
			hooksecurefunc("KeyBindingFrame_SetBinding", updatebind)
		end
		
	elseif event == "PLAYER_LOGIN" then
		for k, v in pairs(NURFED_BINDINGS) do
			local func = getglobal("SetBinding"..v[1])
			func(k, v[2])
		end
		SaveBindings(GetCurrentBindingSet())
		nrf_togglechat()
		nrf_togglcast()
		nrf_mainmenu()
	elseif event == "VARIABLES_LOADED" then
		if this:IsUserPlaced() then
			this:SetUserPlaced(nil)
		end
		this:SetPoint(unpack(Nurfed:getopt("lock")))

		for k, v in pairs(NURFED_FRAMES.templates) do Nurfed:createtemp(k, v) end
		for k, v in pairs(NURFED_FRAMES.frames) do
			local f = Nurfed:create(k, v)
			if not v.Point then f:SetPoint("CENTER", UIParent, "CENTER") end
			Nurfed:unitimbue(f)
		end

		createbars()
		for k in pairs(NURFED_ACTIONBARS) do
			Nurfed:createbar(k)
		end

		for k, v in pairs(UIOptionsFrameSliders) do
			if v.text == "MAX_FOLLOW_DIST" then
				v.maxValue = 3.5
			end
		end
	end
end

local tbl = {
	type = "CheckButton",
	size = { 33, 33 },
	FrameStrata = "LOW",
	Checked = NRF_LOCKED,
	Movable = true,
	events = {
		"ADDON_LOADED",
		"MERCHANT_SHOW",
		"TRAINER_SHOW",
		"MINIMAP_PING",
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_SYSTEM",
		"PLAYER_LOGIN",
		"VARIABLES_LOADED",
	},
	children = {
		dropdown = { type = "Frame" },
		Border = {
			type = "Texture",
			size = { 52, 52 },
			layer = "ARTWORK",
			Texture = "Interface\\Minimap\\MiniMap-TrackingBorder",
			Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
		},
		HighlightTexture = {
			type = "Texture",
			size = { 33, 33 },
			alphaMode = "ADD",
			Texture = "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight",
			Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
		},
		icon = {
			type = "Texture",
			size = { 23, 23 },
			layer = "BACKGROUND",
			Texture = NRF_IMG.."locked",
			Anchor = { "CENTER", "$parent", "CENTER", -1, 1 },
		},
	},
	OnEvent = onevent,
	OnEnter = onenter,
	OnClick = function() onclick(arg1) end,
	OnLeave = function() GameTooltip:Hide() end,
	OnDragStart = function(self)
		self.isMoving = true
		self:SetScript("OnUpdate", function(self) onupdate(self) end)
	end,
	OnDragStop = function(self)
		self.isMoving = nil
		self:SetScript("OnUpdate", nil)
		NURFED_SAVED["lock"] = { self:GetPoint() }
		NURFED_SAVED["lock"][2] = "Minimap"
	end,
}

--[[ Init ]]--
local lock = Nurfed:create("Nurfed_LockButton", tbl, Minimap)
lock:RegisterForClicks("AnyUp")
lock:RegisterForDrag("LeftButton")
tbl = nil

-- Modify chat frames
ChatTypeInfo["CHANNEL"].sticky = 1
ChatTypeInfo["OFFICER"].sticky = 1

local OnMouseWheel = function()
	if IsShiftKeyDown() then
		if arg1 > 0 then this:PageUp()
		elseif arg1 < 0 then this:PageDown()
		end
	elseif IsControlKeyDown() then
		if arg1 > 0 then this:ScrollToTop()
		elseif arg1 < 0 then this:ScrollToBottom()
		end
	else
		if arg1 > 0 then this:ScrollUp()
		elseif arg1 < 0 then this:ScrollDown()
		end
	end
end

local message = function(this, msg, r, g, b, id)
	if (msg and type(msg) == "string") then
		if id and id == 8 and string.find(msg, "!ndkp") then return end
		local text = {}
		local pre = Nurfed:getopt("chatprefix")
		local ts = Nurfed:getopt("timestamps")
		if ts then
			local tsform = Nurfed:getopt("timestampsformat")
			local stamp = date(tsform)
			table.insert(text, stamp)
		end
		if not pre then
			msg = string.gsub(msg, "%["..CHAT_MSG_OFFICER.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_GUILD.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_PARTY.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_RAID.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_RAID_LEADER.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_RAID_WARNING.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_BATTLEGROUND.."%] ", "")
			msg = string.gsub(msg, "%["..CHAT_MSG_BATTLEGROUND_LEADER.."%] ", "")
		end
		table.insert(text, msg)
		this:O_AddMessage(table.concat(text, " "), r, g, b, id)
	end
end

CastingBarFrame.O_onevent = CastingBarFrame:GetScript("OnEvent")
CastingBarFrame.O_onupdate = CastingBarFrame:GetScript("OnUpdate")

function nrf_togglcast()
	local hide = Nurfed:getopt("hidecasting")
	if hide then
		CastingBarFrame:SetScript("OnEvent", nil)
		CastingBarFrame:SetScript("OnUpdate", nil)
		CastingBarFrame:Hide()
	else
		CastingBarFrame:SetScript("OnEvent", CastingBarFrame.O_onevent)
		CastingBarFrame:SetScript("OnUpdate", CastingBarFrame.O_onupdate)
	end
end

function nrf_togglechat()
	local buttons = Nurfed:getopt("chatbuttons")
	local fade = Nurfed:getopt("chatfade")
	local fadetime = Nurfed:getopt("chatfadetime")
	for i = 1, 7 do
		local chatframe = getglobal("ChatFrame"..i)
		local up = getglobal("ChatFrame"..i.."UpButton")
		local down = getglobal("ChatFrame"..i.."DownButton")
		local bottom = getglobal("ChatFrame"..i.."BottomButton")
		if buttons then
			up:Hide()
			down:Hide()
			bottom:Hide()
			if i == 1 then ChatFrameMenuButton:Hide() end
			chatframe:SetScript("OnShow", function() SetChatWindowShown(this:GetID(), 1) end)
		else
			up:Show()
			down:Show()
			bottom:Show()
			if i == 1 then ChatFrameMenuButton:Show() end
			chatframe:SetScript("OnShow", chatframe.O_OnShow)
		end
		chatframe:SetFading(fade)
		chatframe:SetTimeVisible(fadetime)
	end
end

local nrf_PlaySound = PlaySound
function PlaySound(snd)
	local raid = Nurfed:getopt("raidclicks")
	if snd == "igCharacterInfoTab" and raid then
		return
	end
	nrf_PlaySound(snd)
end

for i = 1, 7 do
	local chatframe = getglobal("ChatFrame"..i)
	local buttons = Nurfed:getopt("chatbuttons")
	chatframe:EnableMouseWheel(true)
	chatframe:SetScript("OnMouseWheel", OnMouseWheel)
	if not chatframe.O_AddMessage then
		chatframe.O_AddMessage = chatframe.AddMessage
		chatframe.AddMessage = message
	end
	if not chatframe.O_OnShow then
		chatframe.O_OnShow = chatframe:GetScript("OnShow")
	end
end

-- Overwrite Blizzard seconds conversion
function SecondsToTimeAbbrev(seconds)
	local time
	if seconds > 86400 then
		time = format(DAY_ONELETTER_ABBR, ceil(seconds / 86400))
	elseif seconds > 3600 then
		time = format(HOUR_ONELETTER_ABBR, ceil(seconds / 3600))
	elseif seconds > 60 then
		local min = floor(seconds / 60)
		local sec = floor(seconds-(min)*60)
		time = format("%02d:%02d", min, sec)
	else
		time = format("00:%02d", seconds)
	end
	return time
end

-- Add guild line to inspect
function Nurfed_InspectOnShow()
	InspectPaperDollFrame_OnShow()
	local guildname, guildtitle = GetGuildInfo("target")
	if guildname and guildtitle then
		InspectTitleText:SetText(format(TEXT(GUILD_TITLE_TEMPLATE), guildtitle, guildname))
		InspectTitleText:Show()
	else
		InspectTitleText:Hide()
	end
end

local flood = function()
	local now = GetTime()
	if invite and now - invite > 1 then invite = nil end
	for n, t in pairs(pingflood) do
		if now - t > 1 then pingflood[n] = nil end
	end
end

Nurfed:schedule(0.5, flood, true)