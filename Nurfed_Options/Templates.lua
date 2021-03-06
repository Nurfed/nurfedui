local saveopt, onshow
------------------------------------------
-- Option Menu Templates
-- Slider value text
local slidertext = function(self)
	local value = math.round(self:GetValue(), self.deci)
	_G[self:GetName().."value"]:SetText(value)
end

-- drop down menu
do	-- keep local dropmenu local...rofl?
	local dropmenu = CreateFrame("Frame")
	dropmenu.displayMode = "MENU"
	function Nurfed_DropMenu(tbl)
		local info = {}
		local btn = this
		local func
		if btn.alt then
			func = function() btn:SetText(this.value) btn.alt(btn) end
		elseif btn:GetParent():GetObjectType() == "EditBox" then
			func = function() btn:GetParent():SetText(this.value) end
		else
			func = function() btn:SetText(this.value) saveopt(btn) end
		end
		dropmenu.initialize = function()
			for _, v in ipairs(tbl) do
				info.text = v
				info.value = v
				info.func = func
				info.isTitle = nil
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info)
			end
		end
		ToggleDropDownMenu(1, nil, dropmenu, "cursor")
	end
	
	function Nurfed_GenerateMenu(menu, template, rows)
		local row, parent
		parent = _G["Nurfed"..menu.."Panel"]
		for i = 1, rows do
			row = Nurfed:create("Nurfed"..menu.."RowPanel"..i, template, parent)
			if row:GetObjectType() == "Button" then
				row:RegisterForClicks("AnyUp")
			end
			
			if i == 1 then
				row:SetPoint("TOPLEFT", "Nurfed"..menu.."Panelscroll", "TOPLEFT", 0, -3)
			else
				row:SetPoint("TOPLEFT", "Nurfed"..menu.."RowPanel"..(i - 1), "BOTTOMLEFT", 0, 0)
			end
		end
	end
end
-- Scroll menu
function Nurfed_Options_ScrollMenu()
	FauxScrollFrame_Update(this, this.pages, 1, 100)
	local page = FauxScrollFrame_GetOffset(this) + 1
	local children = { this:GetParent():GetChildren() }
	for _, child in ipairs(children) do
		if (not string.find(child:GetName(), "scroll", 1, true)) then
			if (child.page == page) then
				child:Show()
			else
				child:Hide()
			end
		end
	end
end
-- color swatches
function Nurfed_Options_swatchSetColor(frame)
	local option = frame.option
	local r, g, b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	local swatch = _G[frame:GetName().."bg"]
	swatch:SetVertexColor(r, g, b)
	frame.r = r
	frame.g = g
	frame.b = b
	NURFED_SAVED[frame.option] = { r, g, b, a }
	if frame.func then
		frame.func()
	end
end

function Nurfed_Options_swatchCancelColor(frame, prev)
	local option = frame.option
	local r = prev.r
	local g = prev.g
	local b = prev.b
	local a = prev.a
	local swatch = _G[frame:GetName().."bg"]
	swatch:SetVertexColor(r, g, b)
	frame.r = r
	frame.g = g
	frame.b = b
	NURFED_SAVED[frame.option] = { r, g, b, a }
	if frame.func then
		frame.func()
	end
end

function Nurfed_Options_swatchOpenColorPicker(self)
	CloseMenus()
	ColorPickerFrame.func = self.swatchFunc
	ColorPickerFrame.hasOpacity = self.hasOpacity
	ColorPickerFrame.opacityFunc = self.opacityFunc
	ColorPickerFrame.opacity = self.opacity
	ColorPickerFrame:SetColorRGB(self.r, self.g, self.b)
	ColorPickerFrame.previousValues = {r = self.r, g = self.g, b = self.b, a = self.opacity}
	ColorPickerFrame.cancelFunc = self.cancelFunc
	ColorPickerFrame:Show()
end

