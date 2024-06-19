-- Remix Weapon Tracker is marked with CC0 1.0 Universal. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

---@class ns
local ns = select(2,...)

ns.enum = ns.enum or {}

-- copilot dreamed up this list, so it's probably subtly wrong
---@enum equip
local equip = {
   ONE_H_AXE = 1,
   TWO_H_AXE = 2,
   ONE_H_SWORD = 3,
   TWO_H_SWORD = 4,
   ONE_H_MACE = 5,
   TWO_H_MACE = 6,
   STAFF = 7,
   DAGGER = 8,
   FIST = 9,
   POLEARM = 10,
   BOW = 11,
   GUN = 12,
   CROSSBOW = 13,
   WAND = 14,
   SHIELD = 15,
   OFF_HAND = 16,
   GLAIVES = 17,
   CLOTH = 18,
   LEATHER = 19,
   MAIL = 20,
   PLATE = 21,
}
ns.enum.equip = equip
local toEnum = {
   ["Staff"] = equip.STAFF,
   ["Two-Handed Sword"] = equip.TWO_H_SWORD,
   ["Dagger"] = equip.DAGGER,
   ["One-Handed Mace"] = equip.ONE_H_MACE,
   ["One-Handed Axe"] = equip.ONE_H_AXE,
   ["Wand"] = equip.WAND,
   ["Fist Weapon"] = equip.FIST,
   ["Two-Handed Axe"] = equip.TWO_H_AXE,
   ["One-Handed Sword"] = equip.ONE_H_SWORD,
   ["Bow"] = equip.BOW,
   ["Two-Handed Mace"] = equip.TWO_H_MACE,
   ["Polearm"] = equip.POLEARM,
   ["Crossbow"] = equip.CROSSBOW,
   ["Gun"] = equip.GUN
}


---@type table<equip,string>
local equipName = {
   [equip.ONE_H_AXE] = "One-Handed Axe",
   [equip.TWO_H_AXE] = "Two-Handed Axe",
   [equip.ONE_H_SWORD] = "One-Handed Sword",
   [equip.TWO_H_SWORD] = "Two-Handed Sword",
   [equip.ONE_H_MACE] = "One-Handed Mace",
   [equip.TWO_H_MACE] = "Two-Handed Mace",
   [equip.STAFF] = "Staff",
   [equip.DAGGER] = "Dagger",
   [equip.FIST] = "Fist Weapon",
   [equip.POLEARM] = "Polearm",
   [equip.BOW] = "Bow",
   [equip.GUN] = "Gun",
   [equip.CROSSBOW] = "Crossbow",
   [equip.WAND] = "Wand",
   [equip.SHIELD] = "Shield",
   [equip.OFF_HAND] = "Off-Hand", -- books, orbs, etc. IIRC all classes can equip these
   [equip.GLAIVES] = "Warglaives",
}
ns.enum.equipName = equipName

-- copilot dreamed up this list, so it's probably extremely wrong
---@type table<class,table<equip,true>>
local class_to_equip = {
   DEATHKNIGHT = {
      [equip.PLATE] = true,
      [equip.ONE_H_AXE] = true,
      [equip.TWO_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.TWO_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.TWO_H_MACE] = true,
      [equip.POLEARM] = true,
   },
   DEMONHUNTER = {
      [equip.LEATHER] = true,
      [equip.ONE_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.FIST] = true,
   },
   DRUID = {
      [equip.LEATHER] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.ONE_H_MACE] = true,
      [equip.POLEARM] = true,
      [equip.OFF_HAND] = true,
      [equip.TWO_H_MACE] = true,
   },
   EVOKER = {
      [equip.CLOTH] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.WAND] = true,
      [equip.OFF_HAND] = true,
      [equip.ONE_H_AXE] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.ONE_H_MACE] = true,
      [equip.ONE_H_SWORD] = true,
   },
   HUNTER = {
      [equip.MAIL] = true,
      [equip.BOW] = true,
      [equip.GUN] = true,
      [equip.CROSSBOW] = true,
      [equip.POLEARM] = true,
      [equip.STAFF] = true,
   },
   MAGE = {
      [equip.CLOTH] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.WAND] = true,
      [equip.OFF_HAND] = true,
   },
   MONK = {
      [equip.LEATHER] = true,
      [equip.ONE_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.STAFF] = true,
      [equip.FIST] = true,
      [equip.POLEARM] = true,
      [equip.OFF_HAND] = true,
   },
   PALADIN = {
      [equip.PLATE] = true,
      [equip.ONE_H_AXE] = true,
      [equip.TWO_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.TWO_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.TWO_H_MACE] = true,
      [equip.POLEARM] = true,
      [equip.OFF_HAND] = true,
      [equip.SHIELD] = true,
   },
   PRIEST = {
      [equip.CLOTH] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.ONE_H_MACE] = true,
      [equip.WAND] = true,
      [equip.OFF_HAND] = true,
   },
   ROGUE = {
      [equip.LEATHER] = true,
      [equip.ONE_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
   },
   SHAMAN = {
      [equip.MAIL] = true,
      [equip.ONE_H_AXE] = true,
      [equip.TWO_H_AXE] = true,
      [equip.ONE_H_MACE] = true,
      [equip.TWO_H_MACE] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.OFF_HAND] = true,
      [equip.SHIELD] = true,
   },
   WARLOCK = {
      [equip.CLOTH] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.WAND] = true,
      [equip.OFF_HAND] = true,
   },
   WARRIOR = {
      [equip.PLATE] = true,
      [equip.ONE_H_AXE] = true,
      [equip.TWO_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.TWO_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.TWO_H_MACE] = true,
      [equip.STAFF] = true,
      [equip.FIST] = true,
      [equip.POLEARM] = true,
      [equip.SHIELD] = true,
   },
}
ns.enum.class_to_equip = class_to_equip

