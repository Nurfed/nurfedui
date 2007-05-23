local units = { "none", "focus", "party1", "party2", "party3", "party4", "pet", "player", "target", "targettarget" }
local states = { "stance:", "stealth:", "actionbar:", "shift:", "ctrl:", "alt:" }

local framedrop = function(tbl)
	local drop = Nurfed_MenuActionBarsdropdown
	local info = {}
	local parent = this:GetParent()
	drop.displayMode = "MENU"
	drop.initialize = function()
		for _, v in ipairs(tbl) do
			info = {}
			info.text = v
			info.value = v
			info.func = function() parent:SetText(this.value) end
			info.isTitle = nil
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info)
		end
	end
	ToggleDropDownMenu(1, nil, drop, "cursor")
end

local updateoptions = function()
	local bar = Nurfed_MenuActionBars.bar
	if bar then
		local vals = NURFED_ACTIONBARS[bar]
		Nurfed_MenuActionBarsbarrows:SetValue(vals.rows)
		Nurfed_MenuActionBarsbarcols:SetValue(vals.cols)
		Nurfed_MenuActionBarsbarscale:SetValue(vals.scale)
		Nurfed_MenuActionBarsbaralpha:SetValue(vals.alpha)
		Nurfed_MenuActionBarsbarunit:SetText(vals.unit or "")
		Nurfed_MenuActionBarsbarunitshow:SetChecked(vals.unitshow)
		Nurfed_MenuActionBarsbarxgap:SetValue(vals.xgap)
		Nurfed_MenuActionBarsbarygap:SetValue(vals.ygap)
	end
end

local addstate = function()
	local bar = Nurfed_MenuActionBars.bar
	if bar then
		local statemaps = NURFED_ACTIONBARS[bar].statemaps
		local state = Nurfed_MenuActionBarsstatesstate:GetText()
		local map = Nurfed_MenuActionBarsstatesmap:GetText()
		state = string.trim(state)
		map = string.trim(map)
		if map == "" or state == "" then
			return
		end
		statemaps[state] = map
		Nurfed:updatebar(getglobal(bar))
		Nurfed_ScrollActionBarsStates()
		Nurfed_MenuActionBarsstatesstate:SetText("")
		Nurfed_MenuActionBarsstatesmap:SetText("")
		if this.ClearFocus then
			this:ClearFocus()
		end
	end
end

local updatebuttons = function()
	local btn = Nurfed_MenuActionBars.bar
	if btn then
		Nurfed_MenuActionBarsbuttondefaulttext:SetText(DEFAULT)
		Nurfed_MenuActionBarsbuttonhelptext:SetText(FACTION_STANDING_LABEL5)
		Nurfed_MenuActionBarsbuttonharmtext:SetText(FACTION_STANDING_LABEL2)
		btn = getglobal(btn)

		local value = btn:GetAttribute("state-parent")
		local helpv = SecureButton_GetModifiedAttribute(btn, "helpbutton", value)
		local harmv = SecureButton_GetModifiedAttribute(btn, "harmbutton", value)


		local default = SecureButton_GetModifiedAttribute(btn, "type", value)
		local help = SecureButton_GetModifiedAttribute(btn, "type", helpv)
		local harm = SecureButton_GetModifiedAttribute(btn, "type", harmv)

		local seticon = function(opt, val, name)
			local texture, stext
			local button = getglobal("Nurfed_MenuActionBarsbutton"..name)
			local icon = getglobal("Nurfed_MenuActionBarsbutton"..name.."Icon")
			local text = getglobal("Nurfed_MenuActionBarsbutton"..name.."Name")
			button.spell = nil
			button.item = nil
			if opt then
				local spell = SecureButton_GetModifiedAttribute(btn, opt, val)
				if spell then
					if opt == "spell" then
						texture = GetSpellTexture(spell)
						button.spell = spell
					elseif opt == "item" then
						texture = select(10, GetItemInfo(spell))
						button.item = spell
					elseif opt == "macro" then
						texture = select(2, GetMacroInfo(spell))
						stext = spell
					end
				end
				button.opt = opt
			end
			icon:SetTexture(texture)
			text:SetText(stext)
		end

		seticon(default, value, "default")
		seticon(help, helpv, "help")
		seticon(harm, harmv, "harm")
	end
