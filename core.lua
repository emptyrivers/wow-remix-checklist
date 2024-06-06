-- Remix Weapon Tracker is marked with CC0 1.0 Universal. To view a copy of this license, visit http://creativecommons.org/publicdomain/zero/1.0

---@type string
local name = ...
---@class ns
local ns = select(2, ...)

---@class Panel : Frame
local Panel = CreateFrame("Frame", "RemixWeaponsPanel", UIParent, "DefaultPanelTemplate")
Panel:EnableMouse(true)
Panel:SetMovable(true)
Panel:SetSize(450, 300)
Panel:SetPoint("CENTER")
Panel:Hide()

---@type RemixWeaponsFrame
local RemixWeaponsFrame

SLASH_REMIXWEAPONS1 = "/remixweapons"
SlashCmdList["REMIXWEAPONS"] = function()
   if not RemixWeaponsFrame then
      RemixWeaponsFrame = CreateFrame("Frame", "RemixWeaponsFrame", UIParent, "RemixWeaponsFrameTemplate") --[[@as RemixWeaponsFrame]]
   else
      RemixWeaponsFrame:SetShown(not RemixWeaponsFrame:IsShown())
   end
end


