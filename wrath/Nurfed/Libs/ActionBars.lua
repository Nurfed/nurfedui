------------------------------------------
--  Nurfed Action Bar Library
------------------------------------------

-- Locals
local _G = getfenv(0)
local pairs = _G.pairs
local ipairs = _G.ipairs
local isloaded
local playerClass = select(2, UnitClass("player"))
local UnitCanAttack = _G.UnitCanAttack
local UnitCanAssist = _G.UnitCanAssist
local GetItemCount = _G.GetItemCount
local GetSpellCount = _G.GetSpellCount
local IsEquipedItem = _G.IsEquipedItem
local GetMacroItem = _G.GetMacroItem
local GetMacroSpell = _G.GetMacroSpell
local GetSpellName = _G.GetSpellName
local GetSpellCount = _G.GetSpellCount
local GetSpellTexture = _G.GetSpellTexture
local GetSpellCooldown = _G.GetSpellCooldown
local GetItemCooldown = _G.GetItemCooldown
local SecureButton_GetAttribute = _G.SecureButton_GetAttribute
local SecureButton_GetUnit = _G.SecureButton_GetUnit
local SecureButton_GetModifiedAttribute = _G.SecureButton_GetModifiedAttribute
local IsAttackSpell = _G.IsAttackSpell
local IsAutoRepeatSpell = _G.IsAutoRepeatSpell
local GetMacroInfo = _G.GetMacroInfo
local GameTooltip_SetDefaultAnchor = _G.GameTooltip_SetDefaultAnchor
local GameTooltip = _G.GameTooltip
local GetItemInfo = _G.GetItemInfo
local GetMacroBody = _G.GetMacroBody
local GetCompanionInfo = _G.GetCompanionInfo
local SecureCmdOptionParse = _G.SecureCmdOptionParse
local InCombatLockdown = _G.InCombatLockdown
local convert = _G.convert
local PickupSpell = _G.PickupSpell
local PickupItem = _G.PickupItem
local PickupMacro = _G.PickupMacro
local UnitExists = _G.UnitExists
local GetCursorInfo = _G.GetCursorInfo
local ClearCursor = _G.ClearCursor
local IsCurrentSpell = _G.IsCurrentSpell
local IsUsableSpell = _G.IsUsableSpell
local SpellHasRange = _G.SpellHasRange
local IsSpellInRange = _G.IsSpellInRange
local IsUsableItem = _G.IsUsableItem
local ItemHasRange = _G.ItemHasRange
local IsItemInRange = _G.IsItemInRange
local GetActiveTalentGroup = _G.GetActiveTalentGroup
local Nurfed = _G.Nurfed
local L = _G.Nurfed:GetTranslations()
local companionList
local lbf = _G["LibStub"] and _G.LibStub("LibButtonFacade", true) or nil
local lbfg, lbfg_virtual, lbfg_blizzard
local currentTalentGroup

NURFED_ACTIONBARS = NURFED_ACTIONBARS or {
	[1] = {
		[1] = {
			name = "Nurfed_Bar1",
			rows = 1,
			cols = 12,
			scale = 1,
			alpha = 1,
			unitshow = false,
			xgap = 2,
			ygap = 2,
			buttons = {},
			statemaps = {},
			visible = "show",
		},
		talentGroup = 1,
	},
	[2] = {
		[1] = {
			name = "Nurfed_Bar1",
			rows = 1,
			cols = 12,
			scale = 1,
			alpha = 1,
			unitshow = false,
			xgap = 2,
			ygap = 2,
			buttons = {},
			statemaps = {},
			visible = "show",
		},
		talentGroup = 2,
	},
}
----------------------------------------------------------------
-- Meta Tables (Expect to see a lot more of these used in the future)
-- Cache the data, so that we arent constantly pulling texture functions.  rwar
local icons = setmetatable({}, {__index = function(self, key)
	self[key] = GetSpellTexture(key) or "Interface\\Icons\\NoIcon"
	return self[key]
end,})

local function clearMetaTables()
	for name, texture in pairs(icons) do
		if texture == "Interface\\Icons\\NoIcon" then
			icons[name] = nil
		end
	end
end
----------------------------------------------------------------
-- Button functions

local function updateCompanionList()
	if not companionList then
		companionList = {}
	end
	local mnum = GetNumCompanions("MOUNT")
	if mnum and mnum > 0 then
		for i=1, mnum do
			local _, name, id = GetCompanionInfo("MOUNT", i)
			if name and id then
				if not icons[name] or (icons[name] and icons[name] == "Interface\\Icons\\NoIcon") then
					if name:find("Mount") then
						companionList[name:gsub("%sMount", "")] = id
						icons[name:gsub("%sMount", "")] = select(3, GetSpellInfo(id))
					end
					companionList[name] = id
					icons[name] = select(3, GetSpellInfo(id))
				end
			else
				-- if there isnt a name, and there should be, stop updating and rerun func.
				return Nurfed:schedule(1, updateCompanionList)
			end
		end
	end
	mnum = GetNumCompanions("CRITTER")
	if mnum and mnum > 0 then
		for i=1, mnum do
			local _, name, id = GetCompanionInfo("CRITTER", i)
			if name and id then
				if not icons[name] or (icons[name] and icons[name] == "Interface\\Icons\\NoIcon") then
					companionList[name] = id
					icons[name] = select(3, GetSpellInfo(id))
				end
			else
				-- if there isnt a name, and there should be, stop updating and rerun func.
				return Nurfed:schedule(1, updateCompanionList)
			end
		end
	end
end
function nrftest(...)
	return icons[...]
end

local function updateitem(btn)
	if btn.spell then
		local count = _G[btn:GetName().."Count"]
		local border = _G[btn:GetName().."Border"]

		if btn.type == "spell" then
			local reg = GetSpellCount(btn.spell)
			if reg and reg > 0 then
				count:SetText(reg)
			else
				count:SetText(nil)
			end
			border:Hide()
			
		elseif btn.type == "item" then
			local num = GetItemCount(btn.spell)
			if num > 1 then
				count:SetText(num)
			else
				count:SetText(nil)
			end
			if IsEquippedItem(btn.spell) then
				border:SetVertexColor(0, 1.0, 0, 0.35)
				border:Show()
			else
				border:Hide()
			end
		elseif btn.type == "macro" then
			local item, link = GetMacroItem(btn.spell)
			local spell, rank = GetMacroSpell(btn.spell)
			if item then
				local num = GetItemCount(item)
				if num > 1 then
					count:SetText(num)
				else
					count:SetText(nil)
				end
				if IsEquippedItem(item) then
					border:SetVertexColor(0, 1.0, 0, 0.35)
					border:Show()
				else
					border:Hide()
				end
			elseif spell then
				local reg = GetSpellCount(spell)
				if reg and reg > 0 then
					count:SetText(reg)
				else
					count:SetText(nil)
				end
				border:Hide()
			else
				border:Hide()
				count:SetText(nil)
			end
		end
	end
end

local function updatecooldown(btn)
	if btn.companionID then return end
	local start, duration, enable = 0, 0, 0
	if btn.spell then
		if btn.type == "spell" then
			start, duration, enable = GetSpellCooldown(btn.spell)
		elseif btn.type == "item" then
			start, duration, enable = GetItemCooldown(btn.spell)
		elseif btn.type == "macro" then
			local item, link = GetMacroItem(btn.spell)
			local spell, rank = GetMacroSpell(btn.spell)
			if item then
				start, duration, enable = GetItemCooldown(item)
			elseif spell then
				start, duration, enable = GetSpellCooldown(spell)
			end
		end
	end
	if start and duration then
		CooldownFrame_SetTimer(_G[btn:GetName().."Cooldown"], start, duration, enable)
	end
end

