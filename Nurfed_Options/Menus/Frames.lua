local layout, name

function Nurfed_SendLayout()
	if layout > 0 then
		local text = table.remove(layout, 1)
		SendAddonMessage("Nurfed", "Lyt:"..string.trim(text), "WHISPER", name)
	else
		Nurfed:unschedule(nrfsend, true)
		Nurfed:print("Layout Sent To "..name)
		SendAddonMessage("Nurfed", "Lyt:complete", "WHISPER", name)
		name = nil
	end
	
end

NURFED_MENUS["Frames"] = {
	template = "nrf_options",
	children = {
		import = {
			template = "nrf_button",
			Point = { "BOTTOMRIGHT", -5, 5 }
		},
		send = {
			template = "nrf_button",
			Text = "Send Layout",
			Point = { "RIGHT", "$parentimport", "LEFT", -5, 0 }
		},
	},
	OnLoad = function(self)
		local import = getglobal(self:GetName().."import")
		if Nurfed_UnitsLayout then
			import:SetText("Import")
		else
			import:SetText("Disabled")
		end
	end,
}






















Nurfed:createtemp("nrf_frames_row", {
	type = "Button",
	size = { 400, 14 },
	children = {
		icon = {
			type = "Button",
			layer = "ARTWORK",
			size = { 14, 14 },
			Anchor = { "LEFT", "$parent", "LEFT", 5, 0 },
			NormalTexture = "Interface\\Buttons\\UI-PlusButton-Up",
			PushedTexture = "Interface\\Buttons\\UI-PlusButton-Down",
			HighlightTexture = "Interface\\Buttons\\UI-PlusButton-Hilight",
			OnClick = function() Nurfed_ExpandFrame() end,
		},
		name = {
			type = "FontString",
			layer = "ARTWORK",
			size = { 250, 14 },
			Anchor = { "LEFT", "$parenticon", "RIGHT", 5, 0 },
			FontObject = "GameFontNormal",
			JustifyH = "LEFT",
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
	OnClick = function() Nurfed_Frame_OnClick(arg1) end,
})

local framelist
local methods = {}
local framedelete = CreateFrame("Frame")
framedelete:Hide()

local ignore = {
	GetScript = true,
	GetAttribute = true,
	GetRegions = true,
	GetChildren = true,
	GetParent = true,
	GetMinResize = true,
	GetMaxResize = true,
	GetHitRectInsets = true,
	GetID = true,
	GetDisabledFontObject = true,
	GetPushedTexture = true,
	GetHighlightTexture = true,
	GetNormalTexture = true,
	GetDisabledTexture = true,
	GetButtonState = true,
	GetMinMaxValues = true,
	GetValue = true,
	GetTexCoordModifiesRect = true,
	GetModel = true,
	Enable = true,
	EnableDrawLayer = true,
	EnableKeyboard = true,
	EnableMouseWheel = true,
	GetText = true,
	GetFontString = true,
	GetFogColor = true,
	GetFogFar = true,
	GetFogNear = true,
	GetLight = true,
	GetPosition = true,
}

local points = {
	BOTTOM = true,
	BOTTOMLEFT = true,
	BOTTOMRIGHT = true,
	CENTER = true,
	LEFT = true,
	RIGHT = true,
	TOP = true,
	TOPLEFT = true,
	TOPRIGHT = true,
}


local tables = {
	Backdrop = true,
	Font = true,
	Point = true,
	PushedTextOffset = true,
	ShadowOffset = true,
	TexCoord = true,
}

local checks = {
	Fading = true,
	EnableMouse = true,
	ClampedToScreen = true,
}

local sliders = {
	Alpha = { 2, "0%", "100%", 0, 1, 0.01 },
	Scale = { 2, "25%", "300%", 0, 3, 0.01 },
}

local edits = {
	Height = { 40, true, "CENTER" },
	Width = { 40, true, "CENTER" },
	FrameLevel = { 40, true, "CENTER" },
	Spacing = { 40, true, "CENTER" },
	FadeDuration = { 50, nil, "CENTER", 2 },
	ModelScale = { 50, nil, "CENTER", 2 },
	TimeVisible = { 40, true, "CENTER" },
	FontObject = { 170, nil, "LEFT" },
	TextFontObject = { 170, nil, "LEFT" },
	HighlightFontObject = { 170, nil, "LEFT" },
	Texture = { 220, nil, "LEFT" },
	NormalTexture = { 220, nil, "LEFT" },
	StatusBarTexture = { 190, nil, "LEFT" },
	Facing = { 60, nil, "CENTER", 4 },
}

local drops = {
	DrawLayer = { "BACKGROUND", "BORDER", "ARTWORK", "OVERLAY", "HIGHLIGHT" },
	JustifyH = { "LEFT","RIGHT", "CENTER" },
	JustifyV = { "TOP","BOTTOM", "MIDDLE" },
	FrameStrata = { "TOOLTIP", "FULLSCREEN_DIALOG", "FULLSCREEN", "DIALOG", "HIGH", "MEDIUM", "LOW", "BACKGROUND" },
	Orientation = { "HORIZONTAL", "VERTICAL"},
	InsertMode = { "TOP", "BOTTOM" },
	BlendMode = { "DISABLE", "BLEND", "ALPHAKEY", "ADD", "MOD" },
}

local dropdowns = {
	[1] = {
		{ "BOTTOM", "BOTTOM" },
		{ "BOTTOMLEFT", "BOTTOMLEFT" },
		{ "BOTTOMRIGHT", "BOTTOMRIGHT" },
		{ "CENTER", "CENTER" },
		{ "LEFT", "LEFT" },
		{ "RIGHT", "RIGHT" },
		{ "TOP", "TOP" },
		{ "TOPLEFT", "TOPLEFT" },
		{ "TOPRIGHT", "TOPRIGHT" }
	},
	[2] = {
		{ "None", "" },
		{ "Tooltip", "Interface\\Tooltips\\UI-Tooltip-Background" },
		{ "Plain", NRF_IMG.."PlainBackdrop" }
	},
	[3] = {
		{ "None", "" },
		{ "Plain", NRF_IMG.."PlainBackdrop" },
		{ "Round", "Interface\\Tooltips\\UI-Tooltip-Border" },
		{ "Square", "Interface\\DialogFrame\\UI-DialogBox-Border" }
	},
	[4] = {
		{ "Blizzard", "Interface\\TargetingFrame\\UI-StatusBar" },
		{ "Texture1", NRF_IMG.."statusbar2" },
		{ "Texture2", NRF_IMG.."statusbar3" },
		{ "Texture3", NRF_IMG.."statusbar4" },
		{ "Texture4", NRF_IMG.."statusbar5" },
		{ "Texture5", NRF_IMG.."statusbar6" },
		{ "Texture6", NRF_IMG.."statusbar7" },
		{ "Texture7", NRF_IMG.."statusbar8" },
		{ "Texture8", NRF_IMG.."statusbar9" },
	},
}

local popframes = function()
	framelist = {}
	local function populate(n, f, l)
		if Nurfed_MenuFrames[f] then
			local kids = {}
			Nurfed:getframes(getglobal(f), kids)
			table.sort(kids, function(a, b) return a > b end)
			for _, v in ipairs(kids) do
				table.insert(framelist, n, { v, l })
			end
		end
	end

	for k in pairs(NURFED_FRAMES.frames) do
		table.insert(framelist, { k, 0 })
	end
	table.sort(framelist, function(a, b) return a[1] < b[1] end)
	for k, v in ipairs(framelist) do populate(k + 1, v[1], v[2] + 1) end
end

local configmain = function()
	UIDropDownMenu_SetWidth(150, this)
	UIDropDownMenu_JustifyText("LEFT", this)
	this.displayMode = "MENU"
	this:SetScript("OnShow", nil)
	this:SetScale(0.85)

	UIDropDownMenu_SetWidth(150, Nurfed_MenuEditordrop)
	UIDropDownMenu_JustifyText("LEFT", Nurfed_MenuEditordrop)
	Nurfed_MenuEditordrop.displayMode = "MENU"
	Nurfed_MenuEditordrop:SetScale(0.85)
	Nurfed_MenuEditorbackdroptileText:SetText("Tile")
end

local hidemethods = function()
	Nurfed_MenuEditorcolor:Hide()
	Nurfed_MenuEditorenable:Hide()
	Nurfed_MenuEditorslider:Hide()
	Nurfed_MenuEditoredit:Hide()
	Nurfed_MenuEditordrop:Hide()
	Nurfed_MenuEditorbackdrop:Hide()
	Nurfed_MenuEditorfont:Hide()
	Nurfed_MenuEditorpoint:Hide()
	Nurfed_MenuEditorpushedtextoffset:Hide()
	Nurfed_MenuEditorshadowoffset:Hide()
	Nurfed_MenuEditortexcoord:Hide()
	Nurfed_MenuEditoreditdrop:Hide()
end

local updatemethods = function()
	local info
	for k, v in ipairs(methods) do
		info = {}
		info.text = v
		info.func = Nurfed_Method_OnClick
		info.checked = nil
		UIDropDownMenu_AddButton(info)
	end
end

local updateeditor = function()
	local name = Nurfed_MenuFrames.select
	local frame = getglobal(name)
	Nurfed_MenuEditorframe:SetText(name)
	Nurfed_MenuEditordelete:Hide()
	Nurfed_MenuEditorcreate:Hide()

	if frame then
		Nurfed_MenuEditordelete:Show()
		local tbl = getmetatable(frame, 0)
		methods = {}
		for k, v in pairs(tbl.__index) do
			local set = string.gsub(k, "Get", "")
			set = string.gsub(set, "Set", "")
			if not ignore[k] and (k == "EnableMouse" or k == "SetClampedToScreen" or (string.find(k, "^Get") and frame["Set"..set])) then
				table.insert(methods, set)
			end
			if string.find(k, "^Create") then
				Nurfed_MenuEditorcreate:Show()
			end
		end
		table.sort(methods, function(a, b) return a < b end)
		UIDropDownMenu_Initialize(Nurfed_MenuEditormethods, updatemethods)
		Nurfed_Method_OnClick(1)
		--[[
		local text = {}
		for k, v in pairs(frame) do
			if type(v) == "string" or type(v) == "number" then
				table.insert(text, k.." = "..v)
			end
		end
		Nurfed_MenuEditorvars:SetText(table.concat(text, "\n"))
		]]
	else
		hidemethods()
		Nurfed_MenuEditorcreate:Show()
		--Nurfed_MenuEditorvars:SetText("")
		UIDropDownMenu_ClearAll(Nurfed_MenuEditormethods)
	end
end

function getframetable(frame, tab)
	local tbl = getmetatable(frame, 0)
	tab.type = frame:GetObjectType()
	local vars = {}
	for k, v in pairs(frame) do
		if type(v) == "string" or type(v) == "number" then
			vars[k] = v
		end
	end
	if frame.GetAttribute and frame:GetAttribute("unit") then
		tab.uitemp = "SecureUnitButtonTemplate"
	end
	tab.vars = vars

	for k, v in pairs(tbl.__index) do
		local set = string.gsub(k, "Get", "")
		if set == "IsMouseEnabled" then set = "Mouse" end
		if set == "IsClampedToScreen" then set = "ClampedToScreen" end
		if not ignore[k] and (k == "IsMouseEnabled" or k == "IsClampedToScreen" or (string.find(k, "^Get") and frame["Set"..set])) then
			local method = frame[k]
			local val = { method(frame) }
			if #val > 0 and val[1] then
				for i = 1, #val do
					if type(val[i]) == "table" then
						if val[i].GetTexture then
							val[i] = val[i]:GetTexture()
						elseif val[i].GetName then
							val[i] = val[i]:GetName()
						end
					end
				end
				if table.getn(val) == 1 then val = val[1] end
				if set == "Point" and frame:GetPoint(2) then
					val = "all"
				end
				tab[set] = val
			end
		end
	end
	if tab["FontObject"] and tab["Font"] then tab["FontObject"] = nil end
	local children = {}
	Nurfed:getframes(frame, children)
	if #children > 0 then
		tab.children = {}
		for _, v in ipairs(children) do
			local child = getglobal(v)
			local parent = child:GetParent():GetName()
			local childname = string.gsub(child:GetName(), parent, "")
			tab.children[childname] = {}
			getframetable(child, tab.children[childname])
		end
	end
end

local saveframe = function(frame)
	if not frame then
		frame = getglobal(Nurfed_MenuFrames.select)
	end
	while frame:GetParent() ~= UIParent do
		frame = frame:GetParent()
	end
	local name = frame:GetName()
	getframetable(frame, NURFED_FRAMES.frames[name])
end

local frameupdate = function(edit, nosave)
	local frame = getglobal(Nurfed_MenuFrames.select)
	if edit then this = edit end
	if frame then
		local val, color, bgcolor
		local id = UIDropDownMenu_GetSelectedID(Nurfed_MenuEditormethods)
		local m = methods[id]
		local method = frame["Set"..m] or frame["EnableMouse"]
		local objtype = this:GetObjectType()
		if string.find(m, "Color") then
			val = { Nurfed_MenuEditorcolor:GetColorRGB() }
			val[4] = Nurfed_MenuEditorcoloralpha:GetNumber()/100
		elseif m == "Backdrop" then
			color = { frame:GetBackdropColor() }
			bgcolor = { frame:GetBackdropBorderColor() }
			val = {
				bgFile = Nurfed_MenuEditorbackdropbgFile:GetText(),
				edgeFile = Nurfed_MenuEditorbackdropedgeFile:GetText(),
				tile = Nurfed_MenuEditorbackdroptile:GetChecked(),
				tileSize = Nurfed_MenuEditorbackdroptileSize:GetNumber(),
				edgeSize = Nurfed_MenuEditorbackdropedgeSize:GetNumber(),
				insets = {
					left = Nurfed_MenuEditorbackdropleft:GetNumber(),
					right = Nurfed_MenuEditorbackdropright:GetNumber(),
					top = Nurfed_MenuEditorbackdroptop:GetNumber(),
					bottom = Nurfed_MenuEditorbackdropbottom:GetNumber(),
				}
			}
		elseif m == "Font" then
			val = {
				Nurfed_MenuEditorfont1:GetText(),
				Nurfed_MenuEditorfont2:GetNumber(),
				Nurfed_MenuEditorfont3:GetText(),
			}
		elseif m == "Point" then
			local text4 = Nurfed_MenuEditorpoint4:GetText()
			local text5 = Nurfed_MenuEditorpoint5:GetText()
			if not string.find(text4, "[0-9]+") or not string.find(text5, "[0-9]+") then return end
			val = {
				string.upper(Nurfed_MenuEditorpoint1:GetText()),
				Nurfed_MenuEditorpoint2:GetText(),
				string.upper(Nurfed_MenuEditorpoint3:GetText()),
				tonumber(text4),
				tonumber(text5),
			}
		elseif m == "PushedTextOffset" then
			val = {
				Nurfed_MenuEditorpushedtextoffset1:GetNumber(),
				Nurfed_MenuEditorpushedtextoffset2:GetNumber(),
			}
		elseif m == "ShadowOffset" then
			local text1 = Nurfed_MenuEditorshadowoffset1:GetText()
			local text2 = Nurfed_MenuEditorshadowoffset2:GetText()
			if not string.find(text1, "[0-9]+") or not string.find(text2, "[0-9]+") then return end
			val = {
				tonumber(text1),
				tonumber(text2),
			}
		elseif m == "TexCoord" then
			val = {
				tonumber(Nurfed_MenuEditortexcoord1:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord2:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord3:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord4:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord5:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord6:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord7:GetText()) or 0,
				tonumber(Nurfed_MenuEditortexcoord8:GetText()) or 0,
			}
		elseif objtype == "CheckButton" then
			val = Nurfed_MenuEditorenable:GetChecked()
		elseif objtype == "Slider" then
			val = Nurfed_MenuEditorslider:GetValue()
		elseif objtype == "EditBox" then
			if Nurfed_MenuEditoredit:IsNumeric() then
				val = Nurfed_MenuEditoredit:GetNumber()
			elseif Nurfed_MenuEditoredit.deci then
				val = Nurfed_MenuEditoredit:GetText()
				val = tonumber(val) or 0
				val = math.round(val, Nurfed_MenuEditoredit.deci)
			else
				val = Nurfed_MenuEditoredit:GetText()
			end
			if val == "" then val = nil end
		elseif objtype == "Button" then
			local id = this:GetID()
			UIDropDownMenu_SetSelectedID(Nurfed_MenuEditordrop, id)
			val = this:GetText()
		end
		if string.find(m, "Object") and not getglobal(val) then return end
		if m == "Point" then
			if not points[val[1]] then return end
			if not points[val[3]] then return end
			string.gsub(val[2], "$parent", frame:GetParent():GetName())
			if val[2] == "" then
				val[2] = nil
			elseif not getglobal(val[2]) then
				return
			end
			frame:ClearAllPoints()
		end
		if type(val) == "table" and m ~= "Backdrop" then
			method(frame, unpack(val))
		else
			method(frame, val)
			if m == "Backdrop" then
				frame:SetBackdropColor(unpack(color))
				frame:GetBackdropBorderColor(unpack(bgcolor))
			end
		end
		if not nosave then
			saveframe()
		end
	end
end

local colorupdate = function()
	local r = Nurfed_MenuEditorcolorred:GetNumber()/255
	local g = Nurfed_MenuEditorcolorgreen:GetNumber()/255
	local b = Nurfed_MenuEditorcolorblue:GetNumber()/255
	local a = Nurfed_MenuEditorcoloralpha:GetNumber()/100
	if r > 1 then r = 1 Nurfed_MenuEditorcolorred:SetText(255) end
	if g > 1 then g = 1 Nurfed_MenuEditorcolorgreen:SetText(255) end
	if b > 1 then b = 1 Nurfed_MenuEditorcolorblue:SetText(255) end
	if a > 1 then a = 1 Nurfed_MenuEditorcoloralpha:SetText(100) end
	Nurfed_MenuEditorcolor:SetColorRGB(r, g, b)
	frameupdate()
end

local import = function()
	for k, v in pairs(Nurfed_UnitsLayout.templates) do
		NURFED_FRAMES.templates[k] = v
	end
	for k, v in pairs(Nurfed_UnitsLayout.Layout) do
		local name = k
		if not string.find(k, "^Nurfed") then name = "Nurfed_"..k end
		NURFED_FRAMES.frames[name] = v
	end
	if Nurfed_UnitsLayout.Name and Nurfed_UnitsLayout.Author then
		Nurfed:print(Nurfed_UnitsLayout.Name.." designed by "..Nurfed_UnitsLayout.Author.." imported.")
	end
	StaticPopup_Show("NRF_RELOADUI")
end

local delete = function()
	local name = Nurfed_MenuFrames.select
	local frame = getglobal(name)
	if frame then
		local parent = frame:GetParent()
		if frame.UnregisterAllEvents then frame:UnregisterAllEvents() end
		frame:SetParent(framedelete)
		frame:Hide()
		if parent == UIParent then
			NURFED_FRAMES.frames[name] = nil
		else
			saveframe(parent)
		end
		Nurfed_MenuFrames.select = nil
		Nurfed_MenuFrames[name] = nil
		popframes()
		Nurfed_ScrollFrames()
		updateeditor()
	end
end

local framedrop = function()
	local drop = Nurfed_MenuEditordropdown
	local info = {}
	local id = this:GetID()
	local parent = this:GetParent()
	drop.displayMode = "MENU"
	drop.initialize = function()
		for _, v in ipairs(dropdowns[id]) do
			info = {}
			info.text = v[1]
			info.value = v[2]
			info.func = function() parent:SetText(this.value) end
			info.isTitle = nil
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info)
		end
	end
	ToggleDropDownMenu(1, nil, drop, "cursor")
end

local createnew = function()
	local parent = this.value
	local method = this:GetText()
	local name = parent:GetName()
	if parent == UIParent then
		name = "Nurfed_"
	end
	Nurfed_MenuFrames.data = { parent, method, name }
	StaticPopupDialogs["NRF_CREATE"].text = "Create new "..method.."\n|cffff0000"..name.."|r"
	StaticPopup_Show("NRF_CREATE")
end

local framecreate = function()
	local creates = {}
	if Nurfed_MenuFrames.select then
		local frame = getglobal(Nurfed_MenuFrames.select)
		if frame.CreateTexture then table.insert(creates, { frame, "Texture" }) end
		if frame.CreateFontString then table.insert(creates, { frame, "FontString" }) end
		if frame.GetChildren then
			table.insert(creates, { frame, "Button" })
			table.insert(creates, { frame, "Frame" })
			table.insert(creates, { frame, "PlayerModel" })
			table.insert(creates, { frame, "StatusBar" })
		end
	else
		table.insert(creates, { UIParent, "Button" })
		table.insert(creates, { UIParent, "Frame" })
	end

	local drop = Nurfed_MenuEditordropdown
	local info = {}
	drop.displayMode = "MENU"
	drop.initialize = function()
		for _, v in ipairs(creates) do
			info = {}
			info.text = v[2]
			info.value = v[1]
			info.func = createnew
			info.isTitle = nil
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info)
		end
	end
	ToggleDropDownMenu(1, nil, drop, "cursor")
