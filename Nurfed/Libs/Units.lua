------------------------------------------
--		Nurfed Units Library
------------------------------------------

--locals
local units, tots
local partyframes = {}
local _G = getfenv(0)
local pairs = pairs
local ipairs = ipairs
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitMana = UnitMana
local UnitManaMax = UnitManaMax
local UnitDebuff = UnitDebuff
local UnitBuff = UnitBuff
local ghost = "Ghost"

if GetLocale()=="deDE" then
	ghost = "Geist"
elseif GetLocale()=="frFR" then
	ghost = "Fantôme"
elseif GetLocale()=="koKR" then
	ghost = "유령"
elseif GetLocale()=="zhCN" then
	ghost = "鬼"
elseif GetLocale()=="zhTW" then
	ghost = "鬼"
elseif GetLocale()=="esES" then
	ghost = "Fantasma"
end

local combatlog = {
	player = {},
	party1 = {},
	party2 = {},
	party3 = {},
	party4 = {},
}

-- Default Options
NURFED_FRAMES = NURFED_FRAMES or {
	templates = {
		Nurfed_UnitFont = {
			type = "Font",
			Font = { NRF_FONT.."framd.ttf", 10, "NONE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitFontOutline = {
			type = "Font",
			Font = { NRF_FONT.."framd.ttf", 10, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitFontSmall = {
			type = "Font",
			Font = { NRF_FONT.."framd.ttf", 8, "NONE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitFontSmallOutline = {
			type = "Font",
			Font = { NRF_FONT.."framd.ttf", 8, "OUTLINE" },
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
			StatusBarTexture = NRF_IMG.."statusbar5",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."statusbar5",
					VertexColor = { 1, 0, 0, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur ($max)" },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontOutline",
					JustifyH = "RIGHT",
					TextColor = { 1, 0.25, 0 },
					Anchor = "all",
					vars = { format = "$miss" },
				},
			},
			vars = { ani = "glide" },
		},

		Nurfed_Unit_mp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			StatusBarTexture = NRF_IMG.."statusbar5",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."statusbar5",
					VertexColor = { 0, 1, 1, 0.25 },
					Anchor = "all"
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur ($max)" },
				},
			},
			vars = { ani = "glide" },
		},

		Nurfed_Unit_xp = {
			type = "StatusBar",
			StatusBarTexture = NRF_IMG.."statusbar5",
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
					vars = { format = "$cur/$max$rest" },
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
					StatusBarTexture = NRF_IMG.."statusbar5",
					FrameLevel = 1,
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
			FrameLevel = 1,
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
					StatusBarTexture = NRF_IMG.."statusbar5",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 3, 3 },
					children = {
						bg = {
							type = "Texture",
							layer = "BACKGROUND",
							Texture = NRF_IMG.."statusbar5",
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

		Nurfed_Party = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 180, 41 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }, },
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 147, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 14 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 147, 8 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "RIGHT", "$parent", "LEFT" },
				},
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 4, 2 } },
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
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", -3, -2 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff1", "RIGHT", 1, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff2", "RIGHT", 1, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff3", "RIGHT", 1, 0 } },
				classicon = {
					type = "Texture",
					size = { 23, 23 },
					layer = "OVERLAY",
					Texture = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -4 },
				},
				highlight = {
					type = "Texture",
					size = { 130, 12 },
					layer = "ARTWORK",
					Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
					BlendMode = "ADD",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, -4 },
					Hide = true,
				},
				leader = {
					type = "Texture",
					size = { 12, 13 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -25 },
				},
				master = {
					type = "Texture",
					size = { 11, 11 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 16, -26 },
				},
				pvp = {
					type = "Texture",
					size = { 20, 20 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 4, -4 },
				},
				name = {
					type = "FontString",
					size = { 140, 10 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 28, -4 },
					vars = { format = "[$key] $name" },
				},
				hpperc = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontOutline",
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -15, -5 },
					vars = { format = "$perc" },
				},
				pet = {
					template = "Nurfed_Unit_mini",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMRIGHT", -4, 2 },
				},
			},
			vars = { aurawidth = 176 },
		},
	},
	frames = {
		Nurfed_player = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 180, 59 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 5, right = 5, top = 5, bottom = 5 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 130, 13 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 25 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 130, 10 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 14 },
				},
				xp = {
					template = "Nurfed_Unit_xp",
					size = { 170, 8 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "RIGHT", "$parent", "LEFT" },
				},
				model = {
					template = "Nurfed_Unit_model",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 13 },
				},
				rank = {
					type = "Texture",
					size = { 17, 17 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -23, -4 },
					Hide = true,
				},
				status = {
					type = "Texture",
					size = { 20, 20 },
					layer = "OVERLAY",
					Texture = "Interface\\CharacterFrame\\UI-StateIcon",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -39, -3 },
					Hide = true,
				},
				pvp = {
					type = "Texture",
					size = { 28, 28 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 5, -4 },
					Hide = true,
				},
				leader = {
					type = "Texture",
					size = { 10, 10 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOP", "$parent", "TOP", 28, -4 },
					Hide = true,
				},
				master = {
					type = "Texture",
					size = { 9, 9 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOP", "$parent", "TOP", 28, -12 },
					Hide = true,
				},
				name = {
					type = "FontString",
					size = { 65, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 45, -4 },
					vars = { format = "$name" },
				},
				level = {
					type = "FontString",
					size = { 20, 10 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "RIGHT",
					Anchor = { "TOP", "$parent", "TOP", 10, -5 },
					vars = { format = "$level" },
				},
				group = {
					type = "FontString",
					size = { 50, 8 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 45, -13 },
				},
				feedbackheal = {
					type = "MessageFrame",
					layer = "OVERLAY",
					size = { 110, 11 },
					FontObject = "Nurfed_UnitFontOutline",
					JustifyH = "LEFT",
					InsertMode = "BOTTOM",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 13 },
					FadeDuration = 0.5,
					TimeVisible = 1,
					vars = { heal = true },
				},
				feedbackdamage = {
					type = "MessageFrame",
					layer = "OVERLAY",
					size = { 110, 11 },
					FontObject = "Nurfed_UnitFontOutline",
					JustifyH = "LEFT",
					InsertMode = "TOP",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -5 },
					FadeDuration = 0.5,
					TimeVisible = 1,
					vars = { damage = true },
				},
			},
			vars = { unit = "player" },
		},

		Nurfed_target = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 180, 50 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 5, right = 5, top = 5, bottom = 5 },
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 130, 13 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 15 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 130, 10 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 5 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "RIGHT", "$parent", "LEFT" },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 40, 40 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -4, 5 },
				},
				target = { template = "Nurfed_Unit_mini", Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", -4, -3 } },
				targettarget = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMRIGHT", -4, 3 } },
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 4, 2 } },
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
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parentbuff1", "BOTTOMLEFT", 0, -1 } },
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
				rank = {
					type = "Texture",
					size = { 20, 20 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPLEFT", 3, -4 },
				},
				pvp = {
					type = "Texture",
					size = { 29, 29 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -35, -4 },
				},
				name = {
					type = "FontString",
					size = { 110, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -4 },
					vars = { format = "$name $guild" },
				},
				level = {
					type = "FontString",
					size = { 90, 8 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -13 },
					vars = { format = "$level $class" },
				},
				hpperc = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					Font = {NRF_FONT.."framd.ttf", 9, "NONE" },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -63, -12 },
					vars = { format = "$perc" },
				},
				combo = {
					type = "FontString",
					layer = "OVERLAY",
					Font = {NRF_FONT.."framd.ttf", 22, "OUTLINE" },
					TextHeight = 22,
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMLEFT", 2, 3 },
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 15, 15 },
					layer = "OVERLAY",
					Anchor = { "BOTTOMRIGHT", "$parent", "TOPRIGHT", -5, 0 },
					Hide = true,
				},
			},
			vars = { unit = "target", aurawidth = 176, aurasize = 17 },
		},
		Nurfed_pet = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 160, 43 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }, },
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 150, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 14 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 150, 8 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				name = {
					type = "FontString",
					size = { 123, 10 },
					layer = "ARTWORK",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -4 },
					vars = { format = "[$level] $name" },
				},
				hpperc = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."framd.ttf", 9, "OUTLINE" },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, -5 },
					vars = { format = "$perc" },
				},
				happiness = {
					type = "Texture",
					Texture = "Interface\\PetPaperDollFrame\\UI-PetHappiness",
					size = { 14, 14 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -40, -4 },
					Hide = true,
				},
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 4, 2 } },
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
			vars = { unit = "pet", aurawidth = 160 },
		},
		Nurfed_focus = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 160, 43 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }, },
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 150, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 14 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 150, 8 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "RIGHT", "$parent", "LEFT" },
				},
				name = {
					type = "FontString",
					size = { 123, 10 },
					layer = "ARTWORK",
					FontObject = "Nurfed_UnitFont",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -4 },
					vars = { format = "[$level] $name" },
				},
				hpperc = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."framd.ttf", 9, "OUTLINE" },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, -5 },
					vars = { format = "$perc" },
				},
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 4, 2 } },
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
			vars = { unit = "focus", aurawidth = 160 },
		},

		Nurfed_party1 = { template = "Nurfed_Party", vars = { unit = "party1" } },
		Nurfed_party2 = { template = "Nurfed_Party", vars = { unit = "party2" } },
		Nurfed_party3 = { template = "Nurfed_Party", vars = { unit = "party3" } },
		Nurfed_party4 = { template = "Nurfed_Party", vars = { unit = "party4" } },
	},
}

