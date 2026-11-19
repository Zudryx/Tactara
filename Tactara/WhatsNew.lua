-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: the newest changelog sections, for the "what's new" window.
-- Made from CHANGELOG.md by tests/make_whats_new.py: edit the changelog,
-- then run that script. Don't edit this file by hand.

local ADDON, ns = ...

ns.WHATS_NEW = {
  { version = "0.19.2", lines = {
    "- **Fixed:** if the key bar or the helper popup was set to a size other than 100%, it crept a little across the screen on every login or `/reload`. It now stays where you put it. Thanks to the player who found the cause and sent the fix.",
    "- **Fixed:** `/tac probe` caused a Lua error in dungeon fights, where the game hides your target's name from addons. It now shows the name as HIDDEN, says which dungeon you're in, and finishes the report. Anything Tactara prints to chat shows hidden values as \"(hidden)\" instead of erroring.",
  } },
  { version = "0.19.1", lines = {
    "Rotation review for mid-November: the WoW Forever hotfixes up to November 13 and the class guides.",
    "- **Assassination Rogue:** Venom is a passive now: Shank sets it off and your poisons hit harder for a few seconds. The rotation stops trying to cast Venom as a finisher, and the helper shows Shank whenever it's ready.",
    "- **Subtlety Rogue:** the helper waits for 5 combo points before showing Death Mark (it's a finisher, and it stores more damage with more points).",
    "- **Survival Hunter:** once you take Lone Wolf, the helper stops asking you to call your pet.",
    "- **Feral Druid (Cat and Bear):** Berserk isn't in WoW Forever, so it's gone from the rotations. Lacerate is a talent you can take at 25 (not a level 42 spell); the notes say so.",
    "- **Fire Mage:** the helper no longer shows Pyroblast all the time. Pyroblast pays off with Heating Up, which the helper can't count, so it now shows Combustion, Fire Blast and Fireball, and the key still mixes in Scorch and Pyroblast.",
    "- **Affliction Warlock:** after the November 10 hotfix, Wrack makes Corruption, Siphon Life and Bane of Agony tick twice as fast while you channel it. From 40 the opener ends with Wrack, right after your DoTs are up.",
    "- **Holy Priest:** in WoW Forever it's Holy Binding, a passive (your Flash Heal on someone else heals you too), not a Binding Heal spell. The self-heal line that tried to cast it is gone.",
    "- **Arms Warrior:** the helper shows Spearing Strike (talent) ahead of Mortal Strike against Giants and Dragonkin, where it does double damage, as Icy Veins recommends. It needs Battle Stance.",
    "- **All Warriors:** the helper shows Reckless Swings (talent) when you have 60% health or more. It costs a quarter of your base health for extra Rage on your next 4 swings, and it comes after your big hitters, so it shows when they're waiting on Rage or on cooldown. The key doesn't cast it, because the key can't check your health.",
    "- **Fury Warrior:** checked against Icy Veins: Whirlwind before Bloodthirst and Execute is still right. No change.",
    "- **Enhancement Shaman talent build:** Icy Veins changed its leveling build on November 13 to save Mana: one point in Maelstrom Weapon at 43, Water Shield at 46 and Elemental Focus at 57 instead of five Maelstrom Weapon points and Rage of the Farseer. Tactara's build follows it. If you follow the old version, Tactara asks before switching. The rotation now keeps Water Shield up once you have it, in place of Lightning Shield. The level 60 build hasn't changed.",
    "- The other talent builds still match Icy Veins.",
    "- **Your own rotations:** `@health above 60` shows a line only when your health is 60% or more (`@health 35` still means below 35%).",
  } },
  { version = "0.19.0", lines = {
    "- **A cleaner look for the helper popup and the key bar.** Every icon has a thin frame. The best spell now, and your key's next press, are framed in Tactara's cyan (the color of its logo and the glow). The interrupt and defensive slots are framed in red and orange, with an outlined caption in the same color under them. PULL is in cyan too.",
    "- **Display look:** Standard (all of the above) or **Minimal**: just the icons, with a thin red or orange edge left on the interrupt and defensive slots so you can tell them apart. Settings page (Displays) or `/tac look minimal`.",
    "- Tactara's windows (rotation editor, talent planner, what's new, key setup) show the logo and the name in cyan in their title. Menus, buttons and the settings page stay the game's own, so they look like the rest of your UI.",
    "- No gameplay changes.",
  } },
}
