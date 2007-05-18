------------------------------------------
--	Nurfed Action Bar Library
------------------------------------------

-- Locals
local _G = getfenv(0)
local pairs = pairs
local ipairs = ipairs

-- Default Options
NURFED_ACTIONBARS = NURFED_ACTIONBARS or {
	["Nurfed_Bar1"] = {
		rows = 1,
		cols = 12,
		scale = 1,
		alpha = 1,
		unitshow = false,
		xgap = 2,
		ygap = 2,
		buttons = {},
		statemaps = {},
	},
}

NURFED_DEFAULT["hidemain"] = 1
NURFED_DEFAULT["tooltips"] = 1
NURFED_DEFAULT["fadein"] = 1
NURFED_DEFAULT["bagsshow"] = 1
NURFED_DEFAULT["bagsscale"] = 1
NURFED_DEFAULT["bagsvert"] = false
NURFED_DEFAULT["stanceshow"] = 1
NURFED_DEFAULT["stancescale"] = 1
NURFED_DEFAULT["stancevert"] = false
NURFED_DEFAULT["petbarshow"] = 1
NURFED_DEFAULT["petbarscale"] = 1
NURFED_DEFAULT["petbarvert"] = false
NURFED_DEFAULT["microshow"] = 1
NURFED_DEFAULT["microscale"] = 1
NURFED_DEFAULT["microvert"] = false


local updateitem = function(self)
	if not self.item then return end
	local count = getglobal(self:GetName().."Count")
	local border = getglobal(self:GetName().."Border")
	local num = GetItemCount(self.item)
	if num > 1 then
		count:SetText(num)
	else
		count:SetText(nil)
	end
	if IsEquippedItem(self.item) then
		border:SetVertexColor(0, 1.0, 0, 0.35)
		border:Show()
	else
		border:Hide()
	end
end

local updatecooldown = function(self)
	local start, duration, enable = 0, 0, 0
	local cooldown = getglobal(self:GetName().."Cooldown")
	if self.spell then
		start, duration, enable = GetSpellCooldown(self.spell)
	elseif self.item then
		start, duration, enable = GetItemCooldown(self.item)
	end
	if not start or not duration then return end
	CooldownFrame_SetTimer(cooldown, start, duration, enable)
end

local updatebind = function(self)
	local id = self:GetID()
	if id > 0 then
		local parent = self:GetParent():GetName()
		local hotkey = getglobal(self:GetName().."HotKey")
		local key = GetBindingKey("CLICK "..this:GetName()..":LeftButton")
		NURFED_ACTIONBARS[parent].buttons[id].bind = key
		if key then
			key = Nurfed:binding(key)
		end
		hotkey:SetText(key)
	end
end

local convert = function(self, value)
	local unit = SecureButton_GetAttribute(self, "unit")
	if unit and unit ~= "none" and UnitExists(unit) then
		if UnitCanAttack("player", unit) then
			value = SecureButton_GetModifiedAttribute(self, "harmbutton", value) or value
		elseif UnitCanAssist("player", unit) then
			value = SecureButton_GetModifiedAttribute(self, "helpbutton", value) or value
		end
	end
	return value
end

local seticon = function(self, name, value)
	if name then
		if string.find(name, "^%*") or string.find(name, "^shift") or string.find(name, "^ctrl") or string.find(name, "^alt") then
			if self.save then
				local id = self:GetID()
				local parent = self:GetParent():GetName()
				NURFED_ACTIONBARS[parent].buttons[id][name] = value
			end
			name = "state-parent"
			value = self:GetAttribute("state-parent")
		end

		if name == "state-parent" and value then
			local texture, spell
			local name = getglobal(self:GetName().."Name")
			local icon = getglobal(self:GetName().."Icon")
			local count = getglobal(self:GetName().."Count")
			name:SetText(nil)
			self.spell = nil
			self.item = nil
			self.macro = nil
			self.attack = nil

			value = convert(self, value)

			local new = SecureButton_GetModifiedAttribute(self, "type", value)
			if new then
				spell = SecureButton_GetModifiedAttribute(self, new, value)
				if spell then
					if new == "spell" then
						texture = GetSpellTexture(spell)
						self.spell = spell
						if IsAttackSpell(spell) or IsAutoRepeatSpell(spell) then
							self.attack = true
						end
					elseif new == "item" then
						local itemid = SecureButton_GetModifiedAttribute(self, "itemid", value)
						if itemid then
							texture = select(10, GetItemInfo(itemid))
							self.item = itemid
						end
					elseif new == "macro" then
						spell, texture = GetMacroInfo(spell)
						name:SetText(spell)
						self.macro = true
					end
				end
			end

			if icon:GetTexture() ~= texture then
				icon:SetTexture(texture)
				if texture then
					local fade = Nurfed:getopt("fadein")
					if fade then UIFrameFadeIn(icon, 0.5) end
					self:SetAlpha(1)
				else
					self:SetAlpha(0)
				end
				updatecooldown(self)

				if new and spell and new == "item" then
					updateitem(self)
				else
					getglobal(self:GetName().."Border"):Hide()
					count:SetText(nil)
				end
			elseif not texture then
				self:SetAlpha(0)
			end
		end
	end