end

local addnew = function()
	local objtype = this:GetObjectType()
	if objtype == "Button" then
		this = this:GetParent()
	end
	local text = this:GetText()
	if text ~= "" and not NURFED_ACTIONBARS[text] then
		local unit = Nurfed_MenuActionBarsbarunit:GetText()
		unit = string.trim(unit)
		if unit == "" then unit = nil end
		NURFED_ACTIONBARS[text] = {
			unit = unit,
			rows = Nurfed_MenuActionBarsbarrows:GetValue(),
			cols = Nurfed_MenuActionBarsbarcols:GetValue(),
			scale = Nurfed_MenuActionBarsbarscale:GetValue(),
			alpha = Nurfed_MenuActionBarsbaralpha:GetValue(),
			unitshow = Nurfed_MenuActionBarsbarunitshow:GetChecked(),
			combatshow = Nurfed_MenuActionBarsbarcombatshow:GetChecked(),
			xgap = Nurfed_MenuActionBarsbarxgap:GetValue(),
			ygap = Nurfed_MenuActionBarsbarygap:GetValue(),
			buttons = {},
			statemaps = {},
		}
		Nurfed:createbar(text)
		this:SetText("")
		Nurfed_ScrollActionBars()
	end
end

local updatebar = function()
	local bar = Nurfed_MenuActionBars.bar
	if bar then
		local value
		local objtype = this:GetObjectType()
		if objtype == "Slider" then
			value = this:GetValue()
		elseif objtype == "CheckButton" then
			value = this:GetChecked()
		elseif objtype == "EditBox" then
			value = this:GetText()
			if this.val ~= "unit" then
				value = tonumber(value)
			end
		end
		NURFED_ACTIONBARS[bar][this.val] = value
		local hdr = getglobal(bar)
		if this.val == "scale" then
			hdr:SetScale(value)
		elseif this.val == "unit" then
			if value == "" then value = nil end
			if hdr:GetAttribute("unit") ~= value then
				hdr:SetAttribute("unit", value)
				Nurfed:updatebar(hdr)
			end
		elseif this.val == "alpha" then
			local children = { hdr:GetChildren() }
			for _, child in ipairs(children) do
				child:SetAlpha(value)
			end
		elseif this.val == "unitshow" then
			if value then
				RegisterUnitWatch(hdr)
			else
				UnregisterUnitWatch(hdr)
				hdr:Show()
			end
		elseif this.val == "combatshow" then
			if not InCombatLockdown() then
				if value then
					hdr:Hide()
				else
					hdr:Show()
				end
				hdr:SetAttribute("combat", value)
			end
		else
			Nurfed:updatebar(hdr)
			Nurfed_ScrollActionBars()
		end
	end
end

local ondragstart = function(self)
	local btn = Nurfed_MenuActionBars.bar
	btn = getglobal(btn)
	local id = btn:GetID()
	local parent = btn:GetParent():GetName()
	local value = "-"..btn:GetAttribute("state-parent")
	local prefix = "*"
	if IsModifierKeyDown() then
		prefix = SecureButton_GetModifierPrefix()
	end

	if self.t then
		btn:SetAttribute(prefix..self.t..value, nil)
		value = "-"..self.s..value
	else
		value = "*"
	end
	btn:SetAttribute(prefix.."type"..value, nil)
	btn:SetAttribute(prefix..self.opt..value, nil)

	updatebuttons()
end

