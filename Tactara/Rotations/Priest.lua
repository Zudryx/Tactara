-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: built-in Priest rotations for WoW Forever.
--
-- Based on the WoW Forever Priest guides on Warcraft Tavern, wowtbc.gg and
-- Mobalytics, and Blizzard's Forever class deep dive (checked November
-- 2026). Forever changes that matter here:
--   * Every Priest learns Devouring Plague and Fear Ward at 20, Divine Spirit
--     at 30 and Shadow Word: Death (new) at 32. Shadow Word: Death hits you
--     for 30% of your maximum health when it doesn't kill the target (spell
--     data, November 2026), and the game hides the target's health from
--     addons, so no rotation casts it: it's a line you can turn on in
--     [priority] if you want the helper to show it.
--   * Shadowform now allows every non-healing spell.
--   * Discipline gets Penance (channel: damage or healing), Holy gets
--     Holy Binding (a passive: your Flash Heal on someone else heals you
--     too) and Prayer of Mending.
--
-- Discipline and Holy have no healing button: healing needs you to pick who
-- to heal, so those two rotations are the solo damage you level with
-- (Holy Fire, Penance, Smite), and you heal your group by hand. The helper
-- suggests your wand when you're out of mana.

local ADDON, ns = ...

ns.RegisterBuiltin([=[
name: Priest - Shadow
class: PRIEST
detect: Shadowform
tree: Shadow
default: yes
notes: Mind Blast to pull, Shadow Word: Pain and Devouring Plague up, Mind Blast on cooldown, Vampiric Embrace, Mind Flay to fill. Let Mind Flay finish before the next press when you can: pressing during the channel cuts it short.

[opener]
/cast Mind Blast
    /cast Smite
/cast Shadow Word: Pain
    /cast Smite
/cast Devouring Plague
    /cast Vampiric Embrace
    /cast Smite

[loop]
3x /cast Mind Blast
    /cast Mind Flay
    /cast Smite
3x /cast Mind Flay
    /cast Mind Blast
    /cast Smite
1x /cast Shadow Word: Pain
    /cast Mind Flay
    /cast Smite
1x /cast Devouring Plague
    /cast Mind Flay
    /cast Smite
1x /cast Vampiric Embrace
    /cast Mind Flay
    /cast Smite

[priority]
/cast Power Word: Fortitude @missing Power Word: Fortitude
/cast Inner Fire @missing Inner Fire
/cast Divine Spirit @missing Divine Spirit
/cast Shadowform @missing Shadowform
/cast Shadow Word: Pain @nodebuff Shadow Word: Pain
/cast Devouring Plague @nodebuff Devouring Plague
/cast Vampiric Embrace @nodebuff Vampiric Embrace
/cast Mind Blast
/cast Mind Flay
# Shadow Word: Death hurts you for 30% of your health when it doesn't kill.
# Remove the # to have the helper show it anyway:
# /cast Shadow Word: Death
/cast Smite
/cast Shoot

[interrupt]
/cast Silence

[defensive]
/cast Power Word: Shield @health 60
/cast Desperate Prayer @health 30
# Crowd control is off by default. Remove the # to turn it on:
# /cast Psychic Scream @health 30
]=])

ns.RegisterBuiltin([=[
name: Priest - Discipline
class: PRIEST
detect: Penance
tree: Discipline
notes: Solo damage for a Discipline Priest: Holy Fire and Shadow Word: Pain up, Penance and Mind Blast on cooldown, Smite to fill. Shield yourself when you take damage. Group healing is up to you.

[opener]
/cast Holy Fire
    /cast Smite
/cast Shadow Word: Pain
    /cast Smite
/cast Penance
    /cast Mind Blast
    /cast Smite

[loop]
3x /cast Penance
    /cast Mind Blast
    /cast Smite
2x /cast Mind Blast
    /cast Penance
    /cast Smite
3x /cast Smite
1x /cast Holy Fire
    /cast Smite
1x /cast Shadow Word: Pain
    /cast Smite

[priority]
/cast Power Word: Fortitude @missing Power Word: Fortitude
/cast Inner Fire @missing Inner Fire
/cast Divine Spirit @missing Divine Spirit
/cast Holy Fire @nodebuff Holy Fire
/cast Shadow Word: Pain @nodebuff Shadow Word: Pain
/cast Penance
/cast Mind Blast
# Shadow Word: Death hurts you for 30% of your health when it doesn't kill.
# Remove the # to have the helper show it anyway:
# /cast Shadow Word: Death
/cast Smite
/cast Shoot

[interrupt]
/cast Silence

[defensive]
/cast Power Word: Shield @health 70
/cast Desperate Prayer @health 30
/cast [@player] Flash Heal @health 40
/cast [@player] Renew @health 60
# Crowd control is off by default. Remove the # to turn it on:
# /cast Psychic Scream @health 30
]=])

ns.RegisterBuiltin([=[
name: Priest - Holy
class: PRIEST
detect: Prayer of Mending
tree: Holy
notes: Solo damage for a Holy Priest: Holy Fire and Shadow Word: Pain up, Mind Blast on cooldown, Smite to fill, Holy Nova on groups. Group healing is up to you.

[opener]
/cast Holy Fire
    /cast Smite
/cast Shadow Word: Pain
    /cast Smite
/cast Mind Blast
    /cast Smite

[loop]
3x /cast Mind Blast
    /cast Smite
4x /cast Smite
1x /cast Holy Fire
    /cast Smite
1x /cast Shadow Word: Pain
    /cast Smite

[aoe]
3x /cast Holy Nova
    /cast Smite
1x /cast Shadow Word: Pain
    /cast Holy Nova
    /cast Smite
1x /cast Mind Blast
    /cast Holy Nova
    /cast Smite

[priority]
/cast Power Word: Fortitude @missing Power Word: Fortitude
/cast Inner Fire @missing Inner Fire
/cast Divine Spirit @missing Divine Spirit
/cast Holy Nova @enemies 3
/cast Holy Fire @nodebuff Holy Fire
/cast Shadow Word: Pain @nodebuff Shadow Word: Pain
/cast Mind Blast
# Shadow Word: Death hurts you for 30% of your health when it doesn't kill.
# Remove the # to have the helper show it anyway:
# /cast Shadow Word: Death
/cast Smite
/cast Shoot

[interrupt]
/cast Silence

[defensive]
/cast Power Word: Shield @health 70
/cast Desperate Prayer @health 30
/cast [@player] Flash Heal @health 40
/cast [@player] Renew @health 60
# Crowd control is off by default. Remove the # to turn it on:
# /cast Psychic Scream @health 30
]=])