end

local ondragstart = function(self)
	if not NRF_LOCKED then
		local name = self:GetName()
		if string.find(name, "^Nurfed_Button") then
			if InCombatLockdown() then return end
			local state = self:GetAttribute("state-parent")
			if state == "0" then state = "LeftButton" end
			local value = convert(self, state)
			local new = SecureButton_GetModifiedAttribute(self, "type", value)
			if new then
				spell = SecureButton_GetModifiedAttribute(self, new, value)
				if spell then
					self.save = true
					if new == "spell" then
						local id = Nurfed:getspell(spell)
						PickupSpell(id, BOOKTYPE_SPELL)
					elseif new == "item" then
					elseif new == "macro" then
						PickupMacro(spell)
					end
					if state == "LeftButton" then
						value = "*"
					else
						value = "-"..value
					end
					self:SetAttribute("*type"..value, nil)
					self:SetAttribute("*"..new..value, nil)

					local unit = SecureButton_GetModifiedUnit(self, state)
					if unit and unit ~= "none" and UnitExists(unit) then
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
					self.save = nil
				end
			end
		else
			local parent = self:GetParent()
			parent:StartMoving()
			parent.moving = true
		end
	end
end

local ondragstop = function(self)
	local parent = self:GetParent()
	parent:StopMovingOrSizing()
	parent.moving = nil
	if NURFED_ACTIONBARS[parent:GetName()] then
		NURFED_ACTIONBARS[parent:GetName()].Point = { parent:GetPoint() }
	end
end

local onenter = function(self)
	local tooltip = Nurfed:getopt("tooltips")
	if tooltip and (self.spell or self.item) then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		--[[
		local x, y = self:GetRight(), self:GetTop()
		local anchor = "ANCHOR_"
		if y >= (GetScreenHeight() / 2) then
			anchor = anchor.."BOTTOM"
		else
			anchor = anchor.."TOP"
		end
		if x >= (GetScreenWidth() / 2) then
			anchor = anchor.."RIGHT"
		else
			anchor = anchor.."LEFT"
		end
		GameTooltip:SetOwner(self, anchor)
		]]

		if self.spell then
			local id = Nurfed:getspell(self.spell)
			if not id then return end
			local _, spellRank = GetSpellName(id, BOOKTYPE_SPELL)
			GameTooltip:SetSpell(id, BOOKTYPE_SPELL)
			if spellRank then
				GameTooltipTextRight1:SetText(spellRank)
				GameTooltipTextRight1:SetTextColor(0.5, 0.5, 0.5)
				GameTooltipTextRight1:Show()
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