----------------------------------------------------------------
-- Icon coord tables
local race = {
	["HUMAN_MALE"]		= {0, 0.125, 0, 0.25},
	["DWARF_MALE"]		= {0.125, 0.25, 0, 0.25},
	["GNOME_MALE"]		= {0.25, 0.375, 0, 0.25},
	["NIGHTELF_MALE"]	= {0.375, 0.5, 0, 0.25},
	["TAUREN_MALE"]		= {0, 0.125, 0.25, 0.5},
	["SCOURGE_MALE"]	= {0.125, 0.25, 0.25, 0.5},
	["TROLL_MALE"]		= {0.25, 0.375, 0.25, 0.5},
	["ORC_MALE"]		= {0.375, 0.5, 0.25, 0.5},
	["HUMAN_FEMALE"]	= {0, 0.125, 0.5, 0.75},
	["DWARF_FEMALE"]	= {0.125, 0.25, 0.5, 0.75},
	["GNOME_FEMALE"]	= {0.25, 0.375, 0.5, 0.75},
	["NIGHTELF_FEMALE"]	= {0.375, 0.5, 0.5, 0.75},
	["TAUREN_FEMALE"]	= {0, 0.125, 0.75, 1.0},
	["SCOURGE_FEMALE"]	= {0.125, 0.25, 0.75, 1.0},
	["TROLL_FEMALE"]	= {0.25, 0.375, 0.75, 1.0},
	["ORC_FEMALE"]		= {0.375, 0.5, 0.75, 1.0},
	["BLOODELF_MALE"]	= {0.5, 0.625, 0.25, 0.5},
	["BLOODELF_FEMALE"]	= {0.5, 0.625, 0.75, 1.0},
	["DRAENEI_MALE"]	= {0.5, 0.625, 0, 0.25},
	["DRAENEI_FEMALE"]	= {0.5, 0.625, 0.5, 0.75},
}

local class = {
	["WARRIOR"] = {0, 0.25, 0, 0.25},
	["MAGE"] = {0.25, 0.49609375, 0, 0.25},
	["ROGUE"] = {0.49609375, 0.7421875, 0, 0.25},
	["DRUID"] = {0.7421875, 0.98828125, 0, 0.25},
	["HUNTER"] = {0, 0.25, 0.25, 0.5},
	["SHAMAN"] = {0.25, 0.49609375, 0.25, 0.5},
	["PRIEST"] = {0.49609375, 0.7421875, 0.25, 0.5},
	["WARLOCK"] = {0.7421875, 0.98828125, 0.25, 0.5},
	["PALADIN"] = {0, 0.25, 0.5, 0.75},
	["PETS"] = {0, 1, 0, 1},
}

local cure = {
	["Magic"] = {
		["PRIEST"] = true,
		["PALADIN"] = true,
		["WARLOCK"] = true,
	},
	["Curse"] = {
		["DRUID"] = true,
		["MAGE"] = true,
	},
	["Disease"] = {
		["PRIEST"] = true,
		["PALADIN"] = true,
		["SHAMAN"] = true,
	},
	["Poison"] = {
		["DRUID"] = true,
		["SHAMAN"] = true,
		["PALADIN"] = true,
	},
}

local damage = {
	{ (255/255), (255/255), (0/255) },
	{ (255/255), (0/255), (0/255) },
	{ (0/255), (102/255), (0/255) },
	{ (0/255), (102/255), (255/255) },
	{ (202/255), (76/255), (217/255) },
	{ (153/255), (204/255), (255/255) },
}

local classification = {
	["rareelite"] = ITEM_QUALITY3_DESC.."-"..ELITE,
	["rare"] = ITEM_QUALITY3_DESC,
	["elite"] = ELITE,
}

----------------------------------------------------------------
-- Text variable replacements
local replace = {
	["$realm"] = function(t) return select(2, UnitName(this.unit)) or "" end,
	["$faction"] = function(t) return UnitFactionGroup(this.unit) or "" end,
	["$rname"] = function(t) return GetPVPRankInfo(UnitPVPRank(this.unit)) or "" end,
	["$rnum"] = function(t) return select(2, GetPVPRankInfo(UnitPVPRank(this.unit))) or "" end,
	["$race"] = function(t) return UnitRace(this.unit) or "" end,

	["$name"] = function(t)
		local name = UnitName(this.unit)
		local color
		if UnitIsPlayer(this.unit) then
			local _, eclass = UnitClass(this.unit)
			if eclass then
				color = RAID_CLASS_COLORS[eclass].hex
			end
			
		else
			if UnitIsTapped(this.unit) and not UnitIsTappedByPlayer(this.unit) then
				color = "|cff7f7f7f"
			else
				local reaction = UnitReaction(this.unit, "player")
				if reaction then
					color = UnitReactionColor[reaction].hex
				end
			end
		end
		return (color or "|cffffffff")..name.."|r"
	end,


	["$key"] = function(t)
			local id, found = gsub(this.unit, "party([1-4])", "%1")
			if found == 1 then
				local binding = GetBindingText(GetBindingKey("TARGETPARTYMEMBER"..id), "KEY_")
				binding = Nurfed:binding(binding)
				return binding or ""
			end
	end,

	["$level"] = function(t)
			local level = UnitLevel(this.unit)
			local classification = UnitClassification(this.unit)
			local r, g, b
			if level > 0 then
				local color = GetDifficultyColor(level)
				r = color.r
				g = color.g
				b = color.b
			end
			if UnitIsPlusMob(this.unit) then
				level = level.."+"
			elseif level == 0 then
				level = ""
			elseif level < 0 then
				level = "??"
				r, g, b = 1, 0, 0
			end
			if classification == "worldboss" then
				level = BOSS
				r, g, b = 1, 0, 0
			end
			return Nurfed:rgbhex(r, g, b)..level.."|r"
	end,

	["$class"] = function(t)
			local class, eclass = UnitClass(this.unit)
			if UnitIsPlayer(this.unit) then
				if RAID_CLASS_COLORS[eclass] then
					local color = RAID_CLASS_COLORS[eclass].hex
					class = color..class.."|r"
				end
			else
				local unitclass = UnitClassification(this.unit)
				if UnitCreatureType(this.unit) == "Humanoid" and UnitIsFriend("player", this.unit) then
					class = "NPC"
				elseif UnitCreatureType(this.unit) == "Beast" and UnitCreatureFamily(this.unit) then
					class = UnitCreatureFamily(this.unit)
				else
					class = UnitCreatureType(this.unit)
				end
				if classification[unitclass] then
					class = classification[unitclass].." "..class
				end
			end
			return class or ""
	end,

	["$guild"] = function(t)
			local guild = GetGuildInfo(this.unit)
			if guild then
				local pguild = GetGuildInfo("player")
				local color = "|cff00bfff"
				if guild == pguild then
					color = "|cffff00ff"
				end
				guild = color..guild.."|r"
			end
			return guild or ""
	end,

	["$loot"] = function(t)
		if GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0 then
			local loot = UnitLootMethod[GetLootMethod()].text
			local color = ITEM_QUALITY_COLORS[GetLootThreshold()].hex
			return color..loot.."|r"
		end
		return ""
	end,
}

