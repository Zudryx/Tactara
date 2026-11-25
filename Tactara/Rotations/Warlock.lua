-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: built-in Warlock rotations for WoW Forever.
--
-- Based on the WoW Forever Warlock guides on Warcraft Tavern, Mobalytics
-- and wowtbc.gg, and Blizzard's Forever class deep dive (checked November
-- 2026). Forever changes that matter here:
--   * Curse of Agony is now Bane of Agony (one Bane per target, and it no
--     longer competes with a utility Curse).
--   * Affliction: Wrack (40) is a 6-second channel. Since the November 10
--     hotfix your Corruption, Siphon Life and Bane of Agony tick twice as
--     fast while you channel it (it no longer makes them hit harder), so it
--     comes right after those three are up.
--   * Demonology: Searing Pain brands the target for your demon (Demonic
--     Brand); demons scale with your gear.
--   * Destruction: Conflagrate and Incinerate (40, stronger on Immolated
--     targets), Bane of Havoc.
--
-- Every press sends your demon. Spells that cost a Soul Shard (Soul Fire,
-- Shadowburn) are left to you. Drains are channels: pressing again during
-- one cuts it short. When you run low on mana the helper shows Life Tap,
-- then your wand.

local ADDON, ns = ...

ns.RegisterBuiltin([=[
name: Warlock - Affliction
class: WARLOCK
detect: Wrack
tree: Affliction
default: yes
notes: DoTs: Bane of Agony to pull, Corruption, Immolate and Siphon Life, then Wrack (40) as your filler, Drain Life and Shadow Bolt before it. Voidwalker to tank while leveling; once you sacrifice a demon (Demonic Sacrifice) it stops suggesting one.

[keypress]
/petattack [harm,nodead]

[opener]
/cast Bane of Agony
    /cast Corruption
    /cast Immolate
    /cast Shadow Bolt
/cast Corruption
    /cast Immolate
    /cast Shadow Bolt
/cast Immolate
    /cast Shadow Bolt
/cast Siphon Life
    /cast Shadow Bolt
/cast Wrack

[loop]
# Wrack is the filler once you have it (Icy Veins' Wrack build casts Shadow
# Bolt only when Nightfall makes it instant); Shadow Bolt before that.
3x /cast Wrack
    /cast Shadow Bolt
2x /cast Wrack
    /cast Drain Life
    /cast Shadow Bolt
1x /cast Drain Life
    /cast Shadow Bolt
1x /cast Corruption
    /cast Shadow Bolt
1x /cast Bane of Agony
    /cast Shadow Bolt
1x /cast Siphon Life
    /cast Immolate
    /cast Shadow Bolt

[aoe]
2x /cast Corruption
    /cast Bane of Agony
    /cast Shadow Bolt
2x /cast Hellfire
    /cast Shadow Bolt
1x /cast Bane of Agony
    /cast Shadow Bolt

[priority]
/cast Demon Armor @missing Demon Armor
/cast Demon Skin @missing Demon Skin @unless Demon Armor
# Icy Veins' builds take Demonic Sacrifice (Affliction 41, Destruction 55):
# you sacrifice a demon for a two-hour buff that summoning any demon
# removes, so once you know it Tactara stops suggesting one.
/cast Summon Voidwalker @nopet @unless Demonic Sacrifice
/cast Summon Imp @nopet @unless Summon Voidwalker @unless Demonic Sacrifice
/cast Rain of Fire @enemies 4
/cast Bane of Agony @nodebuff Bane of Agony
/cast Corruption @nodebuff Corruption
/cast Siphon Life @nodebuff Siphon Life
/cast Immolate @nodebuff Immolate
/cast Wrack
/cast Shadow Bolt
/cast Life Tap
/cast Shoot

[interrupt]
/cast Spell Lock
/cast Death Coil

[defensive]
/cast Death Coil @health 30
/cast Drain Life @health 45
# Crowd control is off by default. Remove the # to turn it on:
# /cast Fear @health 25
]=])