-- unlocalize and change the name to an unused global to allow hooking from PT3Bar and AutoBar etc
-- No Reason to use "CooldownCount" etc if this function does everything we want in a nice clean fashion
--local cooldowntext = function(btn)
--nrfcooldowntext = function(btn)
function nrfcooldowntext(btn)
	local cd = _G[btn:GetName().."Cooldown"]
	if cd and cd.text and cd.cool then
		local cdscale = cd:GetScale()
		local r, g, b = 1, 0, 0
		local height = floor(20 / cdscale)
		local fheight = select(2, cd.text:GetFont())
		local remain = (cd.start + cd.duration) - GetTime()
		if remain >= 0 then
			remain = math.round(remain)
		
			if remain >= 3600 then
				remain = math.floor(remain / 3600).."h"
				r, g, b = 0.6, 0.6, 0.6
				height = floor(12 / cdscale)
			
			elseif remain >= 60 then
				local min = math.floor(remain / 60)
				r, g, b = 1, 1, 0
				height = floor(12 / cdscale)

				if min < 10 then
					local secs = math.floor(math.fmod(remain, 60))
					remain = string.format("%2d:%02s", min, secs)
				else
					remain = min.."m"
				end
			end
			cd.text:SetText(remain)
			cd.text:SetTextColor(r, g, b)
			if height ~= fheight and not cd.disableheight then
				cd.text:SetFont("Fonts\\FRIZQT__.TTF", height, "OUTLINE")
				cd:SetFrameLevel(30)
			end
		else
			cd.text:SetText(nil)
			cd.cool = nil
		end
	end
end

local function convert(btn, value)
	local unit = SecureButton_GetAttribute(btn, "unit")
	if unit and unit ~= "none" and UnitExists(unit) then
		if UnitCanAttack("player", unit) then
			value = SecureButton_GetModifiedAttribute(btn, "harmbutton", value) or value
		elseif UnitCanAssist("player", unit) then
			value = SecureButton_GetModifiedAttribute(btn, "helpbutton", value) or value
		end
	end
	return value
end

local function seticon(btn)
	local value = btn:GetParent():GetAttribute("state")
	if value then
		value = convert(btn, value)
		local texture, spell, attrib
		local text = _G[btn:GetName().."Name"]
		local new = SecureButton_GetModifiedAttribute(btn, "type", value)
		btn.type = new
		btn.attack = nil
		text:SetText(nil)
		if new then
			spell = SecureButton_GetModifiedAttribute(btn, new, value)
			if spell then
				if new == "spell" then
					clearMetaTables() -- clear the garbaged cache if it exists (for some reason)
					local txture = icons[spell]
					if txture == "Interface\\Icons\\NoIcon" then
						txture = nil;
					else
						texture = txture
					end
					if IsAttackSpell(spell) or IsAutoRepeatSpell(spell) then
						btn.attack = true
					end
					
				elseif new == "item" then
					local itemid = SecureButton_GetModifiedAttribute(btn, "itemid", value)
					if itemid then
						texture = select(10, GetItemInfo(itemid))
					end
				
				elseif new == "macro" then
					local id = btn:GetAttribute("*macroID"..value)
					if id then
						texture = GetActionTexture(id)
						spell = GetActionText(id)
					else
						spell, texture = GetMacroInfo(spell)
					end
					if Nurfed:getopt("macrotext") then
						text:SetText(spell)
					else
						text:SetText("")
					end
				end
			end
			btn.spell = spell
			if not attrib then-- clear the spell id for non-companions
				btn.companionID = nil
			end
		end

		local icon = _G[btn:GetName().."Icon"]
		if icon:GetTexture() ~= texture then
			icon:SetTexture(texture)
			if texture then
				btn:SetAlpha(1)
				if Nurfed:getopt("fadein") then
					UIFrameFadeIn(icon, 0.25)
				end
			end
			updateitem(btn)
			updatecooldown(btn)
		end
		if not texture and not btn.grid then
			btn:SetAlpha(0)
		end
	end
end

----------------------------------------------------------------
-- Button creation and management
local function btnenter(self)
	local tooltip = Nurfed:getopt("tooltips")
	if tooltip and self.type then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		if self.type == "spell" then
			local id = Nurfed:getspell(self.spell)
			if id and GetSpellLink(id, BOOKTYPE_SPELL) then
				local rank = select(2, GetSpellName(id, BOOKTYPE_SPELL))
				GameTooltip:SetHyperlink(GetSpellLink(id, BOOKTYPE_SPELL))
				if rank then
					GameTooltipTextRight1:SetText(rank)
					GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
					GameTooltipTextRight1:Show()
				end
			else
				if not companionList then
					updateCompanionList()
				end
				if companionList and companionList[self.spell] then
					GameTooltip:SetHyperlink("spell:"..companionList[self.spell])
				end
			end
		
		elseif self.type == "item" then
			if GetItemInfo(self.spell) then
				GameTooltip:SetHyperlink(select(2, GetItemInfo(self.spell)))
			end
		
		elseif self.type == "macro" and GetMacroBody(self.spell) then
			local bdy = GetMacroBody(self.spell)
			local action = SecureCmdOptionParse(bdy)
			if action then
				if bdy:find("/cast") then
					local taction = bdy:match("/ca%a+ [%a%s]+")
					if taction then
						taction = taction:gsub("/ca%a+ ", ""):gsub("%c", "")
						action = taction
					end
				end
				if companionList and companionList[action] then
					GameTooltip:SetHyperlink("spell:"..companionList[action])
				
				elseif GetItemInfo(action) then
					GameTooltip:SetHyperlink(select(2, GetItemInfo(action)))
				else
					local id = Nurfed:getspell(action)
					if id then
						local rank = select(2, GetSpellName(id, BOOKTYPE_SPELL))
						GameTooltip:SetHyperlink(GetSpellLink(id, BOOKTYPE_SPELL))
						if rank then
							GameTooltipTextRight1:SetText(rank)
							GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
							GameTooltipTextRight1:Show()
						end
					end
				end
			end
		end
		GameTooltip:Show()
	end
end

local function btndragstart(self)
	if not NRF_LOCKED and not InCombatLockdown() then
		local state = self:GetParent():GetAttribute("state")
		if state == "0" then
			state = "LeftButton"
		end
		
		local value = convert(self, state)
		local new = SecureButton_GetModifiedAttribute(self, "type", value)
		if new then
			spell = SecureButton_GetModifiedAttribute(self, new, value)
			if spell then
				local state, value = state, value
				if state == "LeftButton" then
					value = "*"
				else
					value = "-"..value
				end
				if new == "spell" then
					if companionList and companionList[spell] then
						for i=1, GetNumCompanions("MOUNT") do
							if select(3, GetCompanionInfo("MOUNT", i)) == companionList[spell] then
								PickupCompanion("MOUNT", i)
								break
							end
						end
						for i=1, GetNumCompanions("CRITTER") do
							if select(3, GetCompanionInfo("CRITTER", i)) == companionList[spell] then
								PickupCompanion("CRITTER", i)
								break
							end
						end
						-- do nothing.
					else
						if Nurfed:getspell(spell) then
							PickupSpell(Nurfed:getspell(spell), BOOKTYPE_SPELL)
						else
							self.spell = nil
						end
					end
				elseif new == "item" then
					PickupItem(spell)
				elseif new == "macro" then
					PickupMacro(spell)
					self:SetAttribute("*macroID"..value, nil)
				end
			end

			if state == "LeftButton" then
				value = "*"
			else
				value = "-"..value
			end
			self:SetAttribute("*type"..value, nil)
			self:SetAttribute("*"..new..value, nil)

			local unit = SecureButton_GetModifiedUnit(self, state)
			local useunit = self:GetParent():GetAttribute("useunit")
			if useunit and unit and unit ~= "none" and UnitExists(unit) then
				if state == "LeftButton" then
					state = "*"
				else
					state = "-"..state
				end
				if UnitCanAttack("player", unit) then
					self:SetAttribute("*harmbutton"..state, nil)
				elseif UnitCanAssist("player", unit) then
					self:SetAttribute("*helpbutton"..state, nil)
				end
			end
		end
	end
end

