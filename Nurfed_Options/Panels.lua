------------------------------------------
-- Option Menu Panels
local hptype = { "class", "fade", "script", "pitbull" }
local mptype = { "normal", "class", "fade", "pitbull" }
local auras = { "all", "curable", "yours" }
local units = { "", "focus", "party1", "party2", "party3", "party4", "pet", "player", "target", "targettarget" }
local states = { "stance:", "stealth:", "actionbar:", "shift:", "ctrl:", "alt:" }
local visible = { "show", "hide", "combat", "nocombat", "exists" }
local setupFrameName, setupParentName, setupPoints


local updateoptions = function()
	local bar = Nurfed_MenuActionBars.bar
	if bar then
		local vals = NURFED_ACTIONBARS[bar]
		Nurfed_MenuActionBarsbarrows:SetValue(vals.rows)
		Nurfed_MenuActionBarsbarcols:SetValue(vals.cols)
		Nurfed_MenuActionBarsbarscale:SetValue(vals.scale)
		Nurfed_MenuActionBarsbaralpha:SetValue(vals.alpha)
		Nurfed_MenuActionBarsbarunit:SetText(vals.unit or "")
		Nurfed_MenuActionBarsbarvisible:SetText(vals.visible or "")
		Nurfed_MenuActionBarsbaruseunit:SetChecked(vals.useunit)
		Nurfed_MenuActionBarsbarxgap:SetValue(vals.xgap)
		Nurfed_MenuActionBarsbarygap:SetValue(vals.ygap)
	end
end

local addstate = function()
	local bar = Nurfed_MenuActionBars.bar
	if bar then
		local statemaps = NURFED_ACTIONBARS[bar].statemaps
		local state = Nurfed_MenuActionBarsstatesstate:GetText()
		local map = Nurfed_MenuActionBarsstatesmap:GetText()
		state = string.trim(state)
		map = string.trim(map)
		if map == "" or state == "" then
			return
		end
		statemaps[state] = map
		Nurfed:updatebar(getglobal(bar))
		Nurfed_ScrollActionBarsStates()
		Nurfed_MenuActionBarsstatesstate:SetText("")
		Nurfed_MenuActionBarsstatesmap:SetText("")
		if this.ClearFocus then
			this:ClearFocus()
		end
	end
end

local updatebuttons = function()
	local btn = Nurfed_MenuActionBars.bar
	if btn then
		Nurfed_MenuActionBarsbuttondefaulttext:SetText(DEFAULT)
		Nurfed_MenuActionBarsbuttonhelptext:SetText(FACTION_STANDING_LABEL5)
		Nurfed_MenuActionBarsbuttonharmtext:SetText(FACTION_STANDING_LABEL2)
		btn = getglobal(btn)

		local value = btn:GetAttribute("state-parent")
		local helpv = SecureButton_GetModifiedAttribute(btn, "helpbutton", value)
		local harmv = SecureButton_GetModifiedAttribute(btn, "harmbutton", value)


		local default = SecureButton_GetModifiedAttribute(btn, "type", value)
		local help = SecureButton_GetModifiedAttribute(btn, "type", helpv)
		local harm = SecureButton_GetModifiedAttribute(btn, "type", harmv)

		local seticon = function(opt, val, name)
			local texture, stext
			local button = getglobal("Nurfed_MenuActionBarsbutton"..name)
			local icon = getglobal("Nurfed_MenuActionBarsbutton"..name.."Icon")
			local text = getglobal("Nurfed_MenuActionBarsbutton"..name.."Name")
			button.spell = nil
			button.item = nil
			if opt then
				local spell = SecureButton_GetModifiedAttribute(btn, opt, val)
				if spell then
					if opt == "spell" then
						texture = GetSpellTexture(spell)
						button.spell = spell
					elseif opt == "item" then
						texture = select(10, GetItemInfo(spell))
						button.item = spell
					elseif opt == "macro" then
						texture = select(2, GetMacroInfo(spell))
						stext = spell
					end
				end
				button.opt = opt
			end
			icon:SetTexture(texture)
			text:SetText(stext)
		end

		seticon(default, value, "default")
		seticon(help, helpv, "help")
		seticon(harm, harmv, "harm")
	end
end

local addnew = function()
	local objtype = this:GetObjectType()
	if objtype == "Button" then
		this = this:GetParent()
	end
	local text = this:GetText()
	if text ~= "" and not NURFED_ACTIONBARS[text] then
		local unit = Nurfed_MenuActionBarsbarunit:GetText()
		unit = string.trim(unit)
		if unit == "" then unit = nil end
		NURFED_ACTIONBARS[text] = {
			unit = unit,
			rows = Nurfed_MenuActionBarsbarrows:GetValue(),
			cols = Nurfed_MenuActionBarsbarcols:GetValue(),
			scale = Nurfed_MenuActionBarsbarscale:GetValue(),
			alpha = Nurfed_MenuActionBarsbaralpha:GetValue(),
			xgap = Nurfed_MenuActionBarsbarxgap:GetValue(),
			ygap = Nurfed_MenuActionBarsbarygap:GetValue(),
			visible = Nurfed_MenuActionBarsbarvisible:GetText(),
			useunit = Nurfed_MenuActionBarsbaruseunit:GetChecked(),
			buttons = {},
			statemaps = {},
		}
		Nurfed:createbar(text)
		this:SetText("")
		Nurfed_ScrollActionBars()
	end
end

local updatebar = function(self)
	local bar = Nurfed_MenuActionBars.bar
	if bar then
		local value
		local objtype = self:GetObjectType()
		if objtype == "Slider" then
			value = self:GetValue()
		elseif objtype == "CheckButton" then
			value = self:GetChecked()
		elseif objtype == "EditBox" then
			value = self:GetText()
			if self.val ~= "unit" and self.val ~= "visible" then
				value = tonumber(value)
			end
			self:ClearFocus()
		elseif objtype == "Button" then
			value = self:GetText()
		end
		NURFED_ACTIONBARS[bar][self.val] = value

		local hdr = getglobal(bar)
		if self.val == "scale" then
			hdr:SetScale(value)
		elseif self.val == "unit" then
			if value == "" then value = nil end
			if hdr:GetAttribute("unit") ~= value then
				hdr:SetAttribute("unit", value)
				Nurfed:updatebar(hdr)
			end
		elseif self.val == "useunit" then
			hdr:SetAttribute("useunit", value)
		elseif self.val == "alpha" then
			local children = { hdr:GetChildren() }
			for _, child in ipairs(children) do
				child:SetAlpha(value)
			end
		else
			Nurfed:updatebar(hdr)
			Nurfed_ScrollActionBars()
		end
	end
end

