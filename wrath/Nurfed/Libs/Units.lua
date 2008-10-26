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
local playerClass = select(2, UnitClass("player"))
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
if UnitName("player") == "Adeathpoco" then 
	NURFED_FRAMES = nil 
end
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
		Nurfed_Unit_druidmp = {
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
		Nurfed_Unit_rune = {
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
					vars = { defaultText = "!" },
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
			--uitemp = "SecurePartyHeaderTemplate",
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
			Nurfed_Raid = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			--uitemp = "SecurePartyHeaderTemplate",
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
					vars = { format = "$name" },
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
				druidmanabar = {
					template = "Nurfed_Unit_druidmp",
					size = { 170, 8 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
					vars = { hideFrame = "xp" },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "RIGHT", "$parent", "LEFT" },
				},
				rune1 = {
					template = "Nurfed_Unit_rune",
					size = { 12, 8 },
					Anchor = { "BOTTOM", "$parent", "TOP", -35, 0 },
				},
				rune2 = {
					template = "Nurfed_Unit_rune",
					size = { 12, 8 },
					Anchor = { "TOPLEFT", "$parentrune1", "TOPRIGHT", 2, 0 },
				},
				rune3 = {
					template = "Nurfed_Unit_rune",
					size = { 12, 8 },
					Anchor = { "TOPLEFT", "$parentrune2", "TOPRIGHT", 2, 0 },
				},
				rune4 = {
					template = "Nurfed_Unit_rune",
					size = { 12, 8 },
					Anchor = { "TOPLEFT", "$parentrune3", "TOPRIGHT", 2, 0 },
				},
				rune5 = {
					template = "Nurfed_Unit_rune",
					size = { 12, 8 },
					Anchor = { "TOPLEFT", "$parentrune4", "TOPRIGHT", 2, 0 },
				},
				rune6 = {
					template = "Nurfed_Unit_rune",
					size = { 12, 8 },
					Anchor = { "TOPLEFT", "$parentrune5", "TOPRIGHT", 2, 0 },
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
			vars = { unit = "player", enablePredictedStats = true, },
		},

		Nurfed_target = {
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
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -22 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 130, 10 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -35.5 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "RIGHT", "$parent", "LEFT" },
				},
				threat = {
					--template = "Nurfed_Unit_threat",
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
					vars = { threatUnit = "player", ani = "glide" },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 40, 40 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -4, -6 },
					
				},
				rank = {
					type = "Texture",
					size = { 17, 17 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -23, -4 },
					Hide = true,
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
					--FontObject = "Nurfed_UnitFont",
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parentname", "BOTTOMLEFT", 0, 0 },
					vars = { format = "$level $class" }
				},
				hpperc = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					--Font = { NRF_FONT.."framd.ttf", 9, "NONE" },
					FontObject = "Nurfed_UnitFontSmall",
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMRIGHT", "$parenthp", "TOPRIGHT", 0, 0 },
					vars = { format = "$perc" },
				},
				--[[
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
				threat = {
					type = "FontString",
					size = { 100, 8 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."framd.ttf", 9, "NONE" },
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMLEFT", "$parenthpperc", "TOPRIGHT", 15, 0 },
					vars = { format = "$threat-$tperc", threatUnit = "player" },
				},]]
				combo = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."framd.ttf", 22, "OUTLINE" },
					TextHeight = 22,
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMLEFT", 2, 3 },
					vars = { unit1 = "player", unit2 = "target" },
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
			vars = { unit = "target", aurawidth = 176, aurasize = 17, enablePredictedStats = true, },
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
			vars = { unit = "pet", aurawidth = 160, enablePredictedStats = true },
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
		--Nurfed_raid1 = { template = "Nurfed_Raid", vars = { unit = "raid1" } },
	},
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
	[1] = { (255/255), (100/255), (100/255) },-- 1 - physical
	[2] = { (255/255), (255/255), (0/255) },-- 2 - holy
	[4] = { (255/255), (0/255), (0/255) },-- 4 - fire
	[8] = { (0/255), (102/255), (0/255) }, -- 8 - nature
	[16] = { (0/255), (102/255), (255/255) }, -- 16 - frost
	[24] = { (255/255), (76/255), (178/255) }, -- 24 - Shadow + fire (corehound)
	[32] = { (202/255), (76/255), (217/255) },-- 32 - shadow
	[40] = { (202/255), (178/255), (217/255) }, -- 40 - nature + shadow? lol?
	[64] = { (153/255), (204/255), (255/255) }, -- 64 - arcane
	[127] = { (255/255), (100/255), (100/255) }, -- 127 - Used by Chaos Rain, unknown damage type
}

local classification = {
	["rareelite"] = ITEM_QUALITY3_DESC.."-"..ELITE,
	["rare"] = ITEM_QUALITY3_DESC,
	["elite"] = ELITE,
}

