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

local function isAppearanceKnown(sourceID)
   local isKnown = false
   if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
       return true
   else
       local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
       if sourceInfo then
           local visualID = sourceInfo.visualID
           local sources = C_TransmogCollection.GetAllAppearanceSources(visualID)
           for i = 1, #sources do
               if sourceID ~= sources[i] then
                   if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sources[i]) then
                       isKnown = true
                       break
                   end
               end
           end
       end
   end

   return isKnown
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
      if not isAppearanceKnown(itemData.itemModifiedAppearanceID) then
         if not slotsSeen[itemData.invSlot] then
            count = count + 1
            slotsUnlearned[itemData.invSlot] = true
         end
      else
         if slotsUnlearned[itemData.invSlot] then
            count = count - 1
         end
         slotsUnlearned[itemData.invSlot] = nil
      end
      if not slotsSeen[itemData.invSlot] then
         slotsSeen[itemData.invSlot] = true
         slots = slots + 1
      end
   end
   local has = next(slotsUnlearned) == nil
   if not has then
      -- check if the tooltip says "Already known"
      local tooltip = C_TooltipInfo.GetItemByID(itemID)
      if tooltip then
         for i = #tooltip.lines, 1, -1 do
            if tooltip.lines[i].leftText and tooltip.lines[i].leftText:find(ITEM_SPELL_KNOWN, 1, true)
            or tooltip.lines[i].rightText and tooltip.lines[i].rightText:find(ITEM_SPELL_KNOWN, 1, true) then
               has = true
               break
            end
         end
      end   
   end
   return has, count, slots
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

local Datamine = {Transmog={}}
---@param itemModifiedAppearanceID number
---@return number invType
function Datamine.Transmog:GetSlotTypeForAppearanceID(itemModifiedAppearanceID)
   local sourceInfo = C_TransmogCollection.GetSourceInfo(itemModifiedAppearanceID);
   
   return sourceInfo.invType;
end
function Datamine.Transmog:GetSlotIDForAppearanceID(itemModifiedAppearanceID)
   local invType = self:GetSlotTypeForAppearanceID(itemModifiedAppearanceID);
   local invSlot = C_Transmog.GetSlotForInventoryType(invType);
   
   return invSlot;
end
---@param transmogSetID number
---@return table transmogSet
function Datamine.Transmog:GetAppearancesBySlotForSet(transmogSetID)
   local transmogSet = {};
   local setInfo = C_TransmogSets.GetSetInfo(transmogSetID);
   
   transmogSet.ID = setInfo.setID;
   transmogSet.Name = setInfo.name;
   transmogSet.HiddenUntilCollected = setInfo.hiddenUntilCollected;
   transmogSet.Appearances = {};
   transmogSet.Slots = {};
   transmogSet.Defaults = {};
   
   local primaryAppearances = {};
   for _, v in pairs(C_TransmogSets.GetSetPrimaryAppearances(transmogSetID)) do
      primaryAppearances[v.appearanceID] = true;
   end
   
   local sources = C_TransmogSets.GetAllSourceIDs(transmogSetID);
   for _, source in pairs(sources) do
      local isDefault = primaryAppearances[source] or false;
      local invSlot = self:GetSlotIDForAppearanceID(source);
      
      local category = C_TransmogCollection.GetCategoryForItem(source);
      local _, isWeapon, _, canMainHand, canOffHand = C_TransmogCollection.GetCategoryInfo(category);
      
      transmogSet.Appearances[source] = {
         have = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(source),
         IsDefault = isDefault,
         InvSlot = invSlot,
         IsWeapon = isWeapon,
         CanMainHand = canMainHand,
         CanOffhand = canOffHand,
      };
      
      if not transmogSet.Slots[invSlot] then
         transmogSet.Slots[invSlot] = {};
      end
      
      tinsert(transmogSet.Slots[invSlot], source);
      
      if canOffHand then
         if not transmogSet.Slots[INVSLOT_OFFHAND] then
            transmogSet.Slots[INVSLOT_OFFHAND] = {};
         end
         tinsert(transmogSet.Slots[INVSLOT_OFFHAND], source);
      end
      
      transmogSet.Defaults[source] = isDefault;
   end
   
   return transmogSet;
end
-- local itemID = 215187
-- local print = print
-- local loader = ContinuableContainer:Create()
-- loader:AddContinuable(Item:CreateFromItemID(itemID))
-- loader:ContinueOnLoad(function()
--       local setID = C_Item.GetItemLearnTransmogSet(itemID)
--       local slotData = Datamine.Transmog:GetAppearancesBySlotForSet(setID)
      
--       local count = 0
--       local slots = 0
--       local slotsSeen = {}
--       local slotsUnlearned = {}
--       for slot, items in ipairs(slotData.slots) do
--          if not slotsSeen[slot] then
--             slotsSeen[slot] = true
--             slots = slots + 1
--          end
--          for _, appearanceID in ipairs(items) do
            
--             if slotData.Appearances[appearanceID] and not slotData.Appearances[appearanceID].have then
--                if not slotsUnlearned[slot] then
--                   count = count + 1
--                end
--                slotsUnlearned[slot] = true
--             elseif slotData.Appearances[appearanceID] then
--                if slotsUnlearned[slot] then
--                   count = count - 1
--                end
--                slotsUnlearned[slot] = nil
--             else
--                print('unknown appearance ID', appearanceID)
               
--             end
--          end
         
--       end
--    end)
   





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
