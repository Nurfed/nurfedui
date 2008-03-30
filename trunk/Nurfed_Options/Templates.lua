------------------------------------------
-- Option Menu Templates

local onshow = function(self)
  local text = getglobal(self:GetName().."Text")
  local value = getglobal(self:GetName().."value")
  local objtype = self:GetObjectType()
  text:SetText(self.text)
  if self.color then
    text:SetTextColor(unpack(self.color))
  end

  local point = select(3, self:GetPoint())
  if string.find(point, "RIGHT") and objtype ~= "EditBox" then
    if value then
      value:ClearAllPoints()
      value:SetPoint("RIGHT", self, "LEFT", -3, 0)
    else
      text:ClearAllPoints()
      text:SetPoint("RIGHT", self:GetName(), "LEFT", -1, 1)
      self:SetHitRectInsets(-100, 0, 0, 0)
    end
  end

  local opt
  if self.option then
    opt = Nurfed:getopt(self.option)
  elseif self.default then
    opt = self.default
  end

  if objtype == "CheckButton" and opt then
    self:SetChecked(opt)
  elseif objtype == "Slider" then
    local low = _G[self:GetName().."Low"]
    local high = _G[self:GetName().."High"]
    self:SetMinMaxValues(self.min, self.max)
    self:SetValueStep(self.step)
    if opt then
      self:SetValue(opt)
    end

    value.option = self.option
    value.val = self.val
    value.func = self.func
  elseif objtype == "EditBox" then
    self:SetText(opt or "")
  elseif objtype == "Button" then
    local swatch = _G[self:GetName().."bg"]
    if swatch then
      local frame = self
      swatch:SetVertexColor(opt[1], opt[2], opt[3])
      self.r = opt[1]
      self.g = opt[2]
      self.b = opt[3]
      self.swatchFunc = function() Nurfed_Options_swatchSetColor(frame) end
      self.cancelFunc = function(x) Nurfed_Options_swatchCancelColor(frame, x) end
      if self.opacity then
        self.hasOpacity = frame.opacity
        self.opacityFunc = function() Nurfed_Options_swatchSetColor(frame) end
        self.opacity = opt[4]
      end
    else
      self:SetText(opt or "")
    end
  end
  self:SetScript("OnShow", nil)
end

local saveopt = function(self)
  local value, objtype
  objtype = self:GetObjectType()
  
  if objtype == "CheckButton" then
    value = self:GetChecked() or false
    if value then
      PlaySound("igMainMenuOptionCheckBoxOn")
    else
      PlaySound("igMainMenuOptionCheckBoxOff")
    end
  elseif objtype == "Slider" then
    value = self:GetValue()
  elseif objtype == "EditBox" then
    if not self.focus then return end
    value = self:GetText()
  elseif objtype == "Button" then
    value = self:GetText()
  end
  
  if self.option then
    local opt = self.option
    if value == NURFED_DEFAULT[opt] then
      NURFED_SAVED[opt] = nil
    else
      NURFED_SAVED[opt] = value
    end
  end
  
  if self.func then
    self.func(value)
  end
end

local templates = {
  nrf_check = {
    type = "CheckButton",
    uitemp = "InterfaceOptionsCheckButtonTemplate",
    OnShow = onshow,
    OnClick = saveopt,
  },
  nrf_slider = {
    type = "Slider",
    uitemp = "InterfaceOptionsSliderTemplate",
    children = {
      value = {
        template = "nrf_editbox",
        size = { 35, 18 },
        Anchor = { "LEFT", "$parent", "RIGHT", 3, 0 },
        OnTextChanged = function(self)
          if self.focus then
            local parent = self:GetParent()
            local value = tonumber(self:GetText())
            local min, max = parent:GetMinMaxValues()
            if not value or value < min then return end
            if value > max then value = max end
            parent:SetValue(value)
            --local func = parent:GetScript("OnMouseUp")
            --func(parent)
          end
        end,
        OnEditFocusGained = function() this:HighlightText() this.focus = true end,
        OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
      },
    },
    OnShow = function(self) onshow(self) end,
    OnMouseUp = function(self) end,
    OnValueChanged = function() end,
  },
  nrf_editbox = {
    type = "EditBox",
    AutoFocus = false,
    size = { 155, 20 },
    Backdrop = {
      bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
      edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
      tile = true,
      tileSize = 16,
      edgeSize = 10,
      insets = { left = 3, right = 3, top = 3, bottom = 3 },
    },
    BackdropColor = { 0, 0, 0.2, 0.75 },
    FontObject = "GameFontNormal",
    TextInsets = { 3, 3, 3, 3 },
    children = {
      Text = {
        type = "FontString",
        layer = "ARTWORK",
        Anchor = { "BOTTOMLEFT", "$parent", "TOPLEFT", 3, 0 },
        FontObject = "GameFontHighlight",
        JustifyH = "LEFT",
      },
    },
    OnShow = function(self) onshow(self) end,
    OnEscapePressed = function() this:ClearFocus() end,
    OnEnterPressed = function() this:ClearFocus() end,
    OnEditFocusGained = function() this:HighlightText() this.focus = true end,
    OnEditFocusLost = function() this:HighlightText(0, 0) this.focus = nil end,
    OnTextChanged = function(self) end,
  },
}

for k, v in pairs(templates) do
  Nurfed:createtemp(k, v)
end