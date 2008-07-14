---------------------------------------------------------
-- Nurfed CombatLog

--[[
local istotem = "Totem"

if GetLocale()=="koKR" then
	istotem = "토템"
elseif GetLocale()=="zhCN" then
	istotem = "图腾"
elseif GetLocale()=="zhTW" then
	istotem = "圖騰"
elseif GetLocale()=="esES" then
	istotem = "Tótem"
end

local inparty = function(unit)
	for i = 1, GetNumPartyMembers() do
		local name = UnitName("party"..i)
		if name == unit then
			return true
		end
	end
end
]]

local function onevent(event, ...)
  local timestamp, tevent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags = select(1, ...)
  local prefix, suffix = string.split("_", tevent, 2)
  if prefix == "SPELL" then
    local id, spell, school = select(9, ...)
    if suffix == "CAST_START" then
      Nurfed_SpellAlert:AddMessage(format(SPELLCASTGOOTHER, srcName, "|cff999999"..spell.."|r"))
    elseif suffix == "CAST_SUCCESS" then
      Nurfed_SpellAlert:AddMessage(format(SPELLCASTGOOTHER, srcName, "|cff999999"..spell.."|r"))
    elseif suffix == "AURA_APPLIED" then
      local auratype = select(12, ...)
      if auratype == "BUFF" then
        Nurfed_BuffAlert:AddMessage(format(AURAADDEDOTHERHELPFUL, dstName, "|cff00ff00"..spell.."|r"))
      end
    end
  end
end

Nurfed:regevent("COMBAT_LOG_EVENT_UNFILTERED", onevent)

CreateFrame("MessageFrame", "Nurfed_SpellAlert", UIParent)
Nurfed_SpellAlert:SetWidth(UIParent:GetWidth())
Nurfed_SpellAlert:SetHeight(20)
Nurfed_SpellAlert:SetInsertMode("TOP")
Nurfed_SpellAlert:SetFrameStrata("HIGH")
Nurfed_SpellAlert:SetTimeVisible(1)
Nurfed_SpellAlert:SetFadeDuration(0.5)
Nurfed_SpellAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_SpellAlert:SetPoint("CENTER", 0, 95)

CreateFrame("MessageFrame", "Nurfed_BuffAlert", UIParent)
Nurfed_BuffAlert:SetWidth(UIParent:GetWidth())
Nurfed_BuffAlert:SetHeight(20)
Nurfed_BuffAlert:SetInsertMode("TOP")
Nurfed_BuffAlert:SetFrameStrata("HIGH")
Nurfed_BuffAlert:SetTimeVisible(1)
Nurfed_BuffAlert:SetFadeDuration(0.5)
Nurfed_BuffAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_BuffAlert:SetPoint("BOTTOM", Nurfed_SpellAlert, "TOP", 0, 2)

TEXT_MODE_A_STRING_VALUE_SCHOOL = ""
TEXT_MODE_A_STRING_RESULT_RESISTED = "R"
TEXT_MODE_A_STRING_RESULT_BLOCKED = "B"
TEXT_MODE_A_STRING_RESULT_ABSORBED = "A"
TEXT_MODE_A_STRING_RESULT_CRITICAL = "C"
TEXT_MODE_A_STRING_RESULT_CRITICAL_SPELL = "C"
TEXT_MODE_A_STRING_RESULT_GLANCING = "G"
TEXT_MODE_A_STRING_RESULT_CRUSHING = "Cr"
ACTION_SPELL_DAMAGE_FULL_TEXT = "$source $spell $dest $value.$result";
ACTION_SPELL_DAMAGE_FULL_TEXT_NO_SOURCE = "$spell $dest $value.$result";