local ondragstart = function(self)
	local btn = Nurfed_MenuActionBars.bar
	btn = getglobal(btn)
	local id = btn:GetID()
	local parent = btn:GetParent():GetName()
	local value = "-"..btn:GetAttribute("state-parent")
	local prefix = "*"
	if IsModifierKeyDown() then
		prefix = SecureButton_GetModifierPrefix()
	end

	if self.t then
		btn:SetAttribute(prefix..self.t..value, nil)
		value = "-"..self.s..value
	else
		value = "*"
	end
	btn:SetAttribute(prefix.."type"..value, nil)
	btn:SetAttribute(prefix..self.opt..value, nil)

	updatebuttons()
end

local onreceivedrag = function(self)
	local btn = Nurfed_MenuActionBars.bar
	btn = getglobal(btn)
	local cursoritem = Nurfed:getcursor()
	if cursoritem then
		local id = btn:GetID()
		local parent = btn:GetParent():GetName()
		local value = "-"..btn:GetAttribute("state-parent")
		local prefix = "*"
		if IsModifierKeyDown() then
			prefix = SecureButton_GetModifierPrefix()
		end

		if self.t then
			btn:SetAttribute(prefix..self.t..value, self.s..value)
			value = "-"..self.s..value
		else
			value = "*"
		end

		btn:SetAttribute(prefix.."type"..value, cursoritem[2])
		btn:SetAttribute(prefix..cursoritem[2]..value, cursoritem[1])
		if cursoritem[2] == "spell" then
			btn:SetAttribute(prefix.."item"..value, nil)
			btn:SetAttribute(prefix.."macro"..value, nil)
		elseif cursoritem[2] == "item" then
			btn:SetAttribute(prefix.."spell"..value, nil)
			btn:SetAttribute(prefix.."macro"..value, nil)
		elseif cursoritem[2] == "macro" then
			btn:SetAttribute(prefix.."spell"..value, nil)
			btn:SetAttribute(prefix.."item"..value, nil)
		end
		ClearCursor()
		updatebuttons()
	end
end

local onenter = function(self)
	if self.spell or self.item then
		GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT")

		if self.spell then
			local id, rank, book = Nurfed:getspells(self.spell)
			GameTooltip:SetSpell(id, book)
			GameTooltipTextLeft1:SetText(self.spell)
		elseif self.item then
			GameTooltip:SetHyperlink(select(2, GetItemInfo(self.item)))
		end
		GameTooltip:Show()
	end
end

local onleave = function(self)
	GameTooltip:Hide()
end

local postclick = function(self)
	self:SetChecked(nil)
	onreceivedrag(self)
end

local onkeydown = function(self, arg1)
	local keyPressed = arg1
	local screenshotKey = GetBindingKey("SCREENSHOT")
	if keyPressed == "ESCAPE" then
		HideUIPanel(Nurfed_Menu)
	elseif screenshotKey and keyPressed == screenshotKey then
		Screenshot()
	elseif keyPressed == "SHIFT" or keyPressed == "CTRL" or keyPressed == "ALT" then
		updatebuttons()
	else
		if IsShiftKeyDown() then keyPressed = "SHIFT-"..keyPressed end
		if IsControlKeyDown() then keyPressed = "CTRL-"..keyPressed end
		if IsAltKeyDown() then keyPressed = "ALT-"..keyPressed end
		local action = GetBindingAction(keyPressed)
		if action and not string.find(action, "^MOVE") and not string.find(action, "^TURN") and not string.find(action, "^JUMP") and not string.find(action, "^TARGET") and not string.find(action, "^TARGET") then
			RunBinding(action)
		end
	end