local function btnreceivedrag(self)
	if GetCursorInfo() and not InCombatLockdown() then
		local oldtype = self.type
		local oldspell = self.spell
		local cursor, arg1, arg2 = GetCursorInfo()
		local value = self:GetParent():GetAttribute("state")
		if value == "0" then
			value = nil
		end
		local unit = SecureButton_GetModifiedUnit(self, (value or "LeftButton"))
		if value then
			value = "-"..value
		else
			value = "*"
		end
		
		local useunit = self:GetParent():GetAttribute("useunit")
		if useunit and unit and unit ~= "none" and UnitExists(unit) then
			if UnitCanAttack("player", unit) then
				self:SetAttribute("*harmbutton"..value, "nuke"..value)
				value = "-nuke"..value
			elseif UnitCanAssist("player", unit) then
				self:SetAttribute("*helpbutton"..value, "heal"..value)
				value = "-heal"..value
			end
		end
		self:SetAttribute("*type"..value, cursor)
		--Clear Attributes
		self:SetAttribute("*spell"..value, nil)
		self:SetAttribute("*item"..value, nil)
		self:SetAttribute("*itemid"..value, nil)
		self:SetAttribute("*macro"..value, nil)
		self:SetAttribute("*macroID"..value, nil)
		if cursor == "companion" then
			local id = select(3, GetCompanionInfo(arg2, arg1))
			spell = GetSpellInfo(id)
			self:SetAttribute("*spell"..value, spell)
			-- find a way to use the attribute id 'companion' which I imagine is in now.
			self:SetAttribute("*type"..value, "spell")
			
			
		elseif cursor == "spell" then
			local spell, rank = GetSpellName(arg1, arg2)
			if rank:find(RANK) then
				spell = spell.."("..rank..")"
			elseif spell:find("%(") then
				spell = spell.."()"
			end
			self:SetAttribute("*spell"..value, spell)
			
		elseif cursor == "item" then
			self:SetAttribute("*item"..value, GetItemInfo(arg1))
			self:SetAttribute("*itemid"..value, arg1)
			
		elseif cursor == "macro" then
			self:SetAttribute("*macro"..value, arg1)
			for i=1, 72 do
				if select(2, GetActionInfo(i)) == arg1 then
					self:SetAttribute("*macroID"..value, i)
					break
				end
			end
		end 
		ClearCursor()

		if oldtype and oldspell then
			if oldtype == "spell" then
				local id = Nurfed:getspell(oldspell)
				if id then
					PickupSpell(id, BOOKTYPE_SPELL)
					-- patch 3.0.1
					--if we just use PickupSpell, it doesn't always seem to work.  Possibly a blizz bug, until a fix
					-- is found, use this.  nrf:sched(time, func) time == 0, func() done on next frame (0.001 second~)
					--[[
					Nurfed:schedule(0, function() 
						if not GetCursorInfo() then 
							PickupSpell(id, BOOKTYPE_SPELL) 
						end 
					end)]]
				end
			elseif oldtype == "item" then
				-- do nothing?
			elseif oldtype == "macro" then
				PickupMacro(oldspell)
			end
		end
	end
end

local function saveattrib(self, name, value)
	if name:find("^%*") or name:find("^shift") or name:find("^ctrl") or name:find("^alt") then
		local parent = self:GetParent():GetName()
		for _, tbl in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
			if tbl.name == parent then
				if not self:GetAttribute("possessButton") then
					tbl.buttons[self:GetID()][name] = value
				end
				name = "state-parent"
				break
			end
		end
	end
	if name == "state-parent" then seticon(self) end
end

local live, dead = {}, {}

local function getbtn(hdr)
	local btn
	if #dead > 0 then
		btn = table.remove(dead)
	else
		local new = #live + 1
		--btn = CreateFrame("CheckButton", "Nurfed_Button"..new, hdr, "SecureActionButtonTemplate ActionButtonTemplate")
		btn = CreateFrame("CheckButton", "Nurfed_Button"..new, hdr, "SecureActionButtonTemplate  ActionButtonTemplate")
		RegisterStateDriver(btn, "possesstest", "[bonusbar:5]s1;s2")

		--hdr:SetAttribute("_adopt", btn)
		btn:RegisterForClicks("AnyUp")
		btn:RegisterForDrag("LeftButton")
		
		btn:SetAttribute("checkselfcast", true)
		btn:SetAttribute("useparent-unit", true)
		btn:SetAttribute("useparent-statebutton", true)

		btn:SetScript("OnEnter", btnenter)
		btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
		btn:SetScript("OnDragStart", btndragstart)
		btn:SetScript("OnReceiveDrag", btnreceivedrag)
		
		btn:SetScript("PreClick", function(self)
			if GetCursorInfo() and not InCombatLockdown() then
				self.unwrapped = true
				hdr:UnwrapScript(self, "OnClick")
				hdr:WrapScript(self, "OnClick", [[ return false ]])
				btnreceivedrag(self)
			end
		end)
		
		btn:SetScript("PostClick", function(self)
			self:SetChecked(nil)
			if self.unwrapped then
				hdr:UnwrapScript(self, "OnClick")
				hdr:WrapScript(self, "OnClick", [[ return state ]])
				self.unwrapped = nil
			end
		end)
		
		local cd = _G[btn:GetName().."Cooldown"]
		cd.text = cd:CreateFontString(nil, "OVERLAY")
		cd.text:SetPoint("CENTER")
		cd.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
		
		local flash = _G[btn:GetName().."Flash"]
		flash:ClearAllPoints()
		flash:SetAllPoints(cd)
		btn.flashtime = 0
	end
	table.insert(live, btn)
	btn:SetScript("OnAttributeChanged", saveattrib)
	hdr:UnwrapScript(btn, "OnClick")
	hdr:WrapScript(btn, "OnClick", [[ return state ]])
	return btn
end

local function delbtn(btn)
	for k, v in ipairs(live) do
		if v == btn then
			table.remove(live, k)
			table.insert(dead, btn)
			break
		end
	end

	btn:SetScript("OnAttributeChanged", nil)

	local attribs
	local parent = btn:GetParent():GetName()
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		if v.name == parent then
			attribs = v.buttons[btn:GetID()]
			break
		end
	end
	if attribs then
		for k in pairs(attribs) do
			btn:SetAttribute(k, nil)
		end
	end

	btn:SetParent(UIParent)
	btn:Hide()
	btn:SetID(0)
	_G[btn:GetName().."HotKey"]:SetText(nil)
end

----------------------------------------------------------------
-- Button events
local btnevents = {
	["PLAYER_TARGET_CHANGED"] = function(btn)
		if SecureButton_GetUnit(btn) == "target" then
			seticon(btn)
		end
	end,
	["PLAYER_FOCUS_CHANGED"] = function(btn)
		if SecureButton_GetUnit(btn) == "focus" then
			seticon(btn)
		end
	end,
	
	["COMPANION_UPDATE"] = seticon,
	["NURFED_UPDATE_ICONS"] = seticon,
	["PLAYER_ENTERING_WORLD"] = seticon,
	["MODIFIER_STATE_CHANGED"] = seticon,
	["ACTIONBAR_UPDATE_STATE"] = seticon,
	["UPDATE_BONUS_ACTIONBAR"] = seticon,
	
	["ACTIONBAR_UPDATE_USABLE"] = updatecooldown,
	["UPDATE_INVENTORY_ALERTS"] = updatecooldown,
	["ACTIONBAR_UPDATE_COOLDOWN"] = updatecooldown,

	["PLAYER_REGEN_ENABLED"] = function(btn) seticon(btn); updatecooldown(btn); end,
	["PLAYER_REGEN_DISABLED"] = function(btn) seticon(btn); updatecooldown(btn); end,
	
	["UPDATE_BINDINGS"] = function(btn)
		if isloaded then
			local id = btn:GetID()
			if id > 0 then
				local key = GetBindingKey("CLICK "..btn:GetName()..":LeftButton")
				local parent = btn:GetParent():GetName()
				if parent ~= "UIParent" then
					for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
						if v.name == parent then
							v.buttons[id].bind = key
							break
						end
					end
					if key then
						key = Nurfed:binding(key)
					end
					if Nurfed:getopt("showbindings") then
						_G[btn:GetName().."HotKey"]:SetText(key)
						_G[btn:GetName().."HotKey"]:Show()
					else
						_G[btn:GetName().."HotKey"]:SetText(nil)
						_G[btn:GetName().."HotKey"]:Hide()
					end
					if Nurfed:getopt("macrotext") and btn.type == "macro" then
						_G[btn:GetName().."Name"]:SetText(btn.spell)
					else
						_G[btn:GetName().."Name"]:SetText(nil)
					end
				end
			end
		end
	end,
	["NRF_TOGGLE_NUMBER_TEXT"] = function(btn, toggle)
		if not _G[btn:GetName().."NumberText"] then
			btn:CreateFontString(btn:GetName().."NumberText", "OVERLAY")
			_G[btn:GetName().."NumberText"]:SetFont("Fonts\\FRIZQT__.TTF", 24 * btn:GetScale(), "OUTLINE")
			_G[btn:GetName().."NumberText"]:SetPoint("CENTER", btn, "CENTER", 0, 0)
		end
		_G[btn:GetName().."NumberText"]:SetText(btn:GetName():gsub("Nurfed_Button", ""))
		if toggle then
			_G[btn:GetName().."NumberText"]:Show()
		else
			_G[btn:GetName().."NumberText"]:Hide()
		end
	end,

	["UPDATE_MACROS"] = function(btn)
		if btn.type == "macro" then
			seticon(btn)
		end
	end,

	["BAG_UPDATE"] = updateitem,
	["UNIT_SPELLCAST_SUCCEEDED"] = function(btn)
		if btn.type == "macro" then
			btn.macro = true
		end
	end,
	["ACTIONBAR_SHOWGRID"] = function(btn)
		btn.grid = true
		btn:SetAlpha(1)
	end,
	["ACTIONBAR_HIDEGRID"] = function(btn)
		btn.grid = nil
		if not _G[btn:GetName().."Icon"]:GetTexture() then
			btn:SetAlpha(0)
		end
	end,
	
	["START_AUTOREPEAT_SPELL"] = function(btn) btn.flash = true end,
	["STOP_AUTOREPEAT_SPELL"] = function(btn) btn.flash = nil end,

	["PLAYER_ENTER_COMBAT"] = function(btn) btn.flash = true end,
	["PLAYER_LEAVE_COMBAT"] = function(btn) btn.flash = nil end,

	["UNIT_FACTION"] = function(btn, unit)
		if SecureButton_GetUnit(btn) == unit then
			seticon(btn);
		end
	end,
}