local onreceivedrag = function(self)
	if GetCursorInfo() and not InCombatLockdown() then
		local cursor = { GetCursorInfo() }
		local value = self:GetAttribute("state-parent")
		if value == "0" then value = nil end
		local unit = SecureButton_GetModifiedUnit(self, (value or "LeftButton"))
		if value then value = "-"..value else value = "*" end

		self.save = true
		if unit and unit ~= "none" and UnitExists(unit) then
			if UnitCanAttack("player", unit) then
				self:SetAttribute("*harmbutton"..value, "nuke"..value)
				value = "-nuke"..value
			elseif UnitCanAssist("player", unit) then
				self:SetAttribute("*helpbutton"..value, "heal"..value)
				value = "-heal"..value
			end
		end

		self:SetAttribute("*type"..value, cursor[1])
		if cursor[1] == "spell" then
			local spell, rank = GetSpellName(cursor[2], cursor[3])
			if string.find(rank, RANK) then
				spell = spell.."("..rank..")"
			elseif string.find(spell, " %(") then
				spell = spell.."()"
			end
			self:SetAttribute("*spell"..value, spell)
			self:SetAttribute("*item"..value, nil)
			self:SetAttribute("*itemid"..value, nil)
			self:SetAttribute("*macro"..value, nil)
		elseif cursor[1] == "item" then
			local item = GetItemInfo(cursor[2])
			self:SetAttribute("*spell"..value, nil)
			self:SetAttribute("*item"..value, item)
			self:SetAttribute("*itemid"..value, cursor[2])
			self:SetAttribute("*macro"..value, nil)
		elseif cursor[1] == "macro" then
			self:SetAttribute("*spell"..value, nil)
			self:SetAttribute("*item"..value, nil)
			self:SetAttribute("*itemid"..value, nil)
			self:SetAttribute("*macro"..value, cursor[2])
		end
		self.save = nil
		ClearCursor()
	end
end

local preclick = function(self)
	if GetCursorInfo() and not InCombatLockdown() then
		onreceivedrag(self)
		self:SetScript("OnClick", nil)
	end
end

local postclick = function(self)
	self:SetChecked(nil)
	if not self:GetScript("OnClick") then
		local hdr = self:GetParent()
		hdr:SetAttribute("addchild", self)
	end
end

local cooldowntext = function(self)
	local cooldown = getglobal(self:GetName().."Cooldown")
	if not cooldown.text then return end
	if cooldown.cool then
		local cdscale = cooldown:GetScale()
		local r, g, b = 1, 0, 0
		local height = floor( 22 / cdscale )
		local fheight = select(2, cooldown.text:GetFont())
		local remain = math.round((cooldown.start + cooldown.duration) - GetTime())
		if remain >= 0 then
			if remain >= 3600 then
				remain = math.floor(remain / 3600).."h"
				r, g, b = 0.6, 0.6, 0.6
				height = floor(14 / cdscale)
			elseif remain >= 60 then
				local min = math.floor(remain / 60)
				local sec = math.floor(math.fmod(remain, 60))
				remain = string.format("%2d:%02s", min, sec)
				r, g, b = 1, 1, 0
				height = floor(14 / cdscale)
			end
			cooldown.text:SetText(remain)
			cooldown.text:SetTextColor(r, g, b)
			if height ~= fheight then
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", height, "OUTLINE")
			end
		else
			cooldown.text:SetText(nil)
			cooldown.cool = nil
		end
	else
		cooldown.text:SetText(nil)
	end
end

local onupdate = function(self, e)
	self.update = self.update - e
	if self.update <= 0 then
		local usable, color
		local unit = SecureButton_GetUnit(self)
		if self.spell then
			if not IsUsableSpell(self.spell) then
				usable = "use"
				color = { 0.5, 0.5, 0.5 }
			elseif SpellHasRange(self.spell) and IsSpellInRange(self.spell, unit) == 0 then
				usable = "range"
				color = { 1, 0, 0 }
			end
		elseif self.item then
			if not IsUsableItem(self.item) then
				usable = "use"
				color = { 0.5, 0.5, 0.5 }
			elseif ItemHasRange(self.item) and IsItemInRange(self.item, unit) == 0 then
				usable = "range"
				color = { 1, 0, 0 }
			end
		elseif self.macro and self.change then
			seticon(self, "state-parent", self:GetAttribute("state-parent"))
			self.change = nil
		end

		if usable ~= self.usable then
			getglobal(self:GetName().."Icon"):SetVertexColor(unpack(color or {1, 1, 1}))
			self.usable = usable
		end

		cooldowntext(self)
		self.update = TOOLTIP_UPDATE_TIME
	end

	local flash = getglobal(this:GetName().."Flash")
	if self.flash and self.attack then
		self.flashtime = self.flashtime - e
		if ( self.flashtime <= 0 ) then
			local overtime = -self.flashtime
			if overtime >= ATTACK_BUTTON_FLASH_TIME then
				overtime = 0
			end
			self.flashtime = ATTACK_BUTTON_FLASH_TIME - overtime

			if flash:IsVisible() then
				flash:Hide()
			else
				flash:Show()
			end
		end
	else
		flash:Hide()
	end
