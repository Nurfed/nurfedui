------------------------------------------
--		Nurfed Options
------------------------------------------

-- Reload UI Popup
StaticPopupDialogs["NRF_RELOADUI"] = {
	text = "Reload User Interface?",
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function()
		ReloadUI()
	end,
	timeout = 10,
	whileDead = 1,
	hideOnEscape = 1,
}

-- Locals
local _G = getfenv(0)
local menus = {}
local activemenu, addon

-- Save Option
local saveopt = function()
	local value, objtype, func, opt, sound, tbl
	objtype = this:GetObjectType()
	func = this.func
	opt = this.option
	
	if objtype == "CheckButton" then
		value = this:GetChecked() or false
		if value then
			sound = "igMainMenuOptionCheckBoxOn"
		else
			sound = "igMainMenuOptionCheckBoxOff"
		end
		PlaySound(sound)
	elseif objtype == "Slider" then
		value = this:GetValue()
	elseif objtype == "EditBox" then
		if not this.focus then return end
		value = this:GetText()
	end

	if addon then
		addon = "_"..string.upper(addon)
	end
	tbl = _G["NURFED"..(addon or "").."_SAVED"]
	
	if opt then
		if value == NURFED_DEFAULT[opt] then
			tbl[opt] = nil
		else
			tbl[opt] = value
		end
	end
	
	if func then
		func()
	end
end

-- Init option display
local onshow = function()
	local text, value, objtype, opt, right
	text = _G[this:GetName().."Text"]
	value = _G[this:GetName().."value"]
	objtype = this:GetObjectType()
	if this:GetParent():GetRight() and this:GetRight() then
		right = this:GetParent():GetRight() - this:GetRight()
		if right < 50 and objtype ~= "EditBox" then
			if value then
				value:ClearAllPoints()
				value:SetPoint("RIGHT", this, "LEFT", -3, 0)
			else
				text:ClearAllPoints()
				text:SetPoint("RIGHT", this:GetName(), "LEFT", -1, 1)
			end
		end
	end

	text:SetText(this.text)

	if this.color then
		text:SetTextColor(unpack(this.color))
	end
	
	if this.option then
		opt = Nurfed:getopt(this.option, addon)
	elseif this.default then
		opt = this.default
	end

	if objtype == "CheckButton" and opt then
		this:SetChecked(opt)
	elseif objtype == "Slider" then
		local low = _G[this:GetName().."Low"]
		local high = _G[this:GetName().."High"]
		this:SetMinMaxValues(this.min, this.max)
		this:SetValueStep(this.step)
		if opt then
			this:SetValue(opt)
		end

		value.option = this.option
		value.val = this.val
		value.func = this.func
	elseif objtype == "EditBox" then
		this:SetText(opt or "")
	end
	this:SetScript("OnShow", nil)
end

-- Select options menu
local showmenu = function(menu)
	if IsAddOnLoaded("Nurfed_"..menu) then
		addon = menu
	end

	local frame = _G["Nurfed_Menu"..menu]
	if not frame then
		frame = Nurfed:create("Nurfed_Menu"..menu, NURFED_MENUS[menu], Nurfed_Menu)
	end
	frame:Show()
	UIFrameFadeIn(frame, 0.25)
	PlaySound("igAbiliityPageTurn")
end

local menuclick = function()
	local num, button, menu
	addon = nil
	num = 1
	button = _G["Nurfed_MenuButton"..num]
	while button do
		menu = button:GetText()
		if this ~= button then
			button:Enable()
			menu = _G["Nurfed_Menu"..menu]
			if menu and menu:IsShown() then
				menu:Hide()
				menu:SetAlpha(0)
			end
		else
			button:Disable()
			showmenu(menu)
		end
		num = num + 1
		button = _G["Nurfed_MenuButton"..num]
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

-- Slider value text
local slidertext = function()
	local value = math.round(this:GetValue(), this.deci)
	_G[this:GetName().."value"]:SetText(value)
end

