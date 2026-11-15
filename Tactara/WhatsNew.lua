-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: the newest changelog sections, for the "what's new" window.
-- Made from CHANGELOG.md by tests/make_whats_new.py: edit the changelog,
-- then run that script. Don't edit this file by hand.

local ADDON, ns = ...

ns.WHATS_NEW = {
  { version = "0.19.1", lines = {
    "Rotation review for mid-November: the WoW Forever hotfixes up to November 13 and the class guides.",
    "- **Assassination Rogue:** Venom is a passive now: Shank sets it off and your poisons hit harder for a few seconds. The rotation stops trying to cast Venom as a finisher, and the helper shows Shank whenever it's ready.",
    "- **Subtlety Rogue:** the helper waits for 5 combo points before showing Death Mark (it's a finisher, and it stores more damage with more points).",
    "- **Survival Hunter:** once you take Lone Wolf, the helper stops asking you to call your pet.",
    "- **Feral Druid (Cat and Bear):** Berserk isn't in WoW Forever, so it's gone from the rotations. Lacerate is a talent you can take at 25 (not a level 42 spell); the notes say so.",
    "- **Fire Mage:** the helper no longer shows Pyroblast all the time. Pyroblast pays off with Heating Up, which the helper can't count, so it now shows Combustion, Fire Blast and Fireball, and the key still mixes in Scorch and Pyroblast.",
    "- **Affliction Warlock:** after the November 10 hotfix, Wrack makes Corruption, Siphon Life and Bane of Agony tick twice as fast while you channel it. From 40 the opener ends with Wrack, right after your DoTs are up.",
    "- **Holy Priest:** in WoW Forever it's Holy Binding, a passive (your Flash Heal on someone else heals you too), not a Binding Heal spell. The self-heal line that tried to cast it is gone.",
    "- Talent builds haven't changed.",
  } },
  { version = "0.19.0", lines = {
    "- **A cleaner look for the helper popup and the key bar.** Every icon has a thin frame. The best spell now, and your key's next press, are framed in Tactara's cyan (the color of its logo and the glow). The interrupt and defensive slots are framed in red and orange, with an outlined caption in the same color under them. PULL is in cyan too.",
    "- **Display look:** Standard (all of the above) or **Minimal**: just the icons, with a thin red or orange edge left on the interrupt and defensive slots so you can tell them apart. Settings page (Displays) or `/tac look minimal`.",
    "- Tactara's windows (rotation editor, talent planner, what's new, key setup) show the logo and the name in cyan in their title. Menus, buttons and the settings page stay the game's own, so they look like the rest of your UI.",
    "- No gameplay changes.",
  } },
  { version = "0.18.0", lines = {
    "- **Your own limits:** on the settings page (Reminders), or with commands:",
    "  - **Buffs running low:** Early (twice as long left), Normal, Late (half) or Only when missing. `/tac buffs low early`",
    "  - **Low on ammo under** this many shots (200 by default). `/tac supplies ammo 300`",
    "  - **Low on Soul Shards under** this many (2 by default). `/tac supplies shards 3`",
    "  - At 0, ammo and shards only count when you're out.",
    "- **Hide while mounted:** the helper popup and the key bar step aside while you're on a mount or a flight path, and come back when you get off or a fight starts. Off until you turn it on: settings page (Displays) or `/tac mounted on`. While the displays are unlocked they stay, so you can still move them.",
    "- **Feral Druid (Cat and Bear):** the rotations used Faerie Fire (Feral), which WoW Forever removed, so the pull and the armor debuff were skipped. In Forever plain Faerie Fire works in Bear and Cat Form (free, 6-second cooldown), and the rotations use that now: to pull, in the opener and to keep the debuff up.",
    "- **Games in other languages:** Feral Charge now finds the right spell (in Forever the talent is the charge itself, in Cat and Bear Form), and a few spell IDs with old names were dropped. On English games nothing changes.",
  } },
}
