---------------------------------------------------------
-- Nurfed CombatLog
assert(Nurfed, "Nurfed must be enabled for Nurfed_CombatLog to work.")
local _G = getfenv(0)
local bitband = _G.bit.band
local SPELLCASTGOOTHER = "%s casts %s."
local AURAADDEDOTHERHELPFUL = "%s gains %s."
local COMBATLOG_OBJECT_REACTION_HOSTILE = _G.COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER
local classLst = {}
NURFED_COMBATLOG_SAVED = NURFED_COMBATLOG_SAVED or {
	spell = {
		enabled = true,
		height = 90,
		width = UIParent:GetWidth(),
		insertMode = "TOP",
		visibleTime = 1,
		fadeDuration = 0.5,
		fontHeight = 18,
		fontStyle = "OUTLINE",
		fontJustifyH = "CENTER",
	},
	buff = {
		enabled = true,
		height = 90,
		width = UIParent:GetWidth(),
		insertMode = "TOP",
		visibleTime = 1,
		fadeDuration = 0.5,
		fontHeight = 18,
		fontStyle = "OUTLINE",
		fontJustifyH = "CENTER",
	},
}


local eventLst = { ["SPELL_CAST_SUCCESS"] = true, ["SPELL_CAST_START"] = true, ["SPELL_AURA_APPLIED"] = true, }
local function onevent(_, _, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, id, spellName, spellSchool, spellType, spellName2)
	if not eventLst[event] then return end
	if event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_START" then	-- both use source
		if bitband(COMBATLOG_OBJECT_REACTION_HOSTILE, srcFlags) ~= 0 and bitband(COMBATLOG_OBJECT_CONTROL_PLAYER, srcFlags) ~= 0 then
			if classLst[srcName] then
				srcName = classLst[srcName]..srcName.."|r"
			end
			Nurfed_SpellAlert:AddMessage("|T"..select(3, GetSpellInfo(id))..":24:24:-5|t"..SPELLCASTGOOTHER:format(srcName, "|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r"))
		end
		
	elseif event == "SPELL_AURA_APPLIED" and spellType == "BUFF" then	-- uses destFlags
		if bitband(COMBATLOG_OBJECT_REACTION_HOSTILE, dstFlags) ~= 0 and bitband(COMBATLOG_OBJECT_CONTROL_PLAYER, dstFlags) ~= 0 then
			if classLst[dstName] then
				dstName = classLst[dstName]..dstName.."|r"
			end
			Nurfed_BuffAlert:AddMessage("|T"..select(3, GetSpellInfo(id))..":24:24:-5|t"..AURAADDEDOTHERHELPFUL:format(dstName, "|c"..CombatLog_Color_ColorStringBySchool(spellSchool)..spellName.."|r"))
		end
	end
end

local function zonechange()
	if GetZonePVPInfo() == "sanctuary" then
		Nurfed:unregevent("COMBAT_LOG_EVENT_UNFILTERED", onevent)
	else
		Nurfed:regevent("COMBAT_LOG_EVENT_UNFILTERED", onevent)
	end
end


Nurfed:regevent("PLAYER_LOGIN", zonechange)
Nurfed:regevent("ZONE_CHANGED_NEW_AREA", zonechange)
Nurfed:regevent("NURFED_COMBATLOG_SETTINGS_CHANGED", function()
	Nurfed_SpellAlert:SetWidth(NURFED_COMBATLOG_SAVED.spell.width)
	Nurfed_SpellAlert:SetHeight(NURFED_COMBATLOG_SAVED.spell.height)
	Nurfed_SpellAlert:SetInsertMode(NURFED_COMBATLOG_SAVED.spell.insertMode)
	Nurfed_SpellAlert:SetTimeVisible(NURFED_COMBATLOG_SAVED.spell.visibleTime)
	Nurfed_SpellAlert:SetFadeDuration(NURFED_COMBATLOG_SAVED.spell.fadeDuration)
	Nurfed_SpellAlert:SetFont("Fonts\\FRIZQT__.TTF", NURFED_COMBATLOG_SAVED.spell.fontHeight, NURFED_COMBATLOG_SAVED.spell.fontStyle)
	Nurfed_SpellAlert:SetJustifyH(NURFED_COMBATLOG_SAVED.spell.fontJustifyH)
	if NURFED_COMBATLOG_SAVED.spell.enabled then
		eventLst["SPELL_CAST_SUCCESS"] = true
		eventLst["SPELL_CAST_START"] = true
	else
		eventLst["SPELL_CAST_SUCCESS"] = false
		eventLst["SPELL_CAST_START"] = false
	end
	
	Nurfed_BuffAlert:SetWidth(NURFED_COMBATLOG_SAVED.buff.width)
	Nurfed_BuffAlert:SetHeight(NURFED_COMBATLOG_SAVED.buff.height)
	Nurfed_BuffAlert:SetInsertMode(NURFED_COMBATLOG_SAVED.buff.insertMode)
	Nurfed_BuffAlert:SetTimeVisible(NURFED_COMBATLOG_SAVED.buff.visibleTime)
	Nurfed_BuffAlert:SetFadeDuration(NURFED_COMBATLOG_SAVED.buff.fadeDuration)
	Nurfed_BuffAlert:SetFont("Fonts\\FRIZQT__.TTF", NURFED_COMBATLOG_SAVED.buff.fontHeight, NURFED_COMBATLOG_SAVED.buff.fontStyle)
	Nurfed_BuffAlert:SetJustifyH(NURFED_COMBATLOG_SAVED.buff.fontJustifyH)
	if NURFED_COMBATLOG_SAVED.buff.enabled then
		eventLst["SPELL_AURA_APPLIED"] = true
	else
		eventLst["SPELL_AURA_APPLIED"] = false
	end
end)
local unittbl = {
	[1] = "mouseover",
	[2] = "target",
	[3] = "focus",
}
local function nameupdate()
	local unit = "mouseover";
	for _, unit in ipairs(unittbl) do
		if UnitExists(unit) and UnitIsPlayer(unit) and UnitCanAttack("player", unit) then
			local name = UnitName(unit)
			if name and not classLst[name] then
				classLst[name] = RAID_CLASS_COLORS[select(2, UnitClass(unit))].hex
				break
			end
		end
	end
