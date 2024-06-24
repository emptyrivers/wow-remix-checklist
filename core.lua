-- Remix Weapon Tracker is marked with CC0 1.0 Universal. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

---@type string
local name = ...

---@class ns
---@field tree TreeNode
---@field saved Saved
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
      ns:LoadItemData()
   end
end

if LibStub then

   local function getAnchors(frame)
      local x, y = frame:GetCenter()
      if not x or not y then return "CENTER" end
      local hHalf = (x > UIParent:GetWidth()*2/3) and "RIGHT" or (x < UIParent:GetWidth()/3) and "LEFT" or ""
      local vHalf = (y > UIParent:GetHeight()/2) and "TOP" or "BOTTOM"
      return vHalf..hHalf, frame, (vHalf == "TOP" and "BOTTOM" or "TOP")..hHalf
   end

   local icon = LibStub("LibDBIcon-1.0")
   local LDB = LibStub("LibDataBroker-1.1")
   if LDB and icon then
      local db = LDB:NewDataObject("RemixChecklist", {
         type = "data source",
         icon = "interface/targetingframe/unitframeicons",
         OnClick = function(_, button)
            SlashCmdList["REMIXCHECKLIST"]()
         end,
         OnEnter = function(self)
            GameTooltip:SetOwner(self, "ANCHOR_NONE")
            GameTooltip:SetPoint(getAnchors(self))
            GameTooltip:ClearLines()
            GameTooltip:AddLine("Remix Checklist")
            GameTooltip:Show()
         end,
         OnLeave = function()
            GameTooltip:Hide()
         end,
      })
      ---@diagnostic disable-next-line: missing-fields
      icon:Register("RemixChecklist", db, { hide = false })
   end
end

local loader = CreateFrame("frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, event, addon)
   if addon == name then
      self:UnregisterEvent("ADDON_LOADED")
      if type(RemixCheckListSaved) ~= "table" then
         RemixCheckListSaved = {}
      end
      ns.saved = RemixCheckListSaved
      if type(ns.saved.version) ~= "number" or ns.saved.version < 1 then
         ns.saved.version = 1
         ns.saved.options = {
            weaponMode = "type",
            hideCompleted = false,
            hideNonFOMO = false,
            hideUnobtainable = false,
         }
      end
   end
end)


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
   local appearances = 0
   local known = 0
   local seen = {}
   for i, itemData in ipairs(setItems) do
      local sourceID = itemData.itemModifiedAppearanceID
      local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
      if not seen[sourceInfo.visualID] then
         seen[sourceInfo.visualID] = true
         appearances = appearances + 1
         local sources = C_TransmogCollection.GetAllAppearanceSources(sourceInfo.visualID)
         local has = false
         for j = 1, #sources do
            if C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sources[j]) then
               has = true
               break
            end
         end
         if has then
            known = known + 1
         end
      end
   end
   return known == appearances, appearances - known, appearances
end

function ns:CreateItems()
   self.items = {}
   for i, types in ipairs(ns.weapons) do
      for j, weapon in ipairs(types.items) do
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

---@type options
local defaultOptions = {
   weaponMode = "type",
   autoPopulate = true,
   hideCompleted = false,
   hideNonFOMO = false,
   hideUnobtainable = false,
}

---@param ... options
---@return options
local function orDefault(...)
   if select("#", ...) == 0 then
      return defaultOptions
   end
   return CreateFromMixins(defaultOptions, ...)
end

---@param type equip
---@return boolean
function ns:IsLootable(type)
   local _, class = UnitClass("player")
   return ns.enum.class_to_equip[class][type] ~= nil
end