end

--[[
local events = {
	["PLAYER_ENTERING_WORLD"] = function(frame)
	["UNIT_INVENTORY_CHANGED"] = function(frame)
	["ACTIONBAR_UPDATE_USABLE"] = function(frame)
	["UPDATE_INVENTORY_ALERTS"] = function(frame)
	["ACTIONBAR_UPDATE_COOLDOWN"] = function(frame)
	["UPDATE_BINDINGS"] = function(frame)
	["PLAYER_TARGET_CHANGED"] = function(frame)
	["PLAYER_FOCUS_CHANGED"] = function(frame)
	["MODIFIER_STATE_CHANGED"] = function(frame)
	["UNIT_SPELLCAST_SUCCEEDED"] = function(frame)
	["ACTIONBAR_SHOWGRID"] = function(frame)
	["ACTIONBAR_HIDEGRID"] = function(frame)
	["PLAYER_ENTER_COMBAT"] = function(frame)
	["START_AUTOREPEAT_SPELL"] = function(frame)
	["PLAYER_LEAVE_COMBAT"] = function(frame)
	["STOP_AUTOREPEAT_SPELL"] = function(frame)
}

local onevent = function(event, ...)
	events[event](...)
end

Nurfed:regevent("PLAYER_ENTERING_WORLD", onevent)
Nurfed:regevent("UNIT_INVENTORY_CHANGED", onevent)
Nurfed:regevent("ACTIONBAR_UPDATE_USABLE", onevent)
Nurfed:regevent("UPDATE_INVENTORY_ALERTS", onevent)
Nurfed:regevent("ACTIONBAR_UPDATE_COOLDOWN", onevent)
Nurfed:regevent("UPDATE_BINDINGS", onevent)
Nurfed:regevent("PLAYER_TARGET_CHANGED", onevent)
Nurfed:regevent("PLAYER_FOCUS_CHANGED", onevent)
Nurfed:regevent("MODIFIER_STATE_CHANGED", onevent)
Nurfed:regevent("UNIT_SPELLCAST_SUCCEEDED", onevent)
Nurfed:regevent("ACTIONBAR_SHOWGRID", onevent)
Nurfed:regevent("ACTIONBAR_HIDEGRID", onevent)
Nurfed:regevent("PLAYER_ENTER_COMBAT", onevent)
Nurfed:regevent("START_AUTOREPEAT_SPELL", onevent)
Nurfed:regevent("PLAYER_LEAVE_COMBAT", onevent)
Nurfed:regevent("STOP_AUTOREPEAT_SPELL", onevent)
]]

