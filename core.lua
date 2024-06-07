-- Remix Weapon Tracker is marked with CC0 1.0 Universal. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

---@type string
local name = ...

---@class ns
---@field data CheckListData
local ns = select(2, ...)

---@class CheckListData
---@field weapons table<equip, table<itemID, WeaponCheckListItem>>
---@field appearances table<vendor, table<itemID, AppearanceCheckListItem>>
---@field toys table<itemID, CheckListItem>
---@field mounts table<itemID, CheckListItem>

---@alias vendor
---| '"world"'
---| '"dungeon"'
---| '"lfr"'
---| '"normal"'
---| '"heroic"'
---| '"bones"'

---@class CheckListItem
---@field link string
---@field has boolean
---@field cost number

---@class WeaponCheckListItem : CheckListItem
---@field location string
---@field cost nil

---@class AppearanceCheckListItem : CheckListItem
---@field remaining number


---@type RemixWeaponsFrame
local RemixWeaponsFrame

SLASH_REMIXWEAPONS1 = "/remixweapons"
SlashCmdList["REMIXWEAPONS"] = function()
   if not RemixWeaponsFrame then
      RemixWeaponsFrame = CreateFrame("Frame", "RemixWeaponsFrame", UIParent, "RemixWeaponsFrameTemplate") --[[@as RemixWeaponsFrame]]
   else
      RemixWeaponsFrame:SetShown(not RemixWeaponsFrame:IsShown())
   end
   if not ns.loaded then
      ns:LoadItemData(function() RemixWeaponsFrame:Populate() end)
   end
end

---@return boolean?, number?
local function hasEnsemble(itemID)
   local setID = C_Item.GetItemLearnTransmogSet(itemID)
   if not setID then return end
   local setItems = C_Transmog.GetAllSetAppearancesByID(setID)
   if not setItems then return end
   local count = 0
   local slotsUnlearned = {}
   for i, itemData in ipairs(setItems) do
      if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(itemData.itemModifiedAppearanceID) then
         if not slotsUnlearned[itemData.invSlot] then
            count = count + 1
         end
         slotsUnlearned[itemData.invSlot] = true
      else
         if slotsUnlearned[itemData.invSlot] then
            count = count - 1
         end
         slotsUnlearned[itemData.invSlot] = nil
      end
   end
   return next(slotsUnlearned) == nil, count
end

function ns:CreateItems()
   self.items = {}
   for _, ids in pairs(ns.weapons) do
      for id in pairs(ids) do
         table.insert(self.items, Item:CreateFromItemID(id))
      end
   end
   for _, ids in pairs(ns.appearances) do
      for _, data in pairs(ids) do
         table.insert(self.items, Item:CreateFromItemID(data[1]))
      end
   end
   for _, mountInfo in pairs(ns.mounts) do
      table.insert(self.items, Item:CreateFromItemID(mountInfo[1]))
   end
   for _, toyInfo in pairs(ns.toys) do
      table.insert(self.items, Item:CreateFromItemID(toyInfo[1]))
   end
end

---@param callback function
function ns:LoadItemData(callback)
   self.loaded = true
   if not self.items then
      self:CreateItems()
   end
   local loader = ContinuableContainer:Create()
   DevTool:AddData(self.items, 'items')
   loader:AddContinuables(self.items)
   loader:ContinueOnLoad(function()
      self.data = {
         weapons = {},
         appearances = {},
         toys = {},
         mounts = {},
      }
      for equip, ids in pairs(ns.weapons) do
         self.data.weapons[equip] = {}
         for id, loc in pairs(ids) do
            self.data.weapons[equip][id] = {
               link = select(2, C_Item.GetItemInfo(id)),
               has = C_TransmogCollection.PlayerHasTransmog(id),
               location = loc
            }
         end
      end
      for vendor, ids in pairs(ns.appearances) do
         self.data.appearances[vendor] = {}
         for _, appearanceInfo in pairs(ids) do
            if vendor == "bones" then
               self.data.appearances[vendor][appearanceInfo[1]] = {
                  link = select(2, C_Item.GetItemInfo(appearanceInfo[1])),
                  has = C_TransmogCollection.PlayerHasTransmog(appearanceInfo[1]),
                  cost = appearanceInfo[2],
                  remaining = appearanceInfo[3],
               }
            else
               local has, remaining = hasEnsemble(appearanceInfo[1])
               self.data.appearances[vendor][appearanceInfo[1]] = {
                  link = select(2, C_Item.GetItemInfo(appearanceInfo[1])),
                  cost = appearanceInfo[2],
                  has = has or false,
                  remaining = remaining or 0,
               }
            end
         end
      end
      for _, toyInfo in pairs(ns.toys) do
         self.data.toys[toyInfo[1]] = {
            link = select(2, C_Item.GetItemInfo(toyInfo[1])),
            has = PlayerHasToy(toyInfo[1]),
            cost = toyInfo[2],
         }
      end
      for _, mountInfo in pairs(ns.mounts) do
         local mountID = C_MountJournal.GetMountFromItem(mountInfo[1]) --[[@as number]]
         if mountID then
            self.data.mounts[mountInfo[1]] = {
               link = select(2, C_Item.GetItemInfo(mountInfo[1])),
               has = select(11, C_MountJournal.GetMountInfoByID(mountID)),
               cost = mountInfo[2],
            }
         end
      end
      DevTool:AddData(self.data, 'collection')
      if callback then
         callback()
      end
   end)
end