end

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
local import, checkonline, addonmsg, cancel, accept
do
	local layout, received, sendname, acceptname

	import = function()
		local templates = Nurfed_UnitsLayout.templates
		local frames = Nurfed_UnitsLayout.Layout or Nurfed_UnitsLayout.frames

		if templates then
			for k, v in pairs(templates) do
				NURFED_FRAMES.templates[k] = v
			end
		end

		if frames then
			for k, v in pairs(frames) do
				local name = k
				if not string.find(k, "^Nurfed") then
					name = "Nurfed_"..k
				end
				NURFED_FRAMES.frames[name] = v
			end
		end

		local out = "Nurfed Layout: |cffff0000Imported|r"

		if Nurfed_UnitsLayout.Name then
			out = out.." "..Nurfed_UnitsLayout.Name
		end

		if Nurfed_UnitsLayout.Author then
			out = out.." designed by "..Nurfed_UnitsLayout.Author
		end

		Nurfed:print(out, 1, 0, 0.75, 1)
		StaticPopup_Show("NRF_RELOADUI")
	end

	checkonline = function()
		for i = 1, GetNumFriends() do
			local name, level, class, area, connected, status = GetFriendInfo(i)
			if name == sendname then
				return connected
			end
		end

		for i = 1, GetNumGuildMembers() do
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status = GetGuildRosterInfo(i)
			if name == sendname then
				return online
			end
		end
	end

	accept = function()
		received = {}
		SendAddonMessage("Nurfed:Lyt", "receive", "WHISPER", acceptname)
		Nurfed_MenuFramessend:Disable()
		Nurfed_MenuFramesaccept:Disable()
		Nurfed_MenuFramescancel:Enable()
	end

	cancel = function(nosend)
		if not nosend then
			SendAddonMessage("Nurfed:Lyt", "cancel", "WHISPER", (sendname or acceptname))
		end
		if sendname then
			Nurfed:unschedule(Nurfed_SendLayout, true)
		end
		Nurfed_MenuFramesprogress:Hide()
		Nurfed_MenuFramescancel:Disable()
		Nurfed_MenuFramessend:Enable()
		layout = nil
		sendname = nil
		received = nil
		acceptname = nil
	end

	addonmsg = function(name, cmd)
		if cmd == "send" then
			Nurfed_MenuFramesaccept:Enable()
			acceptname = name
		elseif cmd == "receive" then
			layout = Nurfed:serialize("Nurfed_UnitsLayout", NURFED_FRAMES)
			Nurfed_MenuFramesprogress:SetMinMaxValues(0, #layout)
			Nurfed_MenuFramesprogress:SetValue(#layout)
			Nurfed_MenuFramesprogress:Show()
			Nurfed_MenuFramesprogressname:SetText(sendname)
			Nurfed_MenuFramesprogresscount:SetText(#layout)
			Nurfed_MenuFramesprogresstotal:SetText(#layout)
			Nurfed_MenuFramescancel:Enable()
			Nurfed_MenuFramessend:Disable()
			SendAddonMessage("Nurfed:Lyt", "count:"..#layout, "WHISPER", sendname)
			Nurfed:schedule(0.03, Nurfed_SendLayout, true)
		elseif cmd == "complete" then
			Nurfed_MenuFramessend:Enable()
			received = table.concat(received)
			Nurfed_UnitsLayout = loadstring(received)
			Nurfed_UnitsLayout()
			if Nurfed_UnitsLayout then
				Nurfed_MenuFramesimport:Enable()
			end
			Nurfed_MenuFramesprogress:Hide()
			received = nil
			acceptname = nil
		elseif cmd == "cancel" then
			cancel(true)
		elseif string.find(cmd, "^count") then
			local _, count = string.split(":", cmd)
			Nurfed_MenuFramesprogress:SetMinMaxValues(0, tonumber(count))
			Nurfed_MenuFramesprogress:SetValue(0)
			Nurfed_MenuFramesprogress:Show()
			Nurfed_MenuFramesprogressname:SetText(acceptname)
			Nurfed_MenuFramesprogresscount:SetText(0)
			Nurfed_MenuFramesprogresstotal:SetText(count)
		elseif name == acceptname then
			table.insert(received, cmd)
			Nurfed_MenuFramesprogress:SetValue(#received)
			Nurfed_MenuFramesprogresscount:SetText(#received)
		end
	end

	Nurfed:addmsg("Lyt", addonmsg)

	function Nurfed_SendLayout()
		if #layout > 0 then
			local text = table.remove(layout, 1)
			text = string.trim(text)
			local size = string.len(text)
			if size > 240 then
				local count = ceil(size / 240)
				for i = 1, count do
					local snip = string.sub(text, 1, 240)
					SendAddonMessage("Nurfed:Lyt", snip, "WHISPER", sendname)
					text = string.sub(text, 241)
				end
			else
				SendAddonMessage("Nurfed:Lyt", text, "WHISPER", sendname)
			end
			Nurfed_MenuFramesprogress:SetValue(#layout)
			Nurfed_MenuFramesprogresscount:SetText(#layout)
		else
			SendAddonMessage("Nurfed:Lyt", "complete", "WHISPER", sendname)
			Nurfed:unschedule(Nurfed_SendLayout, true)
			Nurfed_MenuFramesprogress:Hide()
			Nurfed_MenuFramescancel:Disable()
			Nurfed_MenuFramessend:Enable()
			layout = nil
			sendname = nil
		end
	end
end
local panels = {
  -- Chat Panel
  {
	name = "Chat",
	subtext = "Options that affect the appearance of chat messages and alerts sent to the chat frames.",
	menu = {
		check1 = {
			template = "nrf_check",
			Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
			vars = { text = NRF_PINGWARNING, option = "ping" },
		},
		check2 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, -8 },
			vars = { text = NRF_CHATTIMESTAMPS, option = "timestamps" },
		},
		check3 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, -8 },
			vars = { text = NRF_RAIDGROUP, option = "raidgroup" },
		},
		check4 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 0, -8 },
			vars = { text = NRF_RAIDCLASS, option = "raidclass" },
		},
		check5 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck4", "BOTTOMLEFT", 0, -8 },
			vars = { text = NRF_CHATBUTTONS, option = "chatbuttons", func = function() nrf_togglechat() end },
		},
		check6 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck5", "BOTTOMLEFT", 0, -8 },
			vars = { text = NRF_CHATPREFIX, option = "chatprefix" },
		},
		check7 = {
			template = "nrf_check",
			Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -8 },
			vars = { text = NRF_CHATFADE, option = "chatfade", func = function() nrf_togglechat()
				-- Note to Tivs:
				-- I need a disabled = boolean(or function that returns boolean) option in vars
				-- to be able to alpha / enablemouse for options that are no longer relevant based on other options
				-- example: disabled = function(self) return not Nurfed:getopt("chatfade") end,
				-- that would return true if Chat Fading is turned on, hence enable the slider for the time
				-- otherwise it would return false and shade out and disable the slider option as its nolonger needed
				-- this would prevent a lot of redundancy and make it easier on the users and myself
				-- Also the onshow(self) func in Templates.lua should be fired for all visible options 
				-- anytime the saveopt() func is fired to make sure that all values are proper.
				-- The disabled function should also fire anytime the saveopt() is fired.
				if Nurfed:getopt("chatfade") then
					NurfedChatPanelslider1:SetAlpha(1)
					NurfedChatPanelslider1:EnableMouse(true)
					NurfedChatPanelslider1:EnableMouseWheel(true)
					NurfedChatPanelslider1value:SetAlpha(1)
					NurfedChatPanelslider1value:EnableMouse(true)
				else
					NurfedChatPanelslider1:SetAlpha(0.5)
					NurfedChatPanelslider1:EnableMouse(false)
					NurfedChatPanelslider1:EnableMouseWheel(false)
					NurfedChatPanelslider1value:SetAlpha(0.5)
					NurfedChatPanelslider1value:EnableMouse(false)
				end
			end },
		},
		slider1 = {
			template = "nrf_slider",
			Anchor = { "TOPRIGHT", "$parentcheck7", "BOTTOMRIGHT", 0, -24 },
			vars = {
				text = NRF_CHATFADETIME,
				option = "chatfadetime",
				low = 0,
				high = 250,
				min = 0,
				max = 250,
				step = 1,
				format = "%.0f",
				func = function() nrf_togglechat() end,
			},
			-- this whole function could be removed if the above mention note is added in.  <3 u tivs
			-- I would like to add this into a lot of different spots but I wont, more of a proof of concept
			-- for right now so you know what I am talking about
			OnShow = function(self)
				NurfedTemplatesOnShow(self)
				if Nurfed:getopt("chatfade") then
					self:SetAlpha(1)
					self:EnableMouse(true)
					self:EnableMouseWheel(true)
					_G[self:GetName().."value"]:SetAlpha(1)
					_G[self:GetName().."value"]:EnableMouse(true)
				else
					self:SetAlpha(0.5)
					self:EnableMouse(false)
					self:EnableMouseWheel(false)
					_G[self:GetName().."value"]:SetAlpha(0.5)
					_G[self:GetName().."value"]:EnableMouse(false)
				end
			end,
		},
		input1 = {
			template = "nrf_editbox",
			Anchor = { "TOPRIGHT", "$parentslider1", "BOTTOMRIGHT", 0, -32 },
			vars = { text = NRF_TIMESTAMP, option = "timestampsformat" },
		},
	},
},
  -- General Panel
  {
    name = "General",
    subtext = "General options for Nurfed that affect default UI elements and appearance.",
    menu = {
		scroll = {
			template = "nrf_scroll",
			vars = { pages = 2 },
			size = { 360, 320 },
			Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 5, -8 },
		},
		scrollbg = {
			type = "Frame",
			Anchor = { "TOPRIGHT", "$parentscroll", "TOPRIGHT", 25, 6 },
			size = { 24, 330 },
			Backdrop = { 
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
				edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
				tile = true, 
				tileSize = 12, 
				edgeSize = 12, 
				insets = { left = 2, right = 2, top = 2, bottom = 2 }, 
			},
			BackdropColor = { 0, 0, 0, 0.5 },
		},
		check1 = {
			template = "nrf_check",
			Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
			vars = { text = NRF_UNTRAINABLE, option = "traineravailable", page = 1 },
		},
		check2 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, -8 },
			vars = { text = NRF_AUTOINVITE, option = "autoinvite", page = 1 },
		},
		check3 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, -8 },
			vars = { text = "Invite Reply", option = "invitetext", page = 1 },
		},
		check4 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 0, -8 },
			vars = { text = "Square Minimap", option = "squareminimap", page = 1 },
		},
		check5 = {
			template = "nrf_check",
			Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -8 },
			vars = { text = NRF_AUTOREPAIR, option = "repair", page = 1 },
		},
		check6 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck4", "BOTTOMLEFT", 0, -8 },
			vars = { text = "Show Binding Text", option = "showbindings", func = function() Nurfed:sendevent("UPDATE_BINDINGS") end, page = 1 },
		},
		slider1 = {
			template = "nrf_slider",
			Anchor = { "TOPRIGHT", "$parentcheck5", "BOTTOMRIGHT", 0, -24 },
			vars = {
				text = NRF_REPAIRLIMIT,
				option = "repairlimit",
				low = 0,
				high = 800,
				min = 0,
				max = 800,
				step = 5,
				bigStep = 50,
				format = "%.0f",
				page = 1
			},
		},
		input1 = {
			template = "nrf_editbox",
			Anchor = { "TOPLEFT", "$parentslider1", "BOTTOMLEFT", 0, -30 },
			vars = { text = NRF_KEYWORD, option = "keyword", page = 1 },
		},
		check7 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck6", "BOTTOMLEFT", 0, -15 },
			vars = { text = "Disable Casting Bar", option = "hidecasting", right = true, func = function() nrf_togglcast() end, page = 1 },
		},
		check8 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck7", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Show Action Tooltips", option = "tooltips", right = true, page = 1 },
		},
		check9 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck8", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Fade In Actions", option = "fadein", right = true, page = 1 },
		},
		check10 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck9", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Hide Main Bar", option = "hidemain", right = true, func = function() nrf_mainmenu() end, page = 1 },
		},
		-- page 2
		check11 = {
			template = "nrf_check",
			Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
			vars = { text = "Show Bags", option = "bagsshow", func = function() nrf_updatemainbar("bags") end, page = 2 },
		},
		check12 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck11", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Vertical Bags", option = "bagsvert", func = function() nrf_updatemainbar("bags") end, page = 2 },
		},
		check13 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck12", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Show Micro", option = "microshow", func = function() nrf_updatemainbar("micro") end, page = 2 },
		},
		check14 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck13", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Show Stance", option = "stanceshow", func = function() nrf_updatemainbar("stance") end, page = 2 },
		},
		check15 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck14", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Vertical Stance", option = "stancevert", func = function() nrf_updatemainbar("stance") end, page = 2 },
		},
		check16 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck15", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Show Pet Bar", option = "petbarshow", func = function() nrf_updatemainbar("petbar") end, page = 2 },
		},
		check17 = {
			template = "nrf_check",
			Anchor = { "TOPLEFT", "$parentcheck16", "BOTTOMLEFT", 0, -2 },
			vars = { text = "Vertical Pet Bar", option = "petbarvert", func = function() nrf_updatemainbar("petbar") end, page = 2 },
		},
		slider2 = {
			template = "nrf_slider",
			Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -10 },
			vars = {
				text = "Bags Scale",
				option = "bagsscale",
				low = "25%",
				high = "100%",
				min = 0.25,
				max = 1,
				step = 0.01,
				deci = 2,
				format = "%.2f",
				right = true,
				func = function() nrf_updatemainbar("bags") end,
				page = 2,
			},
		},
		slider3 = {
			template = "nrf_slider",
			Anchor = { "TOP", "$parentslider2", "BOTTOM", 0, -30 },
			vars = {
				text = "Micro Scale",
				option = "microscale",
				low = "25%",
				high = "100%",
				min = 0.25,
				max = 1,
				step = 0.01,
				deci = 2,
				format = "%.2f",
				right = true,
				func = function() nrf_updatemainbar("micro") end,
				page = 2,
			},
		},
		slider4 = {
			template = "nrf_slider",
			Anchor = { "TOP", "$parentslider3", "BOTTOM", 0, -30 },
			vars = {
				text = "Stance Scale",
				option = "stancescale",
				low = "25%",
				high = "100%",
				min = 0.25,
				max = 1,
				step = 0.01,
				deci = 2,
				format = "%.2f",
				right = true,
				func = function() nrf_updatemainbar("stance") end,
				page = 2,
			},
		},
		slider5 = {
			template = "nrf_slider",
			Anchor = { "TOP", "$parentslider4", "BOTTOM", 0, -30 },
			vars = {
				text = "Pet Bar Scale",
				option = "petbarscale",
				low = "25%",
				high = "100%",
				min = 0.25,
				max = 1,
				step = 0.01,
				deci = 2,
				format = "%.2f",
				right = true,
				func = function() nrf_updatemainbar("petbar") end,
				page = 2,
			},
		},
		slider6 = {
			template = "nrf_slider",
			Anchor = { "TOP", "$parentslider5", "BOTTOM", 0, -30 },
			vars = {
				text = "Pet Offset",
				option = "petbaroffset",
				low = -20,
				high = 20,
				min = -20,
				max = 20,
				step = 1,
				format = "%.0f",
				page = 2,
				func = function() nrf_updatemainbar("petbar") end,
			},
		},

	},
  },