local onevent = function(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		seticon(self, "state-parent", self:GetAttribute("state-parent"))
	elseif event == "UNIT_INVENTORY_CHANGED" and select(1, ...) == "player" and self.item then
		updateitem(self)
	elseif event == "ACTIONBAR_UPDATE_USABLE" or event == "UPDATE_INVENTORY_ALERTS" or event == "ACTIONBAR_UPDATE_COOLDOWN" then
		updatecooldown(self)
	elseif event == "UPDATE_BINDINGS" then
		updatebind(self)
	elseif event == "PLAYER_TARGET_CHANGED" then
		local unit = SecureButton_GetUnit(self)
		if unit == "target" then
			seticon(self, "state-parent", self:GetAttribute("state-parent"))
		end
	elseif event == "PLAYER_FOCUS_CHANGED" then
		local unit = SecureButton_GetUnit(self)
		if unit == "focus" then
			seticon(self, "state-parent", self:GetAttribute("state-parent"))
		end
	elseif event == "MODIFIER_STATE_CHANGED" then
		seticon(self, "state-parent", self:GetAttribute("state-parent"))
	elseif event == "UNIT_SPELLCAST_SUCCEEDED" and self.macro then
		self.change = true
	elseif event == "ACTIONBAR_SHOWGRID" then
		self:SetAlpha(1)
	elseif event == "ACTIONBAR_HIDEGRID" then
		local texture = getglobal(self:GetName().."Icon"):GetTexture()
		if not texture then self:SetAlpha(0) end
	elseif event == "PLAYER_ENTER_COMBAT" or event == "START_AUTOREPEAT_SPELL" then
		self.flash = true
	elseif event == "PLAYER_LEAVE_COMBAT" or event == "STOP_AUTOREPEAT_SPELL" then
		self.flash = nil
	end
end

local usedbtns = {}
local btncount = 0

local getbtn = function()
	local btn
	if #usedbtns > 0 then
		btn = table.remove(usedbtns)
		btn:SetScript("OnUpdate", onupdate)
	else
		btncount = btncount + 1
		btn = CreateFrame("CheckButton", "Nurfed_Button"..btncount, UIParent, "SecureActionButtonTemplate, ActionButtonTemplate")
		btn.update = 0
		btn.flashtime = 0
		btn:RegisterForClicks("AnyUp")
		btn:RegisterForDrag("LeftButton")
		btn:SetAttribute("checkselfcast", true)
		btn:SetAttribute("useparent-unit", true)
		btn:SetAttribute("useparent-statebutton", true)
		btn:SetScript("OnEvent", onevent)
		btn:SetScript("OnEnter", onenter)
		btn:SetScript("OnLeave", onleave)
		btn:SetScript("OnUpdate", onupdate)
		btn:SetScript("PreClick", preclick)
		btn:SetScript("PostClick", postclick)
		btn:SetScript("OnDragStart", ondragstart)
		btn:SetScript("OnAttributeChanged", seticon)
		btn:SetScript("OnReceiveDrag", onreceivedrag)

		btn:RegisterEvent("PLAYER_ENTERING_WORLD")
		btn:RegisterEvent("UPDATE_BINDINGS")
		btn:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
		btn:RegisterEvent("UPDATE_INVENTORY_ALERTS")
		btn:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
		btn:RegisterEvent("PLAYER_TARGET_CHANGED")
		btn:RegisterEvent("PLAYER_FOCUS_CHANGED")
		btn:RegisterEvent("UNIT_INVENTORY_CHANGED")
		btn:RegisterEvent("MODIFIER_STATE_CHANGED")
		btn:RegisterEvent("ACTIONBAR_SHOWGRID")
		btn:RegisterEvent("ACTIONBAR_HIDEGRID")
		btn:RegisterEvent("PLAYER_ENTER_COMBAT")
		btn:RegisterEvent("PLAYER_LEAVE_COMBAT")
		btn:RegisterEvent("START_AUTOREPEAT_SPELL")
		btn:RegisterEvent("STOP_AUTOREPEAT_SPELL")
		btn:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

		local cooldown = getglobal(btn:GetName().."Cooldown")
		cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
		cooldown.text:SetPoint("CENTER", 0, 0)
		cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
		local flash = getglobal(btn:GetName().."Flash")
		flash:ClearAllPoints()
		flash:SetAllPoints(cooldown)
	end
	return btn
end

local delbtn = function(btn)
	local id = btn:GetID()
	local parent = btn:GetParent():GetName()
	local attrib = NURFED_ACTIONBARS[parent].buttons[id]
	for k in pairs(attrib) do
		btn:SetAttribute(k, nil)
	end
	table.insert(usedbtns, btn)
	btn:Hide()
	btn:SetID(0)
	btn:SetParent(UIParent)
	btn:SetScript("OnUpdate", nil)
	getglobal(btn:GetName().."HotKey"):SetText(nil)
end

local imbue = function(btn, spells, unit)
	if spells then
		for k, v in pairs(spells) do
			if k == "bind" then
				NURFED_BINDINGS[v] = { "Click", btn:GetName(), "LeftButton" }
				SetBindingClick(v, btn:GetName(), "LeftButton")
			else
				btn:SetAttribute(k, v)
			end
		end
	end
end

local dragupdate = function(self, e, force)
	if NRF_LOCKED then
		self.drag:Hide()
	else
		self.drag:Show()
	end
	if self.moving or force then
		local x = self:GetRight()
		local point = self.drag:GetPoint()
		if x >= (GetScreenWidth() / 2) then
			if point ~= "LEFT" then
				self.drag:ClearAllPoints()
				self.drag:SetPoint("LEFT", -20, 0)
			end
		else
			if point ~= "RIGHT" then
				self.drag:ClearAllPoints()
				self.drag:SetPoint("RIGHT", 20, 0)
			end
		end
	end
end

function nrf_updatebar(hdr)
	local last, begin, state
	local count = 1
	local btns = {}
	local statelist = {}
	local statestring = ""
	local children = { hdr:GetChildren() }
	for _, child in ipairs(children) do
		if string.find(child:GetName(), "^Nurfed_Button") then
			table.insert(btns, child:GetID(), child)
		end
	end

	local vals = NURFED_ACTIONBARS[hdr:GetName()]
	if not vals.statemaps then vals.statemaps = {} end
	for k, v in pairs(vals.statemaps) do
		hdr:SetAttribute("statemap-"..k, v)
		if not statelist[v] then
			statelist[v] = true
		end

		if not hdr.init then
			if string.find(k, "^stance") then
				hdr.init = "stance"
			elseif string.find(k, "^actionbar") then
				hdr.init = "actionbar"
			elseif string.find(k, "^stealth") then
				hdr.init = "stealth"
			end
		end
	end

	if hdr.init then
		state = hdr:GetAttribute("statemap-"..hdr.init.."-"..hdr:GetAttribute("state-"..hdr.init))
	end
	hdr:SetAttribute("state", state or "0")
	hdr:SetWidth(vals.cols * (36 + vals.xgap) - vals.xgap)
	

	for k in pairs(statelist) do
		statestring = statestring..k..":"..k..";"
	end

	for i = 1, vals.rows do
		for j = 1, vals.cols do
			local btn = table.remove(btns, 1) or getbtn()
			hdr:SetAttribute("addchild", btn)
			btn:SetAttribute("statebutton", statestring)
			btn:SetID(count)
			btn:SetAlpha(vals.alpha)
			vals.buttons[count] = vals.buttons[count] or {}
			imbue(btn, vals.buttons[count], vals.unit)
			btn:ClearAllPoints()
			if j == 1 then
				if begin then
					btn:SetPoint("BOTTOMLEFT", begin, "TOPLEFT", 0, vals.ygap)
				else
					btn:SetPoint("BOTTOMLEFT", hdr, "BOTTOMLEFT", 0, 0)
				end
				begin = btn
			else
				btn:SetPoint("LEFT", last, "RIGHT", vals.xgap, 0)
			end
			last = btn
			count = count + 1
		end
	end

	for _, v in ipairs(btns) do
		delbtn(v)
	end
	return count
end

function Nurfed:deletebar(frame)
	local hdr = getglobal(frame)
	UnregisterUnitWatch(hdr)
	hdr:SetAttribute("unit", nil)
	hdr:SetAttribute("combat", nil)
	hdr:Hide()

	local children = { hdr:GetChildren() }
	for _, child in ipairs(children) do
		if string.find(child:GetName(), "^Nurfed_Button") then
			delbtn(child)
		end
	end

end

function Nurfed:createbar(frame)
	local last, begin
	local count = 1
	local vals = NURFED_ACTIONBARS[frame]
	local hdr = getglobal(frame)
	if not hdr then
		hdr = CreateFrame("Frame", frame, UIParent, "SecureStateDriverTemplate")
		hdr:SetScript("OnUpdate", dragupdate)
		local drag = CreateFrame("Frame", frame.."drag", hdr)
		drag:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, tileSize = 12, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }, })
		drag:SetBackdropColor(0, 0, 0, 0.75)
		drag:EnableMouse(true)
		drag:RegisterForDrag("LeftButton")
		drag:SetScript("OnDragStop", ondragstop)
		drag:SetScript("OnDragStart", ondragstart)
		drag:SetWidth(18)
		drag:SetHeight(42)
		hdr.drag = drag
		hdr:RegisterEvent("PLAYER_REGEN_ENABLED")
		hdr:RegisterEvent("PLAYER_REGEN_DISABLED")
	end

	if hdr and type(hdr) == "table" then
		hdr:SetHeight(36)
		hdr:SetMovable(true)
		hdr:SetScale(vals.scale)
		hdr:SetClampedToScreen(true)
		hdr:SetPoint(unpack(vals.Point or { "CENTER", 0, 0 }))
		hdr:SetAttribute("unit", vals.unit)
		hdr:SetAttribute("combat", vals.combatshow)
		if vals.unitshow then
			RegisterUnitWatch(hdr)
		else
			hdr:Show()
		end

		local count = nrf_updatebar(hdr)
		while vals.buttons[count] do
			vals.buttons[count] = nil
			count = count + 1
		end
		dragupdate(hdr, 0, true)
	end
