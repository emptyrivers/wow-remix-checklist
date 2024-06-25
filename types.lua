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

---@class NodeData
---@field id string | number
---@field template string
---@field itemTemplate string?
---@field data any
---@field children NodeData[]?
---@field items ItemData[]?
---@field itemType itemType?

---@class VendorData
---@field vendor vendor
---@field items ItemData[]

---@alias itemID number
---@alias cost number

---@class ItemData
---@field id itemID
---@field cost cost?
---@field bones cost?
---@field fomo boolean?
---@field type equip?
---@field itemType itemType?
---@field loc loc?

---@class farmLoc
---@field loc loc
---@field locs loc[]
---@field items ItemData[]
