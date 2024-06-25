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

function ns:QueueRedraw()
   self.invalidate = true
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
            ns:QueueRedraw()
         end,
         checked = ns.saved.options.weaponMode == "type",
      },
      {
         text = "Location",
         func = function()
            ns.saved.options.weaponMode = "zone"
            ns:QueueRedraw()
         end,
         checked = ns.saved.options.weaponMode == "zone",
      },
      {
         text = "Hide Collected",
         func = function()
            ns.saved.options.hideCompleted = not ns.saved.options.hideCompleted
            ns:QueueRedraw()
         end,
         checked = ns.saved.options.hideCompleted,
      },
      {
         text = "Hide unobtainable",
         func = function()
            ns.saved.options.hideUnobtainable = not ns.saved.options.hideUnobtainable
            ns:QueueRedraw()
         end,
         checked = ns.saved.options.hideUnobtainable,
      },
      {
         text = "Hide non FOMO items",
         func = function()
            ns.saved.options.hideNonFOMO = not ns.saved.options.hideNonFOMO
            ns:QueueRedraw()
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
            ns:QueueRedraw()
         end,
         justifyH = "CENTER",
      }
   }
end

function ns:CreateFilterPredicate()
   local opts = ns.saved.options
   ---@param data LeafCache
   local function isLeafFiltered(data)
      if data.id == "leaf=215219" then
      end
      if opts.hideCompleted and data.has then
         return false
      elseif opts.hideNonFOMO and not data.static.fomo then
         return false
      elseif opts.hideUnobtainable and (data.static.loc == ns.enum.loc.UNKNOWN or data.static.type and not self:IsLootable(data.static.type)) then
         return false
      end
      return true
   end
   ---@param data NodeCache
   local function isNodeFiltered(data)
      local filteredWeaponNode = opts.weaponMode == "type" and "weaponsByLoc" or "weaponsByType"
      if data.static.id == filteredWeaponNode then
         return false
      end
      if data.children then
         for i, cache in ipairs(data.children) do
            if isNodeFiltered(cache) then
               return true
            end
         end
      end
      if data.items then
         for i, cache in ipairs(data.items) do
            if isLeafFiltered(cache) then
               return true
            end
         end
      end
      return false
   end
   ---@param node TreeNode
   return function(node)
      ---@type CacheData
      local data = node:GetData()
      if data.id:find("node", 1, true) then
         return isNodeFiltered(data --[[@as NodeCache]])
      else
         return isLeafFiltered(data --[[@as LeafCache]])
      end
   end
end

--@debug@
DevTool:AddData(ns, "RemixChecklist")
_G.RemixChecklistPrivate = ns
--@end-debug@