onshow = function(self)
	local text = _G[self:GetName().."Text"]
	local value = _G[self:GetName().."value"]
	local objtype = self:GetObjectType()
	if not text then
		text = _G[self:GetParent():GetName().."Text"]
		assert(text, "NO TEXT FRAME FOR:"..self:GetName())
	end
	text:SetText(self.text)
	if self.color then
		text:SetTextColor(unpack(self.color))
	end

	local point = select(3, self:GetPoint())
	if point and point:find("RIGHT") and objtype ~= "EditBox" then
		if value then
			value:ClearAllPoints()
			value:SetPoint("RIGHT", self, "LEFT", -3, 0)
		else
			if not self.textpoint then
				text:ClearAllPoints()
				text:SetPoint("RIGHT", self, "LEFT", -1, 1)
				if text:GetText() ~= "" then
					self:SetHitRectInsets(-text:GetWidth(), 0, 0, 0)
				end
			end
		end
	end
	--set the proper hitrec ffs.  dont use unneeded space kthx?
	if objtype == "CheckButton" and text and text ~= "" and point and not point:find("RIGHT") then
		self:SetHitRectInsets(0, -text:GetWidth(), 0, 0)
	end
	if self.textpoint then
		text:ClearAllPoints()
		local p1, p2, p3, p4, p5 = unpack(self.textpoint)
		p2 = p2 == "self" and self or p2 == "parent" and self:GetParent() or _G[p2]
		text:SetPoint(p1, p2, p3, p4, p5)
	end
	
	-- anchoring the value editbox of a slider in the template apparently does not
	-- move it...at all.  It is still getting anchored to the left/right
	-- even when the anchor to pos is not set to RIGHT at all
	-- look into further, until then hack it this way
	if value and value:GetObjectType() == "EditBox" and objtype == "Slider" then
		value:ClearAllPoints()
		value:SetPoint("TOP", self, "BOTTOM", 0, 0)
	end
	if self.fontobject then
		text:SetFontObject(self.fontobject)
	end

	local opt
	if self.option then
		if self.cltbl then
			opt = NURFED_COMBATLOG_SAVED[self.cltbl][self.option]
		else
			opt = Nurfed:getopt(self.option)
		end
	elseif self.default then
		opt = self.default
	end

	if objtype == "CheckButton" and opt then
		self:SetChecked(opt)
	elseif objtype == "Slider" then
		local low = _G[self:GetName().."Low"]
		local high = _G[self:GetName().."High"]
		self:SetMinMaxValues(self.min, self.max)
		self:SetValueStep(self.step)
		if opt then
			self:SetValue(opt)
		end

		value.option = self.option
		value.cltbl = self.cltbl
		value.val = self.val
		value.func = self.func
		value.event = self.event
	elseif objtype == "EditBox" then
		if type(opt) == "table" then
			local text = ""
			for name in pairs(opt) do
				text = text..name.."\r"
			end
			self:SetText(text)
		else		
			self:SetText(opt or "")
		end
		
	elseif objtype == "Button" then
		local swatch = _G[self:GetName().."bg"]
		if swatch then
			local frame = self
			swatch:SetVertexColor(opt[1], opt[2], opt[3])
			self.r = opt[1]
			self.g = opt[2]
			self.b = opt[3]
			self.swatchFunc = function() Nurfed_Options_swatchSetColor(frame) end
			self.cancelFunc = function(x) Nurfed_Options_swatchCancelColor(frame, x) end
			if self.opacity then
				self.hasOpacity = frame.opacity
				self.opacityFunc = function() Nurfed_Options_swatchSetColor(frame) end
				self.opacity = opt[4]
			end
		else
			self:SetText(opt or "")
		end
	end
	self:SetScript("OnShow", nil)
end

saveopt = function(self)
	local value, objtype
	objtype = self:GetObjectType()

	if objtype == "CheckButton" then
		value = self:GetChecked() or false
		if value then
			PlaySound("igMainMenuOptionCheckBoxOn")
		else
			PlaySound("igMainMenuOptionCheckBoxOff")
		end
	elseif objtype == "Slider" then
		value = self:GetValue()
	elseif objtype == "EditBox" then
		if not self.focus then return end
		value = self:GetText()
	elseif objtype == "Button" then
		value = self:GetText()
	end

	if self.option and not self.cltbl then
		local opt = self.option
		if value == NURFED_DEFAULT[opt] then
			NURFED_SAVED[opt] = nil
		else
			NURFED_SAVED[opt] = value
		end
	end
	if self.cltbl then
		NURFED_COMBATLOG_SAVED[self.cltbl][self.option] = value or false
	end

	if self.func then
		self.func(value)
	end
	if self.event then
		Nurfed:sendevent(self.event)
	end