local disable = {
	player = function()
		PlayerFrame:UnregisterAllEvents()
		PlayerFrame:Hide()
	end,
	target = function()
		TargetFrame:UnregisterAllEvents()
		TargetFrame:Hide()
		ComboFrame:UnregisterAllEvents()
		ComboFrame:Hide()
	end,
	party1 = function()
		for i = 1, 4 do
			local party = _G["PartyMemberFrame"..i]
			party:UnregisterAllEvents()
			party:Hide()
		end
		ShowPartyFrame = function() end
	end,
}

local auratip = function()
	if not this:IsVisible() then return end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	local unit = this:GetParent().unit
	if this.isdebuff then
		GameTooltip:SetUnitDebuff(unit, this:GetID(), this.filter)
	else
		GameTooltip:SetUnitBuff(unit, this:GetID(), this.filter)
	end
end

----------------------------------------------------------------
-- StatusBar animations
local glide = function(self, e)
	if self.fade < 1 then
		self.fade = self.fade + e
		if self.fade > 1 then self.fade = 1 end
		local delta = self.endvalue - self.startvalue
		local diff = delta * (self.fade / 1)
		self.startvalue = self.startvalue + diff
		self:SetValue(self.startvalue)
	end
end

-- Based on custom fading hits by Tyrone
local usedBits = {}
local i = 0

local getbit = function()
	local r
	if #usedBits > 0 then
		r = table.remove(usedBits)
	else
		i = i + 1
		r = UIParent:CreateTexture("nrf_fade"..i, "BACKGROUND")
	end
	return r
end

local killbit = function(item)
	table.insert(usedBits, item)
	item:Hide()
	item:SetParent(UIParent)
end

local nrf_fading = function(self, value, flag)
	local lower,upper = self:GetValue(), self.old
	if lower<upper then
		local min,max = self:GetMinMaxValues()
		if self.old > max then self.old = lower return end
		local chunk = getbit()
		chunk:SetTexture(self.texture)
		chunk:SetParent(self)
		local size=self:GetWidth()
		chunk:SetPoint("TOP", self,0,0)
		chunk:SetPoint("BOTTOM", self,0,0)
		chunk:SetPoint("RIGHT",self,(size *-(max-upper)/max),0)
		chunk:SetPoint("LEFT",self, "RIGHT",(size *-(max-lower)/max),0)
		chunk:Show()
		local fadeinfo = {}
		fadeinfo.timeToFade = 1.5
		fadeinfo.mode = "OUT"
		fadeinfo.finishedFunc = killbit
		fadeinfo.finishedArg1 = chunk
		UIFrameFade(chunk, fadeinfo)
	end
	self.old = lower
end

local fade = function(frame)
	local texture = frame:GetStatusBarTexture()
	local name = texture:GetTexture()
	frame.texture = name
	frame.old = 0
	hooksecurefunc(frame, "SetValue", nrf_fading)
end

local addcombat = function()
	local text = date("[%#I:%M:%S]")
	local unit = arg1
	local event = arg2
	local flags = arg3
	local amount = arg4
	local dtype = arg5
	local color = Nurfed:rgbhex(1, 0.647, 0)

	if event == "HEAL" then
		text = text.." |cff00ff00+"..amount.."|r"
	elseif event == "WOUND" then
		if amount ~= 0 then
			if dtype == 0 then
				color = "|cffff0000"
			else
				color = Nurfed:rgbhex(unpack(damage[dtype]))
			end
			text = text.." "..color.."-"..amount.."|r"
		elseif CombatFeedbackText[flags] then
			text = text.." "..color..CombatFeedbackText[flags].."|r"
		else
			text = text.." "..color..CombatFeedbackText["MISS"].."|r"
		end
	elseif event == "ENERGIZE" then
		color = Nurfed:rgbhex(0.41, 0.8, 0.94)
		text = text.." "..color..amount.."|r"
	elseif CombatFeedbackText[event] then
		text = text.." "..color..CombatFeedbackText[event].."|r"
	end

	if flags == "CRITICAL" then
		text = text.."|cffffff00*|r"
	elseif flags == "CRUSHING" then
		text = text.."|cffffff00^|r"
	elseif flags == "GLANCING" then
		text = text.."|cffffff00-|r"
	end

	table.insert(combatlog[unit], { UnitName(unit), text })
	if #combatlog[unit] > 50 then
		table.remove(combatlog[unit], 1)
	end
end

local updatedamage = function(frame, unit, event, flags, amount, type)
	local text = ""
	local r, g, b = 1, 0.647, 0

	if event == "HEAL" then
		text = "+"..amount
		r, g, b = 0, 1, 0
	elseif event == "WOUND" then
		if amount ~= 0 then
			if type == 0 then
				r, g, b = 1, 0, 0
			else
				r, g, b = unpack(damage[type])
			end
			text = "-"..amount
		elseif flags == "ABSORB" then
			text = CombatFeedbackText["ABSORB"]
		elseif flags == "BLOCK" then
			text = CombatFeedbackText["BLOCK"]
		elseif flags == "RESIST" then
			text = CombatFeedbackText["RESIST"]
		else
			text = CombatFeedbackText["MISS"]
		end
	elseif event == "IMMUNE" then
		text = CombatFeedbackText[event]
	elseif event == "BLOCK" then
		text = CombatFeedbackText[event]
	elseif event == "ENERGIZE" then
		text = amount
		r, g, b = 0.41, 0.8, 0.94
	else
		text = CombatFeedbackText[event]
	end
	if frame.feedback then
		for _, child in ipairs(frame.feedback) do
			if child.heal and event == "HEAL" then
				child:AddMessage(text, r, g, b, 1, 1)
			end
			if child.damage and event ~= "HEAL" then
				child:AddMessage(text, r, g, b, 1, 1)
			end
			if not child.damage and not child.heal then
				child:AddMessage(text, r, g, b, 1, 1)
			end
		end
	end

	if combatlog[unit] then
		local color = Nurfed:rgbhex(r, g, b)
		text = date("[%#I:%M:%S]").." "..color..text.."|r"
		table.insert(combatlog[unit], { UnitName(unit), text })
		if #combatlog[unit] > 50 then
			table.remove(combatlog[unit], 1)
		end
	end
end