local function btnevent(event, ...)
	for _, btn in ipairs(live) do
		btnevents[event](btn, ...);
	end
end

for event, _ in pairs(btnevents) do
	Nurfed:regevent(event, btnevent);
end

local optColorNoMana, optColorNotUsable, optColorNoRange, optColorBaseColor = {}, {}, {}, {}
function NurfedActionBarsUpdateColors()
	-- recycle the tables, don't recreate it
	for i,v in ipairs(Nurfed:getopt("actionbarnomana")) do
		optColorNoMana[i] = v
	end
	for i,v in ipairs(Nurfed:getopt("actionbarnotusable")) do
		optColorNotUsable[i] = v
	end
	for i,v in ipairs(Nurfed:getopt("actionbarnorange")) do
		optColorNoRange[i] = v
	end
	for i,v in ipairs(Nurfed:getopt("actionbarbasecolor")) do
		optColorBaseColor[i] = v
	end
end

local function btnupdate()
	for _, btn in ipairs(live) do
		local r, g, b = optColorBaseColor[1], optColorBaseColor[2], optColorBaseColor[3]--1, 1, 1;
		local unit = SecureButton_GetUnit(btn);
		if btn.type == "spell" then
			if IsCurrentSpell(btn.spell) or UnitCastingInfo("player") == btn.spell then
				btn:SetChecked(true);
			else
				btn:SetChecked(nil);
			end
			if companionList[btn.spell] then
				if UnitAffectingCombat("player") then
					r, g, b = optColorNotUsable[1], optColorNotUsable[2], optColorNotUsable[3] --0.4, 0.4, 0.4;
				end
			else
				local usable, nomana = IsUsableSpell(btn.spell);
				if nomana then
					r, g, b = optColorNoMana[1], optColorNoMana[2], optColorNoMana[3] --0.5, 0.5, 1;
				elseif not usable then
					r, g, b = optColorNotUsable[1], optColorNotUsable[2], optColorNotUsable[3] --0.4, 0.4, 0.4;
				elseif SpellHasRange(btn.spell) and IsSpellInRange(btn.spell, unit) == 0 then
					r, g, b = optColorNoRange[1], optColorNoRange[2], optColorNoRange[3]--1, 0, 0;
				end
			end
	
		elseif btn.type == "item" then
			if not IsUsableItem(btn.spell) then
				r, g, b = optColorNotUsable[1], optColorNotUsable[2], optColorNotUsable[3] --0.4, 0.4, 0.4;
			elseif ItemHasRange(btn.spell) and IsItemInRange(btn.spell, unit) == 0 then
				r, g, b = optColorNoRange[1], optColorNoRange[2], optColorNoRange[3]--1, 0, 0;
			end
			
		elseif btn.type == "macro" then
			local item, link = GetMacroItem(btn.spell);
			local spell, rank = GetMacroSpell(btn.spell);
			if item then
				if not IsUsableItem(item) then
					r, g, b = optColorNotUsable[1], optColorNotUsable[2], optColorNotUsable[3] --0.4, 0.4, 0.4;
				elseif ItemHasRange(item) and IsItemInRange(item, unit) == 0 then
					r, g, b = optColorNoRange[1], optColorNoRange[2], optColorNoRange[3]--1, 0, 0;
				end
			
			elseif spell then
				if companionList and companionList[spell] then
					if InCombatLockdown() then
						r, g, b = optColorNotUsable[1], optColorNotUsable[2], optColorNotUsable[3] --0.4, 0.4, 0.4;
					end
				else
					local usable, nomana = IsUsableSpell(spell);
					if nomana then
						r, g, b = optColorNoMana[1], optColorNoMana[2], optColorNoMana[3] --0.5, 0.5, 1;
					elseif not usable then
						r, g, b = optColorNotUsable[1], optColorNotUsable[2], optColorNotUsable[3] --0.4, 0.4, 0.4;
					elseif SpellHasRange(spell) and IsSpellInRange(spell, unit) == 0 then
						r, g, b = optColorNoRange[1], optColorNoRange[2], optColorNoRange[3]--1, 0, 0;
					end
				end
			end

			if btn.macro then
				seticon(btn);
				btn.macro = nil;
			end
		end
		_G[btn:GetName().."Icon"]:SetVertexColor(r, g, b);
		nrfcooldowntext(btn);
	end
end

Nurfed:schedule(TOOLTIP_UPDATE_TIME, btnupdate, true)

local function btnflash()
	for _, btn in ipairs(live) do
		local flash = _G[btn:GetName().."Flash"];
		if btn.flash and btn.attack then
			if flash:IsVisible() then
				flash:Hide();
			else
				flash:Show();
			end
		else
			flash:Hide();
		end
	end
end

Nurfed:schedule(ATTACK_BUTTON_FLASH_TIME, btnflash, true);

----------------------------------------------------------------
-- Reset stance bar border
if IsAddOnLoaded("Bartender3") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("TrinityBars") or IsAddOnLoaded("Bongos2_ActionBar") or IsAddOnLoaded("Bongos3_ActionBar") or IsAddOnLoaded("Dominos") then
else
	hooksecurefunc("UIParent_ManageFramePositions", function()
		if not MainMenuBar:IsShown() then
			for i = 1, 10 do
				local border = _G["ShapeshiftButton"..i.."NormalTexture"];
				border:SetWidth(50);
				border:SetHeight(50);
				border = _G["PossessButton"..i.."NormalTexture"];
				if border then
					border:SetWidth(50);
					border:SetHeight(50);
				end
			end
		end
	end)
end

----------------------------------------------------------------
-- Add cooldown text
local function updatecooling(self, start, duration, enable)
	if not self:GetName() or not self.text then return end
	if start > 2 and duration > 2 then
		self.cool = true;
		self.start = start;
		self.duration = duration;
	else
		self.cool = nil;
		self.text:SetText(nil);
	end
end

if not GetAddOnMetadata("OmniCC", "Version") and not IsAddOnLoaded("CooldownCount") then
	hooksecurefunc("CooldownFrame_SetTimer", updatecooling);
end

