------------------------------------------
-- Option Menu Panels

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
        vars = { text = NRF_CHATFADE, option = "chatfade", func = function() nrf_togglechat() end },
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
      check1 = {
        template = "nrf_check",
        Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
        vars = { text = NRF_UNTRAINABLE, option = "traineravailable" },
      },
      check2 = {
        template = "nrf_check",
        Anchor = { "TOPLEFT", "$parentcheck1", "BOTTOMLEFT", 0, -8 },
        vars = { text = NRF_AUTOINVITE, option = "autoinvite" },
      },
      check3 = {
        template = "nrf_check",
        Anchor = { "TOPLEFT", "$parentcheck2", "BOTTOMLEFT", 0, -8 },
        vars = { text = "Invite Reply", option = "invitetext" },
      },
      check4 = {
        template = "nrf_check",
        Anchor = { "TOPLEFT", "$parentcheck3", "BOTTOMLEFT", 0, -8 },
        vars = { text = "Square Minimap", option = "squareminimap" },
      },

      check5 = {
        template = "nrf_check",
        Anchor = { "TOPRIGHT", "$parentSubText", "BOTTOMRIGHT", 0, -8 },
        vars = { text = NRF_AUTOREPAIR, option = "repair" },
      },
      slider1 = {
        template = "nrf_slider",
        Anchor = { "TOPRIGHT", "$parentcheck5", "BOTTOMRIGHT", 0, -24 },
        vars = {
          text = NRF_REPAIRLIMIT,
          option = "repairlimit",
          low = 0,
          high = 200,
          min = 0,
          max = 200,
          step = 1,
          format = "%.0f",
        },
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
        Point = { "TOPLEFT", "$parentSubText", "BOTTOMLEFT", -2, -8 },
        vars = { text = "Aura Cooldowns", option = "cdaura" },
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