----------------------------------------------------------------
-- Casting bar functions
local castevent = function()
	local parent = this.parent
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "PARTY_MEMBERS_CHANGED" or event == "PLAYER_FOCUS_CHANGED" then
		local nameChannel  = UnitChannelInfo(this.unit)
		local nameSpell  = UnitCastingInfo(this.unit)
		if nameChannel then
			event = "UNIT_SPELLCAST_CHANNEL_START"
			arg1 = this.unit
		elseif nameSpell then
			event = "UNIT_SPELLCAST_START"
			arg1 = this.unit
		else
			this:Hide()
			if parent then parent:Hide() end
			return
		end
	end

	if arg1 ~= this.unit then return end

	local barText = _G[this:GetName().."text"]
	local barIcon = _G[this:GetName().."icon"]
	local orient = this:GetOrientation()

	if event == "UNIT_SPELLCAST_START" then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(this.unit)
		if not name then
			this:Hide()
			if parent then parent:Hide() end
			return
		end

		this:SetStatusBarColor(1.0, 0.7, 0.0)
		this.startTime = startTime / 1000
		this.maxValue = endTime / 1000

		this:SetMinMaxValues(this.startTime, this.maxValue)
		this:SetValue(this.startTime)
		this:SetAlpha(1.0)
		this.holdTime = 0
		this.casting = 1
		this.channeling = nil
		this.fadeOut = nil
		this:Show()
		if barText and barText.format then
			local out = barText.format
			out = string.gsub(out, "$spell", name)
			out = string.gsub(out, "$rank", nameSubtext)
			if orient == "VERTICAL" or barText.short then
				local vtext = ""
				out = string.gsub(out, "[^A-Z:0-9.]", "") --fridg
				out = string.gsub(out, "R(%d+)", function(s) return " R"..s end)
				for i = 1, string.len(out) do
					vtext = vtext..string.sub(out, i, i).."\n"
				end
				out = vtext
			end
			barText:SetText(out)
		end
		if barIcon then barIcon:SetTexture(texture) end
		if parent then
			parent:Show()
			parent:SetAlpha(1.0)
		end

	elseif event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" then
		if not this:IsVisible() then this:Hide() end
		if this:IsShown() then
			this:SetValue(this.maxValue)
			if event == "UNIT_SPELLCAST_STOP" then
				this:SetStatusBarColor(0.0, 1.0, 0.0)
				this.casting = nil
			else
				this.channeling = nil
			end
			this.fadeOut = 1
			this.holdTime = 0
		end
	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		if this:IsShown() and not this.channeling then
			this:SetValue(this.maxValue)
			this:SetStatusBarColor(1.0, 0.0, 0.0)
			this.casting = nil
			this.channeling = nil
			this.fadeOut = 1
			this.holdTime = GetTime() + CASTING_BAR_HOLD_TIME
			if barText then
				local text = INTERRUPTED
				if event == "UNIT_SPELLCAST_FAILED" then
					text = FAILED
				end
				if orient == "VERTICAL" then
					local vtext = ""
					for i=1, string.len(text) do
						vtext = vtext..string.sub(text, i, i).."\n"
					end
					text = vtext
				end
				barText:SetText(text)
			end
		end
	elseif event == "UNIT_SPELLCAST_DELAYED" then
		if this:IsShown() then
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(this.unit)
			if not name then
				this:Hide()
				if parent then parent:Hide() end
				return
			end
			this.startTime = startTime / 1000
			this.maxValue = endTime / 1000
			this:SetMinMaxValues(this.startTime, this.maxValue)
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(this.unit)
		if not name then
			this:Hide()
			if parent then parent:Hide() end
			return
		end

		this:SetStatusBarColor(0.0, 1.0, 0.0)
		this.startTime = startTime / 1000
		this.endTime = endTime / 1000
		this.duration = this.endTime - this.startTime
		this.maxValue = this.startTime

		this:SetMinMaxValues(this.startTime, this.endTime)
		this:SetValue(this.endTime)
		this:SetAlpha(1.0)
		this.holdTime = 0
		this.casting = nil
		this.channeling = 1
		this.fadeOut = nil
		this:Show()
		if barText and barText.format then
			local out = barText.format
			out = string.gsub(out, "$spell", name)
			out = string.gsub(out, "$rank", nameSubtext)
			if orient == "VERTICAL" or barText.short then
				local vtext = ""
				out = string.gsub(out, "[^A-Z:0-9.]", "") --fridg
				out = string.gsub(out, "R(%d+)", function(s) return " R"..s end)
				for i = 1, string.len(out) do
					vtext = vtext..string.sub(out, i, i).."\n"
				end
				out = vtext
			end
			barText:SetText(out)
		end
		if barIcon then barIcon:SetTexture(texture) end
		if parent then
			parent:Show()
			parent:SetAlpha(1.0)
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
		if this:IsShown() then
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(this.unit)
			if not name then
				this:Hide()
				if parent then parent:Hide() end
				return
			end
			this.startTime = startTime / 1000
			this.endTime = endTime / 1000
			this.maxValue = this.startTime
			this:SetMinMaxValues(this.startTime, this.endTime)
		end
	end
end

local castupdate = function()
	if this.casting and this:IsShown() then
		local status = GetTime()
		if status > this.maxValue then
			status = this.maxValue
		end
		if status == this.maxValue then
			this:SetValue(this.maxValue)
			this:SetStatusBarColor(0.0, 1.0, 0.0)
			this.casting = nil
			this.flash = 1
			this.fadeOut = 1
			return
		end
		this:SetValue(status)
		local cast = _G[this:GetName().."time"]
		if cast then
			cast:SetText(string.format("(%.1fs)", this.maxValue - status))
		end
	elseif this.channeling then
		local time = GetTime()
		if time > this.endTime then
			time = this.endTime
		end
		if time == this.endTime then
			this:SetStatusBarColor(0.0, 1.0, 0.0)
			this.channeling = nil
			this.flash = 1
			this.fadeOut = 1
			return
		end
		local barValue = this.startTime + (this.endTime - time)
		this:SetValue(barValue)
		local cast = _G[this:GetName().."time"]
		if cast then
			cast:SetText(string.format("(%.1fs)", this.endTime - time))
		end
	elseif GetTime() < this.holdTime then
		return
	elseif this.fadeOut then
		local parent = this.parent
		local alpha = this:GetAlpha() - CASTING_BAR_ALPHA_STEP
		if alpha > 0 then
			this:SetAlpha(alpha)
			if parent then parent:SetAlpha(alpha) end
		else
			this.fadeOut = nil
			this:Hide()
			if parent then parent:Hide() end
		end
	end
end

----------------------------------------------------------------
-- Health, Mana, XP text and colors
local cuttexture = function(texture, size, fill, value)
	if fill == "top" then
		texture:SetHeight(size)
		texture:SetTexCoord(0, 1, value, 1)
	elseif fill == "bottom" then
		texture:SetHeight(size)
		texture:SetTexCoord(0, 1, 1, value)
	elseif fill == "left" then
		texture:SetWidth(size)
		texture:SetTexCoord(value, 1, 0, 1)
	elseif fill == "right" then
		texture:SetWidth(size)
		texture:SetTexCoord(1, value, 0, 1)
	elseif fill == "vertical" then
		texture:SetHeight(size)
		texture:SetTexCoord(0, 1, 0 + (value / 2), 1 - (value / 2))
	elseif fill == "horizontal" then
		texture:SetWidth(size)
		texture:SetTexCoord(0 + (value / 2), 1 - (value / 2), 0, 1)
	end
end

local updateinfo = function(frame, stat)
	if not frame[stat] then return end
	local unit = SecureButton_GetUnit(frame)
	local curr, max, missing, perc, r, g, b = Nurfed:getunitstat(unit, stat)
	local maxtext, missingtext = max, missing
	local rest

	if stat == "XP" then
		local name = GetWatchedFactionInfo()
		if name then
			rest = name
		else
			rest = GetXPExhaustion() or ""
		end
	else
		if max >= 1000000 then
			maxtext = format("%.2fm", max/1000000)
		elseif max >= 100000 then
			maxtext = format("%.1fk", max/1000)
		end

		if missing <= -1000000 then
			missingtext = format("%.2fm", missing/1000000)
		elseif missing <= -100000 then
			missingtext = format("%.1fk", missing/1000)
		end
	end

	for _, child in ipairs(frame[stat]) do
		local objtype = child:GetObjectType()
		if max == 0 then
			child:Hide()
		else
			if not child:IsShown() then
				child:Show()
			end
			if objtype == "StatusBar" then
				child:SetMinMaxValues(0, max)
				if child.ani and child.ani == "glide" then
					child.endvalue = curr
					child.fade = 0.35
				else
					child:SetValue(curr)
				end
				if r and g and b then
					child:SetStatusBarColor(r, g, b)
				end
			elseif objtype == "FontString" then
				local text
				if not UnitIsConnected(unit) and stat == "Health" then
					text = PLAYER_OFFLINE
				elseif UnitIsGhost(unit) and stat == "Health" then
					text = ghost
				elseif (UnitIsDead(unit) or UnitIsCorpse(unit)) and stat == "Health" then
					text = DEAD
				else
					text = child.format
					text = string.gsub(text, "$cur", curr)
					text = string.gsub(text, "$max", maxtext)
					text = string.gsub(text, "$perc", perc.."%%")
					text = string.gsub(text, "$miss", missingtext)
					text = string.gsub(text, "$rest", rest)
				end
				child:SetText(text)
				if r and g and b and child.color then
					child:SetTextColor(r, g, b)
				end
			elseif objtype == "Texture" and child.fill then
				local size = child.bar * (perc / 100)
				local p_h1, p_h2
				if size < 1 then
					size = 1
				end

				if child.fill == "top" or child.fill == "bottom" or child.fill == "vertical" then
					p_h1 = child.bar / child.height
				else
					p_h1 = child.bar / child.width
				end

				p_h2 = 1 - p_h1
				cuttexture(child, size, child.fill, (1 - (perc / 100)) * p_h1 + p_h2)
				if r and g and b then
					child:SetVertexColor(r, g, b)
				end
			end
		end
	end