--[[  
  {
	name = "ActionBars",
	subtext = "Action Bar options",
	Hide = true,
	menu = {
		actionbar = {
			type = "Frame",
			template = "nrf_options",
			size = { 500, 500 },
			anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, 0 },
			children = {
				scroll = {
					type = "ScrollFrame",
					size = { 165, 250 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
					uitemp = "FauxScrollFrameTemplate",
					OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollActionBars) end,
					OnShow = function() Nurfed_ScrollActionBars() end,
				},
				backing = {
					type = "Frame",
					size = { 173, 250 },
					Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
					BackdropColor = { 0, 0, 0, 0 },
					Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 0, 0 },
				},
				add = {
					template = "nrf_editbox",
					size = { 130, 18 },
					children = {
						add = {
							template = "nrf_button",
							Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
							Text = NEW,
							OnClick = addnew,
						},
					},
					OnEnterPressed = addnew,
					Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 5, -4 },
				},
				bar = {
					type = "Frame",
					size = { 230, 100 },
					Anchor = { "TOPRIGHT", -5, 0 },
					children = {
						unit = {
							template = "nrf_editbox",
							size = { 75, 18 },
							Anchor = { "TOPLEFT", 0, -7 },
							children = {
								add = {
									template = "nrf_button",
									Anchor = { "LEFT", "$parent", "RIGHT", 0, 0 },
									Text = "Unit",
									OnClick = function() Nurfed_DropMenu(units) end,
								},
							},
							OnTextChanged = function(self) updatebar(self) end,
							OnEnterPressed = function(self) updatebar(self) end,
							vars = { val = "unit", default = "target" },
						},
						useunit = {
							template = "nrf_check",
							Anchor = { "TOPRIGHT", 0, -7 },
							OnClick = function(self) updatebar(self) end,
							vars = { text = "Harm / Help", val = "useunit" },
						},
						visible = {
							template = "nrf_editbox",
							size = { 135, 18 },
							Anchor = { "TOPLEFT", "$parentunit", "BOTTOMLEFT", 0, -7 },
							children = {
								add = {
									template = "nrf_button",
									Anchor = { "LEFT", "$parent", "RIGHT", 0, 0 },
									Text = "Visible",
									OnClick = function() Nurfed_DropMenu(visible) end,
								},
							},
							--OnTextChanged = function(self) updatebar(self) end,
							OnEnterPressed = function(self) updatebar(self) end,
							vars = { val = "visible", default = "show" },
						},
						rows = {
							template = "nrf_slider",
							Anchor = { "TOPLEFT", "$parentvisible", "BOTTOMLEFT", 0, -13 },
							vars = {
								text = "Rows",
								val = "rows",
								low = 1,
								high = 24,
								min = 1,
								max = 24,
								step = 1,
								format = "%.0f",
								right = true,
								default = 1,
							},
							OnMouseUp = function(self) updatebar(self) end,
						},
						cols = {
							template = "nrf_slider",
							Anchor = { "TOPRIGHT", "$parentrows", "BOTTOMRIGHT", 0, -18 },
							vars = {
								text = "Columns",
								val = "cols",
								low = 1,
								high = 24,
								min = 1,
								max = 24,
								step = 1,
								format = "%.0f",
								right = true,
								default = 12,
							},
							OnMouseUp = function(self) updatebar(self) end,
						},
						scale = {
							template = "nrf_slider",
							Anchor = { "TOPRIGHT", "$parentcols", "BOTTOMRIGHT", 0, -18 },
							vars = {
								text = "Scale",
								val = "scale",
								low = "25%",
								high = "300%",
								min = 0.25,
								max = 3,
								step = 0.01,
								format = "%.2f",
								deci = 2,
								right = true,
								default = 1,
							},
							OnMouseUp = function(self) updatebar(self) end,
						},
						alpha = {
							template = "nrf_slider",
							Anchor = { "TOPRIGHT", "$parentscale", "BOTTOMRIGHT", 0, -18 },
							vars = {
								text = "Alpha",
								val = "alpha",
								low = "0%",
								high = "100%",
								min = 0,
								max = 1,
								step = 0.01,
								format = "%.2f",
								deci = 2,
								right = true,
								default = 1,
							},
							OnMouseUp = function(self) updatebar(self) end,
						},
						xgap = {
							template = "nrf_slider",
							Anchor = { "TOPRIGHT", "$parentalpha", "BOTTOMRIGHT", 0, -18 },
							vars = {
								text = "X Gap",
								val = "xgap",
								low = -2,
								high = 50,
								min = -2,
								max = 50,
								step = 1,
								format = "%.0f",
								right = true,
								default = 2,
							},
							OnMouseUp = function(self) updatebar(self) end,
						},
						ygap = {
							template = "nrf_slider",
							Anchor = { "TOPRIGHT", "$parentxgap", "BOTTOMRIGHT", 0, -18 },
							vars = {
								text = "Y Gap",
								val = "ygap",
								low = -2,
								high = 50,
								min = -2,
								max = 50,
								step = 1,
								format = "%.0f",
								right = true,
								default = 2,
							},
							OnMouseUp = function(self) updatebar(self) end,
						},
					},
				},
				button = {
					type = "Frame",
					size = { 100, 100 },
					uitemp = "SecureStateDriverTemplate",
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -20, -60 },
					--Keyboard = true,
					children = {
						default = {
							type = "CheckButton",
							uitemp = "SecureActionButtonTemplate, ActionButtonTemplate",
							Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
							children = {
								text = {
									type = "FontString",
									Anchor = { "RIGHT", "$parent", "LEFT", -15, 0 },
									FontObject = "GameFontNormalHuge",
								},
							},
							OnEnter = onenter,
							OnLeave = onleave,
							PostClick = postclick,
							OnDragStart = ondragstart,
							OnReceiveDrag = onreceivedrag,
							OnAttributeChanged = updatebuttons,
						},
						help = {
							type = "CheckButton",
							uitemp = "SecureActionButtonTemplate, ActionButtonTemplate",
							Anchor = { "TOPRIGHT", "$parentdefault", "BOTTOMRIGHT", 0, -15 },
							children = {
								text = {
									type = "FontString",
									Anchor = { "RIGHT", "$parent", "LEFT", -15, 0 },
									FontObject = "GameFontNormalHuge",
								},
							},
							OnEnter = onenter,
							OnLeave = onleave,
							PostClick = postclick,
							OnDragStart = ondragstart,
							OnReceiveDrag = onreceivedrag,
							OnAttributeChanged = updatebuttons,
							vars = { t = "helpbutton", s = "heal" },
						},
						harm = {
							type = "CheckButton",
							uitemp = "SecureActionButtonTemplate, ActionButtonTemplate",
							Anchor = { "TOPRIGHT", "$parenthelp", "BOTTOMRIGHT", 0, -15 },
							children = {
								text = {
									type = "FontString",
									Anchor = { "RIGHT", "$parent", "LEFT", -15, 0 },
									FontObject = "GameFontNormalHuge",
								},
							},
							OnEnter = onenter,
							OnLeave = onleave,
							PostClick = postclick,
							OnDragStart = ondragstart,
							OnReceiveDrag = onreceivedrag,
							OnAttributeChanged = updatebuttons,
							vars = { t = "harmbutton", s = "nuke" },
						},
					},
					--OnKeyUp = updatebuttons,
					--OnKeyDown = onkeydown,
					Hide = true,
				},
				states = {
					type = "Frame",
					size = { 220, 100 },
					Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", 0, 0 },
					children = {
						state = {
							template = "nrf_editbox",
							size = { 160, 18 },
							children = {
								drop = {
									template = "nrf_button",
									Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
									Text = "State",
									OnClick = function() Nurfed_DropMenu(states) end,
								},
							},
							OnTabPressed = function() Nurfed_MenuActionBarsstatesmap:SetFocus() end,
							OnEnterPressed = addstate,
							Anchor = { "TOPLEFT", "$parent", "TOPLEFT", 0, -4 },
						},
						map = {
							template = "nrf_editbox",
							size = { 50, 18 },
							children = {
								add = {
									template = "nrf_button",
									Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
									Text = "State Value",
									OnClick = addstate,
								},
							},
							OnTabPressed = function() Nurfed_MenuActionBarsstatesstate:SetFocus() end,
							OnEnterPressed = addstate,
							Anchor = { "TOPLEFT", "$parentstate", "BOTTOMLEFT", 0, -5 },
						},
						scroll = {
							type = "ScrollFrame",
							size = { 170, 155 },
							Anchor = { "TOPLEFT", "$parentmap", "BOTTOMLEFT", 0, 0 },
							uitemp = "FauxScrollFrameTemplate",
							OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollActionBarsStates) end,
							OnShow = function() Nurfed_ScrollActionBarsStates() end,
						},
						["1"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parentscroll", "TOPLEFT", 0, -8 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["2"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["3"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["4"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent3", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["5"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent4", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["6"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent5", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["7"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent6", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["8"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent7", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["9"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent8", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
						["10"] = {
							template = "nrf_actionstates",
							Anchor = { "TOPLEFT", "$parent9", "BOTTOMLEFT", 0, 0 },
							OnClick = function() Nurfed_MenuActionBarsstatesstate:SetText(this.state) end,
						},
					},
					Hide = true,
				},
			},
			OnLoad = function()	Nurfed_GenerateMenu("ActionBars", "nrf_actionbars_row", 19) end,
			OnHide = function()
				Nurfed_MenuActionBarsbuttondefault:SetParent(Nurfed_MenuActionBarsbutton)
				Nurfed_MenuActionBarsbuttonhelp:SetParent(Nurfed_MenuActionBarsbutton)
				Nurfed_MenuActionBarsbuttonharm:SetParent(Nurfed_MenuActionBarsbutton)
			end,
			vars = { expand = {} },
		},
	},
},
]]
{
	name = "Setup",
	subtext = "Assist in setting up your UI",
	menu = {
		framename = {
			template = "nrf_editbox",
			Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, 10 },
			size = { 250, 18 },
			OnEnterPressed = function(self) setupFrameName = self:GetText() self:ClearFocus() end,
			OnEditFocusGained = function() this:HighlightText() this.focus = true end,
			OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			OnTextChanged = function(self) setupFrameName = self:GetText() end,
			OnTabPressed = function(self) self:ClearFocus() NurfedSetupPanelparentname:SetFocus() end,
			vars = { text = "Frame Name" },
		},
		parentname = {
			template = "nrf_editbox",
			Point = { "TOPLEFT", "$parentframename", "BOTTOMLEFT", 0, -18 },
			size = { 250, 18 },
			OnEnterPressed = function(self) setupParentName = self:GetText() self:ClearFocus() end,
			OnEditFocusGained = function() this:HighlightText() this.focus = true end,
			OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			OnTextChanged = function(self) setupParentName = self:GetText() end,
			OnTabPressed = function(self) self:ClearFocus() NurfedSetupPanelpointname:SetFocus() end,
			vars = { text = "Parent Name" },
		},
		pointname = {
			template = "nrf_editbox",
			Point = { "TOPLEFT", "$parentparentname", "BOTTOMLEFT", 0, -18 },
			size = { 250, 18 },
			OnEnterPressed = function(self) if not setupPoints then setupPoints = {} end; setupPoints[1] = self:GetText():upper() self:ClearFocus() end,
			OnEditFocusGained = function() this:HighlightText() this.focus = true end,
			OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			OnTextChanged = function(self) if not setupPoints then setupPoints = {} end; setupPoints[1] = self:GetText():upper() end,
			OnTabPressed = function(self) self:ClearFocus() NurfedSetupPanelpointname2:SetFocus() end,
			vars = { text = "Anchor From" },
		},
		pointname2 = {
			template = "nrf_editbox",
			Point = { "TOPLEFT", "$parentpointname", "BOTTOMLEFT", 0, -18 },
			size = { 250, 18 },
			OnEnterPressed = function(self) if not setupPoints then setupPoints = {} end; setupPoints[2] = self:GetText():upper() self:ClearFocus() end,
			OnEditFocusGained = function() this:HighlightText() this.focus = true end,
			OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			OnTextChanged = function(self) if not setupPoints then setupPoints = {} end; setupPoints[2] = self:GetText():upper() end,
			OnTabPressed = function(self) self:ClearFocus() NurfedSetupPanelpointname3:SetFocus() end,
			vars = { text = "Anchor To" },
		},
		pointname3 = {
			template = "nrf_editbox",
			Point = { "TOPLEFT", "$parentpointname2", "BOTTOMLEFT", 0, -18 },
			size = { 250, 18 },
			OnEnterPressed = function(self) if not setupPoints then setupPoints = {} end; setupPoints[3] = tonumber(self:GetText()) self:ClearFocus() end,
			OnEditFocusGained = function() this:HighlightText() this.focus = true end,
			OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			OnTextChanged = function(self) if not setupPoints then setupPoints = {} end; setupPoints[3] = tonumber(self:GetText()) end,
			OnTabPressed = function(self) self:ClearFocus() NurfedSetupPanelpointname4:SetFocus() end,
			vars = { text = "X Offset" },
		},
		pointname4 = {
			template = "nrf_editbox",
			Point = { "TOPLEFT", "$parentpointname3", "BOTTOMLEFT", 0, -18 },
			size = { 250, 18 },
			OnEnterPressed = function(self) if not setupPoints then setupPoints = {} end; setupPoints[4] = tonumber(self:GetText()) self:ClearFocus() end,
			OnEditFocusGained = function() this:HighlightText() this.focus = true end,
			OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
			OnTextChanged = function(self) if not setupPoints then setupPoints = {} end; setupPoints[4] = tonumber(self:GetText()) end,
			vars = { text = "Y Offset" },
		},
		executename = {
			template = "nrf_button",
			Text = "Execute",
			Point = { "TOPLEFT", "$parentpointname4", "BOTTOMLEFT", 0, 0 },
			OnClick = function() 
				local f = _G[setupFrameName]
				f:StartMoving()
				f:ClearAllPoints()
				f:SetPoint(setupPoints[1]:upper(), setupParentName or UIParent, setupPoints[2]:upper(), setupPoints[3] or 0, setupPoints[4] or 0)
				f:StopMovingOrSizing()
			end,
		},
	},
}, 
			
  -- Units Panel
  {
	name = "Units",
	subtext = "Options that effect the unit frames created by Nurfed.",
	menu = {
		check1 = {
			template = "nrf_check",
			Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, 10 },
			vars = { text = "Aura Cooldowns", option = "cdaura" },
		},
		check2 = {
			template = "nrf_check",
			Point = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, 0 },
			vars = { text = "Color Mana Background", option = "changempbg" },
		},
		check3 = {
			template = "nrf_check",
			Point = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, 0 },
			vars = { text = "Color Health Background", option = "changehpbg" },
		},
		swatch1 = {
			template = "nrf_color",
			Point = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 5, -5 },
			vars = { text = MANA, option = MANA, func = setmana },
		},
		swatch2 = {
			template = "nrf_color",
			Point = { "TOPLEFT", "$parentswatch1", "BOTTOMLEFT", 0, -5 },
			vars = { text = RAGE_POINTS, option = RAGE_POINTS, func = setmana },
		},
		swatch3 = {
			template = "nrf_color",
			Point = { "TOPLEFT", "$parentswatch2", "BOTTOMLEFT", 0, -5 },
			vars = { text = FOCUS_POINTS, option = FOCUS_POINTS, func = setmana },
		},
		swatch4 = {
			template = "nrf_color",
			Point = { "LEFT", "$parentswatch1", "RIGHT", 120, 0 },
			vars = { text = ENERGY_POINTS, option = ENERGY_POINTS, func = setmana },
		},
		swatch5 = {
			template = "nrf_color",
			Point = { "TOPRIGHT", "$parentswatch4", "BOTTOMRIGHT", 0, -5 },
			vars = { text = HAPPINESS_POINTS, option = HAPPINESS_POINTS, func = setmana },
		},
		button1 = {
			template = "nrf_optbutton",
			Anchor = { "TOPLEFT", "$parentswatch3", "BOTTOMLEFT", 55, -5 },
			OnClick = function() Nurfed_DropMenu(mptype) end,
			vars = { text = "MP Color", option = "mpcolor", func = setmp },
		},
		button2 = {
			template = "nrf_optbutton",
			Anchor = { "TOPLEFT", "$parentbutton1", "TOPRIGHT", 55, 0 },
			OnClick = function() Nurfed_DropMenu(hptype) end,
			vars = { text = "HP Color", option = "hpcolor", func = sethp },
		},
		hpscript = {
			template = "nrf_multiedit",
			size = { 350, 160 },
			Point = { "TOPLEFT", "$parentbutton1", "BOTTOMLEFT", -70, -7 },
			vars = { option = "hpscript", func = sethp },
		},
	},
},

  -- Combat Log Panel
  {
    name = "CombatLog",
    subtext = "Options that affect the combat log appearance.",
    addon = "Nurfed_CombatLog",
    menu = {},
  },

