------------------------------------------
--    Nurfed Core Library
------------------------------------------

local version = 1.11
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
local hpfunc
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

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
function util:print(msg, out, r, g, b, ...)
	if type(out) == "string" then
		msg = msg:format(out, r, g, b, ...)
	end
	out	= _G["ChatFrame"..(type(out) == "number" and out or 1)]
	out:AddMessage(msg, (type(r) == "number" and r or 1), (type(g) == "number" and g or 1), (type(b) == "number" and b or 1))
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

local basicSerialize = function(o)
  if type(o) == "number" or type(o) == "boolean" then
	return tostring(o)
  else
	return string.format("%q", o)
  end
end

function save(name, value, out, indent)
  indent = indent or 0
  local iname = string.rep(" ", indent)..name
  if type(value) == "number" or type(value) == "string" or type(value) == "boolean" then
	table.insert(out, iname.." = "..basicSerialize(value)..",")
  elseif type(value) == "table" then
	table.insert(out, iname.." = {")
	for k, v in pairs(value) do
	  local fieldname
	  if type (k) == "string" and string.find (k, "^[_%a][_%a%d]*$") then
		fieldname = k
	  else
		fieldname = string.format("[%s]", basicSerialize(k))
	  end
	  save(fieldname, v, out, indent + 2)
	end
	if indent == 0 then
	  table.insert(out, string.rep(" ", indent).."}")
	else
	  table.insert(out, string.rep(" ", indent).."},")
	end
	
  end
end

function util:serialize(what, tbl)
  local out = {}
  save(what, tbl, out)
  return out
end

function util:getopt(opt)
  local val = NURFED_SAVED[opt]
  if val == nil then
	val = NURFED_DEFAULT[opt]
  end
  return val
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
-- Unit functions
local race = {
  ["HUMAN_MALE"]    = {0, 0.125, 0, 0.25},
  ["DWARF_MALE"]    = {0.125, 0.25, 0, 0.25},
  ["GNOME_MALE"]    = {0.25, 0.375, 0, 0.25},
  ["NIGHTELF_MALE"]  = {0.375, 0.5, 0, 0.25},
  ["TAUREN_MALE"]    = {0, 0.125, 0.25, 0.5},
  ["SCOURGE_MALE"]  = {0.125, 0.25, 0.25, 0.5},
  ["TROLL_MALE"]    = {0.25, 0.375, 0.25, 0.5},
  ["ORC_MALE"]    = {0.375, 0.5, 0.25, 0.5},
  ["HUMAN_FEMALE"]  = {0, 0.125, 0.5, 0.75},
  ["DWARF_FEMALE"]  = {0.125, 0.25, 0.5, 0.75},
  ["GNOME_FEMALE"]  = {0.25, 0.375, 0.5, 0.75},
  ["NIGHTELF_FEMALE"]  = {0.375, 0.5, 0.5, 0.75},
  ["TAUREN_FEMALE"]  = {0, 0.125, 0.75, 1.0},
  ["SCOURGE_FEMALE"]  = {0.125, 0.25, 0.75, 1.0},
  ["TROLL_FEMALE"]  = {0.25, 0.375, 0.75, 1.0},
  ["ORC_FEMALE"]    = {0.375, 0.5, 0.75, 1.0},
  ["BLOODELF_MALE"]  = {0.5, 0.625, 0.25, 0.5},
  ["BLOODELF_FEMALE"]  = {0.5, 0.625, 0.75, 1.0},
  ["DRAENEI_MALE"]  = {0.5, 0.625, 0, 0.25},
  ["DRAENEI_FEMALE"]  = {0.5, 0.625, 0.5, 0.75},
}