end

function nrf_updatemainbar(bar)
	local show = Nurfed:getopt(bar.."show")
	local scale = Nurfed:getopt(bar.."scale")
	local vert = Nurfed:getopt(bar.."vert")
	bar = getglobal("Nurfed_"..bar)
	bar:SetScale(scale)

	if bar == Nurfed_petbar then
		if show then
			RegisterUnitWatch(Nurfed_petbar)
		else
			UnregisterUnitWatch(Nurfed_petbar)
		end
		for i = 2, 10 do
			local btn = getglobal("PetActionButton"..i)
			btn:ClearAllPoints()
			if vert then
				btn:SetPoint("TOP", "PetActionButton"..(i-1), "BOTTOM", 0, -3)
			else
				btn:SetPoint("LEFT", "PetActionButton"..(i-1), "RIGHT", 3, 0)
			end
		end
	elseif bar == Nurfed_stance then
		for i = 2, 10 do
			local btn = getglobal("ShapeshiftButton"..i)
			btn:ClearAllPoints()
			if vert then
				btn:SetPoint("TOP", "ShapeshiftButton"..(i-1), "BOTTOM", 0, -3)
			else
				btn:SetPoint("LEFT", "ShapeshiftButton"..(i-1), "RIGHT", 3, 0)
			end
		end
	elseif bar == Nurfed_bags then
		for i = 0, 3 do
			local bag = getglobal("CharacterBag"..i.."Slot")
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
		bar:Show()
	else
		bar:Hide()
	end
