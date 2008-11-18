------------------------------------------
--  Nurfed Bindings

-- Saved item links for bindings
NURFED_ITEMS = NURFED_ITEMS or {}

local bind, spells, macros, listing

local function addcursoritem()
	local ctype, itemID = GetCursorInfo()
	if ctype == "item" then
		ClearCursor()
		if IsConsumableItem(itemID) or GetItemSpell(itemID) then
			local item = GetItemInfo(itemID)
			NURFED_ITEMS[item] = itemID
			for _, v in ipairs(NURFED_ITEMS) do
				if v == item then return end
			end
			table.insert(NURFED_ITEMS, item)
			table.sort(NURFED_ITEMS, function(a, b) return a < b end)
			listing = nil
			Nurfed_ScrollBindings()
		end
	end
end

local function removeitem(item)
	NURFED_ITEMS[item] = nil
	for k, v in ipairs(NURFED_ITEMS) do
		if v == item then
			table.remove(NURFED_ITEMS, k)
			listing = nil
			Nurfed_ScrollBindings()
			return
		end
	end
end

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

function Nurfed_MouseWheelBindings(self, val)
	if NurfedBindingsPanelList.spell then
		if val > 0 then
			Nurfed_Binding_OnKeyDown("MOUSEWHEELUP")
		else
			Nurfed_Binding_OnKeyDown("MOUSEWHEELDOWN")
		end
	else
		ScrollFrameTemplate_OnMouseWheel(self, val)
	end
end