----------------------------------------------------------------
-- Text variable replacements
local replace = {
	["$realm"] = function(self, t) return select(2, UnitName(self.unit)) or "" end,
	["$faction"] = function(self, t) return UnitFactionGroup(self.unit) or "" end,
	["$rname"] = function(self, t) return GetPVPRankInfo(UnitPVPRank(self.unit)) or "" end,
	["$rnum"] = function(self, t) return select(2, GetPVPRankInfo(UnitPVPRank(self.unit))) or "" end,
	["$race"] = function(self, t) return UnitRace(self.unit) or "" end,
	["$threat"] = function(self, t)
		if not self.threatUnit or not self.unit then return end
		local isTanking, state, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(self.threatUnit, self.unit)
		local string = ""
		if threatValue then
			if isTanking then
				string = "|cffff0000"
			else
				string = "|cff00ff00"
			end
			threatValue = threatValue / 100 -- get the real number....	
			if threatValue > 1000000 then
				threatValue = string.format("%2.1fm", threatValue / 1000000)
			elseif threatValue > 1000 then
				threatValue = string.format("%2.1fk", threatValue / 1000)
			else
				threatValue = string.format("%2.0f", threatValue)
			end
			string = string..threatValue.."|r"
		end
		return string
	end,
	["$tperc"] = function(self, t)
		if not self.threatUnit or not self.unit then return end
		local isTanking, state, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(self.threatUnit, self.unit)
		local string = ""
		if scaledPercent then
			if isTanking then
				string = "|cffff0000"
			else
				string = "|cff00ff00"
			end
			scaledPercent = string.format("%2.2f", scaledPercent)
			string = string..scaledPercent.."|r"
		end
		return string
	end,
	["$name"] = function(self, t)
		local name = UnitName(self.unit)
		local color
		if UnitIsPlayer(self.unit) then
			local eclass = select(2, UnitClass(self.unit))
			if eclass then
				color = RAID_CLASS_COLORS[eclass].hex
			end
			
		else
			if not UnitPlayerControlled(self.unit) and UnitIsTapped(self.unit) and not UnitIsTappedByPlayer(self.unit) then
				color = "|cff7f7f7f"
			else
				color = Nurfed:rgbhex(UnitSelectionColor(self.unit))
			end
		end
		return (color or "|cffffffff")..name.."|r"
	end,


	["$key"] = function(self, t)
			local id, found = self.unit:gsub("party([1-4])", "%1")
			if found == 1 then
				local binding = GetBindingText(GetBindingKey("TARGETPARTYMEMBER"..id), "KEY_")
				binding = Nurfed:binding(binding)
				return binding or ""
			end
	end,

	["$level"] = function(self, t)
			local level = UnitLevel(self.unit)
			local classification = UnitClassification(self.unit)
			local r, g, b
			if level > 0 then
				local color = GetDifficultyColor(level)
				r = color.r
				g = color.g
				b = color.b
			end
			if UnitIsPlusMob(self.unit) then
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

	["$class"] = function(self, t)
			local class, eclass = UnitClass(self.unit)
			if UnitIsPlayer(self.unit) then
				if RAID_CLASS_COLORS[eclass] then
					local color = RAID_CLASS_COLORS[eclass].hex or "|cffffffff"
					class = color..class.."|r"
				end
			else
				local unitclass = UnitClassification(self.unit)
				if UnitCreatureType(self.unit) == "Humanoid" and UnitIsFriend("player", self.unit) then
					class = "NPC"
				elseif UnitCreatureType(self.unit) == "Beast" and UnitCreatureFamily(self.unit) then
					class = UnitCreatureFamily(self.unit)
				else
					class = UnitCreatureType(self.unit)
				end
				if classification[unitclass] then
					class = classification[unitclass].." "..class
				end
			end
			return class or ""
	end,

	["$guild"] = function(self, t)
			local guild = GetGuildInfo(self.unit)
			if guild then
				local color = "|cff00bfff"
				if UnitIsInMyGuild(self.unit) then
					color = "|cffff00ff"
				end
				guild = color..guild.."|r"
			end
			return guild or ""
	end,

	["$loot"] = function(self, t)
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
		_G["PlayerFrame"]:UnregisterAllEvents()
		_G["PlayerFrame"]:Hide()
	end,
	target = function()
		_G["TargetFrame"]:UnregisterAllEvents()
		_G["TargetFrame"]:Hide()
		_G["ComboFrame"]:UnregisterAllEvents()
		_G["ComboFrame"]:Hide()
	end,
	party1 = function()
		for i = 1, 4 do
			local party = _G["PartyMemberFrame"..i]
			party:UnregisterAllEvents()
			party:Hide()
		end
		_G["ShowPartyFrame"] = function() end
	end,
	focus = function()
		_G["FocusFrame"]:UnregisterAllEvents()
		_G["FocusFrame"]:Hide()
		if _G["ShowFocusFrame"] then
			_G["ShowFocusFrame"] = function() end
		end
	end,
}

local function auratip(self)
	if not self:IsVisible() then return end
	GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
	local unit = self:GetParent().unit
	if self.isdebuff then
		GameTooltip:SetUnitDebuff(unit, self:GetID(), self.filter)
	else
		GameTooltip:SetUnitBuff(unit, self:GetID(), self.filter)
	end
end

local function ntinsert(tbl, val)
	if not tbl or type(tbl) ~= "table" then return end
	local add = true
	for i,v in pairs(tbl) do
		if i == val or v == val then
			add = false
			break
		end
	end
	if add then
		table.insert(tbl, val)
	end	
end
----------------------------------------------------------------
-- StatusBar animations
local function glide(self, e)
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

local function getbit()
	local r
	if #usedBits > 0 then
		r = table.remove(usedBits)
	else
		i = i + 1
		r = UIParent:CreateTexture("nrf_fade"..i, "BACKGROUND")
	end
	return r
end

local function killbit(item)
	table.insert(usedBits, item)
	item:Hide()
	item:SetParent(UIParent)
end

local function nrf_fading(self, value, flag)
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

local function fade(frame)
	local texture = frame:GetStatusBarTexture()
	local name = texture:GetTexture()
	frame.texture = name
	frame.old = 0
	hooksecurefunc(frame, "SetValue", nrf_fading)
end

local function addcombat()-- Update:  You said this was used by the combatlog.  
						  -- I still cant find it being called anywhere in this file
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
			color = Nurfed:rgbhex(unpack(damage[dtype]))
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

local lastTime, lastType, lastAmount = 0, 0, 0
local function updatedamage(frame, unit, event, flags, amount, type)
	-- hack to prevent double parsing of the same event.  UNIT_COMBAT seems to be firing
	-- twice for each event.  This may be a Nurfed bug, look into further.
	if lastTime + .001 >= GetTime() and lastType == type and lastAmount == amount then return end
	lastTime, lastType, lastAmount = GetTime(), type, amount
	local text = ""
	local r, g, b = 1, 0.647, 0
	
	if event == "HEAL" then
		text = "+"..amount
		r, g, b = 0, 1, 0
	elseif event == "WOUND" then
		if amount ~= 0 then
			if not damage[type] then
				Nurfed:print("New Damage Type:"..amount.."  type:"..type.."  Report this message to Apoco along with what mob did it!")
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
local function castevent(self)
	local parent = self.parent
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "PARTY_MEMBERS_CHANGED" or event == "PLAYER_FOCUS_CHANGED" then
		local nameChannel  = UnitChannelInfo(self.unit)
		local nameSpell  = UnitCastingInfo(self.unit)
		if nameChannel then
			event = "UNIT_SPELLCAST_CHANNEL_START"
			arg1 = self.unit
		elseif nameSpell then
			event = "UNIT_SPELLCAST_START"
			arg1 = self.unit
		else
			self:Hide()
			if parent then parent:Hide() end
			return
		end
	end

	if arg1 ~= self.unit then return end

	local barText = _G[self:GetName().."text"]
	local barIcon = _G[self:GetName().."icon"]
	local orient = self:GetOrientation()

	if event == "UNIT_SPELLCAST_START" then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(self.unit)
		if not name then
			self:Hide()
			if parent then parent:Hide() end
			return
		end

		self:SetStatusBarColor(1.0, 0.7, 0.0)
		self.startTime = startTime / 1000
		self.maxValue = endTime / 1000

		self:SetMinMaxValues(self.startTime, self.maxValue)
		self:SetValue(self.startTime)
		self:SetAlpha(1.0)
		self.holdTime = 0
		self.casting = 1
		self.channeling = nil
		self.fadeOut = nil
		self:Show()
		if barText and barText.format then
			local out = barText.format
			out = out:gsub("$spell", name)
			out = out:gsub("$rank", nameSubtext)
			if nameSubtext == "" then
				out = out:gsub("%(", ""):gsub("%)", "")
			end
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
		if not self:IsVisible() then self:Hide() end
		if self:IsShown() then
			self:SetValue(self.maxValue)
			if event == "UNIT_SPELLCAST_STOP" then
				self:SetStatusBarColor(0.0, 1.0, 0.0)
				self.casting = nil
			else
				self.channeling = nil
			end
			self.fadeOut = 1
			self.holdTime = 0
		end
	elseif event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" then
		if self:IsShown() and not self.channeling then
			self:SetValue(self.maxValue)
			self:SetStatusBarColor(1.0, 0.0, 0.0)
			self.casting = nil
			self.channeling = nil
			self.fadeOut = 1
			self.holdTime = GetTime() + CASTING_BAR_HOLD_TIME
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
		if self:IsShown() then
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitCastingInfo(self.unit)
			if not name then
				self:Hide()
				if parent then parent:Hide() end
				return
			end
			self.startTime = startTime / 1000
			self.maxValue = endTime / 1000
			self:SetMinMaxValues(self.startTime, self.maxValue)
		end
	elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
		local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(self.unit)
		if not name then
			self:Hide()
			if parent then parent:Hide() end
			return
		end

		self:SetStatusBarColor(0.0, 1.0, 0.0)
		self.startTime = startTime / 1000
		self.endTime = endTime / 1000
		self.duration = self.endTime - self.startTime
		self.maxValue = self.startTime

		self:SetMinMaxValues(self.startTime, self.endTime)
		self:SetValue(self.endTime)
		self:SetAlpha(1.0)
		self.holdTime = 0
		self.casting = nil
		self.channeling = 1
		self.fadeOut = nil
		self:Show()
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
		if self:IsShown() then
			local name, nameSubtext, text, texture, startTime, endTime, isTradeSkill = UnitChannelInfo(self.unit)
			if not name then
				self:Hide()
				if parent then parent:Hide() end
				return
			end
			self.startTime = startTime / 1000
			self.endTime = endTime / 1000
			self.maxValue = self.startTime
			self:SetMinMaxValues(self.startTime, self.endTime)
		end
	end
