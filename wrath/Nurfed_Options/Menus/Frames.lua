--[[Nurfed_OptionsMenus["Frames"] = {
	template = "nrf_options",
	children = {
		scroll = {
			type = "ScrollFrame",
			size = { 388, 270 },
			Anchor = { "LEFT", "$parent", "LEFT" },
			uitemp = "FauxScrollFrameTemplate",
			OnVerticalScroll = function(self) FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollFrames) end,
			OnShow = function(self) Nurfed_ScrollFrames() end,
		},
	},
}
]]
--[[
Nurfed:createtemp("nrf_frames_row", {
	type = "Frame",
	size = { 411, 271 },
	Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 1, 0 },
	Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
	BackdropColor = { 0, 0, 0, 0.95 },
	Alpha = 0,
	Hide = true,
	children = {
		scroll = {
			type = "ScrollFrame",
			size = { 388, 270 },
			Anchor = { "LEFT", "$parent", "LEFT" },
			uitemp = "FauxScrollFrameTemplate",
			OnVerticalScroll = function(self, val) 
				--FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollFrames) 
				FauxScrollFrame_OnVerticalScroll(self, val, 14, Nurfed_ScrollFrames) 
			end,
			OnShow = function(self) Nurfed_ScrollFrames() end,
		},
	},
})
]]
--local nrf = nurfed_util:new()
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

local popframes = function(self)
	framelist = {}
	local function populate(n, f, l)
		if NurfedFramesPanelFrames[f] then
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

local configmain = function(self)
	UIDropDownMenu_SetWidth(self, 150)
	UIDropDownMenu_JustifyText(self, "LEFT")
	self.displayMode = "MENU"
	self:SetScript("OnShow", nil)
	self:SetScale(0.85)

	UIDropDownMenu_SetWidth(NurfedFramesPanelEditordrop, 150)
	UIDropDownMenu_JustifyText(NurfedFramesPanelEditordrop, "LEFT")
	NurfedFramesPanelEditordrop.displayMode = "MENU"
	NurfedFramesPanelEditordrop:SetScale(0.85)
	NurfedFramesPanelEditorbackdroptileText:SetText("Tile")
end

local hidemethods = function(self)
	NurfedFramesPanelEditorcolor:Hide()
	NurfedFramesPanelEditorenable:Hide()
	NurfedFramesPanelEditorslider:Hide()
	NurfedFramesPanelEditoredit:Hide()
	NurfedFramesPanelEditordrop:Hide()
	NurfedFramesPanelEditorbackdrop:Hide()
	NurfedFramesPanelEditorfont:Hide()
	NurfedFramesPanelEditorpoint:Hide()
	NurfedFramesPanelEditorpushedtextoffset:Hide()
	NurfedFramesPanelEditorshadowoffset:Hide()
	NurfedFramesPanelEditortexcoord:Hide()
	NurfedFramesPanelEditoreditdrop:Hide()
end

local updatemethods = function(self)
	local info
	for k, v in ipairs(methods) do
		info = {}
		info.text = v
		info.func = function(self, ...) Nurfed_Method_OnClick(self, ...) end
		info.checked = nil
		UIDropDownMenu_AddButton(info)
	end
end

local updateeditor = function(self)
	local name = NurfedFramesPanelFrames.select
	local frame = getglobal(name)
	NurfedFramesPanelEditorframe:SetText(name)
	NurfedFramesPanelEditordelete:Hide()
	NurfedFramesPanelEditorcreate:Hide()

	if frame then
		NurfedFramesPanelEditordelete:Show()
		local tbl = getmetatable(frame, 0)
		methods = {}
		for k, v in pairs(tbl.__index) do
			local set = string.gsub(k, "Get", "")
			set = string.gsub(set, "Set", "")
			if not ignore[k] and (k == "EnableMouse" or k == "SetClampedToScreen" or (string.find(k, "^Get") and frame["Set"..set])) then
				table.insert(methods, set)
			end
			if string.find(k, "^Create") then
				NurfedFramesPanelEditorcreate:Show()
			end
		end
		table.sort(methods, function(a, b) return a < b end)
		UIDropDownMenu_Initialize(NurfedFramesPanelEditormethods, updatemethods)
		Nurfed_Method_OnClick(self, 1)
		--[[
		local text = {}
		for k, v in pairs(frame) do
			if type(v) == "string" or type(v) == "number" then
				table.insert(text, k.." = "..v)
			end
		end
		NurfedFramesPanelEditorvars:SetText(table.concat(text, "\n"))
		]]
	else
		hidemethods(self)
		NurfedFramesPanelEditorcreate:Show()
		--NurfedFramesPanelEditorvars:SetText("")
		UIDropDownMenu_ClearAll(NurfedFramesPanelEditormethods)
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
		frame = getglobal(NurfedFramesPanelFrames.select)
	end
	while frame:GetParent() ~= UIParent do
		frame = frame:GetParent()
	end
	local name = frame:GetName()
	getframetable(frame, NURFED_FRAMES.frames[name])
