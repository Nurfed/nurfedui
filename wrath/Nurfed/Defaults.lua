NURFED_DEFAULT = {}
NURFED_DEFAULT["chatfade"] = true
NURFED_DEFAULT["chatprefix"] = false
NURFED_DEFAULT["numchatprefix"] = false
NURFED_DEFAULT["chatbuttons"] = false
NURFED_DEFAULT["hideachievements"] = true
NURFED_DEFAULT["classcolortext"] = true
NURFED_DEFAULT["chatfadetime"] = 120
NURFED_DEFAULT["autoinvite"] = true
NURFED_DEFAULT["invitetext"] = true
NURFED_DEFAULT["keyword"] = "invite"
NURFED_DEFAULT["autojoingroup"] = true
NURFED_DEFAULT["readycheck"] = true
NURFED_DEFAULT["ping"] = true
NURFED_DEFAULT["raidgroup"] = true
NURFED_DEFAULT["raidclass"] = true
NURFED_DEFAULT["repair"] = true
NURFED_DEFAULT["repairlimit"] = 20
NURFED_DEFAULT["autosell"] = true
NURFED_DEFAULT["timestamps"] = true
NURFED_DEFAULT["timestampsformat"] = "[%I:%M:%S]"
NURFED_DEFAULT["traineravailable"] = true
NURFED_DEFAULT["hidecasting"] = true
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
NURFED_DEFAULT["changeframesforvehicle"] = true
NURFED_DEFAULT["changehpbg"] = false
NURFED_DEFAULT["changempbg"] = false
NURFED_DEFAULT["mana"] = { 0.00, 0.00, 1.00 }
NURFED_DEFAULT["rage"] = { 1.00, 0.00, 0.00 }
NURFED_DEFAULT["focus"] = { 1.00, 0.50, 0.25 }
NURFED_DEFAULT["energy"] = { 1.00, 1.00, 0.00 }
NURFED_DEFAULT["happiness"] = { 0.00, 1.00, 1.00 }
NURFED_DEFAULT["showmap"] = true
NURFED_DEFAULT["cdaura"] = true
NURFED_DEFAULT["cdaction"] = true
NURFED_DEFAULT["combatloglength"] = 50
NURFED_DEFAULT["combatlogshowschool"] = true
NURFED_DEFAULT["usebigdebuffs"] = false
NURFED_DEFAULT["bigdebuffscale"] = 2
NURFED_DEFAULT["onelinedebuffs"] = true
NURFED_DEFAULT["useshortnumbers"] = false
NURFED_DEFAULT["debufffilterlist"] = {}
NURFED_DEFAULT["bufffilterlist"] = {}


-- ActionBars
NURFED_DEFAULT["hidemain"] = true
NURFED_DEFAULT["tooltips"] = true
NURFED_DEFAULT["hotkeys"] = true
NURFED_DEFAULT["macrotext"] = true
NURFED_DEFAULT["unusedbtn"] = true
NURFED_DEFAULT["fadein"] = true

NURFED_DEFAULT["olddebuffstyle"] = false

NURFED_DEFAULT["actionbarnomana"] = { 0.5, 0.5, 1 }
NURFED_DEFAULT["actionbarnotusable"] = { 0.4, 0.4, 0.4 }
NURFED_DEFAULT["actionbarnorange"] = { 1, 0, 0 }
NURFED_DEFAULT["actionbarbasecolor"] = { 1, 1, 1 }

NURFED_DEFAULT["bagsshow"] = false
NURFED_DEFAULT["bagsscale"] = 1
NURFED_DEFAULT["bagsvert"] = false

NURFED_DEFAULT["stanceshow"] = true
NURFED_DEFAULT["stancescale"] = 1
NURFED_DEFAULT["stancevert"] = false

NURFED_DEFAULT["petbarshow"] = true
NURFED_DEFAULT["petbarscale"] = 1
NURFED_DEFAULT["petbarvert"] = false
NURFED_DEFAULT["petbaroffset"] = 3

NURFED_DEFAULT["possessbarshow"] = true
NURFED_DEFAULT["possessbarscale"] = 1
NURFED_DEFAULT["possessbarvert"] = false
NURFED_DEFAULT["possessbaroffset"] = 3

NURFED_DEFAULT["vehiclemenubarshow"] = true
NURFED_DEFAULT["vehiclemenubarscale"] = 1
NURFED_DEFAULT["vehiclemenubarvert"] = false
NURFED_DEFAULT["vehiclemenubaroffset"] = 3

NURFED_DEFAULT["possessactionbarshow"] = true
NURFED_DEFAULT["possessactionbarscale"] = 1
NURFED_DEFAULT["possessactionbarvert"] = false
NURFED_DEFAULT["possessactionbaroffset"] = 3

NURFED_DEFAULT["microshow"] = false
NURFED_DEFAULT["microscale"] = 1
NURFED_DEFAULT["microvert"] = false

NURFED_DEFAULT["showbindings"] = true


NURFED_DEFAULT["alphadistance"] = "30"
NURFED_DEFAULT["alphaharmspellranged"] = ""
NURFED_DEFAULT["alphaharmspellmelee"] = ""
NURFED_DEFAULT["alphahelpspell"] = ""
NURFED_DEFAULT["alphahidevalue"] = 0.5