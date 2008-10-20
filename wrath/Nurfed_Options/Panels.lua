 ------------------------------------------
-- Option Menu Panels
local L = Nurfed:GetTranslations()
local hptype = { "class", "fade", "script", "pitbull" }
local mptype = { "normal", "class", "fade", "pitbull" }
local auras = { "all", "curable", "yours" }
local units = { "", "focus", "party1", "party2", "party3", "party4", "pet", "player", "target", "targettarget" }
local states = { "stance:", "stealth:", "actionbar:", "shift:", "ctrl:", "alt:" }
local unitstates = { "modifier: shift", "nomodifier: shift", "modifier: alt", "nomodifier: alt" };
local visible = { "show", "hide", "combat", "nocombat", "exists" }
local setupFrameName, setupParentName, setupPoints

local function addDeBuffFilter(type, buff)
	if not buff or buff == "" then return end
	local filterLst = Nurfed:getopt(type)
	if not filterLst[buff] then
		if not NURFED_SAVED[type] then
			NURFED_SAVED[type] = {}
		end
		NURFED_SAVED[type][buff] = true
	end
end

local function removeDeBuff(type, buff)
	if not buff or buff == "" then return end
	NURFED_SAVED[type][buff] = nil
end
local updateoptions = function()
	local bar = NurfedActionBarsPanel.bar
	if bar then
		--local vals = NURFED_ACTIONBARS[bar]
		local vals
		for i in ipairs(NURFED_ACTIONBARS) do
			if NURFED_ACTIONBARS[i].name == bar then
				vals = NURFED_ACTIONBARS[i]
				break
			end
		end
		NurfedActionBarsPanelbarrows:SetValue(vals.rows)
		NurfedActionBarsPanelbarcols:SetValue(vals.cols)
		NurfedActionBarsPanelbarscale:SetValue(vals.scale)
		NurfedActionBarsPanelbaralpha:SetValue(vals.alpha)
		NurfedActionBarsPanelbarunit:SetText(vals.unit or "")
		NurfedActionBarsPanelbarvisible:SetText(vals.visible or "")
		NurfedActionBarsPanelbaruseunit:SetChecked(vals.useunit)
		NurfedActionBarsPanelbarxgap:SetValue(vals.xgap)
		NurfedActionBarsPanelbarygap:SetValue(vals.ygap)
	end
end

local addstate = function()
	local bar = NurfedActionBarsPanel.bar
	if bar then
		--local statemaps = NURFED_ACTIONBARS[bar].statemaps
		local statemaps
		for i in ipairs(NURFED_ACTIONBARS) do
			if NURFED_ACTIONBARS[i].name == bar then
				statemaps = NURFED_ACTIONBARS[i].statemaps
				break
			end
		end
		local state = string.trim(NurfedActionBarsPanelstatesstate:GetText())
		local map = string.trim(NurfedActionBarsPanelstatesmap:GetText())
		--state = string.trim(state)
		--map = string.trim(map)
		if map == "" or state == "" then
			return
		end
		statemaps[state] = map
		Nurfed:updatebar(getglobal(bar))
		Nurfed_ScrollActionBarsStates()
		NurfedActionBarsPanelstatesstate:SetText("")
		NurfedActionBarsPanelstatesmap:SetText("")
		if this.ClearFocus then
			this:ClearFocus()
		end
	end
end

local addunitstate = function(self)
	local bar = NurfedActionBarsPanel.bar
	if bar then
		--local statemaps = NURFED_ACTIONBARS[bar].statemaps
		local unitmaps
		for i,v in ipairs(NURFED_ACTIONBARS) do
			if v.name == bar then
				unitmaps = v.unitmaps
				break
			end
		end

		local state = string.trim(NurfedActionBarsPanelunitstatesstate:GetText())
		local map = string.trim(NurfedActionBarsPanelunitstatesmap:GetText())
		if map == "" or state == "" then
			return
		end
		unitmaps[state] = map
		Nurfed:updatebar(getglobal(bar))
		Nurfed_ScrollActionBarsUnitStates()
		NurfedActionBarsPanelunitstatesstate:SetText("")
		NurfedActionBarsPanelunitstatesmap:SetText("")
		if self.ClearFocus then
			self:ClearFocus()
		end
	end
end

local updatebuttons = function()
	local btn = NurfedActionBarsPanel.bar
	if btn then
		NurfedActionBarsPanelbuttondefaulttext:SetText(DEFAULT)
		NurfedActionBarsPanelbuttonhelptext:SetText(FACTION_STANDING_LABEL5)
		NurfedActionBarsPanelbuttonharmtext:SetText(FACTION_STANDING_LABEL2)
		btn = getglobal(btn)

		local value = btn:GetAttribute("state-parent")
		local helpv = SecureButton_GetModifiedAttribute(btn, "helpbutton", value)
		local harmv = SecureButton_GetModifiedAttribute(btn, "harmbutton", value)


		local default = SecureButton_GetModifiedAttribute(btn, "type", value)
		local help = SecureButton_GetModifiedAttribute(btn, "type", helpv)
		local harm = SecureButton_GetModifiedAttribute(btn, "type", harmv)

		local seticon = function(opt, val, name)
			local texture, stext
			local button = getglobal("NurfedActionBarsPanelbutton"..name)
			local icon = getglobal("NurfedActionBarsPanelbutton"..name.."Icon")
			local text = getglobal("NurfedActionBarsPanelbutton"..name.."Name")
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
	local add = true
	for i in ipairs(NURFED_ACTIONBARS) do
		if NURFED_ACTIONBARS[i].name == text then
			add = false
			break
		end
	end
	if text ~= "" and add then
		local unit = NurfedActionBarsPanelbarunit:GetText()
		unit = string.trim(unit)
		if unit == "" then unit = nil end
		local bscale, brows, bcols, balpha, bxgap, bygap, bvisible, buseunit
		do
			local scale = NurfedActionBarsPanelbarscale:GetValue()
			bscale = scale > 0 and scale or 1
			local rows = NurfedActionBarsPanelbarrows:GetValue()
			brows = rows > 0 and rows or 1
			local cols = NurfedActionBarsPanelbarcols:GetValue()
			bcols = cols > 0 and cols or 12
			local alpha = NurfedActionBarsPanelbaralpha:GetValue()
			balpha = alpha > 0 and alpha or 1
			local xgap = NurfedActionBarsPanelbarxgap:GetValue()
			bxgap = xgap > -40 and xgap or 0
			local ygap = NurfedActionBarsPanelbarygap:GetValue()
			bygap = ygap > -40 and ygap or 0
			local visible = NurfedActionBarsPanelbarvisible:GetText()
			bvisible = visible or ""
			local useunit = NurfedActionBarsPanelbaruseunit:GetChecked()
			buseunit = not not useunit
		end
		table.insert(NURFED_ACTIONBARS, {
			name = text,
			unit = unit,
			rows = brows,
			cols = bcols,
			scale = bscale,
			alpha = balpha,
			xgap = bxgap,
			ygap = bygap,
			visible = bvisible,
			useunit = buseunit,
			buttons = {},
			statemaps = {},
		})
		--[[NURFED_ACTIONBARS[text] = {
			unit = unit,
			rows = NurfedActionBarsPanelbarrows:GetValue(),
			cols = NurfedActionBarsPanelbarcols:GetValue(),
			scale = NurfedActionBarsPanelbarscale:GetValue(),
			alpha = NurfedActionBarsPanelbaralpha:GetValue(),
			xgap = NurfedActionBarsPanelbarxgap:GetValue(),
			ygap = NurfedActionBarsPanelbarygap:GetValue(),
			visible = NurfedActionBarsPanelbarvisible:GetText(),
			useunit = NurfedActionBarsPanelbaruseunit:GetChecked(),
			buttons = {},
			statemaps = {},
		}]]
		Nurfed:createbar(text)
		this:SetText("")
		Nurfed_ScrollActionBars()
	end
