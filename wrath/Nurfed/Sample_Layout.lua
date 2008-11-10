if (not Nurfed_UnitsLayout) then

	Nurfed_UnitsLayout = {}

	Nurfed_UnitsLayout.Name = "Modified Simplicity Layout"
	Nurfed_UnitsLayout.Author = "Croissant"

	--Frame Templates
	Nurfed_UnitsLayout.templates = {
		Nurfed_Unit_Font = {
			type = "Font",
			Font = { NRF_FONT.."Charcoal.ttf", 12, "NONE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_Unit_Bold = {
			type = "Font",
			Font = { NRF_FONT.."Charcoal.ttf", 12, "OUTLINE" },
			TextColor = { 1, 1, 1 },
		},
		Nurfed_Unit_backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16, edgeSize = 16, insets = { left = 0, right = 0, top = 0, bottom = 0 }, },

		Nurfed_Unit_hp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			Orientation = "HORIZONTAL",
			StatusBarTexture = NRF_IMG.."statusbar9",
			vars = { ani = "glide" },
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
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75},
					ShadowOffset = { -1, -1 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
					vars = { format = "$cur / $max" },
				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Bold",
					JustifyH = "RIGHT",
					TextColor = { 1, 0, 0 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
					vars = { format = "$miss" },
				},
			},
		},

		Nurfed_Unit_mp = {
			type = "StatusBar",
			FrameStrata = "LOW",
			Orientation = "HORIZONTAL",
			StatusBarTexture = NRF_IMG.."statusbar9",
			vars = { ani = "glide" },
			children = {	
				bg = {
					type = "Texture",
					layer = "BACKGROUND",
					Texture = NRF_IMG.."statusbar9",
					VertexColor = { 0, 1, 1, 0.25 },
					Anchor = "all",
				},
				text = {
					type = "FontString",
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$cur / $max" },
				},
			},
		},

		Nurfed_Unit_xp = {
			type = "StatusBar",
--			StatusBarTexture = NRF_IMG.."statusbar9",
			children = {
--				bg = {
--					type = "Texture",
--					layer = "BACKGROUND",
--					Texture = NRF_IMG.."statusbar5",
--					VertexColor = { 0, 0, 1, 0.25 },
--					Anchor = "all",
--				},
--				text = {
--					type = "FontString",
--					layer = "OVERLAY",
--					FontObject = "Nurfed_Unit_Font",
--					JustifyH = "CENTER",
--					ShadowColor = { 0, 0, 0, 0.75 },
--					ShadowOffset = { -1, -1 },
--					Anchor = "all",
--					vars = { format = "$cur/$max$rest" },
--				},
				text2 = {
					type = "FontString",
					layer = "OVERLAY",
				FontObject = "Nurfed_Unit_Bold",
					JustifyH = "RIGHT",
					ShadowColor = { 0, 0, 0, 0.75 },
					TextColor = { 1, 0, 0 },
					ShadowOffset = { -1, -1 },
					Anchor = "all",
					vars = { format = "$perc" },
				}
			},
		},

		Nurfed_Unit_casting = {
			type = "Frame",
			size = { 176, 20 },
			Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
			BackdropColor = { 0, 0, 0, 0 },
			children = {
				casting = {
					type = "StatusBar",
					size = { 173, 17 },
					Orientation = "HORIZONTAL",
					Anchor = { "LEFT", 2, 0 },
					StatusBarTexture = NRF_IMG.."statusbar9",
					FrameLevel = 1,
					children = {
						text = {
							type = "FontString",
							layer = "ARTWORK",
							size = { 176, 20 },
							JustifyH = "CENTER",
							FontObject = "Nurfed_Unit_Font",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = { "LEFT" },
							vars = { format = "$spell" },
						},
						time = {
							type = "FontString",
							layer = "ARTWORK",
							JustifyH = "LEFT",
							FontObject = "Nurfed_Unit_Font",
							ShadowColor = { 0, 0, 0, 0.75 },
							ShadowOffset = { -1, -1 },
							Anchor = { "RIGHT", "$parent", "RIGHT", 27, 0 },
						},
						icon = {
							type = "Texture",
							layer = "ARTWORK",
							size = { 20, 20 },
							Anchor = { "LEFT", "$parent", "LEFT", -25, 0 },
						},
					},
					Hide = true,
				},
			},
			Hide = true,
		},

		Nurfed_Unit_model = {
			type = "PlayerModel",
			FrameStrata = "LOW",
			ModelScale = 1.9,
			Camera = 0,
			FrameLevel = 1,
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
			FrameLevel = 1,
			Backdrop = { 
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = "",
				tile = true,
				tileSize = 100,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
				},
			BackdropColor = { 0, 0, 0, .75 },
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
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "CENTER",
					Anchor = "all",
					vars = { format = "$name" },
				},
			},
		},

		Nurfed_Unit_mini = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 75, 20 },
			FrameStrata = "LOW",
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 8,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			children = {
				hp = {
					type = "StatusBar",
					size = { 75, 10 },
					FrameStrata = "LOW",
					Orientation = "HORIZONTAL",
					StatusBarTexture = NRF_IMG.."statusbar9",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
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
							Font = { NRF_FONT.."Charcoal.ttf", 9, "OUTLINE" },
							JustifyH = "RIGHT",
							TextColor = { 1, 0, 0 },
							Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
							vars = { format = "$perc" },
						},
					},
				},
				name = {
					type = "FontString",
					size = { 75, 10 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, 1 },
					vars = { format = "$name" },
				},
			},
			Hide = true,
		},

		Nurfed_Unit_mini_party = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 75, 44 },
			FrameStrata = "LOW",
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 8,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			children = {
				hp = {
					type = "StatusBar",
					size = { 75, 22 },
					FrameStrata = "LOW",
					Orientation = "HORIZONTAL",
					StatusBarTexture = NRF_IMG.."statusbar9",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
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
							Font = { NRF_FONT.."Charcoal.ttf", 15, "OUTLINE" },
							JustifyH = "RIGHT",
							TextColor = { 1, 0, 0 },
							Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, -3 },
							vars = { format = "$perc" },
						},
					},
				},
				name = {
					type = "FontString",
					size = { 75, 22 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, 1 },
					vars = { format = "$name" },
				},
			},
			Hide = true,
		},

		Nurfed_Unit_mini_party_pet = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 100, 36 },
			FrameStrata = "LOW",
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				tile = true,
				tileSize = 16,
				edgeSize = 8,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0, 0, 0, 0.75 },
			children = {
				hp = {
					type = "StatusBar",
					size = { 100, 18 },
					FrameStrata = "LOW",
					Orientation = "HORIZONTAL",
					StatusBarTexture = NRF_IMG.."statusbar9",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
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
							Font = { NRF_FONT.."Charcoal.ttf", 14, "OUTLINE" },
							JustifyH = "RIGHT",
							TextColor = { 1, 0, 0 },
							Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, -3 },
							vars = { format = "$perc" },
						},
					},
				},
				name = {
					type = "FontString",
					size = { 75, 22 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					ShadowColor = { 0, 0, 0, 0.75 },
					ShadowOffset = { -1, -1 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 1, 1 },
					vars = { format = "$name" },
				},
			},
			Hide = true,
		},

		Nurfed_Party = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 176, 44 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { 0, 0, 0, 0.75 },
			Movable = true,
			Mouse = true,
			events = { "PLAYER_LOGIN" },
			OnEvent = [[
				local class = select(2, UnitClass("player")) 
				if class == "PRIEST" then 
					self.heal = "Lesser Heal"
				elseif class == "MAGE" then 
					self.heal = "Arcane Brilliance"
				elseif class == "DRUID" then 
					self.heal = "Healing Touch" elseif 
				class == "PALADIN" then 
					self.heal = "Holy Light" 
				elseif class == "SHAMAN" then 
					self.heal = "Healing Wave"
				end
			]],
			OnUpdate = [[
				if CheckInteractDistance(self.unit, 1) then 
					self:SetAlpha(1) 
					self:SetBackdropColor(0, 0, 0, 0.75) 
				elseif self.heal and IsSpellInRange(self.heal, self.unit) == 1 then
					self:SetAlpha(1) 
					self:SetBackdropColor(1, 0, 0, 0.75)
				else 
					self:SetAlpha(0.5) 
					self:SetBackdropColor(0, 0, 0, 0.75) 
				end
			]],
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 170, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -3, 15 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 170, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT",-3, 2 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "BOTTOMLEFT", "$parent", "LEFT", 20, -62 },
				},
				target = { template = "Nurfed_Unit_mini_party", Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 175, 0 } },
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, -2 } },
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
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", 1, 0 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff1", "RIGHT", 1, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff2", "RIGHT", 1, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff3", "RIGHT", 1, 0 } },
				debuff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOP", "$parentdebuff1", "BOTTOM", 1, 0 } },
				debuff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff5", "RIGHT", 1, 0 } },
				debuff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff6", "RIGHT", 1, 0 } },
				debuff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentdebuff7", "RIGHT", 1, 0 } },
				highlight = {
					type = "Texture",
					size = { 160, 10 },
					layer = "ARTWORK",
					Texture = "Interface\\QuestFrame\\UI-QuestTitleHighlight",
					BlendMode = "ADD",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, -4 },
				},				
				leader = {
					type = "Texture",
					size = { 10, 10 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOP", "$parent", "TOP", 40, -4 },
				},
				master = {
					type = "Texture",
					size = { 9, 9 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOP", "$parent", "TOP", 28, -4 },
				},
				name = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 18, -4 },
					vars = { format = "$name" },
				},
				pet = {
					template = "Nurfed_Unit_mini_party_pet",
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 150, -38 },
				},
				level = {
					type = "FontString",
					size = { 20, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 3, -4 },
					vars = { format = "$level" },
				},
			},
			vars = { aurawidth = 272, aurasize = 17, enablePredictedStats = true },
		},
	}
	
	--Frame Design
	Nurfed_UnitsLayout.Layout = {
		player = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 176, 44 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { 0, 0, 0, 0.75 },
			Scale = 1.5,
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 170, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -3, 15 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 170, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT",-3, 2 },
				},
				xp = {
					template = "Nurfed_Unit_xp",
					size = { 170, 8 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, -4 },
				},
				model_frame = {
					template = "Nurfed_Model_frame",
					size = { 51, 52 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", -47, 4 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 42, 42 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 7, 4 },
				},
				leader = {
					type = "Texture",
					size = { 10, 10 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-LeaderIcon",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -19, -4 },
				},
				master = {
					type = "Texture",
					size = { 9, 9 },
					layer = "OVERLAY",
					Texture = "Interface\\GroupFrame\\UI-Group-MasterLooter",
					Anchor = { "TOP", "$parent", "TOP", 28, -4 },
				},
				name = {
					type = "FontString",
					size = { 65, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 18, -4 },
					vars = { format = "$name" },
				},
				level = {
					type = "FontString",
					size = { 20, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 3, -4 },
					vars = { format = "$level" },
				},
				group = {
					type = "FontString",
					size = { 50, 8 },
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 12, "NONE" },
					JustifyH = "LEFT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -20, -5 },
				},
   		        druidmanabar = {
      		        template = "Nurfed_Unit_mp",
					size = { 170, 8 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, -4 },
  			        vars = { hideFrame = "xp" },
 		        },
			},
			vars = { unit = "player", enablePredictedStats = true },
		},

		target = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 176, 44 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { 0, 0, 0, 0.75 },
			Scale = 1.5,
			Movable = true,
			Mouse = true,
			events = { "PLAYER_LOGIN" },
			OnEvent = [[
				local class = select(2, UnitClass("player")) 
					if class == "PRIEST" then 
						self.heal = "Lesser Heal" 
						self.harm = "Shadow Word: Pain" 
					elseif class == "MAGE" then 
						self.heal = "Arcane Brilliance" 
						self.harm = "Fireball" 
					elseif class == "DRUID" then 
						self.heal = "Healing Touch" 
						self.harm = "Cyclone" 
					elseif class == "WARLOCK" then 
						self.heal = "Unending Breath" 
						self.harm = "Shadowbolt" 
					elseif class == "PALADIN" then 
						self.heal = "Holy Light" 
						self.harm = "Hammer of Wrath" 
					elseif class == "SHAMAN" then 
						self.heal = "Healing Wave" 
						self.harm = "Lightning Bolt" 
					end
			]],
			OnUpdate = [[
				if CheckInteractDistance(self.unit, 1) then 
					self:SetAlpha(1) 
					self:SetBackdropColor(0, 0, 0, 0.75) 
				elseif self.heal and (IsSpellInRange(self.heal, self.unit) == 1 or IsSpellInRange(self.harm, self.unit) == 1) then 
					self:SetAlpha(1) 
					self:SetBackdropColor(1, 0, 0, 0.75) 
				else 
					self:SetAlpha(0.5) 
					self:SetBackdropColor(0, 0, 0, 0.75) 
				end
			]],
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 170, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -3, 15 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 170, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT",-3, 2 },
				},
				model_frame = {
					template = "Nurfed_Model_frame",
					size = { 51, 52 },
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", -47, 4 },
				},
				model = {
					template = "Nurfed_Unit_model",
					size = { 42, 42 },
					Anchor = { "BOTTOMLEFT", "$parentmodel_frame", "BOTTOMLEFT", 7, 4 },
				},
				target = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 44 } },
				targettarget = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 0, 44 } },
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, -2 } },
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
				name = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 25, -4 },
					vars = { format = "$name" },
				},
				level = {
					type = "FontString",
					size = { 20, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 3, -4 },
					vars = { format = "$level" },
				},
				hpperc = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					TextColor = { 1, 0, 0 },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, -4 },
					vars = { format = "$perc" },
				},
				combo = {
					type = "FontString",
					layer = "OVERLAY",
					Font = { NRF_FONT.."Charcoal.ttf", 22, "OUTLINE" },
					JustifyH = "RIGHT",
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMRIGHT", -2, 3 },
			        vars = { unit1 = "player", unit2 = "target" },
				},
				raidtarget = {
					type = "Texture",
					Texture = "Interface\\TargetingFrame\\UI-RaidTargetingIcons",
					size = { 15, 15 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parent", "TOPRIGHT", 0, -4 },
					Hide = true,
				},
			},
			vars = { unit = "target", enablePredictedStats = true },
		},

		focus = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 176, 44 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { 0, 0, 0, 0.75 },
			Scale = 1.5,
			Movable = true,
			Mouse = true,
			events = { "PLAYER_LOGIN" },
			OnEvent = [[
				local class = select(2, UnitClass("player")) 
				if class == "PRIEST" then 
					self.heal = "Lesser Heal" 
					self.harm = "Shadow Word: Pain" 
				elseif class == "MAGE" then 
					self.heal = "Arcane Brilliance" 
					self.harm = "Fireball" 
				elseif class == "DRUID" then 
					self.heal = "Healing Touch" 
					self.harm = "Cyclone" 
				elseif class == "WARLOCK" then 
					self.heal = "Unending Breath" 
					self.harm = "Shadowbolt" 
				elseif class == "PALADIN" then 
					self.heal = "Holy Light" 
					self.harm = "Hammer of Wrath" 
				elseif class == "SHAMAN" then 
					self.heal = "Healing Wave" 
					self.harm = "Lightning Bolt" 
				end
			]],
			OnUpdate = [[
				if CheckInteractDistance(self.unit, 1) then 
					self:SetAlpha(1) 
					self:SetBackdropColor(0, 0, 0, 0.75) 
				elseif self.heal and (IsSpellInRange(self.heal, self.unit) == 1 or IsSpellInRange(self.harm, self.unit) == 1) then 
					self:SetAlpha(1) 
					self:SetBackdropColor(1, 0, 0, 0.75) 
				else 
					self:SetAlpha(0.5) 
					self:SetBackdropColor(0, 0, 0, 0.75)
				end
			]],
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 170, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -3, 15 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 170, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT",-3, 2 },
				},
				name = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 18, -4 },
					vars = { format = "$name" },
				},
				level = {
					type = "FontString",
					size = { 20, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 3, -4 },
					vars = { format = "$level" },
				},
				hpperc = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					TextColor = { 1, 0, 0 },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, -4 },
					vars = { format = "$perc" },
				},
				target = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 44 } },
				targettarget = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 0, 44 } },
				buff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "TOPLEFT", "$parent", "BOTTOMLEFT", 0, -2 } },
				buff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff1", "RIGHT", 0, 0 } },
				buff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff2", "RIGHT", 0, 0 } },
				buff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff3", "RIGHT", 0, 0 } },
				buff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff4", "RIGHT", 0, 0 } },
				buff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff5", "RIGHT", 0, 0 } },
				buff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff6", "RIGHT", 0, 0 } },
				buff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "LEFT", "$parentbuff7", "RIGHT", 0, 0 } },
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, -40 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff1", "BOTTOMRIGHT", 0, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff2", "BOTTOMRIGHT", 0, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff3", "BOTTOMRIGHT", 0, 0 } },
				debuff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff4", "BOTTOMRIGHT", 0, 0 } },
				debuff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff5", "BOTTOMRIGHT", 0, 0 } },
				debuff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff6", "BOTTOMRIGHT", 0, 0 } },
				debuff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff7", "BOTTOMRIGHT", 0, 0 } },
			},
			vars = { unit = "focus", aurawidth = 160, enablePredictedStats = true },

		},

		pet = {
			type = "Button",
			uitemp = "SecureUnitButtonTemplate",
			size = { 176, 44 },
			FrameStrata = "LOW",
			ClampedToScreen = true,
			Backdrop = "Nurfed_Unit_backdrop",
			BackdropColor = { 0, 0, 0, 0.75 },
			Scale = 1,
			Movable = true,
			Mouse = true,
			children = {
				hp = {
					template = "Nurfed_Unit_hp",
					size = { 170, 14 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -3, 15 },
				},
				mp = {
					template = "Nurfed_Unit_mp",
					size = { 170, 12 },
					Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT",-3, 2 },
				},
				castingframe = {
					template = "Nurfed_Unit_casting",
					Anchor = { "BOTTOMLEFT", "$parent", "LEFT", 20, -62 },
				},
				name = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 18, -4 },
					vars = { format = "$name" },
				},
				level = {
					type = "FontString",
					size = { 20, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					JustifyH = "LEFT",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 3, -4 },
					vars = { format = "$level" },
				},
				hpperc = {
					type = "FontString",
					size = { 100, 9 },
					layer = "OVERLAY",
					FontObject = "Nurfed_Unit_Font",
					TextColor = { 1, 0, 0 },
					JustifyH = "RIGHT",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -5, -4 },
					vars = { format = "$perc" },
				},
				happiness = {
					type = "Texture",
					Texture = "Interface\\PetPaperDollFrame\\UI-PetHappiness",
					size = { 13, 13 },
					layer = "OVERLAY",
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 125, -1 },
					Hide = true,
				},
				target = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 44 } },
				targettarget = { template = "Nurfed_Unit_mini", Anchor = { "BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", 0, 44 } },
				debuff1 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, -40 } },
				debuff2 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff1", "BOTTOMRIGHT", 0, 0 } },
				debuff3 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff2", "BOTTOMRIGHT", 0, 0 } },
				debuff4 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff3", "BOTTOMRIGHT", 0, 0 } },
				debuff5 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff4", "BOTTOMRIGHT", 0, 0 } },
				debuff6 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff5", "BOTTOMRIGHT", 0, 0 } },
				debuff7 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff6", "BOTTOMRIGHT", 0, 0 } },
				debuff8 = { type = "Button", uitemp = "TargetDebuffButtonTemplate", Anchor = { "BOTTOMLEFT", "$parentdebuff7", "BOTTOMRIGHT", 0, 0 } },
			},
			vars = { unit = "pet", aurawidth = 160, enablePredictedStats = true },
		},

		Nurfed_party1 = { template = "Nurfed_Party", vars = { unit = "party1" } },
		Nurfed_party2 = { template = "Nurfed_Party", vars = { unit = "party2" } },
		Nurfed_party3 = { template = "Nurfed_Party", vars = { unit = "party3" } },
		Nurfed_party4 = { template = "Nurfed_Party", vars = { unit = "party4" } },
	}
end