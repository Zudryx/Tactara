-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: the newest changelog sections, for the "what's new" window.
-- Made from CHANGELOG.md by tests/make_whats_new.py: edit the changelog,
-- then run that script. Don't edit this file by hand.

local ADDON, ns = ...

ns.WHATS_NEW = {
  { version = "0.19.5", lines = {
    "- **Talent builds updated to the latest Icy Veins guides** (changed November 16–22). If you follow one of these, Tactara asks before switching you to the new version:",
    "  - **Fury Warrior** (leveling): Blood Craze, Gore Drinker and Deflection in place of Improved Rend, Improved Overpower and Deep Wounds.",
    "  - **Shadow Priest** (leveling): Shadow Focus and Twin Disciplines in place of Shadow Reach and Mental Strength. This is Icy Veins' no-respec path; they also suggest a Meditation build to 40 and a respec into Shadow there.",
    "  - **Subtlety Rogue** (leveling): Dirty Deeds, Master of Deception, Improved Slice and Dice and Precision in place of Improved Ambush, Remorseless Attacks and Lethality.",
    "  - **Survival Hunter** (leveling): no more Lone Wolf, so you keep your pet. Deadly Aspects, Focused Fire and Resourcefulness come in; Improved Stings, Efficiency and Mortal Shots go.",
    "  - **Affliction Warlock** (level 60): Demonology for Demonic Sacrifice in place of Destruction's Bane and Ruin.",
    "  - **Holy Paladin** (level 60): Divine Precision in place of Holy Conduit.",
    "- **Fury Warrior rotation** follows Icy Veins' rewritten guide: Rend, Overpower and Thunder Clap stop once you learn Whirlwind (36), Victory Rush comes first when it's up, and Death Wish and Berserker Rage join the helper's suggestions.",
    "- **Priests: no more Shadow Word: Death.** It hits you for 30% of your health when it doesn't kill the target, and the game hides your target's health, so neither the key nor the helper can tell when it's safe. Remove the # in front of it in your rotation if you want the helper to show it anyway.",
    "- **Shadow Priest** pulls with Mind Blast, as Icy Veins suggests.",
    "- **Subtlety Rogue** opens from Stealth with Garrote (from 14) instead of Cheap Shot.",
    "- **Affliction and Destruction Warlocks:** once you know Demonic Sacrifice, Tactara stops suggesting a demon, because summoning one removes the sacrifice buff. Affliction's key uses Wrack as its filler once you have it.",
    "- `/tac test` rounds buff timers to whole seconds.",
  } },
  { version = "0.19.4", lines = {
    "- **Defensive suggestions work again on WoW Forever.** The game hides your current health from addons, even out of combat, so Shield Wall, Ice Block, Feign Death, self-heals and every other health-based defensive stayed quiet. Tactara now hands each ready defensive to the game with its health line (\"show below 20%\"), and the game shows or hides its icon in the orange slot by your health. Tactara never reads it. When several are ready, the first in the list sits on top, so you see the one that applies.",
    "- **Reckless Swings (Warrior)** works the same way: when it's ready and ranks above the helper's suggestion, the game shows it over the big icon while you're above 60% health.",
    "- Because Tactara can't tell when these icons show, they get no glow on your action bars and no defensive sound.",
    "- New: `/tac probe health` checks that the game still allows this. It reports what the game offers and shows two red test squares for 30 seconds; the 0-1 one should show below 90% health and vanish above it.",
  } },
  { version = "0.19.3", lines = {
    "- **Fixed:** a Lua error when you cast a debuff Tactara keeps a timer for (Serpent Sting, Hunter's Mark, Rend and others) while the game hides your target's ID from addons, which it does in some fights. The helper also missed its next step on that cast. Timers now fall back to \"your current target\", and a cast always moves the helper on. Thanks to the player who tracked down the cause.",
    "- The same kind of hidden value is now handled everywhere Tactara reads one: your target's creature type, combo points, buff names, cooldowns and range. When the game hides one, Tactara treats it as \"can't tell\" instead of guessing or erroring.",
    "- **Fixed:** the game sometimes gives an empty realm name, and Tactara then saved your settings under your name alone. In \"Copy settings from\", that made your own character show up as if it were another one. Tactara now remembers each character's full name and realm and keeps using it, and it removes the entry saved without the realm. `/tac probe` also shows your name, the realm the game reports, and the name your settings are saved under.",
    "- `/tac probe` now lists every way the game offers to read your health, and what each one gives. WoW Forever hides your current health from addons even out of combat, so for now Tactara skips suggestions that depend on it (Reckless Swings, defensives at low health) rather than guess. This report shows whether another way works.",
  } },
}
