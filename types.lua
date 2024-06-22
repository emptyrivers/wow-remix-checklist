---@meta

---@class Saved
---@field version integer
---@field options options

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

---@alias vendor
---| '"world"'
---| '"dungeon"'
---| '"lfr"'
---| '"normal"'
---| '"heroic"'
---| '"bones"'
---| '"class"'

---@class LeafNode
---@field template string
---@field summary any

---@class TreeNode : LeafNode
---@field children (TreeNode | LeafNode)[]

---@class options
---@field weaponMode 'zone' | 'type'
---@field hideCompleted boolean
---@field hideNonFOMO boolean
---@field hideUnobtainable boolean

---@class VendorData
---@field vendor vendor
---@field items ItemData[]

---@alias itemID number
---@alias cost number

---@class ItemData
---@field id itemID
---@field cost cost
---@field bones cost?
---@field fomo boolean?

---@class WeaponData
---@field id itemID
---@field link string
---@field loc loc
---@field fomo boolean?

---@class farmLoc
---@field loc loc
---@field locs loc[]
---@field items {id: number, type: equip}[]
