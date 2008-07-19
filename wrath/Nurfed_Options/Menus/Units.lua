local hptype = { "class", "fade", "script" }
local auras = { "all", "curable", "yours" }

local setmana = function()
	for i = 0, 4 do
		local color = Nurfed:getopt(ManaBarColor[i].prefix)
		ManaBarColor[i].r = color[1]
		ManaBarColor[i].g = color[2]
		ManaBarColor[i].b = color[3]
	end

	Nurfed_UnitColors()
end

local sethp = function()
	Nurfed:sethpfunc()
	Nurfed_UnitColors()
end

NURFED_MENUS["Units"] = {
	template = "nrf_options",
	children = {
		swatch1 = {
			template = "nrf_color",
			Point = { "TOPLEFT", 5, -7 },
			vars = { text = MANA, option = MANA, func = setmana },
		},
		swatch2 = {
			template = "nrf_color",
			Point = { "TOPLEFT", "$parentswatch1", "BOTTOMLEFT", 0, -7 },
			vars = { text = RAGE_POINTS, option = RAGE_POINTS, func = setmana },
		},
		swatch3 = {
			template = "nrf_color",
			Point = { "TOPLEFT", "$parentswatch2", "BOTTOMLEFT", 0, -7 },
			vars = { text = FOCUS_POINTS, option = FOCUS_POINTS, func = setmana },
		},
		swatch4 = {
			template = "nrf_color",
			Point = { "LEFT", "$parentswatch1", "RIGHT", 70, 0 },
			vars = { text = ENERGY_POINTS, option = ENERGY_POINTS, func = setmana },
		},
		swatch5 = {
			template = "nrf_color",
			Point = { "TOPRIGHT", "$parentswatch4", "BOTTOMRIGHT", 0, -7 },
			vars = { text = HAPPINESS_POINTS, option = HAPPINESS_POINTS, func = setmana },
		},
		button1 = {
			template = "nrf_optbutton",
			Anchor = { "TOPLEFT", "$parentswatch3", "BOTTOMLEFT", 70, -5 },
			OnClick = function() Nurfed_DropMenu(hptype) end,
			vars = { text = "HP Color", option = "hpcolor", func = sethp },
		},
		hpscript = {
			template = "nrf_multiedit",
			size = { 280, 160 },
			Point = { "TOPLEFT", "$parentbutton1", "BOTTOMLEFT", -70, -7 },
			vars = { option = "hpscript", func = sethp },
		},
	},
}