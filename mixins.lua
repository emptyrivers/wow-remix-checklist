

---@class ns
local ns = select(2, ...)

---@class RemixChecklistFrame : Frame
---@field ScrollBox Frame
---@field ScrollBar Frame
---@field CloseButton Button
RemixChecklistFrameMixin = {}

function RemixChecklistFrameMixin:OnLoad()
   self.dataProvider = CreateTreeDataProvider()
   self.scrollView = CreateScrollBoxListTreeListView()
   self.dataProvider:CollapseAll()
   self.scrollView:SetDataProvider(self.dataProvider)
   self.ScrollBox:SetShadowsShown(false)
   ScrollUtil.InitScrollBoxListWithScrollBar(self.ScrollBox, self.ScrollBar, self.scrollView)
   local withBar = {
      CreateAnchor("TOPLEFT", self, "TOPLEFT", 5, -22),
      CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -27, 1)
   }
   local withoutBar = {
      CreateAnchor("TOPLEFT", self, "TOPLEFT", 5, -22),
      CreateAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", -7, 1)
   }
   ScrollUtil.AddManagedScrollBarVisibilityBehavior(self.ScrollBox, self.ScrollBar, withBar, withoutBar)
   
   
   local function initializer(frame, node)
      frame:Init(node)
   end

   
   self.scrollView:SetElementFactory(function (factory, node)
      factory(node:GetData().template, initializer)
   end)
   
end

function RemixChecklistFrameMixin:Refresh()
   ns:LoadItemData(function() self:Populate() end)
end

function RemixChecklistFrameMixin:Populate()
   -- todo: maybe someday (next remix season?), consider being more judicious than "eh just yeet everything and start from scratch"
   self.dataProvider:Flush()
   self:SetTitleFormatted("Remix Checklist - %d/%d collected, %d|T4638724:0|t", ns.tree.summary.collected, ns.tree.summary.total, ns.tree.summary.bronze)
   for _, data in ipairs(ns.tree.children) do
      self.dataProvider:Insert(data)
   end
   self.dataProvider:CollapseAll()
end


function RemixChecklistFrameMixin:OnMouseDown()
   self:StartMoving()
end

function RemixChecklistFrameMixin:OnMouseUp()
   self:StopMovingOrSizing()
end

---@class RemixCheckListTreeNodeMixin : Frame
---@field title FontString
---@field progress FontString
---@field CollapseAndExpandButton CheckButton
RemixCheckListTreeNodeMixin = {}

function RemixCheckListTreeNodeMixin:OnLoad()
   self:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8"
   })
   self:SetBackdropColor(0.2, 0.2, 0.2, 0)
end

function RemixCheckListTreeNodeMixin:OnEnter()
   self:SetBackdropColor(0.7, 0.7, 0.7, 0.5)
end

function RemixCheckListTreeNodeMixin:OnLeave()
   self:SetBackdropColor(0, 0, 0, 0)
end

function RemixCheckListTreeNodeMixin:Init(node)
   self.node = node
   local data = node:GetData()
   self.title:SetText(data.summary.title)
   if data.summary.bronze then
      self.bronze:SetFormattedText("%d|T4638724:0|t", data.summary.bronze)
   else
      self.bronze:SetText("")
   end
   self.progress:SetFormattedText("%d/%d (%.1f%%)",
      data.summary.collected,
      data.summary.total,
      data.summary.collected / data.summary.total * 100
   )
   if node.collapsed == nil then
      -- workaround:
      -- TreeDataProvider doesn't support initial collapsed state
      -- fortunately the collapsed field is normally boolean
      -- except when the node is first created
      -- so, we just immediately collapse (without invalidating the layout) if node.collapsed == nil
      node:SetCollapsed(true, nil, true)
   end
   self.CollapseAndExpandButton:SetChecked(node:IsCollapsed())
   self.CollapseAndExpandButton:UpdateOrientation()
end

---@param collapsed boolean
function RemixCheckListTreeNodeMixin:SetCollapsed(collapsed)
   self.collapsed = collapsed
   if self.node:GetData().children and self.node:GetSize() ~= #self.node:GetData().children then
      for _, child in ipairs(self.node:GetData().children) do
         -- annoying that TreeDataProvider doesn't support initial collapsed state
         -- at least we can pass 3rd arg to suppress invalidation until after all children are added
         self.node:Insert(child)--[[ :SetCollapsed(true, nil, true) ]]
      end
   end
   self.node:SetCollapsed(self.collapsed)
   -- self.node:Invalidate()
end

---@class RemixCheckListCollapseAndExpandButtonMixin : CheckButton
RemixCheckListCollapseAndExpandButtonMixin = { }

function RemixCheckListCollapseAndExpandButtonMixin:OnLoad()
	self.orientation = 1
	self.expandDirection = 0

	self:SetChecked(true)
	self:UpdateOrientation()
end

function RemixCheckListCollapseAndExpandButtonMixin:OnClick()
	self:GetParent():SetCollapsed(self:GetChecked())
	self:UpdateOrientation()
end

