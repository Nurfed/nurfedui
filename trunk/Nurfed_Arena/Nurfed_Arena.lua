NURFED_DEFAULT["arenascale"] = 1
NURFED_DEFAULT["arenamacro1"] = "/target $name"
NURFED_DEFAULT["arenamacro2"] = "/target $name\n/assist"

local _G = getfenv(0)
local teams, targets = {}, {}
local queued = { {}, {}, {} }
local slain = Nurfed:formatgs(SELFKILLOTHER, true)
local dies = Nurfed:formatgs(UNITDIESOTHER, true)

local getteam = function(size)
	for i = 1, MAX_ARENA_TEAMS do
		local teamName, teamSize = GetArenaTeam(i)
		if teamSize == size then
			return teamName
		end
	end
end

local inparty = function(name)
	for i = 1, GetNumPartyMembers() do
		if UnitName("party"..i) == name then
			return true
		end
	end
end

local updateunit = function(unit, name, class, health, isdead)
	if unit then
		if UnitIsEnemy("player", unit) and UnitIsPlayer(unit) then
			name = UnitName(unit)
			health = UnitHealth(unit)
			class = select(2, UnitClass(unit))
			isdead = UnitIsDead(unit)
			if not isdead then
				SendAddonMessage("Nurfed:Arn", "unit:"..name..":"..class..":"..health, "BATTLEGROUND")
			end
		end
	end

	if name and health then
		if not targets[name] then
			table.insert(targets, name)
			targets[name] = #targets
		end

		local id = targets[name]
		local btn = _G["Nurfed_Arena"..id]

		if not btn then
			btn = Nurfed:create("Nurfed_Arena"..id, "arena_unit", Nurfed_Arena)
			if id == 1 then
				btn:SetPoint("TOP", Nurfed_Arena, "BOTTOM", 0, 1)
			else
				btn:SetPoint("TOP", _G["Nurfed_Arena"..(id - 1)], "BOTTOM", 0, 0)
			end
			btn:SetAttribute("*type1", "macro")
			btn:SetAttribute("*type2", "macro")
			btn.hp = _G["Nurfed_Arena"..id.."hp"]
			btn.perc = _G["Nurfed_Arena"..id.."hpperc"]
		end

		if not btn:IsShown() then
			btn.name = name
			local _, coords = Nurfed:getclassicon(class, true)
			_G["Nurfed_Arena"..id.."hpname"]:SetText(name)
			if coords then
				_G["Nurfed_Arena"..id.."icon"]:SetTexCoord(unpack(coords))
			end
			if not InCombatLockdown() then
				btn:Show()
			else
				btn:RegisterEvent("PLAYER_REGEN_ENABLED")
				btn:SetScript("OnEvent", function(self, event)
						self:UnregisterEvent(event)
						self:Show()
					end)
			end
		end

		local r, g, b
		local perc = health / 100
		if perc > 0.5 then
			r = (1.0 - perc) * 2
			g = 1.0
		else
			r = 1.0
			g = perc * 2
		end
		btn.hp:SetValue(health)
		btn.hp:SetStatusBarColor(r, g, 0)

		if isdead then
			btn:SetAlpha(0.25)
			btn.perc:SetText("Dead")
		else
			btn:SetAlpha(1)
			btn.perc:SetText(health.."%")
		end
	end
end

local events = {
	["UPDATE_MOUSEOVER_UNIT"] = function()
		if select(2, IsInInstance()) == "arena" then
			if not inparty(UnitName("mouseover")) then
				updateunit("mouseover")
			end
		end
	end,
	["PLAYER_TARGET_CHANGED"] = function()
		if select(2, IsInInstance()) == "arena" then
			if not inparty(UnitName("target")) then
				updateunit("target")
			end
		end
	end,
	["UNIT_HEALTH"] = function(event, ...)
		if select(2, IsInInstance()) == "arena" then
			if arg1 == "mouseover" or arg1 == "target" or arg1 == "focus" then
				if not inparty(UnitName(arg1)) then
					updateunit(arg1)
				end
			end
		end
	end,
	["CHAT_MSG_COMBAT_HOSTILE_DEATH"] = function(event, ...)
		if select(2, IsInInstance()) == "arena" then
			local _, _, name = string.find(arg1, dies)
			if not name then
				local _, _, name = string.find(arg1, slain)
			end

			if name and targets[name] then
				updateunit(nil, name, nil, 0, true)
			end
		end
	end,
	["UPDATE_BATTLEFIELD_STATUS"] = function()
		local status, mapName, instanceID, levelRangeMin, levelRangeMax, teamSize, registeredMatch
		for i = 1, MAX_BATTLEFIELD_QUEUES do
			status, mapName, instanceID, levelRangeMin, levelRangeMax, teamSize, registeredMatch = GetBattlefieldStatus(i)
			if registeredMatch then
				local team = getteam(teamSize)
				local id = 1
				if teamSize == 3 then
					id = 2
				elseif teamSize == 5 then
					id = 3
				end
				SendAddonMessage("Nurfed:Arn", status..":"..id..":"..team..":"..teamSize, "GUILD")
			end
		end
	end,
	["PLAYER_ENTERING_WORLD"] = function()
		if select(2, IsInInstance()) == "arena" then
			Nurfed_Arena:Show()
		else
			if NRF_LOCKED then
				Nurfed_Arena:Hide()
			end
			for i = 1, #targets do
				local btn = _G["Nurfed_Arena"..i]
				if btn then
					btn:Hide()
				end
			end
			targets = {}
		end
	end,
	["PLAYER_LOGIN"] = function()
		if not Nurfed_Arena:IsUserPlaced() then
			Nurfed_Arena:SetPoint("CENTER")
		end
		local scale = Nurfed:getopt("arenascale")
		Nurfed_Arena:SetScale(scale)
	end,
	["NURFED_LOCK"] = function()
		local _, instance = IsInInstance()
		if instance ~= "arena" then
			if NRF_LOCKED then
				Nurfed_Arena:Hide()
			else
				Nurfed_Arena:Show()
			end
		end
	end,
}