local onreceivedrag = function(self)
	local btn = Nurfed_MenuActionBars.bar
	btn = getglobal(btn)
	local cursoritem = Nurfed:getcursor()
	if cursoritem then
		local id = btn:GetID()
		local parent = btn:GetParent():GetName()
		local value = "-"..btn:GetAttribute("state-parent")
		local prefix = "*"
		if IsModifierKeyDown() then
			prefix = SecureButton_GetModifierPrefix()
		end

		if self.t then
			btn:SetAttribute(prefix..self.t..value, self.s..value)
			value = "-"..self.s..value
		else
			value = "*"
		end

		btn:SetAttribute(prefix.."type"..value, cursoritem[2])
		btn:SetAttribute(prefix..cursoritem[2]..value, cursoritem[1])
		if cursoritem[2] == "spell" then
			btn:SetAttribute(prefix.."item"..value, nil)
			btn:SetAttribute(prefix.."macro"..value, nil)
		elseif cursoritem[2] == "item" then
			btn:SetAttribute(prefix.."spell"..value, nil)
			btn:SetAttribute(prefix.."macro"..value, nil)
		elseif cursoritem[2] == "macro" then
			btn:SetAttribute(prefix.."spell"..value, nil)
			btn:SetAttribute(prefix.."item"..value, nil)
		end
		ClearCursor()
		updatebuttons()
	end
end

local onenter = function(self)
	if self.spell or self.item then
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")

		if self.spell then
			local id, rank, book = Nurfed:getspells(self.spell)
			GameTooltip:SetSpell(id, book)
			GameTooltipTextLeft1:SetText(self.spell)
		elseif self.item then
			GameTooltip:SetHyperlink(select(2, GetItemInfo(self.item)))
		end
		GameTooltip:Show()
	end
end

local onleave = function(self)
	GameTooltip:Hide()
end

local postclick = function(self)
	self:SetChecked(nil)
	onreceivedrag(self)
end

local onkeydown = function(self, arg1)
	local keyPressed = arg1
	local screenshotKey = GetBindingKey("SCREENSHOT")
	if keyPressed == "ESCAPE" then
		HideUIPanel(Nurfed_Menu)
	elseif screenshotKey and keyPressed == screenshotKey then
		Screenshot()
	elseif keyPressed == "SHIFT" or keyPressed == "CTRL" or keyPressed == "ALT" then
		updatebuttons()
	else
		if IsShiftKeyDown() then keyPressed = "SHIFT-"..keyPressed end
		if IsControlKeyDown() then keyPressed = "CTRL-"..keyPressed end
		if IsAltKeyDown() then keyPressed = "ALT-"..keyPressed end
		local action = GetBindingAction(keyPressed)
		if action and not string.find(action, "^MOVE") and not string.find(action, "^TURN") and not string.find(action, "^JUMP") and not string.find(action, "^TARGET") and not string.find(action, "^TARGET") then
			RunBinding(action)
		end
	end
end

