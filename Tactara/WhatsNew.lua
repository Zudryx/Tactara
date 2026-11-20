-- Copyright (C) 2026 Zudryx. Part of Tactara, licensed under the GNU GPL v3 only.
-- SPDX-License-Identifier: GPL-3.0-only

-- Tactara: the newest changelog sections, for the "what's new" window.
-- Made from CHANGELOG.md by tests/make_whats_new.py: edit the changelog,
-- then run that script. Don't edit this file by hand.

local ADDON, ns = ...

ns.WHATS_NEW = {
  { version = "0.19.4", lines = {
    "- New: `/tac probe health`. WoW Forever hides your current health from addons, so Tactara's defensive suggestions (and Reckless Swings) can't show. Newer versions of the game let an addon show an icon by your health without ever reading it. This test finds out whether Forever allows that: it reports what the game offers and shows two red test squares for 30 seconds that should appear while you're below 90% health. Nothing else changes.",
  } },
  { version = "0.19.3", lines = {
    "- **Fixed:** a Lua error when you cast a debuff Tactara keeps a timer for (Serpent Sting, Hunter's Mark, Rend and others) while the game hides your target's ID from addons, which it does in some fights. The helper also missed its next step on that cast. Timers now fall back to \"your current target\", and a cast always moves the helper on. Thanks to the player who tracked down the cause.",
    "- The same kind of hidden value is now handled everywhere Tactara reads one: your target's creature type, combo points, buff names, cooldowns and range. When the game hides one, Tactara treats it as \"can't tell\" instead of guessing or erroring.",
    "- **Fixed:** the game sometimes gives an empty realm name, and Tactara then saved your settings under your name alone. In \"Copy settings from\", that made your own character show up as if it were another one. Tactara now remembers each character's full name and realm and keeps using it, and it removes the entry saved without the realm. `/tac probe` also shows your name, the realm the game reports, and the name your settings are saved under.",
    "- `/tac probe` now lists every way the game offers to read your health, and what each one gives. WoW Forever hides your current health from addons even out of combat, so for now Tactara skips suggestions that depend on it (Reckless Swings, defensives at low health) rather than guess. This report shows whether another way works.",
  } },
  { version = "0.19.2", lines = {
    "- **Fixed:** if the key bar or the helper popup was set to a size other than 100%, it crept a little across the screen on every login or `/reload`. It now stays where you put it. Thanks to the player who found the cause and sent the fix.",
    "- **Fixed:** `/tac probe` caused a Lua error in dungeon fights, where the game hides your target's name from addons. It now shows the name as HIDDEN, says which dungeon you're in, and finishes the report. Anything Tactara prints to chat shows hidden values as \"(hidden)\" instead of erroring.",
  } },
}