end

local manacolor = function(frame)
	if not frame.Mana then return end
	local unit = SecureButton_GetUnit(frame)
	local color = ManaBarColor[UnitPowerType(unit)]
	for _, child in ipairs(frame.Mana) do
		local objtype = child:GetObjectType()
		if objtype == "StatusBar" then
			child:SetStatusBarColor(color.r, color.g, color.b)
		elseif objtype == "Texture" then
			child:SetVertexColor(color.r, color.g, color.b)
		elseif objtype == "FontString" then
			if child.color then
				child:SetTextColor(color.r, color.g, color.b)
			end
		end
	end
	updateinfo(frame, "Mana")
end

local updatestatus = function(frame)
	if frame.status then
		local icon = frame.status
		local objtype = icon:GetObjectType()
		local unit = SecureButton_GetUnit(frame)
		if UnitAffectingCombat(unit) then
			if objtype == "Texture" then
				icon:SetTexCoord(0.5, 1.0, 0, 0.5)
			else
				icon:SetText("Combat")
				icon:SetTextColor(1, 0, 0)
			end
			icon:Show()
		elseif IsResting() then
			if objtype == "Texture" then
				icon:SetTexCoord(0, 0.5, 0, 0.5)
			else
				icon:SetText(TUTORIAL_TITLE30)
				icon:SetTextColor(1, 1, 0)
			end
			icon:Show()
		else
			icon:Hide()
		end
	end
end

local updateraid = function(frame)
	if frame.raidtarget then
		local unit = SecureButton_GetUnit(frame)
		local icon = frame.raidtarget
		local index = GetRaidTargetIndex(unit)
		if index then
			SetRaidTargetIconTexture(icon, index)
			icon:Show()
		else
			icon:Hide()
		end
	end
end

----------------------------------------------------------------
-- Text replacement
local subtext = function(text)
	if not text then return end
	local pre = string.find(text, "%$%a")
	string.gsub(text, "%$%a+",
		function (s)
			if replace[s] then
				text = string.gsub(text, s, replace[s])
			end
		end
	)
	if pre == 1 then
		local post = string.find(text, "[%a^%|cff]")
		if post and post > pre then
			text = string.gsub(text, "[^%a]", "", 1)
		end
	end
	return text
end

local formattext = function(frame)
	if frame and frame.format then
		local display = subtext(frame.format)
		frame:SetText(display)
	end
end

local updatetext = function(frame)
	if frame.text then
		for _, v in ipairs(frame.text) do
			formattext(v)
		end
	end
end

local updatehappiness = function(frame)
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
	local hasPetUI, isHunterPet = HasPetUI()
	if happiness or isHunterPet then
		local display
		local text = frame.name
		local icon = frame.happiness
		if text then display = subtext(text.format) end
		if icon then icon:Show() end
		if happiness == 1 then
			if text then text:SetTextColor(1, 0.5, 0) end
			if icon then icon:SetTexCoord(0.375, 0.5625, 0, 0.359375) end
		elseif happiness == 2 then
			if text then text:SetTextColor(1, 1, 0) end
			if icon then icon:SetTexCoord(0.1875, 0.375, 0, 0.359375) end
		elseif happiness == 3 then
			if text then text:SetTextColor(0, 1, 0) end
			if icon then icon:SetTexCoord(0, 0.1875, 0, 0.359375) end
		end
		if text then
			if loyaltyRate < 0 then
				text:SetText("-"..display.."-")
			elseif loyaltyRate > 0 then
				text:SetText("+"..display.."+")
			else
				text:SetText(display)
			end
		end
	end
end

local updatecombo = function(frame)
	if frame.combo then
		local comboPoints = GetComboPoints()
		for _, child in ipairs(frame.combo) do
			if comboPoints > 0 then
				local objtype = child:GetObjectType()
				if objtype == "FontString" then
					child:SetText(comboPoints)
					if comboPoints < 5 then
						child:SetTextColor(1, 1, 0)
					else
						child:SetTextColor(1, 0, 0)
					end
					child:Show()
				elseif objtype == "StatusBar" then
					child:SetMinMaxValues(0, 5)
					child:SetValue(comboPoints)
					child:Show()
				else
					if comboPoints >= child.id then
						child:Show()
					else
						child:Hide()
					end
				end
			else
				child:Hide()
			end
		end
	end
end

local updateleader = function(frame)
	if frame.leader then
		local icon = frame.leader
		local unit = SecureButton_GetUnit(frame)
		local id, found = gsub(unit, "party([1-4])", "%1")
		if unit == "player" then
			if IsPartyLeader() then
				icon:Show()
			else
				icon:Hide()
			end
		elseif found == 1 then
			if GetPartyLeaderIndex() == tonumber(id) then
				icon:Show()
			else
				icon:Hide()
			end
		end
	end
end

local updatemaster = function(frame)
	if frame.master then
		local icon = frame.master
		local unit = SecureButton_GetUnit(frame)
		local id, found = gsub(unit, "party([1-4])", "%1")
		local lootMethod, lootMaster = GetLootMethod()
		if unit == "player" then
			if lootMaster == 0 and ((GetNumPartyMembers() > 0) or (GetNumRaidMembers() > 0)) then
				icon:Show()
			else
				icon:Hide()
			end
		elseif found == 1 then
			if lootMaster == tonumber(id) then
				icon:Show()
			else
				icon:Hide()
			end
		end
	end
end

local updatepvp = function(frame)
	if frame.pvp then
		local unit = SecureButton_GetUnit(frame)
		local icon = frame.pvp
		local objtype = icon:GetObjectType()
		local factionGroup, factionName = UnitFactionGroup(unit)
		if UnitIsPVPFreeForAll(unit) then
			if objtype == "Texture" then
				icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
			else
				icon:SetText(PVP_ENABLED)
			end
			if unit == "player" and not frame.pvpenabled then
				frame.pvpenabled = true
				PlaySound("igPVPUpdate")
			end
			icon:Show()
		elseif factionGroup and UnitIsPVP(unit) then
			if objtype == "Texture" then
				icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup)
			else
				icon:SetText(PVP_ENABLED)
			end
			if unit == "player" and not frame.pvpenabled then
				frame.pvpenabled = true
				PlaySound("igPVPUpdate")
			end
			icon:Show()
		else
			if unit == "player" and frame.pvpenabled then
				frame.pvpenabled = nil
			end
			icon:Hide()
		end
	end
end

local aurafade = function(...)
	local e = select(2, ...)
	this.update = this.update + e
	if this.update > 0.04 then
		local now = GetTime()
		local frame, texture, p
		if now - this.flashtime > 0.3 then
			this.flashdct = this.flashdct * (-1)
			this.flashtime = now
		end

		if this.flashdct == 1 then
			p = (1 - (now - this.flashtime + 0.001) / 0.3 * 0.7)
		else
			p = ( (now - this.flashtime + 0.001) / 0.3 * 0.7 + 0.3)
		end
		this:SetAlpha(p)
		this.update = 0
	end
end