local class = {
  ["WARRIOR"]  = {0, 0.25, 0, 0.25},
  ["MAGE"]  = {0.25, 0.49609375, 0, 0.25},
  ["ROGUE"]  = {0.49609375, 0.7421875, 0, 0.25},
  ["DRUID"]  = {0.7421875, 0.98828125, 0, 0.25},
  ["HUNTER"]  = {0, 0.25, 0.25, 0.5},
  ["SHAMAN"]  = {0.25, 0.49609375, 0.25, 0.5},
  ["PRIEST"]  = {0.49609375, 0.7421875, 0.25, 0.5},
  ["WARLOCK"]  = {0.7421875, 0.98828125, 0.25, 0.5},
  ["PALADIN"]  = {0, 0.25, 0.5, 0.75},
  ["PETS"]  = {0, 1, 0, 1},
}
-- these are seperate from the above lists, used for Pitbull settings
local colorLst = {
	["HUNTER"] = { 0.6392156862745098, 1, 0.5098039215686274 },
	["WARRIOR"] = { 0.8274509803921568, 0.7529411764705882,	0.5882352941176471 },
	["PALADIN"] = { 0.9607843137254902, 0.5490196078431373, 0.7294117647058823 },
	["DRUID"] = { 0, 0.4901960784313725, 0.0392156862745098 },
	["PRIEST"] = { 0.7607843137254902, 0.74, 0.996078431372549 },
	["SHAMAN"] = { 0, 1, 0.996078431372549 },
	["ROGUE"] = { 0, 0.9607843137254902, 0.4117647058823529 },
	["MAGE"] = { 0.4823529411764706, [3] = 1 },
	["WARLOCK"] = { 0.7333333333333333, 0.6431372549019607, 1 },
	
	["disconnected"] = { 0.2666666666666667, 0.2862745098039216, 0.2588235294117647 },
	["dead"] = { 0.2549019607843137, 0.2784313725490196, 0.3215686274509804 },
	["tapped"] = { 1, 1, 34/255 },
	
	["civilian"] = { 0.8431372549019608, 0.1882352941176471, 0.1529411764705883 },
	["neutral"] = { 0.8470588235294118, 0.7764705882352941, 0.3529411764705882 },
	["hostile"] = {	0.8431372549019608, 0.1882352941176471, 0.1529411764705883 },
	["friendly"] = { 0.192156862745098, 0.4666666666666667, 0.196078431372549 },
	
	["midHP"] = { 0.7647058823529411, 0, 0.00392156862745098 },
	["minHP"] = {0, 0.2627450980392157,	0.1607843137254902 },
	["maxHP"] = { 0.1333333333333333, [3] = 0.1607843137254902 },
	["rage"] = { 226/255, 45/255, 75/255 },
	["energy"] = { 1, 220/255, 25/255 },
	["focus"] = { 1, 210/255, 0 },
	["mana"] = { 48/255, 113/255, 191/255 },
	["happiness"] = { 0.8, 0.8, 0.8 },	
}
function util:getunit(name)
  for i = 1, GetNumRaidMembers() do
	local rname, rank, group = GetRaidRosterInfo(i)
	if name == rname then
	  return group, rank
	end
  end
end

function util:sethpfunc()
  local script = "return function(perc, unit)\n"..self:getopt("hpscript").."\nreturn r, g, b\nend"
  hpfunc = assert(loadstring(script))()
end

local function HealthGradient(perc)
	local r1, g1, b1
	local r2, g2, b2
	if perc <= 0.5 then
		perc = perc * 2
		r1, g1, b1 = unpack(colorLst.minHP)
		r2, g2, b2 = unpack(colorLst.midHP)
	else
		perc = perc * 2 - 1
		r1, g1, b1 = unpack(colorLst.midHP)
		r2, g2, b2 = unpack(colorLst.maxHP)
	end
	if r1 and r2 and g1 and g2 and b1 and b2 then
		return r1 + (r2-r1)*perc, g1 + (g2-g1)*perc, b1 + (b2-b1)*perc
	else
		return 1, .5, .8
	end
end

