---------------------------------------------------------
-- Nurfed CombatLog
assert(Nurfed, "Nurfed must be enabled for Nurfed_CombatLog to work.")
local _G = getfenv(0)
local bitband = _G.bit.band
local SPELLCASTGOOTHER = _G.SPELLCASTGOOTHER
local AURAADDEDOTHERHELPFUL = _G.AURAADDEDOTHERHELPFUL
local COMBATLOG_OBJECT_REACTION_HOSTILE = _G.COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_CONTROL_PLAYER = _G.COMBATLOG_OBJECT_CONTROL_PLAYER

local damage = {
	[1] = "|cffff6464",-- 1 - physical
	[2] = "|cffffff00",-- 2 - holy
	[4] = "|cffff0000",-- 4 - fire
	[8] = "|cff006600", -- 8 - nature
	[16] = "|cff0066ff", -- 16 - frost
	[32] = "|cffca4cd9",-- 32 - shadow
	[40] = "|cffcab2d9", -- 40 - nature + shadow? lol?
	[64] = "|cff99ccff", -- 64 - arcane
}

local eventLst = { ["SPELL_CAST_SUCCESS"] = true, ["SPELL_CAST_START"] = true, ["SPELL_AURA_APPLIED"] = true, }
local function onevent(_, _, event, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags, id, spellName, spellSchool, spellType, spellName2)
	if not eventLst[event] then return end
	if event == "SPELL_CAST_SUCCESS" or event == "SPELL_CAST_START" then	-- both use source
		if bitband(COMBATLOG_OBJECT_REACTION_HOSTILE, srcFlags) ~= 0 and bitband(COMBATLOG_OBJECT_CONTROL_PLAYER, srcFlags) ~= 0 then
			Nurfed_SpellAlert:AddMessage("|T"..select(3, GetSpellInfo(id))..":24:24:-5|t"..SPELLCASTGOOTHER:format(srcName, (damage[spellSchool] or "|cff999999")..spellName.."|r"))
		end
		
	elseif event == "SPELL_AURA_APPLIED" and spellType == "BUFF" then	-- uses destFlags
		if bitband(COMBATLOG_OBJECT_REACTION_HOSTILE, dstFlags) ~= 0 and bitband(COMBATLOG_OBJECT_CONTROL_PLAYER, dstFlags) ~= 0 then
			Nurfed_BuffAlert:AddMessage("|T"..select(3, GetSpellInfo(id))..":24:24:-5|t"..AURAADDEDOTHERHELPFUL:format(dstName, (damage[spellSchool] or "|cff00ff00")..spellName.."|r"))
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
--Nurfed:regevent("COMBAT_LOG_EVENT_UNFILTERED", onevent)

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
createhandle("Nrf_SpellAlert", "Nurfed_SpellAlert")

CreateFrame("MessageFrame", "Nurfed_SpellAlert", UIParent)
Nurfed_SpellAlert:SetWidth(UIParent:GetWidth())
Nurfed_SpellAlert:SetHeight(20)
Nurfed_SpellAlert:SetInsertMode("TOP")
Nurfed_SpellAlert:SetFrameStrata("HIGH")
Nurfed_SpellAlert:SetTimeVisible(1)
Nurfed_SpellAlert:SetFadeDuration(0.5)
Nurfed_SpellAlert:SetPoint("CENTER", "Nrf_SpellAlert", 0, -13)
Nurfed_SpellAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")

createhandle("Nrf_BuffAlert", "Nurfed_BuffAlert")
CreateFrame("MessageFrame", "Nurfed_BuffAlert", UIParent)
Nurfed_BuffAlert:SetWidth(UIParent:GetWidth())
Nurfed_BuffAlert:SetHeight(20)
Nurfed_BuffAlert:SetInsertMode("TOP")
Nurfed_BuffAlert:SetFrameStrata("HIGH")
Nurfed_BuffAlert:SetTimeVisible(1)
Nurfed_BuffAlert:SetFadeDuration(0.5)
Nurfed_BuffAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_BuffAlert:SetPoint("CENTER", "Nrf_BuffAlert", 0, -13)
Nurfed:regevent("NURFED_LOCK", function()
	if NRF_LOCKED then
		Nrf_BuffAlert:Hide()
		Nrf_SpellAlert:Hide()
	else
		Nrf_BuffAlert:Show()
		Nrf_SpellAlert:Show()
	end
end)