---@param type equip
---@return string
function ns:GenerateLootString(type)
   
   local _, _, classID = UnitClass("player")
   if not self:IsLootable(type) then
      local t = {}
      for i = 1, GetNumClasses() do
         local _, c = GetClassInfo(i)
         if ns.enum.class_to_equip[c][type] then
            if #t < 4 then
               t[#t + 1] = CreateAtlasMarkup(GetClassAtlas(c:lower()))
            else
               t[#t+ 1] = "..."
               break
            end
         end
      end
      return table.concat(t)
   else
      local t = {}
      for i = 1, GetNumSpecializationsForClassID(classID) do
         local id, _, _, icon = GetSpecializationInfoForClassID(classID, i)
         if ns.enum.spec_can_loot[type][id] then
            if #t < 4 then
               t[#t + 1] = "|T" .. icon .. ":0|t"
            else
               t[#t+ 1] = "..."
               break
            end
         end
      end
      return table.concat(t)
   end
end

---@param opts options?
function ns:LoadItemData(opts)
   opts = orDefault(self.saved.options, opts or {})
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
            fomoCollected = 0,
            fomoTotal = 0,
         },
         children = {}
      }
      local weaponsNode = {
         children = {},
         template = "RemixChecklistTreeNodeWeaponTopTemplate",
         summary = {
            title = "Weapons",
            collected = 0,
            total = 0,
            fomoCollected = 0,
            fomoTotal = 0,
            mode = opts.weaponMode,
         }
      }
      table.insert(tree.children, weaponsNode)
      if opts.weaponMode == "type" then
         for i = 1, #ns.weapons do
            local weaponType = ns.weapons[i]
            ---@type TreeNode
            local equipNode = {
               children = {},
               template = "RemixChecklistTreeNodeWeaponTypeTemplate",
               summary = {
                  title = ns.enum.equipName[weaponType.type],
                  collected = 0,
                  total = 0,
                  fomoCollected = 0,
                  fomoTotal = 0,
                  type = weaponType.type,
               }
            }
            table.insert(weaponsNode.children, equipNode)
            for j = 1, #weaponType.items do
               local weapon = weaponType.items[j]
               local _, sourceID = C_TransmogCollection.GetItemInfo(weapon.id)
               local has = isAppearanceKnown(sourceID)
               ---@type LeafNode
               local leaf = {
                  template = "RemixChecklistLeafNodeWeaponTypeTemplate",
                  summary = {
                     link = select(2, C_Item.GetItemInfo(weapon.id)),
                     has = has,
                     loc = weapon.loc,
                     type = weaponType.type,
                     unobtainable = weapon.loc == ns.enum.loc.UNKNOWN and not has,
                     fomo = weapon.fomo,
                  }
               }
               table.insert(equipNode.children, leaf)
               if has or weapon.loc ~= ns.enum.loc.UNKNOWN then
                  tree.summary.total = tree.summary.total + 1
                  weaponsNode.summary.total = weaponsNode.summary.total + 1
                  equipNode.summary.total = equipNode.summary.total + 1
                  if weapon.fomo then
                     tree.summary.fomoTotal = tree.summary.fomoTotal + 1
                     weaponsNode.summary.fomoTotal = weaponsNode.summary.fomoTotal + 1
                     equipNode.summary.fomoTotal = equipNode.summary.fomoTotal + 1
                  end
                  if has then
                     tree.summary.collected = tree.summary.collected + 1
                     weaponsNode.summary.collected = weaponsNode.summary.collected + 1
                     equipNode.summary.collected = equipNode.summary.collected + 1
                     if weapon.fomo then
                        tree.summary.fomoCollected = tree.summary.fomoCollected + 1
                        weaponsNode.summary.fomoCollected = weaponsNode.summary.fomoCollected + 1
                        equipNode.summary.fomoCollected = equipNode.summary.fomoCollected + 1
                     end
                  end
               end
            end
         end
      else
         local counted = {}
         for i = 1, #ns.farmLocs do
            local farmLoc = ns.farmLocs[i]
            ---@type TreeNode
            local locNode = {
               children = {},
               template = "RemixChecklistTreeNodeWeaponLocTemplate",
               summary = {
                  title = farmLoc.loc,
                  collected = 0,
                  total = 0,
               }
            }
            table.insert(weaponsNode.children, locNode)
            for j = 1, #farmLoc.items do
               local weapon = farmLoc.items[j]
               local _, sourceID = C_TransmogCollection.GetItemInfo(weapon.id)
               local has = isAppearanceKnown(sourceID)
               ---@type LeafNode
               local leaf = {
                  template = "RemixChecklistLeafNodeWeaponLocTemplate",
                  summary = {
                     link = select(2, C_Item.GetItemInfo(weapon.id)),
                     has = has,
                     type = weapon.type,
                     loc = farmLoc.loc,
                     unobtainable = (farmLoc.loc == ns.enum.loc.UNKNOWN or not ns:IsLootable(weapon.type)) and not has,
                     fomo = weapon.fomo
                  }
               }
               table.insert(locNode.children, leaf)
               if has or farmLoc.loc ~= ns.enum.equip.UNKNOWN then
                  if not counted[weapon.id] then
                     tree.summary.total = tree.summary.total + 1
                     weaponsNode.summary.total = weaponsNode.summary.total + 1
                  end
                  locNode.summary.total = locNode.summary.total + 1
                  if weapon.fomo then
                     tree.summary.fomoTotal = tree.summary.fomoTotal + 1
                     weaponsNode.summary.fomoTotal = weaponsNode.summary.fomoTotal + 1
                  end
                  if has then
                     if not counted[weapon.id] then
                        tree.summary.collected = tree.summary.collected + 1
                     weaponsNode.summary.collected = weaponsNode.summary.collected + 1
                     end
                     locNode.summary.collected = locNode.summary.collected + 1
                     if weapon.fomo then
                        tree.summary.fomoCollected = tree.summary.fomoCollected + 1
                        weaponsNode.summary.fomoCollected = weaponsNode.summary.fomoCollected + 1
                     end
                  end
               end
               counted[weapon.id] = true
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
            fomoCollected = 0,
            fomoTotal = 0,
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
               fomoCollected = 0,
               fomoTotal = 0,
            }
         }
         table.insert(appearancesNode.children, vendorNode)
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
                     fomo = appearance.fomo,
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
                     slots = slots,
                     fomo = appearance.fomo,
                     type = appearance.type,
                  }
               }
            end
            table.insert(vendorNode.children, leaf)
            tree.summary.total = tree.summary.total + 1
            appearancesNode.summary.total = appearancesNode.summary.total + 1
            vendorNode.summary.total = vendorNode.summary.total + 1
            if appearance.fomo then
               tree.summary.fomoTotal = tree.summary.fomoTotal + 1
               appearancesNode.summary.fomoTotal = appearancesNode.summary.fomoTotal + 1
               vendorNode.summary.fomoTotal = vendorNode.summary.fomoTotal + 1
            end
            if leaf.summary.has then
               tree.summary.collected = tree.summary.collected + 1
               appearancesNode.summary.collected = appearancesNode.summary.collected + 1
               vendorNode.summary.collected = vendorNode.summary.collected + 1
               if appearance.fomo then
                  tree.summary.fomoCollected = tree.summary.fomoCollected + 1
                  appearancesNode.summary.fomoCollected = appearancesNode.summary.fomoCollected + 1
                  vendorNode.summary.fomoCollected = vendorNode.summary.fomoCollected + 1
               end
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
            fomoCollected = 0,
            fomoTotal = 0,
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
               fomo = toy.fomo,
            }
         }
         table.insert(toyNode.children, leaf)
         tree.summary.total = tree.summary.total + 1
         toyNode.summary.total = toyNode.summary.total + 1
         if toy.fomo then
            tree.summary.fomoTotal = tree.summary.fomoTotal + 1
            toyNode.summary.fomoTotal = toyNode.summary.fomoTotal + 1
         end
         if leaf.summary.has then
            tree.summary.collected = tree.summary.collected + 1
            toyNode.summary.collected = toyNode.summary.collected + 1
            if toy.fomo then
               tree.summary.fomoCollected = tree.summary.fomoCollected + 1
               toyNode.summary.fomoCollected = toyNode.summary.fomoCollected + 1
            end
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
            fomoCollected = 0,
            fomoTotal = 0,
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
                  fomo = mount.fomo,
               }
            }
            table.insert(mountNode.children, leaf)
            tree.summary.total = tree.summary.total + 1
            mountNode.summary.total = mountNode.summary.total + 1
            if mount.fomo then
               tree.summary.fomoTotal = tree.summary.fomoTotal + 1
               mountNode.summary.fomoTotal = mountNode.summary.fomoTotal + 1
            end
            if leaf.summary.has then
               tree.summary.collected = tree.summary.collected + 1
               mountNode.summary.collected = mountNode.summary.collected + 1
               if mount.fomo then
                  tree.summary.fomoCollected = tree.summary.fomoCollected + 1
                  mountNode.summary.fomoCollected = mountNode.summary.fomoCollected + 1
               end
            else
               tree.summary.bronze = tree.summary.bronze + leaf.summary.bronze
               mountNode.summary.bronze = mountNode.summary.bronze + leaf.summary.bronze
            end
         end
      end
      self.tree = tree
      if opts.autoPopulate then
         RemixChecklistFrame:Populate()
      end
   end)