function Nurfed_ScrollBindings()
  if not spells then updatespells() end
  if not macros then updatemacros() end

  if not listing then
    listing = {}
    for i = 1, #spells do
      local name = GetSpellTabInfo(i)
      table.insert(listing, { name, "|cff0099ff" })
      for k, v in ipairs(spells[i]) do
        table.insert(listing, { v, spells[i][v], "SPELL" })
      end
    end

    table.insert(listing, { " ", "|cff00ff00" })

    for i = 1, #macros do
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

    table.insert(listing, { " ", "|cffffff00" })
    table.insert(listing, { ITEMS, "|cffffff00" })

    for _, v in ipairs(NURFED_ITEMS) do
      table.insert(listing, { v, true, "ITEM" })
    end

    for _, v in ipairs(NURFED_ACTIONBARS) do
      table.insert(listing, { " ", "|cffffff00" })
      table.insert(listing, { v.name, "|cffff00ff" })
      local btns = { getglobal(v.name):GetChildren() }
      for _, btn in ipairs(btns) do
        if btn:GetID() > 0 then
          table.insert(listing, { btn:GetName(), true, "CLICK" })
        end
      end
    end
  end

	local format_row = function(row, num)
		local name = getglobal(row:GetName().."name")
		local binding = getglobal(row:GetName().."binding")
		local icon = getglobal(row:GetName().."icon")
		local hl = getglobal(row:GetName().."HighlightTexture")
		binding:SetText(nil)
		icon:Hide()
		row.ranks = nil
		row.spell = nil
		row.item = nil
		
		if listing[num][3] then
			local key
			local spell = listing[num][1]
			row.spell = spell
			
			if NurfedBindingsPanelList.spell == spell then
				row:LockHighlight()
				hl:SetVertexColor(1, 0, 0)
				row:EnableKeyboard(true)
				bind = listing[num][3]
			else
				row:UnlockHighlight()
				hl:SetVertexColor(1, 1, 0)
				row:EnableKeyboard(nil)
			end
			
			if listing[num][3] == "SPELL" then
				icon:SetTexture(GetSpellTexture(listing[num][2][1], BOOKTYPE_SPELL))
				if #listing[num][2] > 1 then
					row.ranks = #listing[num][2]
					if NurfedBindingsPanelList[spell] then
						spell = spell.."("..RANK.." "..NurfedBindingsPanelList[spell]..")"
					end
				end
			
			elseif listing[num][3] == "MACRO" then
				icon:SetTexture(listing[num][2])
			
			elseif listing[num][3] == "ITEM" then
				local itemid = NURFED_ITEMS[spell]
				icon:SetTexture(GetItemIcon(itemid or spell))
				row.item = true
			
			elseif listing[num][3] == "CLICK" then
				icon:SetTexture(nil)
				key = spell..":LeftButton"
				spell = "Button "..getglobal(spell):GetID()
			end
			name:SetPoint("LEFT", icon, "RIGHT", 3, 0)
			name:SetText(spell)
			icon:Show()
      
			if binding then
				if listing[num] and key or spell then
					binding:SetText(GetBindingKey(listing[num][3].." "..(key or spell)))	
				end
			end
		else
			name:SetText(listing[num][2]..listing[num][1].."|r")
			name:SetPoint("LEFT", row, "LEFT", 5, 0)
		end
	end

	local frame = NurfedBindingsPanelListscroll
	FauxScrollFrame_Update(frame, #listing, 23, 14)
	for line = 1, 23 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = _G["NurfedBindingsRow"..line]
		if offset <= #listing then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
	CloseDropDownMenus()
end

function Nurfed_Binding_OnKeyDown(self, keyPressed)
	local screenshotKey = GetBindingKey("SCREENSHOT")
	if screenshotKey and keyPressed == screenshotKey then
		Screenshot()
		return
	end
	if keyPressed == "ESCAPE" then
		HideUIPanel(Nurfed_Menu)
		return
	end

	if NurfedBindingsPanelList.spell then
		if keyPressed == "UNKNOWN" or keyPressed == "SHIFT" or keyPressed == "CTRL" or keyPressed == "ALT" then
		  return
		end
		
		if keyPressed == "MiddleButton" then keyPressed = "BUTTON3"
		elseif keyPressed == "Button4" then keyPressed = "BUTTON4"
		elseif keyPressed == "Button5" then keyPressed = "BUTTON5"
		end
		
		if IsShiftKeyDown() then keyPressed = "SHIFT-"..keyPressed end
		if IsControlKeyDown() then keyPressed = "CTRL-"..keyPressed end
		if IsAltKeyDown() then keyPressed = "ALT-"..keyPressed end
		
		local spell = NurfedBindingsPanelList.spell
		if NurfedBindingsPanelList[spell] then
			spell = spell.."("..RANK.." "..NurfedBindingsPanelList[spell]..")"
		end
		
		local key
		if bind == "CLICK" then
			key = GetBindingKey(bind.." "..spell..":LeftButton")
		else
			key = GetBindingKey(bind.." "..spell)
		end
		
		local text, data
		if key == keyPressed then
			text = "Unbind |cff00ff00"..spell.."|r?"
			NurfedBindingsPanelList.data = { keyPressed }
		else
			text = "Bind |cff00ff00"..spell.."|r to |cffff0000"..keyPressed.."|r?"
			local oldkey = GetBindingAction(keyPressed)
			if getglobal("BINDING_NAME_"..oldkey) then
				oldkey = getglobal("BINDING_NAME_"..oldkey)
			end
			
			if oldkey ~= "" then
				text = "Current: |cff00ff00"..oldkey.."|r\n"..text
			end
			
			if string.find(spell, " %(") then
				spell = spell.."()"
			end
			NurfedBindingsPanelList.data = { keyPressed, spell, bind }
		end
		StaticPopupDialogs["NRF_BINDKEY"].text = text
		StaticPopup_Show("NRF_BINDKEY")
	end
end

function Nurfed_Binding_OnClick(self, button)
	if not self.spell then return end
	if button == "LeftButton" then
		local spellname = self.spell
		if NurfedBindingsPanelList.spell == spellname then
			NurfedBindingsPanelList.spell = nil
		else
			NurfedBindingsPanelList.spell = spellname
		end
		if NurfedBindingsPanelList[spellname] then
			spellname = spellname.." ("..RANK.." "..NurfedBindingsPanelList[spellname]..")"
		end
		Nurfed_ScrollBindings()
  
	elseif button == "RightButton" then
		if self.ranks then
			local dropdown = getglobal(self:GetName().."dropdown")
			local info = {}
			local spell = self.spell
			dropdown.displayMode = "MENU"
			dropdown.initialize = function()
				info.text = spell
				info.isTitle = 1
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info)
				
				info = {}
				info.text = "Max "..RANK
				info.func = function() Nurfed_Binding_Dropdown(spell) end
				info.isTitle = nil
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info)
				
				for i = 1, self.ranks do
					info.text = "("..RANK.." "..i..")"
					info.func = function() Nurfed_Binding_Dropdown(spell, i) end
					info.isTitle = nil
					info.notCheckable = 1
					UIDropDownMenu_AddButton(info)
				end
			end
			ToggleDropDownMenu(1, nil, dropdown, "cursor")
		
		elseif self.item then
			local dropdown = getglobal(self:GetName().."dropdown")
			local info = {}
			local item = self.spell
			dropdown.displayMode = "MENU"
			dropdown.initialize = function()
				info.text = item
				info.isTitle = 1
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info)

				info = {}
				info.text = REMOVE
				info.func = function() removeitem(item) end
				info.isTitle = nil
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info)
			end
			ToggleDropDownMenu(1, nil, dropdown, "cursor")
		end
	else
		Nurfed_Binding_OnKeyDown(self, button)
	end
