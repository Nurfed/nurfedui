NURFED_MENUS["Templates"] = {
	template = "nrf_options",
	children = {
		scroll = {
			type = "ScrollFrame",
			size = { 388, 270 },
			Anchor = { "LEFT", "$parent", "LEFT" },
			uitemp = "FauxScrollFrameTemplate",
			OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollTemplates) end,
			OnShow = function() Nurfed_ScrollTemplates() end,
		},
	},
	OnLoad = function() Nurfed_GenerateMenu("Templates", "nrf_frames_row", 19) end,
}

Nurfed:createtemp("nrf_templates_row", {
	type = "Button",
	size = { 400, 14 },
	children = {
		icon = {
			type = "Texture",
			Texture = "Interface\\Buttons\\UI-PlusButton-Up",
			layer = "ARTWORK",
			size = { 14, 14 },
			Anchor = { "LEFT", "$parent", "LEFT", 5, 0 },
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
	OnClick = function() Nurfed_Template_OnClick(arg1) end,
})

local templist

function Nurfed_ScrollTemplates()
	local list = {}
	for k in pairs(NURFED_FRAMES.templates) do
		table.insert(list, k)
		table.sort(list, function(a, b) return a < b end)
	end

	local format_row = function(row, num)
		local na = getglobal(row:GetName().."name")
		local icon = getglobal(row:GetName().."icon")
		icon:Show()
		row.temp = list[num]
		na:SetText(list[num])
		if Nurfed_MenuTemplates.temp == list[num] then
			row:LockHighlight()
			icon:SetTexture("Interface\\Buttons\\UI-MinusButton-Up")
		else
			row:UnlockHighlight()
			icon:SetTexture("Interface\\Buttons\\UI-PlusButton-Up")
		end
	end

	local frame = Nurfed_MenuTemplatesscroll
	FauxScrollFrame_Update(frame, #list, 19, 14)
	for line = 1, 19 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("Nurfed_TemplatesRow"..line)
		if offset <= #list then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_Template_OnClick(button)
	if button == "LeftButton" and this.temp then
		local temp = this.temp
		if Nurfed_MenuTemplates.temp == temp then
			Nurfed_MenuTemplates.temp = nil
		else
			Nurfed_MenuTemplates.temp = temp
		end
		Nurfed_ScrollTemplates()
	elseif button == "RightButton" and this.ranks then
		local dropdown = getglobal(this:GetName().."dropdown")
		local info = {}
		local spell = this.spell
		dropdown.displayMode = "MENU"
		dropdown.initialize = function ()
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

			for i = 1, this.ranks do
				info = {}
				info.text = "("..RANK.." "..i..")"
				info.func = function() Nurfed_Binding_Dropdown(spell, i) end
				info.isTitle = nil
				info.notCheckable = 1
				UIDropDownMenu_AddButton(info)
			end
		end
		ToggleDropDownMenu(1, nil, dropdown, "cursor")
	end
end