---@type table<equip,table<number,true>>
ns.enum.spec_can_loot = {
   [equip.ONE_H_AXE] = {
      -- DK
      [251] = true,
      -- DH
      [577] = true,
      [581] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Monk
      [268] = true,
      [269] = true,
      [270] = true,
      -- Paladin
      [65] = true,
      [66] = true,
      -- Rogue
      [260] = true,
      -- Shaman
      [262] = true,
      [263] = true,
      [264] = true,
      -- Warrior
      [72] = true,
      [73] = true,
   },
   [equip.TWO_H_AXE] = {
      -- DK
      [250] = true,
      [251] = true,
      [252] = true,
      -- Paladin
      [65] = true,
      [70] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warrior
      [71] = true,
      [72] = true,
   },
   [equip.BOW] = {
      -- Hunter
      [253] = true,
      [254] = true,
   },
   [equip.CROSSBOW] = {
      -- Hunter
      [253] = true,
      [254] = true,
   },
   [equip.DAGGER] = {
      -- Druid
      [102] = true,
      [105] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Mage
      [62] = true,
      [63] = true,
      [64] = true,
      -- Priest
      [256] = true,
      [257] = true,
      [258] = true,
      -- Rogue
      [259] = true,
      [261] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warlock
      [265] = true,
      [266] = true,
      [267] = true,
   },
   [equip.FIST] = {
      -- DH
      [577] = true,
      [581] = true,
      -- Druid
      [102] = true,
      [105] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Monk
      [268] = true,
      [269] = true,
      [270] = true,
      -- Rogue
      [260] = true,
      -- Shaman
      [262] = true,
      [263] = true,
      [264] = true,
      -- Warrior
      [72] = true,
      [73] = true,
   },
   [equip.GUN] = {
      -- Hunter
      [253] = true,
      [254] = true,
   },
   [equip.ONE_H_MACE] = {
      -- DK
      [251] = true,
      -- Druid
      [102] = true,
      [105] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Monk
      [268] = true,
      [269] = true,
      [270] = true,
      -- Paladin
      [65] = true,
      [66] = true,
      -- Priest
      [256] = true,
      [257] = true,
      [258] = true,
      -- Rogue
      [260] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warrior
      [72] = true,
      [73] = true,
   },
   [equip.TWO_H_MACE] = {
      -- DK
      [250] = true,
      [251] = true,
      [252] = true,
      -- Druid
      [102] = true,
      [103] = true,
      [104] = true,
      [105] = true,
      -- Paladin
      [65] = true,
      [70] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warrior
      [71] = true,
      [72] = true,
   },
   [equip.OFF_HAND] = {
      -- Druid
      [102] = true,
      [105] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Mage
      [62] = true,
      [63] = true,
      [64] = true,
      -- Monk
      [270] = true,
      -- Paladin
      [65] = true,
      -- Priest
      [256] = true,
      [257] = true,
      [258] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warlock
      [265] = true,
      [266] = true,
      [267] = true,
   },
   [equip.POLEARM] = {
      -- DK
      [250] = true,
      [251] = true,
      [252] = true,
      -- Druid
      [102] = true,
      [103] = true,
      [104] = true,
      [105] = true,
      -- Hunter
      [255] = true,
      -- Monk
      [268] = true,
      [269] = true,
      [270] = true,
      -- Paladin
      [65] = true,
      [70] = true,
      -- Warrior
      [71] = true,
      [72] = true,
   },
   [equip.SHIELD] = {
      -- Paladin
      [65] = true,
      [66] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warrior
      [73] = true,
   },
   [equip.STAFF] = {
      -- Druid
      [102] = true,
      [103] = true,
      [104] = true,
      [105] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Hunter
      [255] = true,
      -- Mage
      [62] = true,
      [63] = true,
      [64] = true,
      -- Monk
      [268] = true,
      [269] = true,
      [270] = true,
      -- Priest
      [256] = true,
      [257] = true,
      [258] = true,
      -- Shaman
      [262] = true,
      [264] = true,
      -- Warrior
      [71] = true,
      [72] = true,
      -- Warlock
      [265] = true,
      [266] = true,
      [267] = true,
   },
   [equip.ONE_H_SWORD] = {
      -- DK
      [251] = true,
      -- DH
      [577] = true,
      [581] = true,
      -- Evoker
      [1467] = true,
      [1468] = true,
      [1473] = true,
      -- Mage
      [62] = true,
      [63] = true,
      [64] = true,
      -- Monk
      [268] = true,
      [269] = true,
      [270] = true,
      -- Paladin
      [65] = true,
      [66] = true,
      -- Rogue
      [260] = true,
      -- Warrior
      [72] = true,
      [73] = true,
      -- Warlock
      [265] = true,
      [266] = true,
      [267] = true,
   },
   [equip.TWO_H_SWORD] = {
      -- DK
      [250] = true,
      [251] = true,
      [252] = true,
      -- Paladin
      [65] = true,
      [70] = true,
      -- Warrior
      [71] = true,
      [72] = true,
   },
   [equip.WAND] = {
      -- Mage
      [62] = true,
      [63] = true,
      [64] = true,
      -- Priest
      [256] = true,
      [257] = true,
      [258] = true,
      -- Warlock
      [265] = true,
      [266] = true,
      [267] = true,
   },
}