end

local updatebar = function(self)
	local bar = NurfedActionBarsPanel.bar
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
		--NURFED_ACTIONBARS[bar][self.val] = value
		for i in ipairs(NURFED_ACTIONBARS) do
			if NURFED_ACTIONBARS[i].name == bar then
				NURFED_ACTIONBARS[i][self.val] = value
				break
			end
		end

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
	local btn = NurfedActionBarsPanel.bar
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

local getcursor = function()
	local t = {}
	local type, id, link = GetCursorInfo()
	if type then
		t[1] = id
		t[2] = type
		t[3] = link
		return t
	end
end
local onreceivedrag = function(self)
	local btn = NurfedActionBarsPanel.bar
	btn = getglobal(btn)
	local cursoritem = getcursor()
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
		if cursoritem[2] == "spell" then
			cursoritem[1] = GetSpellName(cursoritem[1], cursoritem[3])
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
			if id and book then
				GameTooltip:SetSpell(id, book)
				GameTooltipTextLeft1:SetText(self.spell)
			end
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
	--[[for i = 0, 4 do
		local color = Nurfed:getopt(ManaBarColor[i].prefix)
		ManaBarColor[i].r = color[1]
		ManaBarColor[i].g = color[2]
		ManaBarColor[i].b = color[3]
	end]]
	for i = 0, 6 do
		local color = Nurfed:getopt(i == 0 and "mana" or i == 1 and "rage" or i == 2 and "focus" or i == 3 and "energy" or i == 4 and "happiness" or i == 5 and "runes" or i == 6 and "runic_power")
		if color then
			PowerBarColor[i].r = color[1]
			PowerBarColor[i].g = color[2]
			PowerBarColor[i].b = color[3]
		end
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

		local out = L["Nurfed Layout: |cffff0000Imported|r"]

		if Nurfed_UnitsLayout.Name then
			out = out.." "..Nurfed_UnitsLayout.Name
		end

		if Nurfed_UnitsLayout.Author then
			out = out..L[" designed by "]..Nurfed_UnitsLayout.Author
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
Nurfed_ImportLayout = import;
local panels = {
  -- Chat Panel
	{
		name = L["Chat"],
		subtext = L["Options that affect the appearance of chat messages and alerts sent to the chat frames."],
		menu = {
			check1 = {
				template = "nrf_check",
				Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
				vars = { text = L["Ping Warning"], option = "ping" },
			},
			check2 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Chat Timestamps"], option = "timestamps" },
			},
			check3 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Show Raid Group"], option = "raidgroup" },
			},
			check4 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Show Raid Class"], option = "raidclass" },
			},
			check5 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck4", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Hide Chat Buttons"], option = "chatbuttons", func = function() nrf_togglechat() end },
			},
			check6 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck5", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Show Chat Prefix"], option = "chatprefix" },
			},
			check7 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck6", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Show Number Prefix Text"], option = "numchatprefix" },
			},
			check8 = {
				template = "nrf_check",
				Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -8 },
				vars = { text = L["Chat Text Fade"], option = "chatfade", func = function() nrf_togglechat()
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
			check9 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck7", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Hide Achievements"], option = "hideachievements" },
			},
			check10 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck9", "BOTTOMLEFT", 0, -8 },
				vars = { text = L["Class Color Names"], option = "classcolortext" },
			}, 
			slider1 = {
				template = "nrf_slider",
				Anchor = { "TOPRIGHT", "$parentcheck8", "BOTTOMRIGHT", 0, -24 },
				vars = {
					text = L["Chat Text Fade Time"],
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
				vars = { text = L["Timestamp Format"], option = "timestampsformat" },
			},
		},
	},
	-- Action Bar Options
	{
		name = L["ActionBars Settings"],
		subtext = L["Basic options for controling the appearance of your Nurfed Action Bars"],
		menu = {
			check1 = {
				template = "nrf_check",
				Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
				vars = { text = L["Show Macro Text"], option = "macrotext", nrfevent = "UPDATE_BINDINGS", page = 1 },
			},
			check2 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Binding Text"], option = "showbindings", nrfevent = "UPDATE_BINDINGS", page = 1 },
			},
			check3 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Action Tooltips"], option = "tooltips", right = true, page = 1 },
			},
			check4 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Fade In Actions"], option = "fadein", right = true, page = 1 },
			},
			check5 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck4", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Hide Main Bar"], option = "hidemain", right = true, func = function() nrf_mainmenu() end, page = 1 },
			},
			swatch1 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentcheck5", "BOTTOMLEFT", 5, -5 },
				vars = { text = L["No Mana"], option = "actionbarnomana", func = NurfedActionBarsUpdateColors, page = 1 },
			},
			swatch2 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentswatch1", "BOTTOMLEFT", 0, -5 },
				vars = { text = L["Not Usable"], option = "actionbarnotusable", func = NurfedActionBarsUpdateColors, page = 1 },
			},
			swatch3 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentswatch2", "BOTTOMLEFT", 0, -5 },
				vars = { text = L["Out of Range"], option = "actionbarnorange", func = NurfedActionBarsUpdateColors, page = 1 },
			},
			swatch4 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentswatch3", "BOTTOMLEFT", 0, -5 },
				vars = { text = L["Base Color"], option = "actionbarbasecolor", func = NurfedActionBarsUpdateColors, page = 1 },
			},
		},
	},
	-- General Panel
	{
		name = GENERAL,
		subtext = L["General options for Nurfed that affect default UI elements and appearance."],
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
				vars = { text = L["Hide Untrainable Skills"], option = "traineravailable", page = 1 },
			},
			check2 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Auto Invite"], option = "autoinvite", page = 1 },
			},
			check3 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Invite Reply"], option = "invitetext", page = 1 },
			},
			check4 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Square Minimap"], option = "squareminimap", hint = L["Enables the Nurfed Minimap icon to flow properly on square minimaps."], page = 1 },
			},
			check5 = {
				template = "nrf_check",
				Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -2 },
				vars = { text = L["Auto Repair"], option = "repair", hint = L["Toggle auto-repairing of gear when a repair vendor is opened.  We will try to repair from gbank first, then use your own money."], page = 1 },
			},
			check6 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck4", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Disable Casting Bar"], option = "hidecasting", hint = L["Toggle the default blizzard casting bar from showing or not."], func = nrf_togglecast, page = 1 },
			},
			check7 = {
				template = "nrf_check",
				Point = { "TOPLEFT", "$parentcheck6", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Bags"], option = "bagsshow", func = function() nrf_updatemainbar("bags") end, page = 1 },
			},
			check8 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck7", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Vertical Bags"], option = "bagsvert", func = function() nrf_updatemainbar("bags") end, page = 1 },
			},
			check9 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck8", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Micro"], option = "microshow", func = function() nrf_updatemainbar("micro") end, page = 1 },
			},
			check10 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck9", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Stance"], option = "stanceshow", func = function() nrf_updatemainbar("stance") end, page = 1 },
			},
			check11 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck10", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Vertical Stance"], option = "stancevert", func = function() nrf_updatemainbar("stance") end, page = 1 },
			},
			slider1 = {
				template = "nrf_slider",
				Anchor = { "TOPRIGHT", "$parentcheck5", "BOTTOMRIGHT", 0, -24 },
				vars = {
					text = L["Repair Gold Limit"],
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
				Anchor = { "TOPLEFT", "$parentslider1", "BOTTOMLEFT", -5, -30 },
				vars = { text = L["Invite Keyword"], option = "keyword", page = 1 },
			},
			slider2 = {
				template = "nrf_slider",
				Anchor = { "TOP", "$parentinput1", "BOTTOM", 0, -30 },
				vars = {
					text = L["Bags Scale"],
					option = "bagsscale",
					low = "25%",
					high = "100%",
					min = 0.25,
					max = 2,
					step = 0.01,
					bigStep = 0.10,
					deci = 2,
					format = "%.2f",
					right = true,
					func = function() nrf_updatemainbar("bags") end,
					page = 1,
				},
			},
			slider3 = {
				template = "nrf_slider",
				Anchor = { "TOP", "$parentslider2", "BOTTOM", 0, -30 },
				vars = {
					text = L["Micro Scale"],
					option = "microscale",
					low = "25%",
					high = "100%",
					min = 0.25,
					max = 2,
					step = 0.01,
					bigStep = 0.10,
					deci = 2,
					format = "%.2f",
					right = true,
					func = function() nrf_updatemainbar("micro") end,
					page = 1,
				},
			},
			slider4 = {
				template = "nrf_slider",
				Anchor = { "TOP", "$parentslider3", "BOTTOM", 0, -30 },
				vars = {
					text = L["Stance Scale"],
					option = "stancescale",
					low = "25%",
					high = "100%",
					min = 0.25,
					max = 2,
					step = 0.01,
					bigStep = 0.10,
					deci = 2,
					format = "%.2f",
					right = true,
					func = function() nrf_updatemainbar("stance") end,
					page = 1,
				},
			},
			-- page 2
			
			check16 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
				vars = { text = L["Show Pet Bar"], option = "petbarshow", func = function() nrf_updatemainbar("petbar") end, page = 2 },
			},
			check17 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck16", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Vertical Pet Bar"], option = "petbarvert", func = function() nrf_updatemainbar("petbar") end, page = 2 },
			},
			check18 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck17", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Possess Bar"], option = "possessbarshow", func = function() nrf_updatemainbar("possessbar") end, page = 2 },
			},
			check19 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck18", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Vertical Possess Bar"], option = "possessbarvert", func = function() nrf_updatemainbar("possessbar") end, page = 2 },
			},
			check20 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck19", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Show Vehicle Bar"], option = "vehiclemenubarshow", func = function() nrf_updatemainbar("vehiclemenubar") end, page = 2 },
			},
			check21 = {
				template = "nrf_check",
				Anchor = { "TOPLEFT", "$parentcheck20", "BOTTOMLEFT", 0, -2 },
				vars = { text = L["Vertical Vehicle Bar"], option = "vehiclemenubarvert", func = function() nrf_updatemainbar("vehiclemenubar") end, page = 2 },
			},
			slider5 = {
				template = "nrf_slider",
				--Anchor = { "TOP", "$parentslider4", "BOTTOM", 0, -30 },
				Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -10 },
				vars = {
					text = L["Pet Bar Scale"],
					option = "petbarscale",
					low = "25%",
					high = "100%",
					min = 0.25,
					max = 2,
					step = 0.01,
					bigStep = 0.10,
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
					text = L["Pet Bar Offset"],
					option = "petbaroffset",
					low = -20,
					high = 20,
					min = -20,
					max = 20,
					step = 1,
					bigStep = 2,
					format = "%.0f",
					page = 2,
					func = function() nrf_updatemainbar("petbar") end,
				},
			},
		},
	},
	{
		name = "Talent Settings",
		subtext = "Save settings based on talents.",
		menu = {
			addbar = {
				template = "nrf_button",
				Anchor = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", 0, 20 },
				OnClick = function()
					local tab1 = select(3, GetTalentTabInfo(1, false))
					local tab2 = select(3, GetTalentTabInfo(2, false))
					local tab3 = select(3, GetTalentTabInfo(3, false))
					if not NURFED_TALENTBARS[tab1] then
						NURFED_TALENTBARS[tab1] = {}
					end
					if not NURFED_TALENTBARS[tab1][tab2] then
						NURFED_TALENTBARS[tab1][tab2] = {}
					end
					NURFED_TALENTBARS[tab1][tab2][tab3] = {}
					for i,v in pairs(NURFED_ACTIONBARS) do
						NURFED_TALENTBARS[tab1][tab2][tab3][i] = v
					end
					Nurfed:print("Nurfed: Saved ActionBar Settings for Spec:"..tab1..","..tab2..","..tab3)
				end,
				Text = L["Add Talent Action Bars"],
			},
			addbinding = {
				template = "nrf_button",
				Anchor = { "TOPLEFT", "$parentaddbar", "BOTTOMLEFT", 0, -20 },
				OnClick = function()
					local tab1 = select(3, GetTalentTabInfo(1, false))
					local tab2 = select(3, GetTalentTabInfo(2, false))
					local tab3 = select(3, GetTalentTabInfo(3, false))
					if not NURFED_TALENTBINDINGS[tab1] then
						NURFED_TALENTBINDINGS[tab1] = {}
					end
					if not NURFED_TALENTBINDINGS[tab1][tab2] then
						NURFED_TALENTBINDINGS[tab1][tab2] = {}
					end
					NURFED_TALENTBINDINGS[tab1][tab2][tab3] = {}
					--[[ this function sucks ass.  
					-- Fail blizzard at making GetNumBindings and GetBinding not work with non-registered bindings
					-- such as SetBindingSpell, SetBindingMacro, and SetBindingItem
					-- very depressing
					for i=0, GetNumBindings() do
						local action, key1, key2 = GetBinding(i)
						if key1 then
							if key2 then
								NURFED_TALENTBINDINGS[tab1][tab2][tab3][action] = { [1] = key1, [2] = key2 }
							else
								NURFED_TALENTBINDINGS[tab1][tab2][tab3][action] = key1
							end
						end
					end]]
					local permutations = {"SHIFT","CTRL","ALT","ALT-SHIFT","ALT-CTRL","CTRL-SHIFT","ALT-CTRL-SHIFT"}
					local talentKeyLst = {
						"ESCAPE","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","PRINTSCREEN",
						"SCROLLLOCK","PAUSE","`","1","2","3","4","5","6","7","8","9","0","-","=","BACKSPACE","TAB",
						"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "[", "]", "\\", "CAPSLOCK", "A", "S", "D", "F", "G", "H", 
						"J", "K", "L", ";", "'", "ENTER", "SHIFT", "Z", "X", "C", "V", "B", "N", "M", ",", ".", "/", "SHIFT", "INSERT", 
						"HOME", "PAGEUP", "DELETE", "END", "PAGEDOWN", "LEFT", "UP", "DOWN", "RIGHT", "NUMLOCK", "NUMPADDIVIDE", "NUMPADMULTIPLY", 
						"NUMPADMINUS", "NUMPAD7", "NUMPAD8", "NUMPAD9", "NUMPADPLUS", "NUMPAD4", "NUMPAD5", "NUMPAD6", "NUMPAD1", "NUMPAD2", 
						"NUMPAD3", "ENTER", "NUMPAD0", "NUMPADDECIMAL", 
					}
					for _, key in pairs(talentKeyLst) do
						local action = GetBindingAction(key)
						if action and action ~= "" then
							if not NURFED_TALENTBINDINGS[tab1][tab2][tab3][action] then
								NURFED_TALENTBINDINGS[tab1][tab2][tab3][action] = {}
							end
							table.insert(NURFED_TALENTBINDINGS[tab1][tab2][tab3][action], key)
						end
						for _, subkey in pairs(permutations) do
							action = GetBindingAction(subkey.."-"..key)
							if action and action ~= "" then
								if not NURFED_TALENTBINDINGS[tab1][tab2][tab3][action] then
									NURFED_TALENTBINDINGS[tab1][tab2][tab3][action] = {}
								end
								table.insert(NURFED_TALENTBINDINGS[tab1][tab2][tab3][action], subkey.."-"..key)
							end
						end
					end
					Nurfed:print("Nurfed: Saved Keybinding Settings for Spec:"..tab1..","..tab2..","..tab3)
				end,
				Text = L["Add Talent Keybindings"],
			},
		},
	},
	-- Action Bars Panel
	{
		name = "ActionBars",
		subtext = L["Change settings for the action bars provided by Nurfed."],
		menu = {
			savepos = {
				template = "nrf_button",
				Anchor = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", 0, 20 },
				OnClick = function()
					for i in ipairs(NURFED_ACTIONBARS) do
						NURFED_ACTIONBARS[i].Point = { _G[NURFED_ACTIONBARS[i].name]:GetPoint() }
					end
				end,
				Text = L["Save Pos"],
			},
			buttontext = {
				template = "nrf_button",
				Anchor = { "TOPLEFT", "$parentsavepos", "TOPRIGHT", 2, 0 },
				OnMouseDown = function()
					Nurfed:sendevent("NRF_TOGGLE_NUMBER_TEXT", true)
				end,
				OnMouseUp = function()
					Nurfed:sendevent("NRF_TOGGLE_NUMBER_TEXT")
				end,
				Text = L["Button Numbers"],
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
				Anchor = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -10, 0 },
			},
			scroll = {
				type = "ScrollFrame",
				size = { 165, 300 },
				Anchor = { "TOPLEFT", "$parentadd", "BOTTOMLEFT", 0, -5 },
				uitemp = "FauxScrollFrameTemplate",
				OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollActionBars) end,
				OnShow = function() Nurfed_ScrollActionBars() end,
			},
			backing = {
				type = "Frame",
				size = { 173, 300 },
				Backdrop = {	
					bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
					edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
					tile = true, 
					tileSize = 12, 
					edgeSize = 10, 
					insets = { left = 2, right = 2, top = 2, bottom = 2 }, 
				},
				BackdropColor = { 0, 0, 0, 1 },
				Anchor = { "TOPLEFT", "$parentadd", "BOTTOMLEFT", 0, -5 },
			},
			defaults = {
				type = "Frame",
				size = { 230, 100 },
				Anchor = { "TOPLEFT", "$parentadd", "BOTTOMRIGHT", 65, 25 },
				--Hide = true,
				children = {
					desc = {
						type = "FontString",
						layer = "ARTWORK",
						Anchor = { "TOPLEFT", 0, -7 },
						FontObject = "GameFontNormalSmall",
						JustifyH = "LEFT",
						Text = L["Settings Templates"],
					},
					roguestealthbar = {
						template = "nrf_button",
						Text = L["Rogue Stealth Bar"],
						Point = { "TOPLEFT", "$parentdesc", "BOTTOMLEFT", 0, -7 },
						OnClick = function() 
							Nurfed_CreateDefaultActionBar("rogueStealth")
						end,
					},
					druidbarnostealth = {
						template = "nrf_button",
						Text = L["Druid Form Bar (No Stealth)"],
						Point = { "TOPLEFT", "$parentroguestealthbar", "BOTTOMLEFT", 0, -7 },
						OnClick = function()
							Nurfed_CreateDefaultActionBar("druidNoStealth")
						end,
					},
					druidbarstealth = {
						template = "nrf_button",
						Text = L["Druid Form Bar (Stealth)"],
						Point = { "TOPLEFT", "$parentdruidbarnostealth", "BOTTOMLEFT", 0, -7 },
						OnClick = function()
							Nurfed_CreateDefaultActionBar("druidStealth")
						end,
					},
					warriorstancebar = {
						template = "nrf_button",
						Text = L["Warrior Stance Bar"],
						Point = { "TOPLEFT", "$parentdruidbarstealth", "BOTTOMLEFT", 0, -7 },
						OnClick = function()
							Nurfed_CreateDefaultActionBar("warriorStance")
						end,
					},
					
					petbarconfig = {
						template = "nrf_editbox",
						size = { 125, 18 },
						Point = { "TOPLEFT", "$parentwarriorstancebar", "BOTTOMLEFT", 0, -30 },
						OnTextChanged = function(self) 
							local opt = self.option
							local value = tonumber(self:GetText())
							if value == NURFED_DEFAULT[opt] then
								NURFED_SAVED[opt] = nil
							else
								NURFED_SAVED[opt] = value
							end
						end,
						OnEnterPressed = function(self) 
							local opt = self.option
							local value = tonumber(self:GetText())
							if value == NURFED_DEFAULT[opt] then
								NURFED_SAVED[opt] = nil
							else
								NURFED_SAVED[opt] = value
							end
							self:ClearFocus()
						end,
						vars = { val = "petbarstartbutton", option = "petbarstartbutton", text = L["Pet Bar Start Button"] },
					},
				},
			},
			bar = {
				type = "Frame",
				size = { 230, 100 },
				Anchor = { "TOPLEFT", "$parentadd", "BOTTOMRIGHT", 65, 25 },
				Hide = true,
				children = {
					unit = {
						template = "nrf_editbox",
						size = { 125, 18 },
						Anchor = { "TOPLEFT", 0, -7 },
						children = {
							add = {
								template = "nrf_button",
								Anchor = { "LEFT", "$parent", "RIGHT", 0, 0 },
								Text = L["Unit"],
								OnClick = function(self) Nurfed_DropMenu(self, units) end,
							},
						},
						OnTextChanged = function(self) updatebar(self) end,
						OnEnterPressed = function(self) updatebar(self) end,
						vars = { val = "unit", default = "target" },
					},
					useunit = {
						template = "nrf_check",
						Anchor = { "BOTTOM", "$parent", "TOP", -50, -10 },
						OnClick = function(self) updatebar(self) end,
						vars = { text = L["Harm / Help"], val = "useunit" },
					},
					visible = {
						template = "nrf_editbox",
						size = { 125, 18 },
						Anchor = { "TOPLEFT", "$parentunit", "BOTTOMLEFT", 0, -7 },
						children = {
							add = {
								template = "nrf_button",
								Anchor = { "LEFT", "$parent", "RIGHT", 0, 0 },
								Text = L["Visible"],
								OnClick = function(self) Nurfed_DropMenu(self, visible) end,
							},
						},
						OnEnterPressed = function(self) updatebar(self) end,
						vars = { val = "visible", default = "show" },
					},
					rows = {
						template = "nrf_slider",
						Anchor = { "TOPLEFT", "$parentvisible", "BOTTOMLEFT", 0, -13 },
						vars = {
							text = L["Rows"],
							val = "rows",
							low = 1,
							high = 24,
							min = 1,
							max = 24,
							step = 1,
							bigStep = 2,
							format = "%.0f",
							right = true,
							default = 1,
							fontobject = "GAMEFONTNORMALSMALL",
							funcself = updatebar,
						},
					},
					cols = {
						template = "nrf_slider",
						Anchor = { "TOP", "$parentrows", "BOTTOM", 0, -30 },
						vars = {
							text = L["Columns"],
							val = "cols",
							low = 1,
							high = 24,
							min = 1,
							max = 24,
							step = 1,
							bigStep = 2,
							format = "%.0f",
							right = true,
							default = 12,
							fontobject = "GAMEFONTNORMALSMALL",
							funcself = updatebar,
						},
					},
					scale = {
						template = "nrf_slider",
						Anchor = { "TOP", "$parentcols", "BOTTOM", 0, -30 },
						vars = {
							text = L["Scale"],
							val = "scale",
							low = "25%",
							high = "300%",
							min = 0.25,
							max = 3,
							step = 0.01,
							bigStep = .05,
							format = "%.2f",
							deci = 2,
							right = true,
							default = 1,
							fontobject = "GAMEFONTNORMALSMALL",
							funcself = updatebar,
						},
					},
					alpha = {
						template = "nrf_slider",
						Anchor = { "TOP", "$parentscale", "BOTTOM", 0, -30 },
						vars = {
							text = L["Alpha"],
							val = "alpha",
							low = "0%",
							high = "100%",
							min = 0,
							max = 1,
							step = 0.01,
							bigStep = .05,
							format = "%.2f",
							deci = 2,
							right = true,
							default = 1,
							fontobject = "GAMEFONTNORMALSMALL",
							funcself = updatebar,
						},
					},
					xgap = {
						template = "nrf_slider",
						Anchor = { "TOP", "$parentalpha", "BOTTOM", 0, -30 },
						vars = {
							text = L["X Gap"],
							val = "xgap",
							low = -2,
							high = 50,
							min = -2,
							max = 50,
							step = 1,
							bigStep = 2,
							format = "%.0f",
							right = true,
							default = 2,
							fontobject = "GAMEFONTNORMALSMALL",
							funcself = updatebar,
						},
					},
					ygap = {
						template = "nrf_slider",
						Anchor = { "TOP", "$parentxgap", "BOTTOM", 0, -30 },
						vars = {
							text = L["Y Gap"],
							val = "ygap",
							low = -2,
							high = 50,
							min = -2,
							max = 50,
							step = 1,
							bigStep = 2,
							format = "%.0f",
							right = true,
							default = 2,
							fontobject = "GAMEFONTNORMALSMALL",
							funcself = updatebar,
						},
					},
				},
			},
			button = {
				type = "Frame",
				size = { 100, 100 },
				uitemp = "SecureHandlerStateTemplate",
				Anchor = { "TOPRIGHT", "$parent", "TOPRIGHT", -50, -150 },
				Keyboard = true,
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
						OnShow = function(self) self:SetFrameLevel(1000) self:SetFrameStrata("HIGH") end,
						OnHide = function(self) self:SetFrameLevel(4) self:SetFrameStrata("LOW") end,
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
						OnShow = function(self) self:SetFrameLevel(1000) self:SetFrameStrata("HIGH") end,
						OnHide = function(self) self:SetFrameLevel(4) self:SetFrameStrata("LOW") end,
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
						OnShow = function(self) self:SetFrameLevel(1000) self:SetFrameStrata("HIGH") end,
						OnHide = function(self) self:SetFrameLevel(4) self:SetFrameStrata("LOW") end,
						vars = { t = "harmbutton", s = "nuke" },
					},
				},
				Hide = true,
			},
			states = {
				type = "Frame",
				size = { 230, 100 },
				Anchor = { "TOPLEFT", "$parentadd", "BOTTOMRIGHT", 65, 25 },
				children = {
					state = {
						template = "nrf_editbox",
						size = { 125, 18 },
						Anchor = { "TOPLEFT", 0, -7 },
						children = {
							drop = {
								template = "nrf_button",
								Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
								Text = L["State"],
								OnClick = function(self) Nurfed_DropMenu(self, states) end,
							},
						},
						OnTabPressed = function() NurfedActionBarsPanelstatesmap:SetFocus() end,
						OnEnterPressed = addstate,
					},
					map = {
						template = "nrf_editbox",
						size = { 50, 18 },
						children = {
							add = {
								template = "nrf_button",
								Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
								Text = L["State Value"],
								OnClick = addstate,
							},
						},
						OnTabPressed = function() NurfedActionBarsPanelstatesstate:SetFocus() end,
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
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["2"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["3"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["4"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent3", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["5"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent4", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["6"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent5", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["7"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent6", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["8"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent7", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["9"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent8", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
					["10"] = {
						template = "nrf_actionstates",
						Anchor = { "TOPLEFT", "$parent9", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelstatesstate:SetText(self.state) end,
					},
				},
				Hide = true,
			},
			unitstates = {
				type = "Frame",
				size = { 230, 100 },
				Anchor = { "TOPLEFT", "$parentadd", "BOTTOMRIGHT", 65, 25 },
				children = {
					state = {
						template = "nrf_editbox",
						size = { 125, 18 },
						Anchor = { "TOPLEFT", 0, -7 },
						children = {
							drop = {
								template = "nrf_button",
								Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
								Text = L["State"],
								OnClick = function(self) Nurfed_DropMenu(self, unitstates) end,
							},
						},
						OnTabPressed = function() NurfedActionBarsPanelunitstatesmap:SetFocus() end,
						OnEnterPressed = addunitstate,
					},
					map = {
						template = "nrf_editbox",
						size = { 50, 18 },
						children = {
							add = {
								template = "nrf_button",
								Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
								Text = L["Unit Value"],
								OnClick = addunitstate,
							},
						},
						OnTabPressed = function() NurfedActionBarsPanelunitstatesstate:SetFocus() end,
						OnEnterPressed = addunitstate,
						Anchor = { "TOPLEFT", "$parentstate", "BOTTOMLEFT", 0, -5 },
					},
					scroll = {
						type = "ScrollFrame",
						size = { 170, 155 },
						Anchor = { "TOPLEFT", "$parentmap", "BOTTOMLEFT", 0, 0 },
						uitemp = "FauxScrollFrameTemplate",
						OnVerticalScroll = function() FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollActionBarsUnitStates) end,
						OnShow = function(self) Nurfed_ScrollActionBarsUnitStates(self) end,
					},
					["1"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parentscroll", "TOPLEFT", 0, -8 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["2"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent1", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["3"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent2", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["4"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent3", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["5"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent4", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["6"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent5", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["7"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent6", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["8"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent7", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["9"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent8", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
					["10"] = {
						template = "nrf_unitstates",
						Anchor = { "TOPLEFT", "$parent9", "BOTTOMLEFT", 0, 0 },
						OnClick = function(self) NurfedActionBarsPanelunitstatesstate:SetText(self.state) end,
					},
				},
				Hide = true,
			},
		},
	},
  -- Units Panel
	{
		name = L["Units"],
		subtext = L["Options that effect the unit frames created by Nurfed."],
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
				Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, 10 },
				vars = { text = L["Aura Cooldowns"], option = "cdaura", page = 1 },
			},
			check2 = {
				template = "nrf_check",
				Point = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, 0 },
				vars = { text = L["Color Mana Background"], option = "changempbg", page = 1 },
			},
			check3 = {
				template = "nrf_check",
				Point = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, 0 },
				vars = { text = L["Color Health Background"], option = "changehpbg", page = 1 },
			},
			swatch1 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 5, -5 },
				vars = { text = MANA, option = "mana", func = setmana, page = 1 },
			},
			swatch2 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentswatch1", "BOTTOMLEFT", 0, -5 },
				vars = { text = RAGE, option = "rage", func = setmana, page = 1 },
			},
			swatch3 = {
				template = "nrf_color",
				Point = { "TOPLEFT", "$parentswatch2", "BOTTOMLEFT", 0, -5 },
				vars = { text = FOCUS, option = "focus", func = setmana, page = 1 },
			},
			swatch4 = {
				template = "nrf_color",
				Point = { "LEFT", "$parentswatch1", "RIGHT", 120, 0 },
				vars = { text = ENERGY, option = "energy", func = setmana, page = 1 },
			},
			swatch5 = {
				template = "nrf_color",
				Point = { "TOPRIGHT", "$parentswatch4", "BOTTOMRIGHT", 0, -5 },
				vars = { text = HAPPINESS, option = "happiness", func = setmana, page = 1 },
			},
			button1 = {
				template = "nrf_optbutton",
				Anchor = { "TOPLEFT", "$parentswatch3", "BOTTOMLEFT", 55, -5 },
				OnClick = function(self) Nurfed_DropMenu(self, mptype) end,
				vars = { text = L["MP Color"], option = "mpcolor", func = setmp, page = 1, nohitrect = true, },
			},
			button2 = {
				template = "nrf_optbutton",
				Anchor = { "TOPLEFT", "$parentbutton1", "TOPLEFT", 110, 0 },
				OnClick = function(self) Nurfed_DropMenu(self, hptype) end,
				vars = { text = L["HP Color"], option = "hpcolor", func = sethp, page = 1, nohitrect = true, },
			},
			hpscript = {
				template = "nrf_multiedit",
				size = { 350, 160 },
				Point = { "TOPLEFT", "$parentbutton1", "BOTTOMLEFT", -70, -7 },
				vars = { option = "hpscript", func = sethp, page = 1 },
			},
			button3 = {
				template = "nrf_optbutton",
				size = { 120, 18 },
				Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", 20, 0 },
				OnClick = function(self)
					local t = {}
					for i in pairs(Nurfed:getopt("bufffilterlist")) do
						table.insert(t, i)
					end
					Nurfed_DropMenu(self, t)
				end,
				OnShow = function(self)
					local text = _G[self:GetName().."Text"]
					if text then
						text:ClearAllPoints();
						text:SetPoint("BOTTOM", self:GetName(), "TOP", 0, 0)
						text:SetText(self.text)
						text:Show()
					end
				end,
				vars = { text = L["Buff Filter List"], func = function(text) NurfedUnitsPanelbutton3:SetText(""); removeDeBuff("bufffilterlist", text) end, page = 2 },
			},
			editbox1 = {
				template = "nrf_editbox",
				size = { 250, 18 },
				Point = { "TOPLEFT", "$parentbutton3", "BOTTOMLEFT", -2, -18 },
				OnEnterPressed = function(self) addDeBuffFilter("bufffilterlist", self:GetText()); self:ClearFocus(); self:SetText("") end,
				OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
				OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				vars = { text = L["Add Buff Filter"], page = 2 },
			},
			button4 = {
				template = "nrf_optbutton",
				size = { 120, 18 },
				Point = { "TOPLEFT", "$parenteditbox1", "BOTTOMLEFT", 0, -18 },
				OnClick = function(self)
					local t = {}
					for i in pairs(Nurfed:getopt("debufffilterlist")) do
						table.insert(t, i)
					end
					Nurfed_DropMenu(self, t)
				end,
				OnShow = function(self)
					local text = _G[self:GetName().."Text"]
					if text then
						text:ClearAllPoints();
						text:SetPoint("BOTTOM", self:GetName(), "TOP", 0, 0)
						text:SetText(self.text)
						text:Show()
					end
				end,
				vars = { text = L["Debuff Filter List"], func = function(text) NurfedUnitsPanelbutton4:SetText(""); removeDeBuff("debufffilterlist", text) end, page = 2 },
			},
			editbox2 = {
				template = "nrf_editbox",
				size = { 250, 18 },
				Point = { "TOPLEFT", "$parentbutton4", "BOTTOMLEFT", 0, -18 },
				OnEnterPressed = function(self) addDeBuffFilter("debufffilterlist", self:GetText()); self:ClearFocus(); self:SetText("") end,
				OnEditFocusGained = function(self) self:HighlightText() self.focus = true end,
				OnEditFocusLost = function(self) self:HighlightText(0, 0) self.focus = nil end,
				vars = { text = L["Add Debuff Filter"], page = 2 },
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
		name = L["Frames"],
		subtext = L["Frames menu options"],
		menu = {
			Frames = {
				type = "Frame",
				--size = { 375, 332 },
				--Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -14, 0 },
				size = { 375, 332 },
				Anchor = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -14, 0 },
				Backdrop = { bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 16, edgeSize = 8, insets = { left = 2, right = 2, top = 2, bottom = 2 }, },
				--BackdropColor = { 0, 0, 0, 0.95 },
				BackdropColor = { 0, 0, 0, 0 },
				--Alpha = ,
				--Hide = true,
				children = {
					scroll = {
						type = "ScrollFrame",
						size = { 375, 332 },
						Point = { "TOPRIGHT", "$parent", "TOPRIGHT", -20, 0 },
						uitemp = "FauxScrollFrameTemplate",
						OnVerticalScroll = function(self, val) 
							--FauxScrollFrame_OnVerticalScroll(14, Nurfed_ScrollFrames) 
							FauxScrollFrame_OnVerticalScroll(self, val, 14, Nurfed_ScrollFrames) 
						end,
						OnShow = function(self) 
							if not rwar then
								do
									local menu = "Frames"
									local parent = getglobal("Nurfed"..menu.."Panel")
									--local temp = "nrf_"..string.lower(menu).."_row"
									local temp = {
										type = "Button",
										size = { 350, 14 },
										children = {
											icon = {
												type = "Button",
												layer = "ARTWORK",
												size = { 14, 14 },
												Anchor = { "LEFT", "$parent", "LEFT", 5, 0 },
												NormalTexture = "Interface\\Buttons\\UI-PlusButton-Up",
												PushedTexture = "Interface\\Buttons\\UI-PlusButton-Down",
												HighlightTexture = "Interface\\Buttons\\UI-PlusButton-Hilight",
												OnClick = function(self) Nurfed_ExpandFrame(self) end,
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
										OnClick = function(self, arg1) Nurfed_Frame_OnClick(self, arg1) end,
									}
									for i = 1, 22 do
										--local row = nrf:create("Nurfed_"..menu.."Row"..i, temp, parent)
										local row = Nurfed:create("Nurfed"..menu.."PanelFramesRow"..i, temp, parent)
										if (row:GetObjectType() == "Button") then
											row:RegisterForClicks("AnyUp")
										end
										if (i == 1) then
											--row:SetPoint("TOPLEFT", "Nurfed_OptionsFrame"..menu.."scroll", "TOPLEFT", 0, -3)
											row:SetPoint("TOPLEFT", "Nurfed"..menu.."PanelFramesscroll", "TOPLEFT", 20, -3)
										else
											--row:SetPoint("TOPLEFT", "Nurfed_"..menu.."Row"..i - 1, "BOTTOMLEFT", 0, 0)
											row:SetPoint("TOPLEFT", "Nurfed"..menu.."PanelFramesRow"..i - 1, "BOTTOMLEFT", 0, 0)
										end
									end
								end
								rwar = true
								NurfedFramesPanelEditor:Show()
							end

							Nurfed_ScrollFrames(self) 
						end,
					},
				},
			},
		},
	},
	{
		name = "Beta Shit",
		subtext = "Configure hidding settings for the beta.  Use at your own risk.",
		menu = {
			shadows = {
				template = "nrf_slider",
				Anchor = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", 0, -24 },
				vars = {
					text = "Shadows",
					--option = "chatfadetime",
					low = 0,
					high = 6,
					min = 0,
					max = 6,
					step = 1,
					format = "%.0f",
					--func = function() nrf_togglechat() end,
					func = function(val) SetCVar("extShadowQuality", val) end,
				},
			},
			threatbar = {
				template = "nrf_check",
				Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -8 },
				vars = { 
					text = "Enable Threat Menu",
					--option = "threatmenu", 
					func = function(val) 
						debug(val)
						if val then
							IsThreatWarningEnabled = function() return true end
							SetCVar("showThreatMeter", 1)
						else
							IsThreatWarningEnabled = function() return false end
							SetCVar("showThreatMeter", 0)
						end
					end,
				},
			},
		},
	},

  -- AddOns Panel
	{
		name = L["AddOns"],
		subtext = L["Disable/Enable installed AddOns."],
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
						OnVerticalScroll = function(self, val) 
							FauxScrollFrame_OnVerticalScroll(self, val, 14, Nurfed_ScrollAddOns) 
						end,
						OnShow = function(self) Nurfed_ScrollAddOns() end,
					},
				},
				OnLoad = Nurfed_AddonsCreate,
			},
		},
	},

  -- Bindings Panel
	{
		name = L["Bindings"],
		subtext = L["Direct spell, macro, item Bindings and Nurfed Button bindings.\nRight Click to select Rank, Select and Repeat Bind to Unbind."],
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
						OnVerticalScroll = function(self, val) 
							FauxScrollFrame_OnVerticalScroll(self, val, 14, Nurfed_ScrollBindings) 
						end,
						OnShow = function(self) Nurfed_ScrollBindings() end,
						OnMouseWheel = function(...) Nurfed_MouseWheelBindings(...) end,
					},
				},
				OnLoad = Nurfed_BindingsCreate,
			},
		},
	},
  -- arena panel
	{
  		name = ARENA,
		subtext = L["Options that affect Nurfed Arena"],
		addon = "Nurfed_Arena",
		menu = {
			input1 = {
				template = "nrf_editbox",
				Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", 0, 0 },
				vars = { text = L["2's Assist"], option = "arenaassist2" },
			},
			input2 = {
				template = "nrf_editbox",
				Anchor = { "TOPRIGHT", "$parentinput1", "BOTTOMRIGHT", 0, -15 },
				vars = { text = L["3's Assist"], option = "arenaassist3" },
			},
			input3 = {
				template = "nrf_editbox",
				Anchor = { "TOPRIGHT", "$parentinput2", "BOTTOMRIGHT", 0, -15 },
				vars = { text = L["5's Assist"], option = "arenaassist5" },
			},
			slider1 = {
				template = "nrf_slider",
				Anchor = { "TOPLEFT", "$parentinput1", "TOPRIGHT", 15, 0 },
				vars = {
					text = L["Frame Scale"],
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
				size = { 165, 80 },
				Point = { "BOTTOMLEFT", 5, 5 },
				vars = { text = L["Left Click"], option = "arenamacro1", ltrs = 255 },
			},
			macro2 = {
				template = "nrf_multiedit",
				size = { 165, 80 },
				Point = { "BOTTOMRIGHT", -27, 5 },
				vars = { text = L["Right Click"], option = "arenamacro2", ltrs = 255 },
			},
		},
	},
}

