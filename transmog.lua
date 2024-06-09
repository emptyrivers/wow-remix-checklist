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
---| '"DEATH_KNIGHT"'
---| '"DEMON_HUNTER"'
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
   DEATH_KNIGHT = {
      [equip.PLATE] = true,
      [equip.ONE_H_AXE] = true,
      [equip.TWO_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.TWO_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.TWO_H_MACE] = true,
      [equip.POLEARM] = true,
   },
   DEMON_HUNTER = {
      [equip.LEATHER] = true,
      [equip.ONE_H_AXE] = true,
      [equip.ONE_H_SWORD] = true,
      [equip.FIST] = true,
      [equip.GLAIVES] = true,
   },
   DRUID = {
      [equip.LEATHER] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.ONE_H_MACE] = true,
      [equip.POLEARM] = true,
      [equip.OFF_HAND] = true,
   },
   EVOKER = {
      [equip.CLOTH] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.WAND] = true,
      [equip.OFF_HAND] = true,
   },
   HUNTER = {
      [equip.MAIL] = true,
      [equip.BOW] = true,
      [equip.GUN] = true,
      [equip.CROSSBOW] = true,
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
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.POLEARM] = true,
      [equip.OFF_HAND] = true,
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
      [equip.ONE_H_SWORD] = true,
      [equip.TWO_H_SWORD] = true,
      [equip.ONE_H_MACE] = true,
      [equip.TWO_H_MACE] = true,
      [equip.STAFF] = true,
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.POLEARM] = true,
      [equip.OFF_HAND] = true,
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
      [equip.DAGGER] = true,
      [equip.FIST] = true,
      [equip.POLEARM] = true,
   },
}
addon.enum.class_to_equip = class_to_equip

---@enum loc
local loc = {
   SOO_LFR = "Siege of Ongrimmar (LFR)",
   SOO_N = "Siege of Ongrimmar (Normal)",
   SOO_H = "Siege of Ongrimmar (Heroic)",
   SOO_M = "Siege of Ongrimmar (Mythic)",
   TOT_LFR = "Throne of Thunder (LFR)",
   TOT_N = "Throne of Thunder (Normal)",
   TOT_H = "Throne of Thunder (Heroic)",
   FEAR_LFR = "MSV/HOF/TOES (LFR)",
   FEAR_N = "MSV/HOF/TOES (Normal)",
   FEAR_H = "MSV/HOF/TOES (Heroic)",
   ISLE = "Islands",
   DREAD = "Dread Wastes",
   VALE = "Vale of Eternal Blossoms",
   SUMMIT = "Kun-Lai Summit",
   STEPPES = "Townlong Steppes",
   JADE = "Jade Forest",
   WILDS = "Krasarang Wilds",
   FOUR = "Valley of Four Winds",
   SCENE = "Scenarios",
   DUNG = "Dungeons",
   UNKNOWN = "Unknown",
}
addon.enum.loc = loc

---@alias itemID number

