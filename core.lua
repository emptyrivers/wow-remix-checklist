-- Remix Weapon Tracker is marked with CC0 1.0 Universal. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

---@type string
local name = ...

---@class ns
---@field tree TreeNode
local ns = select(2, ...)

---@type RemixChecklistFrame
local RemixChecklistFrame

SLASH_REMIXCHECKLIST1 = "/remixchecklist"
SLASH_REMIXCHECKLIST2 = "/remixcl"
SLASH_REMIXCHECKLIST3 = "/rmc"
SlashCmdList["REMIXCHECKLIST"] = function()
   if not RemixChecklistFrame then
      RemixChecklistFrame = CreateFrame("Frame", "RemixChecklistFrame", UIParent, "RemixChecklistFrameTemplate") --[[@as RemixChecklistFrame]]
   else
      RemixChecklistFrame:SetShown(not RemixChecklistFrame:IsShown())
   end
   --@debug@
   DevTool:AddData(RemixChecklistFrame, "RemixChecklistFrame")
   --@end-debug@
   if not ns.loaded then
      ns:LoadItemData(function()
         --@debug@
         DevTool:AddData(ns.tree, "RemixChecklistTree")
         --@end-debug@
         RemixChecklistFrame:Populate()
      end)
   end
end

---@return boolean?, number?, number?
local function hasEnsemble(itemID)
   local setID = C_Item.GetItemLearnTransmogSet(itemID)
   if not setID then return end
   local setItems = C_Transmog.GetAllSetAppearancesByID(setID)
   if not setItems then return end
   local count = 0
   local slots = 0
   local slotsSeen = {}
   local slotsUnlearned = {}
   for i, itemData in ipairs(setItems) do
      if not slotsSeen[itemData.invSlot] then
         slotsSeen[itemData.invSlot] = true
         slots = slots + 1
      end
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
   return next(slotsUnlearned) == nil, count, slots
end

function ns:CreateItems()
   self.items = {}
   for i, types in ipairs(ns.weapons) do
      for j, weapon in ipairs(types.items) do
         if not weapon or not weapon.id then
            print("Invalid weapon", i, j, weapon and weapon.id)
         end
         table.insert(self.items, Item:CreateFromItemID(weapon.id))
      end
   end
   for _, vendor in ipairs(ns.appearances) do
      for _, appearance in ipairs(vendor.items) do
         table.insert(self.items, Item:CreateFromItemID(appearance.id))
      end
   end
   for _, toy in pairs(ns.toys) do
      table.insert(self.items, Item:CreateFromItemID(toy.id))
   end
   for _, mount in ipairs(ns.mounts) do
      table.insert(self.items, Item:CreateFromItemID(mount.id))
   end
end

