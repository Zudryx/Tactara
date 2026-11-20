# Changelog

Each `## x.y.z` section becomes the release notes for that version.

## 0.19.4
- **Defensive suggestions work again on WoW Forever.** The game hides your current health from addons, even out of combat, so Shield Wall, Ice Block, Feign Death, self-heals and every other health-based defensive stayed quiet. Tactara now hands each ready defensive to the game with its health line ("show below 20%"), and the game shows or hides its icon in the orange slot by your health. Tactara never reads it. When several are ready, the first in the list sits on top, so you see the one that applies.
- **Reckless Swings (Warrior)** works the same way: when it's ready and ranks above the helper's suggestion, the game shows it over the big icon while you're above 60% health.
- Because Tactara can't tell when these icons show, they get no glow on your action bars and no defensive sound.
- New: `/tac probe health` checks that the game still allows this. It reports what the game offers and shows two red test squares for 30 seconds; the 0-1 one should show below 90% health and vanish above it.

## 0.19.3
- **Fixed:** a Lua error when you cast a debuff Tactara keeps a timer for (Serpent Sting, Hunter's Mark, Rend and others) while the game hides your target's ID from addons, which it does in some fights. The helper also missed its next step on that cast. Timers now fall back to "your current target", and a cast always moves the helper on. Thanks to the player who tracked down the cause.
- The same kind of hidden value is now handled everywhere Tactara reads one: your target's creature type, combo points, buff names, cooldowns and range. When the game hides one, Tactara treats it as "can't tell" instead of guessing or erroring.
- **Fixed:** the game sometimes gives an empty realm name, and Tactara then saved your settings under your name alone. In "Copy settings from", that made your own character show up as if it were another one. Tactara now remembers each character's full name and realm and keeps using it, and it removes the entry saved without the realm. `/tac probe` also shows your name, the realm the game reports, and the name your settings are saved under.
- `/tac probe` now lists every way the game offers to read your health, and what each one gives. WoW Forever hides your current health from addons even out of combat, so for now Tactara skips suggestions that depend on it (Reckless Swings, defensives at low health) rather than guess. This report shows whether another way works.

## 0.19.2
- **Fixed:** if the key bar or the helper popup was set to a size other than 100%, it crept a little across the screen on every login or `/reload`. It now stays where you put it. Thanks to the player who found the cause and sent the fix.
- **Fixed:** `/tac probe` caused a Lua error in dungeon fights, where the game hides your target's name from addons. It now shows the name as HIDDEN, says which dungeon you're in, and finishes the report. Anything Tactara prints to chat shows hidden values as "(hidden)" instead of erroring.

## 0.19.1
Rotation review for mid-November: the WoW Forever hotfixes up to November 13 and the class guides.
- **Assassination Rogue:** Venom is a passive now: Shank sets it off and your poisons hit harder for a few seconds. The rotation stops trying to cast Venom as a finisher, and the helper shows Shank whenever it's ready.
- **Subtlety Rogue:** the helper waits for 5 combo points before showing Death Mark (it's a finisher, and it stores more damage with more points).
- **Survival Hunter:** once you take Lone Wolf, the helper stops asking you to call your pet.
- **Feral Druid (Cat and Bear):** Berserk isn't in WoW Forever, so it's gone from the rotations. Lacerate is a talent you can take at 25 (not a level 42 spell); the notes say so.
- **Fire Mage:** the helper no longer shows Pyroblast all the time. Pyroblast pays off with Heating Up, which the helper can't count, so it now shows Combustion, Fire Blast and Fireball, and the key still mixes in Scorch and Pyroblast.
- **Affliction Warlock:** after the November 10 hotfix, Wrack makes Corruption, Siphon Life and Bane of Agony tick twice as fast while you channel it. From 40 the opener ends with Wrack, right after your DoTs are up.
- **Holy Priest:** in WoW Forever it's Holy Binding, a passive (your Flash Heal on someone else heals you too), not a Binding Heal spell. The self-heal line that tried to cast it is gone.
- **Arms Warrior:** the helper shows Spearing Strike (talent) ahead of Mortal Strike against Giants and Dragonkin, where it does double damage, as Icy Veins recommends. It needs Battle Stance.
- **All Warriors:** the helper shows Reckless Swings (talent) when you have 60% health or more. It costs a quarter of your base health for extra Rage on your next 4 swings, and it comes after your big hitters, so it shows when they're waiting on Rage or on cooldown. The key doesn't cast it, because the key can't check your health.
- **Fury Warrior:** checked against Icy Veins: Whirlwind before Bloodthirst and Execute is still right. No change.
- **Enhancement Shaman talent build:** Icy Veins changed its leveling build on November 13 to save Mana: one point in Maelstrom Weapon at 43, Water Shield at 46 and Elemental Focus at 57 instead of five Maelstrom Weapon points and Rage of the Farseer. Tactara's build follows it. If you follow the old version, Tactara asks before switching. The rotation now keeps Water Shield up once you have it, in place of Lightning Shield. The level 60 build hasn't changed.
- The other talent builds still match Icy Veins.
- **Your own rotations:** `@health above 60` shows a line only when your health is 60% or more (`@health 35` still means below 35%).

## 0.19.0
- **A cleaner look for the helper popup and the key bar.** Every icon has a thin frame. The best spell now, and your key's next press, are framed in Tactara's cyan (the color of its logo and the glow). The interrupt and defensive slots are framed in red and orange, with an outlined caption in the same color under them. PULL is in cyan too.
- **Display look:** Standard (all of the above) or **Minimal**: just the icons, with a thin red or orange edge left on the interrupt and defensive slots so you can tell them apart. Settings page (Displays) or `/tac look minimal`.
- Tactara's windows (rotation editor, talent planner, what's new, key setup) show the logo and the name in cyan in their title. Menus, buttons and the settings page stay the game's own, so they look like the rest of your UI.
- No gameplay changes.

## 0.18.0
- **Your own limits:** on the settings page (Reminders), or with commands:
  - **Buffs running low:** Early (twice as long left), Normal, Late (half) or Only when missing. `/tac buffs low early`
  - **Low on ammo under** this many shots (200 by default). `/tac supplies ammo 300`
  - **Low on Soul Shards under** this many (2 by default). `/tac supplies shards 3`
  - At 0, ammo and shards only count when you're out.
- **Hide while mounted:** the helper popup and the key bar step aside while you're on a mount or a flight path, and come back when you get off or a fight starts. Off until you turn it on: settings page (Displays) or `/tac mounted on`. While the displays are unlocked they stay, so you can still move them.
- **Feral Druid (Cat and Bear):** the rotations used Faerie Fire (Feral), which WoW Forever removed, so the pull and the armor debuff were skipped. In Forever plain Faerie Fire works in Bear and Cat Form (free, 6-second cooldown), and the rotations use that now: to pull, in the opener and to keep the debuff up.
- **Games in other languages:** Feral Charge now finds the right spell (in Forever the talent is the charge itself, in Cat and Bear Form), and a few spell IDs with old names were dropped. On English games nothing changes.

## 0.17.0
- **After the fight:** a couple of seconds after combat ends, Tactara checks the buffs your rotation keeps up, for every class: Blessings, Righteous Fury and your aura, Fortitude and Inner Fire, Mark of the Wild and Thorns, Arcane Intellect and your armor, Demon Armor, aspects, Lightning or Water Shield, Battle Shout (when you have the rage left over), your pet, and a Rogue's poisons or a Shaman's weapon imbue. Anything missing or running low shows under the helper for 30 seconds and in chat (the same line at most every 2 minutes). Seals are left out: they'd run out before the next pull anyway. No target needed.
- **Running low counts too,** before the pull and after the fight: an hour-long Blessing under 5 minutes, a 30-minute buff under 2, a 5 to 10 minute one under 1, Battle Shout under 30 seconds. The line says how long is left, like *Blessing of Might (4 min left)*. Seals still only show when they're missing or about to drop. Auras, aspects and forms never run low.
- **A sound for buff reminders,** off until you pick one: settings page (Reminders) or `/tac sound buffs ready`.
- The setting is now **Buffs before and after a fight** (settings page, Reminders); `/tac buffs on` / `helper` / `off` works like `/tac prepull`.
- **A buff you click off (or that's dispelled, or lost when you die) is noticed now.** In a fight the game hides your buffs, so Tactara times them from your casts, and a timer can't see a buff come off. Once the fight is over, when the game is showing your buffs again, its "not there" wins over the timer: the after-the-fight check and the before-the-pull line list it, and the opener puts it back up.
- When the game hides your buffs, Tactara times them from your casts. Now a buff that replaces another (one Seal for another, one Blessing, aura, aspect, armor or shield for another) ends the old one's timer too, so Tactara doesn't think your old aspect is still up.
- `/tac probe reminders` shows each buff's time left and what the after-the-fight check sees.
- Tactara still only tells you; you cast the buff.

## 0.16.1
- **Paladin auras:** the helper and the before-the-pull line now see the aura you have on, even after a reload or when you turned it on before logging in. Tactara reads it from your aura bar (the stance bar), which the game always shows to addons. The same goes for Warrior stances, Druid forms and Shadowform. `/tac probe reminders` lists what's on your stance bar.
- No gameplay changes.

## 0.16.0
- **What's new:** after Tactara updates, a window shows what changed (including any versions you skipped), once for all your characters. `/tac new` shows it any time. Turn it off on the settings page (Reminders).
- **Set up your keys:** a character with no Tactara key gets a small window, before the talent planner question, with the same key buttons as the settings page: **One-button key**, **AoE key**, **Interrupt key**, and **Remove** to give them all back. Click a button and press any key; right-click one to clear it. **Done** closes it (with no key set, it asks again next time); **No thanks** doesn't ask again. `/tac reset keybinds` (or `/tac keys`) opens it any time and keeps the keys you have. The glow and the helper popup work without a key.
- First-time questions (your key and the talent planner) can be turned off for all your characters on the settings page (Reminders).
- **Share your settings:** `/tac export` (or **Export** on the settings page, Your characters) gives this character's settings as text, to back them up or give them to a friend on any account or computer. `/tac import` takes it back: you're asked first, and keys only come along if you choose **With keys**.
- **Games in other languages:** rotations and talent builds now work on German, French, Spanish and other game clients. Tactara finds each spell's name in your language by its spell ID; its own windows stay in English. `/tac probe locale` checks the IDs against your game. On English games nothing changes.
- **Sound alerts:** pick a sound to play when the red interrupt slot lights up, and one for the orange defensive slot (raid warning, ready check, alarm clock, map ping or whisper). Both are off until you pick one on the settings page (Suggestions) or with `/tac sound interrupt raid`. `/tac sound test` plays them. Like the glow, a sound only tells you; you still press the key.
- **Supplies:** a Hunter's arrows or bullets (under 200), a Warlock's Soul Shards (under 2), and the reagents and totems your spells need: Flash Powder when your rotation uses Vanish, an Ankh for Reincarnation, a Fire Totem for your fire totems, and so on. You see them under the helper popup when you target an enemy, in chat when one runs low or runs out, and at a vendor that sells one. `/tac supplies` shows the list any time; settings page (Reminders) or `/tac supplies on` / `helper` / `off`. Tactara never buys anything.
- No gameplay changes.

## 0.15.0
- **Level 60 talent builds:** every spec now has a level 60 build as well, the main raid and dungeon build from each Icy Veins spec page (Druid has one for Cat and one for Bear), checked against the game's trees. They're under **Level 60** in the planner, below the leveling builds.
- **Switching at 60:** unlearn your talents at your class trainer (it costs gold), then **Use this build** and **Learn all**. The planner says so when your talents don't fit a level 60 build.
- **When you reach 60,** Tactara asks once whether to look at the level 60 build for your spec. Nothing changes unless you pick it.
- The planner's build list is grouped (**Leveling**, **Level 60**, **Yours**) and leaves out your class name. Level 60 builds are listed point by point instead of level by level.
- No gameplay changes.

## 0.14.0
- **Talent builds for every class:** leveling builds for every spec of Paladin, Hunter, Rogue, Priest, Shaman, Mage, Warlock and Druid (one Feral build for Cat and Bear), level 10 to 60, from the Icy Veins leveling guides. Each is checked point by point against the game's talent trees.
- **Warrior builds updated:** Arms, Fury and Protection now follow the Icy Veins leveling guides too. If you follow one, Tactara asks before anything changes: **Switch**, **Later** or **Keep mine**.
- **Talent planner, Hunter:** the trees draw and check correctly. The Hunter data has a second Lightning Reflexes far off to the side, an Improved Serpent Sting far below the tree, and an arrow from Bestial Wrath back up to Intimidation (which would make each need the other). Those are left out.
- **Before the pull:** when you target an enemy and you're not fighting yet, a line under the helper popup lists what your rotation wants up and isn't: a buff it keeps up, your pet, or a poison or weapon imbue (Rogue, Shaman). A chat line says the same at most once a minute. Tactara only tells you; you cast it. Settings page (Reminders) or `/tac prepull on` / `helper` / `off`.
- **Trainer reminder:** when you level up, a chat line lists the spells now waiting at your class trainer, the ones your rotation uses first. `/tac trainer` shows the list any time. New spells only, not new ranks.
- **Dual spec:** each spec keeps its own talent build and rotation choice. Switch specs and Tactara switches with you, and says which build it's following. The talent glow only shows on your active spec's tab.
- **The same settings on all your characters:** copy keys, display positions and sizes, the glow, suggestions, minimap button and talent options from another character (settings page > Your characters, or `/tac copy`). Or make them the default every new character starts with (`/tac defaults`). Rotation and talent builds always stay each character's own. Characters show up in the list after you've played them once with this version.
- **A one-time question on each character:** the first time you play a character with Tactara (a new character, a fresh install, or one that hasn't picked a talent build), Tactara asks once whether to open the talent planner. Below level 10 you can choose **At level 10** instead, and you're asked again when you get your first talent point. Never in combat. Characters already following a build aren't asked. Turn it off for all your characters on the settings page (Talents).
- **Build updates are your choice:** when Tactara updates one of its talent builds that you're following, you keep following the version you picked. Tactara asks once: **Switch**, **Later** or **Keep mine**. It tells you where the build changed and whether the new version fits your talents or would need a respec. **Keep mine** saves your version as your own build, which never changes. The planner shows the same choice.
- **Talent planner, Warlock and Priest:** the trees now draw and check correctly. The game puts a few talents slightly off the grid (Warlock's Improved Life Tap and Amplify Curse), which made Suppression look like it needed 5 points first. A stray second Holy Specialization in the Priest data is now ignored.
- No gameplay changes.

## 0.13.0
- **Talent planner (`/tac talents`):** your three talent trees, read from the game, with a build point by point from level 10 to 60.
- **Tactara's builds:** Arms, Fury and Protection leveling builds for Warrior, from current Forever guides and checked against the game's trees. More classes are coming.
- **Your own builds:** start new, copy one of Tactara's, or **start from your talents** (keep the points you have, no respec needed), then click talents in the order you want them. The planner only lets you add points the game would take. Share builds as text and import other people's.
- **Learn next / Learn all:** learn the next points of the build you're using with one click. **Learn automatically when I level up** is there too, off by default. Never in combat.
- The next talent glows in your talent window, and a chat line reminds you when you have points to spend. Both can be turned off on the settings page (Talents).
- Open the planner with the new **Tactara planner** button at the bottom of the game's talent window, the **Talents** button in `/tac`, or shift-click the minimap button.

## 0.12.1
- **`/tac probe talents`:** a read-only report on how your talents and the talent window look to Tactara, shown in a window you can copy from. It's groundwork for a talent planner and changes nothing.
- No gameplay changes.

## 0.12.0
- **Minimap button:** left-click opens the rotation editor, right-click the settings page. Drag it to move it around the minimap. Works with round and square minimaps.
- Show or hide it on the settings page (Displays) or with `/tac minimap`; `/tac minimap reset` puts it back where it started.
- The minimap's addon menu still has Tactara too, with the same clicks.
- No gameplay changes.

## 0.11.1
- **Tactara is now licensed under the GNU GPL v3** (it was MIT). You can still fork it and share changes, as long as your version stays open source under the same license.
- **The name and logo stay with Tactara:** a changed version you share needs its own name and logo. See NOTICE.md.
- The license and notice now come with every download.
- No gameplay changes.

## 0.11.0
- **See further ahead, or just one icon:** the key bar and the helper popup can each show 1 to 10 icons instead of always 3.
- **Key bar: whole rotation** shows every step your key will cast until the rotation repeats.
- **Helper popup: everything usable now** shows every spell in your rotation you can use right now, best first.
- Extra icons are added on the right, so the first icon stays where you put it.
- On the settings page (Displays), or `/tac icons helper|key 1-10|all` and `/tac icons 3` for both.
- No gameplay changes.

## 0.10.0
- **Between fights, your choice:** the helper popup and the key bar can each show normally, go see-through or hide when you're out of combat with no enemy targeted. They come back the moment you target an enemy or combat starts.
- A slider sets how visible see-through is (10% to 90%).
- Defaults match before: the helper popup goes see-through, the key bar stays as it is.
- On the settings page (Displays), or `/tac fade helper|key show|fade|hide` and `/tac fade 40`.
- While the displays are unlocked, "hide" shows them see-through instead so you can still move them.
- No gameplay changes.

## 0.9.0
- **Helper icons tell you more**, like your action bars do: a clock sweep while a spell is on cooldown, red when your target is out of range, blue when you're short on mana, rage or energy, and grey when it can't be used right now. In boss fights and arenas, where WoW hides this, the icons stay plain.
- Both can be turned off on the settings page (Displays).
- No gameplay changes.

## 0.8.0
- **Tactara has an icon.** It shows next to Tactara in WoW's addon list.
- Tactara is also in the minimap's addon menu: left-click opens the rotation editor, right-click the settings page.
- No gameplay changes.

## 0.7.1
- The key buttons on the settings page now show the key each one is set to (or "Not set"), and update as soon as you set or remove a key, or change it in WoW's Keybindings menu.

## 0.7.0
- **Settings page:** Esc > Options > AddOns > Tactara (or `/tac options`, or the new **Settings** button in the `/tac` window). Rotation choice, keys, both displays, the bar glow and suggestions are all on one page now; the `/tac` commands still work.
- **Display size:** make the helper popup and the key bar anywhere from 50% to 200%. They stay where you put them when you resize.
- **Reset positions** puts both displays back in the middle of the screen if you lose one.
- No gameplay changes.

## 0.6.0
- **Every class is here.** New rotations for Paladin, Hunter, Rogue, Priest, Shaman, Mage, Warlock and Druid, one per spec (Druid gets both Cat and Bear), built from the WoW Forever guides and Forever's new spells: Holy Strike and Seal of Fury, Summon Hawk and Strider Kick, Shank, Mutilate and Venom, Shadow Word: Death and Penance, Lava Burst and Stormstrike, Arcane Blast, Ice Lance and Frostfire Bolt, Bane of Agony and Wrack, Lacerate and Primal Bite.
- Auto-pick works for every class: it reads your talent trees, then your weapon, then picks a default. Druids with Feral points get Cat or Bear from the talents they took.
- Healing specs get the solo damage rotation you level with. Healing your group stays in your hands.
- The helper knows more: Exorcism and Holy Wrath only on Undead and Demons, a reminder when your pet is missing, and finishers when you likely have the combo points.
- Pet abilities like Spell Lock are recognized, and the rotation updates when your pet changes.
- Warrior: a few steps that only had situational spells (Victory Rush, Overpower, Execute) now fall back to Heroic Strike, Slam or Cleave instead of doing nothing.
- `/tac probe` now checks things for your own class.

## 0.5.1
- Added a fair-play note to the guide, the GitHub page and `/tac help`: Tactara is an assistant, and every cast comes from your own key press. The addon list now says "You press every key."
- Removed the old "not tested in game yet" warning from the guide.
- No gameplay changes.

## 0.5.0
- New name: Cadence is now **Tactara**, because another addon already uses the old name. The slash command is now `/tac` (or `/tactara`).
- Your settings come with you. The updater copies your rotation edits, keys and options over to Tactara and moves the old folder out of AddOns. Keys you set in WoW's Keybindings menu move over the first time you log in.
- If you used the old updater: download `TactaraUpdater.zip` from this release once and run it with WoW closed. The old updater can't find the renamed download.
- No gameplay changes.

## 0.4.3
- Tactara now describes itself in its own words: removed references to other addons from the addon, its notes and its guide. No gameplay changes.

## 0.4.2
- Battle Shout, Rend, Thunder Clap, Demoralizing Shout and Sunder Armor now drop off the helper after you cast them. WoW Forever doesn't report these buffs and debuffs to addons, so Tactara times them from your own casts. If the game does report one, Tactara uses that instead.
- The opener skips Battle Shout while it's still up.
- First release on GitHub, with the Windows updater (`TactaraUpdater.zip`).

## 0.4.1
- Much stronger bar glow by default (thicker border, halo, tinted icon). `/tac glow strong / normal / subtle`, plus `/tac glow test` for a 3-second preview.

## 0.4.0
- Helper popup showing the best skill to use right now, separate from the key bar.
- Interrupts (red) and defensives (orange), shown only when needed. `/tac bind interrupt` for an interrupt key.
- Stuns and crowd control in each rotation, off by default.

## 0.3.0
- Reads your talents and weapons to pick the rotation (`/tac build`).
- Priority lists for the helper, with live checks: `@missing`, `@nodebuff`, `@enemies`.

## 0.2.0
- Bar highlight: glow on the next spell on your action bars.

## 0.1.x
- One-button rotations for Warrior (Arms, Fury, Protection), level-aware.
- In-game editor, `/tac bind` key picker, pull (Charge) display, diagnostics.