end

local function castupdate(self)
	if self.casting and self:IsShown() then
		local status = GetTime()
		if status > self.maxValue then
			status = self.maxValue
		end
		if status == self.maxValue then
			self:SetValue(self.maxValue)
			self:SetStatusBarColor(0.0, 1.0, 0.0)
			self.casting = nil
			self.flash = 1
			self.fadeOut = 1
			return
		end
		self:SetValue(status)
		local cast = _G[self:GetName().."time"]
		if cast then
			cast:SetText(string.format("(%.1fs)", self.maxValue - status))
		end
	elseif self.channeling then
		local time = GetTime()
		if time > self.endTime then
			time = self.endTime
		end
		if time == self.endTime then
			self:SetStatusBarColor(0.0, 1.0, 0.0)
			self.channeling = nil
			self.flash = 1
			self.fadeOut = 1
			return
		end
		local barValue = self.startTime + (self.endTime - time)
		self:SetValue(barValue)
		local cast = _G[self:GetName().."time"]
		if cast then
			cast:SetText(string.format("(%.1fs)", self.endTime - time))
		end
	elseif GetTime() < self.holdTime then
		return
	elseif self.fadeOut then
		local parent = self.parent
		local alpha = self:GetAlpha() - CASTING_BAR_ALPHA_STEP
		if alpha > 0 then
			self:SetAlpha(alpha)
			if parent then parent:SetAlpha(alpha) end
		else
			self.fadeOut = nil
			self:Hide()
			if parent then parent:Hide() end
		end
	end
end

----------------------------------------------------------------
-- Health, Mana, XP text and colors
local function cuttexture(texture, size, fill, value)
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

local function updateinfo(self, stat, tstat)
	if not stat or not self[stat] then return end
	local unit = SecureButton_GetUnit(self)
	local curr, max, missing, perc, r, g, b, bgr, bgg, bgb, isTanking, state, scaledPercent, rawPercent, threatValue, rest;
	if stat ~= "Threat" then
		curr, max, missing, perc, r, g, b, bgr, bgg, bgb = Nurfed:getunitstat(unit, stat, tstat and 0, tstat and "Mana")
	else
		isTanking, state, scaledPercent, rawPercent, threatValue = UnitDetailedThreatSituation(self[stat][1].threatUnit, unit)
		if not scaledPercent or not threatValue then
			for _, child in ipairs(self[stat]) do
				child:Hide()
			end
			return
		end
		scaledPercent = string.format("%2.2f", scaledPercent)
	end
		
	local maxtext, missingtext = max, missing
	
	if stat == "XP" then
		local name = GetWatchedFactionInfo()
		if name then
			rest = name
		else
			rest = GetXPExhaustion() or ""
		end
	elseif stat == "Threat" then
		if isTanking then
			max = threatValue
		else
			max = select(5, UnitDetailedThreatSituation(unit.."target", unit))
		end	
		if not max then 
			for _, child in ipairs(self[stat]) do
				child:Hide()
			end
			return 
		end
		perc = scaledPercent
		curr = threatValue
		curr = curr / 100 -- get the real number....
		max = max / 100
		r, g, b = GetThreatStatusColor(state)
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

	for _, child in ipairs(self[stat]) do
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
				if bgr and bgg and bgb then
					child:SetBackdropColor(bgr, bgg, bgb)
				end
			elseif objtype == "FontString" then
				local text
				local curr, max, maxtext = curr, max, maxtext
				if stat == "Threat" then
					if curr > 1000000 then
						curr = string.format("%2.1fm", curr / 1000000)
					elseif curr > 1000 then
						curr = string.format("%2.1fk", curr / 1000)
					else
						curr = string.format("%2.0f", curr)
					end
					if max > 1000000 then
						maxtext = string.format("%2.1fm", max / 1000000)
					elseif max > 1000 then
						maxtext = string.format("%2.1fk", max / 1000)
					else
						max = string.format("%2.0f", max)
					end
				end
				if not UnitIsConnected(unit) and stat == "Health" then
					text = PLAYER_OFFLINE
				elseif UnitIsGhost(unit) and stat == "Health" then
					text = ghost
				elseif (UnitIsDead(unit) or UnitIsCorpse(unit)) and stat == "Health" then
					text = DEAD
				else
					text = child.format
					text = text:gsub("$cur", curr)
					text = text:gsub("$max", maxtext)
					text = text:gsub("$perc", perc.."%%")
					
					if missingtext and missingtext ~= 0 then
						text = text:gsub("$miss", "|cffcc1111"..missingtext.."|r")
					else
						text = text:gsub("$miss", "")
					end
					text = text:gsub("$rest", rest)
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

local function manacolor(self)
	if not self.Mana then return end
	local unit = SecureButton_GetUnit(self)
	local color = PowerBarColor[UnitPowerType(unit)]
	for _, child in ipairs(self.Mana) do
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
	updateinfo(self, "Mana")
end

local function updatestatus(self)
	if self.status then
		local icon = self.status
		local objtype = icon:GetObjectType()
		local unit = SecureButton_GetUnit(self)
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

local function updateraid(self)
	if self.raidtarget then
		local unit = SecureButton_GetUnit(self)
		local icon = self.raidtarget
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
local function subtext(self, text)
	if not text then return end
	local pre = text:find("%$%a")
	string.gsub(text, "%$%a+", function(s)
		if replace[s] then
			text = text:gsub(s, replace[s](self))
		end
	end)

	if pre == 1 then
		local post = text:find("[%a^%|cff]")
		if post and post > pre then
			text = text:gsub("[^%a]", "", 1)
		end
	end
	return text
end

local function formattext(self, trueself)
	if self and self.format then
		local display = subtext(trueself or self, self.format)
		self:SetText(display)
	end
end

