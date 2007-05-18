
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

function Nurfed_HealthPercColor(perc)
	local color = {};
	if(perc > 0.6) then
		color.r = (78/255);
		color.g = (106/255);
		color.b = (143/255);
	else
		if(perc > 0.2) then
			color.r = (( 78+((0.6-perc)*100*(128/40)))/255);
			color.g = ((106+((0.6-perc)*100*(-89/40)))/255);
			color.b = ((143+((0.6-perc)*100*(-136/40)))/255);
		else
			color.r = (206/255);
			color.g = (17/255);
			color.b = (17/255);
		end
	end
	return color;
end

ManaBarColor[0] = { r = .498, g = .604, b = .722, prefix = TEXT(MANA) };	-- mana
ManaBarColor[1] = { r = .498, g = .604, b = .722, prefix = TEXT(MANA) };	-- rage
ManaBarColor[2] = { r = .498, g = .604, b = .722, prefix = TEXT(MANA) };	-- focus
ManaBarColor[3] = { r = .498, g = .604, b = .722, prefix = TEXT(MANA) };	-- energy
ManaBarColor[4] = { r = .498, g = .604, b = .722, prefix = TEXT(MANA) };	-- happiness

if (not Nurfed_UnitsLayout) then

	Nurfed_UnitsLayout = {};

	Nurfed_UnitsLayout.Name = "|cffff0000Tknp Modified Nurfed|r";
	Nurfed_UnitsLayout.Author = "Tivoli";

	--Frame Templates
	Nurfed_UnitsLayout.templates = {
		Nurfed_UnitCharcoal_Outline = {
			type = "Font",
			Font = { NRF_FONT.."Charcoal.ttf", 15, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_UnitCharcoal_Name = {
			type = "Font",
			Font = { NRF_FONT.."Charcoal.ttf", 18, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},

		Nurfed_Unit_backdrop = {
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16,
			insets = { left = 5, right = 5, top = 5, bottom = 5 },
		},

		Nurfed_Unit_hp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			Orientation = "HORIZONTAL",
			StatusBarTexture = NRF_IMG.."statusbar9",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."statusbar9",
					VertexColor = { 1, 0, 0, 0.25 },
					Anchor = "all"
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitCharcoal_Outline",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur / $max" },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitCharcoal_Outline",
					JustifyH = "RIGHT",
					Anchor = "all",
					vars = { format = "[$perc]" },
				},
			},
			vars = { ani = "glide" },
		},

		Nurfed_Unit_mp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			Orientation = "HORIZONTAL",
			StatusBarTexture = NRF_IMG.."statusbar9",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."statusbar9",
					VertexColor = { 0, 1, 1, 0.25 },
					Anchor = "all" },
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitCharcoal_Outline",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur / $max" },
				},
			},
			vars = { ani = "glide" },
		},

		Nurfed_Unit_xp = {
			type = "StatusBar",
			strata = "LOW",
			Orientation = "HORIZONTAL",
			StatusBarTexture = NRF_IMG.."statusbar9",
			children = {
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."statusbar9",
					VertexColor = { 0, 0, 1, 0.25 },
					Anchor = "all" },
				text = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 11, "NONE" },
					JustifyH = "CENTER",
					TextColor = { 1, 1, 1 },
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur/$max" },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 11, "NONE" },
					JustifyH = "RIGHT",
					TextColor = { 1, 1, 1 },
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "[$perc]" },
				}
			},
		},

		Nurfed_Unit_model = {
			type = "PlayerModel",
			FrameStrata = "LOW",
			ModelScale = 1.9,
			Camera = 0,
			FrameLevel = 2,
		},

		Nurfed_Model_frame = {
			type = "Frame",
			FrameStrata = "LOW",
			FrameLevel = 2,
			Backdrop = { 
				bgFile = NRF_IMG.."statusbar9",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 100,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
			BackdropColor = { .06, .13, .22, .95 },
		},

		Nurfed_Pet_frame = {
			type = "Frame",
			FrameStrata = "LOW",
			FrameLevel = 2,
			Backdrop = { 
				bgFile = NRF_IMG.."statusbar9",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 100,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
			BackdropColor = { .06, .13, .22, .95 },	
		},

		Nurfed_Name_frame = {
			type = "Frame",
			Backdrop = {
				bgFile = NRF_IMG.."statusbar9",
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
				tile = true,
				tileSize = 100,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
			BackdropColor = { .06, .13, .22, .95 },
			children = {
				text = {
					type = "FontString",
					size = { 105, 30 },
					layer = "OVERLAY",
					FontObject = "Nurfed_UnitCharcoal_Name",
					JustifyH = "CENTER",
					Anchor = "all",
					vars = { format = "$name" },
				},
			},
		},

		Nurfed_Unit_mini = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 75, 35 },
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
					size = { 69, 16 },
					FrameStrata = "LOW",
					Orientation = "HORIZONTAL",
					StatusBarTexture = NRF_IMG.."statusbar9",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 3, 3 },
					children = {
						bg = {
							type = "Texture",
							layer = "BACKGROUND",
							Texture = NRF_IMG.."statusbar9",
							VertexColor = { 1, 0, 0, 0.25 },
							Anchor = "all",
						},
						text = {
							type = "FontString",
							layer = "OVERLAY",
							Font = { NRF_FONT.."Charcoal.ttf", 12, "OUTLINE" },
							JustifyH = "RIGHT",
							TextColor = { 1, 1, 1 },
							Anchor = "all",
							vars = { format = "[$perc]" },
						},
					},
				},
				name = {
					type = "FontString",
					size = { 70, 12 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 12, "OUTLINE" },
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
			size = { 200, 46 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 147, 15 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 17 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 147, 11 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 4, 0 } },
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
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", -3, 14 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff1", "RIGHT", 1, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff2", "RIGHT", 1, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff3", "RIGHT", 1, 0 } },
				model_frame = {
					template = "Nurfed_Model_frame",
					size = { 50, 50 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 4 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 40, 40 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 6, 4 },
				},
				highlight = {
					type = "Texture",
					size = { 118, 30 },
					layer = "ARTWORK",
					Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
					BlendMode = "ADD",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 16 },
				},
				leader = {
					type = "Texture",
					size = { 13, 13 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 50, 10 },
				},
				master = {
					type = "Texture",
					size = { 13, 13 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 65, 12 },
				},
				pvp = {
					type = "FontString",
					size = { 60, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 10, 17 },
				},
				name = {
					template = "Nurfed_Name_frame",
					size = { 110, 30 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, 16 },
				},
				pet = {
					template = "Nurfed_Unit_mini",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMRIGHT", -4, 2 },
				},
				feedback = {
					type = "MessageFrame",
					layer = "OVERLAY",
					size = { 50, 16 },
					Font = { NRF_FONT.."Charcoal.ttf", 15, "OUTLINE" },
					JustifyH = "LEFT",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 5 },
					FadeDuration = 0.5,
					TimeVisible = 1,
					FrameLevel = 3,
				},
			},
			vars = { aurawidth = 176 },
		},

	};

	--Frame Design
	Nurfed_UnitsLayout.Layout = {
		player = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 270, 91 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { .2, .2, .2, 0.85 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 166, 18 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 30 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 166, 13 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 16 },
				},
				xp = {
					template = "Nurfed_Unit_xp",
					size = { 166, 11 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				model_frame = {
					template = "Nurfed_Model_frame",
					size = { 100, 100 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 5 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 90, 90 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 6, 4 },
				},
				name = {
					template = "Nurfed_Name_frame",
					size = { 130, 30 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, 15 },
				},
				guild = {
					type = "FontString",
					size = { 145, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -7, -13 },
					vars = { format = "$guild" },
				},
				class = {
					type = "FontString",
					size = { 125, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "RIGHT",
					TextColor = { 0.5, 0.5, 0.5 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -7, -28 },
					vars = { format = "$race/$class" },
				},
				pvp = {
					type = "FontString",
					size = { 60, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 100, -13 },
				},
				rank = {
					type = "Texture",
					size = { 15, 15 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 116, -27 },
				},
				level = {
					type = "FontString",
					size = { 30, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 100, -28 },
					vars = { format = "$level" },
				},
				status = {
					type = "Texture",
					size = { 22, 22 },
					layer = "OVERLAY",
					Texture = "Interface\\CharacterFrame\\UI-StateIcon",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 130, -24 },
				},
				leader = {
					type = "Texture",
					size = { 15, 15 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 100, 13 },
				},
				master = {
					type = "Texture",
					size = { 15, 15 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 115, 15 },
				},
				group = {
					type = "FontString",
					size = { 50, 13 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 13, "NONE" },
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 30, 17 },
				},
				feedback = {
					type = "MessageFrame",
					layer = "OVERLAY",
					size = { 110, 21 },
					Font = { NRF_FONT.."Charcoal.ttf", 20, "OUTLINE" },
					JustifyH = "LEFT",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 5 },
					FadeDuration = 0.5,
					TimeVisible = 1,
					FrameLevel = 3,
				},
			},
			vars = { unit = "player" },
		},

		target = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 260, 80 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { .2, .2, .2, 0.85 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 166, 18 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 19 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 166, 13 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 5, 5 },
				},
				model_frame = {
					template = "Nurfed_Model_frame",
					size = { 90, 90 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 5 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 80, 80 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 6, 4 },
				},

				target = { template = "Nurfed_Unit_mini", Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", -3, -3 } },
				targettarget = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMRIGHT", -3, 3 } },
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
				debuff9 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOP", "$parentdebuff1", "BOTTOM", 0, 0 } },
				debuff10 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff9", "RIGHT", 0, 0 } },
				debuff11 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff10", "RIGHT", 0, 0 } },
				debuff12 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff11", "RIGHT", 0, 0 } },
				debuff13 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff12", "RIGHT", 0, 0 } },
				debuff14 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff13", "RIGHT", 0, 0 } },
				debuff15 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff14", "RIGHT", 0, 0 } },
				debuff16 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff15", "RIGHT", 0, 0 } },
				name = {
					template = "Nurfed_Name_frame",
					size = { 155, 30 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, 15 },
				},
				guild = {
					type = "FontString",
					size = { 145, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 7, -13 },
					vars = { format = "$guild" },
				},
				class = {
					type = "FontString",
					size = { 125, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "LEFT",
					TextColor = { 0.5, 0.5, 0.5 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 7, -28 },
					vars = { format = "$race/$class" },
				},
				pvp = {
					type = "FontString",
					size = { 60, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -90, -12 },
				},
				rank = {
					type = "Texture",
					size = { 15, 15 },
					layer = "OVERLAY",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -106, -27 },
				},
				level = {
					type = "FontString",
					size = { 30, 14 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 14, "NONE" },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -90, -28 },
					vars = { format = "$level" },
				},
				combo = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 22, "OUTLINE" },
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMLEFT", 2, 3 },
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 20, 20 },
					layer = "OVERLAY",
					Anchor = { "RIGHT", "$parentmodel_frame", "LEFT", -40, 10 },
					Hide = true,
				},
			},
			vars = { unit = "target" },
		},

		pet = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 163, 48 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = { template = "Nurfed_Unit_backdrop" },
			BackdropColor = { .2, .2, .2, 0.85 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 110, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 18 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 110, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				model_frame = {
					template = "Nurfed_Pet_frame",
					size = { 50, 50 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 2 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 40, 40 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 6, 4 },
				},
				name = {
					template = "Nurfed_Name_frame",
					size = { 90, 25 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, 10 },
				},
				happiness = {
					type = "Texture",
					Texture = "Interface\\PetPaperDollFrame\\UI-PetHappiness",
					size = { 14, 14 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 50, -4 },
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

		focus = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 163, 48 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = { template = "Nurfed_Unit_backdrop" },
			BackdropColor = { .2, .2, .2, 0.85 },
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 110, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 18 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 110, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -5, 5 },
				},
				model_frame = {
					template = "Nurfed_Pet_frame",
					size = { 50, 50 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 2 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 40, 40 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 6, 4 },
				},
				name = {
					template = "Nurfed_Name_frame",
					size = { 90, 25 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, 10 },
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
	};
end