table.sort(panels, function(a, b) return b.name > a.name end)

for _, info in ipairs(panels) do
	if not info.addon or IsAddOnLoaded(info.addon) then
		local name = string.format("Nurfed%sPanel", info.name)
		local panel = Nurfed:create(name, "uipanel")
		panel.name = info.name
		panel.parent = "Nurfed"
		panel.default = function() end
    
		getglobal(name.."Title"):SetText(info.name)
		getglobal(name.."SubText"):SetText(info.subtext)

		for opt, tbl in pairs(info.menu) do
			Nurfed:create(name..opt, tbl, panel)
		end
		if name == "NurfedActionBarsPanel" then
			panel.expand = {}
			Nurfed_GenerateMenu("ActionBars", "nrf_actionbars_row", 19)
			panel:SetScript("OnHide", function()
				NurfedActionBarsPanelbuttondefault:SetParent(NurfedActionBarsPanelbutton)
				NurfedActionBarsPanelbuttonhelp:SetParent(NurfedActionBarsPanelbutton)
				NurfedActionBarsPanelbuttonharm:SetParent(NurfedActionBarsPanelbutton)
			end)
		end

		InterfaceOptions_AddCategory(panel)
	end
end

Nurfed_CustomConfig = Nurfed_CustomConfig or {}
function Nurfed_CreateCustomConfig(name)
	if Nurfed_CustomConfig[name] then
		for _, info in ipairs(Nurfed_CustomConfig[name]) do
			if not info.addon or IsAddOnLoaded(info.addon) then
				local name = string.format("Nurfed%sPanel", info.name)
				local panel = Nurfed:create(name, "uipanel")
				panel.name = info.name
				panel.parent = "Nurfed"
				panel.default = function() end
		    
				getglobal(name.."Title"):SetText(info.name)
				getglobal(name.."SubText"):SetText(info.subtext)

				for opt, tbl in pairs(info.menu) do
					Nurfed:create(name..opt, tbl, panel)
				end
				if name == "NurfedActionBarsPanel" then
					panel.expand = {}
					Nurfed_GenerateMenu("ActionBars", "nrf_actionbars_row", 19)
					panel:SetScript("OnHide", function()
						NurfedActionBarsPanelbuttondefault:SetParent(NurfedActionBarsPanelbutton)
						NurfedActionBarsPanelbuttonhelp:SetParent(NurfedActionBarsPanelbutton)
						NurfedActionBarsPanelbuttonharm:SetParent(NurfedActionBarsPanelbutton)
					end)
				end

				InterfaceOptions_AddCategory(panel)
			end
		end
	end
