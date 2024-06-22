

---@class ns
local ns = select(2, ...)

---@class Panel : Frame
---@field titleContainer Frame

---@class RemixChecklistFrame : Panel
---@field ScrollBox Frame
---@field ScrollBar Frame
---@field CloseButton Button
RemixChecklistFrameMixin = {}

function RemixChecklistFrameMixin:OnLoad()
   self.dataProvider = ns:CreateFilterableTreeDataProvider()
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
   ns:LoadItemData()
end

function RemixChecklistFrameMixin:Populate()
   -- todo: maybe someday (next remix season?), consider being more judicious than "eh just yeet everything and start from scratch"
   self.dataProvider:Flush()
   local topSummary = ns.tree.summary
   self:SetTitleFormatted("Remix Checklist - %d/%d (%s%d/%d), %d|T4638724:0|t",
      topSummary.collected,
      topSummary.total,
      CreateAtlasMarkup("ChromieTime-32x32"),
      topSummary.fomoCollected,
      topSummary.fomoTotal,
      topSummary.bronze
   )
   for _, data in ipairs(ns.tree.children) do
      self.dataProvider:Insert(data)
   end
   self.dataProvider:CollapseAll()
   self.dataProvider:SetFilterPredicate(ns:CreateFilterPredicate())
end


function RemixChecklistFrameMixin:OnMouseDown()
   self:StartMoving()
end

function RemixChecklistFrameMixin:OnMouseUp()
   self:StopMovingOrSizing()
end

---@class RemixChecklistOptionsButtonMixin : Button
RemixChecklistOptionsButtonMixin = {}

function RemixChecklistOptionsButtonMixin:OnClick()
   EasyMenu(ns:BuildOptionsMenu(), self:GetParent().OptionsMenu, self:GetParent(), 0, 0, "MENU")
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
RemixCheckListCollapseAndExpandButtonMixin = {}

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

---@class RemixCheckListTreeNodeWeaponTopMixin : RemixCheckListTreeNodeMixin
---@field weaponMode Button
RemixCheckListTreeNodeWeaponTopMixin = {}

function RemixCheckListTreeNodeWeaponTopMixin:Init(node)
   RemixCheckListTreeNodeMixin.Init(self, node)
   self.weaponMode:SetText(node:GetData().summary.mode == "type" and "By Type" or "By Zone")
end

function RemixCheckListTreeNodeWeaponTopMixin:ToggleWeaponMode()
   ns.saved.options.weaponMode = ns.saved.options.weaponMode == "zone" and "type" or "zone"
   ns:LoadItemData()
end

---@class RemixCheckListTreeNodeWeaponTypeMixin : RemixCheckListTreeNodeMixin
---@field lootOn FontString
RemixCheckListTreeNodeWeaponTypeMixin = {}

function RemixCheckListTreeNodeWeaponTypeMixin:Init(node)
   RemixCheckListTreeNodeMixin.Init(self, node)
   self.lootOn:SetText(ns:GenerateLootString(node:GetData().summary.type))
   if ns:IsLootable(node:GetData().summary.type) then
      self.title:SetTextColor(GameFontNormal:GetTextColor())
   else
      self.title:SetTextColor(1, 0, 0)
   end
end

---@class RemixCheckListTreeNodeWeaponLocMixin : RemixCheckListTreeNodeMixin
RemixCheckListTreeNodeWeaponLocMixin = {}

function RemixCheckListTreeNodeWeaponLocMixin:Init(node)
   RemixCheckListTreeNodeMixin.Init(self, node)
   -- self.lootOn:SetText(node:GetData().summary.lootOn)
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
   local data = node:GetData()
   self.icon:SetAtlas(data.summary.has and "common-icon-checkmark" or "common-icon-redx")
   if data.summary.unobtainable then
      self.icon:SetDesaturated(true)
   else
      self.icon:SetDesaturated(false)
   end
   self.itemLink:SetText((data.summary.fomo and CreateAtlasMarkup("ChromieTime-32x32") or "") .. data.summary.link)
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
RemixCheckListLeafNodeWeaponTypeMixin = {}

function RemixCheckListLeafNodeWeaponTypeMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.location:SetText(node:GetData().summary.loc)
end

---@class RemixCheckListLeafNodeWeaponLocMixin : RemixCheckListLeafNodeBaseMixin
---@field lootOn FontString
RemixCheckListLeafNodeWeaponLocMixin = {}

function RemixCheckListLeafNodeWeaponLocMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   local lootOn = ns:GenerateLootString(node:GetData().summary.type)
   self.lootOn:SetText(lootOn)
end