local function updatetext(self)
	if self.text then
		for _, v in ipairs(self.text) do
			formattext(v, self)
		end
	end
end

local function updatehappiness(self)
	local happiness, damagePercentage = GetPetHappiness()
	local hasPetUI, isHunterPet = HasPetUI()
	if happiness or isHunterPet then
		local display
		local text = self.name
		local icon = self.happiness
		if text then 
			display = subtext(self, self.name.format)
		end
		if icon then 
			icon:Show() 
		end
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
			text:SetText(display)
		end
	end
end

local function updatecombo(self, unit, force)
	if self.combo then
		local comboPoints
		for _, child in ipairs(self.combo) do
			if not force then -- if we aren't forcing the update (target changed), then check the unit
				if child.unit1 ~= unit then 
					return -- not proper unit, dont update info kthx
				end
			end
			comboPoints = GetComboPoints(unit, child.unit2)
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

local function updateleader(self)
	if self.leader then
		local icon = self.leader
		local unit = SecureButton_GetUnit(self)
		local id, found = unit:gsub("party([1-4])", "%1")
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

local function updatemaster(self)
	if self.master then
		local icon = self.master
		local unit = SecureButton_GetUnit(self)
		local id, found = unit:gsub("party([1-4])", "%1")
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

local function updatepvp(self)
	if self.pvp then
		local unit = SecureButton_GetUnit(self)
		local icon = self.pvp
		local objtype = icon:GetObjectType()
		local factionGroup, factionName = UnitFactionGroup(unit)
		if UnitIsPVPFreeForAll(unit) then
			if objtype == "Texture" then
				icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
			else
				icon:SetText(PVP_ENABLED)
			end
			if unit == "player" and not self.pvpenabled then
				self.pvpenabled = true
				PlaySound("igPVPUpdate")
			end
			icon:Show()
		elseif factionGroup and UnitIsPVP(unit) then
			if objtype == "Texture" then
				icon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..factionGroup)
			else
				icon:SetText(PVP_ENABLED)
			end
			if unit == "player" and not self.pvpenabled then
				self.pvpenabled = true
				PlaySound("igPVPUpdate")
			end
			icon:Show()
		else
			if unit == "player" and self.pvpenabled then
				self.pvpenabled = nil
			end
			icon:Hide()
		end
	end
end

local function cooldowntext(self)
	local cd = _G[self:GetName().."Cooldown"]
	if Nurfed:getopt("cdaura") then
		if cd.text and cd.cool then
			local cdscale = cd:GetScale()
			local r, g, b = 1, 0, 0
			local remain = (cd.start + cd.duration) - GetTime()
			if remain >= 0 then
				remain = math.round(remain)
				if remain >= 60 then
					remain = math.floor(remain / 60)
					r, g, b = 1, 1, 0
				end
				cd.text:SetText(remain)
				cd.text:SetTextColor(r, g, b)
			else
				cd.text:SetText(nil)
				cd.cool = nil
			end
		end
	else
		if cd.text and cd.cool then
			cd.text:SetText(nil)
			cd.cool = nil
		end
	end
end

local function aurafade(self, time)
	self.update = self.update + time
	if self.update > 0.04 then
		local now = GetTime()
		local frame, texture, p
		if now - self.flashtime > 0.3 then
			self.flashdct = self.flashdct * (-1)
			self.flashtime = now
		end

		if self.flashdct == 1 then
			p = (1 - (now - self.flashtime + 0.001) / 0.3 * 0.7)
		else
			p = ( (now - self.flashtime + 0.001) / 0.3 * 0.7 + 0.3)
		end
		self:SetAlpha(p)
		self.update = 0
	end
	cooldowntext(self)
end

local removeLst = {
	["Enrage"] = {
		["HUNTER"] = true,
	},
	[""] = {	-- Frenzy, Enrage show up as "" instead of nil for some reason, probably bugged
		["HUNTER"] = true,
	},
}
local function updateauras(self)
	local unit = SecureButton_GetUnit(self)
	local button, name, rank, texture, app, duration, left, dtype, color, total, width, fwidth, scale, count, cd, isMine, isStealable
	local isFriend, filterList, check
	local showdur = Nurfed:getopt("showdurationlist")
	local oldBuffs = Nurfed:getopt("olddebuffstyle")
	
	isFriend = UnitIsFriend("player", unit)
	if self.buff then
		filterList = Nurfed:getopt("bufffilterlist")
		
		for name in pairs(filterList) do check = true; break; end
		filterList = check and filterList or nil
		
		total = 0
		for i = 1, #self.buff do
			button = _G[self:GetName().."buff"..i]
			name, rank, texture, app, dtype, duration, left, isMine, isStealable = UnitBuff(unit, i, self.bfilter)
			--if name then
			if name and not filterList or filterList and filterList[name] then
				total = total + 1
				-- reset to button position if we are using a filtering list.
				button = filterList and _G[self:GetName().."buff"..total] or button
				
				_G[button:GetName().."Icon"]:SetTexture(texture)
				count = _G[button:GetName().."Count"]
				
				if app > 1 then
					count:SetText(app)
					count:Show()
				else
					count:Hide()
				end
				button.filter = self.bfilter
				button:Show()
				--button:SetScript("OnUpdate", cooldowntext)
				cd = _G[button:GetName().."Cooldown"]
				if duration and duration > 0 then
					if not oldBuffs or oldBuffs and isMine then
						CooldownFrame_SetTimer(cd, left - duration, duration, 1)
					else
						cd:Hide()
					end
				else
					cd:Hide()
				end
				if not isFriend and dtype and removeLst[dtype] and removeLst[dtype][playerClass] then
					if not button:GetScript("OnUpdate") then
						button.flashtime = GetTime()
						button.update = 0
						button.flashdct = 1
						button:SetScript("OnUpdate", aurafade)
						self.cure = cure[dtype][playerClass]
					end
				else
					button:SetScript("OnUpdate", cooldowntext)
					button:SetAlpha(1)
				end
			else
				button:SetScript("OnUpdate", nil)
				button:Hide()
			end
		end
		if self.buffwidth then
			width = button:GetWidth()
			fwidth = total * width
			scale = self.buffwidth / fwidth
			if scale > 1 then scale = 1 end
			for i = 1, total do
				_G[self:GetName().."buff"..i]:SetScale(scale)
			end
		end
	end
	
	if self.debuff then
		check = nil
		filterList = Nurfed:getopt("debufffilterlist")
		for name in pairs(filterList) do check = true; break; end
		filterList = check and filterList or nil
		
		self.cure = nil
		total = 0
		for i = 1, #self.debuff do
			button = _G[self:GetName().."debuff"..i]
			local filter = self.dfilter
			if (unit == "target" or unit == "focus") and not isFriend then filter = nil end

			name, rank, texture, app, dtype, duration, left, isMine = UnitDebuff(unit, i, filter)
			if (name and (isFriend or not filterList)) or name and filterList and filterList[name] then
				total = total + 1
				-- reset to button position if we are using a filtering list.
				button = filterList and _G[self:GetName().."debuff"..total] or button

				_G[button:GetName().."Icon"]:SetTexture(texture)
				count = _G[button:GetName().."Count"]

				if app > 1 then
					count:SetText(app)
					count:Show()
				else
					count:Hide()
				end

				color = DebuffTypeColor[dtype or "none"]
				_G[button:GetName().."Border"]:SetVertexColor(color.r, color.g, color.b)
				button.filter = self.dfilter
				button:Show()

				cd = _G[button:GetName().."Cooldown"]
				if duration and duration > 0 then
					if not oldBuffs or oldBuffs and isMine then
						CooldownFrame_SetTimer(cd, left - duration, duration, 1)
					else
						cd:Hide()
					end
				else
					cd:Hide()
				end
				if isFriend and dtype and cure[dtype] and cure[dtype][playerClass] then
					if not button:GetScript("OnUpdate") then
						button.flashtime = GetTime()
						button.update = 0
						button.flashdct = 1
						button:SetScript("OnUpdate", aurafade)
						self.cure = true
					end
				else
					button:SetScript("OnUpdate", cooldowntext)
					button:SetAlpha(1)
				end
			else
				button:SetScript("OnUpdate", nil)
				button:Hide()
			end
		end
		if self.debuffwidth then
			width = button:GetWidth()
			fwidth = total * width
			scale = self.debuffwidth / fwidth
			if scale > 1 then scale = 1 end
			for i = 1, total do
				_G[self:GetName().."debuff"..i]:SetScale(scale)
			end
		end
	end