NURFED_MENUS["ActionBars"] = {
	template = "nrf_options",
	children = {
		dropdown = { type = "Frame" },
		scroll = {
			type = "ScrollFrame",
			size = { 165, 250 },
			Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
			uitemp = "FauxScrollFrameTemplate",
			OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollActionBars) end,
			OnShow = function() Nurfed_ScrollActionBars() end,
		},
		backing = {
			type = "Frame",
			size = { 173, 250 },
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
			BackdropColor = { 0, 0, 0, 0 },
			Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
		},
		add = {
			template = "nrf_editbox",
			size = { 130, 18 },
			children = {
				add = {
					template = "nrf_button",
					Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
					Text = NEW,
					OnClick = addnew,
				},
			},
			OnEnterPressed = addnew,
			Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -4 },
		},
		bar = {
			type = "Frame",
			size = { 100, 100 },
			Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
			children = {
				unit = {
					template = "nrf_editbox",
					size = { 100, 18 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -50, -10 },
					children = {
						add = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "Unit",
							OnClick = function() framedrop(units) end,
						},
					},
					OnTextChanged = function() updatebar() end,
					OnEnterPressed = function() updatebar() end,
					vars = { val = "unit", default = "target" },
				},
				unitshow = {
					template = "nrf_check",
					Anchor = { "TOPRIGHT", "$parentunitadd", "BOTTOMRIGHT", 0, -8 },
					OnClick = function() updatebar() end,
					vars = { text = "Unit Toggle", val = "unitshow" },
				},
				combatshow = {
					template = "nrf_check",
					Anchor = { "RIGHT", "$parentunitshow", "LEFT", -85, 0 },
					OnClick = function() updatebar() end,
					vars = { text = "Combat Toggle", val = "combatshow" },
				},
				rows = {
					template = "nrf_slider",
					Anchor = { "TOPRIGHT", "$parentunitshow", "BOTTOMRIGHT", 0, -13 },
					vars = {
						text = "Rows",
						val = "rows",
						low = 1,
						high = 24,
						min = 1,
						max = 24,
						step = 1,
						format = "%.0f",
						right = true,
						default = 1,
					},
					OnMouseUp = function() updatebar() end,
				},
				cols = {
					template = "nrf_slider",
					Anchor = { "TOPRIGHT", "$parentrows", "BOTTOMRIGHT", 0, -18 },
					vars = {
						text = "Columns",
						val = "cols",
						low = 1,
						high = 24,
						min = 1,
						max = 24,
						step = 1,
						format = "%.0f",
						right = true,
						default = 12,
					},
					OnMouseUp = function() updatebar() end,
				},
				scale = {
					template = "nrf_slider",
					Anchor = { "TOPRIGHT", "$parentcols", "BOTTOMRIGHT", 0, -18 },
					vars = {
						text = "Scale",
						val = "scale",
						low = "25%",
						high = "300%",
						min = 0.25,
						max = 3,
						step = 0.01,
						format = "%.2f",
						deci = 2,
						right = true,
						default = 1,
					},
					OnMouseUp = function() updatebar() end,
				},
				alpha = {
					template = "nrf_slider",
					Anchor = { "TOPRIGHT", "$parentscale", "BOTTOMRIGHT", 0, -18 },
					vars = {
						text = "Alpha",
						val = "alpha",
						low = "0%",
						high = "100%",
						min = 0,
						max = 1,
						step = 0.01,
						format = "%.2f",
						deci = 2,
						right = true,
						default = 1,
					},
					OnMouseUp = function() updatebar() end,
				},
				xgap = {
					template = "nrf_slider",
					Anchor = { "TOPRIGHT", "$parentalpha", "BOTTOMRIGHT", 0, -18 },
					vars = {
						text = "X Gap",
						val = "xgap",
						low = -2,
						high = 50,
						min = -2,
						max = 50,
						step = 1,
						format = "%.0f",
						right = true,
						default = 2,
					},
					OnMouseUp = function() updatebar() end,
				},
				ygap = {
					template = "nrf_slider",
					Anchor = { "TOPRIGHT", "$parentxgap", "BOTTOMRIGHT", 0, -18 },
					vars = {
						text = "Y Gap",
						val = "ygap",
						low = -2,
						high = 50,
						min = -2,
						max = 50,
						step = 1,
						format = "%.0f",
						right = true,
						default = 2,
					},
					OnMouseUp = function() updatebar() end,
				},
			},
		},
		button = {
			type = "Frame",
			size = { 100, 100 },
			uitemp = "SecureStateDriverTemplate",
			Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -20, -60 },
			--Keyboard = true,
			children = {
				default = {
					type = "CheckButton",
					uitemp = "SecureActionButtonTemplate, ActionButtonTemplate",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
					children = {
						text = {
							type = "FontString",
							Anchor = { "RIGHT", "$parent", "LEFT", -15, 0 },
							FontObject = "GameFontNormalHuge",
						},
					},
					OnEnter = onenter,
					OnLeave = onleave,
					PostClick = postclick,
					OnDragStart = ondragstart,
					OnReceiveDrag = onreceivedrag,
					OnAttributeChanged = updatebuttons,
				},
				help = {
					type = "CheckButton",
					uitemp = "SecureActionButtonTemplate, ActionButtonTemplate",
					Anchor = { "TOPRIGHT", "$parentdefault", "BOTTOMRIGHT", 0, -15 },
					children = {
						text = {
							type = "FontString",
							Anchor = { "RIGHT", "$parent", "LEFT", -15, 0 },
							FontObject = "GameFontNormalHuge",
						},
					},
					OnEnter = onenter,
					OnLeave = onleave,
					PostClick = postclick,
					OnDragStart = ondragstart,
					OnReceiveDrag = onreceivedrag,
					OnAttributeChanged = updatebuttons,
					vars = { t = "helpbutton", s = "heal" },
				},
				harm = {
					type = "CheckButton",
					uitemp = "SecureActionButtonTemplate, ActionButtonTemplate",
					Anchor = { "TOPRIGHT", "$parenthelp", "BOTTOMRIGHT", 0, -15 },
					children = {
						text = {
							type = "FontString",
							Anchor = { "RIGHT", "$parent", "LEFT", -15, 0 },
							FontObject = "GameFontNormalHuge",
						},
					},
					OnEnter = onenter,
					OnLeave = onleave,
					PostClick = postclick,
					OnDragStart = ondragstart,
					OnReceiveDrag = onreceivedrag,
					OnAttributeChanged = updatebuttons,
					vars = { t = "harmbutton", s = "nuke" },
				},
			},
			--OnKeyUp = updatebuttons,
			--OnKeyDown = onkeydown,
			Hide = true,
		},
		states = {
			type = "Frame",
			size = { 200, 100 },
			Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
			children = {
				state = {
					template = "nrf_editbox",
					size = { 80, 18 },
					children = {
						drop = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "State",
							OnClick = function() framedrop(states) end,
						},
					},
					OnTabPressed = function() Nurfed_MenuActionBarsstatesmap:SetFocus() end,
					OnEnterPressed = addstate,
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, -4 },
				},
				map = {
					template = "nrf_editbox",
					size = { 120, 18 },
					children = {
						add = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "State Value",
							OnClick = addstate,
						},
					},
					OnTabPressed = function() Nurfed_MenuActionBarsstatesstate:SetFocus() end,
					OnEnterPressed = addstate,
					Anchor = { "TOPLEFT", "$parentstate", "BOTTOMLEFT", 0, -5 },
				},
				scroll = {
					type = "ScrollFrame",
					size = { 170, 155 },
					Anchor = { "TOPLEFT", "$parentmap", "BOTTOMLEFT", 0, 0 },
					uitemp = "FauxScrollFrameTemplate",
					OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollActionBarsStates) end,
					OnShow = function() Nurfed_ScrollActionBarsStates() end,
				},
				["1"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parentscroll", "TOPLEFT", 0, -8 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["2"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["3"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["4"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent3", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["5"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent4", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["6"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent5", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["7"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent6", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["8"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent7", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["9"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent8", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
				["10"] = {
					template = "nrf_actionstates",
					Anchor = { "TOPLEFT", "$parent9", "BOTTOMLEFT", 0, 0 },
					OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
				},
			},
			Hide = true,
		},
	},
	OnLoad = function() Nurfed_GenerateMenu("ActionBars", "nrf_actionbars_row", 19) end,
	OnHide = function()
		Nurfed_MenuActionBarsbuttondefault:SetParent(Nurfed_MenuActionBarsbutton)
		Nurfed_MenuActionBarsbuttonhelp:SetParent(Nurfed_MenuActionBarsbutton)
		Nurfed_MenuActionBarsbuttonharm:SetParent(Nurfed_MenuActionBarsbutton)
	end,
	vars = { expand = {} },
}