-- Frames Panel
	{ 
		name = "Frames",
		subtext = "Frames menu options",
		menu = {
			List = {
				type = "Frame",
				size = { 375, 332 },
				Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -14, 0 },
				children = {
					import = {
						template = "nrf_button",
						Text = "Import",
						Point = { "BOTTOMRIGHT", -3, 3 },
						OnClick = function() import() end,
					},
					export = {
						template = "nrf_button",
						Text = "Export Layout",
						Point = { "RIGHT", "$parentimport", "LEFT", -3, 0 },
						OnClick = function()
							NURFED_LAYOUT = Nurfed:copytable(NURFED_FRAMES)
							NURFED_LAYOUT.Author = UnitName("player")
							Nurfed:print("Nurfed Layout: |cffff0000Exported|r", 1, 0, 0.75, 1)
						end,
					},
					accept = {
						template = "nrf_button",
						Text = ACCEPT,
						Point = { "RIGHT", "$parentexport", "LEFT", -3, 0 },
						OnClick = function() accept() end,
					},
					send = {
						template = "nrf_button",
						Text = "Send Layout",
						Point = { "RIGHT", "$parentaccept", "LEFT", -3, 0 },
						OnClick = function(self)
							Nurfed_MenuFramessendname:ClearFocus()
							sendname = string.trim(Nurfed_MenuFramessendname:GetText())
							sendname = string.lower(sendname)
							sendname = string.capital(sendname)
							if sendname ~= UnitName("player") and checkonline() then
								Nurfed:print("Nurfed Layout: |cffff0000Send|r "..sendname, 1, 0, 0.75, 1)
								SendAddonMessage("Nurfed:Lyt", "send", "WHISPER", sendname)
							end
						end,
					},
					sendname = {
						template = "nrf_editbox",
						size = { 100, 18 },
						Point = { "RIGHT", "$parentsend", "LEFT", -1, 0 },
					},
					cancel = {
						template = "nrf_button",
						Text = CANCEL,
						Point = { "RIGHT", "$parentsendname", "LEFT", -3, 0 },
						OnClick = function() cancel() end,
					},
					progress = {
						type = "StatusBar",
						size = { 405, 12 },
						Hide = true,
						Point = { "BOTTOMLEFT", 3, 22 },
						StatusBarTexture = NRF_IMG.."statusbar5",
						StatusBarColor = { 0, 0.5, 1 },
						children = {
							name = {
								type = "FontString",
								layer = "ARTWORK",
								FontObject = "GameFontNormalSmall",
								JustifyH = "LEFT",
								ShadowColor = { 0, 0, 0, 0.75},
								ShadowOffset = { -1, -1 },
								Anchor = "all",
							},
							count = {
								type = "FontString",
								layer = "ARTWORK",
								FontObject = "GameFontNormalSmall",
								JustifyH = "CENTER",
								ShadowColor = { 0, 0, 0, 0.75},
								ShadowOffset = { -1, -1 },
								Anchor = "all",
							},
							total = {
								type = "FontString",
								layer = "ARTWORK",
								FontObject = "GameFontNormalSmall",
								JustifyH = "RIGHT",
								ShadowColor = { 0, 0, 0, 0.75},
								ShadowOffset = { -1, -1 },
								Anchor = "all",
							},
						},
					},
				},
				OnLoad = function(self)
					local import = getglobal(self:GetName().."import")
					local accept = getglobal(self:GetName().."accept")
					local cancel = getglobal(self:GetName().."cancel")
					if not Nurfed_UnitsLayout then
						import:Disable()
					end
					cancel:Disable()
					accept:Disable()
				end,
			},
		},
	},

  -- AddOns Panel
  {
    name = "AddOns",
    subtext = "Disable/Enable installed AddOns.",
    menu = {
      List = {
        type = "Frame",
        size = { 375, 332 },
        Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -14, 0 },
        children = {
          scroll = {
            type = "ScrollFrame",
            size = { 375, 332 },
            Point = { "TOPLEFT" },
            uitemp = "FauxScrollFrameTemplate",
            OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollAddOns) end,
            OnShow = function() Nurfed_ScrollAddOns() end,
          },
        },
        OnLoad = Nurfed_AddonsCreate,
      },
    },
  },

  -- Bindings Panel
  {
    name = "Bindings",
    subtext = "Direct spell, macro, item Bindings and Nurfed Button bindings.\nRight Click to select Rank, Select and Repeat Bind to Unbind.",
    menu = {
      List = {
        type = "Frame",
        size = { 375, 332 },
        Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -14, 0 },
        children = {
          scroll = {
            type = "ScrollFrame",
            size = { 375, 332 },
            Point = { "TOPLEFT" },
            uitemp = "FauxScrollFrameTemplate",
            OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollBindings) end,
            OnShow = function() Nurfed_ScrollBindings() end,
            OnMouseWheel = function() Nurfed_MouseWheelBindings(arg1) end,
          },
        },
        OnLoad = Nurfed_BindingsCreate,
      },
    },
  },
}