end

function nrf_mainmenu()
	if IsAddOnLoaded("Bartender3") or IsAddOnLoaded("TrinityBars") or IsAddOnLoaded("Bongos_ActionBar") then
		return
	end
	local hide = Nurfed:getopt("hidemain")
	if not hide then
		if MainMenuBar:IsShown() then return end
		KeyRingButton:SetParent(MainMenuBarArtFrame)
		KeyRingButton:ClearAllPoints()
		KeyRingButton:SetPoint("RIGHT", "CharacterBag3Slot", "LEFT", -5, 0)

		MainMenuBarBackpackButton:SetParent(MainMenuBarArtFrame)
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("BOTTOMRIGHT", -6, 2)
		MainMenuBarBackpackButton:SetScript("OnDragStart", nil)
		MainMenuBarBackpackButton:SetScript("OnDragStop", nil)

		for i = 0, 3 do
			local bag = getglobal("CharacterBag"..i.."Slot")
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
		CharacterMicroButton:SetScript("OnDragStart", nil)
		CharacterMicroButton:SetScript("OnDragStop", nil)

		local children = { Nurfed_micro:GetChildren() }
		for _, child in ipairs(children) do
			child:SetParent(MainMenuBarArtFrame)
			child:SetScript("OnDragStart", nil)
			child:SetScript("OnDragStop", nil)
		end

		for i = 1, 10 do
			local btn = getglobal("ShapeshiftButton"..i)
			btn:SetParent(ShapeshiftBarFrame)
			btn:ClearAllPoints()
			btn:SetScript("OnDragStart", nil)
			btn:SetScript("OnDragStop", nil)
			if i == 1 then
				btn:SetPoint("BOTTOMLEFT", 11, 3)
			else
				btn:SetPoint("LEFT", "ShapeshiftButton"..(i-1), "RIGHT", 7, 0)
			end

			btn = getglobal("PetActionButton"..i)
			btn:SetParent(PetActionBarFrame)
			btn:ClearAllPoints()
			btn:SetScript("OnDragStop", nil)
			if i == 1 then
				btn:SetPoint("BOTTOMLEFT", 36, 2)
			else
				btn:SetPoint("LEFT", "PetActionButton"..(i-1), "RIGHT", 8, 0)
			end
		end
		MainMenuBar:Show()
	else
		KeyRingButton:SetParent(MainMenuBarBackpackButton)
		KeyRingButton:ClearAllPoints()
		KeyRingButton:SetPoint("LEFT", "MainMenuBarBackpackButton", "RIGHT", 2, 0)

		MainMenuBarBackpackButton:SetParent(Nurfed_bags)
		MainMenuBarBackpackButton:ClearAllPoints()
		MainMenuBarBackpackButton:SetPoint("LEFT", 0, 0)
		MainMenuBarBackpackButton:RegisterForDrag("LeftButton")
		MainMenuBarBackpackButton:SetScript("OnDragStart", ondragstart)
		MainMenuBarBackpackButton:SetScript("OnDragStop", ondragstop)

		for i = 0, 3 do
			local bag = getglobal("CharacterBag"..i.."Slot")
			bag:SetParent(Nurfed_bags)
		end


		CharacterMicroButton:SetParent(Nurfed_micro)
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint("LEFT", 0, 0)
		CharacterMicroButton:SetScript("OnDragStart", ondragstart)
		CharacterMicroButton:SetScript("OnDragStop", ondragstop)
		CharacterMicroButton:RegisterForDrag("LeftButton")

		local children = { MainMenuBarArtFrame:GetChildren() }
		for _, child in ipairs(children) do
			local name = child:GetName()
			if (string.find(name, "MicroButton", 1, true)) then
				child:SetParent(Nurfed_micro)
				child:SetScript("OnDragStart", ondragstart)
				child:SetScript("OnDragStop", ondragstop)
				child:RegisterForDrag("LeftButton")
			end
		end

		for i = 1, 10 do
			local btn = getglobal("ShapeshiftButton"..i)
			local cooldown = getglobal("ShapeshiftButton"..i.."Cooldown")
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER", 0, 0)
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			btn:SetParent(Nurfed_stance)
			btn:SetScript("OnDragStart", ondragstart)
			btn:SetScript("OnDragStop", ondragstop)
			btn:SetScript("OnUpdate", cooldowntext)
			btn:RegisterForDrag("LeftButton")
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("LEFT", 0, 0)
			end

			btn = getglobal("PetActionButton"..i)
			cooldown = getglobal("PetActionButton"..i.."Cooldown")
			if not cooldown.text then
				cooldown.text = cooldown:CreateFontString(nil, "OVERLAY")
				cooldown.text:SetPoint("CENTER", 0, 0)
				cooldown.text:SetFont("Fonts\\FRIZQT__.TTF", 22, "OUTLINE")
			end
			btn:SetParent(Nurfed_petbar)
			btn:SetScript("OnDragStop", ondragstop)
			btn:SetScript("OnUpdate", cooldowntext)
			if i == 1 then
				btn:ClearAllPoints()
				btn:SetPoint("LEFT", 0, 0)
			end
		end
		nrf_updatemainbar("bags")
		nrf_updatemainbar("micro")
		nrf_updatemainbar("stance")
		nrf_updatemainbar("petbar")
		MainMenuBar:Hide()
	end