Nurfed:createtemp("nrf_actionbars_row",  {
	type = "Button",
	size = { 150, 14 },
	children = {
		expand = {
			type = "Button",
			layer = "ARTWORK",
			size = { 14, 14 },
			Anchor = { "LEFT", "$parent", "LEFT", 5, 0 },
			NormalTexture = "Interface\\Buttons\\UI-PlusButton-Up",
			PushedTexture = "Interface\\Buttons\\UI-PlusButton-Down",
			HighlightTexture = "Interface\\Buttons\\UI-PlusButton-Hilight",
			OnClick = function() Nurfed_ExpandBar() end,
		},
		name = {
			type = "FontString",
			layer = "ARTWORK",
			size = { 105, 14 },
			Anchor = { "BOTTOMLEFT", "$parentexpand", "BOTTOMRIGHT", 5, 0 },
			FontObject = "GameFontNormal",
			JustifyH = "LEFT",
			TextColor = { 1, 1, 1 },
		},
		states = {
			template = "nrf_check",
			size = { 16, 16 },
			Anchor = { "LEFT", "$parentname", "RIGHT", 5, 0 },
			OnEnter = function()
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
				GameTooltip:AddLine("Show States", 1, 1, 0)
				GameTooltip:Show()
			end,
			OnLeave = function() GameTooltip:Hide() end,
			OnClick = function() Nurfed_ToggleStates() end,
		},
		delete = {
			type = "Button",
			layer = "ARTWORK",
			size = { 14, 14 },
			Anchor = { "LEFT", "$parentstates", "RIGHT", 5, 0 },
			NormalTexture = "Interface\\Buttons\\UI-GroupLoot-Pass-Up",
			PushedTexture = "Interface\\Buttons\\UI-GroupLoot-Pass-Down",
			HighlightTexture = "Interface\\Buttons\\UI-GroupLoot-Pass-Highlight",
			OnClick = function() Nurfed_DeleteBar() end,
			OnEnter = function()
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
				GameTooltip:AddLine(DELETE, 1, 0, 0)
				GameTooltip:Show()
			end,
			OnLeave = function() GameTooltip:Hide() end,
		},
		HighlightTexture = {
			type = "Texture",
			layer = "BACKGROUND",
			Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
			BlendMode = "ADD",
			Anchor = "all",
		},
	},
	OnClick = function() Nurfed_ActionBar_OnClick(arg1) end,
	Hide = true,
})


