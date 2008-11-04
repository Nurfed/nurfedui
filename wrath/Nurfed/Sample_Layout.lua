


-- Apoco's Modified Unit Frames (Nurfed Unit Frames v3)
----------------------------------------------------------------------------------------
--	Text Format Vars
--		(HP/MP text and status bars)
--		$miss = Missing hp/mp
--		$cur = current hp/mp
--		$max = Max hp/mp
--		$perc = Percent hp/mp
--
--		(Name/Level text)
--		$name = Name
--		$level = Level
--		$class = Class
--		$guild = Guild
--		$race = Race
--		$rname = PvP Rank Name
--		$rnum = PvP Rank Number
--		$key = Key Binding
--
--	Element Names
--		hp, mp, xp, combo, target
--		name, level, class, race
--		pvp, leader, master, feedback
--		group, status, buff, debuff
--		raidtarget, highlight, pet, portrait
--
--	StatusBar Animations
--		glide
----------------------------------------------------------------------------------------


if (not Nurfed_UnitsLayout) then

	Nurfed_UnitsLayout = {};

	Nurfed_UnitsLayout.Name = "Nurfed Unit Frames v3.0";
	Nurfed_UnitsLayout.Author = "Apoco";

	--Frame Templates
	Nurfed_UnitsLayout.templates = {
		Nurfed_UnitFont = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 10, "NONE" },
			TextColor = { 1, 1, 1 },
			FrameStrata = "HIGH",
		},
		Nurfed_UnitFontLarge = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 16, "OVERLAY" },
			TextColor = { 1, 1, 1 },
			FrameStrata = "HIGH",
			ShadowColor = { 0, 0, 0, 0.99 },
			ShadowOffset = { 0.8, -0.8 },
		},
		Nurfed_UnitFontMed = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 14, "OVERLAY" },
			TextColor = { .99, .99, .75 },
			FrameStrata = "HIGH",
			ShadowColor = { 0, 0, 0, 0.99 },
			ShadowOffset = { 0.8, -0.8 },
		},
		Nurfed_UnitFontSmall = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 12, "OVERLAY" },
			TextColor = { .99, .99, .75 },
			FrameStrata = "HIGH",
			ShadowColor = { 0, 0, 0, 0.99 },
			ShadowOffset = { 0.8, -0.8 },
		},
		Nurfed_UnitFontMedWhite = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 14, "OVERLAY" },
			TextColor = { 1, 1, 1 },
			FrameStrata = "HIGH",
			ShadowColor = { 0, 0, 0, 0.99 },
			ShadowOffset = { 0.8, -0.8 },
		},
		Nurfed_UnitFontOutline = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 10, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitFontOutlineLarge = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 12, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitFontSmall = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 8, "NONE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitFontSmallOutline = {
			type = "Font",
			Font = { "Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 8, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_CountFontOutline = {
			type = "Font",
			Font = { "Fonts\\ARIALN.TTF", 12, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_Unit_hp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			FrameLevel = 2,
			StatusBarTexture = NRF_IMG.."HalH",
			Backdrop = {
				bgFile = NRF_IMG.."HalH",
				tile = false,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0.27843075990677, 0.39999911189079, 0.23529359698296, 1 },
			vars = { ani = "glide" },
		},
		Nurfed_Unit_hptar = {
			type = "StatusBar",
			FrameStrata = "LOW",
			FrameLevel = 2,
			StatusBarTexture = NRF_IMG.."HalH",
			Backdrop = {
				bgFile = NRF_IMG.."HalH",
				tile = false,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0.235, 0.266, 0.401, .99 },
			children = {
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontLarge",
					JustifyH = "RIGHT",
					Anchor = { "RIGHT", -2, 0 },
					vars = { format = "$cur/$max | $perc" },
				},
			},
			vars = { ani = "glide" },
		},
		Nurfed_Unit_hppet = {
			type = "StatusBar",
			FrameStrata = "LOW",
			FrameLevel = 2,
			StatusBarTexture = NRF_IMG.."HalH",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."HalH",
					--VertexColor = { 0.235, 0.266, 0.799, 1 },
					VertexColor = { 54/255, 66/255, 149/255, 0.50 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "RIGHT",
					Anchor = { "RIGHT", -2, 0 },
					vars = { format = "$perc" },
				},
			},
			vars = { ani = "glide" },
		},
		Nurfed_Unit_mp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			FrameLevel = 2,
			StatusBarTexture = NRF_IMG.."HalH",
			Backdrop = {
				bgFile = NRF_IMG.."HalH",
				tile = false,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0.25882294774055, 0.32548949122429, 0.3921560049057, 1 },
			vars = { ani = "glide" },
		},

		Nurfed_Unit_mppet = {
			type = "StatusBar",
			FrameStrata = "LOW",
			FrameLevel = 2,
			StatusBarTexture = NRF_IMG.."HalH",
			Backdrop = {
				bgFile = NRF_IMG.."HalH",
				tile = false,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0.235, 0.266, 0.401, .99 },
			vars = { ani = "glide" },
		},
		Nurfed_Unit_xp = {
			type = "StatusBar",
			StatusBarTexture = NRF_IMG.."HalH",
			children = {
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur/$max ($rest)" },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "RIGHT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$perc" },
				}
			},
			vars = { ani = "glide" },
		},
		Nurfed_Unit_pcasting = {
			type = "StatusBar",
			StatusBarTexture = NRF_IMG.."axstatusbar",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."axstatusbar",
					VertexColor = { 0, 0, 1, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$spell ($rank)" },
				},
				time = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "RIGHT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
				}
			},
			Hide = true,
		},
		Nurfed_Unit_castingtarget = {
			type = "StatusBar",
			StatusBarTexture = NRF_IMG.."HalH",
			children = {
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$spell ($rank)" },
				},
				time = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "RIGHT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
				}
			},
			Hide = true,
		},
		Nurfed_Unit_casting = {
			type = "Frame",
			size = { 15, 59 },
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
			BackdropColor = { 0, 0, 0, 0 },
			children = {
				casting = {
					type = "StatusBar",
					size = { 10, 44 },
					Orientation = "VERTICAL",
					Anchor = { "TOP", 0, -3 },
					StatusBarTexture = NRF_IMG.."axstatusbar",
					FrameLevel = 2,
					children = {
						text = {
							type = "FontString",
							layer = "ARTWORK",
							size = { 10, 44 },
							JustifyH = "LEFT",
							FontObject = "Nurfed_UnitFontSmall",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = { "TOP" },
							vars = { format = "$spell ($rank)" },
						},
						time = {
							type = "FontString",
							layer = "ARTWORK",
							JustifyH = "LEFT",
							FontObject = "Nurfed_UnitFontSmall",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = { "BOTTOM", "$parent", "TOP", 0, 3 },
						},
						icon = {
							type = "Texture",
							layer = "ARTWORK",
							size = { 10, 10 },
							Anchor = { "TOP", "$parent", "BOTTOM", 0, 0 },
						},
					},
					Hide = true,
				},
			},
			Hide = true,
		},
		Nurfed_Unit_model = {
			type = "PlayerModel",
			size = { 40, 40 },
			FrameStrata = "LOW",
			ModelScale = 1.9,
			FrameLevel = 2,
		},

		Nurfed_Unit_mini = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 80, 22 },
			FrameStrata = "LOW",
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 8,
				insets = { left = 2, right = 2, top = 2, bottom = 2 }
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			children = {
				hp = {
					type = "StatusBar",
					size = { 74, 9 },
					FrameStrata = "LOW",
					Orientation = "HORIZONTAL",
					StatusBarTexture = NRF_IMG.."axstatusbar",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 3, 3 },
					children = {
						bg = {
							type = "Texture",
							layer = "BACKGROUND",
							Texture = NRF_IMG.."axstatusbar",
							VertexColor = { 1, 0, 0, 0.25 },
							Anchor = "all",
						},
						text = {
							type = "FontString",
							layer = "OVERLAY",
							FontObject = "Nurfed_UnitFontSmallOutline",
							JustifyH = "RIGHT",
							TextColor = { 1, 0.25, 0 },
							Anchor = "all",
							vars = { format = "$perc" },
						},
					},
				},
				name = {
					type = "FontString",
					size = { 75, 8 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 3, -2 },
					vars = { format = "$name" },
				},
			},
			Hide = true,
		},
		Nurfed_Unit_target = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 134, 28 },
			FrameStrata = "LOW",
			FrameLevel = 2,
			ClampedToScreen = true,
			Backdrop = {
--				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = false,
				tileSize = 0,
				edgeSize = 0,
			},
			BackdropColor = { 0, 0, 0, 1.0 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hppet",
					size = { 130, 20.5 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 2, -2 },
				},
				mp = {
					template = "Nurfed_Unit_mppet",
					size = { 130, 3 },
					Anchor = { "TOP", "$parenthp", "BOTTOM", 0, -1 },
				},
				name = {
					type = "FontString",
					size = { 123, 10 },
					layer = "ARTWORK",
					FontObject = "Nurfed_UnitFontMed",
					JustifyH = "LEFT",
					Anchor = { "LEFT", "$parenthp", "LEFT", 5, 0 },
					vars = { format = "$name" },
				},
			},
			Hide = true,
		},

		Nurfed_Party = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 0, 0 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }, },
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			Hide = true,
		},
	};
	--Frame Design
	Nurfed_UnitsLayout.Layout = {
		player = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 282, 37 },
			FrameStrata = "LOW",
			FrameLevel = 2,
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = false,
				tileSize = 0,
				edgeSize = 0,
			},
			BackdropColor = { 0, 0, 0, 1 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 280, 26 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, -1 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 280, 8 },
					Anchor = { "TOP", "$parenthp", "BOTTOM", 0, -1 },
				},
				name = {
					type = "FontString",
					size = { 65, 18 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontLarge",
					JustifyH = "RIGHT",
					Anchor = { "RIGHT", "$parenthp", "RIGHT", -2, 0 },
					vars = { format = "$name" },
				},
--[[				status = {
					type = "Texture",
					size = { 20, 20 },
					layer = "OVERLAY",
					Texture = "Interface\\CharacterFrame\\UI-StateIcon",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -15, 10 },
					Hide = true,
				},]]
				castingframebg = {
					type = "Texture",
					size = { 280, 4 },
					layer = "BACKGROUND",
					Texture = NRF_IMG.."HalH",
					VertexColor = { 0, 0, 1, 0.25 },
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},
				castingframe = {
					size = { 280, 4 },
					template = "Nurfed_Unit_castingtarget",
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
					vars = { hideFrame = "xp", },
				},
				mptext = {
					type = "FontString",
					size = { 140, 18 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontMedWhite",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parentcastingframe", "BOTTOMLEFT", 0, 0 },
					vars = { format = "$cur/$max" },
				},
				hptext = {
					type = "FontString",
					size = { 140, 18 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontMedWhite",
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parentcastingframe", "BOTTOMRIGHT", 0, 0 },
					vars = { format = "$cur/$max | $perc" },
				},

				--[[
				leader = {
					type = "Texture",
					size = { 15, 15 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOP", "$parent", "TOP", 0, 10 },
					Hide = true,
				},
				master = {
					type = "Texture",
					size = { 15, 15 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", -5, 10 },
					Hide = true,
				},
				level = {
					type = "FontString",
					size = { 100, 18 },
					layer = "OVERLAY",
					FrameLevel = 3,
					FontObject = "Nurfed_UnitFontMed",
					JustifyH = "LEFT",
					Anchor = { "LEFT", "$parentmp", "LEFT", 4, 0 },
					vars = { format = "$level $class" },
				},
				group = {
					type = "FontString",
					size = { 50, 8 },
					layer = "OVERLAY",
					FrameLevel = 3,
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parentname", "BOTTOMLEFT", 1, 5 },
				},
				xpframebg = {
					type = "Texture",
					size = { 280, 4 },
					layer = "BACKGROUND",
					Texture = NRF_IMG.."HalH",
					VertexColor = { 0, 0, 1, 0.25 },
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},]]
				xp = {
					size = { 280, 4 },
					template = "Nurfed_Unit_xp",
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},
				feedbackheal = {
					type = "ScrollingMessageFrame",
					layer = "OVERLAY",
					size = { 280, 16 },
					FontObject = "Nurfed_UnitFontMed",
					JustifyH = "CENTER",
					InsertMode = "TOP",
					Anchor = { "CENTER", "$parenthp", "CENTER", 0, 0 },
					FadeDuration = 0.3,
					TimeVisible = 0.8,
					vars = { heal = true },
				},
				feedbackdamage = {
					type = "ScrollingMessageFrame",
					layer = "OVERLAY",
					size = { 280, 16 },
					FontObject = "Nurfed_UnitFontMed",
					JustifyH = "CENTER",
					InsertMode = "TOP",
					Anchor = { "CENTER", "$parenthp", "CENTER", 0, 0 },
					FadeDuration = 0.3,
					TimeVisible = 0.8,
					vars = { damage = true },
				},
			},
			vars = { unit = "player", enablePredictedStats = true, },
		},

		target = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 282, 37 },
			FrameStrata = "LOW",
			FrameLevel = 2,
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = false,
				tileSize = 0,
				edgeSize = 0,
			},
			BackdropColor = { 0, 0, 0, 1 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hptar",
					size = { 280, 26 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, -1 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 280, 8 },
					Anchor = { "TOP", "$parenthp", "BOTTOM", 0, -1 },
				},
				castingframebg = {
					type = "Texture",
					size = { 280, 4 },
					layer = "BACKGROUND",
					Texture = NRF_IMG.."HalH",
					VertexColor = { 0, 0, 1, 0.25 },
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},
				castingframe = {
					size = { 280, 4 },
					template = "Nurfed_Unit_castingtarget",
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},
				hptext = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontMedWhite",
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parenthp", "TOPRIGHT", -2, -10 },
					vars = { format = "$miss$cur/$max | $perc" },
				},
				--[[
				threat = {
					type = "StatusBar",
					StatusBarTexture = NRF_IMG.."statusbar5",
					size = { 170, 8 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
					children = {
						bg = {
							type = "Texture",
							layer = "BACKGROUND",
							Texture = NRF_IMG.."statusbar5",
							VertexColor = { 0, 0, 1, 0.25 },
							Anchor = "all",
						},
						text = {
							type = "FontString",
							layer = "OVERLAY",
							FontObject = "Nurfed_UnitFontSmall",
							JustifyH = "CENTER",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = "all",
							vars = { format = "$cur" },
						},
						text2 = {
							type = "FontString",
							layer = "OVERLAY",
							FontObject = "Nurfed_UnitFontSmall",
							JustifyH = "RIGHT",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = "all",
							vars = { format = "$perc" },
						}
					},
					vars = { threatUnit = "player", ani = "glide", },
					Hide = true,
				},
]]
				name = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontMedWhite",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parentcastingframe", "BOTTOMLEFT", 0, 0 },
					vars = { format = "$name $guild $level" },
				},
				--buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 0, 1 } },
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 5, 8 } },
				buff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff1", "RIGHT", 0, 0 } },
				buff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff2", "RIGHT", 0, 0 } },
				buff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff3", "RIGHT", 0, 0 } },
				buff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff4", "RIGHT", 0, 0 } },
				buff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff5", "RIGHT", 0, 0 } },
				buff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff6", "RIGHT", 0, 0 } },
				buff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff7", "RIGHT", 0, 0 } },
				buff9 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff8", "RIGHT", 0, 0 } },
				buff10 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff9", "RIGHT", 0, 0 } },
				buff11 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff10", "RIGHT", 0, 0 } },
				buff12 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff11", "RIGHT", 0, 0 } },
				buff13 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff12", "RIGHT", 0, 0 } },
				buff14 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff13", "RIGHT", 0, 0 } },
				buff15 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff14", "RIGHT", 0, 0 } },
				buff16 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff15", "RIGHT", 0, 0 } },
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentbuff1", "TOPLEFT", 0, 0 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff1", "RIGHT", 0, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff2", "RIGHT", 0, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff3", "RIGHT", 0, 0 } },
				debuff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff4", "RIGHT", 0, 0 } },
				debuff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff5", "RIGHT", 0, 0 } },
				debuff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff6", "RIGHT", 0, 0 } },
				debuff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff7", "RIGHT", 0, 0 } },
				debuff9 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff8", "RIGHT", 0, 0 } },
				debuff10 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff9", "RIGHT", 0, 0 } },
				debuff11 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff10", "RIGHT", 0, 0 } },
				debuff12 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff11", "RIGHT", 0, 0 } },
				debuff13 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff12", "RIGHT", 0, 0 } },
				debuff14 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff13", "RIGHT", 0, 0 } },
				debuff15 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff14", "RIGHT", 0, 0 } },
				debuff16 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff15", "RIGHT", 0, 0 } },
				debuff17 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff16", "RIGHT", 0, 0 } },
				debuff18 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff17", "RIGHT", 0, 0 } },
				debuff19 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff18", "RIGHT", 0, 0 } },
				debuff20 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff19", "RIGHT", 0, 0 } },
				debuff21 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff20", "RIGHT", 0, 0 } },
				debuff22 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff21", "RIGHT", 0, 0 } },
				debuff23 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff22", "RIGHT", 0, 0 } },
				debuff24 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff23", "RIGHT", 0, 0 } },
				rank = {
					type = "Texture",
					size = { 20, 20 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPLEFT", 3, -4 },
				},
				pvp = {
					type = "Texture",
					size = { 35, 35 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 20, 10 },
				},
				combo = {
					type = "FontString",
					layer = "OVERLAY",
					Font = {"Interface\\Addons\\Nurfed\\Fonts\\BigNoodle.ttf", 22, "OUTLINE" },
					TextHeight = 22,
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMLEFT", -2, 0 },
					vars = { unit1 = "player", unit2 = "target", },
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 15, 15 },
					layer = "OVERLAY",
					Anchor = { "BOTTOMRIGHT", "$parent", "TOPRIGHT", -5, 0 },
					Hide = true,
				},
				mptext = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontMedWhite",
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parentcastingframe", "BOTTOMRIGHT", 0, 0 },
					vars = { format = "$cur/$max | $perc" },
				},
			},
			vars = { unit = "target", debuffwidth = 176, buffwidth = 176, enablePredictedStats = true, alphaRange = true, },
		},
		
		targettarget = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 163, 27 },
			FrameStrata = "LOW",
			FrameLevel = 2,
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = false,
				tileSize = 0,
				edgeSize = 0,
			},
			BackdropColor = { 0, 0, 0, .55 },
			Movable = true,
			Mouse = true,
			children = {
				--[[
				hp = {
					template = "Nurfed_Unit_hptar",
					size = { 161, 25 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, -1 },
					children = {
						text = {
							type = "FontString",
							layer = "OVERLAY",
							FontObject = "Nurfed_UnitFontMedWhite",
							JustifyH = "RIGHT",
							Anchor = { "RIGHT", "$parent", "RIGHT", -2, 0 },
							vars = { format = "$perc" },
						},
					},
				},]]
				hp = {
					template = "Nurfed_Unit_hppet",
					size = { 161, 21 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, -1 },
				},
				mp = {
					template = "Nurfed_Unit_mppet",
					size = { 161, 4 },
					Anchor = { "TOPLEFT", "$parenthp", "BOTTOMLEFT", 0, 0 },
				},
				name = {
					type = "FontString",
					size = { 140, 18 },
					layer = "OVERLAY",
					FrameLevel = 3,
					FontObject = "Nurfed_UnitFontMedWhite",
					JustifyH = "MIDDLE",
					Anchor = { "CENTER", "$parenthp", "CENTER", 0, 0 },
					vars = { format = "$name" },
				},
			},
			vars = { unit = "targettarget" },
		},
   		
   		pet = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 160, 14 },
			FrameStrata = "LOW",
			FrameLevel = 2,
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = false,
				tileSize = 0,
				edgeSize = 0,
			},
			BackdropColor = { 0, 0, 0, 1 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hppet",
					size = { 160, 10 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, -1 },
				},
				mp = {
					template = "Nurfed_Unit_mppet",
					size = { 160, 2 },
					Anchor = { "TOPLEFT", "$parenthp", "BOTTOMLEFT", 0, 0 },
				},
				name = {
					type = "FontString",
					size = { 123, 10 },
					layer = "ARTWORK",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "MIDDLE",
					Anchor = { "CENTER", "$parenthp", "CENTER", 0, 0 },
					vars = { format = "$name" },
				},
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parentmp", "BOTTOMLEFT", 0, 0 } },
				buff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff1", "RIGHT", 0, 0 } },
				buff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff2", "RIGHT", 0, 0 } },
				buff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff3", "RIGHT", 0, 0 } },
				buff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff4", "RIGHT", 0, 0 } },
				buff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff5", "RIGHT", 0, 0 } },
				buff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff6", "RIGHT", 0, 0 } },
				buff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff7", "RIGHT", 0, 0 } },
				buff9 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff8", "RIGHT", 0, 0 } },
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parentbuff1", "BOTTOMLEFT", 0, -1 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff1", "RIGHT", 0, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff2", "RIGHT", 0, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff3", "RIGHT", 0, 0 } },
				debuff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff4", "RIGHT", 0, 0 } },
				debuff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff5", "RIGHT", 0, 0 } },
				debuff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff6", "RIGHT", 0, 0 } },
				debuff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff7", "RIGHT", 0, 0 } },
				debuff9 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff8", "RIGHT", 0, 0 } },
			},
			vars = { unit = "pet", debuffwidth = 140, buffwidth = 140, enablePredictedStats = true, },
		},
		focus = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 135, 21 },
			FrameStrata = "LOW",
			FrameLevel = 2,
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = false,
				tileSize = 0,
				edgeSize = 0,
			},
			BackdropColor = { 0, 0, 0, 1 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hppet",
					size = { 133, 16 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, -1 },
				},
				mp = {
					template = "Nurfed_Unit_mppet",
					size = { 133, 3 },
					Anchor = { "TOPLEFT", "$parenthp", "BOTTOMLEFT", 0, 0 },
				},
				name = {
					type = "FontString",
					size = { 123, 16 },
					layer = "ARTWORK",
					FontObject = "Nurfed_UnitFontMed",
					JustifyH = "MIDDLE",
					Anchor = { "BOTTOM", "$parent", "TOP", 0, 0 },
					vars = { format = "$name" },
				},
				castingframebg = {
					type = "Texture",
					size = { 133, 4 },
					layer = "BACKGROUND",
					Texture = NRF_IMG.."HalH",
					VertexColor = { 0, 0, 1, 0.25 },
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},
				castingframe = {
					size = { 133, 4 },
					template = "Nurfed_Unit_castingtarget",
					Anchor = { "TOP", "$parentmp", "BOTTOM", 0, -1 },
				},
			},
			vars = { unit = "focus", alphaRange = true, },
	},

  Nurfed_party1 = { template = "Nurfed_Party", vars = { unit = "party1" } },
  Nurfed_party2 = { template = "Nurfed_Party", vars = { unit = "party2" } },
  Nurfed_party3 = { template = "Nurfed_Party", vars = { unit = "party3" } },
  Nurfed_party4 = { template = "Nurfed_Party", vars = { unit = "party4" } },
};
end	