end

function Nurfed_ScrollFrames()
	if not framelist then popframes() end
	if Nurfed_UnitsLayout then
		Nurfed_MenuEditorimport:Show()
	end

	local format_row = function(row, num)
		local frame = framelist[num][1]
		local level = framelist[num][2]
		local icon = getglobal(row:GetName().."icon")
		local name = getglobal(row:GetName().."name")
		name:SetText(frame)
		icon:Hide()
		icon:ClearAllPoints()
		icon:SetPoint("LEFT", row, "LEFT", 5 + (10 * level), 0)
		if getglobal(frame).GetChildren then
			icon:Show()
			if Nurfed_MenuFrames[frame] then
				icon:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
				icon:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
			else
				icon:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
				icon:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
			end
		end

		row.frame = frame
		if Nurfed_MenuFrames.select == frame then
			row:LockHighlight()
		else
			row:UnlockHighlight()
		end
	end

	local frame = Nurfed_MenuFramesscroll
	FauxScrollFrame_Update(frame, #framelist, 19, 14)
	for line = 1, 19 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("Nurfed_FramesRow"..line)
		if offset <= #framelist then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_Frame_OnClick(button)
	local frame = this.frame
	if Nurfed_MenuFrames.select == frame then
		Nurfed_MenuFrames.select = nil
	else
		Nurfed_MenuFrames.select = frame
	end
	updateeditor()
	Nurfed_ScrollFrames()
end

function Nurfed_Method_OnClick(id)
	if not id then id = this:GetID() end
	UIDropDownMenu_SetSelectedID(Nurfed_MenuEditormethods, id)
	local name = Nurfed_MenuFrames.select
	local frame = getglobal(name)
	hidemethods()
	if frame then
		local m = methods[id]
		local method = frame["Get"..m] or frame["IsMouseEnabled"] or frame["IsClampedToScreen"]
		local val = { method(frame) }
		if table.getn(val) == 0 then
			val = nil
		else
			for i = 1, #val do
				if type(val[i]) == "table" and m ~= "Point" then
					if val[i].GetTexture then
						val[i] = val[i]:GetTexture()
					elseif val[i].GetName then
						val[i] = val[i]:GetName()
					end
				elseif m == "Point" and type(val[i]) == "nil" then
					val[i] = ""
				end
			end
			if table.getn(val) == 1 then val = val[1] end
		end
		if string.find(m, "Color") then
			if not val then val = { 1, 1, 1, 1 } end
			Nurfed_MenuEditorcolor:Show()
			Nurfed_MenuEditorcolor:SetColorRGB(val[1], val[2], val[3])
			Nurfed_MenuEditorcolorred:SetText(math.round(255 * val[1]))
			Nurfed_MenuEditorcolorgreen:SetText(math.round(255 * val[2]))
			Nurfed_MenuEditorcolorblue:SetText(math.round(255 * val[3]))
			Nurfed_MenuEditorcoloralpha:SetText(math.round(100 * val[4]))
			Nurfed_MenuEditorcolor.previousValues = val
		elseif tables[m] then
			m = string.lower(m)
			getglobal("Nurfed_MenuEditor"..m):Show()
			if val then
				for k, v in pairs(val) do
					if type(v) == "string" then
						local opt = getglobal("Nurfed_MenuEditor"..m..k)
						local objtype = opt:GetObjectType()
						if objtype == "EditBox" then
							opt:SetText(v)
						elseif objtype == "Frame" then
							UIDropDownMenu_SetSelectedValue(opt, v)
						end
					elseif type(v) == "number" then
						local opt = getglobal("Nurfed_MenuEditor"..m..k)
						local objtype = opt:GetObjectType()
						if objtype == "EditBox" then
							if opt:IsNumeric() or opt.deci then v = math.round(v, opt.deci) end
							opt:SetText(v)
						elseif objtype == "CheckButton" then
							opt:SetChecked(v)
						end
					elseif type(v) == "table" then
						if v.GetName then
							local opt = getglobal("Nurfed_MenuEditor"..m..k)
							opt:SetText(v:GetName())
						else
							for i, j in pairs(v) do
								getglobal("Nurfed_MenuEditor"..m..i):SetText(math.round(j))
							end
						end
					end
				end
			end
		elseif checks[m] then
			Nurfed_MenuEditorenable:Show()
			Nurfed_MenuEditorenableText:SetText(m)
			Nurfed_MenuEditorenable:SetChecked(val)
		elseif sliders[m] then
			if not val then val = 0 end
			Nurfed_MenuEditorslider:Show()
			Nurfed_MenuEditorslider.deci = sliders[m][1]
			Nurfed_MenuEditorsliderLow:SetText(sliders[m][2])
			Nurfed_MenuEditorsliderHigh:SetText(sliders[m][3])
			Nurfed_MenuEditorslider:SetMinMaxValues(sliders[m][4], sliders[m][5])
			Nurfed_MenuEditorslider:SetValueStep(sliders[m][6])
			Nurfed_MenuEditorslider:SetValue(val)
		elseif edits[m] then
			Nurfed_MenuEditoredit:Show()
			Nurfed_MenuEditoredit:SetWidth(edits[m][1])
			Nurfed_MenuEditoredit:SetNumeric(edits[m][2])
			Nurfed_MenuEditoredit.deci = edits[m][4]
			if edits[m][2] or edits[m][4] then val = math.round(val, edits[m][4]) end
			Nurfed_MenuEditoredit:SetJustifyH(edits[m][3])
			Nurfed_MenuEditoredit:SetText(val or "")
			if m == "StatusBarTexture" then Nurfed_MenuEditoreditdrop:Show() end
		elseif drops[m] then
			Nurfed_MenuEditordrop:Show()
			local selected
			UIDropDownMenu_Initialize(Nurfed_MenuEditordrop, function()
					local info
					for k, v in ipairs(drops[m]) do
						info = {}
						info.text = v
						info.func = frameupdate
						info.checked = nil
						UIDropDownMenu_AddButton(info)
						if v == val then selected = k end
					end
				end)
			UIDropDownMenu_SetSelectedID(Nurfed_MenuEditordrop, selected)
		end
	end
end


--[[ Frame Editor ]]--
local layout = {
	type = "Frame",
	size = { 250, 300 },
	FrameStrata = "LOW",
	Anchor = { "LEFT", "Nurfed_Menu", "RIGHT", 0, 0 },
	Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 4, top = 5, bottom = 4 }, },
	BackdropColor = { 0, 0, 0, 0.75 },
	children = {
		dropdown = { type = "Frame" },
		header = {
			type = "Frame",
			size = { 240, 15 },
			Anchor = { "TOP", "$parent", "TOP", 0, -5 },
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Anchor = "all",
					Texture = NRF_IMG.."statusbar8",
					Gradient = { "HORIZONTAL", 0, 0.75, 1, 0, 0, 0.2 },
				},
				title = {
					type = "FontString",
					layer = "ARTWORK",
					Anchor = "all",
					Font = { "Fonts\\FRIZQT__.TTF", 11, "OUTLINE" },
					JustifyH = "LEFT",
					TextColor = { 1, 1, 1 },
				},
				border = {
					type = "Texture",
					size = { 240, 3 },
					layer = "OVERLAY",
					Anchor = { "TOP", "$parent", "BOTTOM", 0, 1 },
					Texture = "Interface\\ClassTrainerFrame\\UI-ClassTrainer-HorizontalBar",
					TexCoord = { 0.2, 1, 0, 0.25 },
				},
			},
		},
		frame = {
			type = "FontString",
			layer = "ARTWORK",
			Anchor = { "TOPLEFT", "$parentheader", "BOTTOMLEFT", 0, -3 },
			Font = { "Fonts\\FRIZQT__.TTF", 11, "OUTLINE" },
			JustifyH = "LEFT",
			TextColor = { 1, 1, 1 },
		},
		methods = {
			type = "Frame",
			uitemp = "UIDropDownMenuTemplate",
			Anchor = { "TOPLEFT", "$parentheader", "BOTTOMLEFT", -15, -23 },
			OnShow = function() configmain() end,
		},
		color = {
			type = "ColorSelect",
			size = { 160, 100 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				ColorWheelTexture = {
					type = "Texture",
					size = { 100, 100 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
				},
				ColorWheelThumbTexture = {
					type = "Texture",
					size = { 8, 8 },
					Texture = "Interface\\Buttons\\UI-ColorPicker-Buttons",
					TexCoord = { 0, 0.15625, 0, 0.625 },
				},
				ColorValueTexture = {
					type = "Texture",
					size = { 20, 100 },
					Anchor = { "LEFT", "$parentColorWheelTexture", "RIGHT", 15, 0 },
				},
				ColorValueThumbTexture = {
					type = "Texture",
					size = { 40, 8 },
					Texture = "Interface\\Buttons\\UI-ColorPicker-Buttons",
					TexCoord = { 0.25, 1.0, 0, 0.875 },
				},
				red = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", 0, 0 },
					JustifyH = "CENTER",
					BackdropColor = { 0.3, 0, 0, 0.75 },
					TextColor = { 1, 0, 0 },
					Numeric = true,
					MaxLetters = 3,
					OnTabPressed = function() Nurfed_MenuEditorcolorgreen:SetFocus() end,
					OnTextChanged = function() if this.focus then colorupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				green = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOP", "$parentred", "BOTTOM", 0, -9 },
					JustifyH = "CENTER",
					BackdropColor = { 0, 0.3, 0, 0.75 },
					TextColor = { 0, 1, 0 },
					Numeric = true,
					MaxLetters = 3,
					OnTabPressed = function() Nurfed_MenuEditorcolorblue:SetFocus() end,
					OnTextChanged = function() if this.focus then colorupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				blue = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOP", "$parentgreen", "BOTTOM", 0, -9 },
					JustifyH = "CENTER",
					BackdropColor = { 0, 0, 0.3, 0.75 },
					TextColor = { 0, 1, 1 },
					Numeric = true,
					MaxLetters = 3,
					OnTabPressed = function() Nurfed_MenuEditorcoloralpha:SetFocus() end,
					OnTextChanged = function() if this.focus then colorupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				alpha = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOP", "$parentblue", "BOTTOM", 0, -9 },
					JustifyH = "CENTER",
					BackdropColor = { 1, 1, 1, 0.25 },
					Numeric = true,
					MaxLetters = 3,
					OnTabPressed = function() Nurfed_MenuEditorcolorred:SetFocus() end,
					OnTextChanged = function() if this.focus then colorupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
			},
			OnColorSelect = function()
						Nurfed_MenuEditorcolorred:SetText(math.round(255 * arg1))
						Nurfed_MenuEditorcolorgreen:SetText(math.round(255 * arg2))
						Nurfed_MenuEditorcolorblue:SetText(math.round(255 * arg3))
						frameupdate(nil, true)
					end,
			OnMouseUp = function() frameupdate() end,
			Hide = true,
		},
		backdrop = {
			type = "Frame",
			size = { 220, 175 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				bgFile = {
					template = "nrf_editbox",
					size = { 175, 18 },
					children = {
						drop = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "...",
							ID = 2,
							OnClick = function() framedrop() end,
						},
					},
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					OnTabPressed = function() Nurfed_MenuEditorbackdropedgeFile:SetFocus() end,
					OnTextChanged = function() frameupdate() end,
				},
				edgeFile = {
					template = "nrf_editbox",
					size = { 175, 18 },
					children = {
						drop = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "...",
							ID = 3,
							OnClick = function() framedrop() end,
						},
					},
					Anchor = { "TOP", "$parentbgFile", "BOTTOM", 0, -9 },
					OnTabPressed = function() Nurfed_MenuEditorbackdroptileSize:SetFocus() end,
					OnTextChanged = function() frameupdate() end,
				},
				tile = {
					type = "CheckButton",
					size = { 20, 20 },
					uitemp = "UICheckButtonTemplate",
					Anchor = { "TOPLEFT", "$parentedgeFile", "BOTTOMLEFT", 0, -9 },
					OnClick = function() frameupdate() end,
				},
				tileSize = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parenttile", "RIGHT", 40, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorbackdropedgeSize:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				edgeSize = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parenttileSize", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorbackdropleft:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				left = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOPLEFT", "$parenttile", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorbackdropright:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				right = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parentleft", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorbackdroptop:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				top = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parentright", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorbackdropbottom:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				bottom = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parenttop", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorbackdropbgFile:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
			},
			Hide = true,
		},
		font = {
			type = "Frame",
			size = { 220, 175 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				["1"] = {
					template = "nrf_editbox",
					size = { 175, 18 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					OnTabPressed = function() Nurfed_MenuEditorfont2:SetFocus() end,
					OnTextChanged = function() frameupdate() end,
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorfont3:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				["3"] = {
					template = "nrf_editbox",
					size = { 175, 18 },
					Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, -9 },
					OnTabPressed = function() Nurfed_MenuEditorfont1:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
			},
			Hide = true,
		},
		point = {
			type = "Frame",
			size = { 220, 175 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				["1"] = {
					template = "nrf_editbox",
					size = { 125, 18 },
					children = {
						drop = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "...",
							ID = 1,
							OnClick = function() framedrop() end,
						},
					},
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					OnTabPressed = function() Nurfed_MenuEditorpoint2:SetFocus() end,
					OnTextChanged = function() frameupdate() end,
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 175, 18 },
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, -9 },
					OnTabPressed = function() Nurfed_MenuEditorpoint3:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				["3"] = {
					template = "nrf_editbox",
					size = { 125, 18 },
					children = {
						drop = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = "...",
							ID = 1,
							OnClick = function() framedrop() end,
						},
					},
					Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, -9 },
					OnTabPressed = function() Nurfed_MenuEditorpoint4:SetFocus() end,
					OnTextChanged = function() frameupdate() end,
				},
				["4"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "TOPLEFT", "$parent3", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditorpoint5:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 0 },
				},
				["5"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent4", "RIGHT", 15, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditorpoint1:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 0 },
				},
			},
			Hide = true,
		},
		pushedtextoffset = {
			type = "Frame",
			size = { 220, 175 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				["1"] = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorpushedtextoffset2:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parent1", "RIGHT", 15, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function() Nurfed_MenuEditorpushedtextoffset1:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
			},
			Hide = true,
		},
		shadowoffset = {
			type = "Frame",
			size = { 220, 175 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				["1"] = {
					template = "nrf_editbox",
					size = { 40, 18 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					JustifyH = "CENTER",
					MaxLetters = 3,
					OnTabPressed = function() Nurfed_MenuEditorshadowoffset2:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 0 },
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 40, 18 },
					Anchor = { "LEFT", "$parent1", "RIGHT", 15, 0 },
					JustifyH = "CENTER",
					MaxLetters = 3,
					OnTabPressed = function() Nurfed_MenuEditorshadowoffset1:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 0 },
				},
			},
			Hide = true,
		},
		texcoord = {
			type = "Frame",
			size = { 220, 175 },
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				["1"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord2:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent1", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord3:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["3"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent2", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord4:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["4"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent3", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord5:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["5"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord6:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["6"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent5", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord7:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["7"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent6", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord8:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
				["8"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent7", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function() Nurfed_MenuEditortexcoord1:SetFocus() end,
					OnTextChanged = function() if this.focus then frameupdate() end end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
					vars = { deci = 3 },
				},
			},
			Hide = true,
		},
		enable = {
			type = "CheckButton",
			size = { 20, 20 },
			uitemp = "UICheckButtonTemplate",
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			OnClick = function() frameupdate() end,
			Hide = true,
		},
		slider = {
			type = "Slider",
			uitemp = "OptionsSliderTemplate",
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			children = {
				value = {
					template = "nrf_editbox",
					size = { 35, 18 },
					Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
					OnTextChanged = function()
						local value = tonumber(this:GetText())
						local min, max = this:GetParent():GetMinMaxValues()
						if not value or value < min then return end
						if value > max then value = max end
						this:GetParent():SetValue(value)
						if this.focus then frameupdate(this:GetParent()) end
					end,
					OnEditFocusGained = function() this:HighlightText() this.focus = true end,
					OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
				},
			},
			OnMouseUp = function() frameupdate() end,
			OnValueChanged = function() Nurfed_Options_sliderOnValueChanged() end,
			Hide = true,
		},
		edit = {
			template = "nrf_editbox",
			size = { 40, 18 },
			Numeric = true,
			children = {
				drop = {
					template = "nrf_button",
					Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
					Text = "...",
					ID = 4,
					OnClick = function() framedrop() end,
				},
			},
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			OnTextChanged = function() frameupdate() end,
			Hide = true,
		},
		drop = {
			type = "Frame",
			uitemp = "UIDropDownMenuTemplate",
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 0, -8 },
			Hide = true,
		},
		import = {
			template = "nrf_button",
			Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
			Text = "Import Layout",
			OnClick = function() import() end,
			Hide = true,
		},
		delete = {
			template = "nrf_button",
			Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 5 },
			Text = DELETE,
			OnClick = function()
					StaticPopupDialogs["NRF_DELETE"].text = "Delete "..Nurfed_MenuFrames.select.."?"
					StaticPopup_Show("NRF_DELETE")
				end,
			Hide = true,
		},
		create = {
			template = "nrf_button",
			Anchor = { "LEFT", "$parentdelete", "RIGHT", 10, 0 },
			Text = CREATE,
			OnClick = function() framecreate() end,
		},
		--[[
		vars = {
			template = "nrf_editbox",
			size = { 220, 270 },
			Anchor = { "BOTTOM", "$parent", "BOTTOM", 0, 5 },
			MultiLine = true,
		},
		]]
	},
	Hide = true,
}