table.sort(panels, function(a, b) return a.name > b.name end)

for _, info in ipairs(panels) do
  if not info.addon or IsAddOnLoaded(info.addon) then
    local name = string.format("Nurfed%sPanel", info.name)
    local panel = Nurfed:create(name, "uipanel")
    panel.name = info.name
    panel.parent = "Nurfed"
    panel.default = function(self)
      end
    getglobal(name.."Title"):SetText(info.name)
    getglobal(name.."SubText"):SetText(info.subtext)

    for opt, tbl in pairs(info.menu) do
      Nurfed:create(name..opt, tbl, panel)
    end

    InterfaceOptions_AddCategory(panel)
  end
end

function Nurfed_ScrollActionBarsStates()
	local states = {}
	local bar = Nurfed_MenuActionBars.bar
	local tbl = NURFED_ACTIONBARS[bar].statemaps
	for k, v in pairs(tbl) do
		table.insert(states, { k, v })
	end

	local format_row = function(row, num)
		local state = states[num]
		local name = getglobal(row:GetName().."name")
		local value = getglobal(row:GetName().."value")
		name:SetText(state[1])
		value:SetText(state[2])
		row.state = state[1]
	end

	local frame = Nurfed_MenuActionBarsstatesscroll
	FauxScrollFrame_Update(frame, #states, 10, 14)
	for line = 1, 10 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("Nurfed_MenuActionBarsstates"..line)
		if offset <= #states then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_ScrollActionBars()
	local bars = {}
	for k in pairs(NURFED_ACTIONBARS) do
		table.insert(bars, k)
	end
	table.sort(bars, function(a, b) return a < b end)
	for k, v in ipairs(bars) do
		if Nurfed_MenuActionBars.expand[v] then
			local hdr = getglobal(v)
			local children = { hdr:GetChildren() }
			table.sort(children, function(a, b) return a:GetID() > b:GetID() end)
			for _, child in ipairs(children) do
				local name = child:GetName()
				if string.find(name, "^Nurfed_Button") then
					table.insert(bars, k + 1, name)
				end
			end
		end
	end

	local format_row = function(row, num)
		local bar = bars[num]
		local btn = getglobal(bar)
		local name = getglobal(row:GetName().."name")
		local expand = getglobal(row:GetName().."expand")
		local delete = getglobal(row:GetName().."delete")
		local states = getglobal(row:GetName().."states")
		row.bar = bar
		if Nurfed_MenuActionBars.bar == bar then
			row:LockHighlight()
		else
			row:UnlockHighlight()
		end
		if Nurfed_MenuActionBars.expand[bar] then
			expand:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
			expand:SetPushedTexture("Interface\\Buttons\\UI-MinusButton-Down")
		else
			expand:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
			expand:SetPushedTexture("Interface\\Buttons\\UI-PlusButton-Down")
		end
		if btn:GetID() > 0 then
			expand:Hide()
			delete:Hide()
			states:Hide()
			bar = "Button "..btn:GetID()
		else
			expand:Show()
			delete:Show()
			states:Show()
		end
		name:SetText(bar)
	end

	local frame = Nurfed_MenuActionBarsscroll
	FauxScrollFrame_Update(frame, #bars, 17, 14)
	for line = 1, 17 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("Nurfed_ActionBarsRow"..line)
		if offset <= #bars then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_ToggleStates()
	local bar = Nurfed_MenuActionBars.bar
	local pbar = this:GetParent().bar
	if bar and bar == pbar and getglobal(bar):GetID() == 0 then
		if this:GetChecked() then
			Nurfed_MenuActionBarsbar:Hide()
			Nurfed_MenuActionBarsstates:Show()
		else
			Nurfed_MenuActionBarsstates:Hide()
			Nurfed_MenuActionBarsbar:Show()
		end
	end
end

function Nurfed_ActionBar_OnClick(button)
	local barname = this.bar
	local state = getglobal(this:GetName().."states"):GetChecked()
	Nurfed_MenuActionBarsbar:Hide()
	Nurfed_MenuActionBarsstates:Hide()
	Nurfed_MenuActionBarsbutton:Hide()
	--Nurfed_MenuActionBarsbuttondefault:SetParent(Nurfed_MenuActionBarsbutton)
	--Nurfed_MenuActionBarsbuttonhelp:SetParent(Nurfed_MenuActionBarsbutton)
	--Nurfed_MenuActionBarsbuttonharm:SetParent(Nurfed_MenuActionBarsbutton)
	if Nurfed_MenuActionBars.bar == barname then
		Nurfed_MenuActionBars.bar = nil
	else
		Nurfed_MenuActionBars.bar = barname
		local bar = getglobal(barname)
		if bar:GetID() > 0 then
			--[[
			Nurfed_MenuActionBarsbutton:Show()
			local hdr = bar:GetParent()
			local children = { Nurfed_MenuActionBarsbutton:GetChildren() }
			for _, child in ipairs(children) do
				hdr:SetAttribute("addchild", child)
				child:SetAttribute("statebutton", bar:GetAttribute("statebutton"))
			end
			updatebuttons()
			]]
		else
			if state then
				Nurfed_MenuActionBarsstates:Show()
				Nurfed_ScrollActionBarsStates()
			else
				Nurfed_MenuActionBarsbar:Show()
				updateoptions()
			end
		end
	end
	Nurfed_ScrollActionBars()
end

function Nurfed_DeleteState()
	local state = this:GetParent().state
	local bar = Nurfed_MenuActionBars.bar
	local hdr = getglobal(bar)
	NURFED_ACTIONBARS[bar].statemaps[state] = nil
	hdr:SetAttribute("statemap-"..state, nil)
	Nurfed:updatebar(hdr)
	Nurfed_ScrollActionBarsStates()
end

function Nurfed_DeleteBar()
	local bar = this:GetParent().bar
	Nurfed:deletebar(bar)
	NURFED_ACTIONBARS[bar] = nil
	Nurfed_ScrollActionBars()
	Nurfed_MenuActionBars.bar = nil
end

function Nurfed_ExpandBar()
	local bar = this:GetParent().bar
	if Nurfed_MenuActionBars.expand[bar] then
		Nurfed_MenuActionBars.expand[bar] = nil
	else
		Nurfed_MenuActionBars.expand[bar] = true
	end
	Nurfed_ScrollActionBars()
end