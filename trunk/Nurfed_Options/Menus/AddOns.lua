NURFED_MENUS["AddOns"] = {
	template = "nrf_options",
	children = {
		scroll = {
			type = "ScrollFrame",
			size = { 388, 270 },
			Anchor = { "LEFT", "$parent", "LEFT" },
			uitemp = "FauxScrollFrameTemplate",
			OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollAddOns) end,
			OnShow = function() Nurfed_ScrollAddOns() end,
		},
	},
	OnLoad = function() Nurfed_GenerateMenu("AddOns", "nrf_addons_row", 19) end,
}

Nurfed:createtemp("nrf_addons_row", {
	type = "Frame",
	size = { 400, 14 },
	children = {
		check = {
			type = "CheckButton",
			size = { 16, 16 },
			uitemp = "UICheckButtonTemplate",
			Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 2, 0 },
			OnClick = function() Nurfed_ToggleAddOn() end,
		},
		name = {
			type = "FontString",
			layer = "ARTWORK",
			size = { 190, 14 },
			Anchor = { "LEFT", "$parentcheck", "RIGHT", 5, 0 },
			FontObject = "GameFontNormal",
			JustifyH = "LEFT",
			TextColor = { 1, 1, 1 },
		},
		loaded = {
			type = "FontString",
			layer = "ARTWORK",
			size = { 105, 14 },
			Anchor = { "LEFT", "$parentname", "RIGHT", 5, 0 },
			FontObject = "GameFontNormal",
			JustifyH = "LEFT",
			TextColor = { 1, 1, 1 },
		},
		reload = {
			type = "FontString",
			layer = "ARTWORK",
			size = { 100, 14 },
			Anchor = { "LEFT", "$parentloaded", "RIGHT", 5, 0 },
			FontObject = "GameFontNormal",
			JustifyH = "LEFT",
			TextColor = { 1, 0, 0 },
		},
	},
})

function Nurfed_ToggleAddOn()
	if (this:GetChecked()) then
		EnableAddOn(this:GetID())
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		DisableAddOn(this:GetID())
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
	local reload = getglobal(this:GetParent():GetName().."reload")
	reload:SetText("(Reload UI)")
end

function Nurfed_ScrollAddOns()
	local format_row = function(row, num)
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(num)
		local loaded = IsAddOnLoaded(num)
		local check = getglobal(row.."check")
		local na = getglobal(row.."name")
		local load = getglobal(row.."loaded")

		na:SetText(title or name)
		if enabled then
			na:SetTextColor(1, 1, 1)
		else
			na:SetTextColor(0.5, 0.5, 0.5)
		end

		if name == "Nurfed_Options" then
			check:Hide()
		else
			check:Show()
			check:SetChecked(enabled)
			check:SetID(num)
		end
		if loaded then
			load:SetText("Loaded")
			load:SetTextColor(1, 1, 1)
		elseif loadable then
			load:SetText("On Demand")
			load:SetTextColor(1, 1, 1)
		else
			local y = getglobal("ADDON_"..reason)
			load:SetText(y)
			load:SetTextColor(0.5, 0.5, 0.5)
		end
	end

	local count = GetNumAddOns()
	FauxScrollFrame_Update(this, count, 19, 14)
	for line = 1, 19 do
		local offset = line + FauxScrollFrame_GetOffset(this)
		local row = getglobal("Nurfed_AddOnsRow"..line)
		if offset <= count then
			format_row("Nurfed_AddOnsRow"..line, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end