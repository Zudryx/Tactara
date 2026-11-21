-- QA sweep: every built-in rotation of one class, every 5 levels from 1 to
-- 60, through many fight situations, in a stand-in WoW that follows WoW
-- Forever's rules as measured with /tac probe (your health, power and the
-- target's health hidden; the target's name, ID, creature type, auras,
-- cooldowns, range and casts hidden in some fights).
--
-- It checks that nothing raises a Lua error, and that what the helper shows
-- makes sense (see INVARIANTS below). Situations are random but repeatable:
-- the same seed gives the same run.
--
-- Usage: python3 tests/runlua.py tests/qa_sweep.lua Tactara WARRIOR [seed] [situations]
-- or all classes: python3 tests/qa_sweep.py

local root, CLASS = arg[1], (arg[2] or "WARRIOR"):upper()
local SEED = tonumber(arg[3] or "1") or 1
local PER_LEVEL = tonumber(arg[4] or "40") or 40
local LEVELS = { 1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60 }

local D = dofile("tests/class_data.lua")

---------------------------------------------------------------------------
-- What went wrong, grouped so one bug isn't reported a thousand times
---------------------------------------------------------------------------
local problems, problemOrder, situations, calls = {}, {}, 0, 0
local current = "loading"
local function problem(kind, msg)
  local key = kind .. ": " .. msg
  local p = problems[key]
  if not p then
    p = { kind = kind, msg = msg, count = 0, first = current }
    problems[key] = p
    problemOrder[#problemOrder + 1] = key
  end
  p.count = p.count + 1
end
local function try(label, fn, ...)
  calls = calls + 1
  local ok, err = pcall(fn, ...)
  if not ok then problem("Lua error in " .. label, tostring(err):gsub("^.-Tactara/", "Tactara/")) end
  return ok, err
end

---------------------------------------------------------------------------
-- Hidden ("secret") values. In the game these can be stored and handed to
-- the game, but comparing them, doing sums with them, joining them into text
-- or putting them in table.concat is a Lua error. A sealed table does the
-- same here (table.concat refuses tables by itself).
---------------------------------------------------------------------------
local S = {}          -- the situation the stand-in game is in (set for every run)

local SECRET_TEXT = "\1hidden\1"
local SECRET_MT = {}
local function refuse(what) return function() error("attempt to " .. what .. " a secret value", 2) end end
SECRET_MT.__lt, SECRET_MT.__le = refuse("compare"), refuse("compare")
SECRET_MT.__add, SECRET_MT.__sub, SECRET_MT.__mul, SECRET_MT.__div = refuse("do sums with"), refuse("do sums with"),
  refuse("do sums with"), refuse("do sums with")
SECRET_MT.__mod, SECRET_MT.__unm, SECRET_MT.__pow = refuse("do sums with"), refuse("do sums with"), refuse("do sums with")
SECRET_MT.__concat, SECRET_MT.__len = refuse("join"), refuse("measure")
SECRET_MT.__index = function() error("attempt to index a secret value", 2) end
SECRET_MT.__tostring = function() return SECRET_TEXT end
local function secret(v) return setmetatable({ value = v }, SECRET_MT) end
function issecretvalue(v)
  if type(v) == "table" then return getmetatable(v) == SECRET_MT end
  return type(v) == "string" and v:find(SECRET_TEXT, 1, true) ~= nil
end

---------------------------------------------------------------------------
-- Stand-in frames (same as the other tests)
---------------------------------------------------------------------------
local chat, timers, frames, wrapSnippets = {}, {}, {}, {}
local METHOD_PREFIXES = { "Set", "Get", "Is", "Create", "Register", "Enable", "Show", "Hide", "Clear",
  "Highlight", "Start", "Stop", "Play", "Add", "Hook", "Unregister", "Click", "Disable", "Toggle", "Raise", "Lower", "Has", "Insert" }
local function isMethod(k)
  if type(k) ~= "string" then return false end
  for _, p in ipairs(METHOD_PREFIXES) do if k:sub(1, #p) == p then return true end end
  return false
end
local newObj
newObj = function(kind, name)
  local o = { _kind = kind, _name = name, _attrs = {}, _scripts = {}, _hooks = {}, _shown = true, _text = "" }
  local impl = {
    SetAttribute = function(self, k, v) self._attrs[k] = v end,
    GetAttribute = function(self, k) return self._attrs[k] end,
    SetScript = function(self, s, f) self._scripts[s] = f end,
    GetScript = function(self, s) return self._scripts[s] end,
    HookScript = function(self, s, f) self._hooks[s] = self._hooks[s] or {}; table.insert(self._hooks[s], f) end,
    SetText = function(self, t)
      if issecretvalue(t) then self._text = SECRET_TEXT return end
      self._text = t
    end,
    GetText = function(self) return self._text end,
    SetChecked = function(self, v) self._checked = v and true or false end,
    GetChecked = function(self) return self._checked end,
    GetName = function(self) return self._name end,
    Show = function(self) local was = self._shown; self._shown = true; if not was and self._scripts.OnShow then self._scripts.OnShow(self) end end,
    Hide = function(self) self._shown = false end,
    IsShown = function(self) return self._shown end,
    IsVisible = function(self) return self._shown end,
    GetPoint = function() return "CENTER", nil, "CENTER", 10, -20 end,
    GetWidth = function() return 100 end, GetHeight = function() return 100 end,
    GetVerticalScroll = function() return 0 end, GetVerticalScrollRange = function() return 0 end,
    CreateTexture = function() return newObj("Texture") end,
    CreateFontString = function() return newObj("FontString") end,
    CreateAnimationGroup = function() return newObj("AnimationGroup") end,
    CreateAnimation = function() return newObj("Animation") end,
    SetTexture = function(self, t) self._texture = t end,
    GetFrameLevel = function(self) return self._level or 5 end,
    SetFrameLevel = function(self, l) self._level = l end,
    -- widgets take hidden values from the game (that's how health icons work)
    SetAlpha = function(self, a) self._alpha = a end,
    GetAlpha = function(self) return self._alpha or 1 end,
    GetScale = function(self) return self._scale or 1 end,
    SetScale = function(self, s) self._scale = s end,
    GetLeft = function() return 100 end, GetBottom = function() return 100 end,
    GetEffectiveScale = function() return 1 end,
  }
  return setmetatable(o, { __index = function(t, k)
    if impl[k] then return impl[k] end
    if isMethod(k) then return function() end end
    return nil
  end })
end
function CreateFrame(kind, name, parent, template)
  local f = newObj(kind, name)
  f._template, f._parent = template, parent
  if name then _G[name] = f; frames[name] = f end
  return f
end
UIParent = newObj("Frame", "UIParent")
WorldFrame = newObj("Frame", "WorldFrame")
UIErrorsFrame = newObj("Frame", "UIErrorsFrame")
PlayerFrame = newObj("Frame", "PlayerFrame")
Minimap = newObj("Frame", "Minimap")
GameTooltip = newObj("GameTooltip", "GameTooltip")
DEFAULT_CHAT_FRAME = { AddMessage = function(_, m) chat[#chat + 1] = m; if #chat > 400 then chat = {} end end }
C_Timer = { After = function(_, f) timers[#timers + 1] = f end,
  NewTicker = function(_, f) return { Cancel = function() end } end }
local function runTimers()
  local n = 0
  while #timers > 0 and n < 200 do n = n + 1; try("timer", table.remove(timers, 1)) end
end
SlashCmdList, UISpecialFrames, ChatFontNormal = {}, {}, {}
SOUNDKIT = { RAID_WARNING = 8959, READY_CHECK = 8960 }
function SecureHandlerWrapScript(frame, script, header, pre) wrapSnippets[frame] = pre end
function tContains(t, v) for _, x in ipairs(t) do if x == v then return true end end return false end
function wipe(t) for k in pairs(t) do t[k] = nil end return t end
function PlaySound() return true end
function IsDualWielding() return CLASS == "ROGUE" or (CLASS == "WARRIOR" and S.form == 3) end
function GetInstanceInfo() return S.instance and "Hall of Thanes" or "Elwynn Forest", S.instance and "party" or "none" end
function SetBinding() return true end
function GetMerchantItemID() return nil end
C_Container = {
  GetContainerNumSlots = function(bag) return bag == 0 and 16 or 0 end,
  GetContainerItemID = function() return nil end,
  GetContainerItemInfo = function() return nil end,
}
function GetCVarBool() return true end
function GetBuildInfo() return "1.60.1", "70938", "Nov 2026", 16001 end
function GetLocale() return "enUS" end
function GetCursorPosition() return 0, 0 end
function GetMinimapShape() return "ROUND" end
function GetCurrentBindingSet() return 1 end
function GetBindingKey() return nil end
function SetOverrideBindingClick() end
function ClearOverrideBindings() end
function IsShiftKeyDown() return false end
function IsControlKeyDown() return false end
function IsAltKeyDown() return false end
function StaticPopup_Show() end
function ScrollingEdit_OnUpdate() end
function CreateSettingsButtonInitializer() return newObj("Initializer") end
function CreateSettingsListSectionHeaderInitializer() return newObj("Initializer") end
Settings = setmetatable({}, { __index = function() return function() return newObj("Setting") end end })
C_AddOns = { IsAddOnLoaded = function() return false end }
C_SpecializationInfo = { GetActiveSpecGroup = function() return 1 end, GetNumSpecGroups = function() return 1 end }
function GetUnspentTalentPoints() return 0 end
function UnitCharacterPoints() return 0 end
function GetRealmName() return "" end                 -- Forever gives an empty realm sometimes
function GetInventoryItemID() return nil end
function GetMacroSpell() return nil end
function GetActionInfo() return nil end
function GetMacroIndexByName() return 0 end
function CreateMacro() return 1 end
function EditMacro() return 1 end
function GetMacroInfo() return nil end
Enum = { SpellBookItemType = { Spell = 1, FutureSpell = 2 }, LuaCurveType = { Linear = 0, Step = 1, Cubic = 2, Cosine = 3 } }
CurveConstants = { Reverse = 1, ReverseTo100 = 2, ScaleTo100 = 3, ZeroToOne = 4 }

---------------------------------------------------------------------------
-- The situation the stand-in game is in (changed for every run)
---------------------------------------------------------------------------
local known = {}
local now = 1000
function GetTime() return now end

function UnitClass(u) return CLASS:sub(1, 1) .. CLASS:sub(2):lower(), CLASS, 1 end
function UnitLevel() return S.level or 1 end
function UnitName(u)
  if u == "player" then return "Qa" end
  if u == "target" and S.target then
    if S.nameHidden then return secret("Defias Smuggler") end
    return "Defias Smuggler"
  end
  return nil
end
function UnitGUID(u)
  if u == "target" and S.target then
    if S.guidHidden then return secret("Creature-0-1") end
    return "Creature-0-" .. (S.targetId or 1)
  end
  if u == "player" then return "Player-1" end
end
function UnitExists(u)
  if u == "player" then return true end
  if u == "target" then return S.target and true or false end
  if u == "pet" then return S.pet and true or false end
  local n = u and tonumber(u:match("^nameplate(%d+)$"))
  return n ~= nil and n <= (S.enemies or 0)
end
function UnitCanAttack(a, b) return true end
function UnitIsDead(u) return false end
function UnitIsDeadOrGhost(u) return false end
function UnitIsUnit(a, b) return a == b end
function UnitOnTaxi() return false end
function IsMounted() return S.mounted and true or false end
function InCombatLockdown() return S.combat and true or false end
function UnitAffectingCombat(u) return S.combat and true or false end
function UnitCreatureType(u)
  if u ~= "target" or not S.target then return nil end
  if S.creatureHidden then return secret(S.creature) end
  return S.creature
end
C_CreatureInfo = { GetCreatureTypeInfo = function(id) return { name = ({ "Beast", "Dragonkin", "Demon", "Elemental",
  "Giant", "Undead", "Humanoid", "Critter", "Mechanical" })[id] } end }
-- health: yours is always hidden on Forever (max isn't); the target's too
function UnitHealth(u)
  if u == "player" and not S.hpHidden then return math.floor(S.hp * 10) end
  return secret(500)
end
function UnitHealthMax(u)
  if u == "player" then return 1000 end
  return secret(1000)
end
function UnitHealthMissing(u) return secret(0) end
function GetUnitHealthModifier() return 1 end
function UnitHealthPercent(u, predicted, curve)
  if u == "player" and curve and S.curves then
    -- the game runs the curve on your health; the result stays hidden
    local ok, v = pcall(function() return curve:Evaluate(S.hp / 100) end)
    return secret(ok and v or 0)
  end
  return secret(S.hp / 100)
end
function UnitPower(u, kind)
  if kind == 4 then
    if S.comboHidden then return secret(S.combo) end
    return S.combo
  end
  return secret(50)                                  -- your power: hidden on Forever
end
function UnitPowerMax() return 100 end
function GetComboPoints()
  if S.comboHidden then return secret(S.combo) end
  return S.combo
end
function UnitCastingInfo(u)
  if u ~= "target" or not S.target or not S.casting then return nil end
  if S.casting == "hidden" then return secret("Fireball"), nil, nil, nil, nil, nil, nil, secret(false) end
  return "Fireball", nil, nil, nil, nil, nil, nil, S.casting == "uninterruptible"
end
function UnitChannelInfo() return nil end
-- shapeshift / stance bar
local FORMS = {
  WARRIOR = { "Battle Stance", "Defensive Stance", "Berserker Stance" },
  PALADIN = { "Devotion Aura", "Retribution Aura", "Concentration Aura" },
  DRUID = { "Bear Form", "Aquatic Form", "Cat Form", "Travel Form", "Moonkin Form" },
  ROGUE = { "Stealth" }, PRIEST = { "Shadowform" },
}
function GetNumShapeshiftForms()
  local n = 0
  for _, f in ipairs(FORMS[CLASS] or {}) do if known[f] then n = n + 1 end end
  return n
end
function GetShapeshiftFormInfo(i)
  local list = {}
  for _, f in ipairs(FORMS[CLASS] or {}) do if known[f] then list[#list + 1] = f end end
  local name = list[i]
  if not name then return nil end
  local active = (i == (S.form or 1))
  if S.stanceHidden then active = secret(active) end
  return "icon:" .. name, active, true, ns_SpellID and ns_SpellID(name) or 1
end
function GetShapeshiftForm() return S.form or 0 end
function GetWeaponEnchantInfo()
  if S.auras == "present" then return true, 1800000, 1, 1, false end
  return false
end
C_Item = {
  GetItemCount = function() return S.supplies or 0 end,
  GetItemInfoInstant = function(id) return id, "Projectile", "Arrow", "INVTYPE_AMMO", 132382, 6, 2 end,
  GetItemNameByID = function(id) return "Item " .. tostring(id) end,
}
C_MerchantFrame = { GetItemInfo = function() return nil end }
C_Secrets = {
  ShouldSpellAuraBeSecret = function() return S.auras == "hidden" end,
  ShouldUnitHealthMaxBeSecret = function() return false end,
  ShouldUnitPowerBeSecret = function() return true end,
}

-- spells: known from class_data; IDs from the addon's own table
local NAME_BY_ID, ID_BY_NAME = {}, {}
local function SpellName(x)
  if type(x) == "number" then return NAME_BY_ID[x] end
  return x
end
C_SpellBook = {
  FindSpellBookSlotForSpell = function(x) if known[SpellName(x)] then return 1, 0 end return nil end,
  GetSpellBookItemInfo = function() return { itemType = 1 } end,
  IsSpellKnown = function(x) return known[SpellName(x)] == true end,
  GetNumSpellBookSkillLines = function() return 0 end,
  GetSpellBookSkillLineInfo = function() return nil end,
  GetSpellBookItemLevelLearned = function() return 1 end,
}
function IsSpellKnown(x) return known[SpellName(x)] == true end
function IsPlayerSpell(x) return known[SpellName(x)] == true end
function GetSpellInfo(x)
  local n = SpellName(x)
  if not n then return nil end
  return n, nil, "icon:" .. n, 0, 0, 0, ID_BY_NAME[n] or 0
end
local CD = {}        -- spell -> "ready" / "cooldown" / "hidden"
local US = {}        -- spell -> "yes" / "power" / "no" / "hidden"
C_Spell = {
  GetSpellName = function(x) return SpellName(x) end,
  GetSpellTexture = function(x) local n = SpellName(x); return n and ("icon:" .. n) or nil end,
  GetSpellInfo = function(x)
    local n = SpellName(x)
    if not n then return nil end
    return { name = n, iconID = 1, spellID = ID_BY_NAME[n] or 0, castTime = 0 }
  end,
  GetSpellLevelLearned = function() return 1 end,
  GetSpellPowerCost = function() return {} end,
  GetSpellCooldown = function(x)
    local st = CD[SpellName(x)] or "ready"
    if st == "hidden" then
      return { startTime = secret(0), duration = secret(0), isEnabled = true, isActive = secret(false), isOnGCD = secret(false), modRate = 1 }
    elseif st == "cooldown" then
      return { startTime = now - 1, duration = 30, isEnabled = true, isActive = true, isOnGCD = false, modRate = 1 }
    end
    return { startTime = 0, duration = 0, isEnabled = true, isActive = false, isOnGCD = false, modRate = 1 }
  end,
  IsSpellUsable = function(x)
    local u = US[SpellName(x)] or "yes"
    if u == "hidden" then return secret(true), secret(false) end
    if u == "power" then return false, true end
    if u == "no" then return false, false end
    return true, false
  end,
  IsSpellInRange = function()
    if S.rangeHidden then return secret(true) end
    return S.inRange
  end,
}
-- auras: by situation, present / missing / hidden
local function Aura(unit, name)
  if S.auras == "hidden" and S.combat then return secret({ name = name }) end
  if S.auras == "present" then
    return { name = name, expirationTime = now + 600, duration = 1800, applications = 1, sourceUnit = "player",
      auraInstanceID = 1, spellId = ID_BY_NAME[name] or 0 }
  end
  return nil
end
C_UnitAuras = {
  GetAuraDataBySpellName = function(unit, name) return Aura(unit, name) end,
  GetAuraDataByIndex = function(unit, i)
    if S.auras == "hidden" and S.combat then return secret({}) end
    return nil
  end,
  GetPlayerAuraBySpellID = function() return nil end,
}
-- the game's curves (Forever has these; /tac probe health in 0.19.4)
local function Curve()
  local c = { points = {} }
  function c:SetType(t) self.kind = t end
  function c:AddPoint(x, y) self.points[#self.points + 1] = { x, y } end
  function c:Evaluate(x)
    local v = self.points[1] and self.points[1][2] or 0
    for _, p in ipairs(self.points) do if x >= p[1] then v = p[2] end end
    return v
  end
  return c
end
local CURVE_UTIL = { CreateCurve = Curve, CreateColorCurve = Curve }
C_CurveUtil = CURVE_UTIL

-- talents: Tactara's planner reads the tree; a tree with nothing in it here
C_ClassTalents = { GetActiveConfigID = function() return nil end, CanChangeTalents = function() return false end,
  CommitConfig = function() return false end }
C_Traits = setmetatable({}, { __index = function() return function() return nil end end })

-- action bars: one button per known spell, so the glow has somewhere to go
local slotSpell = {}
function GetActionInfo(slot) local n = slotSpell[slot]; if n then return "spell", ID_BY_NAME[n] end end
for i = 1, 12 do local b = CreateFrame("CheckButton", "ActionButton" .. i); b.action = i end
for i = 1, 12 do local b = CreateFrame("CheckButton", "MultiBarBottomLeftButton" .. i); b.action = 60 + i end

-- every game function Tactara looks for that the stand-in doesn't have
local missing = {}
setmetatable(_G, { __index = function(_, k)
  if type(k) == "string" and k:match("^[A-Z]") then missing[k] = (missing[k] or 0) + 1 end
  return nil
end })

---------------------------------------------------------------------------
-- Load the addon
---------------------------------------------------------------------------
local ns = {}
_G.__TactaraNS = ns
local toc = io.open(root .. "/Tactara.toc"):read("a")
for line in toc:gmatch("[^\r\n]+") do
  if not line:find("^##") and line:find("%.lua$") then
    local fn = assert(loadfile(root .. "/" .. line:gsub("\\", "/")))
    try("loading " .. line, fn, "Tactara", ns)
  end
end
for name, id in pairs((ns.SPELL_IDS or {})[CLASS] or {}) do
  ID_BY_NAME[name] = id
  NAME_BY_ID[id] = NAME_BY_ID[id] or name
end
for name, id in pairs((ns.TALENT_IDS or {})[CLASS] or {}) do
  if type(id) == "number" then ID_BY_NAME[name] = ID_BY_NAME[name] or id; NAME_BY_ID[id] = NAME_BY_ID[id] or name end
end
-- spells the IDs table doesn't have get made-up IDs, so casts can still be fired
local nextId = 9000000
local function IdOf(name)
  if not ID_BY_NAME[name] then
    nextId = nextId + 1
    ID_BY_NAME[name], NAME_BY_ID[nextId] = nextId, name
  end
  return ID_BY_NAME[name]
end
ns_SpellID = IdOf

local function fire(event, ...)
  local f = ns.eventFrame
  if f and f._scripts.OnEvent then try("event " .. event, f._scripts.OnEvent, f, event, ...) end
  runTimers()
end
local function fireAll(event, ...)
  -- every frame that listens for events (helper, tracker, reminders...)
  for _, f in pairs(frames) do
    if f._scripts and f._scripts.OnEvent and f ~= ns.eventFrame then
      try("event " .. event .. " on " .. tostring(f:GetName()), f._scripts.OnEvent, f, event, ...)
    end
  end
  for _, f in ipairs({ ns.helperFrame, ns.trackerFrame }) do
    if f and not f._name and f._scripts.OnEvent then try("event " .. event, f._scripts.OnEvent, f, event, ...) end
  end
  fire(event, ...)
end

TactaraDB, TactaraCharDB = nil, nil
fire("ADDON_LOADED", "Tactara")
fire("PLAYER_LOGIN")
fire("PLAYER_ENTERING_WORLD")
now = now + 20; runTimers()
if not ns.helperPopup and ns.CreateHelperPopup then try("CreateHelperPopup", ns.CreateHelperPopup) end

-- The game refuses a hidden value as a table key. Tactara's timer table keys
-- by the target's ID (the 0.19.2 Hunter bug), so it refuses them here too.
do
  local function upvalue(fn, want)
    for i = 1, 80 do
      local n, v = debug.getupvalue(fn, i)
      if n == nil then return nil end
      if n == want then return v end
    end
  end
  local tracked = ns.TrackCast and upvalue(ns.TrackCast, "tracked")
  if tracked and tracked.target then
    local function refuseKey(_, k)
      if issecretvalue(k) then error("attempted to index a table that cannot be indexed with secret keys", 2) end
    end
    setmetatable(tracked.target, { __index = refuseKey,
      __newindex = function(t, k, v) refuseKey(t, k); rawset(t, k, v) end })
  else
    problem("sweep setup", "couldn't reach Tactara's timer table")
  end
end

---------------------------------------------------------------------------
-- The class's built-in rotations and what each knows at a level
---------------------------------------------------------------------------
local rotations = {}
for _, name in ipairs(ns.builtinOrder or {}) do
  local rot = ns.Parse(ns.builtin[name])
  if rot.meta.class == CLASS then rotations[#rotations + 1] = name end
end
assert(#rotations > 0, "no rotations for " .. CLASS)

local function SetKnown(level, spec)
  for k in pairs(known) do known[k] = nil end
  for _, e in ipairs(D.BY_LEVEL[CLASS] or {}) do if e[1] <= level then known[e[2]] = true end end
  for _, e in ipairs(D.TALENTS[spec] or {}) do if e[1] <= level then known[e[2]] = true end end
  -- a bar button for each, in a stable order
  local names = {}
  for n in pairs(known) do names[#names + 1] = n; IdOf(n) end
  table.sort(names)
  for k in pairs(slotSpell) do slotSpell[k] = nil end
  for i, n in ipairs(names) do slotSpell[i] = n end
end

---------------------------------------------------------------------------
-- INVARIANTS: what the helper shows has to make sense
---------------------------------------------------------------------------
local function Shown(holder)
  if not holder or not holder:IsShown() then return nil end
  local tex = holder.tex and holder.tex._texture
  return type(tex) == "string" and tex:match("^icon:(.+)$") or tex
end

local seen = { glow = 0, icons = 0, interrupt = 0, defensive = 0, healthDefensive = 0, overBigIcon = 0,
  keyCasts = 0, castsFired = 0, hiddenAuras = 0, hiddenTargetId = 0 }
local function Check()
  local f = ns.helperPopup
  if ns.lastHighlight then seen.glow = seen.glow + 1 end
  if f and f.icons and f.icons[1] and f.icons[1]:IsShown() then seen.icons = seen.icons + 1 end
  if f and Shown(f.interrupt) then seen.interrupt = seen.interrupt + 1 end
  if f and Shown(f.defensive) then seen.defensive = seen.defensive + 1 end
  if f and f.defLayers and f.defLayers[1] and f.defLayers[1]:IsShown() then seen.healthDefensive = seen.healthDefensive + 1 end
  if f and f.nowLayers and f.nowLayers[1] and f.nowLayers[1]:IsShown() then seen.overBigIcon = seen.overBigIcon + 1 end
  if S.auras == "hidden" and S.combat then seen.hiddenAuras = seen.hiddenAuras + 1 end
  if S.guidHidden and S.target then seen.hiddenTargetId = seen.hiddenTargetId + 1 end
  local util = ns.lastUtility or {}
  local comp = ns.HelperComp and ns.HelperComp()
  local inRotation = {}
  if comp then
    for _, n in ipairs(comp.spells or {}) do inRotation[n] = true end
    for _, list in ipairs({ comp.priority or {}, comp.interrupts or {}, comp.defensives or {} }) do
      for _, e in ipairs(list) do inRotation[e.spell] = true end
    end
    if comp.pull then inRotation[comp.pull] = true end
  end
  local function okSpell(where, n)
    if not n then return end
    if not known[n] then problem("shows a spell you don't have", ("%s: %s"):format(where, n)) end
  end
  -- 1) the main glow and every icon: spells you have
  okSpell("bar glow", ns.lastHighlight)
  if f then
    for i, h in ipairs(f.icons or {}) do okSpell("helper icon " .. i, Shown(h)) end
    okSpell("interrupt slot", Shown(f.interrupt))
    okSpell("defensive slot", Shown(f.defensive))
    for i, h in ipairs(f.defLayers or {}) do okSpell("defensive layer " .. i, Shown(h)) end
    for i, h in ipairs(f.nowLayers or {}) do okSpell("over-the-big-icon layer " .. i, Shown(h)) end
  end
  -- 2) defensives and interrupts only when they apply
  if util.defensive and not S.combat then problem("defensive out of combat", util.defensive) end
  if util.defensive and not S.hpHidden and S.hp >= 100 then
    problem("defensive at full health", util.defensive)
  end
  if util.interrupt then
    if not S.target or not S.casting then problem("interrupt with nothing being cast", util.interrupt) end
    if S.casting == "uninterruptible" then problem("interrupt on a cast that can't be interrupted", util.interrupt) end
  end
  -- 3) icons the game shows by your health: only when it hides your health
  local gatedDef = util.defensiveGated or {}
  if #gatedDef > 0 then
    if not S.hpHidden then problem("health handed to the game while Tactara can read it", gatedDef[1].spell) end
    if not S.curves then problem("health handed to the game without curves", gatedDef[1].spell) end
    if not S.combat then problem("health-based defensive out of combat", gatedDef[1].spell) end
  end
  if f then
    for i, h in ipairs(f.defLayers or {}) do
      if h:IsShown() then
        if not issecretvalue(h._alpha) then
          problem("health layer alpha not from the game", tostring(Shown(h)) .. " alpha " .. tostring(h._alpha))
        end
        if i > 1 and f.defLayers[i - 1]:IsShown() and f.defLayers[i - 1]:GetFrameLevel() <= h:GetFrameLevel() then
          problem("health layers stacked the wrong way", tostring(Shown(h)))
        end
      end
    end
    for _, h in ipairs(f.nowLayers or {}) do
      if h:IsShown() and not issecretvalue(h._alpha) then
        problem("over-the-big-icon alpha not from the game", tostring(Shown(h)))
      end
    end
    -- 4) mounted with "hide while mounted" (locked displays, out of combat): nothing on screen
    if S.mounted and TactaraCharDB.hideMounted and TactaraCharDB.locked and not S.combat and f:IsShown() then
      problem("helper shown while mounted", "hideMounted is on")
    end
  end
  -- 5) the glow is on a spell from this rotation
  if ns.lastHighlight and comp and not inRotation[ns.lastHighlight] then
    problem("glow on a spell that isn't in the rotation", ns.lastHighlight)
  end
end

-- the key: press it the way the game would and check what it would cast
local function PressKey()
  local btn = frames.TactaraMainButton
  if not btn then return end
  for _, h in ipairs(btn._hooks.PreClick or {}) do try("key PreClick", h, btn, "LeftButton", true) end
  local pre = wrapSnippets[btn]
  if pre then
    local fn = load("local self, button, down = ...\n" .. pre)
    if fn then try("key snippet", fn, btn, "LeftButton", true) end
  end
  local text = btn._attrs.macrotext
  if type(text) == "string" and text ~= "" then seen.keyCasts = seen.keyCasts + 1 end
  if type(text) == "string" then
    for line in text:gmatch("[^\n]+") do
      local cmd, rest = line:match("^/(%a+)%s*(.*)$")
      if cmd == "cast" or cmd == "castsequence" then
        for part in rest:gmatch("[^;]+") do
          part = part:gsub("%b[]", ""):gsub("^%s*reset=%S+%s*", "")
          for spell in part:gmatch("[^,]+") do
            spell = spell:gsub("^%s*!?", ""):gsub("%s*$", ""):gsub("%(Rank %d+%)", "")
            if spell ~= "" and not known[spell] then problem("the key casts a spell you don't have", spell) end
          end
        end
      end
    end
  end
  for _, h in ipairs(btn._hooks.OnClick or {}) do try("key OnClick", h, btn, "LeftButton", true) end
end

---------------------------------------------------------------------------
-- Situations
---------------------------------------------------------------------------
local function pick(list) return list[math.random(#list)] end
local CREATURES = { "Humanoid", "Beast", "Undead", "Demon", "Giant", "Dragonkin", "Elemental", "Mechanical", nil }
local function RandomSituation(level)
  S = {
    level = level,
    combat = math.random() < 0.7,
    target = math.random() < 0.85,
    targetId = math.random(3),
    nameHidden = math.random() < 0.3, guidHidden = math.random() < 0.3,
    creature = CREATURES[math.random(#CREATURES)], creatureHidden = math.random() < 0.2,
    hp = pick({ 100, 95, 70, 55, 45, 30, 22, 15, 8 }),
    hpHidden = math.random() < 0.8,            -- Forever: always; also test if a patch shows it
    curves = math.random() < 0.85,
    enemies = pick({ 0, 1, 2, 3, 5, 8 }),
    casting = pick({ false, false, false, "interruptible", "uninterruptible", "hidden" }),
    auras = pick({ "present", "missing", "hidden" }),
    combo = math.random(0, 5), comboHidden = math.random() < 0.2,
    pet = math.random() < 0.6,
    mounted = math.random() < 0.1,
    stanceHidden = math.random() < 0.3,
    rangeHidden = math.random() < 0.3, inRange = math.random() < 0.8,
    form = math.random(0, 3),
    supplies = pick({ 0, 1, 5, 200 }),
    instance = math.random() < 0.3,
  }
  if not S.target then S.casting = false end
  C_CurveUtil = S.curves and CURVE_UTIL or nil        -- a game without curves has no C_CurveUtil
  for k in pairs(CD) do CD[k] = nil end
  for k in pairs(US) do US[k] = nil end
  local cdMode = pick({ "ready", "some", "all", "hidden" })
  local usMode = pick({ "yes", "some", "power", "hidden" })
  for n in pairs(known) do
    if cdMode == "all" or (cdMode == "some" and math.random() < 0.4) then CD[n] = "cooldown"
    elseif cdMode == "hidden" and math.random() < 0.5 then CD[n] = "hidden" end
    if usMode == "power" and math.random() < 0.6 then US[n] = "power"
    elseif usMode == "some" and math.random() < 0.3 then US[n] = pick({ "no", "power" })
    elseif usMode == "hidden" and math.random() < 0.5 then US[n] = "hidden" end
  end
  TactaraCharDB.helperMode = pick({ "auto", "auto", "priority", "sequence" })
  TactaraCharDB.hideMounted = math.random() < 0.5
  TactaraCharDB.locked = math.random() < 0.7
  TactaraCharDB.defensiveSound = pick({ "off", "alarm" })
  TactaraCharDB.interruptSound = pick({ "off", "raid" })
  TactaraCharDB.helperIcons = pick({ 1, 3, 5, 10 })
  TactaraCharDB.displayStyle = pick({ "standard", "minimal" })
end

local function Describe(rot, level, i)
  return ("%s L%d #%d: %s, %s, health %d%%%s%s, %d enemies, cast %s, auras %s, mode %s"):format(rot, level, i,
    S.combat and "in combat" or "out of combat", S.target and "target" or "no target", S.hp,
    S.hpHidden and " hidden" or "", S.curves and "" or " (no curves)", S.enemies, tostring(S.casting), S.auras,
    TactaraCharDB.helperMode)
end

---------------------------------------------------------------------------
-- Run
---------------------------------------------------------------------------
math.randomseed(SEED)
local helperEvents = ns.helperFrame
for _, rotName in ipairs(rotations) do
  local spec = D.SPEC_OF[rotName]
  for _, level in ipairs(LEVELS) do
    current = ("%s L%d (setup)"):format(rotName, level)
    S = { level = level, combat = false }
    SetKnown(level, spec)
    try("/tac use", SlashCmdList.TACTARA, "use " .. rotName)
    fire("SPELLS_CHANGED"); fire("PLAYER_LEVEL_UP", level)
    now = now + 1; runTimers()
    -- every spell in the rotation cast once, the target's ID readable and hidden
    local comp = ns.HelperComp and ns.HelperComp()
    for _, n in ipairs(comp and comp.spells or {}) do
      S.target, S.guidHidden = true, (math.random() < 0.5)
      try("cast " .. n, ns.OnPlayerCast, IdOf(n))
      if helperEvents and helperEvents._scripts.OnEvent then
        try("UNIT_SPELLCAST_SUCCEEDED " .. n, helperEvents._scripts.OnEvent, helperEvents,
          "UNIT_SPELLCAST_SUCCEEDED", "player", "cast-1", IdOf(n))
      end
    end
    for i = 1, PER_LEVEL do
      RandomSituation(level)
      situations = situations + 1
      current = Describe(rotName, level, i)
      now = now + 0.25 + math.random() * 3
      if math.random() < 0.15 then fireAll(S.combat and "PLAYER_REGEN_DISABLED" or "PLAYER_REGEN_ENABLED") end
      if math.random() < 0.15 then fireAll("PLAYER_TARGET_CHANGED") end
      try("helper refresh", ns.HelperRefresh)
      if ns.UpdateHelperPopup then try("helper popup", ns.UpdateHelperPopup) end
      if ns.UpdateDisplay then try("key bar", ns.UpdateDisplay) end
      Check()
      -- the player casts what's suggested, then the helper looks again
      if ns.lastHighlight then
        seen.castsFired = seen.castsFired + 1
        try("cast " .. ns.lastHighlight, ns.OnPlayerCast, IdOf(ns.lastHighlight))
        try("helper refresh after a cast", ns.HelperRefresh)
        if ns.UpdateHelperPopup then try("helper popup after a cast", ns.UpdateHelperPopup) end
        Check()
      end
      if math.random() < 0.3 then PressKey() end
      -- reminders, now and then
      if ns.Reminders and math.random() < 0.1 then
        local R = ns.Reminders
        if R.PrePullText then try("buff reminder text", R.PrePullText) end
        if R.AfterFight then try("after-fight check", R.AfterFight) end
        if R.SupplyList then try("supplies", R.SupplyList) end
      end
    end
    -- the diagnostics, once per level, in and out of combat
    S.combat, S.target = (level % 10 == 0), true
    try("/tac probe", SlashCmdList.TACTARA, "probe")
    if level == 60 then
      try("/tac probe health", SlashCmdList.TACTARA, "probe health")
      try("/tac probe reminders", SlashCmdList.TACTARA, "probe reminders")
      try("/tac test", SlashCmdList.TACTARA, "test")
    end
    S.combat = false
  end
end

---------------------------------------------------------------------------
-- Report
---------------------------------------------------------------------------
print(("%s: %d rotations x %d levels, %d situations, %d calls"):format(CLASS, #rotations, #LEVELS, situations, calls))
print("  rotations: " .. table.concat(rotations, ", "))
print(("  seen: glow %d, helper icon %d, interrupt %d, defensive %d, defensive by hidden health %d, over the big icon %d,"
  .. " key casts %d, casts %d; hidden auras %d, hidden target ID %d"):format(seen.glow, seen.icons, seen.interrupt,
  seen.defensive, seen.healthDefensive, seen.overBigIcon, seen.keyCasts, seen.castsFired, seen.hiddenAuras, seen.hiddenTargetId))
local missingNames = {}
-- action bar addons' buttons (Bartender, Dominos, ElvUI...) are looked for and
-- correctly found missing; only report game functions
local BARS = { "^BT4Button", "^Dominos", "^ElvUI_", "^MultiBar", "^BonusActionButton", "^ActionButton%d+HotKey",
  "^Tactara", "^__" }
for k in pairs(missing) do
  local bar = false
  for _, pat in ipairs(BARS) do if k:match(pat) then bar = true end end
  if not bar then missingNames[#missingNames + 1] = k end
end
table.sort(missingNames)
if #missingNames > 0 then print("  game functions not in the stand-in: " .. table.concat(missingNames, " ")) end
if #problemOrder == 0 then
  print("QA SWEEP PASSED: " .. CLASS)
else
  for _, key in ipairs(problemOrder) do
    local p = problems[key]
    print(("  PROBLEM (%dx) %s\n      first seen: %s"):format(p.count, key, p.first))
  end
  print(("QA SWEEP: %d problem(s) for %s"):format(#problemOrder, CLASS))
  os.exit(1)
end