local lmh4
function util:getunitstat(unit, stat)
  local curr, max, missing, perc, r, g, b, bgr, bgg, bgb
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
	if stat == "Health" then
		if MobHealth3 then
			curr, max = MobHealth3:GetUnitHealth(unit, curr, max, UnitName(unit), UnitLevel(unit))
		end
		if not lmh4 and not IsAddOnLoaded("LibMobHealth-4.0") and GetAddOnMetadata("LibMobHealth-4.0", "Version") then
			local isLoaded, reason = LoadAddOn("LibMobHealth-4.0")
      		if isLoaded ~= 1 then
      			self:print(reason)
      		else
      			lmh4 = LibStub("LibMobHealth-4.0")
      		end
	    end
		if lmh4 then
			curr, max = lmh4:GetUnitHealth(unit)
		end
	end
  end

  if not UnitIsConnected(unit) then
	curr = 0
  end

  perc = curr / max
  missing = curr - max
	if stat == "Mana" then
		local color = self:getopt("mpcolor")
		if color == "normal" then
			local powertype = UnitPowerType(unit)
			if powertype == 0 then r, g, b = unpack(self:getopt("mana"))
			elseif powertype == 1 then r, g, b = unpack(self:getopt("rage"))
			elseif powertype == 2 then r, g, b = unpack(self:getopt("focus"))
			elseif powertype == 3 then r, g, b = unpack(self:getopt("energy"))
			elseif powertype == 4 then r, g, b = unpack(self:getopt("happiness"))
			end
		
		elseif color == "class" then
			local eclass = select(2, UnitClass(unit))
			r = RAID_CLASS_COLORS[eclass].r
			g = RAID_CLASS_COLORS[eclass].g
			b = RAID_CLASS_COLORS[eclass].b
		
		elseif color == "fade" then
			if perc > 0.5 then
				r = (1.0 - perc) * 2
				g = 1.0
			else
				r = 1.0
				g = perc * 2
			end
			b = 0.0	
		elseif color == "pitbull" then
			local powertype = UnitPowerType(unit)
			if powertype == 0 then r, g, b = unpack(colorLst.mana)
			elseif powertype == 1 then r, g, b = unpack(colorLst.rage)
			elseif powertype == 2 then r, g, b = unpack(colorLst.focus)
			elseif powertype == 3 then r, g, b = unpack(colorLst.energy)
			elseif powertype == 4 then r, g, b = unpack(colorLst.happiness)
			end
		end
		if r and self:getopt("changempbg") then
			g = g or 0
			b = b or 0
			bgr, bgg, bgb = (r + 0.2)/3, (g + 0.2)/3, (b + 0.2)/3
		end

				
	elseif stat == "Health" then
		local color = self:getopt("hpcolor")
		if color == "pitbull" then
			local eclass = select(2, UnitClass(unit))
			if not UnitIsConnected(unit) then r, g, b = unpack(colorLst.disconnected)

			elseif UnitIsDeadOrGhost(unit) then r, g, b = unpack(colorLst.dead)

			elseif UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then r, g, b = unpack(colorLst.tapped)

			elseif UnitIsPlayer(unit) then

				if UnitIsFriend("player", unit) then r, g, b = unpack(colorLst[eclass or "WARRIOR"])

				elseif UnitCanAttack(unit, "player") then
					if UnitCanAttack("player", unit) then 
						r, g, b = unpack(colorLst.hostile)
					else
						r, g, b = unpack(colorLst.civilian)
					end
				
				elseif UnitCanAttack("player", unit) then r, g, b = unpack(colorLst.neutral)
		
				elseif UnitIsFriend("player", unit) then
					r, g, b = unpack(colorLst.friendly)
				else
					r, g, b = unpack(colorLst.civilian)
				end
			else
				local reaction = UnitReaction(unit, "player")
				if reaction then
					if reaction >= 5 then
						r, g, b = unpack(colorLst.friendly)
					elseif reaction == 4 then
						r, g, b = unpack(colorLst.neutral)
					else
						r, g, b = unpack(colorLst.hostile)
					end
				else
					r, g, b = 1, 1, 1
				end
			end
			if not r then
				r, g, b = HealthGradient(perc)
			end
	
		elseif color == "class" then
			local eclass = select(2, UnitClass(unit))
			if eclass then
				r = RAID_CLASS_COLORS[eclass].r
				g = RAID_CLASS_COLORS[eclass].g
				b = RAID_CLASS_COLORS[eclass].b
			else
				r, g, b = 0, 1, 0
			end
		
		elseif color == "fade" then
			if perc > 0.5 then
				r = (1.0 - perc) * 2
				g = 1.0
			else
				r = 1.0
				g = perc * 2
			end
			b = 0.0
		
		elseif color == "script" then
			if not hpfunc then
				self:sethpfunc()
			end
			r, g, b = hpfunc(perc, unit)
		end
		if r and self:getopt("changehpbg") then
			g = g or 0
			b = b or 0
			bgr, bgg, bgb = (r + 0.2)/3, (g + 0.2)/3, (b + 0.2)/3
		end
	end
	
  perc = format("%.0f", floor(perc * 100))
  return curr, max, missing, perc, r, g, b, bgr, bgg, bgb