end
			
			
Nurfed:regevent("PLAYER_TARGET_CHANGED", nameupdate)
Nurfed:regevent("PLAYER_FOCUS_CHANGED", nameupdate)
Nurfed:regevent("UPDATE_MOUSEOVER_UNIT", nameupdate)

local function createhandle(name, title)
	if not name or not title then return end
	local f = CreateFrame("Frame", name, UIParent)
	f:SetWidth(110)
	f:SetHeight(13)
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
	f:SetBackdropColor(0,0,0)
	f:SetMovable()
	f:EnableMouse()
	f:RegisterForDrag("LeftButton")
	f:SetClampedToScreen()
	f:Hide()
	if not f:IsUserPlaced() then
		f:SetPoint("CENTER")
	end
	f.text = f:CreateFontString(nil, "OVERLAY")
	f.text:SetPoint("CENTER")
	f.text:SetFontObject("GameFontNormalSmall")
	f.text:SetText(title)
	f.text:SetTextColor(1,1,1)
	f:SetScript("OnDragStart", function(self)
		if not NRF_LOCKED and not InCombatLockdown() then
			self:StartMoving()
		end
	end)
	f:SetScript("OnDragStop", function(self)
		if not NRF_LOCKED and not InCombatLockdown() then
		  self:StopMovingOrSizing()
		  self:SetUserPlaced(true)
		 end
	end)
end
local function creategrid(name, parent)
	if not name or not _G[parent] then return end
	local f = CreateFrame("Frame", name, UIParent)
	f:SetWidth(_G[parent]:GetWidth())
	f:SetHeight(_G[parent]:GetHeight())
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		tile = true,
		tileSize = 16,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
	f:SetBackdropColor(0,0,0)
	f:SetAllPoints(_G[parent])
	f:Hide()
end

createhandle("Nurfed_SpellAlertAnchor", "Nurfed_SpellAlert")
CreateFrame("MessageFrame", "Nurfed_SpellAlert", UIParent)
Nurfed_SpellAlert:SetFrameStrata("HIGH")
Nurfed_SpellAlert:SetPoint("TOP", "Nurfed_SpellAlertAnchor", "BOTTOM", 0, -13)
creategrid("Nurfed_SpellAlertGrid", "Nurfed_SpellAlert")

createhandle("Nurfed_BuffAlertAnchor", "Nurfed_BuffAlert")
CreateFrame("MessageFrame", "Nurfed_BuffAlert", UIParent)
Nurfed_BuffAlert:SetFrameStrata("HIGH")
Nurfed_BuffAlert:SetPoint("TOP", "Nurfed_BuffAlertAnchor", "BOTTOM", 0, -13)
creategrid("Nurfed_BuffAlertGrid", "Nurfed_BuffAlert")

Nurfed:regevent("NURFED_LOCK", function()
	if NRF_LOCKED then
		Nurfed_BuffAlertAnchor:Hide()
		Nurfed_BuffAlertGrid:Hide()
		Nurfed_SpellAlertAnchor:Hide()
		Nurfed_SpellAlertGrid:Hide()
	else
		Nurfed_BuffAlertAnchor:Show()
		Nurfed_BuffAlertGrid:Show()
		Nurfed_SpellAlertAnchor:Show()
		Nurfed_SpellAlertGrid:Show()
	end
end)
Nurfed:sendevent("NURFED_COMBATLOG_SETTINGS_CHANGED")
Nurfed:setversion("Combat Log", "$Date$", "$Rev$")