
---@class ns
local addon = select(2, ...)

---@class RemixWeaponsFrame : Frame
---@field ScrollBox Frame
---@field ScrollBar Frame
---@field CloseButton Button
RemixWeaponsFrameMixin = {}

local DataProvider = CreateTreeDataProvider()
local ScrollView = CreateScrollBoxListTreeListView()
function RemixWeaponsFrameMixin:OnLoad()

   ScrollView:SetDataProvider(DataProvider)

   ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, ScrollView)
   local withBar = {
      CreateAnchor("TOPLEFT", self, "TOPLEFT", 10, -22),
      CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -22, 1)
   }
   local withoutBar = {
      CreateAnchor("TOPLEFT", self, "TOPLEFT", 10, -22),
      CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 1)
   }
   ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, withBar, withoutBar)
end

function RemixWeaponsFrameMixin:OnEvent()
end

local function Initializer(frame, node)
   node:SetCollapsed(true, true)
   frame:SetText(node:GetData().ButtonText)
   frame:SetScript("OnClick", function()
      local data = node:GetData()
      if data.topLevel and not data.loaded then
         local continuable = ContinuableContainer:Create()
         for itemID in pairs(addon.weapons[node:GetData().key]) do
            continuable:AddContinuable(Item:CreateFromItemID(itemID))
         end
         continuable:ContinueOnLoad(function()
            for itemID, loc in pairs(addon.weapons[node:GetData().key]) do
               local tooltip = C_TooltipInfo.GetItemByID(itemID)
               print(tooltip.hyperlink)
               local appearanceKnown = true
               for i = #tooltip.lines, 1, -1 do
                  local line = tooltip.lines[i]
                  if (line.leftText and line.leftText:find(TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN)) or (line.rightText and line.rightText:find(TRANSMOGRIFY_TOOLTIP_APPEARANCE_UNKNOWN)) then
                     appearanceKnown = false
                     break
                  end
               end
               node:Insert({
                  ButtonText = tooltip.hyperlink .. " " .. loc .. " " .. (appearanceKnown and ":)" or ":("),
                  key = itemID
               })
            end
            data.loaded = true
         end)
      end
      node:ToggleCollapsed()
      print("Clicked", node:GetData().key)
   end)
end

local function CustomFactory(factory, node)
   factory("UIPanelButtonTemplate", Initializer)
end

ScrollView:SetElementFactory(CustomFactory)


for equip in pairs(addon.weapons) do
   local topLevelData = {
      ButtonText = addon.enum.equipName[equip] or ("Invalid Equip type %q"):format(equip or "UNKNOWN"),
      topLevel = true,
      key = equip
   }
   DataProvider:Insert(topLevelData)
   
end