end

function Nurfed_Binding_Dropdown(spell, rank)
	if rank then
		NurfedBindingsPanelList[spell] = rank
	elseif NurfedBindingsPanelList[spell] then
		NurfedBindingsPanelList[spell] = nil
	end
	Nurfed_ScrollBindings()
end

function Nurfed_Binding_Save(key, spell, type)
	SetBinding(key)
	if spell then
		type = string.capital(type)
		local func = getglobal("SetBinding"..type)
		func(key, spell)
		if type == "Click" then
			spell = spell..":LeftButton"
		end
		local old = { GetBindingKey(type.." "..spell) }
		for _, v in ipairs(old) do
			if v ~= key then
				SetBinding(v)
			end
		end
	end
	SaveBindings(GetCurrentBindingSet())
end

-- Overwrite binding popup
StaticPopupDialogs["NRF_BINDKEY"] = {
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		local info = NurfedBindingsPanelList.data
		Nurfed_Binding_Save(unpack(info))
		NurfedBindingsPanelList.data = nil
		NurfedBindingsPanelList.spell = nil
		Nurfed_ScrollBindings()
	end,
	timeout = 10,
	whileDead = 1,
	hideOnEscape = 1,
}

Nurfed:createtemp("nrf_bindings_row", {
  type = "Button",
  size = { 375, 14 },
  children = {
    dropdown = { type = "Frame" },
    name = {
      type = "FontString",
      layer = "ARTWORK",
      size = { 200, 14 },
      Anchor = { "LEFT", "$parent", "LEFT", 5, 0 },
      FontObject = "GameFontNormal",
      JustifyH = "LEFT",
      TextColor = { 1, 1, 1 },
    },
    icon = {
      type = "Texture",
      layer = "ARTWORK",
      size = { 14, 14 },
      Anchor = { "LEFT", "$parent", "LEFT", 15, 0 },
    },
    binding = {
      type = "FontString",
      layer = "ARTWORK",
      size = { 130, 14 },
      Anchor = { "LEFT", "$parentname", "RIGHT", 10, 0 },
      FontObject = "GameFontNormal",
      JustifyH = "LEFT",
      TextColor = { 1, 0, 0 },
    },
    HighlightTexture = {
      type = "Texture",
      layer = "BACKGROUND",
      Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
      BlendMode = "ADD",
      Anchor = "all",
    },
  },
  OnClick = function(...) if GetCursorInfo() then addcursoritem(...) else Nurfed_Binding_OnClick(...) end end,
  OnKeyDown = Nurfed_Binding_OnKeyDown,
  OnReceiveDrag = function(...) if GetCursorInfo() then addcursoritem(...) end end,
})
Nurfed:regevent("LEARNED_SPELL_IN_TAB", updatespells)
Nurfed:regevent("UPDATE_MACROS", updatemacros)

function Nurfed_BindingsCreate()
	local row
	for i = 1, 23 do
		row = Nurfed:create("NurfedBindingsRow"..i, "nrf_bindings_row", NurfedBindingsPanelList)
		row:RegisterForClicks("AnyUp")
		if i == 1 then
			row:SetPoint("TOPLEFT", 0, -3)
		else
			row:SetPoint("TOPLEFT", "NurfedBindingsRow"..(i - 1), "BOTTOMLEFT", 0, 0)
		end
	end
end
Nurfed:setversion("Nurfed-Options", "$Date$", "$Rev$")