end

function Nurfed_ScrollActionBarsStates(self)
	local states = {}
	local bar = NurfedActionBarsPanel.bar
	--local tbl = NURFED_ACTIONBARS[bar].statemaps
	local tbl
	for i,v in ipairs(NURFED_ACTIONBARS) do
		if v.name == bar then
			tbl = v.statemaps
			break
		end
	end
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

	local frame = NurfedActionBarsPanelstatesscroll
	FauxScrollFrame_Update(frame, #states, 10, 14)
	for line = 1, 10 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("NurfedActionBarsPanelstates"..line)
		if offset <= #states then
			format_row(row, offset)
			row:Show()
		else
			row:Hide()
		end
	end
end

function Nurfed_ScrollActionBarsUnitStates(self)
	local states = {}
	local bar = NurfedActionBarsPanel.bar
	local tbl
	for i,v in ipairs(NURFED_ACTIONBARS) do
		if v.name == bar then
			if not v.unitmaps then v.unitmaps = {} end
			tbl = v.unitmaps
			break
		end
	end
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

	local frame = NurfedActionBarsPanelunitstatesscroll
	FauxScrollFrame_Update(frame, #states, 10, 14)
	for line = 1, 10 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("NurfedActionBarsPanelunitstates"..line)
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
	--[[for k in pairs(NURFED_ACTIONBARS) do
		table.insert(bars, k)
	end]]
	for i in ipairs(NURFED_ACTIONBARS) do
		table.insert(bars, NURFED_ACTIONBARS[i].name)
	end
	table.sort(bars, function(a, b) return a < b end)
	for k, v in ipairs(bars) do
		if NurfedActionBarsPanel.expand[v] then
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
		if NurfedActionBarsPanel.bar == bar then
			row:LockHighlight()
		else
			row:UnlockHighlight()
		end
		if NurfedActionBarsPanel.expand[bar] then
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

	local frame = NurfedActionBarsPanelscroll
	FauxScrollFrame_Update(frame, #bars, 20, 14)
	for line = 1, 20 do
		local offset = line + FauxScrollFrame_GetOffset(frame)
		local row = getglobal("NurfedActionBarsRowPanel"..line)
		if row then
			if offset <= #bars then
				format_row(row, offset)
				row:Show()
			else
				row:Hide()
			end
		end
	end
end

function Nurfed_ToggleStates(self)
	local bar = NurfedActionBarsPanel.bar
	local pbar = self:GetParent().bar
	if bar and bar == pbar and getglobal(bar):GetID() == 0 then
		if self:GetChecked() then
			NurfedActionBarsPanelbar:Hide()
			NurfedActionBarsPanelstates:Show()
		else
			NurfedActionBarsPanelstates:Hide()
			NurfedActionBarsPanelbar:Show()
		end
	end
end

function Nurfed_ToggleUnitStates(self)
	local bar = NurfedActionBarsPanel.bar
	local pbar = self:GetParent().bar
	if bar and bar == pbar and getglobal(bar):GetID() == 0 then
		if self:GetChecked() then
			NurfedActionBarsPanelbar:Hide()
			NurfedActionBarsPanelunitstates:Show()
		else
			NurfedActionBarsPanelunitstates:Hide()
			NurfedActionBarsPanelbar:Show()
		end
	end
end

function Nurfed_ActionBar_OnClick(button)
	local barname = this.bar
	local state = getglobal(this:GetName().."states"):GetChecked()
	NurfedActionBarsPanelbar:Hide()
	NurfedActionBarsPanelstates:Hide()
	NurfedActionBarsPanelbutton:Hide()
	NurfedActionBarsPaneldefaults:Show()
	NurfedActionBarsPanelbuttondefault:SetParent(NurfedActionBarsPanelbutton)
	NurfedActionBarsPanelbuttonhelp:SetParent(NurfedActionBarsPanelbutton)
	NurfedActionBarsPanelbuttonharm:SetParent(NurfedActionBarsPanelbutton)
	if NurfedActionBarsPanel.bar == barname then
		NurfedActionBarsPanel.bar = nil
	else
		NurfedActionBarsPanel.bar = barname
		NurfedActionBarsPaneldefaults:Hide()
		local bar = _G[barname]
		if bar:GetID() > 0 then
			NurfedActionBarsPanelbutton:Show()
			local hdr = bar:GetParent()
			local children = { NurfedActionBarsPanelbutton:GetChildren() }
			for _, child in ipairs(children) do
				hdr:SetAttribute("addchild", child)
				child:SetAttribute("statebutton", bar:GetAttribute("statebutton"))
			end
			updatebuttons()
		else
			if state then
				NurfedActionBarsPanelstates:Show()
				Nurfed_ScrollActionBarsStates()
			else
				NurfedActionBarsPanelbar:Show()
				updateoptions()
			end
		end
	end
	Nurfed_ScrollActionBars()
end

function Nurfed_DeleteState(self)
	local state = self:GetParent().state
	local bar = NurfedActionBarsPanel.bar
	local hdr = getglobal(bar)
	for i,v in ipairs(NURFED_ACTIONBARS) do
		if v.name == bar then
			NURFED_ACTIONBARS[i].statemaps[state] = nil
			break
		end
	end
	hdr:SetAttribute("statemap-"..state, nil)
	Nurfed:updatebar(hdr)
	Nurfed_ScrollActionBarsStates()
end

function Nurfed_DeleteUnitState(self)
	local state = self:GetParent().state
	local bar = NurfedActionBarsPanel.bar
	local hdr = getglobal(bar)
	for i,v in ipairs(NURFED_ACTIONBARS) do
		if v.name == bar then
			NURFED_ACTIONBARS[i].unitmaps[state] = nil
			break
		end
	end
	--hdr:SetAttribute("statemap-"..state, nil)
	Nurfed:updatebar(hdr)
	Nurfed_ScrollActionBarsUnitStates()
end

function Nurfed_DeleteBar()
	local bar = this:GetParent().bar
	Nurfed:deletebar(bar)
	for i in ipairs(NURFED_ACTIONBARS) do
		if NURFED_ACTIONBARS[i].name == bar then
			--NURFED_ACTIONBARS[i] = nil
			table.remove(NURFED_ACTIONBARS, i)
			break
		end
	end
	Nurfed_ScrollActionBars()
	NurfedActionBarsPanel.bar = nil
end

function Nurfed_ExpandBar()
	local bar = this:GetParent().bar
	if NurfedActionBarsPanel.expand[bar] then
		NurfedActionBarsPanel.expand[bar] = nil
	else
		NurfedActionBarsPanel.expand[bar] = true
	end
	Nurfed_ScrollActionBars()
end

function nrf_test(num)
	local zeronum, onenum = 0,0
	local string = ""
	local i = 1
	while i <= num do
		local ran = math.random(0, 1)
		if ran == 0 then
			zeronum = zeronum + 1
		else
			onenum = onenum + 1
		end
		string = string..","..ran
		i = i + 1
	end
	string = string:tostring()
	Nurfed:print("string:"..string)
	if zeronum > onenum then
		Nurfed:print("|cff00ff00Zero#:"..zeronum.."|r   One#:"..onenum)
	else
		Nurfed:print("Zero#:"..zeronum.."   |cff00ff00One#:"..onenum)
	end		
end

Nurfed:setver("$Date$", 1)
Nurfed:setrev("$Rev$", 1)