-- data was gathered from wowhead by hand, so it's probably subtly wrong
---@type {type: equip, items: { id: itemID, loc: string}[]}[]
addon.weapons = {
   { type = equip.ONE_H_AXE, items = {
      -- haromm
      { id = 215472, loc = loc.SOO_LFR },
      -- kura-kura
      { id = 215499, loc = loc.TOT_N },
      -- malkorok
      { id = 215476, loc = loc.SOO_LFR },
      -- pandaren
      { id = 216021, loc = loc.SUMMIT },
      { id = 216022, loc = loc.SUMMIT },
      { id = 216024, loc = loc.JADE },
      { id = 216025, loc = loc.FOUR },
      -- yaungol
      { id = 215496, loc = loc.DREAD },
      { id = 215494, loc = loc.VALE },
      { id = 215495, loc = loc.STEPPES },
      -- shellsplitter
      [216015] = loc.TOT_N
   }},
   { type = equip.TWO_H_AXE, items = {
      -- shin-ka
      { id = 215506, loc = loc.FEAR_N },
      -- uroe
      { id = 215517, loc = loc.TOT_LFR },
      -- xal'atoh
      { id = 215501, loc = loc.SOO_LFR },
      -- wallwather
      { id = 215515, loc = loc.ISLE },
      { id = 215513, loc = loc.DREAD },
      { id = 215512, loc = loc.STEPPES },
      { id = 215514, loc = loc.VALE },
   }},
   { type = equip.BOW, items = {
      -- dagryn
      { id = 215522, loc = loc.SOO_H },
      -- fang kung
      { id = 215530, loc = loc.FEAR_H },
      -- hisek
      { id = 215527, loc = loc.SOO_LFR },
      -- jinyu
      { id = 215539, loc = loc.VALE },
      { id = 215540, loc = loc.STEPPES },
      { id = 215541, loc = loc.DREAD },
      -- dawnwatcher
      { id = 215537, loc = loc.SCENE },
      -- miracoran
      { id = 215547, loc = loc.TOT_LFR },
      { id = 215550, loc = loc.ISLE },
      -- tortoiseshell
      { id = 215542, loc = loc.TOT_LFR },
   }},
   { type = equip.CROSSBOW, items = {
      -- death lotus
      { id = 215554, loc = loc.SOO_LFR },
      -- durumu
      { id = 215562, loc = loc.TOT_LFR },
      -- forgotten glory
      { id = 215556, loc = loc.FEAR_N },
      { id = 215557, loc = loc.FEAR_H },
      -- seawatch
      { id = 216614, loc = loc.SUMMIT },
   }},
   { type = equip.DAGGER, items = {
      -- mantid
      { id = 215612, loc = loc.DUNG },
      { id = 215614, loc = loc.SCENE },
      { id = 215615, loc = loc.SCENE },
      -- firescribe
      { id = 215604, loc = loc.DUNG },
      { id = 215607, loc = loc.SCENE },
      -- imperial
      { id = 215621, loc = loc.STEPPES },
      { id = 215622, loc = loc.DREAD },
      { id = 215620, loc = loc.VALE },
      { id = 215623, loc = loc.ISLE },
      -- iron qon
      { id = 216413, loc = loc.TOT_N },
      -- lightdrinker
      { id = 215609, loc = loc.DUNG },
      { id = 215610, loc = loc.SCENE },
      { id = 215611, loc = loc.SCENE },
      -- megaera
      { id = 215625, loc = loc.TOT_LFR },
      { id = 215626, loc = loc.TOT_LFR },
      { id = 215627, loc = loc.TOT_LFR },
      -- norushen
      { id = 215572, loc = loc.SOO_LFR },
      -- pandaren
      { id = 215616, loc = loc.STEPPES },
      { id = 215617, loc = loc.DREAD },
      { id = 215618, loc = loc.VALE },
      { id = 215619, loc = loc.ISLE },
      -- regail
      { id = 215588, loc = loc.FEAR_LFR },
      -- rik'kal
      { id = 215580, loc = loc.SOO_LFR },
      -- sanguine ritual
      { id = 216405, loc = loc.TOT_N },
      -- seven stars
      { id = 215584, loc = loc.FEAR_LFR },
      -- soulsever
      { id = 215589, loc = loc.FEAR_H },
   }},
   { type = equip.FIST, items = {
      -- amun-thoth
      { id = 215653, loc = loc.TOT_LFR },
      -- pandaren
      { id = 215649, loc = loc.DREAD },
      { id = 215650, loc = loc.STEPPES },
      { id = 215651, loc = loc.VALE },
      -- pincers
      { id = 215644, loc = loc.ISLE }, -- ? wowhead claims this is also found in kun-lai summit but that breaks the pattern...
      -- softfoot
      { id = 215629, loc = loc.SOO_N },
      -- tia-tia
      { id = 216402, loc = loc.TOT_H },
   }},
   { type = equip.GUN, items = {
      -- klaxxi
      { id = 215706, loc = loc.SCENE },
      -- kor'kron
      { id = 215691, loc = loc.SOO_H },
      -- quilen
      { id = 215710, loc = loc.TOT_LFR },
      -- taoren
      { id = 215695, loc = loc.FEAR_H },
   }},
   { type = equip.ONE_H_MACE, items = {
      -- acid-spine
      { id = 216425, loc = loc.TOT_LFR },
      -- dark animus
      { id = 215766, loc = loc.TOT_LFR },
      { id = 215767, loc = loc.TOT_N }, -- anyone get the feeling these were thrown in loot tables completely arbitrarily?
      { id = 215768, loc = loc.TOT_LFR },
      -- grummle mace
      { id = 215738, loc = loc.JADE }, -- and also townlong steppes?? what the hell
      -- carapace crusher
      { id = 215757, loc = loc.SCENE },
      -- wasteland basher - btw wowhead has completely different names in these sections, for some reason
      { id = 215745, loc = loc.SUMMIT }, -- and also isles? but summit seems be the more common drop source
      -- galvanized stormcrusher
      { id = 215730, loc = loc.FEAR_LFR }, -- finally back to sane drop locations
      -- hozen
      { id = 215762, loc = loc.DREAD },
      { id = 215763, loc = loc.STEPPES },
      { id = 215764, loc = loc.VALE },
      -- jerthud, Hand of the Savior
      { id = 215770, loc = loc.TOT_N },
      -- kardris' scepter
      { id = 215718, loc = loc.SOO_N },
      -- pandaren (but just the one! apparently pandaren don't much like maces)
      { id = 216423, loc = loc.JADE },
      -- saurok (who like maces much more)
      { id = 215758, loc = loc.STEPPES },
      { id = 215759, loc = loc.DREAD },
      { id = 215760, loc = loc.VALE },
      { id = 215761, loc = loc.ISLE },
      -- Sphere of Immerseus (omg this one is gorgeous)
      { id = 215712, loc = loc.SOO_N },
   }},
   { type = equip.TWO_H_MACE, items = {
      -- Hammer of the Dawn
      { id = 216437, loc = loc.TOT_LFR },
      -- Shado-Pan Maul - BTW wowhead lists only Scholomance & Niuzao/Jade Temples but i suspect that's due to low droprate
      -- & ppl farming on classes that can't loot 2h maces,
      -- I doubt that this one doesn't drop in e.g. Stormstout Brewery
      { id = 215783, loc = loc.DUNG },
   }},
   { type = equip.OFF_HAND, items = {
      -- Hope's Effigy
      { id = 215680, loc = loc.WILDS }, -- and also vale, but wilds seems to be the more common drop location
      -- eye of the hydra
      { id = 215688, loc = loc.TOT_N },
      -- mantid tuning fork (not for salads)
      { id = 215682, loc = loc.DUNG },
      { id = 215684, loc = loc.DUNG },
      -- hozen (these are cute)
      { id = 215657, loc = loc.STEPPES },
      { id = 215658, loc = loc.VALE },
      -- Grummle Lantern
      { id = 215678, loc = loc.SUMMIT }, -- also isle, but summit is definitely more common (and thematic!)
      -- lucky cricket cage
      { id = 215663, loc = loc.SOO_LFR },
      -- pandaren books
      { id = 216438, loc = loc.JADE },
      { id = 216439, loc = loc.WILDS },
      { id = 216440, loc = loc.SUMMIT },
      -- pandaren fan (these have a nice eye motif)
      { id = 216442, loc = loc.JADE },
      { id = 216443, loc = loc.FOUR },  -- wowhead missed this one in their big list, it's a nice red
      { id = 216444, loc = loc.WILDS },
      { id = 216445, loc = loc.SUMMIT },
      -- sha-touched globule
      { id = 215670, loc = loc.SOO_LFR },
   }},
   { type = equip.POLEARM, items = {
      -- Bo-Ris, Spear deze nuts
      { id = 215791, loc = loc.FEAR_N },
      -- Ghostheart (ohhh the "random" names are references to the model that that these are recolors of)
      { id = 215808, loc = loc.SCENE },
      { id = 215809, loc = loc.SCENE },
      -- Qiang's Unbreakable Polearm
      { id = 215798, loc = loc.FEAR_N },
      -- Shan-Dun, Breaker of Courage
      { id = 215814, loc = loc.TOT_LFR },
   }},
   { type = equip.SHIELD, items = {
      -- gays of the ancient
      { id = 216566, loc = loc.FEAR_LFR },
      -- eyes of the doomed
      { id = 216600, loc = loc.ISLE },
      { id = 216601, loc = loc.ISLE },
      -- Shield of the Fallen General (rip nazgrim :( )
      { id = 216558, loc = loc.SOO_LFR },
      -- Ironwood Shields
      { id = 216533, loc = loc.VALE },
      { id = 216534, loc = loc.STEPPES },
      { id = 216535, loc = loc.ISLE },
      { id = 216536, loc = loc.DREAD },
      -- Mogu Lord shields
      { id = 216537, loc = loc.STEPPES },
      { id = 216538, loc = loc.DREAD },
      { id = 216539, loc = loc.VALE },
      { id = 216540, loc = loc.ISLE },
      -- pandaren shields (uggo)
      { id = 216541, loc = loc.WILDS },
      { id = 216542, loc = loc.JADE },
      -- Protection of the Emperor
      { id = 216530, loc = loc.ISLE },
      -- Protectorate
      { id = 216581, loc = loc.DUNG },
      { id = 216582, loc = loc.DUNG }, -- another missed one, with red embroidery
      { id = 216583, loc = loc.SCENE },
      { id = 216584, loc = loc.SCENE }, -- and this too (orange embroidery) - is this N vs H dungeon/scenario?
      -- Bulwark of Twinned Despair (so delicious)
      { id = 216596, loc = loc.TOT_LFR },
   }},
   { type = equip.STAFF, items = {
      -- amberweaver
      { id = 215871, loc = loc.JADE }, -- also from rares in Townlong Steppes(!)
      { id = 215872, loc = loc.WILDS },  -- also from rares in Vale of Eternal Blossoms
      -- Brazier of the Eternal Empire (entirely new model!)
      { id = 215839, loc = loc.FEAR_LFR },
      { id = 215840, loc = loc.FEAR_N },
      { id = 215841, loc = loc.FEAR_H },
      { id = 215842, loc = loc.FEAR_LFR },  -- arbitraryyyyyyyy
      -- caduceus of pure moods
      { id = 216459, loc = loc.SOO_N },
      -- staff of corrupted waters (wowhead did a typo on this one)
      { id = 215818, loc = loc.SOO_N },
      -- Drakebinder's Spire
      { id = 215835, loc = loc.SOO_LFR },
      -- Fearspeaker's Warstaff (new model)
      { id = 215847, loc = loc.FEAR_LFR },
      { id = 215848, loc = loc.FEAR_N },
      { id = 215849, loc = loc.FEAR_H },
      { id = 215850, loc = loc.FEAR_LFR },
      -- Staff of Iron Will
      { id = 215874, loc = loc.DUNG },
      -- Jalak's Spirit Staff
      { id = 215898, loc = loc.TOT_N },
      -- jinyu
      { id = 215894, loc = loc.STEPPES },
      { id = 215895, loc = loc.DREAD },
      { id = 215896, loc = loc.VALE },
      { id = 215897, loc = loc.ISLE },
      -- omg there's so many staffs :<
      -- Rod of the Megantholithic Apparatus
      { id = 215830, loc = loc.SOO_LFR },
      -- Staff of the Monkey King (isn't that just the Brewmaster artifact? minus the keg i guess)
      { id = 216450, loc = loc.UNKNOWN },
      { id = 216451, loc = loc.UNKNOWN },  -- so unknown WH doesn't even include it in their list (it's blue with orange gems)
      { id = 216452, loc = loc.UNKNOWN },
      { id = 216453, loc = loc.UNKNOWN },  -- this one too is unlisted (it's purple with green gems)
      -- Pandaren Staffs
      { id = 216454, loc = loc.UNKNOWN },
      { id = 216455, loc = loc.UNKNOWN },
      { id = 216456, loc = loc.UNKNOWN },
      { id = 216457, loc = loc.UNKNOWN },
      -- Pride's Gays (i will never get tired of the gaze <-> gays joke)
      { id = 215831, loc = loc.SOO_LFR },
      -- Soulwood Spire
      { id = 215887, loc = loc.TOT_N },
      -- Spire of Supremacy
      { id = 215826, loc = loc.SOO_LFR },
      -- Springrain Spire
      { id = 215878, loc = loc.DUNG },
      -- Suen-Wo, Spire of the Rising Sun
      { id = 216468, loc = loc.TOT_H },
      -- Tian Monastery Staff
      { id = 216473, loc = loc.SUMMIT },
      -- Fogspeaker Conduit (torch)
      { id = 215865, loc = loc.WILDS },  -- and Vale rares
      -- Waterspeaker's Staff (new model)
      { id = 215843, loc = loc.FEAR_LFR },
      { id = 215844, loc = loc.FEAR_N },
      { id = 215845, loc = loc.FEAR_H },
      { id = 215846, loc = loc.FEAR_LFR },  -- unlisted by WH, aqua gem & olive flare bits
   }},
   { type = equip.ONE_H_SWORD, items = {
      -- Arcweaver Spellblade (omg it's yellow 😍)
      { id = 215920, loc = loc.SOO_LFR },
      -- Do-tharak, the Foebreaker
      { id = 215908, loc = loc.ISLE },
      -- Qon's Iron decree
      { id = 215964, loc = loc.TOT_LFR },
      -- Klaxxi
      { id = 215903, loc = loc.UNKNOWN },
      -- Loshan, Fear Incarnate
      { id = 215933, loc = loc.FEAR_H },
      -- Shao-Tien Saber
      { id = 215922, loc = loc.SOO_N },
      -- Temple Trainee (love these)
      { id = 216474, loc = loc.WILDS },  -- unlisted, red hilt with gold guard
      { id = 216475, loc = loc.JADE },
      { id = 216476, loc = loc.FOUR },
      { id = 216477, loc = loc.SUMMIT },  -- unlisted, grey hilt with reddish guard
      -- Tian Monastery
      { id = 215957, loc = loc.STEPPES },
      { id = 215958, loc = loc.DREAD },
      { id = 215959, loc = loc.VALE },
      { id = 215960, loc = loc.ISLE },
      -- Xifeng, Longblade of the Guardian
      { id = 215912, loc = loc.SOO_LFR },
   }},
   { type = equip.TWO_H_SWORD, items = {
      -- Greatsword of Fallen Pride (is when lgbtq+ people start discoursing about kink @ pride)
      { id = 215971, loc = loc.SOO_LFR },
      -- Greatsword of the Iron Legion
      { id = 215970, loc = loc.ISLE },  -- ooh, chinese ashbringer
      -- Jinyu Greatswords
      { id = 215987, loc = loc.STEPPES },
      { id = 215988, loc = loc.DREAD },
      { id = 215989, loc = loc.VALE },
      -- Mogu'dar, Blade of the Thousand Slaves
      { id = 215986, loc = loc.SCENE },
      { id = 215983, loc = loc.DUNG },
      -- Pandaren Greatswords
      { id = 216478, loc = loc.FOUR },  -- unlisted, red hilt
      { id = 216479, loc = loc.JADE },  -- unlisted, dark blue hilt
      { id = 216480, loc = loc.FOUR },
      { id = 216481, loc = loc.SUMMIT },
      -- Starslicer
      { id = 215976, loc = loc.FEAR_N },
   }},
   { type = equip.WAND, items = {
      -- Felsoul
      { id = 216001, loc = loc.JADE },  -- and Steppes rares
      -- Mistspinner's Channel
      { id = 215994, loc = loc.UNKNOWN },
      -- Necromantic wands
      { id = 216006, loc = loc.DUNG },
      { id = 216007, loc = loc.SCENE },
   }},
}

---@enum
addon.enum.vendorName = {
   world = "Larah Treebender",
   dungeon = "Arturos",
   lfr = "Aeonicus",
   normal = "Durus",
   heroic = "Pythagorus",
   bones = "Pythagorus"
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
}