function Nurfed_GenerateMenu(menu, template, rows)
	local row, parent
	parent = _G["Nurfed_Menu"..menu]
	for i = 1, rows do
		row = Nurfed:create("Nurfed_"..menu.."Row"..i, template, parent)
		if row:GetObjectType() == "Button" then
			row:RegisterForClicks("AnyUp")
		end
		
		if i == 1 then
			row:SetPoint("TOPLEFT", "Nurfed_Menu"..menu.."scroll", "TOPLEFT", 0, -3)
		else
			row:SetPoint("TOPLEFT", "Nurfed_"..menu.."Row"..(i - 1), "BOTTOMLEFT", 0, 0)
		end
	end
end

-- Menu templates
local templates = {
	nrf_menu_button = {
		type = "Button",
		size = { 80, 14 },
		TextFontObject = "GameFontNormalSmall",
		TextColor = { 0.5, 0.5, 0.5 },
		HighlightTextColor = { 1, 1, 1 },
		DisabledTextColor = { 1, 1, 1 },
		PushedTextOffset = { 1, -1 },
		children = {
			NormalTexture = {
				type = "Texture",
				layer = "BACKGROUND",
				Anchor = "all",
				Texture = NRF_IMG.."statusbar8",
				Gradient = { "VERTICAL", 1, 0.5, 0, 0.2, 0, 0 },
			},
			DisabledTexture = {
				type = "Texture",
				layer = "BACKGROUND",
				Anchor = "all",
				Texture = NRF_IMG.."statusbar8",
				Gradient = { "VERTICAL", 0, 0.75, 1, 0, 0, 0.2 },
			},
		},
	},
	nrf_options = {
		type = "Frame",
		size = { 411, 271 },
		Anchor = { "TOPRIGHT", "$parentHeader", "BOTTOMRIGHT", 1, 0 },
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
		Hide = true,
	},
	nrf_actionstates = {
		type = "Button",
		size = { 160, 14 },
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
				OnEnter = function()
					GameTooltip:SetOwner(this, "ANCHOR_RIGHT")
					GameTooltip:AddLine(DELETE, 1, 0, 0)
					GameTooltip:Show()
				end,
				OnLeave = function() GameTooltip:Hide() end,
			},
			name = {
				type = "FontString",
				layer = "ARTWORK",
				size = { 70, 14 },
				Anchor = { "BOTTOMLEFT", "$parentdelete", "BOTTOMRIGHT", 5, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
				TextColor = { 1, 1, 1 },
			},
			value = {
				type = "FontString",
				layer = "ARTWORK",
				size = { 70, 14 },
				Anchor = { "BOTTOMLEFT", "$parentname", "BOTTOMRIGHT", 5, 0 },
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
	nrf_button = {
		type = "Button",
		size = { 30, 18 },
		Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
		BackdropColor = { 0, 0, 0, 0.75 },
		Font = { "Fonts\\ARIALN.TTF", 10, "OUTLINE" },
		TextColor = { 0.65, 0.65, 0.65 },
		HighlightTextColor = { 1, 1, 1 },
		PushedTextOffset = { 1, -1 },
		OnShow = function() this:SetWidth(this:GetTextWidth() + 10) this:SetScript("OnShow", nil) end,
	},
	nrf_check = {
		type = "CheckButton",
		size = { 20, 20 },
		uitemp = "UICheckButtonTemplate",
		OnShow = function() onshow() end,
		OnClick = function() saveopt() end,
	},
	nrf_radio = {
		type = "CheckButton",
		size = { 14, 14 },
		uitemp = "UIRadioButtonTemplate",
		OnShow = function() onshow() end,
		OnClick = function() Nurfed_Options_radioOnClick() end,
	},
	nrf_slider = {
		type = "Slider",
		uitemp = "OptionsSliderTemplate",
		children = {
			value = {
				template = "nrf_editbox",
				size = { 35, 18 },
				Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
				OnTextChanged = function()
					if this.focus then
						local value = tonumber(this:GetText())
						local min, max = this:GetParent():GetMinMaxValues()
						if not value or value < min then return end
						if value > max then value = max end
						this:GetParent():SetValue(value)
						local func = this:GetParent():GetScript("OnMouseUp")
						func()
					end
				end,
				OnEditFocusGained = function() this:HighlightText() this.focus = true end,
				OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			},
		},
		OnShow = function() onshow() end,
		OnMouseUp = function() saveopt() end,
		OnValueChanged = function() slidertext() end,
	},
	nrf_editbox = {
		type = "EditBox",
		AutoFocus = false,
		size = { 135, 18 },
		Backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 10,
			insets = { left = 2, right = 2, top = 2, bottom = 2 },
		},
		BackdropColor = { 0, 0, 0.2, 0.75 },
		FontObject = "GameFontNormalSmall",
		TextColor = { 1, 1, 1 },
		TextInsets = { 3, 3, 3, 3 },
		children = {
			Text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 3, 0 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
		},
		OnShow = function() onshow() end,
		OnEscapePressed = function() this:ClearFocus() end,
		OnEditFocusGained = function() this:HighlightText() this.focus = true end,
		OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
		OnTextChanged = function() saveopt() end,
	},
	nrf_dropdown = {
		type = "Frame",
		uitemp = "UIDropDownMenuTemplate",
		OnShow = function() Nurfed_Options_dropdownOnShow() end,
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
		OnShow = function() Nurfed_Options_swatchOnShow() end,
		OnClick = function() Nurfed_Options_swatchOpenColorPicker() end,
	},
	nrf_scroll = {
		type = "ScrollFrame",
		Anchor = { "LEFT", 0, 0 },
		size = { 385, 271 },
		uitemp = "FauxScrollFrameTemplate",
		OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(100, Nurfed_Options_ScrollMenu) end,
		OnShow = function() Nurfed_Options_ScrollMenu() end,
	},
	nrf_optionpane = {
		type = "Frame",
		Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
		BackdropColor = { 0, 0, 0, 0.5 },
		BackdropBorderColor = { 0.75, 0.75, 0.75, 1 },
		children = {
			title = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 10, -2 },
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
			},
		},
		OnShow = function() Nurfed_Options_paneOnShow() end,
	},
	nrf_paneeditbox = {
		type = "EditBox",
		AutoFocus = false,
		Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = nil, tile = true, tileSize = 16, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
		BackdropColor = { 0.5, 0.5, 0.5, 0.85 },
		FontObject = "GameFontNormalSmall",
		TextColor = { 1, 1, 0 },
		TextInsets = { 3, 3, 3, 3 },
		OnEscapePressed = function() this:ClearFocus() end,
		OnEditFocusLost = function() this:HighlightText(0, 0) end,
		OnEditFocusGained = function() this:HighlightText() end,
		OnEnterPressed = function() Nurfed_Options_paneAddOption() end,
	},
	nrf_panescroll = {
		type = "ScrollFrame",
		Anchor = "all",
		uitemp = "FauxScrollFrameTemplate",
		Scale = 0.75,
		OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(13, Nurfed_Options_ScrollPane) end,
		OnShow = function() Nurfed_Options_ScrollPane() end,
	},
	nrf_pane_row = {
		type = "Button",
		children = {
			text = {
				type = "FontString",
				layer = "ARTWORK",
				Anchor = "all",
				FontObject = "GameFontNormalSmall",
				JustifyH = "LEFT",
				TextColor = { 0, 1, 1 },
			},
			HighlightTexture = {
				type = "Texture",
				layer = "BACKGROUND",
				Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
				BlendMode = "ADD",
				Anchor = "all",
			},
		},
		OnClick = function() Nurfed_Options_PaneSelect() end,
	},
}

