---------------------------------------------------------
-- Nurfed CombatLog

-- event suffixes
TEXT_MODE_A_STRING_VALUE_SCHOOL = ""
TEXT_MODE_A_STRING_RESULT_RESISTED = "R"
TEXT_MODE_A_STRING_RESULT_BLOCKED = "B"
TEXT_MODE_A_STRING_RESULT_ABSORBED = "A"
TEXT_MODE_A_STRING_RESULT_CRITICAL = "C"
TEXT_MODE_A_STRING_RESULT_CRITICAL_SPELL = "C"
TEXT_MODE_A_STRING_RESULT_GLANCING = "G"
TEXT_MODE_A_STRING_RESULT_CRUSHING = "Cr"

-- event strings
ACTION_DAMAGE_SHIELD_FULL_TEXT = "$source $spell reflects $amount $school damage to $dest.$result"
ACTION_DAMAGE_SHIELD_FULL_TEXT_NO_SOURCE = "$spell reflects $amount $school damage to $dest.$result"
ACTION_DAMAGE_SHIELD_MISSED_BLOCK_FULL_TEXT = "$source $spell was blocked by $dest."
ACTION_DAMAGE_SHIELD_MISSED_BLOCK_FULL_TEXT_NO_SOURCE = "$spell was blocked by $dest."
ACTION_DAMAGE_SHIELD_MISSED_DEFLECT_FULL_TEXT = "$source $spell was deflected by $dest."
ACTION_DAMAGE_SHIELD_MISSED_DEFLECT_FULL_TEXT_NO_SOURCE = "$spell was deflected by $dest."
ACTION_DAMAGE_SHIELD_MISSED_DODGE_FULL_TEXT = "$source $spell was dodged by $dest."
ACTION_DAMAGE_SHIELD_MISSED_DODGE_FULL_TEXT_NO_SOURCE = "$spell was dodged by $dest."
ACTION_DAMAGE_SHIELD_MISSED_EVADED_FULL_TEXT = "$source $spell was evaded by $dest."
ACTION_DAMAGE_SHIELD_MISSED_EVADED_FULL_TEXT_NO_SOURCE = "$spell was evaded by $dest."
ACTION_DAMAGE_SHIELD_MISSED_FULL_TEXT = "$source $spell missed $dest."
ACTION_DAMAGE_SHIELD_MISSED_FULL_TEXT_NO_SOURCE = "$spell missed $dest."
ACTION_DAMAGE_SHIELD_MISSED_IMMUNE_FULL_TEXT = "$source $spell failed. $dest was immune."
ACTION_DAMAGE_SHIELD_MISSED_IMMUNE_FULL_TEXT_NO_SOURCE = "$spell failed. $dest was immune."
ACTION_DAMAGE_SHIELD_MISSED_MISS_FULL_TEXT = "$source $spell misses $dest."
ACTION_DAMAGE_SHIELD_MISSED_MISS_FULL_TEXT_NO_SOURCE = "$spell misses $dest."
ACTION_DAMAGE_SHIELD_MISSED_PARRY_FULL_TEXT = "$source $spell was parried by $dest."
ACTION_DAMAGE_SHIELD_MISSED_PARRY_FULL_TEXT_NO_SOURCE = "$spell was parried by $dest."
ACTION_DAMAGE_SHIELD_MISSED_RESIST_FULL_TEXT = "$source $spell was fully resisted by $dest."
ACTION_DAMAGE_SHIELD_MISSED_RESIST_FULL_TEXT_NO_SOURCE = "$spell was fully resisted by $dest."
ACTION_DAMAGE_SPLIT_FULL_TEXT = "$source $spell causes $amount damage to $dest."
ACTION_ENCHANT_APPLIED_FULL_TEXT = "$source cast $spell on $dest $item."
ACTION_ENCHANT_REMOVED_FULL_TEXT = "$spell fades from $dest $item."
ACTION_ENVIRONMENTAL_DAMAGE_DROWNING_FULL_TEXT = "$dest is drowning and loses $amount health."
ACTION_ENVIRONMENTAL_DAMAGE_FALLING_FULL_TEXT = "$dest falls and loses $amount health."
ACTION_ENVIRONMENTAL_DAMAGE_FATIGUE_FULL_TEXT = "$dest is exhausted and loses $amount health."
ACTION_ENVIRONMENTAL_DAMAGE_FIRE_FULL_TEXT = "$dest suffers $amount fire damage."
ACTION_ENVIRONMENTAL_DAMAGE_FULL_TEXT = "$dest loses $amount health from environmental damage."
ACTION_ENVIRONMENTAL_DAMAGE_LAVA_FULL_TEXT = "$dest loses $amount health from swimming in lava."
ACTION_ENVIRONMENTAL_DAMAGE_SLIME_FULL_TEXT = "$dest loses $amount health for swimming in slime."
ACTION_PARTY_KILL_FULL_TEXT = "$source has slain $dest!"
ACTION_RANGE_DAMAGE_FULL_TEXT = "$source ranged shot hit $dest for $value.$result"
ACTION_RANGE_DAMAGE_FULL_TEXT_NO_SOURCE = "A ranged shot hit $dest for $value.$result"
ACTION_RANGE_MISSED_ABSORB_FULL_TEXT = "$source shot was absorbed by $dest."
ACTION_RANGE_MISSED_BLOCK_FULL_TEXT = "$source shot was blocked by $dest."
ACTION_RANGE_MISSED_DEFLECT_FULL_TEXT = "$source shot was deflected by $dest."
ACTION_RANGE_MISSED_DODGE_FULL_TEXT = "$source shot was dodged by $dest."
ACTION_RANGE_MISSED_EVADE_FULL_TEXT = "$source shot was evaded by $dest."
ACTION_RANGE_MISSED_FULL_TEXT = "$source shot misses $dest."
ACTION_RANGE_MISSED_IMMUNE_FULL_TEXT = "$source shot failed. $dest was immune."
ACTION_RANGE_MISSED_MISS_FULL_TEXT = "$source shot misses $dest."
ACTION_RANGE_MISSED_PARRY_FULL_TEXT = "$source shot was parried by $dest."
ACTION_RANGE_MISSED_RESIST_FULL_TEXT = "$source shot was fully resisted by $dest."
ACTION_SPELL_AURA_APPLIED_BUFF_FULL_TEXT = "$dest gains $spell."
ACTION_SPELL_AURA_APPLIED_DEBUFF_FULL_TEXT = "$dest is afflicted by $spell."
ACTION_SPELL_AURA_APPLIED_DOSE_BUFF_FULL_TEXT = "$dest gains $spell ($amount)."
ACTION_SPELL_AURA_APPLIED_DOSE_DEBUFF_FULL_TEXT = "$dest is afflicted by $spell ($amount)."
ACTION_SPELL_AURA_BROKEN_BUFF_FULL_TEXT = "$source's $spell was broken by $dest."
ACTION_SPELL_AURA_BROKEN_DEBUFF_FULL_TEXT = "$source's $spell was broken by $dest."
ACTION_SPELL_AURA_BROKEN_SPELL_BUFF_FULL_TEXT = "$source's $spell was broken by $dest's $extraSpell."
ACTION_SPELL_AURA_BROKEN_SPELL_DEBUFF_FULL_TEXT = "$source's $spell was broken by $dest's $extraSpell."
ACTION_SPELL_AURA_REFRESH_BUFF_FULL_TEXT = "$dest's $spell is refreshed."
ACTION_SPELL_AURA_REFRESH_DEBUFF_FULL_TEXT = "$dest's $spell is refreshed."
ACTION_SPELL_AURA_REMOVED_BUFF_FULL_TEXT = "$spell fades from $dest."
ACTION_SPELL_AURA_REMOVED_DEBUFF_FULL_TEXT = "$spell dissipates from $dest."
ACTION_SPELL_AURA_REMOVED_DOSE_BUFF_FULL_TEXT = "$source $spell ($amount) diminishes."
ACTION_SPELL_AURA_REMOVED_DOSE_DEBUFF_FULL_TEXT = "$source $spell ($amount) subsides."
ACTION_SPELL_AURA_REMOVED_FULL_TEXT = "$spell was removed from $dest."
ACTION_SPELL_AURA_STOLEN_BUFF_FULL_TEXT = "$source $spell steals $dest $extraSpell."
ACTION_SPELL_AURA_STOLEN_BUFF_FULL_TEXT_NO_SOURCE = "$spell steals $dest $extraSpell."
ACTION_SPELL_AURA_STOLEN_DEBUFF_FULL_TEXT = "$source $spell transfers $dest $extraSpell to $source."
ACTION_SPELL_AURA_STOLEN_DEBUFF_FULL_TEXT_NO_SOURCE = "$spell transfers $dest $extraSpell."
ACTION_SPELL_AURA_STOLEN_FULL_TEXT = "$source $spell steals $dest $extraSpell."
ACTION_SPELL_AURA_STOLEN_FULL_TEXT_NO_SOURCE = "$spell steals $dest $extraSpell."
ACTION_SPELL_CAST_FAILED_FULL_TEXT = "$source $spell failed.$result"
ACTION_SPELL_CAST_START_FULL_TEXT = "$source begins casting $spell at $dest."
ACTION_SPELL_CAST_START_FULL_TEXT_NO_DEST = "$source begins casting $spell."
ACTION_SPELL_CAST_SUCCESS_FULL_TEXT = "$source casts $spell at $dest."
ACTION_SPELL_CAST_SUCCESS_FULL_TEXT_NO_DEST = "$source casts $spell."
ACTION_SPELL_CREATE_FULL_TEXT = "$source $spell creates a $dest.$result"
ACTION_SPELL_CREATE_FULL_TEXT_NO_SOURCE = "$spell creates a $dest.$result"
ACTION_SPELL_DAMAGE_FULL_TEXT = "$source $spell hits $dest for $value.$result"
ACTION_SPELL_DAMAGE_FULL_TEXT_NO_SOURCE = "$spell hit $dest for $value.$result"
ACTION_SPELL_DISPEL_BUFF_FULL_TEXT = "$dest $extraSpell is dispelled by $source $spell."
ACTION_SPELL_DISPEL_BUFF_FULL_TEXT_NO_SOURCE = "$dest $extraSpell is dispelled by $spell."
ACTION_SPELL_DISPEL_DEBUFF_FULL_TEXT = "$dest $extraSpell is cleansed by $source $spell."
ACTION_SPELL_DISPEL_DEBUFF_FULL_TEXT_NO_SOURCE = "$dest $extraSpell is cleansed by $spell."
ACTION_SPELL_DISPEL_FAILED_FULL_TEXT = "$source $spell fails to dispel $dest $extraSpell."
ACTION_SPELL_DISPEL_FAILED_FULL_TEXT_NO_SOURCE = "$spell fails to dispel $dest $extraSpell."
ACTION_SPELL_DRAIN_FULL_TEXT = "$source $spell drains $amount $powerType from $dest."
ACTION_SPELL_DRAIN_FULL_TEXT_NO_SOURCE = " $spell drains $amount $powerType from $dest."
ACTION_SPELL_DURABILITY_DAMAGE_ALL_FULL_TEXT = "$source $spell damages $dest: all items damaged."
ACTION_SPELL_DURABILITY_DAMAGE_FULL_TEXT = "$source $spell damages $dest: $item damaged."
ACTION_SPELL_ENERGIZE_FULL_TEXT = "$dest gains $amount $powerType from $source $spell."
ACTION_SPELL_ENERGIZE_FULL_TEXT_NO_SOURCE = "$dest gains $amount $powerType from $spell."
ACTION_SPELL_EXTRA_ATTACKS_FULL_TEXT = "$source gains $amount extra attacks through $spell."
ACTION_SPELL_EXTRA_ATTACKS_FULL_TEXT_NO_SOURCE = "$amount extra attacks granted by $spell."
ACTION_SPELL_HEAL_FULL_TEXT = "$source $spell heals $dest for $amount.$result"
ACTION_SPELL_HEAL_FULL_TEXT_NO_SOURCE = "$spell heals $dest for $amount.$result"
ACTION_SPELL_INSTAKILL_FULL_TEXT = "$source $spell instantly kills $dest."
ACTION_SPELL_INSTAKILL_FULL_TEXT_NO_SOURCE = "$spell instantly kills $dest."
ACTION_SPELL_INTERRUPT_FULL_TEXT = "$source $spell interrupts $dest $extraSpell."
ACTION_SPELL_INTERRUPT_FULL_TEXT_NO_SOURCE = "$spell interrupts $dest $extraSpell."
ACTION_SPELL_LEECH_FULL_TEXT = "$source $spell drains $amount $powerType from $dest. $source gains $extraAmount $powerType."
ACTION_SPELL_LEECH_FULL_TEXT_NO_SOURCE = "$spell drains $amount $powerType from $dest."
ACTION_SPELL_MISSED_ABSORB_FULL_TEXT = "$source $spell was absorbed by $dest."
ACTION_SPELL_MISSED_ABSORB_FULL_TEXT_NO_SOURCE = "$spell was absorbed by $dest."
ACTION_SPELL_MISSED_BLOCK_FULL_TEXT = "$source $spell was blocked by $dest."
ACTION_SPELL_MISSED_BLOCK_FULL_TEXT_NO_SOURCE = "$spell was blocked by $dest."
ACTION_SPELL_MISSED_DEFLECT_FULL_TEXT = "$source $spell was deflected by $dest."
ACTION_SPELL_MISSED_DEFLECT_FULL_TEXT_NO_SOURCE = "$spell was deflected by $dest."
ACTION_SPELL_MISSED_DODGE_FULL_TEXT = "$source $spell was dodged by $dest."
ACTION_SPELL_MISSED_DODGE_FULL_TEXT_NO_SOURCE = "$spell was dodged by $dest."
ACTION_SPELL_MISSED_EVADE_FULL_TEXT = "$source $spell was evaded by $dest."
ACTION_SPELL_MISSED_EVADE_FULL_TEXT_NO_SOURCE = "$spell was evaded by $dest."
ACTION_SPELL_MISSED_FULL_TEXT = "$source $spell missed $dest."
ACTION_SPELL_MISSED_FULL_TEXT_NO_SOURCE = "$spell missed $dest."
ACTION_SPELL_MISSED_IMMUNE_FULL_TEXT = "$source $spell failed. $dest was immune."
ACTION_SPELL_MISSED_IMMUNE_FULL_TEXT_NO_SOURCE = "$spell failed. $dest was immune."
ACTION_SPELL_MISSED_MISS_FULL_TEXT = "$source $spell misses $dest."
ACTION_SPELL_MISSED_MISS_FULL_TEXT_NO_SOURCE = "$spell misses $dest."
ACTION_SPELL_MISSED_PARRY_FULL_TEXT = "$source $spell was parried by $dest."
ACTION_SPELL_MISSED_PARRY_FULL_TEXT_NO_SOURCE = "$spell was parried by $dest."
ACTION_SPELL_MISSED_REFLECT_FULL_TEXT = "$source $spell was reflected by $dest."
ACTION_SPELL_MISSED_REFLECT_FULL_TEXT_NO_SOURCE = "$spell was reflected by $dest."
ACTION_SPELL_MISSED_RESIST_FULL_TEXT = "$source $spell was fully resisted by $dest."
ACTION_SPELL_MISSED_RESIST_FULL_TEXT_NO_SOURCE = "$spell was fully resisted by $dest."
ACTION_SPELL_PERIODIC_DAMAGE_FULL_TEXT = "$dest suffers $value damage from $source $spell.$result"
ACTION_SPELL_PERIODIC_DAMAGE_FULL_TEXT_NO_SOURCE = "$dest suffers $value damage from $spell.$result"
ACTION_SPELL_PERIODIC_DRAIN_FULL_TEXT = "$source $spell drains $amount $powerType from $dest."
ACTION_SPELL_PERIODIC_DRAIN_FULL_TEXT_NO_SOURCE = "$spell drains $amount $powerType from $dest."
ACTION_SPELL_PERIODIC_ENERGIZE_FULL_TEXT = "$dest gains $amount $powerType from $source $spell."
ACTION_SPELL_PERIODIC_ENERGIZE_FULL_TEXT_NO_SOURCE = "$dest gains $amount $powerType from $spell."
ACTION_SPELL_PERIODIC_HEAL_FULL_TEXT = "$dest gains $amount health from $source $spell.$result"
ACTION_SPELL_PERIODIC_HEAL_FULL_TEXT_NO_SOURCE = "$dest gains $amount health from $spell.$result"
ACTION_SPELL_PERIODIC_LEECH_FULL_TEXT = "$source $spell drains $amount $powerType from $dest. $source gains $extraAmount $powerType."
ACTION_SPELL_PERIODIC_LEECH_FULL_TEXT_NO_SOURCE = "$spell drains $amount $powerType from $dest. $source gains $extraAmount $powerType."
ACTION_SPELL_PERIODIC_MISSED_ABSORB_FULL_TEXT = "$source $spell was absorbed by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_ABSORB_FULL_TEXT_NO_SOURCE = "$spell was absorbed by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_BLOCK_FULL_TEXT = "$source $spell was blocked by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_BLOCK_FULL_TEXT_NO_SOURCE = "$spell was blocked by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_DEFLECTED_FULL_TEXT = "$source $spell was deflected by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_DEFLECTED_FULL_TEXT_NO_SOURCE = "$spell was deflected by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_DODGE_FULL_TEXT = "$source $spell was dodged by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_DODGE_FULL_TEXT_NO_SOURCE = "$spell was dodged by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_EVADED_FULL_TEXT = "$source $spell was evaded by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_EVADED_FULL_TEXT_NO_SOURCE = "$spell was evaded by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_FULL_TEXT = "$source $spell does not affect $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_FULL_TEXT_NO_SOURCE = "$spell does not affect $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_IMMUNE_FULL_TEXT = "$dest was immune to $source $spell for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_IMMUNE_FULL_TEXT_NO_SOURCE = "$dest was immune to $spell for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_MISS_FULL_TEXT = "$source $spell missed $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_MISS_FULL_TEXT_NO_SOURCE = "$spell missed $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_PARRY_FULL_TEXT = "$source $spell was parried by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_PARRY_FULL_TEXT_NO_SOURCE = "$spell was parried by $dest for a moment.$result"
ACTION_SPELL_PERIODIC_MISSED_RESIST_FULL_TEXT = "$source $spell does not affect $dest. $dest resisted.$result"
ACTION_SPELL_PERIODIC_MISSED_RESIST_FULL_TEXT_NO_SOURCE = "$spell does not affect $dest. $dest resisted.$result"
ACTION_SPELL_SUMMON_FULL_TEXT = "$source $spell summons $dest.$result"
ACTION_SPELL_SUMMON_FULL_TEXT_NO_SOURCE = "$spell summons $dest.$result"
ACTION_SWING_DAMAGE_FULL_TEXT = "$source melee swing hits $dest for $value.$result"
ACTION_SWING_DAMAGE_FULL_TEXT_NO_SOURCE = "A melee swing hit $dest for $value.$result"
ACTION_SWING_MISSED_ABSORB_FULL_TEXT = "$source attack was absorbed by $dest."
ACTION_SWING_MISSED_BLOCK_FULL_TEXT = "$source attack was blocked by $dest."
ACTION_SWING_MISSED_DEFLECT_FULL_TEXT = "$source attack was deflected by $dest."
ACTION_SWING_MISSED_DODGE_FULL_TEXT = "$source attack was dodged by $dest."
ACTION_SWING_MISSED_EVADE_FULL_TEXT = "$source attack was evaded by $dest."
ACTION_SWING_MISSED_FULL_TEXT = "$source attack misses $dest."
ACTION_SWING_MISSED_IMMUNE_FULL_TEXT = "$source attack failed. $dest was immune."
ACTION_SWING_MISSED_MISS_FULL_TEXT = "$source attack misses $dest."
ACTION_SWING_MISSED_PARRY_FULL_TEXT = "$source attack was parried by $dest."
ACTION_SWING_MISSED_RESIST_FULL_TEXT = "$source attack was fully resisted by $dest."
ACTION_UNIT_DESTROYED_FULL_TEXT = "$dest was destroyed."
ACTION_UNIT_DIED_FULL_TEXT = "$dest died."