----------------------------------------------------------------
-- Action bar management
function Nurfed:updatebar(hdr)
	local state, visible;
	local btns, statelist, driver, unitlist, unitdriver = {}, {}, {}, {}, {}
	for _, child in ipairs({ hdr:GetChildren() }) do
		if child:GetName():find("^Nurfed_Button") then
			table.insert(btns, child:GetID(), child);
			if hdr.lbf then
				hdr.lbf:AddButton(child)
			end
		end
	end

	local vals;
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		if v.name == hdr:GetName() then
			vals = v;
			break
		end
	end
	local unitLst
	if vals.statemaps then
		for k, v in pairs(vals.statemaps) do
			if k:find("%-") then
				k = k:gsub("%-", ":");
			end
	
			local add = true;
			local list = v..":"..v;
			table.insert(driver, "["..k.."] "..v);

			for _, l in ipairs(statelist) do
				if l == list then
					add = nil;
					break
				end
			end

			if add then
				table.insert(statelist, v..":"..v);
			end
		end
	end

	driver = table.concat(driver, ";");
	state = SecureCmdOptionParse(driver);
	statelist = table.concat(statelist, ";");
	

	if #driver == 0 then
		state = "0";
	end

	if not vals.visible or vals.visible == "" then
		vals.visible = "show";
	end

	visible = vals.visible;

	if vals.visible ~= "hide" and vals.visible ~= "show" then
		visible = "["..vals.visible.."]".." show; hide";
	end

	hdr:SetAttribute("_onstate-actionsettings", [[ -- (self, stateid, newstate)
						state = newstate;
						self:SetAttribute("state", newstate)
						control:ChildUpdate(stateid, newstate)]]
					)
	RegisterStateDriver(hdr, "actionsettings", driver);
	RegisterStateDriver(hdr, "visibility", visible);
	hdr:SetAttribute("statebutton", statelist);
	hdr:SetAttribute("state", state);
	
  	hdr:SetWidth(vals.cols * (36 + vals.xgap) - vals.xgap);
	hdr:SetHeight(vals.rows * (36 + vals.ygap) - vals.ygap);
	
	local last, begin;
	local count = 1;
	for i = 1, vals.rows do
		for j = 1, vals.cols do
			local btn = table.remove(btns, 1) or getbtn(hdr);
			btn:SetID(count);
			hdr:SetAttribute("addchild", btn);
			vals.buttons[count] = vals.buttons[count] or {};
      
			for k, v in pairs(vals.buttons[count]) do
				if k == "bind" then
					--SetBindingClick(v, btn:GetName(), "LeftButton");
				else
					btn:SetAttribute(k, v);
				end
			end
			
			btn:ClearAllPoints();
			
			if j == 1 then
				if begin then
					btn:SetPoint("BOTTOMLEFT", begin, "TOPLEFT", 0, vals.ygap);
				else
					btn:SetPoint("BOTTOMLEFT", hdr, "BOTTOMLEFT", 0, 0);
				end
				begin = btn;
			else
				btn:SetPoint("LEFT", last, "RIGHT", vals.xgap, 0);
			end
			last = btn;
			count = count + 1;
		end
	end
	for _, v in ipairs(btns) do
		delbtn(v);
	end

	if NRF_LOCKED then
		_G[hdr:GetName().."drag"]:Hide();
	end
	return count
end

function Nurfed:deletebar(frame)
	local hdr = _G[frame];
	if hdr then
		UnregisterUnitWatch(hdr);
		hdr:SetAttribute("unit", nil);
		RegisterStateDriver(hdr, "visibility", "hide");
		hdr:Hide();

		local children = { hdr:GetChildren() };
		for _, child in ipairs(children) do
			if child:GetName():find("^Nurfed_Button") then
				delbtn(child);
			end
		end
	end
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		if v.name == hdr:GetName() then
			table.remove(NURFED_ACTIONBARS[currentTalentGroup], i);
			break;
		end
	end
end

function Nurfed:createbar(frame)
	local vals
	for _,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		if v.name == frame then
			vals = v;
			break;
		end
	end
	local hdr = _G[frame] or Nurfed:create(frame, "actionbar");
	if hdr and type(hdr) == "table" then
		hdr:SetScale(vals.scale);
		hdr:SetAlpha(vals.alpha);
		hdr:SetPoint(unpack(vals.Point or {"CENTER"}));
		hdr:SetAttribute("unit", vals.unit);
		hdr:SetAttribute("useunit", vals.useunit);

		_G[frame.."dragtext"]:SetText(frame);

		local count = Nurfed:updatebar(hdr);
		while vals.buttons[count] do
			vals.buttons[count] = nil;
			count = count + 1;
		end
		--TODO: Find a better way, event possibly, that fires after the states change.  ^_^;
		hdr:HookScript("OnAttributeChanged", function() Nurfed:sendevent("NURFED_UPDATE_ICONS") end);
		if lbfg then
			hdr.lbf = lbf:Group("Nurfed", "Virtual Bars", hdr:GetName())
		end
	end
end

function Nurfed:updatehks(frame)
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		if v.name == frame then
			vals = v; 
			break;
		end
	end
	
	local hdr = _G[frame] or Nurfed:create(frame, "actionbar");
	if hdr and type(hdr) == "table" then
		local count = Nurfed:updatebar(hdr)
		while vals.buttons[count] do
			vals.buttons[count] = nil;
			count = count + 1;
		end
		if hdr:IsUserPlaced() then
			for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
				if v.name == hdr:GetName() then
					v.Point = { hdr:GetPoint() };
					break;
				end
			end
		end
		
		if vals.Point then
			hdr:ClearAllPoints();
			hdr:SetPoint(unpack(vals.Point));
		end
	end
end

Nurfed:createtemp("actionbar", {
	type = "Frame",
	--uitemp = "SecureHandlerStateTemplate SecureHandlerAttributeTemplate SecureHandlerClickTemplate",
	uitemp = "SecureHandlerStateTemplate SecureHandlerClickTemplate",
	size = { 36, 36 },
	Movable = true,
	Hide = true,
	ClampedToScreen = true,
	OnLoad = function(self)
		if IsLoggedIn() then
		end
	end,
	children = {
		drag = {
			type = "Frame",
			Mouse = true,
			size = { 110, 13 },
			Hide = true,
			Backdrop = {
				bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
				edgeFile = nil,
				tile = true,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			},
			BackdropColor = { 0, 0, 0 },
			Point = { "TOPLEFT", "$parent", "BOTTOMLEFT" },
			OnLoad = function(self)
				self:RegisterForDrag("LeftButton")
				if not NRF_LOCKED and IsLoggedIn() then
					self:Show()
				end
		    end,
			OnAttributeChanged = function(self)
				if NRF_LOCKED and IsLoggedIn() then
					self:Hide()
				end
			end,
			OnDragStart = function(self) self:GetParent():StartMoving() end,
			OnDragStop = function(self)
				local parent = self:GetParent()
				local saved
				parent:StopMovingOrSizing()
				for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
					if v.name == parent:GetName() then
						v.Point = { parent:GetPoint() }
						saved = true
						break
					end
				end
				parent:SetUserPlaced(true)
				
				local top = self:GetTop()
				local screen = GetScreenHeight() / 2
				if top and screen then
					self:ClearAllPoints()
					if top >= screen then
						self:SetPoint("TOPLEFT", parent, "BOTTOMLEFT")
					else  
						self:SetPoint("BOTTOMLEFT", parent, "TOPLEFT")
					end
				end
				if not saved then
					NURFED_SAVED[parent:GetName()] = { parent:GetPoint() }
				end
			end,
			OnShow = function(self)
				local top = self:GetTop()
				local screen = GetScreenHeight() / 2
				if top and screen then
					self:ClearAllPoints()
					if top >= screen then
						self:SetPoint("TOPLEFT", self:GetParent(), "BOTTOMLEFT")
					else  
						self:SetPoint("BOTTOMLEFT", self:GetParent(), "TOPLEFT")
					end
				end
				self:SetScript("OnShow", nil)
			end,
			children = {
				text = {
					type = "FontString",
					Point = "all",
					FontObject = "GameFontNormalSmall",
					JustifyH = "CENTER",
					TextColor = { 1, 1, 1 },
				}
			}
		}
	}
})
  
local barevents = {
	["NURFED_LOCK"] = function(self)
		if NRF_LOCKED then
			_G[self:GetName().."drag"]:Hide()
		else
			_G[self:GetName().."drag"]:Show()
		end
	end,
	["COMPANION_LEARNED"] = updateCompanionList,
	["COMPANION_UPDATE"] = updateCompanionList,
}

local function barevent(event, ...)
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		barevents[event](_G[v.name])
	end
end

for event, func in pairs(barevents) do
	Nurfed:regevent(event, barevent)
end

----------------------------------------------------------------
-- Built in bars
local blizzbars = {
	["bags"] = 36,
	["micro"] = 37,
	["stance"] = 36,
	["petbar"] = 30,
	["possessbar"] = 30,
	["possessactionbar"] = 60,
}