-- Menu layout
local layout = {
	type = "Frame",
	size = { 500, 300 },
	FrameStrata = "LOW",
	Toplevel = true,
	Movable = true,
	Mouse = true,
	ClampedToScreen = true,
	Anchor = { "CENTER", nil, "CENTER", 0, 0 },
	Backdrop = {
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 16,
		edgeSize = 16,
		insets = { left = 5, right = 4, top = 5, bottom = 4 },
	},
	BackdropColor = { 0, 0, 0, 0.25 },
	children = {
		Header = {
			type = "Frame",
			size = { 490, 20 },
			Anchor = { "TOP", "$parent", "TOP", 0, -5 },
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Anchor = "all",
					Texture = NRF_IMG.."statusbar8",
					Gradient = { "HORIZONTAL", 0, 0.75, 1, 0, 0, 0.2 },
				},
				Title = {
					type = "FontString",
					Anchor = "all",
					Font = { "Fonts\\FRIZQT__.TTF", 13, "OUTLINE" },
					JustifyH = "LEFT",
					TextColor = { 1, 1, 1 },
				},
				Version = {
					type = "FontString",
					Anchor = "all",
					Font = { "Fonts\\MORPHEUS.ttf", 13, "NONE" },
					JustifyH = "RIGHT",
					TextColor = { 1, 1, 1 },
				},
				border = {
					type = "Texture",
					size = { 490, 3 },
					layer = "OVERLAY",
					Anchor = { "TOP", "$parent", "BOTTOM", 0, 1 },
					Texture = "Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar",
					TexCoord = { 0.2, 1, 0, 0.25 },
				},
			},
		},
		menubg = {
			type = "Frame",
			FrameStrata = "BACKGROUND",
			size = { 85, 278 },
			Anchor = { "TOPLEFT", "$parentHeader", "BOTTOMLEFT", -3, 5 },
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 8,
				insets = { left = 3, right = 2, top = 3, bottom = 2 },
			},
			BackdropColor = { 0, 0, 0, 0.95 },
		},
		ReloadUI = {
			template = "nrf_menu_button",
			OnClick = function() StaticPopup_Show("NRF_RELOADUI") end,
			Text = "Reload UI",
		},
		Close = {
			template = "nrf_menu_button",
			Anchor = { "TOPLEFT", "$parentReloadUI", "BOTTOMLEFT", 0, -1 },
			OnClick = function() HideUIPanel(this:GetParent()) end,
			Text = CLOSE,
		},
	},
	OnDragStart = function() this:StartMoving() end,
	OnDragStop = function() this:StopMovingOrSizing() end,
	Hide = true,
}