for event, func in pairs(events) do
	Nurfed:regevent(event, func)
end

local addonmsg = function(name, cmd)
	local cm, arg = string.split(":", cmd, 2)
	if cm == "queued" or cm == "confirm" or cm == "none" then
		local id, team, size = string.split(":", arg)
		id = tonumber(id)
		if cm == "queued" then
			queued[id][team] = true
		elseif queued[id][team] then
			queued[id][team] = nil
			local myteam = getteam(size)
			if not myteam then
				Nurfed:print("Nurfed Arena: |cffff0000"..team.."|r No Longer In Queue ("..size.."v"..size..")!", 1, 0, 0.75, 1)
			end
		end
	end
end

Nurfed:addmsg("Arn", addonmsg)

for i = 1, 3 do
	local zone = getglobal("ArenaZone"..i)
	zone:HookScript("OnClick", function(self)
			local text = "Currently Queued"
			for team in pairs(queued[self:GetID()]) do
				text = text.."\n   |cffffffff"..team.."|r"
			end
			ArenaFrameZoneDescription:SetText(text)
		end)
end

ArenaFrame:SetScript("OnShow", function(self)
		PlaySound("igCharacterInfoOpen")
		ArenaZone1:Click()
	end)

Nurfed:create("Nurfed_Arena", {
	type = "Frame",
	size = { 150, 16 },
	Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 12,
		edgeSize = 10,
		insets = { left = 2, right = 2, top = 2, bottom = 2 },
	},
	BackdropColor = { 0, 0, 0, 0.75 },
	Mouse = true,
	Movable = true,
	ClampedToScreen = true,
	children = {
		title = {
			type = "FontString",
			Font = { STANDARD_TEXT_FONT, 10 },
			Point = "CENTER",
			Text = "Nurfed Arena",
		},
	},
	RegisterForDrag = "LeftButton",
	OnDragStart = function(self)
		if not NRF_LOCKED then self:StartMoving() end
	end,
	OnDragStop = function(self)
		self:StopMovingOrSizing()
	end,
})

Nurfed:createtemp("arena_unit", {
	type = "Button",
	uitemp = "SecureActionButtonTemplate",
	size = { 145, 16 },
	RegisterForClicks = "AnyUp",
	Hide = true,
	children = {
		icon = {
			type = "Texture",
			size = { 16, 16 },
			Anchor = { "LEFT" },
			Texture = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes",
		},
		hp = {
			type = "StatusBar",
			size = { 129, 16 },
			Anchor = { "RIGHT" },
			StatusBarTexture = NRF_IMG.."statusbar5",
			MinMaxValues = { 0, 100 },
			children = {
				name = {
					type = "FontString",
					Anchor = "all",
					Font = { STANDARD_TEXT_FONT, 10 },
					JustifyH = "LEFT",
				},
				perc = {
					type = "FontString",
					Anchor = "all",
					Font = { STANDARD_TEXT_FONT, 10 },
					JustifyH = "RIGHT",
				},
			},
		},
	},
	OnShow = function(self)
		local macro1 = Nurfed:getopt("arenamacro1")
		local macro2 = Nurfed:getopt("arenamacro2")
		macro1 = string.gsub(macro1, "$name", self.name)
		macro2 = string.gsub(macro2, "$name", self.name)
		self:SetAttribute("macrotext1", macro1)
		self:SetAttribute("macrotext2", macro2)
	end,
})

--[[


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

ArenaZone1:HookScript("OnClick", function()
		ArenaFrameZoneDescription:SetText("2v2 Arena")
	end)
ArenaZone2:HookScript("OnClick", function()
		ArenaFrameZoneDescription:SetText("3v3 Arena")
	end)
ArenaZone3:HookScript("OnClick", function()
		ArenaFrameZoneDescription:SetText("5v5 Arena")
	end)
]]