end

local templates = {
	nrf_check = {
		type = "CheckButton",
		uitemp = "InterfaceOptionsCheckButtonTemplate",
		OnShow = onshow,
		OnClick = saveopt,
	},
	nrf_button = {
		type = "Button",
		size = { 60, 18 },
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 10,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		},
		BackdropColor = { 0, 0, 0, 0.75 },
		Font = { "Fonts\\ARIALN.TTF", 12, "OUTLINE" },
		TextColor = { 1, 1, 1 },
		HighlightTextColor = { 0, 0.75, 1 },
		DisabledTextColor = { 1, 0, 0 },
		PushedTextOffset = { 1, -1 },
		OnShow = function(self) self:SetWidth(self:GetTextWidth() + 12) self:SetScript("OnShow", nil) end,
	},
	nrf_slider = {
		type = "Slider",
		uitemp = "InterfaceOptionsSliderTemplate",
		children = {
			value = {
				template = "nrf_editbox",
				FontObject = "GameFontNormalSmall",
				JustifyH = "CENTER",
				size = { 35, 18 },
				Anchor = { "TOP", "$parent", "BOTTOM", 0, 0 },
				Backdrop = {
					bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
					tile = true,
					tileSize = 16,
					insets = { left = 3, right = 3, top = 3, bottom = 3 },
				},
				BackdropColor = { 0, 0, 0.2, 0.75 },
				OnTextChanged = function(self)
					if self.focus then
						local parent = self:GetParent()
						local value = tonumber(self:GetText())
						local min, max = parent:GetMinMaxValues()
						if not value or value < min then return end
						if value > max then value = max end
						parent:SetValue(value)
						saveopt(parent)
					end
				end,
				OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
				OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
			},
		},
		OnShow = function(self) 
			self:SetFrameLevel(30)
			self:EnableMouseWheel(true)
			onshow(self)
			local min,max = self:GetMinMaxValues();
			if max >= 1000 or self.deci then 
				_G[self:GetName().."value"]:SetWidth(42)
			end
		end,
		OnMouseUp = function(self) 
			local editbox = _G[self:GetName().."value"]
			editbox:SetCursorPosition(0)
			editbox:ClearFocus()
			saveopt(self) 
		end,
		OnValueChanged = function(self)
			local value = math.round(self:GetValue(), self.deci)
			_G[self:GetName().."value"]:SetText(value) 
		end,
		OnMouseWheel = function(self, change)
			local value = self:GetValue()
			if change > 0  then
				value = value + (self.bigStep or self.step)
			else
				value = value - (self.bigStep or self.step)
			end
			self:SetValue(value)
			saveopt(self)
		end,
	},
	nrf_editbox = {
		type = "EditBox",
		AutoFocus = false,
		size = { 155, 20 },
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 10,
			insets = { left = 3, right = 3, top = 3, bottom = 3 },
		},
		BackdropColor = { 0, 0, 0.2, 0.75 },
		FontObject = "GameFontNormal",
		TextInsets = { 3, 3, 3, 3 },
		children = {
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 3, 0 },
				FontObject = "GameFontHighlight",
				JustifyH = "LEFT",
			},
		},
		OnShow = function(self) onshow(self) end,
		OnEscapePressed = function(self) self:ClearFocus() end,
		OnEnterPressed = function(self) self:ClearFocus() end,
		OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
		OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
		OnTextChanged = function(self) end,
	},
	nrf_options = {
		type = "Frame",
		size = { 411, 271 },
		Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 1, 0 },
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 8,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		},
		BackdropColor = { 0, 0, 0, 0.95 },
		Alpha = 0,
		--Hide = true,
		children = {},
	},
	nrf_actionstates = {
		type = "Button",
		size = { 175, 14 },
		children = {
			delete = {
				type = "Button",
				layer = "ARTWORK",
				size = { 14, 14 },
				Anchor = { "LEFT", "$parent", "LEFT", 0, 0 },
				NormalTexture = "Interface\\Buttons\\UI-GroupLoot-Pass-Up",
				PushedTexture = "Interface\\Buttons\\UI-GroupLoot-Pass-Down",
				HighlightTexture = "Interface\\Buttons\\UI-GroupLoot-Pass-Highlight",
				OnClick = function() Nurfed_DeleteState() end,
				OnEnter = function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:AddLine(DELETE, 1, 0, 0)
					GameTooltip:Show()
				end,
				OnLeave = function() GameTooltip:Hide() end,
			},
			name = {
				type = "FontString",
				layer = "ARTWORK",
				size = { 102, 14 },
				Anchor = { "LEFT", "$parentdelete", "RIGHT", 5, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
				TextColor = { 1, 1, 1 },
			},
			value = {
				type = "FontString",
				layer = "ARTWORK",
				size = { 50, 14 },
				Anchor = { "LEFT", "$parentname", "RIGHT", 5, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "RIGHT",
				TextColor = { 1, 1, 1 },
			},
			HighlightTexture = {
				type = "Texture",
				layer = "BACKGROUND",
				Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
				BlendMode = "ADD",
				Anchor = "all",
			},
		},
	},
	nrf_actionbars_row = {
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
				OnEnter = function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
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
				OnEnter = function(self)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
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
	},
	nrf_color = {
		type = "Button",
		size = { 18, 18 },
		children = {
			bg = {
				type = "Texture",
				Texture = "Interface\\ChatFrame\\ChatFrameColorSwatch",
				layer = "BACKGROUND",
				Anchor = "all",
				VertexColor = { 1, 1, 1 },
			},
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "LEFT", "$parent", "RIGHT", 1, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
		},
		OnShow = function(self) onshow(self) end,
		OnClick = function(self) Nurfed_Options_swatchOpenColorPicker(self) end,
	},
	nrf_scroll = {
		type = "ScrollFrame",
		Anchor = { "LEFT", 0, 0 },
		size = { 385, 271 },
		uitemp = "FauxScrollFrameTemplate",
		OnVerticalScroll = function(self) FauxScrollFrame_OnVerticalScroll(100, Nurfed_Options_ScrollMenu) end,
		OnShow = function(self) Nurfed_Options_ScrollMenu(self) end,
	},
	nrf_multieditinworking = {
		type = "Frame",
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 8,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		},
		BackdropColor = { 0, 0, 0, 0.95 },
		children = {
			scroll = {
				template = "nrf_scroll",
				vars = { pages = 2 },
				size = { 10, 20 },
				Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", 0, 0 },
			},
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 3, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
			edit = {
				type = "EditBox",
				AutoFocus = false,
				MultiLine = true,
				FontObject = "GameFontNormalSmall",
				TextColor = { 1, 1, 1 },
				TextInsets = { 3, 3, 3, 3 },
				OnShow = function(self)
					local parent = self:GetParent()
					self.option = parent.option
					self.func = parent.func
					if parent.ltrs then
						self:SetMaxLetters(parent.ltrs)
					end
					self:ClearAllPoints();
					self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 4)
					self:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -4)
					onshow(self)
					parent:GetScript("OnLoad")(parent)
				end,
				OnEscapePressed = function(self) self:ClearFocus() end,
				OnEditFocusGained = function(self) self.focus = true end,
				OnEditFocusLost = function(self) saveopt(self) self.focus = nil end,
				OnTabPressed = function(self) self:Insert("   ") end,
				OnTextChanged = function(self)
					local scrollBar = _G[self:GetParent():GetName().."ScrollBar"]
					self:GetParent():UpdateScrollChildRect()
					local min, max = scrollBar:GetMinMaxValues()
					if max > 0 and (self.max ~= max) then
						self.max = max
						scrollBar:SetValue(max)
					else
						self:SetPoint("BOTTOM")
					end
				end,
			},
		},
		OnLoad = function(self)
			local child = _G[self:GetName().."edit"]
			local text = _G[self:GetName().."Text"]
			local scroll = _G[self:GetName().."scroll"]
			child:SetWidth(self:GetWidth())
			text:SetText(self.text or "")
			scroll:SetScrollChild(child)
		end,
	},
	nrf_multiedittest2 = {
		type = "Frame",
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 8,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		},
		BackdropColor = { 0, 0, 0, 0.95 },
		children = {
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 3, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
			edit = {
				type = "EditBox",
				AutoFocus = false,
				MultiLine = true,
				FontObject = "GameFontNormalSmall",
				TextColor = { 1, 1, 1 },
				TextInsets = { 3, 3, 3, 3 },
				Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
				OnShow = function(self)
					local parent = self:GetParent()
					self.option = parent.option
					self.func = parent.func
					if parent.ltrs then
						self:SetMaxLetters(parent.ltrs)
					end
					self:ClearAllPoints();
					self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 4)
					self:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -4)
					onshow(self)
					parent:GetScript("OnLoad")(parent)
				end,
				OnEscapePressed = function(self) self:ClearFocus() end,
				OnEditFocusGained = function(self) self.focus = true end,
				OnEditFocusLost = function(self) saveopt(self) self.focus = nil end,
				OnTabPressed = function(self) self:Insert("   ") end,
				OnTextChanged = function(self)
					local scrollBar = _G[self:GetParent():GetName().."ScrollBar"]
					_G[self:GetParent():GetName().."ScrollBar"]:UpdateScrollChildRect()
					local min, max = scrollBar:GetMinMaxValues()
					if max > 0 and (self.max ~= max) then
						self.max = max
						scrollBar:SetValue(max)
					else
						self:SetPoint("BOTTOM")
					end
				end,
			},
			ScrollBar = {
				type = "ScrollFrame",
				uitemp = "UIPanelScrollFrameTemplate",
				OnShow = function(self)
					local parent = self:GetParent():GetName()
					local child = _G[parent.."edit"]
					local text = _G[parent.."Text"]
					text:SetText(self:GetParent().text or "")
					self:SetScrollChild(child)
				end,
			},

		},
	},
	nrf_multiedit = {
		type = "ScrollFrame",
		uitemp = "UIPanelScrollFrameTemplate",
		children = {
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 3, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
			edit = {
				type = "EditBox",
				AutoFocus = false,
				MultiLine = true,
				FontObject = "GameFontNormalSmall",
				TextColor = { 1, 1, 1 },
				TextInsets = { 3, 3, 3, 3 },
				Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
				OnShow = function(self)
					local parent = self:GetParent()
					self.option = parent.option
					self.func = parent.func
					if parent.ltrs then
						self:SetMaxLetters(parent.ltrs)
					end
					self:ClearAllPoints();
					self:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 4)
					self:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -4)
					onshow(self)
					parent:GetScript("OnLoad")(parent)
				end,
				OnEscapePressed = function(self) self:ClearFocus() end,
				OnEditFocusGained = function(self) self.focus = true end,
				OnEditFocusLost = function(self) saveopt(self) self.focus = nil end,
				OnTabPressed = function(self) self:Insert("   ") end,
				OnEnterPressed = function(self) self:GetScript("OnTextChanged")() end,
				OnTextChanged = function(self)
					local scrollBar = _G[self:GetParent():GetName().."ScrollBar"]
					self:GetParent():UpdateScrollChildRect()
					local min, max = scrollBar:GetMinMaxValues()
					if max > 0 then
						if self.max ~= max then
							self.max = max
							scrollBar:SetValue(max)
						end
					else
						scrollBar:SetValue(min)
						self:SetPoint("BOTTOM")
					end
				end,
			},
			bg = {
				type = "Frame",
				Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
				Backdrop = {
					bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
					tile = true,
					tileSize = 16,
					edgeSize = 8,
					insets = { left = 2, right = 2, top = 2, bottom = 2 },
				},
				BackdropColor = { 0, 0, 0, 0.95 },
				OnShow = function(self)
					local parent = self:GetParent()
					self:SetWidth(parent:GetWidth()+5)
					self:SetHeight(parent:GetHeight())
					self:SetFrameLevel(1)
				end,
			},	
		},
		OnLoad = function(self)
			local child = _G[self:GetName().."edit"]
			local text = _G[self:GetName().."Text"]
			child:SetWidth(self:GetWidth())
			text:SetText(self.text or "")
			self:SetScrollChild(child)
		end,
	},
	nrf_optbutton = {
		template = "nrf_button",
		children = {
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "RIGHT", "$parent", "LEFT", -3, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
		},
		OnShow = function(self) onshow(self) end,
	},
}

for k, v in pairs(templates) do
  Nurfed:createtemp(k, v)
end
NurfedTemplatesOnShow = onshow
Nurfed:setver("$Date$", 1)
Nurfed:setrev("$Rev$", 1)