-- Create menu frame
for k, v in pairs(templates) do
	Nurfed:createtemp(k, v)
end
local frame = Nurfed:create("Nurfed_Menu", layout)
frame:RegisterForDrag("LeftButton")
Nurfed_MenuHeaderTitle:SetText("Nurfed Options Menu")
Nurfed_MenuHeaderVersion:SetText(GetAddOnMetadata("Nurfed_Options", "Version"))
table.insert(UISpecialFrames, "Nurfed_Menu")

-- Add menu buttons
local tmp = {}
for k in pairs(NURFED_MENUS) do
    tmp[#tmp + 1] = k
end
table.sort(tmp, function(a, b) return a < b end)
for k, v in ipairs(tmp) do
    local button = Nurfed:create("Nurfed_MenuButton"..k, "nrf_menu_button", Nurfed_Menu)
	button:SetScript("OnClick", menuclick)
	button:SetText(v)
	if k == 1 then
		button:SetPoint("TOPLEFT", Nurfed_MenuHeader, "BOTTOMLEFT", 0, 0)
	else
		button:SetPoint("TOPLEFT", _G["Nurfed_MenuButton"..(k - 1)], "BOTTOMLEFT", 0, -1)
	end
end

Nurfed_MenuReloadUI:SetPoint("TOPLEFT", _G["Nurfed_MenuButton"..#tmp], "BOTTOMLEFT", 0, -1)

-- Clear all temp tables
tmp = nil
layout = nil
templates = nil
















--[[
-----------------------------------------------------------------------------------------
--			Nurfed Options Functions
-----------------------------------------------------------------------------------------

-- color swatches
function Nurfed_Options_swatchSetColor(frame)
	local option = frame.option
	local r,g,b = ColorPickerFrame:GetColorRGB()
	local a = OpacitySliderFrame:GetValue()
	local swatch = getglobal(frame:GetName().."bg")
	swatch:SetVertexColor(r, g, b)
	frame.r = r
	frame.g = g
	frame.b = b
	NURFED_SAVED[frame.option] = { r, g, b, a }
	--Nurfed:SetOption(activemenu, frame.option, { r, g, b, a })
	if (frame.func) then
		frame.func()
	end
end

function Nurfed_Options_swatchCancelColor(frame, prev)
	local option = frame.option
	local r = prev.r
	local g = prev.g
	local b = prev.b
	local a = prev.a
	local swatch = getglobal(frame:GetName().."bg")
	swatch:SetVertexColor(r, g, b)
	frame.r = r
	frame.g = g
	frame.b = b
	NURFED_SAVED[frame.option] = { r, g, b, a }
	--Nurfed:SetOption(activemenu, frame.option, { r, g, b, a })
	if (frame.func) then
		frame.func()
	end
end

function Nurfed_Options_swatchOnShow()
	if (this:IsShown()) then
		local option = optionInit()
		if (not option) then
			return
		end
		local frame = this
		local swatch = getglobal(this:GetName().."bg")
		swatch:SetVertexColor(option[1], option[2], option[3])

		this.r = option[1]
		this.g = option[2]
		this.b = option[3]
		this.swatchFunc = function() Nurfed_Options_swatchSetColor(frame) end
		this.cancelFunc = function(x) Nurfed_Options_swatchCancelColor(frame, x) end
		if (frame.opacity) then
			this.hasOpacity = frame.opacity
			this.opacityFunc = function() Nurfed_Options_swatchSetColor(frame) end
			this.opacity = option[4]
		end
	end
end

function Nurfed_Options_swatchOpenColorPicker()
	CloseMenus()
	ColorPickerFrame.func = this.swatchFunc
	ColorPickerFrame.hasOpacity = this.hasOpacity
	ColorPickerFrame.opacityFunc = this.opacityFunc
	ColorPickerFrame.opacity = this.opacity
	ColorPickerFrame:SetColorRGB(this.r, this.g, this.b)
	ColorPickerFrame.previousValues = {r = this.r, g = this.g, b = this.b, a = this.opacity}
	ColorPickerFrame.cancelFunc = this.cancelFunc
	ColorPickerFrame:Show()
end

-- radios
function Nurfed_Options_radioOnClick(frame, index, noupdate)
	if (not index) then
		index = this.index
	end
	if (not frame) then
		frame = this:GetParent()
	end
	local children = { frame:GetChildren() }
	for _, child in ipairs(children) do
		if (child.index == index) then
			child:SetChecked(1)
		else
			child:SetChecked(nil)
		end
	end
	PlaySound("igMainMenuOptionCheckBoxOn")

	if (not frame:GetParent().selected or noupdate) then
		return
	end
	Nurfed:SetOption(activemenu, frame.option, index, frame.id, frame:GetParent().selected)
	local func = frame:GetParent().func
	if (func) then
		func()
	end
end

function Nurfed_Options_radioGetSelected(frame)
	if (not frame) then
		frame = this:GetParent()
	end
	local children = { frame:GetChildren() }
	for _, child in ipairs(children) do
		if (child:GetChecked()) then
			return child.index
		end
	end
end

-- panes
function Nurfed_Options_paneOnShow()
	local title = getglobal(this:GetName().."title")
	if (this.text) then
		title:SetText(this.text)
	end
	local scroll = getglobal(this:GetName().."scrollScrollBar")
	if (scroll) then
		scroll:SetPoint("RIGHT", scroll:GetParent():GetName(), "RIGHT", -26, 0)
	end
	local children = { this:GetChildren() }
	for _, child in ipairs(children) do
		local objtype = child:GetObjectType()
		if (objtype == "CheckButton") then
			child:SetChecked(child.default)
		elseif (objtype == "Slider") then
			local low = getglobal(child:GetName().."Low")
			local high = getglobal(child:GetName().."High")
			low:SetText(child.low)
			high:SetText(child.high)
			child:SetMinMaxValues(child.min, child.max)
			child:SetValueStep(child.step)
			child:SetValue(child.default)
		elseif (objtype == "Frame" and child.isradio) then
			Nurfed_Options_radioOnClick(child, child.default, true)
		end
		child.option = this.option
	end
	this:SetScript("OnShow", nil)
end

function Nurfed_Options_paneUpdateOptions(frame)
	local option = Nurfed:getopt(activemenu, frame.option)
	local selected = option[frame.selected]
	local children = { frame:GetChildren() }
	for _, child in ipairs(children) do
		local objtype = child:GetObjectType()
		if (objtype == "CheckButton") then
			child:SetChecked(selected[child.id])
		elseif (objtype == "Slider") then
			child:SetValue(selected[child.id])
		elseif (objtype == "Frame" and child.isradio) then
			Nurfed_Options_radioOnClick(child, selected[child.id], true)
		end
	end
end

function Nurfed_Options_panegetopts()
	local tbl = {}
	local children = { this:GetParent():GetChildren() }
	for _, child in ipairs(children) do
		if (child.id) then
			local objtype = child:GetObjectType()
			if (objtype == "Slider") then
				tbl[child.id] = child:GetValue()
			elseif (objtype == "CheckButton") then
				if (child:GetChecked()) then
					tbl[child.id] = 1
				else
					tbl[child.id] = 0
				end
			elseif (objtype == "Frame" and child.isradio) then
				tbl[child.id] = Nurfed_Options_radioGetSelected(child)
			end
		end
	end
	return tbl
end

function Nurfed_Options_paneAddOption()
	local frame = this:GetParent()
	local objtype = this:GetObjectType()
	if (objtype == "EditBox") then
		if (this:GetText() and this:GetText() ~= "") then
			if (frame.up) then
				this:SetText(string.gsub(this:GetText(), "^%l", string.upper))
			end
			if (frame.notbl) then
				Nurfed:SetOption(activemenu, frame.option, true, this:GetText())
			else
				local tbl = Nurfed_Options_panegetopts()
				Nurfed:SetOption(activemenu, frame.option, tbl, this:GetText())
			end
		end
		this:ClearFocus()
		this:SetText("")
	else
		local option = Nurfed:getopt(activemenu, frame.option)
		local name = table.getn(option) + 1
		local tbl = Nurfed_Options_panegetopts()
		Nurfed:SetOption(activemenu, frame.option, tbl, name)
	end
	Nurfed_Options_ScrollPane(frame)
	if (frame.func) then
		frame.func()
	end
end

function Nurfed_Options_paneRemoveOption()
	local frame = this:GetParent()
	if (frame.selected) then
		Nurfed:SetOption(activemenu, frame.option, nil, frame.selected)
		frame.selected = nil
	end
	Nurfed_Options_ScrollPane(frame)
	if (frame.func) then
		frame.func()
	end
end

function Nurfed_Options_ScrollPane(frame)
	if (not frame) then
		frame = this:GetParent()
	else
		this = getglobal(frame:GetName().."scroll")
	end
	local rows = frame.rows
	local selected = frame.selected
	local line, offset, row, text, count, temp
	local option = Nurfed:getopt(activemenu, frame.option)
	
	if (table.getn(option) > 0) then
		count = table.getn(option)
	else
		temp = {}
		for k in pairs(option) do
			table.insert(temp, k)
		end
		count = table.getn(temp)
	end
	FauxScrollFrame_Update(this, count, rows, 13)
	for line = 1, rows do
		offset = line + FauxScrollFrame_GetOffset(this)
		row = getglobal(frame:GetName().."row"..line)
		text = getglobal(row:GetName().."text")
		if offset <= count then
			if (temp) then
				text:SetText(temp[offset])
				if (selected == temp[offset]) then
					row:LockHighlight()
				else
					row:UnlockHighlight()
				end
			else
				text:SetText(frame.prefix.." "..offset)
				row.id = offset
				if (selected == offset) then
					row:LockHighlight()
				else
					row:UnlockHighlight()
				end
			end
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_Options_PaneSelect()
	local frame = this:GetParent()
	local selected = frame.selected
	if (this.id) then
		if (selected == this.id) then
			frame.selected = nil
			this:UnlockHighlight()
		else
			frame.selected = this.id
			this:LockHighlight()
		end
	else
		local text = getglobal(this:GetName().."text"):GetText()
		if (selected == text) then
			frame.selected = nil
			this:UnlockHighlight()
		else
			frame.selected = text
			this:LockHighlight()
		end
	end
	if (frame.selected) then
		Nurfed_Options_paneUpdateOptions(frame)
	end
	Nurfed_Options_ScrollPane(frame)
end

-- Dropdowns
function Nurfed_Options_dropdownOnShow()
	UIDropDownMenu_SetWidth(this.width, this)
	UIDropDownMenu_Initialize(this, this.init)
	if (this.selected) then
		UIDropDownMenu_SetSelectedID(this, this.selected)
	end
	UIDropDownMenu_JustifyText("LEFT", this)
end
]]