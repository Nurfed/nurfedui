------------------------------------------
--		Nurfed Core Library
------------------------------------------

local version = 1.0
local _G = getfenv(0)
local util = _G["Nurfed"]

if util and util.version >= version then
	return
end

-- Add library to environment
util = {}
_G["Nurfed"] = util
util.name = "Nurfed"
util.version = version

-- Globals
NURFED_MENUS = NURFED_MENUS or {}
NURFED_DEFAULT = NURFED_DEFAULT or {}
NRF_LOCKED = 1
NRF_IMG = "Interface\\AddOns\\Nurfed\\Images\\"
NRF_FONT = "Interface\\AddOns\\Nurfed\\Fonts\\"

-- Clique support
ClickCastFrames = ClickCastFrames or {}

--locals
local frame = CreateFrame("Frame")
local virtual = {}
local pairs = pairs
local ipairs = ipairs
local type = type

-- Add round function to math
math.round = function(num, idp)
	return tonumber(string.format("%."..(idp or 0).."f", num))
end

-- Add capitalize function to string
string.capital = function(text)
	local up = function(first, rest)
		return string.upper(first)..string.lower(rest)
	end
	text = string.gsub(string.lower(text), "(%l)([%w_']*)", up)
	return text
end

----------------------------------------------------------------
-- Utility functions
function util:print(msg, out, r, g, b)
	out = _G["ChatFrame"..(out or 1)]
	out:AddMessage(msg, (r or 1), (g or 1), (b or 1))
end

function util:rgbhex(r, g, b)
	if type(r) == "table" then
		if r.r then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end
	return string.format("|cff%02x%02x%02x", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255)
end

function util:copytable(tbl)
	local new = {}
	local key, value = next(tbl, nil)
	while key do
		if type(value) == "table" then
			value = self:copytable(value)
		end
		new[key] = value
		key, value = next(tbl, key)
	end
	return new
end

function util:mergetable(target, source)
	local key, value = next(source, nil)
	while key do
		if not target[key] then
			target[key] = value
		elseif type(target[key]) == "table" and type(value) == "table" then
			target[key] = self:mergetable(target[key], value)
		end
		key, value = next(source, key)
	end
	return target
end

function util:getopt(opt, addon)
	if addon then
		addon = "_"..string.upper(addon)
	end
	local tbl = _G["NURFED"..(addon or "").."_SAVED"]
	local val = tbl[opt]
	if val == nil then
		val = NURFED_DEFAULT[opt]
	end
	return val
end

function util:getunit(name)
	for i = 1, GetNumRaidMembers() do
		local rname, rank, group = GetRaidRosterInfo(i)
		if name == rname then
			return group, rank
		end
	end
end

function util:getunitstat(unit, stat)
	local curr, max, missing, perc, r, g, b
	if stat == "XP" then
		r, g, b = 0.58, 0.0, 0.55
		if unit == "pet" then
			curr, max = GetPetExperience()
		else
			local name, reaction, minval, maxval, value = GetWatchedFactionInfo()
			if name then
				curr = value - minval
				max = maxval - minval
				r = FACTION_BAR_COLORS[reaction].r
				g = FACTION_BAR_COLORS[reaction].g
				b = FACTION_BAR_COLORS[reaction].b
			else
				if GetRestState() == 1 then
					r, g, b = 0.0, 0.39, 0.88
				end
				curr, max = UnitXP(unit), UnitXPMax(unit)
			end
		end
	else
		curr = _G["Unit"..stat](unit)
		max = _G["Unit"..stat.."Max"](unit)
		if stat == "Health" and MobHealth3 then
			curr, max = MobHealth3:GetUnitHealth(unit, curr, max, UnitName(unit), UnitLevel(unit))
		end
	end

	if not UnitIsConnected(unit) then
		curr = 0
	end

	perc = curr / max
	missing = curr - max

	if stat == "Health" then
		if perc > 0.5 then
			r = (1.0 - perc) * 2
			g = 1.0
		else
			r = 1.0
			g = perc * 2
		end
		b = 0.0
	end

	perc = format("%.0f", floor(perc * 100))
	return curr, max, missing, perc, r, g, b
end

function util:binding(bind)
	bind = string.gsub(bind, "CTRL%-", "C-")
	bind = string.gsub(bind, "ALT%-", "A-")
	bind = string.gsub(bind, "SHIFT%-", "S-")
	bind = string.gsub(bind, "Num Pad", "NP")
	bind = string.gsub(bind, "NUMPAD", "NP")
	bind = string.gsub(bind, "Backspace", "Bksp")
	bind = string.gsub(bind, "Spacebar", "Space")
	bind = string.gsub(bind, "Page", "Pg")
	bind = string.gsub(bind, "Down", "Dn")
	bind = string.gsub(bind, "Arrow", "")
	bind = string.gsub(bind, "Insert", "Ins")
	bind = string.gsub(bind, "Delete", "Del")
	return bind
end

function util:formatgs(gstring, anchor)
	gstring = string.gsub(gstring,"([%^%(%)%.%[%]%*%+%-%?])","%%%1")
	gstring = string.gsub(gstring,"%%s","(.+)")
	gstring = string.gsub(gstring,"%%d","(%-?%%d+)")
	if anchor then gstring = "^"..gstring end
	return gstring
