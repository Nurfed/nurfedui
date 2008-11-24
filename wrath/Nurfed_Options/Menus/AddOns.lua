------------------------------------------
--  Nurfed AddOns

Nurfed:createtemp("nrf_addons_row", {
  type = "Frame",
  size = { 400, 14 },
  children = {
    check = {
      type = "CheckButton",
      size = { 16, 16 },
      uitemp = "UICheckButtonTemplate",
      Anchor = { "BOTTOMLEFT", "$parent", "BOTTOMLEFT", 2, 0 },
      OnClick = function(self) Nurfed_ToggleAddOn(self) end,
    },
    name = {
      type = "FontString",
      layer = "ARTWORK",
      size = { 210, 14 },
      Anchor = { "LEFT", "$parentcheck", "RIGHT", 5, 0 },
      FontObject = "GameFontNormal",
      JustifyH = "LEFT",
      TextColor = { 1, 1, 1 },
    },
    loaded = {
      type = "FontString",
      layer = "ARTWORK",
      size = { 105, 14 },
      Anchor = { "LEFT", "$parentname", "RIGHT", 5, 0 },
      FontObject = "GameFontNormal",
      JustifyH = "RIGHT",
      TextColor = { 1, 1, 1 },
    },
    reload = {
      type = "FontString",
      layer = "ARTWORK",
      size = { 100, 14 },
      Anchor = { "LEFT", "$parentloaded", "RIGHT", 5, 0 },
      FontObject = "GameFontNormal",
      JustifyH = "LEFT",
      TextColor = { 1, 0, 0 },
    },
  },
})

function Nurfed_ToggleAddOn(self)	
	if (self:GetChecked()) then
		EnableAddOn(self:GetID())
		PlaySound("igMainMenuOptionCheckBoxOn")
	else
		DisableAddOn(self:GetID())
		PlaySound("igMainMenuOptionCheckBoxOff")
	end
	local reload = getglobal(self:GetParent():GetName().."reload")
	reload:SetText("(Reload UI)")
end

function Nurfed_ScrollAddOns()
  local format_row = function(row, num)
    local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(num)
    local loaded = IsAddOnLoaded(num)
    local check = getglobal(row.."check")
    local na = getglobal(row.."name")
    local load = getglobal(row.."loaded")

    na:SetText(title or name)
    if enabled then
      na:SetTextColor(1, 1, 1)
    else
      na:SetTextColor(0.5, 0.5, 0.5)
    end

    if name == "Nurfed_Options" then
      check:Hide()
    else
      check:Show()
      check:SetChecked(enabled)
      check:SetID(num)
    end
    if loaded then
      load:SetText("Loaded")
      load:SetTextColor(1, 1, 1)
    elseif loadable then
      load:SetText("On Demand")
      load:SetTextColor(1, 1, 1)
    else
      local y = getglobal("ADDON_"..reason)
      load:SetText(y)
      load:SetTextColor(0.5, 0.5, 0.5)
    end
  end

  local count = GetNumAddOns()
  FauxScrollFrame_Update(this, count, 23, 14)
  for line = 1, 23 do
    local offset = line + FauxScrollFrame_GetOffset(this)
    local row = getglobal("NurfedAddOnsRow"..line)
    if offset <= count then
      format_row("NurfedAddOnsRow"..line, offset)
      row:Show()
    else
      row:Hide()
    end
  end
end

function Nurfed_AddonsCreate()
  local row
  for i = 1, 23 do
    row = Nurfed:create("NurfedAddOnsRow"..i, "nrf_addons_row", NurfedAddOnsPanelList)
    if i == 1 then
      row:SetPoint("TOPLEFT", 0, -3)
    else
      row:SetPoint("TOPLEFT", "NurfedAddOnsRow"..(i - 1), "BOTTOMLEFT", 0, 0)
    end
  end
end
Nurfed:setversion("Nurfed-Options", "$Date$", "$Rev$")