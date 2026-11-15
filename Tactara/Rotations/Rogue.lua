-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: built-in Rogue rotations for WoW Forever.
--
-- Based on the WoW Forever Rogue guides on Warcraft Tavern, wowtbc.gg and
-- Mobalytics, Blizzard's Forever class deep dive and the Forever ability
-- list on warcraft.wiki.gg (checked November 2026). Forever changes that
-- matter here:
--   * Shank (level 24): a cheap off-hand strike that gives back Energy.
--   * Assassination: Venom (30) is passive since the November 2 changes:
--     Shank sets it off (stronger poisons for a few seconds), so Shank goes
--     on cooldown. Mutilate (40) is the dagger builder. Slice and Dice comes
--     before Eviscerate.
--   * Combat: Blade Flurry and Adrenaline Rush; Riposte after a parry.
--   * Subtlety: Hemorrhage builds, Rupture and Ghostly Strike, Premeditation
--     from Stealth.
--
-- WoW doesn't tell addons your Energy or combo points, so the key plays a
-- fixed mix: about four builders for each finisher. A finisher with no
-- combo points can't be used, so that press falls through to a builder.
-- Out of combat with an enemy targeted, the key puts you in Stealth and
-- opens with Cheap Shot (from 26). Poisons are up to you.

local ADDON, ns = ...

ns.RegisterBuiltin([=[
name: Rogue - Combat
class: ROGUE
detect: Blade Flurry
tree: Combat
weapon: dual
default: yes
notes: Sinister Strike to build, Slice and Dice and Eviscerate to spend, Shank (24) on cooldown, Riposte after a parry, Blade Flurry and Adrenaline Rush as they come up.

[keypress]
/cast [nocombat,harm,nodead,stealth] Cheap Shot
/cast [nocombat,harm,nodead,nostealth] Stealth
/startattack [harm,nodead,nostealth]

[opener]
/cast Sinister Strike
/cast Sinister Strike
    /cast Shank
/cast Slice and Dice
    /cast Sinister Strike

[loop]
4x /cast Sinister Strike
    /cast Shank
1x /cast Riposte
    /cast Sinister Strike
1x /cast Slice and Dice
    /cast Sinister Strike
2x /cast Eviscerate
    /cast Sinister Strike
1x /cast Shank
    /cast Sinister Strike
1x /cast Adrenaline Rush
    /cast Blade Flurry
    /cast Sinister Strike

[aoe]
1x /cast Blade Flurry
    /cast Adrenaline Rush
    /cast Sinister Strike
4x /cast Sinister Strike
    /cast Shank
1x /cast Slice and Dice
    /cast Sinister Strike
1x /cast Eviscerate
    /cast Sinister Strike

[priority]
/cast Riposte
/cast Blade Flurry @enemies 2
/cast Adrenaline Rush
/cast Slice and Dice @missing Slice and Dice @combo 1
/cast Shank
/cast Eviscerate @combo 4
/cast Sinister Strike

[interrupt]
/cast Kick
/cast Gouge
/cast Kidney Shot

[defensive]
/cast Vanish @health 15
/cast Evasion @health 45
# Crowd control is off by default. Remove the # to turn it on:
# /cast Blind @health 25
]=])

ns.RegisterBuiltin([=[
name: Rogue - Assassination
class: ROGUE
detect: Mutilate
tree: Assassination
weapon: dual
notes: Poisons. Builds with Mutilate (daggers, 40) or Sinister Strike, keeps Slice and Dice up, Eviscerate with what's left. Shank and Cold Blood on cooldown: from 30, Shank also sets off Venom for stronger poisons.

[keypress]
/cast [nocombat,harm,nodead,stealth] Cheap Shot
/cast [nocombat,harm,nodead,nostealth] Stealth
/startattack [harm,nodead,nostealth]

[opener]
/cast Mutilate
    /cast Sinister Strike
/cast Mutilate
    /cast Sinister Strike
/cast Slice and Dice
    /cast Mutilate
    /cast Sinister Strike

[loop]
4x /cast Mutilate
    /cast Sinister Strike
1x /cast Slice and Dice
    /cast Mutilate
    /cast Sinister Strike
1x /cast Cold Blood
    /cast Mutilate
    /cast Sinister Strike
1x /cast Eviscerate
    /cast Mutilate
    /cast Sinister Strike
1x /cast Shank
    /cast Mutilate
    /cast Sinister Strike

[priority]
/cast Slice and Dice @missing Slice and Dice @combo 1
/cast Shank
/cast Cold Blood
/cast Eviscerate @combo 5
/cast Mutilate
/cast Sinister Strike

[interrupt]
/cast Kick
/cast Gouge
/cast Kidney Shot

[defensive]
/cast Vanish @health 15
/cast Evasion @health 45
# Crowd control is off by default. Remove the # to turn it on:
# /cast Blind @health 25
]=])

ns.RegisterBuiltin([=[
name: Rogue - Subtlety
class: ROGUE
detect: Hemorrhage
tree: Subtlety
weapon: dual
notes: Opens from Stealth with Premeditation and Cheap Shot, builds with Hemorrhage (Sinister Strike before 30), keeps Rupture and Slice and Dice up, Ghostly Strike on cooldown, Death Mark (40) at 5 combo points.

[keypress]
/cast [harm,nodead,stealth] Premeditation
/cast [nocombat,harm,nodead,stealth] Cheap Shot
/cast [nocombat,harm,nodead,nostealth] Stealth
/startattack [harm,nodead,nostealth]

[opener]
/cast Hemorrhage
    /cast Sinister Strike
/cast Slice and Dice
    /cast Hemorrhage
    /cast Sinister Strike
/cast Ghostly Strike
    /cast Hemorrhage
    /cast Sinister Strike

[loop]
4x /cast Hemorrhage
    /cast Sinister Strike
1x /cast Ghostly Strike
    /cast Hemorrhage
    /cast Sinister Strike
1x /cast Rupture
    /cast Hemorrhage
    /cast Sinister Strike
1x /cast Slice and Dice
    /cast Hemorrhage
    /cast Sinister Strike
1x /cast Eviscerate
    /cast Hemorrhage
    /cast Sinister Strike
1x /cast Death Mark
    /cast Shank
    /cast Hemorrhage
    /cast Sinister Strike

[priority]
/cast Slice and Dice @missing Slice and Dice @combo 1
/cast Rupture @nodebuff Rupture @combo 4
/cast Death Mark @combo 5
/cast Ghostly Strike
/cast Shank
/cast Eviscerate @combo 5
/cast Hemorrhage
/cast Sinister Strike

[interrupt]
/cast Kick
/cast Gouge
/cast Kidney Shot

[defensive]
/cast Vanish @health 15
/cast Preparation @health 15
/cast Evasion @health 45
# Crowd control is off by default. Remove the # to turn it on:
# /cast Blind @health 25
]=])