end

local setstate = function(self, event)
	if self.init and event == "PLAYER_ENTERING_WORLD" then
		local state = self:GetAttribute("statemap-"..self.init.."-"..self:GetAttribute("state-"..self.init))
		self:SetAttribute("state", state)
		self.init = nil
	end
	if event == "PLAYER_REGEN_ENABLED" and self:GetAttribute("combat") then
		self:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" and self:GetAttribute("combat") then
		self:Show()
	end
end
hooksecurefunc("SecureStateDriver_OnEvent", setstate)

function PetActionButton_OnDragStart()
	if not NRF_LOCKED then
		if IsControlKeyDown() then
			local parent = this:GetParent()
			parent:StartMoving()
		else
			this:SetChecked(0)
			PickupPetAction(this:GetID())
			PetActionBar_Update()
		end
	end
end

----------------------------------------------------------------
-- Correct border for stance buttons
local stanceborder = function()
	if not MainMenuBar:IsShown() then
		for i = 1, 10 do
			local border = getglobal("ShapeshiftButton"..i.."NormalTexture")
			border:SetWidth(50)
			border:SetHeight(50)
		end
	end
end

hooksecurefunc("UIParent_ManageFramePositions", stanceborder)

----------------------------------------------------------------
-- Add cooldown text
local updatecooling = function(this, start, duration, enable)
	if not this:GetName() or not this.text then return end
	if start > 2 and duration > 2 then
		this.cool = true
		this.start = start
		this.duration = duration
	else
		this.cool = nil
	end
end

if not IsAddOnLoaded("OmniCC") then
	hooksecurefunc("CooldownFrame_SetTimer", updatecooling)
end