end

local frameupdate = function(self, edit, nosave)
	local frame = getglobal(NurfedFramesPanelFrames.select)
	if edit then self = edit end
	if frame then
		local val, color, bgcolor
		local id = UIDropDownMenu_GetSelectedID(NurfedFramesPanelEditormethods)
		local m = methods[id]
		debug(methods)
		local method = frame["Set"..m] or frame["EnableMouse"]
		local objtype = self:GetObjectType()
		if string.find(m, "Color") then
			val = { NurfedFramesPanelEditorcolor:GetColorRGB() }
			val[4] = NurfedFramesPanelEditorcoloralpha:GetNumber()/100
		elseif m == "Backdrop" then
			color = { frame:GetBackdropColor() }
			bgcolor = { frame:GetBackdropBorderColor() }
			val = {
				bgFile = NurfedFramesPanelEditorbackdropbgFile:GetText(),
				edgeFile = NurfedFramesPanelEditorbackdropedgeFile:GetText(),
				tile = NurfedFramesPanelEditorbackdroptile:GetChecked(),
				tileSize = NurfedFramesPanelEditorbackdroptileSize:GetNumber(),
				edgeSize = NurfedFramesPanelEditorbackdropedgeSize:GetNumber(),
				insets = {
					left = NurfedFramesPanelEditorbackdropleft:GetNumber(),
					right = NurfedFramesPanelEditorbackdropright:GetNumber(),
					top = NurfedFramesPanelEditorbackdroptop:GetNumber(),
					bottom = NurfedFramesPanelEditorbackdropbottom:GetNumber(),
				}
			}
		elseif m == "Font" then
			val = {
				NurfedFramesPanelEditorfont1:GetText(),
				NurfedFramesPanelEditorfont2:GetNumber(),
				NurfedFramesPanelEditorfont3:GetText(),
			}
		elseif m == "Point" then
			local text4 = NurfedFramesPanelEditorpoint4:GetText()
			local text5 = NurfedFramesPanelEditorpoint5:GetText()
			if not string.find(text4, "[0-9]+") or not string.find(text5, "[0-9]+") then return end
			val = {
				string.upper(NurfedFramesPanelEditorpoint1:GetText()),
				NurfedFramesPanelEditorpoint2:GetText(),
				string.upper(NurfedFramesPanelEditorpoint3:GetText()),
				tonumber(text4),
				tonumber(text5),
			}
		elseif m == "PushedTextOffset" then
			val = {
				NurfedFramesPanelEditorpushedtextoffset1:GetNumber(),
				NurfedFramesPanelEditorpushedtextoffset2:GetNumber(),
			}
		elseif m == "ShadowOffset" then
			local text1 = NurfedFramesPanelEditorshadowoffset1:GetText()
			local text2 = NurfedFramesPanelEditorshadowoffset2:GetText()
			if not string.find(text1, "[0-9]+") or not string.find(text2, "[0-9]+") then return end
			val = {
				tonumber(text1),
				tonumber(text2),
			}
		elseif m == "TexCoord" then
			val = {
				tonumber(NurfedFramesPanelEditortexcoord1:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord2:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord3:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord4:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord5:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord6:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord7:GetText()) or 0,
				tonumber(NurfedFramesPanelEditortexcoord8:GetText()) or 0,
			}
		elseif objtype == "CheckButton" then
			val = NurfedFramesPanelEditorenable:GetChecked()
		elseif objtype == "Slider" then
			val = NurfedFramesPanelEditorslider:GetValue()
		elseif objtype == "EditBox" then
			if NurfedFramesPanelEditoredit:IsNumeric() then
				val = NurfedFramesPanelEditoredit:GetNumber()
			elseif NurfedFramesPanelEditoredit.deci then
				val = NurfedFramesPanelEditoredit:GetText()
				val = tonumber(val) or 0
				val = math.round(val, NurfedFramesPanelEditoredit.deci)
			else
				val = NurfedFramesPanelEditoredit:GetText()
			end
			if val == "" then val = nil end
		elseif objtype == "Button" then
			local id = self:GetID()
			UIDropDownMenu_SetSelectedID(NurfedFramesPanelEditordrop, id)
			val = self:GetText()
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
			saveframe(frame)
		end
	end
