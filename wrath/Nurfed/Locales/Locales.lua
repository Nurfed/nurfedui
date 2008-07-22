------------------------------------------
--    Nurfed Localization Library
------------------------------------------
local _G = getfenv(0)
local util = _G["Nurfed"]

local rawget = rawget
local setmetatable = setmetatable
local currentLocale = GetLocale()
local select = select
local type = type
currentLocale = currentLocale == "enGB" and "enUS" or currentLocale

local locales = {}
local common = {}
local TRANSLATE_MESSAGE
TRANSLATE_MESSAGE = "|cff37FDFCNurfed|r is not fully translated for %q, please help translate." --<name><locale>

if currentLocale == "koKR" then
	TRANSLATE_MESSAGE = "|cff37FDFCNurfed|r의 %q에 충분한 번역이 없을 수 있습니다. 빠진 번역의 도움을 부탁드립니다." --<name><locale>
end
--if currentLocale == "deDE" then
--		TRANSLATE_MESSAGE = "de translation"
--	end
local TRANSLATE_MESSAGE_DEBUG = "%s:   :%s:"

local localesMT = {
	__index = function(self, key)
		if not common[key] then
			self[key] = key
			if not rawget(self, "__Nagged") then
				Nurfed:print(TRANSLATE_MESSAGE:format(currentLocale))
				self.__Nagged = true
			end
			if false then	-- if true will input what is not translated and what module it belongs to in Chatframe3 or ChatFrame2
				debug(TRANSLATE_MESSAGE_DEBUG:format(key))
			end
		else
			self[key] = common[key]
		end
		return self[key]
	end,
}

function util:GetTranslations()
	if not locales[self] then
		locales[self] = setmetatable({}, localesMT)
	end
	return locales[self]
end

function util:RegisterTranslations(locale, ...)
	if locale == currentLocale then
		local L = self:GetTranslations()
		for i=1, select("#", ...), 2 do
			local k, v = select(i, ...)
			if type(k) == "string" and (type(v) == "string" or v == true) then
				L[k] = v == true and k or v
			end
		end
	end
end

function util:RegisterCommonTranslations(locale, ...)
	if locale == currentLocale then
		for i=1, select("#", ...), 2 do
			local k, v = select(i, ...)
			if type(k) == "string" and (type(v) == "string" or v == true) then
				common[k] = v == true and k or v
			end
		end
	end
end