end

function util:getclassicon(unit, isclass)
  local coords
  local texture = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"
  if isclass then
	coords = class[unit]
  else
	if UnitIsPlayer(unit) or UnitCreatureType(unit) == "Humanoid" then
	  local eclass = select(2, UnitClass(unit))
	  coords = class[eclass]
	else
	  coords = class["PETS"]
	  texture = "Interface\\RaidFrame\\UI-RaidFrame-Pets"
	end
  end
  return texture, coords
end

function util:getraceicon(unit)
  local erace = select(2, UnitRace(unit))
  local gender = UnitSex(unit)
  if gender == 1 then
	gender = "MALE"
  else
	gender = "FEMALE"
  end
  local coords = race[string.upper(erace).."_"..gender]
  return coords
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
  Text = {},
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
	--tbl[1]:ClearAllPoints()
	if type(tbl[2]) ~= "table" then
	  if tbl[2] == "all" then
		tbl[1]:SetAllPoints(tbl[1]:GetParent())
	  else
		tbl[1]:SetPoint(tbl[2])
	  end
	  
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

  for i = #framecomp.Text, 1, -1 do
	tbl = framecomp.Text[i]
	tbl[1]:SetText(tbl[2])
	table.remove(framecomp.Text, i)
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

  if layout.template then
	local template = layout.template
	while template do
	  layout.template = nil
	  layout = self:mergetable(layout, virtual[template])
	  template = layout.template
	end
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
	  local template = v.template
	  while template do
		v.template = nil
		v = self:mergetable(v, virtual[template])
		template = v.template
	  end
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
	elseif string.find(k, "^Point") or string.find(k, "^Anchor") then
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

local function onevent(self, event, ...)
	local tbl = events[event]
	if tbl then
		for _, func in ipairs(tbl) do
			func(event, ...)
		end
	else
		Nurfed:print("Nurfed-Error: Called UnregisteredEvent: %s", event)
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

CreateFrame("GameTooltip", "Nurfed_Tooltip", UIParent, "GameTooltipTemplate")
Nurfed_Tooltip:Show()
Nurfed_Tooltip:SetOwner(UIParent, "ANCHOR_NONE")

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

local function updatespells(event, arg1)
  if not spells then
	spells = {}
  end
  for i = 1, GetNumSpellTabs() do
	updatespelltab(i)
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