local function onevent(event, ...)
  local timestamp, tevent, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags = select(1, ...)
  local flags = srcFlags or dstFlags
  if bit.band(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
    local prefix, suffix = string.split("_", tevent, 2)
    if prefix == "SPELL" then
      local id, spell, school = select(9, ...)
      if suffix == "CAST_START" then
        Nurfed_SpellAlert:AddMessage(format(SPELLCASTGOOTHER, srcName, "|cff999999"..spell.."|r"))
      elseif suffix == "CAST_SUCCESS" then
        Nurfed_SpellAlert:AddMessage(format(SPELLCASTGOOTHER, srcName, "|cff999999"..spell.."|r"))
      elseif suffix == "AURA_APPLIED" then
        local auratype = select(12, ...)
        if auratype == "BUFF" then
          Nurfed_BuffAlert:AddMessage(format(AURAADDEDOTHERHELPFUL, dstName, "|cff00ff00"..spell.."|r"))
        end
      end
    end
  end
end

Nurfed:regevent("COMBAT_LOG_EVENT_UNFILTERED", onevent)

CreateFrame("MessageFrame", "Nurfed_SpellAlert", UIParent)
Nurfed_SpellAlert:SetWidth(UIParent:GetWidth())
Nurfed_SpellAlert:SetHeight(20)
Nurfed_SpellAlert:SetInsertMode("TOP")
Nurfed_SpellAlert:SetFrameStrata("HIGH")
Nurfed_SpellAlert:SetTimeVisible(1)
Nurfed_SpellAlert:SetFadeDuration(0.5)
Nurfed_SpellAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_SpellAlert:SetPoint("CENTER", 0, 95)

CreateFrame("MessageFrame", "Nurfed_BuffAlert", UIParent)
Nurfed_BuffAlert:SetWidth(UIParent:GetWidth())
Nurfed_BuffAlert:SetHeight(20)
Nurfed_BuffAlert:SetInsertMode("TOP")
Nurfed_BuffAlert:SetFrameStrata("HIGH")
Nurfed_BuffAlert:SetTimeVisible(1)
Nurfed_BuffAlert:SetFadeDuration(0.5)
Nurfed_BuffAlert:SetFont("Fonts\\FRIZQT__.TTF", 18, "OUTLINE")
Nurfed_BuffAlert:SetPoint("BOTTOM", Nurfed_SpellAlert, "TOP", 0, 2)