---@enum loc
local loc = {
   SOOR = "Siege of Ongrimmar (LFR)",
   SOON = "Siege of Ongrimmar (Normal)",
   SOOH = "Siege of Ongrimmar (Heroic)",
   SOOM = "Siege of Ongrimmar (Mythic)",
   SOOU = "Siege of Ongrimmar (?)",
   SOO  = "Siege of Ongrimmar",
   TOTR = "Throne of Thunder (LFR)",
   TOTN = "Throne of Thunder (Normal)",
   TOTH = "Throne of Thunder (Heroic)",
   TOTU = "Throne of Thunder (?)",
   TOT  = "Throne of Thunder",
   FEAR = "MSV/HOF/TOES (LFR)",
   FEAN = "MSV/HOF/TOES (Normal)",
   FEAH = "MSV/HOF/TOES (Heroic)",
   FEAU = "MSV/HOF/TOES (?)",
   FEA  = "MSV/HOF/TOES",
   KLIS = "Kun-Lai or Islands",
   KREB = "Vale or Wilds",
   V4DW = "Valley or Wastes",
   JFTL = "Forest or Steppes",
   RISL = "Islands Rares",
   ISLE = "Islands",
   RDRW = "Dread Wastes Rares",
   DWST = "Dread Wastes",
   REBL = "Vale of Eternal Blossoms Rares",
   VALE = "Vale of Eternal Blossoms ",
   RKLS = "Kun-Lai Summit Rares",
   KLSM = "Kun-Lai Summit",
   RTLS = "Townlong Steppes Rares",
   STEP = "Townlong Steppes",
   RJDE = "Jade Forest Rares",
   JADE = "Jade Forest",
   RWLD = "Krasarang Wilds Rares",
   WILD = "Krasarang Wilds",
   RV4W = "Valley of the 4 Winds Rares",
   FOUR = "Valley of the 4 Winds",
   SCEN = "Scenarios (Normal)",
   SCEH = "Scenarios (Heroic)",
   SCEU = "Scenarios (?)",
   SCE  = "Scenarios",
   DUNN = "Dungeons (Normal)",
   DUNH = "Dungeons (Heroic)",
   DUNU = "Dungeons (?)",
   DUN  = "Dungeons",
   VEND = "Scrap Vendor",
   UNKNOWN = "Unknown",
}
ns.enum.loc = loc


---@enum
ns.enum.vendorName = {
   world = "Larah Treebender",
   dungeon = "Arturos",
   lfr = "Aeonicus",
   normal = "Durus",
   heroic = "Pythagorus",
   bones = CreateAtlasMarkup("ChromieTime-32x32") .. "Pythagorus",
   class = CreateAtlasMarkup("ChromieTime-32x32") .. "Grandmaster Jakkus",
}