end

local function updaterank(self)
	if self.rank then
		local icon = self.rank
		local unit = SecureButton_GetUnit(self)
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

local function updatename(self)
	local unit = SecureButton_GetUnit(self)
	if self.name then
		formattext(self.name, self)
	end

	if self.class then
		local info
		local icon = self.class
		local texture, coords = Nurfed:getclassicon(unit)
		if coords then
			icon:SetTexture(texture)
			icon:SetTexCoord(unpack(coords))
		end
	end

	if self.race then
		local icon = self.race
		local coords = Nurfed:getraceicon(unit)
		if coords then
			icon:SetTexCoord(unpack(coords))
		end
	end
end

local function updatehighlight(self)
	local unit = SecureButton_GetUnit(self)
	if UnitExists("target") and UnitName("target") == UnitName(unit) then
		self:LockHighlight()
	else
		self:UnlockHighlight()
	end
end

local function updategroup(self)
	if self.group then
		local text = self.group
		local unit = SecureButton_GetUnit(self)
		local group = Nurfed:getunit(UnitName(unit))
		if group then
			text:SetText(GROUP..": |cffffff00"..group.."|r")
		else
			text:SetText(nil)
		end
	end
end

local function updateloot(self)
	if self.loot then
		formattext(self.loot, self)
	end
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

local function showparty(self)
	if InCombatLockdown() then
		if not partysched then
			partysched = true
			Nurfed:schedule("combat", NRF_UpdateParty)
		end
	else
		local size = Nurfed:getopt("raidsize")
		if not UnitExists(self.unit) or (HIDE_PARTY_INTERFACE == "1" and GetNumRaidMembers() > size) then
			self:Hide()
		else
			self:Show()
		end
	end
end

local function updateRunesOnUpdate(self)
	local start, duration = self.start, self.duration
	local time = GetTime()
	local remain = (start + duration) - time
	if remain >= 0 then
		remain = math.round(remain)

		if remain >= 3600 then
			remain = math.floor(remain / 3600).."h"
			r, g, b = 0.6, 0.6, 0.6
		
		elseif remain >= 60 then
			local min = math.floor(remain / 60)
			r, g, b = 1, 1, 0

			if min < 10 then
				local secs = math.floor(math.fmod(remain, 60))
				remain = string.format("%2d:%02s", min, secs)
			else
				remain = min.."m"
			end
		end
		self:SetValue(time - start)
		local text = _G[self:GetName().."text"]
		if text then
			text:SetText(remain)
			text:Show()
		else
			text:Hide()
		end
	end
end

local function updateRunes(self, rune, usable)
	if rune <= 6 then
		local start, duration, runeReady = GetRuneCooldown(rune);
		local frame = _G[self:GetName().."rune"..rune]
		if frame then
			if rune == 1 or rune == 2 then
				frame:SetStatusBarColor(1, 0, 0)
			elseif rune == 5 or rune == 6 then
				frame:SetStatusBarColor(0, 0, 1)
			elseif rune == 3 or rune == 4 then
				frame:SetStatusBarColor(0, 1, 0)
			end
			frame:SetMinMaxValues(0, duration)
			frame.rune = rune
			frame.start = start
			frame.duration = duration
			if runeReady then
				local text = _G[frame:GetName().."text"]
				if text then
					text:SetText(text.defaultText)
					text:Show()
				end
				frame:SetScript("OnUpdate", nil)
				UIFrameFadeIn(frame, 0.5)
			else
				if not frame:GetScript("OnUpdate") then
					frame:SetScript("OnUpdate", updateRunesOnUpdate)
				end
			end
		end
	end
end

local function updateThreat(self, unit)
	updateinfo(self, "Threat")
end

local function updateframe(self, notext)
	local unit = SecureButton_GetUnit(self)
	if self.status then updatestatus(self) end
	if self.Health then updateinfo(self, "Health") end
	if self.XP then updateinfo(self, "XP") end
	if self.Threat then updateinfo(self, "Threat") end
	if self.combo then updatecombo(self, "player", true) end
	if self.Mana then 
		self.powerType = UnitPowerType(unit)
		manacolor(self) 
	end
	if self.buff or frame.debuff then updateauras(self) end
	if self.portrait then SetPortraitTexture(self.portrait, unit) end
	if self.pvp then updatepvp(self) end
	if self.leader then updateleader(self) end
	if self.master then updatemaster(self) end
	if self.raidtarget then updateraid(self) end
	if self.rank then updaterank(self) end
	if self.threat then formattext(self.threat) end
	if not notext then
		if self.text then updatetext(self) end
		updatename(self)
	end

	if unit == "pet" then
		updatehappiness(self) 
	end
	if self.GetHighlightTexture and self:GetHighlightTexture() then
		updatehighlight(self)
	end
	if self.rune then
		for i,v in ipairs(self.rune) do
			updateRunes(self, i)
		end
	end
end