function nrf_updatemainbar(bar)
	local show = Nurfed:getopt(bar.."show")
	local scale = Nurfed:getopt(bar.."scale")
	local vert = Nurfed:getopt(bar.."vert")
	local offset = Nurfed:getopt(bar.."offset")
	bar = _G["Nurfed_"..bar]
	bar:SetScale(scale)

	if bar == Nurfed_petbar then
		if show then
			RegisterUnitWatch(Nurfed_petbar)
		else
			UnregisterUnitWatch(Nurfed_petbar)
		end
		for i = 2, 10 do
			local btn = _G["PetActionButton"..i]
			btn:ClearAllPoints()
			if vert then
				btn:SetPoint("TOP", "PetActionButton"..(i-1), "BOTTOM", 0, offset)
			else
				btn:SetPoint("LEFT", "PetActionButton"..(i-1), "RIGHT", offset, 0)
			end
		end
		
	elseif bar == Nurfed_possessbar then
		for i=2, NUM_POSSESS_SLOTS do
			local btn = _G["PossessButton"..i]
			btn:ClearAllPoints()
			if vert then
				btn:SetPoint("TOP", "PossessButton"..(i-1), "BOTTOM", 0, offset)
			else
				btn:SetPoint("LEFT", "PossessButton"..(i-1), "RIGHT", offset, 0)
			end
		end
	
	elseif bar == Nurfed_possessactionbar then
		for i=2, NUM_BONUS_ACTION_SLOTS do
			local btn = _G["BonusActionButton"..i]
			btn:ClearAllPoints();
			if vert then
				btn:SetPoint("TOP", "BonusActionButton"..(i-1), "BOTTOM", 0, offset)
			else
				btn:SetPoint("LEFT", "BonusActionButton"..(i-1), "RIGHT", offset, 0)
			end
		end
	elseif bar == Nurfed_stance then
		for i = 2, 10 do
			local btn = _G["ShapeshiftButton"..i]
			btn:ClearAllPoints()
			if vert then
				btn:SetPoint("TOP", "ShapeshiftButton"..(i-1), "BOTTOM", 0, -3)
			else
				btn:SetPoint("LEFT", "ShapeshiftButton"..(i-1), "RIGHT", 3, 0)
			end
		end
		
	elseif bar == Nurfed_bags then
		for i = 0, 3 do
			local bag = _G["CharacterBag"..i.."Slot"]
			bag:ClearAllPoints()
			if vert then
				if i == 0 then
					bag:SetPoint("TOP", "MainMenuBarBackpackButton", "BOTTOM", 0, -3)
				else
					bag:SetPoint("TOP", "CharacterBag"..(i-1).."Slot", "BOTTOM", 0, -3)
				end
			else
				if i == 0 then
					bag:SetPoint("RIGHT", "MainMenuBarBackpackButton", "LEFT", -3, 0)
				else
					bag:SetPoint("RIGHT", "CharacterBag"..(i-1).."Slot", "LEFT", -3, 0)
				end
			end
		end
	end
	if show then
		--[[if bar == Nurfed_vehiclemenubar then
			if UnitHasVehicleUI("player") then
				bar:Show()
			else
				bar:Hide()
			end
		else]]
			bar:Show()
		--end
	else
		bar:Hide()
	end
end

local function updateSkins(updateall, skinID, gloss, backdrop, group, button, colors)
	if group and button then
		if group == "Virtual Bars" then
			for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
				if v.name == button then
					if skinID == "Blizzard" then
						v.skin = nil
					else
						v.skin = { skinID, gloss, backdrop }
					end
				end
			end
		elseif group == "Blizzard Bars" then
			if skinID == "Blizzard" then
				NURFED_SAVED[button.."skin"] = nil
			else
				NURFED_SAVED[button.."skin"] = { skinID, gloss, backdrop }
			end
		end
	end
	if updateall then
		for _,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
			if v.skin and _G[v.name] and _G[v.name].lbf then
				_G[v.name].lbf:Skin(unpack(v.skin))
			end
		end
		for k, v in pairs(blizzbars) do
			local bar = "Nurfed_"..k
			if _G[bar] and NURFED_SAVED[bar.."skin"] and _G[bar].lbf then
				_G[bar].lbf:Skin(unpack(NURFED_SAVED[bar.."skin"]))
			end
		end
	end
end

local function createbars(bars)
	if lbf then
		if not lbfg then
			lbfg = lbf:Group("Nurfed")
			if lbfg then
				lbf:RegisterSkinCallback("Nurfed", updateSkins)
				lbf:Group("Nurfed", "Virtual Bars")
				lbf:Group("Nurfed", "Blizzard Bars")
			end
		
		end
	end
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		Nurfed:createbar(v.name)
	end

	local bar, drag
	for k, v in pairs(blizzbars) do
		bar = Nurfed:create("Nurfed_"..k, "actionbar")
		if bar then
			if lbfg then
				bar.lbf = lbf:Group("Nurfed", "Blizzard Bars", bar:GetName())
			end
			bar:SetHeight(v)
			if NURFED_SAVED[bar:GetName()] then
				bar:SetPoint(unpack(NURFED_SAVED[bar:GetName()]))
			elseif not bar:IsUserPlaced() then
				bar:SetPoint("CENTER")
			end
			
			if k == "petbar" then
				bar:SetAttribute("unit", "pet")
			end
			if k == "possessbar" then
				bar:SetAttribute("unit", "player")
			end
			--_G["Nurfed_"..k.."dragtext"]:SetText("Nurfed_"..k)
			local text = k:gsub("bar", " %1"):gsub("action", " %1")
			text = text:gsub("(%a)([%w_']*)", function(first, rest) return first:upper()..rest:lower() end)
			local dragtxt = _G["Nurfed_"..k.."dragtext"]
			dragtxt:SetText(text)
			dragtxt:GetParent():SetWidth(dragtxt:GetStringWidth()+5)
		end
	end
	updateSkins(true)
end
local function update_actionbar_talent_settings(new, old)
	if type(new) == "number" then
		currentTalentGroup = new
		for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
			Nurfed:updatehks(v.name)
		end
		NurfedActionBarsUpdateColors()
	end
