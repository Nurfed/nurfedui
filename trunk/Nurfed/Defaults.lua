NURFED_DEFAULT = {}
NURFED_DEFAULT["chatfade"] = 1
NURFED_DEFAULT["chatprefix"] = false
NURFED_DEFAULT["chatbuttons"] = false
NURFED_DEFAULT["chatfadetime"] = 120
NURFED_DEFAULT["autoinvite"] = 1
NURFED_DEFAULT["invitetext"] = 1
NURFED_DEFAULT["keyword"] = "invite"
NURFED_DEFAULT["readycheck"] = 1
NURFED_DEFAULT["ping"] = 1
NURFED_DEFAULT["raidgroup"] = 1
NURFED_DEFAULT["raidclass"] = 1
NURFED_DEFAULT["repair"] = 1
NURFED_DEFAULT["repairlimit"] = 20
NURFED_DEFAULT["timestamps"] = 1
NURFED_DEFAULT["timestampsformat"] = "[%I:%M:%S]"
NURFED_DEFAULT["traineravailable"] = 1
NURFED_DEFAULT["hidecasting"] = 1
NURFED_DEFAULT["squareminimap"] = false
NURFED_DEFAULT["raidsize"] = 5
NURFED_DEFAULT["lock"] = { "CENTER", "Minimap", "CENTER", -12, -80 }
NURFED_DEFAULT["hpcolor"] = "fade"
NURFED_DEFAULT["mpcolor"] = "normal"
NURFED_DEFAULT["hpscript"] = [[
if perc > 0.6 then
   r = 78/255
   g = 106/255
   b = 143/255
else
   if perc > 0.2 then
      r = (78+((0.6-perc)*100*(128/40)))/255
      g = (106+((0.6-perc)*100*(-89/40)))/255
      b = (143+((0.6-perc)*100*(-136/40)))/255
   else
      r = 206/255
      g = 17/255
      b = 17/255
   end
end
]]
NURFED_DEFAULT["changehpbg"] = false
NURFED_DEFAULT["changempbg"] = false
NURFED_DEFAULT[MANA] = { 0.00, 0.00, 1.00 }
NURFED_DEFAULT[RAGE_POINTS] = { 1.00, 0.00, 0.00 }
NURFED_DEFAULT[FOCUS_POINTS] = { 1.00, 0.50, 0.25 }
NURFED_DEFAULT[ENERGY_POINTS] = { 1.00, 1.00, 0.00 }
NURFED_DEFAULT[HAPPINESS_POINTS] = { 0.00, 1.00, 1.00 }
NURFED_DEFAULT["showmap"] = 1
NURFED_DEFAULT["cdaura"] = 1
NURFED_DEFAULT["cdaction"] = 1

-- ActionBars
NURFED_DEFAULT["hidemain"] = 1
NURFED_DEFAULT["tooltips"] = 1
NURFED_DEFAULT["hotkeys"] = 1
NURFED_DEFAULT["macrotext"] = 1
NURFED_DEFAULT["unusedbtn"] = 1
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
NURFED_DEFAULT["showbindings"] = true