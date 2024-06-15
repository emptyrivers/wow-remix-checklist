-- Remix Weapon Tracker is marked with CC0 1.0 Universal. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

---@class ns
local addon = select(2,...)

addon.enum = addon.enum or {}

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
addon.enum.equip = equip
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
addon.enum.equipName = equipName

---@alias class
---| '"DEATHKNIGHT"'
---| '"DEMONHUNTER"'
---| '"DRUID"'
---| '"EVOKER"'
---| '"HUNTER"'
---| '"MAGE"'
---| '"MONK"'
---| '"PALADIN"'
---| '"PRIEST"'
---| '"ROGUE"'
---| '"SHAMAN"'
---| '"WARLOCK"'
---| '"WARRIOR"'

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
addon.enum.class_to_equip = class_to_equip

---@type table<equip,table<number,true>>
addon.enum.spec_can_loot = {
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
   TOTR = "Throne of Thunder (LFR)",
   TOTN = "Throne of Thunder (Normal)",
   TOTH = "Throne of Thunder (Heroic)",
   TOTU = "Throne of Thunder (?)",
   FEAR = "MSV/HOF/TOES (LFR)",
   FEAN = "MSV/HOF/TOES (Normal)",
   FEAH = "MSV/HOF/TOES (Heroic)",
   FEAU = "MSV/HOF/TOES (?)",
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
   STEP = "Tonwlong Steppes",
   RJDE = "Jade Forest Rares",
   JADE = "Jade Forest",
   RWLD = "Krasarang Wilds Rares",
   WILD = "Krasarang Wilds",
   RV4W = "Valley of the 4 Winds Rares",
   FOUR = "Valley of the 4 Winds",
   SCEN = "Scenarios (Normal)",
   SCEH = "Scenarios (Heroic)",
   SCEU = "Scenarios (?)",
   DUNN = "Dungeons (Normal)",
   DUNH = "Dungeons (Heroic)",
   DUNU = "Dungeons (?)",
   VEND = "Scrap Vendor",
   UNKNOWN = "Unknown",
}
addon.enum.loc = loc

---@alias itemID number