function util:getspells(search)
	local spells = {}
	local tabs = GetNumSpellTabs()
	for tab = 1, tabs do
		local _, _, offset, numSpells = GetSpellTabInfo(tab)
		spells[tab] = {}
		for i = 1, numSpells do
			local spell = offset + i
			if search then
				local spellname, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
				if search == spellname or search == spellname.."("..spellrank..")" then
					return spell, spellrank, BOOKTYPE_SPELL
				end
			elseif not IsPassiveSpell(spell, BOOKTYPE_SPELL) then
				local spellname, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
				if not spells[tab][spellname] then
					spells[tab][spellname] = {}
					table.insert(spells[tab], spellname)
				end
				table.insert(spells[tab][spellname], spell)
			end
		end
	end
	return spells
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
	if InterfaceOptionsFrame:IsShown() then
	  PlaySound("igAbilityClose")
	  InterfaceOptionsFrame:Hide()
	else
	  PlaySound("igAbilityOpen")
	  UIFrameFadeIn(InterfaceOptionsFrame, 0.25)
	  InterfaceOptionsFrame_OpenToFrame("Nurfed")
	end
  end
end

util:addslash(Nurfed_ToggleOptions, "/nurfed")
----------------------------------------------------------------
-- Addon version system
local nrf_ver, nrfo_ver, nrfa_ver, nrf_rev, nrfo_rev, nrfa_ver, nrfcl_ver, nrfcl_rev
-- no opt = Core, 1 = Options, 2 = Arena, 3 = Combat Log
function util:setver(ver, opt)
	ver = ver:gsub("^.-(%d%d%d%d%-%d%d%-%d%d).-$", "%1")
	ver = ver:match("-%d%d"):gsub("-", "").."."..ver:match("-%d%d", 6):gsub("-", "").."."..ver:match("%d%d%d%d")
	if opt then
		if opt == 1 then
			if not nrfo_ver or ver > nrfo_ver then
				nrfo_ver = ver
			end
		elseif opt == 2 then
			if not nrfa_ver or ver > nrfa_ver then
				nrfa_ver = ver
			end
		elseif opt == 3 then
			if not nrfcl_ver or ver > nrfcl_ver then
				nrfcl_ver = ver
			end
		end
	else
		if not nrf_ver or ver > nrf_ver then
			nrf_ver = ver
		end
	end
end

function util:getver(opt)
	if opt then
		if opt == 1 then
			return nrfo_ver or "Not Installed"
		elseif opt == 2 then
			return nrfa_ver or "Not Installed"
		elseif opt == 3 then
			return nrfcl_ver or "Not Installed"
		end
	end
	return nrf_ver or "Unknown"
end

function util:setrev(rev, opt)
	rev = rev:gsub("%$", ""):gsub("%s$", "", 1)
	if opt then
		if opt == 1 then
			if not nrfo_rev or rev > nrfo_rev then
				nrfo_rev = rev
			end
		elseif opt == 2 then
			if not nrfa_rev or rev > nrfa_rev then
				nrfa_rev = rev
			end
		elseif opt == 3 then
			if not nrfcl_rev or rev > nrfcl_rev then
				nrfcl_rev = rev
			end
		end
	else
		if not nrf_rev or rev > nrf_rev then
			nrf_rev = rev
		end
	end
end

function util:getrev(opt)
	if opt then
		if opt == 1 then
			return nrfo_rev or ""
		elseif opt == 2 then
			return nrfa_rev or ""
		elseif opt == 3 then
			return nrfcl_rev or ""
		end
	end
	return nrf_rev or ""
end
----------------------------------------------------------------
-- Addon message database
local addonfunc = {}

function util:addmsg(cmd, func)
  addonfunc[cmd] = func
end

local addonmsg = function(event, ...)
  if arg4 ~= UnitName("player") then
	local check, cmd = string.split(":", arg1)
	if check and check == "Nurfed" and addonfunc[cmd] then
	  addonfunc[cmd](arg4, arg2)
	end
  end
end

util:addslash(function(...)
	local arg, arg2 = string.split(" ", ...)
	arg, arg2 = tonumber(arg), tonumber(arg2)
	while arg <= arg2 do
		if GetSpellLink(arg) then
			Nurfed:print(GetSpellLink(arg))
		end
		arg = arg + 1
	end
end, "/nrfspelllinks")
		
util:regevent("CHAT_MSG_ADDON", addonmsg)
Nurfed:setver("$Date$")
Nurfed:setrev("$Rev$")