end

function ns:BuildOptionsMenu()
   return {
      {
         text = "Group Weapons By:",
         isTitle = true,

      },
      {
         text = "Type",
         func = function()
            ns.saved.options.weaponMode = "type"
            ns:LoadItemData()
         end,
         checked = ns.saved.options.weaponMode == "type",
      },
      {
         text = "Location",
         func = function()
            ns.saved.options.weaponMode = "zone"
            ns:LoadItemData()
         end,
         checked = ns.saved.options.weaponMode == "zone",
      },
      {
         text = "Hide Collected",
         func = function()
            ns.saved.options.hideCompleted = not ns.saved.options.hideCompleted
            ns:LoadItemData()
         end,
         checked = ns.saved.options.hideCompleted,
      },
      {
         text = "Hide unobtainable",
         func = function()
            ns.saved.options.hideUnobtainable = not ns.saved.options.hideUnobtainable
            ns:LoadItemData()
         end,
         checked = ns.saved.options.hideUnobtainable,
      },
      {
         text = "Hide non FOMO items",
         func = function()
            ns.saved.options.hideNonFOMO = not ns.saved.options.hideNonFOMO
            ns:LoadItemData()
         end,
         checked = ns.saved.options.hideNonFOMO,
      },
      {
         text = "",
         isTitle = true,
      },
      {
         text = "Refresh",
         func = function()
            ns:LoadItemData()
         end,
         justifyH = "CENTER",
      }
   }
end

function ns:CreateFilterPredicate()
   local opts = ns.saved.options
   local function isFiltered(data)
      if data.children then
         local filtered = false
         for i = 1, #data.children do
            if isFiltered(data.children[i]) then
               filtered = true
               break
            end
         end
         return filtered
      else
         if opts.hideCompleted and data.summary.has then
            return false
         elseif opts.hideNonFOMO and not data.summary.fomo then
            return false
         elseif opts.hideUnobtainable and (data.summary.loc == ns.enum.loc.UNKNOWN or data.summary.type and not self:IsLootable(data.summary.type)) then
            return false
         end
         return true
      end
   end
   return function(node)
      return isFiltered(node:GetData())
   end
end

--@debug@
DevTool:AddData(ns, "RemixChecklist")
_G.RemixChecklistPrivate = ns
--@end-debug@