end

----------------------------------------------------------------
-- Frame functions
local frameinit = {
	size = function(obj, val)
		obj:SetWidth(val[1])
		obj:SetHeight(val[2])
	end,
	vars = function(obj, val)
		for k, v in pairs(val) do
			obj[k] = v
		end
	end,
	events = function(obj, val)
		for _, v in ipairs(val) do
			obj:RegisterEvent(v)
		end
	end,
	children = function(obj, val)
		if obj:GetName() then
			for k, v in pairs(val) do
				local cobj = Nurfed:createobj(obj:GetName()..k, v, obj)
				if string.find(k, "Texture") then
					local method = obj["Set"..k]
					if method then
						method(obj, cobj)
					end
				end
			end
		end
	end,
}

local framecomp = {
	Anchor = {},
	BackdropColor = {},
	BackdropBorderColor = {},
}

function util:createtemp(name, layout)
	local objtype = rawget(layout, "type")
	if objtype == "Font" then
		self:createobj(name, layout)
	else
		virtual[name] = layout
	end
end

function util:create(name, layout, parent)
	if _G[name] then return end
	local obj = self:createobj(name, layout, (parent or UIParent))
	local tbl, anchor

	for i = #framecomp.Anchor, 1, -1 do
		tbl = framecomp.Anchor[i]
		tbl[1]:ClearAllPoints()
		if type(tbl[2]) ~= "table" then
			tbl[1]:SetAllPoints(tbl[1]:GetParent())
			table.remove(framecomp.Anchor, i)
		else
			anchor = self:copytable(tbl[2])
			if type(anchor[2]) == "string" then
				anchor[2] = string.gsub(anchor[2], "$parent", tbl[1]:GetParent():GetName())
			end
			if not anchor[2] or type(anchor[2]) == "number" or _G[anchor[2]] then
				tbl[1]:SetPoint(unpack(anchor))
				table.remove(framecomp.Anchor, i)
			end
		end
	end

	for i = #framecomp.BackdropColor, 1, -1 do
		tbl = framecomp.BackdropColor[i]
		tbl[1]:SetBackdropColor(unpack(tbl[2]))
		table.remove(framecomp.BackdropColor, i)
	end

	for i = #framecomp.BackdropBorderColor, 1, -1 do
		tbl = framecomp.BackdropBorderColor[i]
		tbl[1]:SetBackdropBorderColor(unpack(tbl[2]))
		table.remove(framecomp.BackdropBorderColor, i)
	end

	return obj
end

function util:createobj(name, layout, parent)
	local obj, objtype, inherit, onload
	if type(parent) == "string" then
		parent = _G[parent]
	end
	if type(layout) == "string" and virtual[layout] then
		layout = self:copytable(virtual[layout])
	end

	if layout.template and virtual[layout.template] then
		layout = self:mergetable(layout, virtual[layout.template])
		layout.template = nil
	end

	objtype = rawget(layout, "type")
	if not objtype then return end

	inherit = layout.uitemp or nil

	if objtype == "Texture" then
		obj = parent:CreateTexture(name, (layout.layer or "ARTWORK"), inherit)
	elseif objtype == "FontString" then
		obj = parent:CreateFontString(name, (layout.layer or "ARTWORK"), inherit)
	elseif objtype == "Font" then
		obj = CreateFont(name)
	else
		obj = CreateFrame(objtype, name, parent, inherit)
	end

	for k, v in pairs(layout) do
		if type(v) == "table" and v.template then
			v = virtual[v.template]
		elseif type(v) == "string" and virtual[v] then
			v = virtual[v]
		end

		if obj.HasScript and obj:HasScript(k) then
			if type(v) == "function" then
				obj:SetScript(k, v)
			else
				obj:SetScript(k, assert(loadstring(v)))
			end
			if k == "OnLoad" then
				onload = obj:GetScript("OnLoad")
			end
		elseif frameinit[k] then
			frameinit[k](obj, v)
		elseif framecomp[k] then
			table.insert(framecomp[k], { obj, v })
		elseif k == "Point" then
			table.insert(framecomp.Anchor, { obj, v })
		else
			local method = obj[k] or obj["Set"..k] or obj["Enable"..k]
			if method then
				if type(v) == "table" and k ~= "Backdrop" then
					method(obj, unpack(v))
				else
					method(obj, v)
				end
			end
		end
	end
	
	if onload then onload(obj) end
	return obj
end

function util:getframes(frame, tbl, recurse)
	if frame.GetChildren then
		local children = { frame:GetChildren() }
		for _, child in ipairs(children) do
			if child:GetName() then
				table.insert(tbl, child:GetName())
				if recurse then self:getframes(child, tbl) end
			end
		end
	end

	if frame.GetRegions then
		local regions = { frame:GetRegions() }
		for _, region in ipairs(regions) do
			if region:GetName() then
				table.insert(tbl, region:GetName())
			end
		end
	end
end

----------------------------------------------------------------
-- OnEvent database
local events