end
--[[
Nurfed:regevent("ACTIVE_TALENT_GROUP_CHANGED", function()
	currentTalentGroup = GetActiveTalentGroup(false, false)
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		Nurfed:updatehks(v.name)
	end
	Nurfed:sendevent("UPDATE_BINDINGS")
	SaveBindings(GetCurrentBindingSet())
	NurfedActionBarsUpdateColors()
	Nurfed:print("Changed Specs!:  Spec Group:"..currentTalentGroup)
end)
]]
Nurfed:regevent("VARIABLES_LOADED", function()
	-- autoupgrade!
	if not NURFED_ACTIONBARS[1] then
		for i,v in pairs(NURFED_ACTIONBARS) do
			if type(i) == "string" and type(v) == "table" then
				NURFED_ACTIONBARS[#NURFED_ACTIONBARS+1] = v
				NURFED_ACTIONBARS[#NURFED_ACTIONBARS].name = i
				NURFED_ACTIONBARS[i] = nil
			end
		end
	end
	if not lbf then
		lbf = _G["LibStub"] and _G.LibStub("LibButtonFacade", true) or nil
	end
	currentTalentGroup = currentTalentGroup or GetActiveTalentGroup(false, false)
	Nurfed_Add_Talent_Call(update_actionbar_talent_settings)
	-- upgrade to dual specs!
	--[[
	if not NURFED_ACTIONBARS[currentTalentGroup].talentGroup then
		local tempTbl = NURFED_ACTIONBARS
		NURFED_ACTIONBARS = {};
		NURFED_ACTIONBARS[1] = tempTbl
		NURFED_ACTIONBARS[2] = tempTbl
		NURFED_ACTIONBARS[1].talentGroup = 1
		NURFED_ACTIONBARS[2].talentGroup = 2
	end]]
	--if not NURFED_ACTIONBARS[currentTalentGroup].talentGroup then	-- convert new ones!
	if NURFED_ACTIONBARS and ((NURFED_ACTIONBARS[currentTalentGroup] and not NURFED_ACTIONBARS[currentTalentGroup].talentGroup) or
		not NURFED_ACTIONBARS[currentTalentGroup]) then
		for i,v in pairs(NURFED_ACTIONBARS) do
			if v.talentGroup then
				NURFED_ACTIONBARS[currentTalentGroup] = v
				break
			end
		end
		if not NURFED_ACTIONBARS[currentTalentGroup].talentGroup then	-- upgrade the old ones!
			local tempTbl = NURFED_ACTIONBARS
			NURFED_ACTIONBARS = {};
			NURFED_ACTIONBARS[1] = tempTbl
			NURFED_ACTIONBARS[2] = tempTbl
			NURFED_ACTIONBARS[1].talentGroup = 1
			NURFED_ACTIONBARS[2].talentGroup = 2
		end
	end
	createbars()
	if _G.ButtonFacade then
		hooksecurefunc(ButtonFacade, "OpenOptions", function()
			_G["ButtonFacade"]:ElementListUpdate("Nurfed")
			_G["ButtonFacade"]:ElementListUpdate("Nurfed", "Virtual Bars")
			_G["ButtonFacade"]:ElementListUpdate("Nurfed", "Blizzard Bars")
		end)
	end
end)

Nurfed:regevent("PLAYER_LOGIN", function()
	for i,v in ipairs(NURFED_ACTIONBARS[currentTalentGroup]) do
		Nurfed:updatehks(v.name)
	end
	isloaded = true
	updateCompanionList()
	Nurfed:sendevent("ACTIVE_TALENT_GROUP_CHANGED")
	SaveBindings(GetCurrentBindingSet())
	NurfedActionBarsUpdateColors()
end)

Nurfed:regevent("NURFED_LOCK", function()
	if NRF_LOCKED then
		Nurfed_bagsdrag:Hide()
		Nurfed_microdrag:Hide()
		Nurfed_stancedrag:Hide()
		Nurfed_petbardrag:Hide()
		Nurfed_possessbardrag:Hide()
		Nurfed_possessactionbardrag:Hide()
		Nurfed_vehiclecontrolsdrag:Hide()
	else
		Nurfed_bagsdrag:Show()
		Nurfed_microdrag:Show()
		Nurfed_stancedrag:Show()
		Nurfed_petbardrag:Show()
		Nurfed_possessbardrag:Show()
		Nurfed_possessactionbardrag:Show()
		Nurfed_vehiclecontrolsdrag:Show()
	end
end)

----------------------------------------------------------------
-- Toggle main action bar
local old_ShapeshiftBar_Update = ShapeshiftBar_Update
function nrf_mainmenu()
	if IsAddOnLoaded("Bartender3") or IsAddOnLoaded("Bartender4") or IsAddOnLoaded("TrinityBars") or IsAddOnLoaded("Bongos2_ActionBar") or IsAddOnLoaded("Bongos3_ActionBar") or IsAddOnLoaded("Dominos") then
		return
	end

	if not Nurfed:getopt("hidemain") then
		if MainMenuBar:IsShown() then return end
		KeyRingButton:SetParent(MainMenuBarArtFrame)
		KeyRingButton:ClearAllPoints()
		KeyRingButton:SetPoint("RIGHT", "CharacterBag3Slot", "LEFT", -5, 0)

		MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame)
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -6, 2)

		for i = 0, 3 do
			local bag = _G["CharacterBag"..i.."Slot"]
			bag:SetParent(MainMenuBarArtFrame)
			bag:ClearAllPoints()
			if i == 0 then
				bag:SetPoint("RIGHT", "MainMenuBarBackpackButton", "LEFT", -5, 0)
			else
				bag:SetPoint("RIGHT", "CharacterBag"..(i-1).."Slot", "LEFT", -5, 0)
			end
		end

		CharacterMicroButton:SetParent(MainMenuBarArtFrame)
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint("BOTTOMLEFT", 552, 2)

		local children = { Nurfed_micro:GetChildren() }
		for _, child in ipairs(children) do
			if not string.find(child:GetName(), "^Nurfed") then
				child:SetParent(MainMenuBarArtFrame)
			end
		end

		for i = 1, 10 do
			local btn = _G["ShapeshiftButton"..i]
			btn:SetParent(ShapeshiftBarFrame)
			btn:ClearAllPoints()
			if i == 1 then
				btn:SetPoint("BOTTOMLEFT", 11, 3)
			else
				btn:SetPoint("LEFT", "ShapeshiftButton"..(i-1), "RIGHT", 7, 0)
			end

			btn = _G["PetActionButton"..i]
			btn:SetParent(PetActionBarFrame)
			btn:ClearAllPoints()
			if i == 1 then
				btn:SetPoint("BOTTOMLEFT", 36, 2)
			else
				btn:SetPoint("LEFT", "PetActionButton"..(i-1), "RIGHT", 8, 0)
			end
			
			if i <= 2 then
				btn = _G["PossessButton"..i]
				btn:SetParent(PossessBarFrame)
				btn:ClearAllPoints()
				if i == 1 then
					btn:SetPoint("BOTTOMLEFT", 36, 2)
				else
					btn:SetPoint("LEFT", "PossessButton"..(i-1), "RIGHT", 8, 0)
				end
			end
		end
		for i = 1, NUM_BONUS_ACTION_SLOTS do
			local btn = _G["BonusActionButton"..i]
			btn:SetParent(BonusActionBarFrame);
			btn:ClearAllPoints();
			if i == 1 then
				btn:SetPoint("BOTTOMLEFT", 36, 2)
			else
				btn:SetPoint("LEFT", "BonusActionButton"..(i-1), "RIGHT", 8, 0)
			end
		end

		ShapeshiftBar_Update = old_ShapeshiftBar_Update
		if MainMenuBar_ToPlayerArt_O and MainMenuBar_ToPlayerArt == nrf_mainmenu then
			MainMenuBar_ToPlayerArt = MainMenuBar_ToPlayerArt_O
		end
		MainMenuBar:Show()
	else
		KeyRingButton:SetParent(MainMenuBarBackpackButton)
		KeyRingButton:ClearAllPoints()
		KeyRingButton:SetPoint("LEFT", "MainMenuBarBackpackButton", "RIGHT", 2, 0)
		KeyRingButton:SetHeight(CharacterBag1Slot:GetHeight())

		MainMenuBarBackpackButton:SetParent(Nurfed_bags)
		MainMenuBarBackpackButton:SetWidth(CharacterBag1Slot:GetWidth())
		MainMenuBarBackpackButton:SetHeight(CharacterBag1Slot:GetHeight())
		MainMenuBarBackpackButtonNormalTexture:SetHeight(CharacterBag1SlotNormalTexture:GetHeight())
		MainMenuBarBackpackButtonNormalTexture:SetWidth(CharacterBag1SlotNormalTexture:GetWidth())
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("BOTTOMLEFT")

		for i = 0, 3 do
			local bag = _G["CharacterBag"..i.."Slot"]
			bag:SetParent(Nurfed_bags)
		end


		CharacterMicroButton:SetParent(Nurfed_micro)
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint("BOTTOMLEFT")

		local children = { MainMenuBarArtFrame:GetChildren() }
		for _, child in ipairs(children) do
			local name = child:GetName()
			if name:find("MicroButton", 1, true) then 
				child:SetParent(Nurfed_micro)
			end
		end
		local children = { VehicleMenuBarArtFrame:GetChildren() }
		for _, child in ipairs(children) do
			local name = child:GetName()
			if name:find("MicroButton", 1, true) then 
				child:SetParent(Nurfed_micro)
			end
		end

		for i = 1, 10 do
			local btn = _G["ShapeshiftButton"..i]
			local cooldown = _G["ShapeshiftButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			btn:SetParent(Nurfed_stance)
			btn:SetScript("OnUpdate", nrfcooldowntext)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("BOTTOMLEFT")
			end
			if Nurfed_stance.lbf then
				Nurfed_stance.lbf:AddButton(btn)
			end

			btn = _G["PetActionButton"..i]
			cooldown = _G["PetActionButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			btn:SetParent(Nurfed_petbar)
			btn:SetScript("OnUpdate", nrfcooldowntext)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("BOTTOMLEFT")
			end
			if Nurfed_petbar.lbf then
				Nurfed_petbar.lbf:AddButton(btn)
			end
		end
		
		for i = 1, NUM_POSSESS_SLOTS do
			local btn = _G["PossessButton"..i]
			local cooldown = _G["PossessButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			btn:SetParent(Nurfed_possessbar)
			btn:SetScript("OnUpdate", nrfcooldowntext)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("BOTTOMLEFT")
			end
			_G["PossessButton"..i.."NormalTexture"]:Hide()
			if Nurfed_possessbar.lbf then
				Nurfed_possessbar.lbf:AddButton(btn)
			end
		end
		
		for i = 1, NUM_BONUS_ACTION_SLOTS do
			local btn = _G["BonusActionButton"..i]
			local cooldown = _G["BonusActionButton"..i.."Cooldown"]
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER")
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			btn:SetParent(Nurfed_possessactionbar)
			btn:SetScript("OnUpdate", nrfcooldowntext)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("BOTTOMLEFT")
			end
			_G["BonusActionButton"..i.."NormalTexture"]:Hide()
			_G["BonusActionButton"..i.."NormalTexture"]:SetAlpha(0)
			if Nurfed_possessactionbar.lbf then
				Nurfed_possessactionbar.lbf:AddButton(btn)
			end
		end
		
		if not NurfedPossessHeader then
			local f = CreateFrame("Frame", "NurfedPossessHeader", nil, "SecureHandlerStateTemplate SecureHandlerClickTemplate")
			for i = 1, NUM_BONUS_ACTION_SLOTS do
				local btn = _G["BonusActionButton"..i]
				f:SetFrameRef("btn"..i, btn)
			end
			f:SetAttribute("_onstate-actionsettings", [[
								if newstate == "s1" then
									if (select(2, PlayerPetSummary()) and select(2, PlayerPetSummary()) ~= "Hover Disk") or not select(2, PlayerPetSummary()) then
										local btn
										for i=1, 12 do
											local key
											if i == 10 then key = 0 elseif i == 11 then key = "-" elseif i == 12 then key = "=" else key = i end
											btn = self:GetFrameRef("btn"..i)
											btn:Show()
											self:SetBindingClick(true, key, btn)
										end
									end
								else
									self:ClearBindings()
									for i=1,12 do
										self:GetFrameRef("btn"..i):Hide()
									end
								end]]
							)
			RegisterStateDriver(f, "actionsettings", "[bonusbar:5]s1;s2");

			-- new vehicle bar code! woot!
			local nvb = Nurfed:create("Nurfed_vehiclecontrols", "actionbar");
			_G["Nurfed_vehiclecontrolsdragtext"]:SetText("Vehicle Controls")
			nvb:SetAttribute("_onstate-vehicleupdate", [[
								if newstate == "s1" then
									self:Show()
								else
									self:Hide()
								end]]
							)
			RegisterStateDriver(nvb, "vehicleupdate", "[target=vehicle,exists]s1;s2")
			nvb:SetWidth(56)
			nvb:SetHeight(80)
			if NURFED_SAVED["Nurfed_vehiclecontrols"] then
				nvb:ClearAllPoints()
				nvb:SetPoint(unpack(NURFED_SAVED["Nurfed_vehiclecontrols"]))
			else
				nvb:SetPoint("CENTER")
			end
			
			-- hijack exit button
			btn = getglobal("VehicleMenuBarLeaveButton")
			btn:SetParent(nvb)
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", nvb, "TOPLEFT", 0, 0)
			btn:GetNormalTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Up")
			btn:GetNormalTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
			btn:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Exit-Down")
			btn:GetPushedTexture():SetTexCoord(0.140625, 0.859375, 0.140625, 0.859375)
			btn:SetWidth(24)
			btn:SetHeight(24)
			btn:Show()
			nvb.exit = btn
			--
			-- hijack pitch slider
			btn = getglobal("VehicleMenuBarPitchSlider")
			btn:SetParent(nvb)
			btn:ClearAllPoints();
			btn:SetPoint("TOPRIGHT", nvb, "TOPLEFT", 0, 2)
			btn:Show()
			nvb.slider = btn
			nvb:SetFrameRef("slider", nvb.slider)
			--
			-- hijack pitchup button
			btn = getglobal("VehicleMenuBarPitchUpButton")
			btn:SetParent(nvb)
			btn:GetNormalTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Pitch-Up")
			btn:GetNormalTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
			btn:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-Pitch-Down")
			btn:GetPushedTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
			btn:SetWidth(24)
			btn:SetHeight(24)
			btn:ClearAllPoints()
			btn:SetPoint("TOPRIGHT", nvb.exit, "BOTTOMRIGHT", 0, -2)
			btn:Show()
			nvb.pitchup = btn
			--
			-- hijack pitch down
			btn = getglobal("VehicleMenuBarPitchDownButton")
			btn:SetParent(nvb)
			btn:GetNormalTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-PitchDown-Up")
			btn:GetNormalTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
			btn:GetPushedTexture():SetTexture("Interface\\Vehicles\\UI-Vehicles-Button-PitchDown-Down")
			btn:GetPushedTexture():SetTexCoord(0.21875, 0.765625, 0.234375, 0.78125)
			btn:SetWidth(24)
			btn:SetHeight(24)
			btn:ClearAllPoints()
			btn:SetPoint("TOPRIGHT", nvb.pitchup, "BOTTOMRIGHT", 0, -2)
			btn:Show()
			nvb.pitchdown = btn
		end
		
		if MainMenuBar_ToPlayerArt ~= nrf_mainmenu then
			MainMenuBar_ToPlayerArt_O = MainMenuBar_ToPlayerArt
			MainMenuBar_ToPlayerArt = nrf_mainmenu
			MainMenuBar_ToVehicleArt_O = MainMenuBar_ToVehicleArt
			MainMenuBar_ToVehicleArt = function() end
		end
		
		nrf_updatemainbar("bags")
		nrf_updatemainbar("micro")
		nrf_updatemainbar("stance")
		nrf_updatemainbar("petbar")
		nrf_updatemainbar("possessbar")
		nrf_updatemainbar("possessactionbar")
		ShapeshiftBar_Update = function() end
		MainMenuBar:Hide()
		if not MainMenuBar.nrfScriptSet then
			MainMenuBar.nrfScriptSet = true
			if MainMenuBar:GetScript("OnShow") then
				MainMenuBar:HookScript("OnShow", nrf_mainmenu)
			else
				MainMenuBar:SetScript("OnShow", nrf_mainmenu)
			end
		end
	end
end

------------------------- default settings shit....kthxdie?
function Nurfed_CreateDefaultActionBar(type)
	assert(type, "NO TYPE TO CREATE A DEFAULT FOR DUMBASS!")
	local typeLst = {
		["rogueStealth"] = true,
		["druidNoStealth"] = true,
		["druidStealth"] = true,
		["warriorStance"] = true,
	}	
	if typeLst[type] then
		table.insert(NURFED_ACTIONBARS, {
			["visible"] = "show",
			["useunit"] = false,
			["buttons"] = {
				{}, {}, {}, {}, -- [4]
				{}, {}, {}, {}, -- [8]
				{}, {}, {}, {}, -- [12]
				{}, {}, {}, {}, -- [16]
				{}, {}, {}, {}, -- [20]
				{}, {}, {}, {}, -- [24]
			},
			["scale"] = 1.0,
			["rows"] = 2,
			["alpha"] = 1,
			["cols"] = 12,
			["Point"] = {
				"CENTER",
			},
			["unit"] = "",
			["statemaps"] = {
			},
			["ygap"] = 7,
			["xgap"] = 7,
		})
	end
	if type == "rogueStealth" then
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].name = "Nurfed_RogueStealthBar"
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].statemaps = {
			["stealth:0"] = "s1",
			["stealth:1"] = "s2",
		}
	elseif type == "druidNoStealth" then
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].name = "Nurfed_DruidNoStealthBar"
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].statemaps = {
			["actionbar:1, stance:0"] = "s0",
			["actionbar:1, stance:1"] = "s1",
			["actionbar:1, stance:2"] = "s2",
			["actionbar:1, stance:3"] = "s3",
			["actionbar:1, stance:4"] = "s4",
			["actionbar:1, stance:5"] = "s5",
			["actionbar:2"] = "p2",
			["actionbar:3"] = "p3",
		}
	
	elseif type == "druidStealth" then
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].name = "Nurfed_DruidStealthBar"
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].statemaps = {
			["actionbar:1, stance:0"] = "s0",
			["actionbar:1, stance:1"] = "s1",
			["actionbar:1, stance:2"] = "s2",
			["actionbar:1, stance:3, nostealth"] = "s3",
			["actionbar:1, stance:3, stealth"] = "st3",
			["actionbar:1, stance:4"] = "s4",
			["actionbar:1, stance:5"] = "s5",
			["actionbar:2"] = "p2",
			["actionbar:3"] = "p3",
		}
	elseif type == "warriorStance" then
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].name = "Nurfed_WarriorStanceBar"
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].statemaps = {
			["stance:1"] = "s1",
			["stance:2"] = "s2",
			["stance:3"] = "s3",
		}
	elseif type == "customShow" then
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].name = "Nurfed_CustomShow"
		NURFED_ACTIONBARS[#NURFED_ACTIONBARS].statemaps = {
			["target=target,harm"] = "s1",
			["target=target,help"] = "s2",
			["target=target,noexists"] = "s3",
			["target=target,group:party/raid"] = "s4",
		}
	end
	StaticPopup_Show("NRF_RELOADUI")
end
	
Nurfed:setversion("Nurfed-Core", "$Date$", "$Rev$")