-- data was gathered from wowhead by hand, so it's probably subtly wrong
---@type {type: equip, items: { id: itemID, loc: string, loc2: string?}[]}[]
addon.weapons = {
   { type = equip.ONE_H_AXE, items = {
      {id=215469,link="https://wowhead.com/item=215469",loc=loc.SOOR},
      {id=215470,link="https://wowhead.com/item=215470",loc=loc.SOON},
      {id=215471,link="https://wowhead.com/item=215471",loc=loc.SOOH},
      {id=215472,link="https://wowhead.com/item=215472",loc=loc.SOOU},
      {id=215473,link="https://wowhead.com/item=215473",loc=loc.SOOR},
      {id=215474,link="https://wowhead.com/item=215474",loc=loc.SOON},
      {id=215475,link="https://wowhead.com/item=215475",loc=loc.SOOH},
      {id=215476,link="https://wowhead.com/item=215476",loc=loc.SOOU},
      {id=215477,link="https://wowhead.com/item=215477",loc=loc.SOOR},
      {id=215478,link="https://wowhead.com/item=215478",loc=loc.SOON},
      {id=215479,link="https://wowhead.com/item=215479",loc=loc.SOOH},
      {id=215480,link="https://wowhead.com/item=215480",loc=loc.SOOR},
      {id=215481,link="https://wowhead.com/item=215481",loc=loc.FEAU},
      {id=215482,link="https://wowhead.com/item=215482",loc=loc.FEAU},
      {id=215483,link="https://wowhead.com/item=215483",loc=loc.FEAU},
      {id=215484,link="https://wowhead.com/item=215484",loc=loc.KREB},
      {id=215485,link="https://wowhead.com/item=215485",loc=loc.V4DW},
      {id=215486,link="https://wowhead.com/item=215486",loc=loc.KLIS},
      {id=215487,link="https://wowhead.com/item=215487",loc=loc.JFTL},
      {id=215488,link="https://wowhead.com/item=215488",loc=loc.KLIS},
      {id=215489,link="https://wowhead.com/item=215489",loc=loc.KREB},
      {id=215490,link="https://wowhead.com/item=215490",loc=loc.DUNN},
      {id=215491,link="https://wowhead.com/item=215491",loc=loc.DUNH},
      {id=215492,link="https://wowhead.com/item=215492",loc=loc.SCEN},
      {id=215493,link="https://wowhead.com/item=215493",loc=loc.SCEH}, 
      {id=215494,link="https://wowhead.com/item=215494",loc=loc.REBL},
      {id=215495,link="https://wowhead.com/item=215495",loc=loc.STEP},
      {id=215496,link="https://wowhead.com/item=215496",loc=loc.DWST},
      {id=215497,link="https://wowhead.com/item=215497",loc=loc.TOTH},
      {id=215498,link="https://wowhead.com/item=215498",loc=loc.TOTR},
      {id=215499,link="https://wowhead.com/item=215499",loc=loc.TOTN},
      {id=215500,link="https://wowhead.com/item=215500",loc=loc.TOTR},
      {id=216013,link="https://wowhead.com/item=216013",loc=loc.TOTU},
      {id=216014,link="https://wowhead.com/item=216014",loc=loc.TOTU},
      {id=216015,link="https://wowhead.com/item=216015",loc=loc.TOTN},
      {id=216016,link="https://wowhead.com/item=216016",loc=loc.TOTU},
      {id=216017,link="https://wowhead.com/item=216017",loc=loc.TOTR},
      {id=216018,link="https://wowhead.com/item=216018",loc=loc.TOTN},
      {id=216019,link="https://wowhead.com/item=216019",loc=loc.TOTH},
      {id=216020,link="https://wowhead.com/item=216020",loc=loc.TOTR},
      {id=216021,link="https://wowhead.com/item=216021",loc=loc.KLSM},
      {id=216022,link="https://wowhead.com/item=216022",loc=loc.KLSM},
      {id=216023,link="https://wowhead.com/item=216023",loc=loc.WILD},
      {id=216024,link="https://wowhead.com/item=216024",loc=loc.JADE},
      {id=216025,link="https://wowhead.com/item=216025",loc=loc.FOUR},
   }},
   { type = equip.TWO_H_AXE, items = {
      {id=215501,link="https://wowhead.com/item=215501",loc=loc.SOOR},
      {id=215502,link="https://wowhead.com/item=215502",loc=loc.SOON}, --lookup!
      {id=215503,link="https://wowhead.com/item=215503",loc=loc.SOOH}, --lookup!
      {id=215504,link="https://wowhead.com/item=215504",loc=loc.SOOU}, --lookup!
      {id=215505,link="https://wowhead.com/item=215505",loc=loc.FEAR}, --lookup!
      {id=215506,link="https://wowhead.com/item=215506",loc=loc.FEAN},
      {id=215507,link="https://wowhead.com/item=215507",loc=loc.FEAH}, --lookup!
      {id=215508,link="https://wowhead.com/item=215508",loc=loc.FEAU}, --lookup!
      {id=215509,link="https://wowhead.com/item=215509",loc=loc.V4DW}, --lookup!
      {id=215510,link="https://wowhead.com/item=215510",loc=loc.KREB}, --lookup!
      {id=215511,link="https://wowhead.com/item=215511",loc=loc.KLIS}, --lookup!
      {id=215512,link="https://wowhead.com/item=215512",loc=loc.STEP},
      {id=215513,link="https://wowhead.com/item=215513",loc=loc.DWST},
      {id=215514,link="https://wowhead.com/item=215514",loc=loc.VALE},
      {id=215515,link="https://wowhead.com/item=215515",loc=loc.ISLE},
      {id=215516,link="https://wowhead.com/item=215516",loc=loc.TOTN}, --lookup!
      {id=215517,link="https://wowhead.com/item=215517",loc=loc.TOTU},
      {id=215518,link="https://wowhead.com/item=215518",loc=loc.TOTR}, --lookup!
      {id=215519,link="https://wowhead.com/item=215519",loc=loc.TOTH}, --lookup!
   }},
   { type = equip.ONE_H_SWORD, items = {
      -- these 3 klaxxi swords haven't been found yet :<
      {id=215902,link="https://wowhead.com/item=215902",loc=loc.UNKNOWN},
      {id=215903,link="https://wowhead.com/item=215903",loc=loc.UNKNOWN},
      {id=215904,link="https://wowhead.com/item=215904",loc=loc.UNKNOWN},
      {id=215905,link="https://wowhead.com/item=215905",loc=loc.UNKNOWN}, --lookup!
      {id=215906,link="https://wowhead.com/item=215906",loc=loc.UNKNOWN}, --lookup!
      {id=215907,link="https://wowhead.com/item=215907",loc=loc.UNKNOWN}, --lookup!
      {id=215908,link="https://wowhead.com/item=215908",loc=loc.ISLE},
      {id=215909,link="https://wowhead.com/item=215909",loc=loc.UNKNOWN}, --lookup!
      {id=215910,link="https://wowhead.com/item=215910",loc=loc.UNKNOWN}, --lookup!
      {id=215911,link="https://wowhead.com/item=215911",loc=loc.UNKNOWN}, --lookup!
      {id=215912,link="https://wowhead.com/item=215912",loc=loc.SOOR},
      {id=215913,link="https://wowhead.com/item=215913",loc=loc.UNKNOWN}, --lookup!
      {id=215914,link="https://wowhead.com/item=215914",loc=loc.UNKNOWN}, --lookup!
      {id=215915,link="https://wowhead.com/item=215915",loc=loc.UNKNOWN}, --lookup!
      {id=215916,link="https://wowhead.com/item=215916",loc=loc.UNKNOWN}, --lookup!
      {id=215917,link="https://wowhead.com/item=215917",loc=loc.UNKNOWN}, --lookup!
      {id=215918,link="https://wowhead.com/item=215918",loc=loc.UNKNOWN}, --lookup!
      {id=215919,link="https://wowhead.com/item=215919",loc=loc.UNKNOWN}, --lookup!
      {id=215920,link="https://wowhead.com/item=215920",loc=loc.SOOR},
      {id=215921,link="https://wowhead.com/item=215921",loc=loc.UNKNOWN}, --lookup!
      {id=215922,link="https://wowhead.com/item=215922",loc=loc.SOON},
      {id=215923,link="https://wowhead.com/item=215923",loc=loc.UNKNOWN}, --lookup!
      {id=215924,link="https://wowhead.com/item=215924",loc=loc.UNKNOWN}, --lookup!
      {id=215925,link="https://wowhead.com/item=215925",loc=loc.UNKNOWN}, --lookup!
      {id=215926,link="https://wowhead.com/item=215926",loc=loc.UNKNOWN}, --lookup!
      {id=215927,link="https://wowhead.com/item=215927",loc=loc.UNKNOWN}, --lookup!
      {id=215928,link="https://wowhead.com/item=215928",loc=loc.UNKNOWN}, --lookup!
      {id=215929,link="https://wowhead.com/item=215929",loc=loc.UNKNOWN}, --lookup!
      {id=215930,link="https://wowhead.com/item=215930",loc=loc.UNKNOWN}, --lookup!
      {id=215931,link="https://wowhead.com/item=215931",loc=loc.UNKNOWN}, --lookup!
      {id=215932,link="https://wowhead.com/item=215932",loc=loc.UNKNOWN}, --lookup!
      {id=215933,link="https://wowhead.com/item=215933",loc=loc.FEAH},
      {id=215934,link="https://wowhead.com/item=215934",loc=loc.UNKNOWN}, --lookup!
      {id=215935,link="https://wowhead.com/item=215935",loc=loc.UNKNOWN}, --lookup!
      {id=215936,link="https://wowhead.com/item=215936",loc=loc.UNKNOWN}, --lookup!
      {id=215937,link="https://wowhead.com/item=215937",loc=loc.KREB}, --lookup!
      {id=215938,link="https://wowhead.com/item=215938",loc=loc.JFTL}, --lookup!
      {id=215939,link="https://wowhead.com/item=215939",loc=loc.V4DW}, --lookup!
      {id=215940,link="https://wowhead.com/item=215940",loc=loc.KLIS}, --lookup!
      {id=215941,link="https://wowhead.com/item=215941",loc=loc.V4DW}, --lookup!
      {id=215942,link="https://wowhead.com/item=215942",loc=loc.JFTL}, --lookup!
      {id=215943,link="https://wowhead.com/item=215943",loc=loc.KREB}, --lookup!
      {id=215944,link="https://wowhead.com/item=215944",loc=loc.KLIS}, --lookup!
      {id=215945,link="https://wowhead.com/item=215945",loc=loc.V4DW}, --lookup!
      {id=215946,link="https://wowhead.com/item=215946",loc=loc.JFTL}, --lookup!
      {id=215947,link="https://wowhead.com/item=215947",loc=loc.KREB}, --lookup!
      {id=215948,link="https://wowhead.com/item=215948",loc=loc.KLIS}, --lookup!
      {id=215949,link="https://wowhead.com/item=215949",loc=loc.JFTL}, --lookup!
      {id=215950,link="https://wowhead.com/item=215950",loc=loc.V4DW}, --lookup!
      {id=215951,link="https://wowhead.com/item=215951",loc=loc.KREB}, --lookup!
      {id=215952,link="https://wowhead.com/item=215952",loc=loc.KLIS}, --lookup!
      {id=215953,link="https://wowhead.com/item=215953",loc=loc.SCEN}, --lookup!
      {id=215954,link="https://wowhead.com/item=215954",loc=loc.DUNU}, --lookup!
      {id=215955,link="https://wowhead.com/item=215955",loc=loc.DUNU}, --lookup!
      {id=215956,link="https://wowhead.com/item=215956",loc=loc.SCEH}, --lookup!
      {id=215957,link="https://wowhead.com/item=215957",loc=loc.STEP},
      {id=215958,link="https://wowhead.com/item=215958",loc=loc.DWST},
      {id=215959,link="https://wowhead.com/item=215959",loc=loc.VALE},
      {id=215960,link="https://wowhead.com/item=215960",loc=loc.ISLE},
      {id=215961,link="https://wowhead.com/item=215961",loc=loc.UNKNOWN}, --lookup!
      {id=215962,link="https://wowhead.com/item=215962",loc=loc.UNKNOWN}, --lookup!
      {id=215963,link="https://wowhead.com/item=215963",loc=loc.UNKNOWN}, --lookup!
      {id=215964,link="https://wowhead.com/item=215964",loc=loc.TOTR},
      {id=215965,link="https://wowhead.com/item=215965",loc=loc.UNKNOWN}, --lookup!
      {id=215966,link="https://wowhead.com/item=215966",loc=loc.UNKNOWN}, --lookup!
      {id=215967,link="https://wowhead.com/item=215967",loc=loc.UNKNOWN}, --lookup!
      {id=216474,link="https://wowhead.com/item=216474",loc=loc.WILD},
      {id=216475,link="https://wowhead.com/item=216475",loc=loc.JADE},
      {id=216476,link="https://wowhead.com/item=216476",loc=loc.FOUR},
      {id=216477,link="https://wowhead.com/item=216477",loc=loc.KLSM},
      {id=224080,link="https://wowhead.com/item=224080",loc=loc.VEND}, --lookup!
   }},
   { type = equip.TWO_H_SWORD, items = {
      {id=215968,link="https://wowhead.com/item=215968",loc=loc.FEAU}, --lookup!
      {id=215969,link="https://wowhead.com/item=215969",loc=loc.FEAU}, --lookup!
      {id=215970,link="https://wowhead.com/item=215970",loc=loc.ISLE}, -- ??
      {id=215971,link="https://wowhead.com/item=215971",loc=loc.SOOR},
      {id=215972,link="https://wowhead.com/item=215972",loc=loc.SOON}, --lookup!
      {id=215973,link="https://wowhead.com/item=215973",loc=loc.SOOH}, --lookup!
      {id=215974,link="https://wowhead.com/item=215974",loc=loc.SOOU}, --lookup!
      -- why do so many weapons have only garalon as drop source in wh data 😭
      {id=215975,link="https://wowhead.com/item=215975",loc=loc.FEAU}, --lookup!
      {id=215976,link="https://wowhead.com/item=215976",loc=loc.FEAN},
      {id=215977,link="https://wowhead.com/item=215977",loc=loc.UNKNOWN}, --lookup!
      {id=215978,link="https://wowhead.com/item=215978",loc=loc.UNKNOWN}, --lookup!
      {id=215979,link="https://wowhead.com/item=215979",loc=loc.V4DW}, --lookup!
      {id=215980,link="https://wowhead.com/item=215980",loc=loc.JFTL}, --lookup!
      {id=215981,link="https://wowhead.com/item=215981",loc=loc.KREB}, --lookup!
      {id=215982,link="https://wowhead.com/item=215982",loc=loc.KLIS}, --lookup!
      {id=215983,link="https://wowhead.com/item=215983",loc=loc.DUNU},
      {id=215984,link="https://wowhead.com/item=215984",loc=loc.DUNU}, --lookup!
      {id=215985,link="https://wowhead.com/item=215985",loc=loc.SCEN}, --lookup!
      {id=215986,link="https://wowhead.com/item=215986",loc=loc.SCEH},
      {id=215987,link="https://wowhead.com/item=215987",loc=loc.RTLS},
      {id=215988,link="https://wowhead.com/item=215988",loc=loc.RDRW},
      {id=215989,link="https://wowhead.com/item=215989",loc=loc.REBL},
      {id=215990,link="https://wowhead.com/item=215990",loc=loc.TOTH}, --lookup!
      {id=215991,link="https://wowhead.com/item=215991",loc=loc.UNKNOWN}, --lookup!
      {id=215992,link="https://wowhead.com/item=215992",loc=loc.UNKNOWN}, --lookup!
      {id=215993,link="https://wowhead.com/item=215993",loc=loc.UNKNOWN}, --lookup!
      {id=216478,link="https://wowhead.com/item=216478",loc=loc.UNKNOWN},
      {id=216479,link="https://wowhead.com/item=216479",loc=loc.JADE},
      {id=216480,link="https://wowhead.com/item=216480",loc=loc.FOUR},
      {id=216481,link="https://wowhead.com/item=216481",loc=loc.WILD},
      {id=216482,link="https://wowhead.com/item=216482",loc=loc.KLSM}, --lookup!
      {id=224075,link="https://wowhead.com/item=224075",loc=loc.VEND}, --lookup!
   }},
   { type = equip.ONE_H_MACE, items = {
      {id=215712,link="https://wowhead.com/item=215712",loc=loc.SOON},
      {id=215713,link="https://wowhead.com/item=215713",loc=loc.SOOH}, --lookup!
      {id=215714,link="https://wowhead.com/item=215714",loc=loc.SOOU}, --lookup!
      {id=215715,link="https://wowhead.com/item=215715",loc=loc.SOOR}, --lookup!
      {id=215716,link="https://wowhead.com/item=215716",loc=loc.SOON}, --lookup!
      {id=215717,link="https://wowhead.com/item=215717",loc=loc.SOOH}, --lookup!
      {id=215718,link="https://wowhead.com/item=215718",loc=loc.SOOU},
      {id=215719,link="https://wowhead.com/item=215719",loc=loc.SOOH}, --lookup!
      {id=215720,link="https://wowhead.com/item=215720",loc=loc.SOOR}, --lookup!
      {id=215721,link="https://wowhead.com/item=215721",loc=loc.SOON}, --lookup!
      {id=215722,link="https://wowhead.com/item=215722",loc=loc.SOOU}, --lookup!
      {id=215723,link="https://wowhead.com/item=215723",loc=loc.SOOR}, --lookup!
      {id=215724,link="https://wowhead.com/item=215724",loc=loc.SOON}, --lookup!
      {id=215725,link="https://wowhead.com/item=215725",loc=loc.SOOH}, --lookup!
      {id=215726,link="https://wowhead.com/item=215726",loc=loc.SOOU}, --lookup!
      {id=215727,link="https://wowhead.com/item=215727",loc=loc.FEAU}, --lookup!
      {id=215728,link="https://wowhead.com/item=215728",loc=loc.FEAU}, --lookup!
      {id=215729,link="https://wowhead.com/item=215729",loc=loc.FEAU}, --lookup!
      {id=215730,link="https://wowhead.com/item=215730",loc=loc.FEAU},
      {id=215731,link="https://wowhead.com/item=215731",loc=loc.FEAR}, --lookup!
      {id=215732,link="https://wowhead.com/item=215732",loc=loc.FEAN}, --lookup!
      {id=215733,link="https://wowhead.com/item=215733",loc=loc.FEAH}, --lookup!
      {id=215734,link="https://wowhead.com/item=215734",loc=loc.UNKNOWN}, --lookup!
      {id=215735,link="https://wowhead.com/item=215735",loc=loc.UNKNOWN}, --lookup!
      {id=215736,link="https://wowhead.com/item=215736",loc=loc.UNKNOWN}, --lookup!
      {id=215737,link="https://wowhead.com/item=215737",loc=loc.UNKNOWN}, --lookup!
      {id=215738,link="https://wowhead.com/item=215738",loc=loc.JFTL},
      {id=215739,link="https://wowhead.com/item=215739",loc=loc.V4DW}, --lookup!
      {id=215740,link="https://wowhead.com/item=215740",loc=loc.KREB}, --lookup!
      {id=215741,link="https://wowhead.com/item=215741",loc=loc.KLIS}, --lookup!
      {id=215742,link="https://wowhead.com/item=215742",loc=loc.KREB}, --lookup!
      {id=215743,link="https://wowhead.com/item=215743",loc=loc.JFTL}, --lookup!
      {id=215744,link="https://wowhead.com/item=215744",loc=loc.V4DW}, --lookup!
      {id=215745,link="https://wowhead.com/item=215745",loc=loc.KLIS},
      {id=215746,link="https://wowhead.com/item=215746",loc=loc.KLIS}, --lookup!
      {id=215747,link="https://wowhead.com/item=215747",loc=loc.JFTL}, --lookup!
      {id=215748,link="https://wowhead.com/item=215748",loc=loc.V4DW}, --lookup!
      {id=215749,link="https://wowhead.com/item=215749",loc=loc.KREB}, --lookup!
      {id=215750,link="https://wowhead.com/item=215750",loc=loc.DUNN}, --lookup!
      {id=215751,link="https://wowhead.com/item=215751",loc=loc.DUNH}, --lookup!
      {id=215752,link="https://wowhead.com/item=215752",loc=loc.SCEN}, --lookup!
      {id=215753,link="https://wowhead.com/item=215753",loc=loc.SCEH}, --lookup!
      {id=215754,link="https://wowhead.com/item=215754",loc=loc.DUNN}, --lookup!
      {id=215755,link="https://wowhead.com/item=215755",loc=loc.DUNH}, --lookup!
      {id=215756,link="https://wowhead.com/item=215756",loc=loc.SCEN}, --lookup!
      {id=215757,link="https://wowhead.com/item=215757",loc=loc.SCEH},
      {id=215758,link="https://wowhead.com/item=215758",loc=loc.STEP},
      {id=215759,link="https://wowhead.com/item=215759",loc=loc.DWST},
      {id=215760,link="https://wowhead.com/item=215760",loc=loc.VALE},
      {id=215761,link="https://wowhead.com/item=215761",loc=loc.ISLE},
      {id=215762,link="https://wowhead.com/item=215762",loc=loc.DWST},
      {id=215763,link="https://wowhead.com/item=215763",loc=loc.STEP},
      {id=215764,link="https://wowhead.com/item=215764",loc=loc.VALE},
      {id=215765,link="https://wowhead.com/item=215765",loc=loc.TOTH}, --lookup!
      {id=215766,link="https://wowhead.com/item=215766",loc=loc.TOTU},
      {id=215767,link="https://wowhead.com/item=215767",loc=loc.TOTU},
      {id=215768,link="https://wowhead.com/item=215768",loc=loc.TOTU},
      {id=215769,link="https://wowhead.com/item=215769",loc=loc.TOTU}, --lookup!
      {id=215770,link="https://wowhead.com/item=215770",loc=loc.TOTN},
      {id=215771,link="https://wowhead.com/item=215771",loc=loc.TOTU}, --lookup!
      {id=215772,link="https://wowhead.com/item=215772",loc=loc.TOTU}, --lookup!
      {id=215773,link="https://wowhead.com/item=215773",loc=loc.TOTU}, --lookup!
      {id=215774,link="https://wowhead.com/item=215774",loc=loc.TOTU}, --lookup!
      {id=215775,link="https://wowhead.com/item=215775",loc=loc.TOTH}, --lookup!
      {id=215776,link="https://wowhead.com/item=215776",loc=loc.ISLE}, -- ??
      {id=216421,link="https://wowhead.com/item=216421",loc=loc.KLSM}, --lookup!
      {id=216422,link="https://wowhead.com/item=216422",loc=loc.WILD}, --lookup!
      {id=216423,link="https://wowhead.com/item=216423",loc=loc.JADE},
      {id=216424,link="https://wowhead.com/item=216424",loc=loc.FOUR}, --lookup!
      {id=216425,link="https://wowhead.com/item=216425",loc=loc.TOTU},
      {id=216426,link="https://wowhead.com/item=216426",loc=loc.TOTU}, --lookup!
      {id=216427,link="https://wowhead.com/item=216427",loc=loc.TOTU}, --lookup!
      {id=216428,link="https://wowhead.com/item=216428",loc=loc.TOTU}, --lookup!
      -- despite the itemID discontinuity, this is an acid-spine bonebreaker too
      {id=216432,link="https://wowhead.com/item=216432",loc=loc.TOTU}, --lookup!
      {id=216429,link="https://wowhead.com/item=216429",loc=loc.TOTU}, --lookup!
      {id=216430,link="https://wowhead.com/item=216430",loc=loc.TOTH}, --lookup!
      {id=216431,link="https://wowhead.com/item=216431",loc=loc.TOTU}, --lookup!
      {id=224079,link="https://wowhead.com/item=224079",loc=loc.VEND}, --lookup!
   }},
   { type = equip.TWO_H_MACE, items = {
      {id=215777,link="https://wowhead.com/item=215777",loc=loc.SOON}, --lookup!
      {id=215778,link="https://wowhead.com/item=215778",loc=loc.SOOH}, --lookup!
      {id=215779,link="https://wowhead.com/item=215779",loc=loc.SOOR}, --lookup!
      {id=215780,link="https://wowhead.com/item=215780",loc=loc.JFTL}, --lookup!
      {id=215781,link="https://wowhead.com/item=215781",loc=loc.V4DW}, --lookup!
      {id=215782,link="https://wowhead.com/item=215782",loc=loc.KREB}, --lookup!
      {id=215783,link="https://wowhead.com/item=215783",loc=loc.DUNN},
      {id=215784,link="https://wowhead.com/item=215784",loc=loc.DUNH}, --lookup!
      {id=215785,link="https://wowhead.com/item=215785",loc=loc.SCEN}, --lookup!
      {id=215786,link="https://wowhead.com/item=215786",loc=loc.SCEH}, --lookup!
      {id=215787,link="https://wowhead.com/item=215787",loc=loc.TOTR}, --lookup!
      {id=215788,link="https://wowhead.com/item=215788",loc=loc.TOTN}, --lookup!
      {id=215789,link="https://wowhead.com/item=215789",loc=loc.TOTH}, --lookup!
      {id=215790,link="https://wowhead.com/item=215790",loc=loc.TOTU}, --lookup!
      {id=216434,link="https://wowhead.com/item=216434",loc=loc.TOTR}, --lookup!
      {id=216435,link="https://wowhead.com/item=216435",loc=loc.TOTN}, --lookup!
      {id=216436,link="https://wowhead.com/item=216436",loc=loc.TOTH}, --lookup!
      {id=216437,link="https://wowhead.com/item=216437",loc=loc.TOTU},
   }},
   { type = equip.STAFF, items = {
      {id=215818,link="https://wowhead.com/item=215818",loc=loc.SOON},
      {id=215819,link="https://wowhead.com/item=215819",loc=loc.SOOH}, --lookup!
      -- {id=215819,link="https://wowhead.com/item=215820",loc=loc.UNKNOWN}, doesn't exist :<
      {id=215821,link="https://wowhead.com/item=215821",loc=loc.SOOU}, --lookup!
      -- {id=215821,link="https://wowhead.com/item=215822",loc=loc.UNKNOWN}, doesn't exist :<
      {id=215823,link="https://wowhead.com/item=215823",loc=loc.SOON}, --lookup!
      -- {id=215823,link="https://wowhead.com/item=215824",loc=loc.UNKNOWN}, doesn't exist <
      {id=215825,link="https://wowhead.com/item=215825",loc=loc.SOOH}, --lookup!
      {id=215826,link="https://wowhead.com/item=215826",loc=loc.SOOU},
      {id=215827,link="https://wowhead.com/item=215827",loc=loc.SOOR}, --lookup!
      {id=215828,link="https://wowhead.com/item=215828",loc=loc.SOON}, --lookup!
      {id=215829,link="https://wowhead.com/item=215829",loc=loc.SOOH}, --lookup!
      {id=215830,link="https://wowhead.com/item=215830",loc=loc.SOOU},
      {id=215831,link="https://wowhead.com/item=215831",loc=loc.SOOR},
      {id=215832,link="https://wowhead.com/item=215832",loc=loc.SOON}, --lookup!
      {id=215833,link="https://wowhead.com/item=215833",loc=loc.SOOH}, --lookup!
      {id=215834,link="https://wowhead.com/item=215834",loc=loc.SOOU}, --lookup!
      {id=215835,link="https://wowhead.com/item=215835",loc=loc.SOOR},
      {id=215836,link="https://wowhead.com/item=215836",loc=loc.SOON}, --lookup!
      {id=215837,link="https://wowhead.com/item=215837",loc=loc.SOOH}, --lookup!
      {id=215838,link="https://wowhead.com/item=215838",loc=loc.SOOU}, --lookup!
      {id=215839,link="https://wowhead.com/item=215839",loc=loc.FEAR},
      {id=215840,link="https://wowhead.com/item=215840",loc=loc.FEAN},
      {id=215841,link="https://wowhead.com/item=215841",loc=loc.FEAH},
      {id=215842,link="https://wowhead.com/item=215842",loc=loc.FEAR},
      {id=215843,link="https://wowhead.com/item=215843",loc=loc.FEAR},
      {id=215844,link="https://wowhead.com/item=215844",loc=loc.FEAN},
      {id=215845,link="https://wowhead.com/item=215845",loc=loc.FEAH},
      {id=215846,link="https://wowhead.com/item=215846",loc=loc.FEAR},
      {id=215847,link="https://wowhead.com/item=215847",loc=loc.FEAR},
      {id=215848,link="https://wowhead.com/item=215848",loc=loc.FEAN},
      {id=215849,link="https://wowhead.com/item=215849",loc=loc.FEAH},
      {id=215850,link="https://wowhead.com/item=215850",loc=loc.FEAR},
      {id=215851,link="https://wowhead.com/item=215851",loc=loc.FEAR}, --lookup!
      {id=215852,link="https://wowhead.com/item=215852",loc=loc.FEAN}, --lookup!
      {id=215853,link="https://wowhead.com/item=215853",loc=loc.FEAH}, --lookup!
      {id=215854,link="https://wowhead.com/item=215854",loc=loc.FEAR}, --lookup!
      {id=215855,link="https://wowhead.com/item=215855",loc=loc.FEAN}, --lookup!
      {id=215856,link="https://wowhead.com/item=215856",loc=loc.FEAH}, --lookup!
      {id=215857,link="https://wowhead.com/item=215857",loc=loc.FEAR}, --lookup!
      {id=215858,link="https://wowhead.com/item=215858",loc=loc.KREB}, --lookup!
      {id=215859,link="https://wowhead.com/item=215859",loc=loc.JFTL}, --lookup!
      {id=215860,link="https://wowhead.com/item=215860",loc=loc.V4DW}, --lookup!
      {id=215861,link="https://wowhead.com/item=215861",loc=loc.KLIS}, --lookup!
      {id=215862,link="https://wowhead.com/item=215862",loc=loc.KLIS}, --lookup!
      {id=215863,link="https://wowhead.com/item=215863",loc=loc.JFTL}, --lookup!
      {id=215864,link="https://wowhead.com/item=215864",loc=loc.V4DW}, --lookup!
      {id=215865,link="https://wowhead.com/item=215865",loc=loc.KREB},
      {id=215866,link="https://wowhead.com/item=215866",loc=loc.JFTL}, --lookup!
      {id=215867,link="https://wowhead.com/item=215867",loc=loc.V4DW}, --lookup!
      {id=215868,link="https://wowhead.com/item=215868",loc=loc.KREB}, --lookup!
      {id=215869,link="https://wowhead.com/item=215869",loc=loc.KLIS}, --lookup!
      {id=215870,link="https://wowhead.com/item=215870",loc=loc.V4DW}, --lookup!
      {id=215871,link="https://wowhead.com/item=215871",loc=loc.JFTL},
      {id=215872,link="https://wowhead.com/item=215872",loc=loc.KREB},
      {id=215873,link="https://wowhead.com/item=215873",loc=loc.KLIS}, --lookup!
      {id=215874,link="https://wowhead.com/item=215874",loc=loc.DUNN},
      {id=215875,link="https://wowhead.com/item=215875",loc=loc.DUNH}, --lookup!
      {id=215876,link="https://wowhead.com/item=215876",loc=loc.SCEN}, --lookup!
      {id=215877,link="https://wowhead.com/item=215877",loc=loc.SCEH}, --lookup!
      {id=215878,link="https://wowhead.com/item=215878",loc=loc.DUNG},
      {id=215879,link="https://wowhead.com/item=215879",loc=loc.DUNN}, --lookup!
      {id=215880,link="https://wowhead.com/item=215880",loc=loc.DUNH}, --lookup!
      {id=215881,link="https://wowhead.com/item=215881",loc=loc.SCEN}, --lookup!
      {id=215882,link="https://wowhead.com/item=215882",loc=loc.SCEH}, --lookup!
      {id=215883,link="https://wowhead.com/item=215883",loc=loc.DUNN}, --lookup!
      {id=215884,link="https://wowhead.com/item=215884",loc=loc.SCEN}, --lookup!
      {id=215885,link="https://wowhead.com/item=215885",loc=loc.DUNH}, --lookup!
      {id=215886,link="https://wowhead.com/item=215886",loc=loc.SCEH}, --lookup!
      {id=215887,link="https://wowhead.com/item=215887",loc=loc.TOTN},
      {id=215888,link="https://wowhead.com/item=215888",loc=loc.TOTH}, --lookup!
      {id=215889,link="https://wowhead.com/item=215889",loc=loc.ISLE}, --lookup!
      {id=215890,link="https://wowhead.com/item=215890",loc=loc.STEP}, --lookup!
      {id=215891,link="https://wowhead.com/item=215891",loc=loc.DWST}, --lookup!
      {id=215892,link="https://wowhead.com/item=215892",loc=loc.VALE}, --lookup!
      {id=215893,link="https://wowhead.com/item=215893",loc=loc.ISLE}, --lookup!
      {id=215894,link="https://wowhead.com/item=215894",loc=loc.STEP},
      {id=215895,link="https://wowhead.com/item=215895",loc=loc.DWST},
      {id=215896,link="https://wowhead.com/item=215896",loc=loc.VALE},
      {id=215897,link="https://wowhead.com/item=215897",loc=loc.ISLE},
      {id=215898,link="https://wowhead.com/item=215898",loc=loc.TOTN},
      {id=215899,link="https://wowhead.com/item=215899",loc=loc.TOTU}, --lookup!
      {id=215900,link="https://wowhead.com/item=215900",loc=loc.TOTU}, --lookup!
      {id=215901,link="https://wowhead.com/item=215901",loc=loc.TOTU}, --lookup!
      -- monkey king & pandaren staffs dont seem to be available :<
      {id=216450,link="https://wowhead.com/item=216450",loc=loc.UNKNOWN}, --lookup!
      {id=216451,link="https://wowhead.com/item=216451",loc=loc.UNKNOWN}, --lookup!
      {id=216452,link="https://wowhead.com/item=216452",loc=loc.UNKNOWN}, --lookup!
      {id=216453,link="https://wowhead.com/item=216453",loc=loc.UNKNOWN}, --lookup!
      {id=216454,link="https://wowhead.com/item=216454",loc=loc.UNKNOWN}, --lookup!
      {id=216455,link="https://wowhead.com/item=216455",loc=loc.UNKNOWN}, --lookup!
      {id=216456,link="https://wowhead.com/item=216456",loc=loc.UNKNOWN}, --lookup!
      {id=216457,link="https://wowhead.com/item=216457",loc=loc.UNKNOWN}, --lookup!
      {id=216458,link="https://wowhead.com/item=216458",loc=loc.TOTU}, --lookup!
      {id=216459,link="https://wowhead.com/item=216459",loc=loc.TOTU},
      {id=216460,link="https://wowhead.com/item=216460",loc=loc.TOTU}, --lookup!
      {id=216461,link="https://wowhead.com/item=216461",loc=loc.TOTU}, --lookup!
      {id=216462,link="https://wowhead.com/item=216462",loc=loc.TOTU}, --lookup!
      {id=216463,link="https://wowhead.com/item=216463",loc=loc.TOTU}, --lookup!
      {id=216464,link="https://wowhead.com/item=216464",loc=loc.TOTU}, --lookup!
      {id=216465,link="https://wowhead.com/item=216465",loc=loc.TOTH}, --lookup!
      {id=216466,link="https://wowhead.com/item=216466",loc=loc.TOTU}, --lookup!
      {id=216467,link="https://wowhead.com/item=216467",loc=loc.TOTU}, --lookup!
      {id=216468,link="https://wowhead.com/item=216468",loc=loc.TOTH},
      {id=216469,link="https://wowhead.com/item=216469",loc=loc.TOTU}, --lookup!
      {id=216470,link="https://wowhead.com/item=216470",loc=loc.WILD}, --lookup!
      {id=216471,link="https://wowhead.com/item=216471",loc=loc.JADE}, --lookup!
      {id=216472,link="https://wowhead.com/item=216472",loc=loc.FOUR}, --lookup!
      {id=216473,link="https://wowhead.com/item=216473",loc=loc.KLSM},
      {id=224081,link="https://wowhead.com/item=224081",loc=loc.VEND}, --lookup!
   }},
   { type = equip.DAGGER, items = {
      -- Jinyu daggers don't seem to be available
      {id=215565,link="https://wowhead.com/item=215565",loc=loc.UNKNOWN}, --lookup!
      {id=215566,link="https://wowhead.com/item=215566",loc=loc.UNKNOWN}, --lookup!
      {id=215567,link="https://wowhead.com/item=215567",loc=loc.UNKNOWN}, --lookup!
      {id=215568,link="https://wowhead.com/item=215568",loc=loc.UNKNOWN}, --lookup!
      {id=215569,link="https://wowhead.com/item=215569",loc=loc.SOOU}, --lookup!
      {id=215570,link="https://wowhead.com/item=215570",loc=loc.SOON}, --lookup!
      {id=215571,link="https://wowhead.com/item=215571",loc=loc.SOOU}, --lookup!
      {id=215572,link="https://wowhead.com/item=215572",loc=loc.SOOR},
      {id=215573,link="https://wowhead.com/item=215573",loc=loc.SOOR}, --lookup!
      {id=215574,link="https://wowhead.com/item=215574",loc=loc.SOON}, --lookup!
      {id=215575,link="https://wowhead.com/item=215575",loc=loc.SOOH}, --lookup!
      {id=215576,link="https://wowhead.com/item=215576",loc=loc.SOOU}, --lookup!
      {id=215577,link="https://wowhead.com/item=215577",loc=loc.SOOR}, --lookup!
      {id=215578,link="https://wowhead.com/item=215578",loc=loc.SOON}, --lookup!
      {id=215579,link="https://wowhead.com/item=215579",loc=loc.SOOH}, --lookup!
      {id=215580,link="https://wowhead.com/item=215580",loc=loc.SOOU},
      {id=215581,link="https://wowhead.com/item=215581",loc=loc.FEAR}, --lookup!
      {id=215582,link="https://wowhead.com/item=215582",loc=loc.FEAU}, --lookup!
      {id=215583,link="https://wowhead.com/item=215583",loc=loc.FEAN}, --lookup!
      {id=215584,link="https://wowhead.com/item=215584",loc=loc.FEAU},
      {id=215585,link="https://wowhead.com/item=215585",loc=loc.FEAU}, --lookup!
      {id=215586,link="https://wowhead.com/item=215586",loc=loc.FEAU}, --lookup!
      {id=215587,link="https://wowhead.com/item=215587",loc=loc.FEAU}, --lookup!
      {id=215588,link="https://wowhead.com/item=215588",loc=loc.FEAU},
      {id=215589,link="https://wowhead.com/item=215589",loc=loc.FEAU},
      {id=215591,link="https://wowhead.com/item=215591",loc=loc.FEAU}, --lookup!
      {id=215592,link="https://wowhead.com/item=215592",loc=loc.FEAU}, --lookup!
      {id=215593,link="https://wowhead.com/item=215593",loc=loc.FEAU}, --lookup!
      {id=215594,link="https://wowhead.com/item=215594",loc=loc.KREB}, --lookup!
      {id=215595,link="https://wowhead.com/item=215595",loc=loc.JFTL}, --lookup!
      {id=215596,link="https://wowhead.com/item=215596",loc=loc.V4DW}, --lookup!
      {id=215597,link="https://wowhead.com/item=215597",loc=loc.KLIS}, --lookup!
      -- blizzard intern messed up the item id order again :p (and there's only 3 models?)
      {id=215590,link="https://wowhead.com/item=215590",loc=loc.JFTL}, --lookup!
      {id=215598,link="https://wowhead.com/item=215598",loc=loc.V4DW}, --lookup!
      {id=215599,link="https://wowhead.com/item=215599",loc=loc.KREB}, --lookup!
      {id=215600,link="https://wowhead.com/item=215600",loc=loc.V4DW}, --lookup!
      {id=215601,link="https://wowhead.com/item=215601",loc=loc.JFTL}, --lookup!
      {id=215602,link="https://wowhead.com/item=215602",loc=loc.KREB}, --lookup!
      {id=215603,link="https://wowhead.com/item=215603",loc=loc.KLIS}, --lookup!
      {id=215604,link="https://wowhead.com/item=215604",loc=loc.DUNN},
      {id=215605,link="https://wowhead.com/item=215605",loc=loc.DUNH}, --lookup!
      {id=215606,link="https://wowhead.com/item=215606",loc=loc.SCEN}, --lookup!
      {id=215607,link="https://wowhead.com/item=215607",loc=loc.SCEH},
      {id=215608,link="https://wowhead.com/item=215608",loc=loc.DUNN}, --lookup!
      {id=215609,link="https://wowhead.com/item=215609",loc=loc.DUNH},
      {id=215610,link="https://wowhead.com/item=215610",loc=loc.SCEN},
      {id=215611,link="https://wowhead.com/item=215611",loc=loc.SCEH},
      {id=215612,link="https://wowhead.com/item=215612",loc=loc.DUNN},
      {id=215613,link="https://wowhead.com/item=215613",loc=loc.DUNH}, --lookup!
      {id=215614,link="https://wowhead.com/item=215614",loc=loc.SCEN},
      {id=215615,link="https://wowhead.com/item=215615",loc=loc.SCEH},
      {id=215616,link="https://wowhead.com/item=215616",loc=loc.STEP},
      {id=215617,link="https://wowhead.com/item=215617",loc=loc.DWST},
      {id=215618,link="https://wowhead.com/item=215618",loc=loc.VALE},
      {id=215619,link="https://wowhead.com/item=215619",loc=loc.ISLE},
      {id=215620,link="https://wowhead.com/item=215620",loc=loc.VALE},
      {id=215621,link="https://wowhead.com/item=215621",loc=loc.STEP},
      {id=215622,link="https://wowhead.com/item=215622",loc=loc.DWST},
      {id=215623,link="https://wowhead.com/item=215623",loc=loc.ISLE},
      {id=215624,link="https://wowhead.com/item=215624",loc=loc.TOTU}, --lookup!
      {id=215625,link="https://wowhead.com/item=215625",loc=loc.TOTR},
      {id=215626,link="https://wowhead.com/item=215626",loc=loc.TOTR},
      {id=215627,link="https://wowhead.com/item=215627",loc=loc.TOTR},
      {id=216404,link="https://wowhead.com/item=216404",loc=loc.TOTU}, --lookup!
      {id=216405,link="https://wowhead.com/item=216405",loc=loc.TOTN},
      {id=216406,link="https://wowhead.com/item=216406",loc=loc.TOTU}, --lookup!
      {id=216407,link="https://wowhead.com/item=216407",loc=loc.TOTU}, --lookup!
      {id=216408,link="https://wowhead.com/item=216408",loc=loc.TOTU}, --lookup!
      {id=216409,link="https://wowhead.com/item=216409",loc=loc.TOTU}, --lookup!
      {id=216410,link="https://wowhead.com/item=216410",loc=loc.TOTU}, --lookup!
      {id=216411,link="https://wowhead.com/item=216411",loc=loc.TOTU}, --lookup!
      {id=216412,link="https://wowhead.com/item=216412",loc=loc.TOTU}, --lookup!
      {id=216413,link="https://wowhead.com/item=216413",loc=loc.TOTN},
      {id=216414,link="https://wowhead.com/item=216414",loc=loc.TOTU}, --lookup!
      {id=216415,link="https://wowhead.com/item=216415",loc=loc.TOTU}, --lookup!
      {id=216416,link="https://wowhead.com/item=216416",loc=loc.TOTU}, --lookup!
      {id=216417,link="https://wowhead.com/item=216417",loc=loc.TOTU}, --lookup!
      {id=216418,link="https://wowhead.com/item=216418",loc=loc.TOTU}, --lookup!
      {id=216419,link="https://wowhead.com/item=216419",loc=loc.TOTU}, --lookup!
      {id=224077,link="https://wowhead.com/item=224077",loc=loc.TOTU}, --lookup!
   }},
   { type = equip.FIST, items = {
      {id=215628,link="https://wowhead.com/item=215628",loc=loc.SOOR}, --lookup!
      {id=215629,link="https://wowhead.com/item=215629",loc=loc.SOON},
      {id=215630,link="https://wowhead.com/item=215630",loc=loc.SOOH}, --lookup!
      {id=215631,link="https://wowhead.com/item=215631",loc=loc.SOOU}, --lookup!
      {id=215632,link="https://wowhead.com/item=215632",loc=loc.FEAR}, --lookup!
      {id=215633,link="https://wowhead.com/item=215633",loc=loc.FEAN}, --lookup!
      {id=215634,link="https://wowhead.com/item=215634",loc=loc.FEAH}, --lookup!
      {id=215635,link="https://wowhead.com/item=215635",loc=loc.FEAR}, --lookup!
      {id=215636,link="https://wowhead.com/item=215636",loc=loc.FEAR}, --lookup!
      {id=215637,link="https://wowhead.com/item=215637",loc=loc.FEAN}, --lookup!
      {id=215638,link="https://wowhead.com/item=215638",loc=loc.FEAH}, --lookup!
      {id=215639,link="https://wowhead.com/item=215639",loc=loc.V4DW}, --lookup!
      {id=215640,link="https://wowhead.com/item=215640",loc=loc.KREB}, --lookup!
      {id=215641,link="https://wowhead.com/item=215641",loc=loc.JFTL}, --lookup!
      {id=215642,link="https://wowhead.com/item=215642",loc=loc.V4DW}, --lookup!
      {id=215643,link="https://wowhead.com/item=215643",loc=loc.KREB}, --lookup!
      {id=215644,link="https://wowhead.com/item=215644",loc=loc.KLIS},
      {id=215645,link="https://wowhead.com/item=215645",loc=loc.DUNN}, --lookup!
      {id=215646,link="https://wowhead.com/item=215646",loc=loc.DUNH}, --lookup!
      {id=215647,link="https://wowhead.com/item=215647",loc=loc.SCEN}, --lookup!
      {id=215648,link="https://wowhead.com/item=215648",loc=loc.SCEH}, --lookup!
      {id=215649,link="https://wowhead.com/item=215649",loc=loc.DWST},
      {id=215650,link="https://wowhead.com/item=215650",loc=loc.STEP},
      {id=215651,link="https://wowhead.com/item=215651",loc=loc.VALE},
      {id=215652,link="https://wowhead.com/item=215652",loc=loc.TOTU}, --lookup!
      {id=215653,link="https://wowhead.com/item=215653",loc=loc.TOTR},
      {id=215654,link="https://wowhead.com/item=215654",loc=loc.TOTU}, --lookup!
      {id=215655,link="https://wowhead.com/item=215655",loc=loc.TOTU}, --lookup!
      {id=216400,link="https://wowhead.com/item=216400",loc=loc.TOTU}, --lookup!
      {id=216401,link="https://wowhead.com/item=216401",loc=loc.TOTU}, --lookup!
      {id=216402,link="https://wowhead.com/item=216402",loc=loc.TOTH},
      {id=216403,link="https://wowhead.com/item=216403",loc=loc.TOTU}, --lookup!
   }},
   { type = equip.POLEARM, items = {
      {id=215791,link="https://wowhead.com/item=215791",loc=loc.FEAR},
      {id=215792,link="https://wowhead.com/item=215792",loc=loc.FEAN}, --lookup!
      {id=215793,link="https://wowhead.com/item=215793",loc=loc.FEAH}, --lookup!
      {id=215794,link="https://wowhead.com/item=215794",loc=loc.SOOR}, --lookup!
      {id=215795,link="https://wowhead.com/item=215795",loc=loc.SOON}, --lookup!
      {id=215796,link="https://wowhead.com/item=215796",loc=loc.SOOH}, --lookup!
      {id=215797,link="https://wowhead.com/item=215797",loc=loc.SOOU}, --lookup!
      {id=215798,link="https://wowhead.com/item=215798",loc=loc.FEAR},
      {id=215799,link="https://wowhead.com/item=215799",loc=loc.FEAN}, --lookup!
      {id=215800,link="https://wowhead.com/item=215800",loc=loc.FEAH}, --lookup!
      {id=215801,link="https://wowhead.com/item=215801",loc=loc.FEAU}, --lookup!
      {id=215802,link="https://wowhead.com/item=215802",loc=loc.KREB}, --lookup!
      {id=215803,link="https://wowhead.com/item=215803",loc=loc.JFTL}, --lookup!
      {id=215804,link="https://wowhead.com/item=215804",loc=loc.V4DW}, --lookup!
      {id=215805,link="https://wowhead.com/item=215805",loc=loc.KLIS}, --lookup!
      {id=215806,link="https://wowhead.com/item=215806",loc=loc.DUNN}, --lookup!
      {id=215807,link="https://wowhead.com/item=215807",loc=loc.DUNH}, --lookup!
      {id=215808,link="https://wowhead.com/item=215808",loc=loc.SCEN},
      {id=215809,link="https://wowhead.com/item=215809",loc=loc.SCEH},
      -- identical to archaeology dig from mainline game
      {id=215810,link="https://wowhead.com/item=215810",loc=loc.UNKNOWN}, --lookup!
      {id=215811,link="https://wowhead.com/item=215811",loc=loc.TOTU}, --lookup!
      {id=215812,link="https://wowhead.com/item=215812",loc=loc.TOTU}, --lookup!
      {id=215813,link="https://wowhead.com/item=215813",loc=loc.TOTU}, --lookup!
      {id=215814,link="https://wowhead.com/item=215814",loc=loc.TOTR},
   }},
   { type = equip.BOW, items = {
      {id=215520,link="https://wowhead.com/item=215520",loc=loc.SOOR}, --lookup!
      {id=215521,link="https://wowhead.com/item=215521",loc=loc.SOON}, --lookup!
      {id=215522,link="https://wowhead.com/item=215522",loc=loc.SOOH},
      {id=215523,link="https://wowhead.com/item=215523",loc=loc.SOOU}, --lookup!
      {id=215524,link="https://wowhead.com/item=215524",loc=loc.SOOR}, --lookup!
      {id=215525,link="https://wowhead.com/item=215525",loc=loc.SOON}, --lookup!
      {id=215526,link="https://wowhead.com/item=215526",loc=loc.SOOH}, --lookup!
      {id=215527,link="https://wowhead.com/item=215527",loc=loc.SOOU},
      {id=215528,link="https://wowhead.com/item=215528",loc=loc.FEAR}, --lookup!
      {id=215529,link="https://wowhead.com/item=215529",loc=loc.FEAN}, --lookup!
      {id=215530,link="https://wowhead.com/item=215530",loc=loc.FEAH},
      {id=215531,link="https://wowhead.com/item=215531",loc=loc.FEAU}, --lookup!
      {id=215532,link="https://wowhead.com/item=215532",loc=loc.KREB}, --lookup!
      {id=215533,link="https://wowhead.com/item=215533",loc=loc.V4DW}, --lookup!
      {id=215534,link="https://wowhead.com/item=215534",loc=loc.KLIS}, --lookup!
      {id=215535,link="https://wowhead.com/item=215535",loc=loc.DUNN}, --lookup!
      {id=215536,link="https://wowhead.com/item=215536",loc=loc.DUNH}, --lookup!
      {id=215537,link="https://wowhead.com/item=215537",loc=loc.SCEN},
      {id=215538,link="https://wowhead.com/item=215538",loc=loc.SCEH}, --lookup!
      {id=215539,link="https://wowhead.com/item=215539",loc=loc.VALE},
      {id=215540,link="https://wowhead.com/item=215540",loc=loc.STEP},
      {id=215541,link="https://wowhead.com/item=215541",loc=loc.DWST},
      {id=215542,link="https://wowhead.com/item=215542",loc=loc.TOTR},
      {id=215543,link="https://wowhead.com/item=215543",loc=loc.TOTN}, --lookup!
      {id=215544,link="https://wowhead.com/item=215544",loc=loc.TOTH}, --lookup!
      {id=215545,link="https://wowhead.com/item=215545",loc=loc.TOTU}, --lookup!
      {id=215546,link="https://wowhead.com/item=215546",loc=loc.TOTU}, --lookup!
      {id=215547,link="https://wowhead.com/item=215547",loc=loc.TOTR},
      {id=215548,link="https://wowhead.com/item=215548",loc=loc.TOTU}, --lookup!
      {id=215549,link="https://wowhead.com/item=215549",loc=loc.TOTU}, --lookup!
      {id=215550,link="https://wowhead.com/item=215550",loc=loc.ISLE},
      {id=224076,link="https://wowhead.com/item=224076",loc=loc.VEND}, --lookup!
   }},
   { type = equip.GUN, items = {
      {id=215690,link="https://wowhead.com/item=215690",loc=loc.SOON}, --lookup!
      {id=215691,link="https://wowhead.com/item=215691",loc=loc.SOOH},
      {id=215692,link="https://wowhead.com/item=215692",loc=loc.SOOU}, --lookup!
      {id=215693,link="https://wowhead.com/item=215693",loc=loc.FEAR}, --lookup!
      {id=215694,link="https://wowhead.com/item=215694",loc=loc.FEAN}, --lookup!
      {id=215695,link="https://wowhead.com/item=215695",loc=loc.FEAH},
      {id=215696,link="https://wowhead.com/item=215696",loc=loc.FEAU}, --lookup!
      {id=215697,link="https://wowhead.com/item=215697",loc=loc.FEAR}, --lookup!
      {id=215698,link="https://wowhead.com/item=215698",loc=loc.FEAN}, --lookup!
      {id=215699,link="https://wowhead.com/item=215699",loc=loc.FEAH}, --lookup!
      {id=215700,link="https://wowhead.com/item=215700",loc=loc.JFTL}, --lookup!
      {id=215701,link="https://wowhead.com/item=215701",loc=loc.V4DW}, --lookup!
      {id=215702,link="https://wowhead.com/item=215702",loc=loc.KREB}, --lookup!
      {id=215703,link="https://wowhead.com/item=215703",loc=loc.KLIS}, --lookup!
      {id=215704,link="https://wowhead.com/item=215704",loc=loc.DUNN}, --lookup!
      {id=215705,link="https://wowhead.com/item=215705",loc=loc.DUNH}, --lookup!
      {id=215706,link="https://wowhead.com/item=215706",loc=loc.SCEN},
      {id=215707,link="https://wowhead.com/item=215707",loc=loc.SCEH}, --lookup!
      {id=215708,link="https://wowhead.com/item=215708",loc=loc.TOTR}, --lookup!
      {id=215709,link="https://wowhead.com/item=215709",loc=loc.TOTN}, --lookup!
      {id=215710,link="https://wowhead.com/item=215710",loc=loc.TOTH},
      {id=215711,link="https://wowhead.com/item=215711",loc=loc.TOTR}, --lookup!
   }},
   { type = equip.CROSSBOW, items = {
      {id=215551,link="https://wowhead.com/item=215551",loc=loc.SOOR}, --lookup!
      {id=215552,link="https://wowhead.com/item=215552",loc=loc.SOON}, --lookup!
      {id=215553,link="https://wowhead.com/item=215553",loc=loc.SOOH}, --lookup!
      {id=215554,link="https://wowhead.com/item=215554",loc=loc.SOOU},
      {id=215555,link="https://wowhead.com/item=215555",loc=loc.FEAR}, --lookup!
      {id=215556,link="https://wowhead.com/item=215556",loc=loc.FEAN},
      {id=215557,link="https://wowhead.com/item=215557",loc=loc.FEAH},
      {id=215558,link="https://wowhead.com/item=215558",loc=loc.JFTL}, --lookup!
      {id=215559,link="https://wowhead.com/item=215559",loc=loc.V4DW}, --lookup!
      {id=215560,link="https://wowhead.com/item=215560",loc=loc.KREB}, --lookup!
      {id=215561,link="https://wowhead.com/item=215561",loc=loc.TOTR}, --lookup!
      {id=215562,link="https://wowhead.com/item=215562",loc=loc.TOTN},
      {id=215563,link="https://wowhead.com/item=215563",loc=loc.TOTH}, --lookup!
      {id=215564,link="https://wowhead.com/item=215564",loc=loc.TOTU}, --lookup!
      {id=216611,link="https://wowhead.com/item=216611",loc=loc.JADE}, --lookup!
      {id=216612,link="https://wowhead.com/item=216612",loc=loc.FOUR}, --lookup!
      {id=216613,link="https://wowhead.com/item=216613",loc=loc.WILD}, --lookup!
      {id=216614,link="https://wowhead.com/item=216614",loc=loc.KLSM},
   }},
   { type = equip.WAND, items = {
      -- mistsmpinner's channel seems to be missing :<
      {id=215994,link="https://wowhead.com/item=215994",loc=loc.UNKNOWN}, --lookup!
      {id=215995,link="https://wowhead.com/item=215995",loc=loc.UNKNOWN}, --lookup!
      {id=215996,link="https://wowhead.com/item=215996",loc=loc.UNKNOWN}, --lookup!
      {id=215997,link="https://wowhead.com/item=215997",loc=loc.FEAR}, --lookup!
      {id=215998,link="https://wowhead.com/item=215998",loc=loc.FEAN}, --lookup!
      {id=215999,link="https://wowhead.com/item=215999",loc=loc.FEAH}, --lookup!
      {id=216000,link="https://wowhead.com/item=216000",loc=loc.FEAU}, --lookup!
      {id=216001,link="https://wowhead.com/item=216001",loc=loc.JFTL},
      {id=216002,link="https://wowhead.com/item=216002",loc=loc.V4DW}, --lookup!
      {id=216003,link="https://wowhead.com/item=216003",loc=loc.KREB}, --lookup!
      {id=216004,link="https://wowhead.com/item=216004",loc=loc.KLIS}, --lookup!
      {id=216005,link="https://wowhead.com/item=216005",loc=loc.DUNN}, --lookup!
      {id=216006,link="https://wowhead.com/item=216006",loc=loc.DUNH},
      {id=216007,link="https://wowhead.com/item=216007",loc=loc.SCEN},
      {id=216008,link="https://wowhead.com/item=216008",loc=loc.SCEH}, --lookup!
      {id=216009,link="https://wowhead.com/item=216009",loc=loc.TOTU}, --lookup!
      {id=216010,link="https://wowhead.com/item=216010",loc=loc.TOTU}, --lookup!
      {id=216011,link="https://wowhead.com/item=216011",loc=loc.TOTU}, --lookup!
      {id=216012,link="https://wowhead.com/item=216012",loc=loc.TOTU}, --lookup!
   }},
   { type = equip.SHIELD, items = {
      {id=216529,link="https://wowhead.com/item=216529",loc=loc.TOTU}, --lookup!
      {id=216530,link="https://wowhead.com/item=216530",loc=loc.ISLE},
      {id=216531,link="https://wowhead.com/item=216531",loc=loc.TOTU}, --lookup!
      {id=216532,link="https://wowhead.com/item=216532",loc=loc.TOTU}, --lookup!
      {id=216533,link="https://wowhead.com/item=216533",loc=loc.VALE},
      {id=216534,link="https://wowhead.com/item=216534",loc=loc.STEP},
      {id=216535,link="https://wowhead.com/item=216535",loc=loc.ISLE},
      {id=216536,link="https://wowhead.com/item=216536",loc=loc.DWST},
      {id=216537,link="https://wowhead.com/item=216537",loc=loc.STEP},
      {id=216538,link="https://wowhead.com/item=216538",loc=loc.DWST},
      {id=216539,link="https://wowhead.com/item=216539",loc=loc.VALE},
      {id=216540,link="https://wowhead.com/item=216540",loc=loc.ISLE},
      {id=216541,link="https://wowhead.com/item=216541",loc=loc.WILD},
      {id=216542,link="https://wowhead.com/item=216542",loc=loc.JADE},
      {id=216543,link="https://wowhead.com/item=216543",loc=loc.KLSM}, --lookup!
      {id=216544,link="https://wowhead.com/item=216544",loc=loc.KLSM}, --lookup!
      {id=216545,link="https://wowhead.com/item=216545",loc=loc.FOUR}, --lookup!
      {id=216546,link="https://wowhead.com/item=216546",loc=loc.SOOR}, --lookup!
      {id=216547,link="https://wowhead.com/item=216547",loc=loc.SOON}, --lookup!
      {id=216548,link="https://wowhead.com/item=216548",loc=loc.SOOH}, --lookup!
      {id=216550,link="https://wowhead.com/item=216550",loc=loc.SOOU}, --lookup!
      {id=216551,link="https://wowhead.com/item=216551",loc=loc.SOOR}, --lookup!
      {id=216552,link="https://wowhead.com/item=216552",loc=loc.SOON}, --lookup!
      {id=216553,link="https://wowhead.com/item=216553",loc=loc.SOOH}, --lookup!
      {id=216554,link="https://wowhead.com/item=216554",loc=loc.SOOU}, --lookup!
      {id=216555,link="https://wowhead.com/item=216555",loc=loc.SOOR}, --lookup!
      {id=216556,link="https://wowhead.com/item=216556",loc=loc.SOON}, --lookup!
      {id=216557,link="https://wowhead.com/item=216557",loc=loc.SOOH}, --lookup!
      {id=216558,link="https://wowhead.com/item=216558",loc=loc.SOOU},
      {id=216559,link="https://wowhead.com/item=216559",loc=loc.FEAR}, --lookup!
      {id=216560,link="https://wowhead.com/item=216560",loc=loc.FEAN}, --lookup!
      {id=216561,link="https://wowhead.com/item=216561",loc=loc.FEAH}, --lookup!
      {id=216562,link="https://wowhead.com/item=216562",loc=loc.FEAU}, --lookup!
      {id=216563,link="https://wowhead.com/item=216563",loc=loc.FEAU}, --lookup!
      {id=216564,link="https://wowhead.com/item=216564",loc=loc.FEAU}, --lookup!
      {id=216565,link="https://wowhead.com/item=216565",loc=loc.FEAU}, --lookup!
      {id=216566,link="https://wowhead.com/item=216566",loc=loc.FEAU},
      {id=216567,link="https://wowhead.com/item=216567",loc=loc.JFTL}, --lookup!
      {id=216568,link="https://wowhead.com/item=216568",loc=loc.V4DW}, --lookup!
      {id=216569,link="https://wowhead.com/item=216569",loc=loc.KLIS}, --lookup!
      -- {id=216569,link="https://wowhead.com/item=216570",loc=loc.KREB}, doesn't exist >_>
      {id=216571,link="https://wowhead.com/item=216571",loc=loc.KREB}, --lookup!
      {id=216572,link="https://wowhead.com/item=216572",loc=loc.JFTL}, --lookup!
      {id=216573,link="https://wowhead.com/item=216573",loc=loc.KREB}, --lookup!
      {id=216574,link="https://wowhead.com/item=216574",loc=loc.JFTL}, --lookup!
      {id=216575,link="https://wowhead.com/item=216575",loc=loc.V4DW}, --lookup!
      {id=216576,link="https://wowhead.com/item=216576",loc=loc.KLIS}, --lookup!
      {id=216577,link="https://wowhead.com/item=216577",loc=loc.DUNN}, --lookup!
      {id=216578,link="https://wowhead.com/item=216578",loc=loc.DUNH}, --lookup!
      {id=216579,link="https://wowhead.com/item=216579",loc=loc.SCEN}, --lookup!
      {id=216580,link="https://wowhead.com/item=216580",loc=loc.SCEH}, --lookup!
      {id=216581,link="https://wowhead.com/item=216581",loc=loc.DUNN},
      {id=216582,link="https://wowhead.com/item=216582",loc=loc.DUNG},
      {id=216583,link="https://wowhead.com/item=216583",loc=loc.SCEN},
      {id=216584,link="https://wowhead.com/item=216584",loc=loc.SCEH},
      {id=216585,link="https://wowhead.com/item=216585",loc=loc.TOTU}, --lookup!
      {id=216586,link="https://wowhead.com/item=216586",loc=loc.TOTU}, --lookup!
      {id=216587,link="https://wowhead.com/item=216587",loc=loc.TOTU}, --lookup!
      {id=216588,link="https://wowhead.com/item=216588",loc=loc.TOTU}, --lookup!
      {id=216589,link="https://wowhead.com/item=216589",loc=loc.TOTU}, --lookup!
      {id=216590,link="https://wowhead.com/item=216590",loc=loc.TOTU}, --lookup!
      {id=216591,link="https://wowhead.com/item=216591",loc=loc.TOTU}, --lookup!
      {id=216592,link="https://wowhead.com/item=216592",loc=loc.TOTU}, --lookup!
      {id=216593,link="https://wowhead.com/item=216593",loc=loc.TOTU}, --lookup!
      {id=216594,link="https://wowhead.com/item=216594",loc=loc.TOTU}, --lookup!
      {id=216595,link="https://wowhead.com/item=216595",loc=loc.TOTU}, --lookup!
      {id=216596,link="https://wowhead.com/item=216596",loc=loc.TOTU},
      {id=216597,link="https://wowhead.com/item=216597",loc=loc.TOTU}, --lookup!
      {id=216598,link="https://wowhead.com/item=216598",loc=loc.TOTU}, --lookup!
      {id=216599,link="https://wowhead.com/item=216599",loc=loc.TOTU}, --lookup!
      {id=216600,link="https://wowhead.com/item=216600",loc=loc.ISLE},
      {id=216601,link="https://wowhead.com/item=216601",loc=loc.ISLE},
      {id=224078,link="https://wowhead.com/item=224078",loc=loc.VEND}, --lookup!
   }},
   { type = equip.OFF_HAND, items = {
      {id=215656,link="https://wowhead.com/item=215656",loc=loc.DWST}, --lookup!
      {id=215657,link="https://wowhead.com/item=215657",loc=loc.STEP},
      {id=215658,link="https://wowhead.com/item=215658",loc=loc.VALE},
      {id=215659,link="https://wowhead.com/item=215659",loc=loc.SOOR}, --lookup!
      {id=215660,link="https://wowhead.com/item=215660",loc=loc.SOON}, --lookup!
      {id=215661,link="https://wowhead.com/item=215661",loc=loc.SOOH}, --lookup!
      {id=215662,link="https://wowhead.com/item=215662",loc=loc.SOOU}, --lookup!
      {id=215663,link="https://wowhead.com/item=215663",loc=loc.SOOR},
      {id=215664,link="https://wowhead.com/item=215664",loc=loc.SOON}, --lookup!
      {id=215665,link="https://wowhead.com/item=215665",loc=loc.SOOH}, --lookup!
      {id=215666,link="https://wowhead.com/item=215666",loc=loc.SOOU}, --lookup!
      {id=215667,link="https://wowhead.com/item=215667",loc=loc.SOOR}, --lookup!
      {id=215668,link="https://wowhead.com/item=215668",loc=loc.SOON}, --lookup!
      {id=215669,link="https://wowhead.com/item=215669",loc=loc.SOOH}, --lookup!
      {id=215670,link="https://wowhead.com/item=215670",loc=loc.SOOU},
      {id=215671,link="https://wowhead.com/item=215671",loc=loc.FEAR}, --lookup!
      {id=215672,link="https://wowhead.com/item=215672",loc=loc.FEAN}, --lookup!
      {id=215673,link="https://wowhead.com/item=215673",loc=loc.FEAH}, --lookup!
      {id=215674,link="https://wowhead.com/item=215674",loc=loc.FEAU}, --lookup!
      {id=215675,link="https://wowhead.com/item=215675",loc=loc.JFTL}, --lookup!
      {id=215676,link="https://wowhead.com/item=215676",loc=loc.V4DW}, --lookup!
      {id=215677,link="https://wowhead.com/item=215677",loc=loc.KREB}, --lookup!
      {id=215678,link="https://wowhead.com/item=215678",loc=loc.KLIS},
      {id=215679,link="https://wowhead.com/item=215679",loc=loc.JFTL}, --lookup!
      {id=215680,link="https://wowhead.com/item=215680",loc=loc.KREB},
      {id=215681,link="https://wowhead.com/item=215681",loc=loc.KLIS}, --lookup!
      {id=215682,link="https://wowhead.com/item=215682",loc=loc.DUNN},
      {id=215684,link="https://wowhead.com/item=215684",loc=loc.DUNH},
      {id=215685,link="https://wowhead.com/item=215685",loc=loc.SCEN}, --lookup!
      {id=215686,link="https://wowhead.com/item=215686",loc=loc.TOTU}, --lookup!
      {id=215687,link="https://wowhead.com/item=215687",loc=loc.TOTU}, --lookup!
      {id=215688,link="https://wowhead.com/item=215688",loc=loc.TOTU},
      {id=215689,link="https://wowhead.com/item=215689",loc=loc.TOTU}, --lookup!
      {id=216438,link="https://wowhead.com/item=216438",loc=loc.JADE},
      {id=216439,link="https://wowhead.com/item=216439",loc=loc.WILD},
      {id=216440,link="https://wowhead.com/item=216440",loc=loc.KLSM},
      {id=216441,link="https://wowhead.com/item=216441",loc=loc.FOUR}, --lookup!
      {id=216442,link="https://wowhead.com/item=216442",loc=loc.JADE},
      {id=216443,link="https://wowhead.com/item=216443",loc=loc.FOUR},
      {id=216444,link="https://wowhead.com/item=216444",loc=loc.WILD},
      {id=216445,link="https://wowhead.com/item=216445",loc=loc.KLSM},
      -- same model as lei-shen off hand, so guessing ToT
      {id=216446,link="https://wowhead.com/item=216446",loc=loc.TOTU}, --lookup!
      {id=216447,link="https://wowhead.com/item=216447",loc=loc.TOTU}, --lookup!
      {id=216448,link="https://wowhead.com/item=216448",loc=loc.TOTU}, --lookup!
      {id=216449,link="https://wowhead.com/item=216449",loc=loc.TOTU}, --lookup!
   }},
}

---@enum
addon.enum.vendorName = {
   world = "Larah Treebender",
   dungeon = "Arturos",
   lfr = "Aeonicus",
   normal = "Durus",
   heroic = "Pythagorus",
   bones = "Pythagorus",
   class = "Grandmaster Jakkus",
}

---@alias collectionID number
---@type {vendor: vendor, items: {id: collectionID, cost: cost, bones: cost?}[]}[]
addon.appearances = {
   { vendor = "world", items = {
      { id = 215219, cost = 2500 },
      { id = 215220, cost = 2500 },
      { id = 215275, cost = 2500 },
      { id = 215276, cost = 2500 },
      { id = 215277, cost = 2500 },
      { id = 215352, cost = 1250 },
      { id = 215353, cost = 1250 },
      { id = 215354, cost = 1250 },
      { id = 215355, cost = 1250 },
      { id = 215238, cost = 1250 },
      { id = 215239, cost = 1250 },
      { id = 215240, cost = 1250 },
      { id = 215285, cost = 1250 },
      { id = 215286, cost = 1250 },
      { id = 215287, cost = 1250 },
      { id = 215356, cost = 1250 },
      { id = 215357, cost = 1250 },
      { id = 215358, cost = 1250 },
      { id = 215183, cost = 750 },
      { id = 215184, cost = 750 },
      { id = 215185, cost = 750 },
      { id = 215225, cost = 750 },
      { id = 215226, cost = 750 },
      { id = 215227, cost = 750 },
      { id = 215228, cost = 750 },
      { id = 215278, cost = 750 },
      { id = 215279, cost = 750 },
      { id = 215280, cost = 750 },
      { id = 215281, cost = 750 },
      { id = 215313, cost = 750 },
      { id = 215314, cost = 750 },
      { id = 215315, cost = 750 },
      { id = 215186, cost = 750 },
      { id = 215187, cost = 750 },
      { id = 215188, cost = 750 },
      { id = 215229, cost = 750 },
      { id = 215230, cost = 750 },
      { id = 215231, cost = 750 },
      { id = 215232, cost = 750 },
      { id = 215282, cost = 750 },
      { id = 215283, cost = 750 },
      { id = 215284, cost = 750 },
      { id = 215316, cost = 750 },
      { id = 215317, cost = 750 },
      { id = 215318, cost = 750 },
      { id = 215319, cost = 750 },
      { id = 215216, cost = 2000 },
      { id = 215217, cost = 2000 },
      { id = 215218, cost = 2000 },
      { id = 215269, cost = 2000 },
      { id = 215270, cost = 2000 },
      { id = 215271, cost = 2000 },
      { id = 215306, cost = 2000 },
      { id = 215307, cost = 2000 },
      { id = 215308, cost = 2000 },
      { id = 215309, cost = 2000 },
      { id = 215349, cost = 2000 },
      { id = 215350, cost = 2000 },
   }},
   { vendor = "dungeon", items = {
      { id = 215176, cost = 2500 },
      { id = 215181, cost = 2500 },
      { id = 215182, cost = 2500 },
      { id = 215221, cost = 2500 },
      { id = 215222, cost = 2500 },
      { id = 215223, cost = 2500 },
      { id = 215224, cost = 2500 },
      { id = 215272, cost = 2500 },
      { id = 215273, cost = 2500 },
      { id = 215274, cost = 2500 },
      { id = 215310, cost = 2500 },
      { id = 215311, cost = 2500 },
      { id = 215312, cost = 2500 },
   }},
   { vendor = "lfr", items = {
      { id = 215189, cost = 5000 },
      { id = 215193, cost = 5000 },
      { id = 215196, cost = 5000 },
      { id = 215199, cost = 5000 },
      { id = 215201, cost = 5000 },
      { id = 215204, cost = 5000 },
      { id = 215208, cost = 5000 },
      { id = 215210, cost = 5000 },
      { id = 215214, cost = 5000 },
      { id = 215241, cost = 5000 },
      { id = 215245, cost = 5000 },
      { id = 215247, cost = 5000 },
      { id = 215252, cost = 5000 },
      { id = 215256, cost = 5000 },
      { id = 215255, cost = 5000 },
      { id = 215261, cost = 5000 },
      { id = 215264, cost = 5000 },
      { id = 215267, cost = 5000 },
      { id = 215289, cost = 5000 },
      { id = 215293, cost = 5000 },
      { id = 215295, cost = 5000 },
      { id = 215298, cost = 5000 },
      { id = 215302, cost = 5000 },
      { id = 215304, cost = 5000 },
      { id = 215320, cost = 5000 },
      { id = 215324, cost = 5000 },
      { id = 215327, cost = 5000 },
      { id = 215330, cost = 5000 },
      { id = 215334, cost = 5000 },
      { id = 215335, cost = 5000 },
      { id = 215339, cost = 5000 },
      { id = 215343, cost = 5000 },
      { id = 215346, cost = 5000 },
   }},
   { vendor = "normal", items = {
      { id = 215191, cost = 5000 },
      { id = 215194, cost = 5000 },
      { id = 215197, cost = 5000 },
      { id = 215198, cost = 5000 },
      { id = 215202, cost = 5000 },
      { id = 215206, cost = 5000 },
      { id = 215209, cost = 5000 },
      { id = 215212, cost = 5000 },
      { id = 215215, cost = 5000 },
      { id = 215243, cost = 5000 },
      { id = 215246, cost = 5000 },
      { id = 215249, cost = 5000 },
      { id = 215251, cost = 5000 },
      { id = 215253, cost = 5000 },
      { id = 215258, cost = 5000 },
      { id = 215260, cost = 5000 },
      { id = 215263, cost = 5000 },
      { id = 215266, cost = 5000 },
      { id = 215288, cost = 5000 },
      { id = 215292, cost = 5000 },
      { id = 215294, cost = 5000 },
      { id = 215297, cost = 5000 },
      { id = 215300, cost = 5000 },
      { id = 215303, cost = 5000 },
      { id = 215321, cost = 5000 },
      { id = 215325, cost = 5000 },
      { id = 215326, cost = 5000 },
      { id = 215329, cost = 5000 },
      { id = 215332, cost = 5000 },
      { id = 215337, cost = 5000 },
      { id = 215341, cost = 5000 },
      { id = 215338, cost = 5000 },
      { id = 215344, cost = 5000 },
      { id = 215347, cost = 5000 },
   }},
   { vendor = "heroic", items = {
      { id = 215190, cost = 5000 },
      { id = 215192, cost = 5000 },
      { id = 215200, cost = 5000 },
      { id = 215203, cost = 5000 },
      { id = 215207, cost = 5000 },
      { id = 215211, cost = 5000 },
      { id = 215242, cost = 5000 },
      { id = 215244, cost = 5000 },
      { id = 215250, cost = 5000 },
      { id = 215254, cost = 5000 },
      { id = 215262, cost = 5000 },
      { id = 215265, cost = 5000 },
      { id = 215290, cost = 5000 },
      { id = 215291, cost = 5000 },
      { id = 215299, cost = 5000 },
      { id = 215301, cost = 5000 },
      { id = 215322, cost = 5000 },
      { id = 215323, cost = 5000 },
      { id = 215331, cost = 5000 },
      { id = 215333, cost = 5000 },
      { id = 215340, cost = 5000 },
      { id = 215342, cost = 5000 },
      { id = 215195, cost = 5000 },
      { id = 215205, cost = 5000 },
      { id = 215213, cost = 5000 },
      { id = 215248, cost = 5000 },
      { id = 215259, cost = 5000 },
      { id = 215268, cost = 5000 },
      { id = 215296, cost = 5000 },
      { id = 215305, cost = 5000 },
      { id = 215328, cost = 5000 },
      { id = 215336, cost = 5000 },
      { id = 215345, cost = 5000 },
   }},
   { vendor = "bones", items = {
      { id = 104399, cost = 8000, bones = 2 },
      { id = 104400, cost = 8000, bones = 2 },
      { id = 104401, cost = 8000, bones = 2 },
      { id = 104402, cost = 8000, bones = 2 },
      { id = 104403, cost = 8000, bones = 2 },
      { id = 104404, cost = 8000, bones = 2 },
      { id = 104405, cost = 8000, bones = 2 },
      { id = 104406, cost = 8000, bones = 2 },
      { id = 104407, cost = 8000, bones = 2 },
      { id = 104408, cost = 8000, bones = 2 },
      { id = 104409, cost = 8000, bones = 2 },
      { id = 224459, cost = 38500, bones = 20 },
   }},
   { vendor = "class", items = {
      { id = 217824, cost = 3000 },
      { id = 217828, cost = 3000 },
      { id = 217829, cost = 3000 },
      { id = 217821, cost = 3000 },
      { id = 217820, cost = 3000 },
      { id = 217823, cost = 3000 },
      { id = 217827, cost = 3000 },
      { id = 217832, cost = 3000 },
      { id = 217831, cost = 3000 },
      { id = 217830, cost = 3000 },
      { id = 217819, cost = 3000 },
      { id = 217826, cost = 3000 },
      { id = 217825, cost = 3000 },
      { id = 217837, cost = 4000 },
      { id = 217843, cost = 4000 },
      { id = 217842, cost = 4000 },
      { id = 217835, cost = 4000 },
      { id = 217834, cost = 4000 },
      { id = 217836, cost = 4000 },
      { id = 217841, cost = 4000 },
      { id = 217846, cost = 4000 },
      { id = 217845, cost = 4000 },
      { id = 217844, cost = 4000 },
      { id = 217833, cost = 4000 },
      { id = 217839, cost = 4000 },
      { id = 217838, cost = 4000 },
   }},
}
