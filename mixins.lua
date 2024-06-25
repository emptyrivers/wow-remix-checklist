

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

   self.scrollView:SetElementFactory(function(factory, node)
      factory(node:GetData().template, initializer)
   end)

   self:RegisterEvent("PLAYER_REGEN_ENABLED")
end

function RemixChecklistFrameMixin:OnUpdate()
   if ns.invalidate and not InCombatLockdown() then
      ns.invalidate = false
      self.dataProvider:Invalidate()
   end
end

function RemixChecklistFrameMixin:OnEvent(event)
   if event == "PLAYER_REGEN_ENABLED" then
      if ns.invalidate and self:IsShown() then
         ns.invalidate = false
         self.dataProvider:Invalidate()
      end
   end
end

function RemixChecklistFrameMixin:OnShow()
   print('showing')
   if self.dataProvider:GetSize(true) == 0 then
      self:Populate()
   end
end

function RemixChecklistFrameMixin:Populate()
   local root = ns.cache.node:Ensure('root', ns.data) --[[@as NodeCache]]
   self:SetTitleFormatted("Remix Checklist - %d/%d (%s%d/%d), %d|T4638724:0|t",
      root.learned,
      root.total,
      CreateAtlasMarkup("ChromieTime-32x32"),
      root.fomoLearned,
      root.fomoTotal,
      root.cost or 0
   )
   for _, node in ipairs(root.children) do
      self.dataProvider:Insert(node, true)
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
---@field node TreeNode
---@field data NodeCache
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
   self.data = data
   self.title:SetText(self.data.static.data.title) --- maybe i should rework that structure....
   if self.data.cost then
      self.bronze:SetFormattedText("%d|T4638724:0|t", self.data.cost)
   else
      self.bronze:SetText("")
   end
   self.progress:SetFormattedText("%d/%d (%.1f%%)",
      self.data.learned,
      self.data.total,
      self.data.learned / self.data.total * 100
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
   local ezpectedSize = (self.data.children and #self.data.children or 0) + (self.data.items and #self.data.items or 0)
   if self.node:GetSize() ~= ezpectedSize then
      if self.data.children then
         for _, childData in ipairs(self.data.children) do
            self.node:Insert(childData)
         end
      end
      if self.data.items then
         for _, itemData in ipairs(self.data.items) do
            self.node:Insert(itemData)
         end
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

---@class RemixCheckListTreeNodeWeaponTypeMixin : RemixCheckListTreeNodeMixin
---@field lootOn FontString
RemixCheckListTreeNodeWeaponTypeMixin = {}

function RemixCheckListTreeNodeWeaponTypeMixin:Init(node)
   RemixCheckListTreeNodeMixin.Init(self, node)
   ---@type equip
   local weaponType = self.data.static.data.type
   self.lootOn:SetText(ns:GenerateLootString(weaponType))
   if ns:IsLootable(weaponType) then
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
---@field node TreeNode
---@field data LeafCache
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
   self.node = node
   self.data = data
   self.icon:SetAtlas(self.data.has and "common-icon-checkmark" or "common-icon-redx")
   local lootable = self.data.static.type ~= nil and ns:IsLootable(self.data.static.type)
   if not lootable then
      self.icon:SetDesaturated(true)
   else
      self.icon:SetDesaturated(false)
   end
   self.itemLink:SetText((self.data.static.fomo and CreateAtlasMarkup("ChromieTime-32x32") or "") .. self.data.cache.link)
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
   self.bronze:SetFormattedText("%d|T4638724:0|t", self.data.static.cost)
end

---@class RemixCheckListLeafNodeAppearanceMixin : RemixCheckListLeafNodeBaseMixin
---@field bronze FontString
---@field slots FontString
RemixCheckListLeafNodeAppearanceMixin = {}

function RemixCheckListLeafNodeAppearanceMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.bronze:SetFormattedText("%d|T4638724:0|t", self.data.static.cost)
   self.slots:SetFormattedText("%d/%d", self.data.cache.cache.learned, self.data.cache.cache.total)
end

---@class RemixCheckListLeafNodeBoneMixin : RemixCheckListLeafNodeBaseMixin
---@field bones FontString
---@field bronze FontString
RemixCheckListLeafNodeBoneMixin = {}

function RemixCheckListLeafNodeBoneMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.bones:SetFormattedText("%d|T1508519:0|t", self.data.static.bones)
   self.bronze:SetFormattedText("%d|T4638724:0|t", self.data.static.cost)
end

---@class RemixCheckListLeafNodeCurrencyMixin : RemixCheckListLeafNodeBaseMixin
---@field location FontString
RemixCheckListLeafNodeWeaponTypeMixin = {}

function RemixCheckListLeafNodeWeaponTypeMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   self.location:SetText(self.data.static.loc)
end

---@class RemixCheckListLeafNodeWeaponLocMixin : RemixCheckListLeafNodeBaseMixin
---@field lootOn FontString
RemixCheckListLeafNodeWeaponLocMixin = {}

function RemixCheckListLeafNodeWeaponLocMixin:Init(node)
   RemixCheckListLeafNodeBaseMixin.Init(self, node)
   local lootOn = ns:GenerateLootString(self.data.static.type)
   self.lootOn:SetText(lootOn)
end
