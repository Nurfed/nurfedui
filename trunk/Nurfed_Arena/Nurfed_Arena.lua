local targets = {}
local inqueue

local eclass = {
	["WARRIOR"]	= {0, 0.25, 0, 0.25},
	["MAGE"]	= {0.25, 0.49609375, 0, 0.25},
	["ROGUE"]	= {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"]	= {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"]	= {0, 0.25, 0.25, 0.5},
	["SHAMAN"]	= {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"]	= {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"]	= {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"]	= {0, 0.25, 0.5, 0.75},
}

local frame = CreateFrame("Frame", nil, UIParent)
frame:SetWidth(150)
frame:SetHeight(16)
frame:SetPoint("CENTER", 0, 0)
frame:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, })
frame:SetBackdropColor(0, 0, 0, 0.75)
frame:EnableMouse(true)
frame:SetMovable(true)
frame:SetClampedToScreen(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", function(self) if not NRF_LOCKED then self:StartMoving() end end)
frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")

local title = frame:CreateFontString(nil, "ARTWORK")
title:SetFont(STANDARD_TEXT_FONT, 10)
title:SetPoint("CENTER", 0, 0)
title:SetText("Nurfed Arena")

for i = 1, 3 do
	local score = getglobal("PVPTeam"..i):CreateFontString("PVPTeam"..i.."points", "ARTWORK")
	score:SetFont(STANDARD_TEXT_FONT, 10)
	score:SetTextColor(0, 1, 0)
	score:SetPoint("LEFT", 15, -4)
end


for i = 1, 5 do
	local button = CreateFrame("Button", "Nurfed_Arena"..i, frame, "SecureActionButtonTemplate")
	button:SetWidth(145)
	button:SetHeight(16)
	button:RegisterForClicks("AnyUp")
	button:SetAttribute("type1", "macro")
	button:SetAttribute("type2", "macro")
	if i == 1 then
		button:SetPoint("TOP", frame, "BOTTOM", 0, 1)
	else
		button:SetPoint("TOP", getglobal("Nurfed_Arena"..(i - 1)), "BOTTOM", 0, 0)
	end

	button.icon = button:CreateTexture(nil, "ARTWORK")
	button.icon:SetWidth(16)
	button.icon:SetHeight(16)
	button.icon:SetPoint("LEFT", 0, 0)
	button.icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
	button.icon:SetTexCoord(0.49609375, 0.7421875, 0.25, 0.5)


	button.bar = CreateFrame("StatusBar", "Nurfed_Arena"..i.."hp", button)
	button.bar:SetWidth(129)
	button.bar:SetHeight(16)
	button.bar:SetPoint("LEFT", button.icon, "RIGHT", 0, 0)
	button.bar:SetMinMaxValues(0, 100)
	button.bar:SetValue(100)
	button.bar:SetStatusBarTexture(NRF_IMG.."statusbar5")
	button.bar:SetStatusBarColor(0, 1, 0)

	button.name = button.bar:CreateFontString(nil, "ARTWORK")
	button.name:SetFont(STANDARD_TEXT_FONT, 10)
	button.name:SetPoint("LEFT", 0, 0)

	button.perc = button.bar:CreateFontString(nil, "ARTWORK")
	button.perc:SetFont(STANDARD_TEXT_FONT, 10)
	button.perc:SetPoint("RIGHT", 0, 0)

	button:Hide()
end

local showunit = function(self, event)
	self:UnregisterEvent(event)
	self:Show()
	self:SetAttribute("macrotext", "/target "..self.name:GetText())
end

local addunit = function(name, class)
	table.insert(targets, name)
	local button = getglobal("Nurfed_Arena"..#targets)
	button.name:SetText(name)
	local coord = eclass[class]
	if coord then
		button.icon:SetTexCoord(unpack(coord))
	end
	if not InCombatLockdown() then
		button:Show()
		button:SetAttribute("macrotext", "/target "..name)
	else
		button:RegisterEvent("PLAYER_REGEN_ENABLED")
		button:SetScript("OnEvent", showunit)
	end
	return #targets
end

local updateunit = function(unit, name, class, health, isdead)
	local num, button, r, g
	if unit then
		if UnitIsEnemy("player", unit) and UnitIsPlayer(unit) and not UnitInParty(unit) then
			name = UnitName(unit)
			if name == UNKNOWN then return end
			health = UnitHealth(unit)
			class = select(2, UnitClass(unit))
			isdead = UnitIsDead(unit)
			if not isdead then
				SendAddonMessage("NRF_ARENA", name..":"..class..":"..health, "BATTLEGROUND")
			end
		end
	end

	if name and health then
		for k, v in ipairs(targets) do
			if v == name then
				num = k
				break
			end
		end

		if not num then
			if class then
				num = addunit(name, class)
			else
				return
			end
		end

		local perc = health / 100
		if perc > 0.5 then
			r = (1.0 - perc) * 2
			g = 1.0
		else
			r = 1.0
			g = perc * 2
		end

		button = getglobal("Nurfed_Arena"..num)
		button.bar:SetValue(health)
		button.bar:SetStatusBarColor(r, g, 0)
		if isdead then
			button.perc:SetText("Dead")
		else
			button.perc:SetText(health.."%")
		end
	end
end

local updateguild = function()
	local status, mapName, instanceID, levelRangeMin, levelRangeMax, teamSize, registeredMatch
	for i = 1, MAX_BATTLEFIELD_QUEUES do
		status, mapName, instanceID, levelRangeMin, levelRangeMax, teamSize, registeredMatch = GetBattlefieldStatus(i)
		if registeredMatch then
			if status == "queued" then
				if not inqueue then
					inqueue = true
					if IsPartyLeader() then
						SendChatMessage("*** QUEUED FOR: "..teamSize.."v"..teamSize.." ***","GUILD")
					end
				end
			elseif status == "confirm" then
				inqueue = nil
				if IsPartyLeader() then
					SendChatMessage("*** WE ARE IN "..mapName.." ("..instanceID..") ***","GUILD")
				end
			elseif status == "none" then
				inqueue = nil
			end
		end
	end
end

local onevent = function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		local _, instance = IsInInstance()
		if instance == "arena" then
			targets = {}
			self:Show()
			self:RegisterEvent("CHAT_MSG_ADDON")
			self:RegisterEvent("UNIT_HEALTH")
			self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
			self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
			self:RegisterEvent("PLAYER_TARGET_CHANGED")
		else
			self:UnregisterEvent("CHAT_MSG_ADDON")
			self:UnregisterEvent("UNIT_HEALTH")
			self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
			self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
			self:UnregisterEvent("PLAYER_TARGET_CHANGED")
			if InCombatLockdown() then
				self:SetScript("OnUpdate", function(self)
						local _, instance = IsInInstance()
						if not InCombatLockdown() and instance ~= "arena" then
							for i = 1, 5 do
								getglobal("Nurfed_Arena"..i):Hide()
							end
							self:Hide()
							self:SetScript("OnUpdate", nil)
						end
					end)
			else
				for i = 1, 5 do
					getglobal("Nurfed_Arena"..i):Hide()
				end
				self:Hide()
			end
		end
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		updateunit("mouseover")
	elseif event == "PLAYER_TARGET_CHANGED" then
		updateunit("target")
	elseif event == "UNIT_HEALTH" and (arg1 == "mouseover" or arg1 == "target" or arg1 == "focus") then
		updateunit(arg1)
	elseif event == "CHAT_MSG_ADDON" and arg1 == "NRF_ARENA" then
		local name, class, health = string.split(":", arg2)
		if arg4 ~= UnitName("player") then
			updateunit(nil, name, class, health)
		end
	elseif event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
		local _, _, name = string.find(arg1, "^(.+) dies")
		updateunit(nil, name, nil, 0, 1)
	elseif event == "UPDATE_BATTLEFIELD_STATUS" then
		updateguild()
	end
end

frame:SetScript("OnEvent", onevent)

local rating = function()
	local size, rating, score, points
	local buttonIndex = 0
	local ARENA_TEAMS = {};
	ARENA_TEAMS[1] = {size = 2}
	ARENA_TEAMS[2] = {size = 3}
	ARENA_TEAMS[3] = {size = 5}

	for index, value in pairs(ARENA_TEAMS) do
		for i = 1, MAX_ARENA_TEAMS do
			teamName, teamSize = GetArenaTeam(i)
			if value.size == teamSize then
				value.index = i
			end
		end
	end

	for index, value in pairs(ARENA_TEAMS) do
		if value.index then
			_, size, rating = GetArenaTeam(value.index);
			buttonIndex = buttonIndex + 1
			score = getglobal("PVPTeam"..buttonIndex.."points")

			if rating > 1500 then
				points = 2894 / (1 + 259 * math.pow(2.718281828459, (-0.0025 * rating)))
			else
				points = (0.206 * rating) + 99
			end
			points = points + 0.5

			if size == 2 then
				points = points * 0.6
			elseif size == 3 then
				points = points * 0.8
			end

			score:SetText(format("%d", points))
		end
	end
end

hooksecurefunc("PVPFrame_OnShow", rating)