end

local colorupdate = function(self)
	local r = NurfedFramesPanelEditorcolorred:GetNumber()/255
	local g = NurfedFramesPanelEditorcolorgreen:GetNumber()/255
	local b = NurfedFramesPanelEditorcolorblue:GetNumber()/255
	local a = NurfedFramesPanelEditorcoloralpha:GetNumber()/100
	if r > 1 then r = 1 NurfedFramesPanelEditorcolorred:SetText(255) end
	if g > 1 then g = 1 NurfedFramesPanelEditorcolorgreen:SetText(255) end
	if b > 1 then b = 1 NurfedFramesPanelEditorcolorblue:SetText(255) end
	if a > 1 then a = 1 NurfedFramesPanelEditorcoloralpha:SetText(100) end
	NurfedFramesPanelEditorcolor:SetColorRGB(r, g, b)
	frameupdate(self)
end

local import = function(self)
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

local delete = function(self)
	local name = NurfedFramesPanelFrames.select
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
		NurfedFramesPanelFrames.select = nil
		NurfedFramesPanelFrames[name] = nil
		popframes()
		Nurfed_ScrollFrames()
		updateeditor()
	end
end

local framedrop = function(self)
	local drop = NurfedFramesPanelEditordropdown
	local info = {}
	local id = self:GetID()
	local parent = self:GetParent()
	drop.displayMode = "MENU"
	drop.initialize = function(self)
		for _, v in ipairs(dropdowns[id]) do
			info = {}
			info.text = v[1]
			info.value = v[2]
			info.func = function(self) parent:SetText(self.value) end
			info.isTitle = nil
			info.notCheckable = 1
			UIDropDownMenu_AddButton(info)
		end
	end
	ToggleDropDownMenu(1, nil, drop, "cursor")
end

local createnew = function(self)
	local parent = self.value
	local method = self:GetText()
	local name = parent:GetName()
	if parent == UIParent then
		name = "Nurfed_"
	end
	NurfedFramesPanelFrames.data = { parent, method, name }
	StaticPopupDialogs["NRF_CREATE"].text = "Create new "..method.."\n|cffff0000"..name.."|r"
	StaticPopup_Show("NRF_CREATE")
end

local framecreate = function(self)
	local creates = {}
	if NurfedFramesPanelFrames.select then
		local frame = getglobal(NurfedFramesPanelFrames.select)
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

	local drop = NurfedFramesPanelEditordropdown
	local info = {}
	drop.displayMode = "MENU"
	drop.initialize = function(self)
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