local events = {
	["UPDATE_SHAPESHIFT_FORM"] = updateframe,

	["PLAYER_ENTERING_WORLD"] = updateframe,
	["PLAYER_FOCUS_CHANGED"] = updateframe,
	["PLAYER_TARGET_CHANGED"] = updateframe,
	["PLAYER_REGEN_DISABLED"] = updatestatus,
	["PLAYER_REGEN_ENABLED"] = updatestatus,
	["PLAYER_UPDATE_RESTING"] = updatestatus,
	["PLAYER_FLAGS_CHANGED"] = updatestatus,
	
	["UNIT_COMBO_POINTS"] = updatecombo,
	
	["PLAYER_XP_UPDATE"] = function(self) updateinfo(self, "XP") end,
	["PLAYER_LEVEL_UP"] = function(self) updateinfo(self, "XP") end,
	["UPDATE_FACTION"] = function(self) updateinfo(self, "XP") end,
	["UPDATE_EXHAUSTION"] = function(self) updateinfo(self, "XP") end,
	["PLAYER_GUILD_UPDATE"] = function(self) formattext(self.guild, self) end,
	["UNIT_THREAT_LIST_UPDATE"] = updateThreat,
	["UNIT_THREAT_SITUATION_UPDATE"] = updateThreat,
	
	["RAID_TARGET_UPDATE"] = updateraid,
	
	["PARTY_MEMBERS_CHANGED"] = function(self)
		if self.isParty then
			updateframe(self)
		else
			updategroup(self)
			updateleader(self)
			updatemaster(self)
			updateloot(self)
		end
	end,
	["PARTY_LEADER_CHANGED"] = function(self)
		updateleader(self)
		updatemaster(self)
	end,
	["PARTY_LOOT_METHOD_CHANGED"] = function(self)
		updatemaster(self)
		updateloot(self)
	end,
	["RAID_ROSTER_UPDATE"] = updategroup,
	
	["UPDATE_BINDINGS"] = function(self) formattext(self.key, self) end,
	["UNIT_PET_EXPERIENCE"] = function(self) updateinfo(self, "XP") end,
	["UNIT_PET"] = updateframe,
	
	["UNIT_HEALTH"] = function(self) updateinfo(self, "Health") end,
	["UNIT_MAXHEALTH"] = function(self) updateinfo(self, "Health") end,
	["UNIT_MANA"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_ENERGY"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_RAGE"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_FOCUS"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_RUNIC_POWER"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_MAXMANA"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_MAXENERGY"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_MAXRAGE"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_MAXFOCUS"] = function(self) updateinfo(self, "Mana") end,
	["UNIT_MAXRUNIC_POWER"] = function(self) updateinfo(self, "Mana") end,
	
	["UNIT_COMBAT"] = updatedamage,
	["UNIT_AURA"] = updateauras,
	["UNIT_DISPLAYPOWER"] = manacolor,
	
	["UNIT_PORTRAIT_UPDATE"] = function(self)
		SetPortraitTexture(self.portrait, SecureButton_GetUnit(self))
	end,
	["UNIT_FACTION"] = updatepvp,
	["UNIT_LEVEL"] = function(self)
		updateinfo(self, "XP")
		formattext(self.level, self)
	end,
	["UNIT_NAME_UPDATE"] = function(self)
		updatename(self)
		updatetext(self)
	end,
	["UNIT_DYNAMIC_FLAGS"] = function(self) formattext(self.name, self) end,
	["UNIT_CLASSIFICATION_CHANGED"] = function(self) formattext(self.level) end,
	["UNIT_HAPPINESS"] = updatehappiness,
	["RUNE_POWER_UPDATE"] = updateRunes,
	["UNIT_ENTERED_VEHICLE"] = updateframe,
	["UNIT_EXITED_VEHICLE"] = updateframe,
}

local function onevent(event, ...)
	for _, frame in ipairs(units[event]) do
		local unit = SecureButton_GetUnit(frame)
		if UnitExists(unit) then
			if event == "UNIT_PET" then
				if (arg1 == "player" and unit == "pet") or (arg1 == unit:gsub("pet", "")) then
					events[event](frame, ...)
				end
			elseif event:find("^UNIT_") then
				if arg1 == unit or event == "UNIT_COMBO_POINTS" then
					events[event](frame, ...)
				end
			else
				events[event](frame, ...)
			end
		end
	end
end

local function totupdate()
	local unit, notext
	for _, frame in ipairs(tots) do
		unit = SecureButton_GetUnit(frame)
		if UnitExists(unit) then
			notext = true
			if not frame.lastname or frame.lastname ~= UnitName(unit) then
				frame.lastname = UnitName(unit)
				notext = nil
			end
			updateframe(frame, notext)
		else
			frame.lastname = nil
		end
	end
end

local predictedStatsUpdateFrame = CreateFrame("Frame")
local predictedStatsTable = {}
local function predictstats()
	for _, frame in ipairs(predictedStatsTable) do
		if UnitExists(frame.unit) then
			if ( not frame.disconnected ) then
				local currValue
				if frame.predictedPower then
					currValue = UnitPower(frame.unit, frame.powerType)
					if currValue ~= frame.currPowerValue then
						frame.currPowerValue = currValue
						updateinfo(frame, "Mana")	
					end
					if frame.dMana then
						currValue = UnitPower(frame.unit, 0)
						if frame.powerType ~= 0 then
							if currValue ~= frame.currDPowerValue then
								frame.currDPowerValue = currValue
								updateinfo(frame, "dMana", true)
								if not frame.dManaShown then
									frame.dManaShown = true
									frame.dMana[1]:Show()
								end
							end
						else	
							if frame.dManaShown then
								frame.dManaShown = false
								frame.dMana[1]:Hide()
							end
						end
					end

				end
				
				if frame.predictedHealth then
					currValue = UnitHealth(frame.unit)
					if currValue ~= frame.currHealthValue then
						frame.currHealthValue = currValue
						updateinfo(frame, "Health")
					end
				end
			end
		end
	end
end