function Nurfed_ScrollActionBarsStates()
	local states = {}
	local bar = Nurfed_MenuActionBars.bar
	local tbl = NURFED_ACTIONBARS[bar].statemaps
	for k, v in pairs(tbl) do
		table.insert(states, { k, v })
	end

	local format_row = function(row, num)
		local state = states[num]
		local name = getglobal(row:GetName().."name")
		local value = getglobal(row:GetName().."value")
		name:SetText(state[1])
		value:SetText(state[2])
		row.state = state[1]
	end

	local frame = Nurfed_MenuActionBarsstatesscroll
	FauxScrollFrame_Update(frame, #states, 10, 14)
	for line = 1, 10 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("Nurfed_MenuActionBarsstates"..line)
		if offset <= #states then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_ScrollActionBars()
	local bars = {}
	for k in pairs(NURFED_ACTIONBARS) do
		table.insert(bars, k)
	end
	table.sort(bars, function(a, b) return a < b end)
	for k, v in ipairs(bars) do
		if Nurfed_MenuActionBars.expand[v] then
			local hdr = getglobal(v)
			local children = { hdr:GetChildren() }
			table.sort(children, function(a, b) return a:GetID() > b:GetID() end)
			for _, child in ipairs(children) do
				local name = child:GetName()
				if string.find(name, "^Nurfed_Button") then
					table.insert(bars, k + 1, name)
				end
			end
		end
	end

	local format_row = function(row, num)
		local bar = bars[num]
		local btn = getglobal(bar)
		local name = getglobal(row:GetName().."name")
		local expand = getglobal(row:GetName().."expand")
		local delete = getglobal(row:GetName().."delete")
		local states = getglobal(row:GetName().."states")
		row.bar = bar
		if Nurfed_MenuActionBars.bar == bar then
			row:LockHighlight()
		else
			row:UnlockHighlight()
		end
		if Nurfed_MenuActionBars.expand[bar] then
			expand:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
			expand:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
		else
			expand:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
			expand:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
		end
		if btn:GetID() > 0 then
			expand:Hide()
			delete:Hide()
			states:Hide()
			bar = "Button "..btn:GetID()
		else
			expand:Show()
			delete:Show()
			states:Show()
		end
		name:SetText(bar)
	end

	local frame = Nurfed_MenuActionBarsscroll
	FauxScrollFrame_Update(frame, #bars, 17, 14)
	for line = 1, 17 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("Nurfed_ActionBarsRow"..line)
		if offset <= #bars then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_ToggleStates()
	local bar = Nurfed_MenuActionBars.bar
	local pbar = this:GetParent().bar
	if bar and bar == pbar and getglobal(bar):GetID() == 0 then
		if this:GetChecked() then
			Nurfed_MenuActionBarsbar:Hide()
			Nurfed_MenuActionBarsstates:Show()
		else
			Nurfed_MenuActionBarsstates:Hide()
			Nurfed_MenuActionBarsbar:Show()
		end
	end
end

function Nurfed_ActionBar_OnClick(button)
	local barname = this.bar
	local state = getglobal(this:GetName().."states"):GetChecked()
	Nurfed_MenuActionBarsbar:Hide()
	Nurfed_MenuActionBarsstates:Hide()
	Nurfed_MenuActionBarsbutton:Hide()
	--Nurfed_MenuActionBarsbuttondefault:SetParent(Nurfed_MenuActionBarsbutton)
	--Nurfed_MenuActionBarsbuttonhelp:SetParent(Nurfed_MenuActionBarsbutton)
	--Nurfed_MenuActionBarsbuttonharm:SetParent(Nurfed_MenuActionBarsbutton)
	if Nurfed_MenuActionBars.bar == barname then
		Nurfed_MenuActionBars.bar = nil
	else
		Nurfed_MenuActionBars.bar = barname
		local bar = getglobal(barname)
		if bar:GetID() > 0 then
			--[[
			Nurfed_MenuActionBarsbutton:Show()
			local hdr = bar:GetParent()
			local children = { Nurfed_MenuActionBarsbutton:GetChildren() }
			for _, child in ipairs(children) do
				hdr:SetAttribute("addchild", child)
				child:SetAttribute("statebutton", bar:GetAttribute("statebutton"))
			end
			updatebuttons()
			]]
		else
			if state then
				Nurfed_MenuActionBarsstates:Show()
				Nurfed_ScrollActionBarsStates()
			else
				Nurfed_MenuActionBarsbar:Show()
				updateoptions()
			end
		end
	end
	Nurfed_ScrollActionBars()
end

function Nurfed_DeleteState()
	local state = this:GetParent().state
	local bar = Nurfed_MenuActionBars.bar
	local hdr = getglobal(bar)
	NURFED_ACTIONBARS[bar].statemaps[state] = nil
	hdr:SetAttribute("statemap-"..state, nil)
	Nurfed:updatebar(hdr)
	Nurfed_ScrollActionBarsStates()
end

function Nurfed_DeleteBar()
	local bar = this:GetParent().bar
	Nurfed:deletebar(bar)
	NURFED_ACTIONBARS[bar] = nil
	Nurfed_ScrollActionBars()
	nrf_mainmenu()
end

function Nurfed_ExpandBar()
	local bar = this:GetParent().bar
	if Nurfed_MenuActionBars.expand[bar] then
		Nurfed_MenuActionBars.expand[bar] = nil
	else
		Nurfed_MenuActionBars.expand[bar] = true
	end
	Nurfed_ScrollActionBars()
end