---------------------------------------------------------
-- Spell Alert
local formatgs = function(gstring, anchor)
	gstring = string.gsub(gstring,"([%^%(%)%.%[%]%*%+%-%?])","%%%1")
	gstring = string.gsub(gstring,"%%s","(.+)")
	gstring = string.gsub(gstring,"%%d","(%-?%%d+)")
	if anchor then gstring = "^"..gstring end
	return gstring
end

local casting = formatgs(SPELLCASTOTHERSTART)
local totem = formatgs(SPELLCASTGOOTHER)
local buff = formatgs(AURAADDEDOTHERHELPFUL)

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

local spellevent = function()
	local unit, spell
	if event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
		for unit, spell in string.gmatch(arg1, casting) do
			if not inparty(unit) then
				Nurfed_SpellAlert:AddMessage(format(SPELLCASTOTHERSTART, unit, "|cffff0000"..spell.."|r"))
			end
		end
	elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
		for unit, spell in string.gmatch(arg1, casting) do
			if not inparty(unit) then
				Nurfed_SpellAlert:AddMessage(format(SPELLCASTOTHERSTART, unit, "|cffffff00"..spell.."|r"))
			end
			return
		end

		for unit, spell in string.gmatch(arg1, totem) do
			if not inparty(unit) and string.find(spell, istotem) then
				Nurfed_SpellAlert:AddMessage(format(SPELLCASTGOOTHER, unit, "|cff999999"..spell.."|r"))
			end
			return
		end

		for unit, spell in string.gmatch(arg1, buff) do
			if string.find(spell, "^%a") then
				Nurfed_BuffAlert:AddMessage(format(AURAADDEDOTHERHELPFUL, unit, "|cff00ff00"..spell.."|r"))
			end
			return
		end
	elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" then
		for unit, spell in string.gmatch(arg1, buff) do
			if string.find(spell, "^%a") then
				Nurfed_BuffAlert:AddMessage(format(AURAADDEDOTHERHELPFUL, unit, "|cff00ff00"..spell.."|r"))
			end
		end
	end
end

CreateFrame("MessageFrame", "Nurfed_SpellAlert", UIParent)
Nurfed_SpellAlert:SetWidth(UIParent:GetWidth())
Nurfed_SpellAlert:SetHeight(20)
Nurfed_SpellAlert:SetInsertMode("TOP")
Nurfed_SpellAlert:SetFrameStrata("HIGH")
Nurfed_SpellAlert:SetTimeVisible(1)
Nurfed_SpellAlert:SetFadeDuration(0.5)
Nurfed_SpellAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_SpellAlert:SetPoint("CENTER", 0, 95)
Nurfed_SpellAlert:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
Nurfed_SpellAlert:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
Nurfed_SpellAlert:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
Nurfed_SpellAlert:SetScript("OnEvent", spellevent)

CreateFrame("MessageFrame", "Nurfed_BuffAlert", UIParent)
Nurfed_BuffAlert:SetWidth(UIParent:GetWidth())
Nurfed_BuffAlert:SetHeight(20)
Nurfed_BuffAlert:SetInsertMode("TOP")
Nurfed_BuffAlert:SetFrameStrata("HIGH")
Nurfed_BuffAlert:SetTimeVisible(1)
Nurfed_BuffAlert:SetFadeDuration(0.5)
Nurfed_BuffAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_BuffAlert:SetPoint("BOTTOM", Nurfed_SpellAlert, "TOP", 0, 2)