function RemixCheckListCollapseAndExpandButtonMixin:UpdateOrientation()
	local isChecked = self:GetChecked()
	local rotation

	if self.orientation == 0 then
		local leftRotation = math.pi
		local rightRotation = 0
		if self.expandDirection == 0 then
			rotation = isChecked and leftRotation or rightRotation
		else
			rotation = isChecked and rightRotation or leftRotation
		end

		self:SetSize(15, 30)
	else
		local downRotation = 3 * math.pi / 2
		local upRotation = math.pi / 2
		if self.expandDirection == 0 then
			rotation = isChecked and downRotation or upRotation
		else
			rotation = isChecked and upRotation or downRotation
		end

		self:SetSize(30, 15)
	end

	self:GetNormalTexture():SetRotation(rotation)
	self:GetHighlightTexture():SetRotation(rotation)
	self:GetPushedTexture():SetRotation(rotation)
end

---@class RemixCheckListTreeNodeWeaponMixin : RemixCheckListTreeNodeMixin
---@field lootOn FontString
RemixCheckListTreeNodeWeaponMixin = {}

function RemixCheckListTreeNodeWeaponMixin:Init(node)
   RemixCheckListTreeNodeMixin.Init(self, node)
   local _, class, classID = UnitClass("player")
   local equip = node:GetData().summary.type
   if not ns.enum.class_to_equip[class][equip] then
      self.title:SetTextColor(1, 0, 0)
      local t = {}
      for i = 1, GetNumClasses() do
         local _, c = GetClassInfo(i)
         if not ns.enum.class_to_equip[c] then print(c) end
         if ns.enum.class_to_equip[c][equip] then
            if #t < 4 then
               t[#t + 1] = CreateAtlasMarkup(GetClassAtlas(c:lower()))
            else
               t[#t+ 1] = "..."
               break
            end
         end
      end
      self.lootOn:SetText(table.concat(t))
   else
      self.title:SetTextColor(GameFontNormal:GetTextColor())
      local t = {}
      for i = 1, GetNumSpecializationsForClassID(classID) do
         local id, _, _, icon = GetSpecializationInfoForClassID(classID, i)
         if ns.enum.spec_can_loot[equip][id] then
            if #t < 4 then
               t[#t + 1] = "|T" .. icon .. ":0|t"
            else
               t[#t+ 1] = "..."
               break
            end
         end
      end
      self.lootOn:SetText(table.concat(t))
   end
end

---@class RemixCheckListLeafNodeBaseMixin : Frame
---@field itemLink FontString
---@field icon Texture
RemixCheckListLeafNodeBaseMixin = {}

function RemixCheckListLeafNodeBaseMixin:OnLoad()
   self:SetHyperlinksEnabled(true)
   self:SetBackdrop({
      bgFile = "Interface\\Buttons\\WHITE8x8"
   })
   self:SetBackdropColor(0.2, 0.2, 0.2, 0)
end

function RemixCheckListLeafNodeBaseMixin:OnEnter()
   self:SetBackdropColor(0.7, 0.7, 0.7, 0.5)
end

function RemixCheckListLeafNodeBaseMixin:OnLeave()
   self:SetBackdropColor(0, 0, 0, 0)
end

function RemixCheckListLeafNodeBaseMixin:Init(node)
   self.icon:SetAtlas(node:GetData().summary.has and "common-icon-checkmark" or "common-icon-redx")
   self.itemLink:SetText(node:GetData().summary.link)
end

function RemixCheckListLeafNodeBaseMixin:OnHyperlinkClick(link, _, button)
   -- a truncated hyperlink (pretty common given the width of the itemLink fontstring)
   -- sets second arg to empty string, which seems to break some item ref functions e.g. ctrl click mount links
   -- since not-truncated hyperlinks seem to set the second arg to the full text, we'll just do that ourselves
   SetItemRef(link, self.itemLink:GetText(), button)
end

---@class RemixCheckListLeafNodeGenericMixin : RemixCheckListLeafNodeBaseMixin
---@field bronze FontString
RemixCheckListLeafNodeGenericMixin = {}

function RemixCheckListLeafNodeGenericMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.bronze:SetFormattedText("%d|T4638724:0|t", node:GetData().summary.bronze)
end

---@class RemixCheckListLeafNodeAppearanceMixin : RemixCheckListLeafNodeBaseMixin
---@field bronze FontString
---@field slots FontString
RemixCheckListLeafNodeAppearanceMixin = {}

function RemixCheckListLeafNodeAppearanceMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.bronze:SetFormattedText("%d|T4638724:0|t", node:GetData().summary.bronze)
   self.slots:SetFormattedText("%d/%d", node:GetData().summary.haveSlots, node:GetData().summary.slots)
end

---@class RemixCheckListLeafNodeBoneMixin : RemixCheckListLeafNodeBaseMixin
---@field bones FontString
---@field bronze FontString
RemixCheckListLeafNodeBoneMixin = {}

function RemixCheckListLeafNodeBoneMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.bones:SetFormattedText("%d|T1508519:0|t", node:GetData().summary.bones)
   self.bronze:SetFormattedText("%d|T4638724:0|t", node:GetData().summary.bronze)
end

---@class RemixCheckListLeafNodeCurrencyMixin : RemixCheckListLeafNodeBaseMixin
---@field location FontString
RemixCheckListLeafNodeWeaponMixin = {}

function RemixCheckListLeafNodeWeaponMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.location:SetText(node:GetData().summary.loc)
end