local updateauras = function(frame)
	local unit = SecureButton_GetUnit(frame)
	local button, name, rank, texture, app, dtype, color, total, width, fwidth, scale

	if frame.buff then
		total = 0
		for i = 1, #frame.buff do
			button = _G[frame:GetName().."buff"..i]
			name, rank, texture, app = UnitBuff(unit, i, frame.bfilter)
			if name then
				_G[button:GetName().."Icon"]:SetTexture(texture)
				count = _G[button:GetName().."Count"]
				if app > 1 then
					count:SetText(app)
					count:Show()
				else
					count:Hide()
				end
				button.filter = frame.bfilter
				button:Show()
				total = total + 1
			else
				button:Hide()
			end
		end
		if frame.buffwidth then
			width = button:GetWidth()
			fwidth = total * width
			scale = frame.buffwidth / fwidth
			if scale > 1 then scale = 1 end
			for i = 1, total do
				_G[frame:GetName().."buff"..i]:SetScale(scale)
			end
		end
	end
		
	if frame.debuff then
		frame.cure = nil
		total = 0
		for i = 1, #frame.debuff do
			button = _G[frame:GetName().."debuff"..i]
			local filter = frame.dfilter
			if (unit == "target" or unit == "focus") and not UnitIsFriend("player", unit) then
				filter = nil
			end
			name, rank, texture, app, dtype = UnitDebuff(unit, i, filter)
			if name then
				_G[button:GetName().."Icon"]:SetTexture(texture)
				count = _G[button:GetName().."Count"]
				border = _G[button:GetName().."Border"]
				if app > 1 then
					count:SetText(app)
					count:Show()
				else
					count:Hide()
				end

				if dtype then
					color = DebuffTypeColor[dtype]
				else
					color = DebuffTypeColor["none"]
				end
				border:SetVertexColor(color.r, color.g, color.b)
				button.filter = frame.dfilter
				button:Show()

				local class = select(2, UnitClass("player"))
				if UnitIsFriend("player", unit) and dtype and cure[dtype] and cure[dtype][class] then
					if not button:GetScript("OnUpdate") then
						button.flashtime = GetTime()
						button.update = 0
						button.flashdct = 1
						button:SetScript("OnUpdate", aurafade)
					end
					frame.cure = cure[dtype][class]
				else
					button:SetScript("OnUpdate", nil)
					button:SetAlpha(1)
				end
			else
				button:Hide()
			end
		end
		if frame.debuffwidth then
			width = button:GetWidth()
			fwidth = total * width
			scale = frame.debuffwidth / fwidth
			if scale > 1 then scale = 1 end
			for i = 1, total do
				_G[frame:GetName().."debuff"..i]:SetScale(scale)
			end
		end
	end
end

local updaterank = function(frame)
	if frame.rank then
		local icon = frame.rank
		local unit = SecureButton_GetUnit(frame)
		local rankname, ranknumber = GetPVPRankInfo(UnitPVPRank(unit))
		if ranknumber and ranknumber > 0 then
			local objtype = icon:GetObjectType()
			if objtype == "Texture" then
				if ranknumber > 9 then
					icon:SetTexture("Interface\\PVPRankBadges\\PVPRank"..ranknumber)
				else
					icon:SetTexture("Interface\\PVPRankBadges\\PVPRank0"..ranknumber)
				end
			else
				icon:SetText(ranknumber)
			end
			icon:Show()
		else
			icon:Hide()
		end
	end
end

local updatename = function(frame)
	local unit = SecureButton_GetUnit(frame)
	if frame.name then
		formattext(frame.name)
	end
	if frame.class then
		local info
		local icon = frame.class
		if UnitIsPlayer(unit) or UnitCreatureType(unit) == "Humanoid" then
			local eclass = select(2, UnitClass(unit))
			info = class[eclass]
			icon:SetTexture("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes")
		else
			info = class["PETS"]
			icon:SetTexture("Interface\\RaidFrame\\UI-RaidFrame-Pets")
		end
		if info then
			icon:SetTexCoord(unpack(info))
		end
	end
	if frame.race then
		local icon = frame.race
		local erace = select(2, UnitRace(unit))
		local gender = UnitSex(unit)
		if gender == 1 then
			gender = "MALE"
		else
			gender = "FEMALE"
		end
		local info = race[string.upper(erace).."_"..gender]
		if info then
			icon:SetTexCoord(unpack(info))
		end
	end
end

local updatehighlight = function(frame)
	local unit = SecureButton_GetUnit(frame)
	if UnitExists("target") and UnitName("target") == UnitName(unit) then
		frame:LockHighlight()
	else
		frame:UnlockHighlight()
	end
end

local updategroup = function(frame)
	if frame.group then
		local text = frame.group
		local unit = SecureButton_GetUnit(frame)
		local group = Nurfed:getunit(UnitName(unit))
		if group then
			text:SetText(GROUP..": |cffffff00"..group.."|r")
		else
			text:SetText(nil)
		end
	end
end

local updateloot = function(frame)
	if frame.loot then
		formattext(frame.loot)
	end
end

local showparty = function(self)
	if not InCombatLockdown() then
		local size = Nurfed:getopt("raidsize")
		if not UnitExists(self.unit) or (HIDE_PARTY_INTERFACE == "1" and GetNumRaidMembers() > size) then
			self:Hide()
		else
			self:Show()
		end
		self:SetScript("OnUpdate", nil)
	else
		self:SetScript("OnUpdate", showparty)
	end
end

local updateframe = function(frame, notext)
	local unit = SecureButton_GetUnit(frame)
	if frame.status then updatestatus(frame) end
	if frame.Health then updateinfo(frame, "Health") end
	if frame.XP then updateinfo(frame, "XP") end
	if frame.combo then updatecombo(frame) end
	if frame.Mana then manacolor(frame) end
	if frame.buff or frame.debuff then updateauras(frame) end
	if frame.portrait then SetPortraitTexture(frame.portrait, unit) end
	if frame.pvp then updatepvp(frame) end
	if frame.leader then updateleader(frame) end
	if frame.master then updatemaster(frame) end
	if frame.raidtarget then updateraid(frame) end
	if frame.rank then updaterank(frame) end
	if not notext then
		if frame.text then updatetext(frame) end
		updatename(frame)
	end

	if unit == "pet" then updatehappiness(frame) end
	if frame.GetHighlightTexture and frame:GetHighlightTexture() then
		updatehighlight(frame)
	end
end

