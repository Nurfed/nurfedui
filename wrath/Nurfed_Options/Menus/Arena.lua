NURFED_MENUS["Arena"] = {
	template = "nrf_options",
	children = {
		input1 = {
			template = "nrf_editbox",
			Anchor = { "TOPLEFT", 3, -15 },
			vars = { text = "2's Assist", option = "arenaassist2" },
		},
		input2 = {
			template = "nrf_editbox",
			Anchor = { "TOPRIGHT", "$parentinput1", "BOTTOMRIGHT", 0, -15 },
			vars = { text = "3's Assist", option = "arenaassist3" },
		},
		input3 = {
			template = "nrf_editbox",
			Anchor = { "TOPRIGHT", "$parentinput2", "BOTTOMRIGHT", 0, -15 },
			vars = { text = "5's Assist", option = "arenaassist5" },
		},

		slider1 = {
			template = "nrf_slider",
			Anchor = { "TOPRIGHT", -23, -15 },
			vars = {
				text = "Frame Scale",
				option = "arenascale",
				low = 0.25,
				high = 3,
				min = 0.25,
				max = 3,
				step = 0.01,
				deci = 2,
				format = "%.2f",
				func = function(val) Nurfed_Arena:SetScale(val) end,
			},
		},
		macro1 = {
			template = "nrf_multiedit",
			size = { 170, 80 },
			Point = { "BOTTOMLEFT", 5, 5 },
			vars = { text = "Left Click", option = "arenamacro1", ltrs = 255 },
		},
		macro2 = {
			template = "nrf_multiedit",
			size = { 170, 80 },
			Point = { "BOTTOMRIGHT", -27, 5 },
			vars = { text = "Right Click", option = "arenamacro2", ltrs = 255 },
		},
	},
}