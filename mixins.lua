
---@class ns
local ns = select(2, ...)

---@class RemixWeaponsFrame : Frame
---@field ScrollBox Frame
---@field ScrollBar Frame
---@field CloseButton Button
RemixWeaponsFrameMixin = {}

function RemixWeaponsFrameMixin:OnLoad()
   self.dataProvider = CreateTreeDataProvider()
   self.scrollView = CreateScrollBoxListTreeListView()
   self.dataProvider:CollapseAll()
   self.scrollView:SetDataProvider(self.dataProvider)

   ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.scrollView)
   local withBar = {
      CreateAnchor("TOPLEFT", self, "TOPLEFT", 10, -22),
      CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -22, 1)
   }
   local withoutBar = {
      CreateAnchor("TOPLEFT", self, "TOPLEFT", 10, -22),
      CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -2, 1)
   }
   ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, withBar, withoutBar)
   
   
   local function Initializer(frame, node)
      frame:SetText(node:GetData().ButtonText)
      frame:SetScript("OnClick", function()
         node:ToggleCollapsed()
      end)
   end
   
   local function CustomFactory(factory, node)
      factory("UIPanelButtonTemplate", Initializer)
   end
   
   self.scrollView:SetElementFactory(CustomFactory)
   
end

function RemixWeaponsFrameMixin:Populate()
   self.dataProvider:Flush()
   local weaponNode = self.dataProvider:Insert({
      ButtonText = "Weapons",
      topLevel = true,
   })

   for equip, checkList in pairs(ns.data.weapons) do
      local equipNode = weaponNode:Insert({
         ButtonText = ns.enum.equipName[equip] or ("Invalid Equip type %q"):format(equip or "UNKNOWN"),
         topLevel = true,
         key = equip
      })
      for id, checkListItem in pairs(checkList) do
         equipNode:Insert({
            ButtonText = checkListItem.link .. " " .. (checkListItem.has and ":)" or ":(") .. " " .. checkListItem.location,
            key = id
         })
      end
   end
   local appearanceNode = self.dataProvider:Insert({
      ButtonText = "Appearances",
      topLevel = true,
   })
   for vendor, checkList in pairs(ns.data.appearances) do
      local equipNode = appearanceNode:Insert({
         ButtonText = vendor,
         key = vendor
      })
      for id, checkListItem in pairs(checkList) do
         equipNode:Insert({
            ButtonText = checkListItem.link .. " " .. (checkListItem.has and ":)" or ":(") .. " " .. checkListItem.remaining .. " " .. checkListItem.cost,
            key = id
         })
      end
   end
   local toyNode = self.dataProvider:Insert({
      ButtonText = "Toys",
      topLevel = true,
   })
   for id, checkListItem in pairs(ns.data.toys) do
      toyNode:Insert({
         ButtonText = checkListItem.link .. " " .. (checkListItem.has and ":)" or ":(") .. " " .. checkListItem.cost,
         key = id
      })
   end
   local mountNode = self.dataProvider:Insert({
      ButtonText = "Mounts",
      topLevel = true,
   })
   for id, checkListItem in pairs(ns.data.mounts) do
      mountNode:Insert({
         ButtonText = checkListItem.link .. " " .. (checkListItem.has and ":)" or ":(") .. " " .. checkListItem.cost,
         key = id
      })
   end
   self.dataProvider:CollapseAll()
end


function RemixWeaponsFrameMixin:OnMouseDown()
   self:StartMoving()
end

function RemixWeaponsFrameMixin:OnMouseUp()
   self:StopMovingOrSizing()
end