function Nurfed:unitimbue(frame)
	local dropdown, menufunc
	local id, found = frame.unit:gsub("party([1-4])", "%1")
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
		frame:SetScript("OnDragStart", function(self) if not NRF_LOCKED then self:StartMoving() end end)
		frame:SetScript("OnDragStop", function(self) NURFED_FRAMES.frames[self:GetName()].Point = { self:GetPoint() } self:StopMovingOrSizing() end)
		frame:SetScript("OnMouseWheel", function(self)
				if not NRF_LOCKED then
					local scale = self:GetScale()
					if arg1 > 0 and scale < 3 then
						self:SetScale(scale + 0.1)
					elseif arg1 < 0 and scale > 0.25 then
						self:SetScale(scale - 0.1)
					end
					NURFED_FRAMES.frames[self:GetName()].Scale = self:GetScale()
				end
			end)
	end

	if found == 1 then
		frame.isParty = true
		frame:SetID(tonumber(id))
		frame:SetScript("OnAttributeChanged", showparty)
		ntinsert(events, "UNIT_COMBAT")
		ntinsert(events, "PARTY_MEMBERS_CHANGED")
		
	elseif frame.unit == "target" then
		ntinsert(events, "PLAYER_TARGET_CHANGED")
		ntinsert(events, "UNIT_DYNAMIC_FLAGS")
		ntinsert(events, "UNIT_CLASSIFICATION_CHANGED")
		frame:SetScript("OnHide", TargetFrame_OnHide)
		
	elseif frame.unit == "focus" then
		ntinsert(events, "PLAYER_FOCUS_CHANGED")
		
	elseif string.find(frame.unit, "pet", 1, true) then
		if frame.unit == "pet" then
			frame.punit = "player"
		end
		ntinsert(events, "UNIT_PET")
		ntinsert(events, "UNIT_EXITED_VEHICLE")
		ntinsert(events, "UNIT_ENTERED_VEHICLE")
		
	elseif frame.unit == "player" then
		ntinsert(events, "UNIT_COMBAT")
		if playerClass == "DEATHKNIGHT" then
			_G["RuneFrame"]:UnregisterAllEvents();
			_G["RuneFrame"]:Hide();
		elseif playerClass == "DRUID" then
			ntinsert(events, "UPDATE_SHAPESHIFT_FORM")
		end
	end

	if found == 1 then
		dropdown = _G["PartyMemberFrame"..id.."DropDown"]
		
	elseif frame.unit:find("^raid") then
		frame.isRaid = true
		FriendsDropDown.initialize = function() UnitPopup_ShowMenu(_G[UIDROPDOWNMENU_OPEN_MENU], "RAID", frame.unit, UnitName(frame.unit), frame:GetID()) end
		FriendsDropDown.displayMode = "MENU"
		dropdown = FriendsDropDown
	else
		dropdown = _G[frame.unit:gsub("^%l", string.upper).."FrameDropDown"]
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
			if not frame.unit and frame:GetParent().unit then frame.unit = frame:GetParent().unit end
			if pre == "Health" then
				if GetCVarBool("predictedHealth") and frame.enablePredictedStats then
					predictedStatsUpdateFrame:SetScript("OnUpdate", predictstats)
					frame.predictedHealth = true
					ntinsert(predictedStatsTable, frame)
				else
					ntinsert(events, "UNIT_HEALTH")
				end
				ntinsert(events, "UNIT_MAXHEALTH")
			
			elseif pre == "Threat" then
				ntinsert(events, "UNIT_THREAT_LIST_UPDATE")
				ntinsert(events, "UNIT_THREAT_SITUATION_UPDATE")
			
			elseif pre == "dMana" then
				if GetCVarBool("predictedPower") and frame.enablePredictedStats then
					predictedStatsUpdateFrame:SetScript("OnUpdate", predictstats)
					frame.predictedPower = true
					ntinsert(predictedStatsTable, frame)
				else
					ntinsert(events, "UNIT_MANA")
					ntinsert(events, "UNIT_RAGE")
					ntinsert(events, "UNIT_FOCUS")
					ntinsert(events, "UNIT_ENERGY")
					ntinsert(events, "UNIT_HAPPINESS")
					ntinsert(events, "UNIT_RUNIC_POWER")
				end
				ntinsert(events, "UNIT_MAXMANA");
				ntinsert(events, "UNIT_MAXRAGE");
				ntinsert(events, "UNIT_MAXFOCUS");
				ntinsert(events, "UNIT_MAXENERGY");
				ntinsert(events, "UNIT_MAXHAPPINESS");
				ntinsert(events, "UNIT_MAXRUNIC_POWER");
				ntinsert(events, "UNIT_DISPLAYPOWER");
			elseif pre == "Mana" then
				if GetCVarBool("predictedPower") and frame.enablePredictedStats then
					predictedStatsUpdateFrame:SetScript("OnUpdate", predictstats)
					frame.predictedPower = true
					frame.powerType = UnitPowerType(frame.unit)
					ntinsert(predictedStatsTable, frame)
				else
					ntinsert(events, "UNIT_MANA");
					ntinsert(events, "UNIT_RAGE");
					ntinsert(events, "UNIT_FOCUS");
					ntinsert(events, "UNIT_ENERGY");
					ntinsert(events, "UNIT_HAPPINESS");
					ntinsert(events, "UNIT_RUNIC_POWER");
				end
				ntinsert(events, "UNIT_MAXMANA");
				ntinsert(events, "UNIT_MAXRAGE");
				ntinsert(events, "UNIT_MAXFOCUS");
				ntinsert(events, "UNIT_MAXENERGY");
				ntinsert(events, "UNIT_MAXHAPPINESS");
				ntinsert(events, "UNIT_MAXRUNIC_POWER");
				ntinsert(events, "UNIT_DISPLAYPOWER");
				
			elseif pre == "XP" then
				if frame.unit == "player" then
					ntinsert(events, "PLAYER_XP_UPDATE");
					ntinsert(events, "PLAYER_LEVEL_UP");
					ntinsert(events, "UPDATE_EXHAUSTION");
					ntinsert(events, "UPDATE_FACTION");
					
				elseif frame.unit == "pet" then
					ntinsert(events, "UNIT_PET_EXPERIENCE");
				end
				
			elseif pre == "combo" then
				ntinsert(events, "UNIT_COMBO_POINTS");
				
			elseif pre == "feedback" then
				ntinsert(events, "UNIT_COMBAT");
				
			elseif pre == "buff" or pre == "debuff" and not string.find(frame.unit, "target", 2, true) then
				ntinsert(events, "UNIT_AURA");
			
			elseif pre == "rune" then
				ntinsert(events, "RUNE_POWER_UPDATE");
				ntinsert(events, "RUNE_TYPE_UPDATE");
				child:GetParent().runes = {}
			end
			if child.hideFrame then
				child:SetScript("OnShow", function(self)
					UIFrameFadeOut(_G[self:GetParent():GetName()..self.hideFrame], 0.15)
				end)
				child:SetScript("OnHide", function(self)
					UIFrameFadeIn(_G[self:GetParent():GetName()..self.hideFrame], 0.15)
				end)
				if UnitPowerType(frame.unit) ~= 0 then
					child:Show()
					UIFrameFadeOut(_G[frame:GetName()..child.hideFrame], 0.15)
				else
					child:Hide()
					UIFrameFadeIn(_G[frame:GetName()..child.hideFrame], 0.15)
				end
			end			
		end
		table.insert(frame[pre], child)
		table.sort(frame[pre], function(a,b) 
			local ma, mb = a:GetName():match("%d"), b:GetName():match("%d")
			if ma and mb then
				return ma < mb
			end
		end)
	end

	local update = function(child)
		local objtype = child:GetObjectType()
		local childname = child:GetName():gsub(name, "")
		if not childname:find("^target") and not childname:find("^pet") then
			
			local pre = childname:sub(1, 2)
			if pre == "hp" or pre == "mp" or pre == "xp" or pre == "dr" or pre == "th" then
				if pre == "hp" then
					pre = "Health"
				elseif pre == "mp" then pre = "Mana"
				elseif pre == "xp" then pre = "XP"
				elseif pre == "dr" then pre = "dMana"
				elseif pre == "th" then pre = "Threat"
				end
				if pre == "dMana" and child:GetParent().unit == "player" and playerClass ~= "DRUID" then 
					child:Hide()
					return 
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
			
			elseif childname:find("^rune") then
				if playerClass == "DEATHKNIGHT" and child:GetParent().unit == "player" then
					regstatus("rune", child)
				else
					child:Hide()
				end
				
			elseif childname:find("^combo") then
				regstatus("combo", child)
				
			elseif childname:find("^pvp") then
				ntinsert(events, "UNIT_FACTION")
				frame.pvp = child
				
			elseif childname:find("^status") then
				ntinsert(events, "PLAYER_REGEN_DISABLED")
				ntinsert(events, "PLAYER_REGEN_ENABLED")
				ntinsert(events, "PLAYER_UPDATE_RESTING")
				frame.status = child
				
			elseif objtype == "FontString" then
				if child.format then
					string.gsub(child.format, "%$%a+",
						function(s)
							if s == "$guild" then
								ntinsert(events, "PLAYER_GUILD_UPDATE")
								frame.guild = child
								
							elseif s == "$level" then
								ntinsert(events, "UNIT_LEVEL")
								frame.level = child
								
							elseif s == "$key" then
								ntinsert(events, "UPDATE_BINDINGS")
								frame.key = child
								
							elseif s == "$name" then
								frame.name = child
								
							elseif s == "$loot" then
								ntinsert(events, "PARTY_MEMBERS_CHANGED")
								ntinsert(events, "PARTY_LOOT_METHOD_CHANGED")
								frame.loot = child
							end
						end
					)
					regstatus("text", child)
					
				elseif childname == "group" then
					ntinsert(events, "RAID_ROSTER_UPDATE")
					ntinsert(events, "PARTY_MEMBERS_CHANGED")
					frame.group = child
				end
				
			elseif objtype == "Texture" then
				local texture = child:GetTexture()
				if texture then
					if texture == "Interface\\GroupFrame\\UI-Group-LeaderIcon" then
						ntinsert(events, "PARTY_LEADER_CHANGED")
						frame.leader = child
					elseif texture == "Interface\\GroupFrame\\UI-Group-MasterLooter" then
						ntinsert(events, "PARTY_LOOT_METHOD_CHANGED")
						frame.master = child
					elseif texture == "Interface\\QuestFrame\\UI-QuestTitleHighlight" then
						ntinsert(events, "PLAYER_TARGET_CHANGED")
						if (not frame:GetHighlightTexture()) then
							frame:SetHighlightTexture(child)
						end
					elseif texture == "Interface\\TargetingFrame\\UI-RaidTargetingIcons" then
						ntinsert(events, "RAID_TARGET_UPDATE")
						frame.raidtarget = child
					elseif texture == "Interface\\PetPaperDollFrame\\UI-PetHappiness" then
						ntinsert(events, "UNIT_HAPPINESS")
						frame.happiness = child
					elseif texture == "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes" then
						frame.class = child
					elseif texture == "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races" then
						frame.race = child
					end
				elseif childname:find("^portrait") or child.isportrait then
					ntinsert(events, "UNIT_PORTRAIT_UPDATE")
					frame.portrait = child
					
				elseif childname:find("^rank") then
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
				child:SetScript("OnEvent", function(self) if event == "DISPLAY_SIZE_CHANGED" then self:RefreshUnit() else self:SetUnit(self.unit) end end)
				if not child.full then
					child:SetScript("OnUpdate", function(self) self:SetCamera(0) end)
				end
				
				
			elseif objtype == "MessageFrame" then
				regstatus("feedback", child)
				
			elseif objtype == "Button" then
				
				if childname:find("^buff") or childname:find("^debuff") then
					local cd = _G[child:GetName().."Cooldown"]
					if not cd then
						cd = CreateFrame("Cooldown", child:GetName().."Cooldown", child, "CooldownFrameTemplate")
						cd:Hide()
					end
					cd.text = cd:CreateFontString(nil, "OVERLAY")
					cd.text:SetPoint("CENTER")
					
					local width = floor(child:GetWidth() * .65)
					cd.text:SetFont("Fonts\\FRIZQT__.TTF", width, "OUTLINE")
					
					local border = _G[child:GetName().."Border"]
					local count = _G[child:GetName().."Count"]
					local icon = _G[child:GetName().."Icon"]
					if childname:find("^debuff") then
						local id, found = childname:gsub("debuff([0-9]+)", "%1")
						border:ClearAllPoints()
						border:SetAllPoints(child)
						child:SetID(id)
						child.isdebuff = true
						regstatus("debuff", child)
					elseif childname:find("^buff") then
						local id, found = childname:gsub("buff([0-9]+)", "%1")
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
				if childname:find("^casting") then
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
					
					if frame.unit == "target" then child:RegisterEvent("PLAYER_TARGET_CHANGED")
					elseif frame.unit == "focus" then child:RegisterEvent("PLAYER_FOCUS_CHANGED")
					elseif found == 1 then child:RegisterEvent("PARTY_MEMBERS_CHANGED")
					end
					child:SetScript("OnEvent", castevent)
					child:SetScript("OnUpdate", castupdate)
					if child.hideFrame then
						child:SetScript("OnShow", function(self)
							UIFrameFadeOut(_G[self:GetParent():GetName()..self.hideFrame], 0.15)
						end)
						child:SetScript("OnHide", function(self)
							UIFrameFadeIn(_G[self:GetParent():GetName()..self.hideFrame], 0.15)
						end)
						if UnitPowerType(frame.unit) ~= 0 then
							child:Show()
							UIFrameFadeOut(_G[frame:GetName()..child.hideFrame], 0.15)
						else
							child:Hide()
							UIFrameFadeIn(_G[frame:GetName()..child.hideFrame], 0.15)
						end
					end
				end
			end
			
		elseif objtype == "Button" then
			if childname:find("^target") then
				child.unit = frame.unit..childname
				self:unitimbue(child)
				
			elseif childname:find("^pet") then
				child.punit = frame.unit
				child.unit = gsub(frame.unit.."pet", "^([^%d]+)([%d]+)[pP][eE][tT]$", "%1pet%2")
				self:unitimbue(child)
			end
		end
	end

	for _, child in ipairs(frames) do
		update(_G[child])
	end

	if frame.unit:find("target", 2) then
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

