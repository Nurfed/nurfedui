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
NURFED_DEFAULT[MANA] = { 0.00, 0.00, 1.00 }
NURFED_DEFAULT[RAGE_POINTS] = { 1.00, 0.00, 0.00 }
NURFED_DEFAULT[FOCUS_POINTS] = { 1.00, 0.50, 0.25 }
NURFED_DEFAULT[ENERGY_POINTS] = { 1.00, 1.00, 0.00 }
NURFED_DEFAULT[HAPPINESS_POINTS] = { 0.00, 1.00, 1.00 }
NURFED_DEFAULT["showmap"] = 1
NURFED_DEFAULT["cdaura"] = 1
NURFED_DEFAULT["cdaction"] = 1