function Nurfed_ScrollFrames(self)
	if not framelist then popframes() end
	if Nurfed_UnitsLayout then
		NurfedFramesPanelEditorimport:Show()
	end

	local format_row = function(row, num)
		local frame = framelist[num][1]
		local level = framelist[num][2]
		local icon = getglobal(row:GetName().."icon")
		local name = getglobal(row:GetName().."name")
		if getglobal(frame) then
			name:SetText(frame)
			icon:Hide()
			icon:ClearAllPoints()
			icon:SetPoint("LEFT", row, "LEFT", 5 + (10 * level), 0)
			if getglobal(frame).GetChildren then
				icon:Show()
				if NurfedFramesPanelFrames[frame] then
					icon:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
					icon:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
				else
					icon:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
					icon:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
				end
			end

			row.frame = frame
			if NurfedFramesPanelFrames.select == frame then
				row:LockHighlight()
			else
				row:UnlockHighlight()
			end
		end
	end

	local frame = NurfedFramesPanelFramesscroll
	FauxScrollFrame_Update(frame, #framelist, 22, 14)
	for line = 1, 22 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("NurfedFramesPanelFramesRow"..line)
		if offset <= #framelist then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_Frame_OnClick(self, button)
	local frame = self.frame
	if NurfedFramesPanelFrames.select == frame then
		NurfedFramesPanelFrames.select = nil
	else
		NurfedFramesPanelFrames.select = frame
	end
	updateeditor()
	Nurfed_ScrollFrames()
end

function Nurfed_Method_OnClick(self, id)
	if not id then id = self:GetID() end
	UIDropDownMenu_SetSelectedID(NurfedFramesPanelEditormethods, id)
	local name = NurfedFramesPanelFrames.select
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
			NurfedFramesPanelEditorcolor:Show()
			NurfedFramesPanelEditorcolor:SetColorRGB(val[1], val[2], val[3])
			NurfedFramesPanelEditorcolorred:SetText(math.round(255 * val[1]))
			NurfedFramesPanelEditorcolorgreen:SetText(math.round(255 * val[2]))
			NurfedFramesPanelEditorcolorblue:SetText(math.round(255 * val[3]))
			NurfedFramesPanelEditorcoloralpha:SetText(math.round(100 * val[4]))
			NurfedFramesPanelEditorcolor.previousValues = val
		elseif tables[m] then
			m = string.lower(m)
			getglobal("NurfedFramesPanelEditor"..m):Show()
			if val then
				for k, v in pairs(val) do
					if type(v) == "string" then
						local opt = getglobal("NurfedFramesPanelEditor"..m..k)
						local objtype = opt:GetObjectType()
						if objtype == "EditBox" then
							opt:SetText(v)
						elseif objtype == "Frame" then
							UIDropDownMenu_SetSelectedValue(opt, v)
						end
					elseif type(v) == "number" then
						local opt = getglobal("NurfedFramesPanelEditor"..m..k)
						local objtype = opt:GetObjectType()
						if objtype == "EditBox" then
							if opt:IsNumeric() or opt.deci then v = math.round(v, opt.deci) end
							opt:SetText(v)
						elseif objtype == "CheckButton" then
							opt:SetChecked(v)
						end
					elseif type(v) == "table" then
						if v.GetName then
							local opt = getglobal("NurfedFramesPanelEditor"..m..k)
							opt:SetText(v:GetName())
						else
							for i, j in pairs(v) do
								getglobal("NurfedFramesPanelEditor"..m..i):SetText(math.round(j))
							end
						end
					end
				end
			end
		elseif checks[m] then
			NurfedFramesPanelEditorenable:Show()
			NurfedFramesPanelEditorenableText:SetText(m)
			NurfedFramesPanelEditorenable:SetChecked(val)
		elseif sliders[m] then
			if not val then val = 0 end
			NurfedFramesPanelEditorslider:Show()
			NurfedFramesPanelEditorslider.deci = sliders[m][1]
			NurfedFramesPanelEditorsliderLow:SetText(sliders[m][2])
			NurfedFramesPanelEditorsliderHigh:SetText(sliders[m][3])
			NurfedFramesPanelEditorslider:SetMinMaxValues(sliders[m][4], sliders[m][5])
			NurfedFramesPanelEditorslider:SetValueStep(sliders[m][6])
			NurfedFramesPanelEditorslider:SetValue(val)
		elseif edits[m] then
			NurfedFramesPanelEditoredit:Show()
			NurfedFramesPanelEditoredit:SetWidth(edits[m][1])
			NurfedFramesPanelEditoredit:SetNumeric(edits[m][2])
			NurfedFramesPanelEditoredit.deci = edits[m][4]
			if edits[m][2] or edits[m][4] then val = math.round(val, edits[m][4]) end
			NurfedFramesPanelEditoredit:SetJustifyH(edits[m][3])
			NurfedFramesPanelEditoredit:SetText(val or "")
			if m == "StatusBarTexture" then NurfedFramesPanelEditoreditdrop:Show() end
		elseif drops[m] then
			NurfedFramesPanelEditordrop:Show()
			local selected
			UIDropDownMenu_Initialize(NurfedFramesPanelEditordrop, function(self)
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
			UIDropDownMenu_SetSelectedID(NurfedFramesPanelEditordrop, selected)
		end
	end
end


--[[ Frame Editor ]]--
local layout = {
	type = "Frame",
	size = { 250, 300 },
	FrameStrata = "LOW",
	Anchor = { "LEFT", "NurfedFramesPanel", "RIGHT", 0, 0 },
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
			OnShow = function(self)
				configmain(self) 
			end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditorcolorgreen:SetFocus() end,
					OnTextChanged = function(self) if self.focus then colorupdate() end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditorcolorblue:SetFocus() end,
					OnTextChanged = function(self) if self.focus then colorupdate() end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditorcoloralpha:SetFocus() end,
					OnTextChanged = function(self) if self.focus then colorupdate() end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				alpha = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOP", "$parentblue", "BOTTOM", 0, -9 },
					JustifyH = "CENTER",
					BackdropColor = { 1, 1, 1, 0.25 },
					Numeric = true,
					MaxLetters = 3,
					OnTabPressed = function(self) NurfedFramesPanelEditorcolorred:SetFocus() end,
					OnTextChanged = function(self) if self.focus then colorupdate() end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
			},
			OnColorSelect = function(self)
						NurfedFramesPanelEditorcolorred:SetText(math.round(255 * arg1))
						NurfedFramesPanelEditorcolorgreen:SetText(math.round(255 * arg2))
						NurfedFramesPanelEditorcolorblue:SetText(math.round(255 * arg3))
						frameupdate(self, nil, true)
					end,
			OnMouseUp = function(self) frameupdate(self) end,
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
							OnClick = function(self) framedrop(self) end,
						},
					},
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdropedgeFile:SetFocus() end,
					OnTextChanged = function(self) frameupdate(self) end,
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
							OnClick = function(self) framedrop(self) end,
						},
					},
					Anchor = { "TOP", "$parentbgFile", "BOTTOM", 0, -9 },
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdroptileSize:SetFocus() end,
					OnTextChanged = function(self) frameupdate(self) end,
				},
				tile = {
					type = "CheckButton",
					size = { 20, 20 },
					uitemp = "UICheckButtonTemplate",
					Anchor = { "TOPLEFT", "$parentedgeFile", "BOTTOMLEFT", 0, -9 },
					OnClick = function(self) frameupdate(self) end,
				},
				tileSize = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parenttile", "RIGHT", 40, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdropedgeSize:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				edgeSize = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parenttileSize", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdropleft:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				left = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOPLEFT", "$parenttile", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdropright:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				right = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parentleft", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdroptop:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				top = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parentright", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdropbottom:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				bottom = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parenttop", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorbackdropbgFile:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditorfont2:SetFocus() end,
					OnTextChanged = function(self) frameupdate(self) end,
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorfont3:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				["3"] = {
					template = "nrf_editbox",
					size = { 175, 18 },
					Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, -9 },
					OnTabPressed = function(self) NurfedFramesPanelEditorfont1:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
							OnClick = function(self) framedrop(self) end,
						},
					},
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					OnTabPressed = function(self) NurfedFramesPanelEditorpoint2:SetFocus() end,
					OnTextChanged = function(self) frameupdate(self) end,
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 175, 18 },
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, -9 },
					OnTabPressed = function(self) NurfedFramesPanelEditorpoint3:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
							OnClick = function(self) framedrop(self) end,
						},
					},
					Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, -9 },
					OnTabPressed = function(self) NurfedFramesPanelEditorpoint4:SetFocus() end,
					OnTextChanged = function(self) frameupdate(self) end,
				},
				["4"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "TOPLEFT", "$parent3", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditorpoint5:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 0 },
				},
				["5"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent4", "RIGHT", 15, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditorpoint1:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditorpushedtextoffset2:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 30, 18 },
					Anchor = { "LEFT", "$parent1", "RIGHT", 15, 0 },
					JustifyH = "CENTER",
					Numeric = true,
					MaxLetters = 2,
					OnTabPressed = function(self) NurfedFramesPanelEditorpushedtextoffset1:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditorshadowoffset2:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 0 },
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 40, 18 },
					Anchor = { "LEFT", "$parent1", "RIGHT", 15, 0 },
					JustifyH = "CENTER",
					MaxLetters = 3,
					OnTabPressed = function(self) NurfedFramesPanelEditorshadowoffset1:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord2:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["2"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent1", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord3:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["3"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent2", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord4:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["4"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent3", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord5:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["5"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, -9 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord6:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["6"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent5", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord7:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["7"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent6", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord8:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
					vars = { deci = 3 },
				},
				["8"] = {
					template = "nrf_editbox",
					size = { 45, 18 },
					Anchor = { "LEFT", "$parent7", "RIGHT", 9, 0 },
					JustifyH = "CENTER",
					MaxLetters = 5,
					OnTabPressed = function(self) NurfedFramesPanelEditortexcoord1:SetFocus() end,
					OnTextChanged = function(self) if self.focus then frameupdate(self) end end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
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
			OnClick = function(self) frameupdate(self) end,
			Hide = true,
		},
		slider = {
			type = "Slider",
			uitemp = "OptionsSliderTemplate",
			Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 20, -72 },
			children = {
				value = {
					template = "nrf_editbox",
					FontObject = "GameFontNormalSmall",
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
						local value = tonumber(self:GetText())
						local min, max = self:GetParent():GetMinMaxValues()
						if not value or value < min then return end
						if value > max then value = max end
						self:GetParent():SetValue(value)
						if self.focus then frameupdate(self:GetParent()) end
					end,
					OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
					OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				},
			},
			OnShow = function(self) self:SetFrameLevel(30); self:EnableMouseWheel(true); end,
			OnMouseUp = function(self) 
				local editbox = _G[self:GetName().."value"]
				editbox:SetCursorPosition(0)
				editbox:ClearFocus()
				frameupdate(self) 
			end,
			OnValueChanged = function(self) Nurfed_Options_sliderOnValueChanged(self) end,
			OnMouseWheel = function(self, change)
				local value = self:GetValue()
				if change > 0  then
					value = value + (IsShiftKeyDown() and 0.01 or .10)
				else
					value = value - (IsShiftKeyDown() and 0.01 or .10)
				end
				self:SetValue(value)
				frameupdate(self)
			end,
			OnEnter = function(self)
				GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT", 0, -10)
				--GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR", -24, -24)
				GameTooltip:ClearLines()
				GameTooltip:AddLine("Hint:", nil, nil, nil, true)
				GameTooltip:AddLine("Hold SHIFT when you scroll for smaller ranges.", nil, nil, nil, true)
				GameTooltip:Show()
			end,
			OnLeave = function() GameTooltip:Hide() end,
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
					OnClick = function(self) framedrop(self) end,
				},
			},
			Anchor = { "TOPLEFT", "$parentmethods", "BOTTOMLEFT", 20, -8 },
			OnTextChanged = function(self) frameupdate(self) end,
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
			OnClick = function(self) import(self) end,
			Hide = true,
		},
		delete = {
			template = "nrf_button",
			Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 5 },
			Text = DELETE,
			OnClick = function(self)
					StaticPopupDialogs["NRF_DELETE"].text = "Delete "..NurfedFramesPanelFrames.select.."?"
					StaticPopup_Show("NRF_DELETE")
				end,
			Hide = true,
		},
		create = {
			template = "nrf_button",
			Anchor = { "LEFT", "$parentdelete", "RIGHT", 10, 0 },
			Text = CREATE,
			OnClick = function(self) framecreate(self) end,
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

function Nurfed_ExpandFrame(self)
	local frame = self:GetParent().frame
	if NurfedFramesPanelFrames[frame] then
		NurfedFramesPanelFrames[frame] = nil
	else
		NurfedFramesPanelFrames[frame] = true
	end
	popframes(self)
	Nurfed_ScrollFrames(self)
end

frame = Nurfed:create("NurfedFramesPanelEditor", layout, NurfedFramesPanel)
NurfedFramesPanelEditorheadertitle:SetText("Nurfed Frame Editor")
layout = nil

StaticPopupDialogs["NRF_DELETE"] = {
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	OnAccept = function(self) delete(self) end,
	timeout = 10,
	whileDead = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["NRF_CREATE"] = {
	button1 = TEXT(ACCEPT),
	button2 = TEXT(CANCEL),
	hasEditBox = 1,
	OnAccept = function(self)
		local editBox = getglobal(self:GetParent():GetName().."EditBox")
		local text = editBox:GetText()
		local data = NurfedFramesPanelFrames.data
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
	OnShow = function(self)
		getglobal(self:GetName().."EditBox"):SetFocus()
	end,
	OnHide = function(self)
		NurfedFramesPanelFrames.data = nil
		popframes(self)
		Nurfed_ScrollFrames(self)
		updateeditor(self)
	end,
	EditBoxOnEnterPressed = function(self)
		local editBox = getglobal(self:GetParent():GetName().."EditBox")
		local text = editBox:GetText()
		local data = NurfedFramesPanelFrames.data
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
		self:GetParent():Hide()
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide()
	end,
	timeout = 10,
	whileDead = 1,
	hideOnEscape = 1,
}