local function combat(self)
	local dropdownFrame = _G[UIDROPDOWNMENU_INIT_MENU]
	local button = self.value
	local unit = dropdownFrame.unit
	local name = dropdownFrame.name
	local server = dropdownFrame.server
	if button == "NRF_COMBATLOG" and combatlog[unit] then
		local name = UnitName(unit)
		Nurfed:print("-------Combat History: "..name.."-------------------")
		for k, v in ipairs(combatlog[unit]) do
			if name == v[1] then
				Nurfed:print(v[2])
			end
		end
		Nurfed:print("-------End--------------------------------------")
	end
end

UnitPopupButtons["NRF_COMBATLOG"] = { text = "Combat History", dist = 0 }
table.insert(UnitPopupMenus["SELF"], "NRF_COMBATLOG")
table.insert(UnitPopupMenus["PARTY"], "NRF_COMBATLOG")
hooksecurefunc("UnitPopup_OnClick", combat)

function Nurfed_UnitColors()
	if not NURFED_FRAMES.frames then return end
	for k in pairs(NURFED_FRAMES.frames) do
		local frame = _G[k]
		local unit = SecureButton_GetUnit(frame)
		if UnitExists(unit) then
			if frame.Health then updateinfo(frame, "Health") end
			if frame.Mana then manacolor(frame) end
		end
	end
end

----------------------------------------------------------------
-- Add custom layouts to locals
if Nurfed_Replace then
	for k, v in pairs(Nurfed_Replace) do
		replace[k] = v
	end
	Nurfed_Replace = nil
end
	-- used to force the import of vars for files that load after units.lua
function Nurfed_ReplaceUnitVars()
	if Nurfed_Replace then
		for k, v in pairs(Nurfed_Replace) do
			replace[k] = v
		end
		Nurfed_Replace = nil
	end
end
Nurfed:setver("$Date$")
Nurfed:setrev("$Rev$")