local events = {
	["PLAYER_ENTERING_WORLD"] = function(frame) updateframe(frame) end,
	["PLAYER_FOCUS_CHANGED"] = function(frame) updateframe(frame) end,
	["PLAYER_TARGET_CHANGED"] = function(frame) updateframe(frame) end,
	["PLAYER_REGEN_DISABLED"] = function(frame) updatestatus(frame) end,
	["PLAYER_REGEN_ENABLED"] = function(frame) updatestatus(frame) end,
	["PLAYER_UPDATE_RESTING"] = function(frame) updatestatus(frame) end,
	["PLAYER_COMBO_POINTS"] = function(frame) updatecombo(frame) end,
	["PLAYER_XP_UPDATE"] = function(frame) updateinfo(frame, "XP") end,
	["PLAYER_LEVEL_UP"] = function(frame) updateinfo(frame, "XP") end,
	["UPDATE_FACTION"] = function(frame) updateinfo(frame, "XP") end,
	["UPDATE_EXHAUSTION"] = function(frame) updateinfo(frame, "XP") end,
	["PLAYER_GUILD_UPDATE"] = function(frame) formattext(frame.guild) end,
	["RAID_TARGET_UPDATE"] = function(frame) updateraid(frame) end,
	["PARTY_MEMBERS_CHANGED"] = function(frame)
		if frame.isParty then
			updateframe(frame)
		else
			updategroup(frame)
			updateleader(frame)
			updatemaster(frame)
			updateloot(frame)
		end
	end,
	["PARTY_LEADER_CHANGED"] = function(frame)
		updateleader(frame)
		updatemaster(frame)
	end,
	["PARTY_LOOT_METHOD_CHANGED"] = function(frame)
		updatemaster(frame)
		updateloot(frame)
	end,
	["RAID_ROSTER_UPDATE"] = function(frame) updategroup(frame) end,
	["UPDATE_BINDINGS"] = function(frame) formattext(frame.key) end,
	["UNIT_PET_EXPERIENCE"] = function(frame) updateinfo(frame, "XP") end,
	["UNIT_PET"] = function(frame) updateframe(frame) end,
	["UNIT_HEALTH"] = function(frame) updateinfo(frame, "Health") end,
	["UNIT_MAXHEALTH"] = function(frame) updateinfo(frame, "Health") end,
	["UNIT_MANA"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_ENERGY"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_RAGE"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_FOCUS"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_MAXMANA"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_MAXENERGY"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_MAXRAGE"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_MAXFOCUS"] = function(frame) updateinfo(frame, "Mana") end,
	["UNIT_COMBAT"] = function(frame, ...) updatedamage(frame, ...) end,
	["UNIT_AURA"] = function(frame) updateauras(frame) end,
	["UNIT_DISPLAYPOWER"] = function(frame) manacolor(frame) end,
	["UNIT_PORTRAIT_UPDATE"] = function(frame)
		local unit = SecureButton_GetUnit(frame)
		SetPortraitTexture(frame.portrait, unit)
	end,
	["UNIT_FACTION"] = function(frame) updatepvp(frame) end,
	["UNIT_LEVEL"] = function(frame)
		updateinfo(frame, "XP")
		formattext(frame.level)
	end,
	["UNIT_NAME_UPDATE"] = function(frame)
		updatename(frame)
		updatetext(frame)
	end,
	["UNIT_DYNAMIC_FLAGS"] = function(frame) formattext(frame.name) end,
	["UNIT_CLASSIFICATION_CHANGED"] = function(frame) formattext(frame.level) end,
	["UNIT_HAPPINESS"] = function(frame) updatehappiness(frame) end,
}

local onevent = function(event, ...)
	for _, frame in ipairs(units[event]) do
		local unit = SecureButton_GetUnit(frame)
		if UnitExists(unit) then
			this = frame
			if event == "UNIT_PET" then
				if (arg1 == "player" and unit == "pet") or (arg1 == string.gsub(unit, "pet", "")) then
					events[event](frame, ...)
				end
			elseif string.find(event, "^UNIT_") then
				if arg1 == unit then
					events[event](frame, ...)
				end
			else
				events[event](frame, ...)
			end
		end
	end
end

local totupdate = function()
	local unit, notext
	for _, frame in ipairs(tots) do
		unit = SecureButton_GetUnit(frame)
		if UnitExists(unit) then
			notext = true
			if not frame.lastname or frame.lastname ~= UnitName(unit) then
				frame.lastname = UnitName(unit)
				notext = nil
			end
			this = frame
			updateframe(frame, notext)
		else
			frame.lastname = nil
		end
	end
end

function Nurfed:unitimbue(frame)
	local dropdown, menufunc
	local id, found = string.gsub(frame.unit, "party([1-4])", "%1")
	if found == 1 and string.len(frame.unit) > 6 then
		id = nil
		found = nil
	end
	local events = { "PLAYER_ENTERING_WORLD", "UNIT_NAME_UPDATE", }
	local frames = {}
	self:getframes(frame, frames, true)
	if disable[frame.unit] then disable[frame.unit]() end
	frame:RegisterForClicks("AnyUp")
	frame:SetScript("OnEnter", UnitFrame_OnEnter)
	frame:SetScript("OnLeave", UnitFrame_OnLeave)
	if frame:GetParent() == UIParent then
		frame:RegisterForDrag("LeftButton")
		frame:SetMovable(true)
		frame:EnableMouseWheel(true)
		frame:SetScript("OnDragStart", function() if not NRF_LOCKED then this:StartMoving() end end)
		frame:SetScript("OnDragStop", function() NURFED_FRAMES.frames[this:GetName()].Point = { this:GetPoint() } this:StopMovingOrSizing() end)
		frame:SetScript("OnMouseWheel", function()
				if not NRF_LOCKED then
					local scale = this:GetScale()
					if arg1 > 0 and scale < 3 then
						this:SetScale(scale + 0.1)
					elseif arg1 < 0 and scale > 0.25 then
						this:SetScale(scale - 0.1)
					end
					NURFED_FRAMES.frames[this:GetName()].Scale = this:GetScale()
				end
			end)
	end

	if found == 1 then
		frame.isParty = true
		frame:SetID(tonumber(id))
		frame:SetScript("OnAttributeChanged", showparty)
		table.insert(events, "UNIT_COMBAT")
		table.insert(events, "PARTY_MEMBERS_CHANGED")
	elseif frame.unit == "target" then
		table.insert(events, "PLAYER_TARGET_CHANGED")
		table.insert(events, "UNIT_DYNAMIC_FLAGS")
		table.insert(events, "UNIT_CLASSIFICATION_CHANGED")
		frame:SetScript("OnHide", TargetFrame_OnHide)
		frame:SetScript("OnShow", TargetFrame_OnShow)
	elseif frame.unit == "focus" then
		table.insert(events, "PLAYER_FOCUS_CHANGED")
	elseif string.find(frame.unit, "pet", 1, true) then
		if frame.unit == "pet" then
			frame.punit = "player"
		end
		table.insert(events, "UNIT_PET")
	elseif frame.unit == "player" then
		table.insert(events, "UNIT_COMBAT")
	end

	if found == 1 then
		dropdown = _G["PartyMemberFrame"..id.."DropDown"]
	elseif string.find(frame.unit, "^raid") then
		frame.isRaid = true
		FriendsDropDown.initialize = UnitPopup_ShowMenu(_G[UIDROPDOWNMENU_OPEN_MENU], "RAID", this.unit, UnitName(this.unit), this:GetID())
		FriendsDropDown.displayMode = "MENU"
		dropdown = FriendsDropDown
	else
		dropdown = _G[string.gsub(frame.unit, "^%l", string.upper).."FrameDropDown"]
	end
	if dropdown then
		menufunc = function() ToggleDropDownMenu(1, nil, dropdown, "cursor") end
	end

	SecureUnitButton_OnLoad(frame, frame.unit, menufunc)
	if found == 1 then
		table.insert(partyframes, frame)
		RegisterUnitWatch(frame, true)
		if not UnitExists(frame.unit) then
			frame:Hide()
		end
	else
		RegisterUnitWatch(frame)
	end
	ClickCastFrames[frame] = true

	local name = frame:GetName()
	local regstatus = function(pre, child)
		if not frame[pre] then
			frame[pre] = {}
			if pre == "Health" then
				table.insert(events, "UNIT_HEALTH")
				table.insert(events, "UNIT_MAXHEALTH")
			elseif pre == "Mana" then
				table.insert(events, "UNIT_MANA")
				table.insert(events, "UNIT_MAXMANA")
				table.insert(events, "UNIT_ENERGY")
				table.insert(events, "UNIT_MAXENERGY")
				table.insert(events, "UNIT_RAGE")
				table.insert(events, "UNIT_MAXRAGE")
				table.insert(events, "UNIT_FOCUS")
				table.insert(events, "UNIT_MAXFOCUS")
				table.insert(events, "UNIT_DISPLAYPOWER")
			elseif pre == "XP" then
				if frame.unit == "player" then
					table.insert(events, "PLAYER_XP_UPDATE")
					table.insert(events, "PLAYER_LEVEL_UP")
					table.insert(events, "UPDATE_EXHAUSTION")
					table.insert(events, "UPDATE_FACTION")
				elseif frame.unit == "pet" then
					table.insert(events, "UNIT_PET_EXPERIENCE")
				end
			elseif pre == "combo" then
				table.insert(events, "PLAYER_COMBO_POINTS")
			elseif pre == "feedback" then
				table.insert(events, "UNIT_COMBAT")
			elseif pre == "buff" or pre == "debuff" and not string.find(frame.unit, "target", 2, true) then
				table.insert(events, "UNIT_AURA")
			end
		end
		table.insert(frame[pre], child)
	end

	local update = function(child)
		local objtype = child:GetObjectType()
		local childname = string.gsub(child:GetName(), name, "")
		if not string.find(childname, "^target") and not string.find(childname, "^pet") then
			local pre = string.sub(childname, 1, 2)
			if pre == "hp" or pre == "mp" or pre == "xp" then
				if pre == "hp" then
					pre = "Health"
				elseif pre == "mp" then
					pre = "Mana"
				elseif pre == "xp" then
					pre = "XP"
				end
				regstatus(pre, child)
				if child.ani then
					if child.ani == "glide" then
						child.endvalue = 1
						child.fade = 1
						child.startvalue = 0
						child:SetScript("OnUpdate", glide)
					elseif child.ani == "fade" then
						fade(child)
					end
				end
			elseif string.find(childname, "^combo") then
				regstatus("combo", child)
			elseif string.find(childname, "^pvp") then
				table.insert(events, "UNIT_FACTION")
				frame.pvp = child
			elseif string.find(childname, "^status") then
				table.insert(events, "PLAYER_REGEN_DISABLED")
				table.insert(events, "PLAYER_REGEN_ENABLED")
				table.insert(events, "PLAYER_UPDATE_RESTING")
				frame.status = child
			elseif objtype == "FontString" then
				if child.format then
					string.gsub(child.format, "%$%a+",
						function (s)
							if s == "$guild" then
								table.insert(events, "PLAYER_GUILD_UPDATE")
								frame.guild = child
							elseif s == "$level" then
								table.insert(events, "UNIT_LEVEL")
								frame.level = child
							elseif s == "$key" then
								table.insert(events, "UPDATE_BINDINGS")
								frame.key = child
							elseif s == "$name" then
								frame.name = child
							elseif s == "$loot" then
								frame.loot = child
								table.insert(events, "PARTY_MEMBERS_CHANGED")
								table.insert(events, "PARTY_LOOT_METHOD_CHANGED")
							end
						end
					)
					regstatus("text", child)
				elseif childname == "group" then
					table.insert(events, "RAID_ROSTER_UPDATE")
					table.insert(events, "PARTY_MEMBERS_CHANGED")
					frame.group = child
				end
			elseif objtype == "Texture" then
				local texture = child:GetTexture()
				if texture then
					if texture == "Interface\\GroupFrame\\UI-Group-LeaderIcon" then
						table.insert(events, "PARTY_LEADER_CHANGED")
						frame.leader = child
					elseif texture == "Interface\\GroupFrame\\UI-Group-MasterLooter" then
						table.insert(events, "PARTY_LOOT_METHOD_CHANGED")
						frame.master = child
					elseif texture == "Interface\\QuestFrame\\UI-QuestTitleHighlight" then
						table.insert(events, "PLAYER_TARGET_CHANGED")
						if (not frame:GetHighlightTexture()) then
							frame:SetHighlightTexture(child)
						end
					elseif texture == "Interface\\TargetingFrame\\UI-RaidTargetingIcons" then
						table.insert(events, "RAID_TARGET_UPDATE")
						frame.raidtarget = child
					elseif texture == "Interface\\PetPaperDollFrame\\UI-PetHappiness" then
						table.insert(events, "UNIT_HAPPINESS")
						frame.happiness = child
					elseif texture == "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes" then
						frame.class = child
					elseif texture == "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races" then
						frame.race = child
					end
				elseif string.find(childname, "^portrait") or child.isportrait then
					table.insert(events, "UNIT_PORTRAIT_UPDATE")
					frame.portrait = child
				elseif string.find(childname, "^rank") then
					frame.rank = child
				end
			elseif objtype == "PlayerModel" then
				child:RegisterEvent("PLAYER_ENTERING_WORLD")
				child:RegisterEvent("DISPLAY_SIZE_CHANGED")
				child:RegisterEvent("UNIT_MODEL_CHANGED")
				if frame.unit == "target" then
					child:RegisterEvent("PLAYER_TARGET_CHANGED")
				elseif frame.unit == "pet" then
					child:RegisterEvent("UNIT_PET")
				elseif frame.unit == "focus" then
					child:RegisterEvent("PLAYER_FOCUS_CHANGED")
				elseif found == 1 then
					child:RegisterEvent("PARTY_MEMBERS_CHANGED")
				end
				child.unit = frame.unit
				child:SetScript("OnEvent", function() if event == "DISPLAY_SIZE_CHANGED" then this:RefreshUnit() else this:SetUnit(this.unit) end end)
				if not child.full then
					child:SetScript("OnUpdate", function() this:SetCamera(0) end)
				end
			elseif objtype == "MessageFrame" then
				regstatus("feedback", child)
			elseif objtype == "Button" then
				if string.find(childname, "^buff") or string.find(childname, "^debuff") then
					local border = _G[child:GetName().."Border"]
					local count = _G[child:GetName().."Count"]
					local icon = _G[child:GetName().."Icon"]
					if string.find(childname, "^debuff") then
						local id, found = gsub(childname, "debuff([0-9]+)", "%1")
						border:ClearAllPoints()
						border:SetAllPoints(child)
						child:SetID(id)
						child.isdebuff = true
						regstatus("debuff", child)
					else
						local id, found = gsub(childname, "buff([0-9]+)", "%1")
						child:SetID(id)
						border:Hide()
						regstatus("buff", child)
					end
					count:SetFontObject(Nurfed_UnitFontOutline)
					count:ClearAllPoints()
					count:SetPoint("BOTTOMRIGHT", child, "BOTTOMRIGHT", 0, 0)
					count:SetWidth(child:GetWidth())
					count:SetJustifyH("RIGHT")
					count:SetHeight(0)
					icon:ClearAllPoints()
					icon:SetAllPoints(child)
					if frame:GetObjectType() == "Button" then
						child:SetScript("OnEnter", auratip)
					else
						child:SetScript("OnEnter", nil)
						child:SetScript("OnLeave", nil)
					end
				end
			elseif objtype == "StatusBar" then
				if string.find(childname, "^casting") then
					if child:GetParent() ~= frame then
						child.parent = child:GetParent()
					end
					child.unit = frame.unit
					child.casting = nil
					child.channeling = nil
					child.holdTime = 0
					child:RegisterEvent("UNIT_SPELLCAST_START")
					child:RegisterEvent("UNIT_SPELLCAST_STOP")
					child:RegisterEvent("UNIT_SPELLCAST_FAILED")
					child:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
					child:RegisterEvent("UNIT_SPELLCAST_DELAYED")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE")
					child:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
					child:RegisterEvent("PLAYER_ENTERING_WORLD")
					if frame.unit == "target" then
						child:RegisterEvent("PLAYER_TARGET_CHANGED")
					elseif frame.unit == "focus" then
						child:RegisterEvent("PLAYER_FOCUS_CHANGED")
					elseif found == 1 then
						child:RegisterEvent("PARTY_MEMBERS_CHANGED")
					end
					child:SetScript("OnEvent", castevent)
					child:SetScript("OnUpdate", castupdate)
				end
			end
		elseif objtype == "Button" then
			if string.find(childname, "^target") then
				child.unit = frame.unit..childname
				self:unitimbue(child)
			elseif string.find(childname, "^pet") then
				child.punit = frame.unit
				child.unit = gsub(frame.unit.."pet", "^([^%d]+)([%d]+)[pP][eE][tT]$", "%1pet%2")
				self:unitimbue(child)
			end
		end
	end

	for _, child in ipairs(frames) do
		update(_G[child])
	end

	if string.find(frame.unit, "target", 2) then
		if not tots then
			tots = {}
			Nurfed:schedule(0.15, totupdate, true)
		end
		table.insert(tots, frame)
	else
		if not units then units = {} end
		for _, event in ipairs(events) do
			if not units[event] then
				units[event] = {}
				Nurfed:regevent(event, onevent)
			end
			table.insert(units[event], frame)
		end
	end
end

local combat = function()
	local dropdownFrame = _G[UIDROPDOWNMENU_INIT_MENU]
	local button = this.value
	local unit = dropdownFrame.unit
	local name = dropdownFrame.name
	local server = dropdownFrame.server
	if button == "NRF_COMBATLOG" and combatlog[unit] then
		local name = UnitName(unit)
		ChatFrame1:AddMessage("-------Combat History "..name.."-------------------")
		for k, v in ipairs(combatlog[unit]) do
			if name == v[1] then
				ChatFrame1:AddMessage(v[2])
			end
		end
		ChatFrame1:AddMessage("-------End--------------------------------------")
	end
end

UnitPopupButtons["NRF_COMBATLOG"] = { text = "Combat History", dist = 0 }
table.insert(UnitPopupMenus["SELF"], "NRF_COMBATLOG")
table.insert(UnitPopupMenus["PARTY"], "NRF_COMBATLOG")
hooksecurefunc("UnitPopup_OnClick", combat)

----------------------------------------------------------------
-- Add custom layouts to locals
if Nurfed_Replace then
	for k, v in Nurfed_Replace do
		replace[k] = v
	end
	Nurfed_Replace = nil
end

----------------------------------------------------------------
-- Toggle party member frames
local partysched
function NRF_UpdateParty()
	if InCombatLockdown() then
		if not partysched then
			partysched = true
			Nurfed:schedule("combat", NRF_UpdateParty)
		end
	else
		local size = Nurfed:getopt("raidsize")
		if HIDE_PARTY_INTERFACE == "1" and GetNumRaidMembers() > size then
			for _, frame in ipairs(partyframes) do
				frame:Hide()
			end
		else
			for _, frame in ipairs(partyframes) do
				if frame:GetAttribute("state-unitexists") then
					frame:Show()
				else
					frame:Hide()
				end
			end
		end
		partysched = nil
	end
end

hooksecurefunc("RaidOptionsFrame_UpdatePartyFrames", NRF_UpdateParty)