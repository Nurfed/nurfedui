-- the intention of this file is to keep out clutter of other files to be able to do more things with multiple specs.
-- eventually this will allow for a more wide range of support, cleaner implemination, and further features.
NURFED_BINDINGS = NURFED_BINDINGS or {}
--local _G = getfenv(0)
local GetActiveTalentGroup = _G.GetActiveTalentGroup
local Nurfed = _G.Nurfed
local L = Nurfed:GetTranslations()
local currentTalentGroup
local callLst = {}

function Nurfed_Add_Talent_Call(func)
	if func then
		for i, tfunc in ipairs(callLst) do
			if func == tfunc then
				return callLst[i]
			end
		end
		return table.insert(callLst, func)
	end
	return nil
end

function Nurfed_Remove_Talent_Call(func)
	if func then
		for i, tfunc in ipairs(callLst) do
			if tfunc == func then
				return table.remove(callLst, i)
			end
		end
	end
	return nil
end

local function update_active_talent_calls(new, old)
	for i, func in ipairs(callLst) do
		func(new, old)
	end
end

local function active_talent_changed(event, new, old)
	if currentTalentGroup then
		if currentTalentGroup == old then
			currentTalentGroup = new
			Nurfed:print(L["Nurfed-MultiSpec:  "]..L["Talent Groups Changed, New Group: "]..new)
		end
	else
		currentTalentGroup = GetActiveTalentGroup(false, false)
		Nurfed:print(L["Nurfed-MultiSpec:  "]..L["Talent Group Set, Group: "]..currentTalentGroup)
	end
	update_active_talent_calls(currentTalentGroup, old)
end

----]]]]]]]]]]]]]]]]]]]]]]]]]]==============================================-]]]]
-- binding information ------------------------------------------------------]]]]
----]]]]]]]]]]]]]]]]]]]]]]]]]]==============================================-]]]]
local macros, spells, listing
local function updatespells()
	local offset, numSpells, spell, spellname, spellrank
	spells = {}
	for tab = 1, GetNumSpellTabs() do
		_, _, offset, numSpells = GetSpellTabInfo(tab)
		spells[tab] = {}
		for i = 1, numSpells do
			spell = offset + i
			if not IsPassiveSpell(spell, BOOKTYPE_SPELL) then
				spellname, spellrank = GetSpellName(spell, BOOKTYPE_SPELL)
				if not spells[tab][spellname] then
					spells[tab][spellname] = {}
					table.insert(spells[tab], spellname)
				end
				table.insert(spells[tab][spellname], spell)
			end
		end
	end
	listing = nil
end

local updatemacros = function()
	local all, char, name, texture
	macros = { {}, {} }
	all, char = GetNumMacros()
	for i = 1, all do
		name, texture = GetMacroInfo(i)
		table.insert(macros[1], {name, texture})
	end
	
	name, texture = nil, nil
	for i = 37, char + 36 do
		name, texture = GetMacroInfo(i)
		table.insert(macros[2], { name, texture })
	end
	listing = nil
end

