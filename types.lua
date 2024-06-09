---@meta

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