function util:regevent(event, func)
	event = string.upper(event)
	frame:RegisterEvent(event)
	if not events then events = {} end
	if not events[event] then
		events[event] = {}
	end
	for _, v in ipairs(events[event]) do
		if v == func then return end
	end
	table.insert(events[event], func)
end

function util:unregevent(event, func)
	event = string.upper(event)
	if not events or not events[event] then
		return
	end
	local tbl = events[event]

	for k, v in ipairs(tbl) do
		if v == func then
			table.remove(tbl, k)
			break
		end
	end

	if #tbl == 0 then
		frame:UnregisterEvent(event)
	end
end

local onevent = function(self, event, ...)
	local tbl = events[event]
	for _, func in ipairs(tbl) do
		func(event, ...)
	end
end

frame:SetScript("OnEvent", onevent)

function util:sendevent(event, ...)
	onevent(frame, event, ...)
end

----------------------------------------------------------------
-- OnUpdate database
local timers, timerfuncs
local loops, loopfuncs, looptimes

function util:schedule(sec, func, loop)
	if loop then
		if not loops then
			loops, loopfuncs, looptimes = {}, {}, {}
		end
		table.insert(loopfuncs, func)
		table.insert(looptimes, sec)
		table.insert(loops, sec)
	else
		if not timers then
			timers, timerfuncs = {}, {}
		end
		table.insert(timerfuncs, func)
		table.insert(timers, sec)
	end
	frame:Show()
end

function util:unschedule(func, isloop)
	if isloop then
		if not loops then return end
		for k, v in ipairs(loopfuncs) do
			if v == func then
				table.remove(loops, k)
				table.remove(loopfuncs, k)
				table.remove(looptimes, k)
				break
			end
		end
	else
		if not timers then return end
		for k, v in ipairs(timerfuncs) do
			if v == func then
				table.remove(timers, k)
				table.remove(timerfuncs, k)
				break
			end
		end
	end
end

local onupdate = function(self, e)
	local update, val
	if timers and #timers > 0 then
		for i = #timers, 1, -1 do
			if timers[i] == "combat" then
				if not InCombatLockdown() then
					table.remove(timerfuncs, i)()
					table.remove(timers, i)
				end
			else
				timers[i] = timers[i] - e
				if timers[i] <= 0 then
					table.remove(timerfuncs, i)()
					table.remove(timers, i)
				end
			end
		end	
		update = true
	end

	if loops and #loops > 0 then
		for k, v in ipairs(loops) do
			loops[k] = loops[k] - e
			if loops[k] <= 0 then
				loopfuncs[k]()
				loops[k] = looptimes[k]
			end
		end
		update = true
	end

	if not update then
		frame:Hide()
	end
end

frame:Hide()
frame:SetScript("OnUpdate", onupdate)

----------------------------------------------------------------
-- Spell database
local spells

local updatespelltab = function(tab)
	local spellid, name, rank
	local _, _, offset, numSpells = GetSpellTabInfo(tab)
	for i = 1, numSpells do
		spellid = offset + i
		if not IsPassiveSpell(spellid, BOOKTYPE_SPELL) then
			name, rank = GetSpellName(spellid, BOOKTYPE_SPELL)
			spells[name] = spellid
			if string.find(rank, RANK) or string.len(rank) == 0 then
				name = name.."("..rank..")"
				spells[name] = spellid
			end
		end
	end
end

local updatespells = function(event, arg1)
	if not spells then
		spells = {}
	end
	if arg1 then
		updatespelltab(arg1)
	else
		for i = 1, GetNumSpellTabs() do
			updatespelltab(i)
		end
	end
end

function util:getspell(spell, rank)
	if not spells then
		updatespells()
	end
	if rank then
		spell = spell.."("..RANK.." "..rank..")"
	end
	spell = string.gsub(spell, "%(%)", "")
	return spells[spell]
end

util:regevent("LEARNED_SPELL_IN_TAB", updatespells)

----------------------------------------------------------------
-- Slash commands database (Credit to CT_Mod)
local numSlashCmds = 0
function util:addslash(func, ...)
	numSlashCmds = numSlashCmds + 1
	local id = "NURFED" .. numSlashCmds
	SlashCmdList[id] = func
	for i = 1, select('#', ...) do
		setglobal("SLASH_" .. id .. i, select(i, ...))
	end
end

function Nurfed_ToggleOptions()
	local loaded, reason = LoadAddOn("Nurfed_Options")
	if loaded then
		if Nurfed_Menu:IsShown() then
			PlaySound("igAbilityClose")
			Nurfed_Menu:Hide()
		else
			PlaySound("igAbilityOpen")
			Nurfed_Menu:Show()
			UIFrameFadeIn(Nurfed_Menu, 0.25)
		end
	end
end

util:addslash(Nurfed_ToggleOptions, "/nurfed")

----------------------------------------------------------------
-- Add hex values to tables
for _, val in pairs(RAID_CLASS_COLORS) do
	val.hex = Nurfed:rgbhex(val.r, val.g, val.b)
end

for _, val in ipairs(UnitReactionColor) do
	val.hex = Nurfed:rgbhex(val.r, val.g, val.b)
end