function Nurfed_ExpandFrame()
	local frame = this:GetParent().frame
	if Nurfed_MenuFrames[frame] then
		Nurfed_MenuFrames[frame] = nil
	else
		Nurfed_MenuFrames[frame] = true
	end
	popframes()
	Nurfed_ScrollFrames()
end

--frame = Nurfed:create("Nurfed_MenuEditor", layout, Nurfed_Menu)
--Nurfed_MenuEditorheadertitle:SetText("Nurfed Frame Editor")
layout = nil

StaticPopupDialogs["NRF_DELETE"] = {
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function() delete() end,
	timeout = 10,
	whileDead = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["NRF_CREATE"] = {
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	OnAccept = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox")
		local text = editBox:GetText()
		local data = Nurfed_MenuFrames.data
		local frame
		text = string.gsub(text, "%s", "")
		if text ~= "" and not getglobal(data[3]..text) then
			if data[2] == "Button" or data[2] == "Frame" or data[2] == "StatusBar" or data[2] == "PlayerModel" then
				frame = CreateFrame(data[2], data[3]..text, data[1])
				if data[2] == "StatusBar" then
					frame:SetMinMaxValues(0, 1)
					frame:SetValue(1)
				elseif data[2] == "PlayerModel" then
					frame:SetUnit("player")
					frame:SetCamera(0)
				end
				if data[1] == UIParent then
					NURFED_FRAMES.frames[data[3]..text] = {}
				end
			else
				if data[2] == "Texture" then
					frame = data[1]:CreateTexture(data[3]..text, "ARTWORK")
				else
					frame = data[1]:CreateFontString(data[3]..text, "ARTWORK")
				end
			end
			saveframe(frame)
		end
		editBox:SetText("")
	end,
	OnShow = function()
		getglobal(this:GetName().."EditBox"):SetFocus()
	end,
	OnHide = function()
		Nurfed_MenuFrames.data = nil
		popframes()
		Nurfed_ScrollFrames()
		updateeditor()
	end,
	EditBoxOnEnterPressed = function()
		local editBox = getglobal(this:GetParent():GetName().."EditBox")
		local text = editBox:GetText()
		local data = Nurfed_MenuFrames.data
		text = string.gsub(text, "%s", "")
		if text ~= "" and not getglobal(data[3]..text) then
			if data[2] == "Button" or data[2] == "Frame" or data[2] == "StatusBar" or data[2] == "PlayerModel" then
				frame = CreateFrame(data[2], data[3]..text, data[1])
				if data[2] == "StatusBar" then
					frame:SetMinMaxValues(0, 1)
					frame:SetValue(1)
				elseif data[2] == "PlayerModel" then
					frame:SetUnit("player")
					frame:SetCamera(0)
				end
				if data[1] == UIParent then
					NURFED_FRAMES.frames[data[3]..text] = {}
				end
			else
				if data[2] == "Texture" then
					frame = data[1]:CreateTexture(data[3]..text, "ARTWORK")
				else
					frame = data[1]:CreateFontString(data[3]..text, "ARTWORK")
				end
			end
			saveframe(frame)
		end
		editBox:SetText("")
		this:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function()
		this:GetParent():Hide()
	end,
	timeout = 10,
	whileDead = 1,
	hideOnEscape = 1,
}