function Nurfed_Save_Talent_Bindings(arg)
	if not macros then updatemacros() end
	if not spells then updatespells() end
	if not listing then
		listing = {}	-- create the list set....initial code is being jacked from the bindings interface.
		-- TODO:  rewrite this crap.
		for i=1, #spells do	-- spells
			local name = GetSpellTabInfo(i)
			table.insert(listing, { name, "|cff0099ff" })
			for k, v in ipairs(spells[i]) do
				table.insert(listing, { v, spells[i][v], "SPELL" })
			end
		end
		for i=1, #macros do	-- macros
			if i == 1 then
				table.insert(listing, { GENERAL_MACROS, "|cff00ff00" })
			else
				local text = string.format(CHARACTER_SPECIFIC_MACROS, UnitName("player"))
				table.insert(listing, { text, "|cff00ff00" })
			end
			for k, v in ipairs(macros[i]) do
				table.insert(listing, { v[1], v[2], "MACRO" })
			end
		end
		if NURFED_ITEMS then
			for _, v in ipairs(NURFED_ITEMS) do	-- items
				table.insert(listing, { v, true, "ITEM" })
			end
		end
		for _, v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do -- actionbars.... are these really needed?
			table.insert(listing, { v.name, "|cffff00ff" })
			local btns = { getglobal(v.name):GetChildren() }
			for _, btn in ipairs(btns) do
				if btn:GetID() > 0 then
					table.insert(listing, { btn:GetName(), true, "CLICK" })
				end
			end
		end
	end
	
	-- calculate the bindings and store them
	bindingsList = {
		["MACRO"] = {},
		["SPELL"] = {},
		["ITEM"] = {},
		["CLICK"] = {},
	}
	for i,v in ipairs(listing) do
		for num=1,#listing do
			if listing[num] and listing[num][3] then
				local key
				local spell = listing[num][1]

	--[[			if listing[num][3] == "SPELL" then
					if #listing[num][2] > 1 then
						if NurfedBindingsPanelList[spell] then
							spell = spell.."("..RANK.." "..NurfedBindingsPanelList[spell]..")"
						end
					end
				
				elseif listing[num][3] == "MACRO" then
				elseif listing[num][3] == "ITEM" then
				elseif listing[num][3] == "CLICK" then
					key = spell..":LeftButton"
					spell = "Button "..getglobal(spell):GetID()
				end]]
					      
				if listing[num] and key or spell then
					local bind
					if listing[num][3] == "CLICK" then
						local tkey = spell..":LeftButton"
						local tspell = "Button "..getglobal(spell):GetID()
						bind = GetBindingKey(listing[num][3].." "..(tkey or tspell) )
					else
						bind = GetBindingKey(listing[num][3].." "..(key or spell) )
					end
					if listing[num][3] == "MACRO" then
						bindingsList["MACRO"][key or spell] = bind
					elseif listing[num][3] == "ITEM" then
						bindingsList["ITEM"][key or spell] = bind
					elseif listing[num][3] == "CLICK" then
						bindingsList["CLICK"][key or spell] = bind
					elseif listing[num][3] == "SPELL" then
						bindingsList["SPELL"][key or spell] = bind
					end
				end
			end
		end
	end
	NURFED_BINDINGS["talent-group-"..currentTalentGroup] = bindingsList
	if arg then
		NURFED_BINDINGS["talent-group-1"] = bindingsList
		NURFED_BINDINGS["talent-group-2"] = bindingsList
	end
	Nurfed:print(L["Nurfed-MultiSpec:  "]..L["Talent Bindings Saved!"])
end

local function update_talent_bindings(new, old)
	new = new or currentTalentGroup
	local binds = NURFED_BINDINGS["talent-group-"..new]
	if not binds then
		 Nurfed_Save_Talent_Bindings(true)
		 binds = NURFED_BINDINGS["talent-group-"..new]
		 if not binds then return end
	end
	for type in pairs(binds) do
		--type = string.capital(type)
		local func = getglobal("SetBinding"..string.capital(type))
		for spell, key in pairs(binds[type]) do
			SetBinding(key)
			
			func(key, spell)
			
			if string.capital(type) == "Click" then
				spell = spell..":LeftButton"
			end
			
			local old = { GetBindingKey(string.capital(type).." "..spell) }
			for _, v in ipairs(old) do
				if v ~= key then
					SetBinding(v)
				end
			end
		end
	end
	SaveBindings(GetCurrentBindingSet())
	Nurfed:sendevent("UPDATE_BINDINGS")
	--[[
	if binds then
		for name, key in pairs(binds["MACRO"]) do
			SetBinding(key)
			SetBindingMacro(key, name)
		end
		for name, key in pairs(binds["CLICK"]) do
			SetBinding(key)
			SetBindingClick(key, name)
		end
		for name, key in pairs(binds["ITEM"]) do
			SetBinding(key)
			SetBindingItem(key, name)
		end
		for name, key in pairs(binds["SPELL"]) do
			SetBinding(key)
			SetBindingSpell(key, name)
		end
		Nurfed:sendevent("UPDATE_BINDINGS")
		SaveBindings(GetCurrentBindingSet())
	end]]
end

Nurfed_Add_Talent_Call(update_talent_bindings)

Nurfed:regevent("PLAYER_LOGIN", active_talent_changed)
Nurfed:regevent("ACTIVE_TALENT_GROUP_CHANGED", active_talent_changed)