ns.RegisterBuiltin([=[
name: Warlock - Demonology
class: WARLOCK
detect: Demonic Sacrifice
tree: Demonology
notes: Pet first: Searing Pain to brand the target for your demon, then Bane of Agony, Corruption and Immolate, Shadow Bolt to fill. Voidwalker while leveling.

[keypress]
/petattack [harm,nodead]

[opener]
/cast Searing Pain
    /cast Shadow Bolt
/cast Bane of Agony
    /cast Corruption
    /cast Shadow Bolt
/cast Corruption
    /cast Immolate
    /cast Shadow Bolt
/cast Immolate
    /cast Shadow Bolt

[loop]
4x /cast Shadow Bolt
1x /cast Searing Pain
    /cast Shadow Bolt
1x /cast Immolate
    /cast Shadow Bolt
1x /cast Corruption
    /cast Shadow Bolt
1x /cast Bane of Agony
    /cast Shadow Bolt
1x /cast Drain Life
    /cast Shadow Bolt

[aoe]
2x /cast Corruption
    /cast Bane of Agony
    /cast Shadow Bolt
2x /cast Hellfire
    /cast Searing Pain
1x /cast Searing Pain
    /cast Shadow Bolt

[priority]
/cast Demon Armor @missing Demon Armor
/cast Demon Skin @missing Demon Skin @unless Demon Armor
/cast Summon Voidwalker @nopet
/cast Summon Imp @nopet @unless Summon Voidwalker
/cast Rain of Fire @enemies 4
/cast Searing Pain @nodebuff Searing Pain
/cast Bane of Agony @nodebuff Bane of Agony
/cast Corruption @nodebuff Corruption
/cast Immolate @nodebuff Immolate
/cast Shadow Bolt
/cast Life Tap
/cast Shoot

[interrupt]
/cast Spell Lock
/cast Death Coil

[defensive]
/cast Death Coil @health 30
/cast Drain Life @health 45
# Crowd control is off by default. Remove the # to turn it on:
# /cast Fear @health 25
]=])

ns.RegisterBuiltin([=[
name: Warlock - Destruction
class: WARLOCK
detect: Conflagrate
tree: Destruction
notes: Immolate up, Conflagrate on cooldown, Incinerate (40; Shadow Bolt before) to fill, Corruption and Bane of Agony on longer fights; once you sacrifice a demon (Demonic Sacrifice) it stops suggesting one.

[keypress]
/petattack [harm,nodead]

[opener]
/cast Immolate
    /cast Shadow Bolt
/cast Conflagrate
    /cast Corruption
    /cast Shadow Bolt
/cast Incinerate
    /cast Shadow Bolt

[loop]
4x /cast Incinerate
    /cast Shadow Bolt
2x /cast Conflagrate
    /cast Incinerate
    /cast Shadow Bolt
1x /cast Immolate
    /cast Incinerate
    /cast Shadow Bolt
1x /cast Corruption
    /cast Incinerate
    /cast Shadow Bolt
1x /cast Bane of Agony
    /cast Incinerate
    /cast Shadow Bolt

[aoe]
2x /cast Immolate
    /cast Hellfire
2x /cast Hellfire
    /cast Incinerate
    /cast Shadow Bolt
1x /cast Conflagrate
    /cast Incinerate
    /cast Shadow Bolt

[priority]
/cast Demon Armor @missing Demon Armor
/cast Demon Skin @missing Demon Skin @unless Demon Armor
# Icy Veins' builds take Demonic Sacrifice (Affliction 41, Destruction 55):
# you sacrifice a demon for a two-hour buff that summoning any demon
# removes, so once you know it Tactara stops suggesting one.
/cast Summon Voidwalker @nopet @unless Demonic Sacrifice
/cast Summon Imp @nopet @unless Summon Voidwalker @unless Demonic Sacrifice
/cast Rain of Fire @enemies 4
/cast Immolate @nodebuff Immolate
/cast Conflagrate
/cast Corruption @nodebuff Corruption
/cast Bane of Agony @nodebuff Bane of Agony
/cast Incinerate
/cast Shadow Bolt
/cast Life Tap
/cast Shoot

[interrupt]
/cast Spell Lock
/cast Death Coil

[defensive]
/cast Death Coil @health 30
/cast Drain Life @health 45
# Crowd control is off by default. Remove the # to turn it on:
# /cast Fear @health 25
]=])