---@param callback function
function ns:LoadItemData(callback)
   self.loaded = true
   if not self.items then
      self:CreateItems()
   end
   local loader = ContinuableContainer:Create()
   loader:AddContinuables(self.items)
   loader:ContinueOnLoad(function()
      ---@type TreeNode
      local tree = {
         template = "dummy",
         summary = {
            title = "Remix CheckList",
            collected = 0,
            total = 0,
            bronze = 0,
         },
         children = {}
      }
      local weaponsNode = {
         children = {},
         template = "RemixChecklistTreeNodeTemplate",
         summary = {
            title = "Weapons",
            collected = 0,
            total = 0,
         }
      }
      table.insert(tree.children, weaponsNode)
      for i = 1, #ns.weapons do
         local weaponType = ns.weapons[i]
         ---@type TreeNode
         local equipNode = {
            children = {},
            template = "RemixChecklistTreeNodeWeaponTemplate",
            summary = {
               title = ns.enum.equipName[weaponType.type],
               collected = 0,
               total = 0,
               type = weaponType.type,
            }
         }
         table.insert(weaponsNode.children, equipNode)
         for j = 1, #weaponType.items do
            local weapon = weaponType.items[j]
            local has = C_TransmogCollection.PlayerHasTransmog(weapon.id)
            ---@type LeafNode
            local leaf = {
               template = "RemixChecklistLeafNodeWeaponTemplate",
               summary = {
                  link = select(2, C_Item.GetItemInfo(weapon.id)),
                  has = has,
                  loc = weapon.loc,
               }
            }
            table.insert(equipNode.children, leaf)
            tree.summary.total = tree.summary.total + 1
            weaponsNode.summary.total = weaponsNode.summary.total + 1
            equipNode.summary.total = equipNode.summary.total + 1
            if has then
               tree.summary.collected = tree.summary.collected + 1
               weaponsNode.summary.collected = weaponsNode.summary.collected + 1
               equipNode.summary.collected = equipNode.summary.collected + 1
            end
         end
      end
      ---@type TreeNode
      local appearancesNode = {
         children = {},
         template = "RemixChecklistTreeNodeTemplate",
         summary = {
            title = "Appearances",
            collected = 0,
            total = 0,
            bronze = 0,
         }
      }
      table.insert(tree.children, appearancesNode)
      for i = 1, #ns.appearances do
         local vendor = ns.appearances[i]
         ---@type TreeNode
         local vendorNode = {
            children = {},
            template = "RemixChecklistTreeNodeTemplate",
            summary = {
               title = ns.enum.vendorName[vendor.vendor],
               collected = 0,
               total = 0,
               bronze = 0,
            }
         }
         table.insert(appearancesNode.children, vendorNode)
         if vendor.vendor == "bones" then
            vendorNode.summary.title = "Bones of Mannorroth"
         end
         for j = 1, #vendor.items do
            local appearance = vendor.items[j]
            ---@type LeafNode
            local leaf
            if vendor.vendor == "bones" then
               leaf = {
                  template = "RemixChecklistLeafNodeBoneTemplate",
                  summary = {
                     link = select(2, C_Item.GetItemInfo(appearance.id)),
                     has = C_TransmogCollection.PlayerHasTransmog(appearance.id),
                     bones = appearance.bones,
                     bronze = appearance.cost,
                  }
               }
            else
               local has, remaining, slots = hasEnsemble(appearance.id)
               leaf = {
                  template = "RemixChecklistLeafNodeAppearanceTemplate",
                  summary = {
                     link = select(2, C_Item.GetItemInfo(appearance.id)),
                     has = has,
                     bronze = appearance.cost,
                     haveSlots = slots - remaining,
                     slots = slots
                  }
               }
            end
            table.insert(vendorNode.children, leaf)
            tree.summary.total = tree.summary.total + 1
            appearancesNode.summary.total = appearancesNode.summary.total + 1
            vendorNode.summary.total = vendorNode.summary.total + 1
            if leaf.summary.has then
               tree.summary.collected = tree.summary.collected + 1
               appearancesNode.summary.collected = appearancesNode.summary.collected + 1
               vendorNode.summary.collected = vendorNode.summary.collected + 1
            else
               tree.summary.bronze = tree.summary.bronze + leaf.summary.bronze
               appearancesNode.summary.bronze = appearancesNode.summary.bronze + leaf.summary.bronze
               vendorNode.summary.bronze = vendorNode.summary.bronze + leaf.summary.bronze
            end
         end
      end
      ---@type TreeNode
      local toyNode = {
         children = {},
         template = "RemixChecklistTreeNodeTemplate",
         summary = {
            title = "Toys",
            collected = 0,
            total = 0,
            bronze = 0,
         }
      }
      table.insert(tree.children, toyNode)
      for i = 1, #ns.toys do
         local toy = ns.toys[i]
         ---@type LeafNode
         local leaf = {
            template = "RemixChecklistLeafNodeGenericTemplate",
            summary = {
               link = select(2, C_Item.GetItemInfo(toy.id)),
               has = PlayerHasToy(toy.id),
               bronze = toy.cost,
            }
         }
         table.insert(toyNode.children, leaf)
         tree.summary.total = tree.summary.total + 1
         toyNode.summary.total = toyNode.summary.total + 1
         if leaf.summary.has then
            tree.summary.collected = tree.summary.collected + 1
            toyNode.summary.collected = toyNode.summary.collected + 1
         else
            tree.summary.bronze = tree.summary.bronze + leaf.summary.bronze
            toyNode.summary.bronze = toyNode.summary.bronze + leaf.summary.bronze
         end
      end
      ---@type TreeNode
      local mountNode = {
         children = {},
         template = "RemixChecklistTreeNodeTemplate",
         summary = {
            title = "Mounts",
            collected = 0,
            total = 0,
            bronze = 0,
         }
      }
      table.insert(tree.children, mountNode)
      for i = 1, #ns.mounts do
         local mount = ns.mounts[i]
         local mountID = C_MountJournal.GetMountFromItem(mount.id) --[[@as number]]
         if mountID then
            ---@type LeafNode
            local leaf = {
               template = "RemixChecklistLeafNodeGenericTemplate",
               summary = {
                  link = select(2, C_Item.GetItemInfo(mount.id)),
                  has = select(11, C_MountJournal.GetMountInfoByID(mountID)),
                  bronze = mount.cost,
               }
            }
            table.insert(mountNode.children, leaf)
            tree.summary.total = tree.summary.total + 1
            mountNode.summary.total = mountNode.summary.total + 1
            if leaf.summary.has then
               tree.summary.collected = tree.summary.collected + 1
               mountNode.summary.collected = mountNode.summary.collected + 1
            else
               tree.summary.bronze = tree.summary.bronze + leaf.summary.bronze
               mountNode.summary.bronze = mountNode.summary.bronze + leaf.summary.bronze
            end
         end
      end
      self.tree = tree
      if callback then
         callback()
      end
   end)
end

--@debug@
DevTool:AddData(ns, "RemixChecklist")
_G.RemixChecklistPrivate = ns
--@end-debug@
