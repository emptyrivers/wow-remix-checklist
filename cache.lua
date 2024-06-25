---@class ns
local ns = select(2, ...)

---@class CacheManager : Frame
local CacheManager = CreateFrame("Frame") do
   ns.cache = CacheManager

   ---@param id string
   function CacheManager:Get(id)
      ---@type string?, string?
      local cache = id:match("^(%w+)=.+$")
      if cache and self[cache] then
         return (self[cache] --[[@as Cache]]).caches[id]
      end
   end

   ---@param caches table<string, CacheData>
   function CacheManager:Invalidate(caches)
      local start = debugprofilestop()
      ---@type table<string, CacheData>
      local toPropogate repeat
         toPropogate = {}
         for id, cache in pairs(caches) do
            local subscribers = cache:Invalidate(nil, true)
            if subscribers then
               for id, subscriber in pairs(subscribers) do
                  toPropogate[id] = subscriber
               end
            end
         end
         caches = toPropogate
      until not next(caches) or debugprofilestop() - start > 5
      if next(caches) then
         self:InvalidateNextFrame(caches)
      end
   end

   function CacheManager:InvalidateNextFrame(cache)
      if not self.nextFrame then
         self.nextFrame = {}
      end
      self.nextFrame[cache.id] = cache
      self:SetScript("OnUpdate", self.OnUpdate)
   end

   function CacheManager:OnUpdate()
      if self.nextFrame then
         self:SetScript("OnUpdate", nil)
         local caches = self.nextFrame
         self.nextFrame = nil
         self:Invalidate(caches)
      end
   end

   CacheManager:SetScript("OnEvent", function(self, event, ...)
      if self[event] then
         self[event](self, ...)
      end
   end)

   CacheManager:RegisterEvent("PLAYER_ENTERING_WORLD")
   function CacheManager:PLAYER_ENTERING_WORLD(isLogin, isReload)
      if isLogin or isReload then
         local loader = ContinuableContainer:Create()
         for _, itemID in ipairs(ns.itemIDs) do
            loader:AddContinuable(Item:CreateFromItemID(itemID))
         end
         loader:ContinueOnLoad(function()
            ns.cache.node:Ensure("root", ns.data)
         end)
      end
   end

   CacheManager:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_ADDED")
   function CacheManager:TRANSMOG_COLLECTION_SOURCE_ADDED(sourceID)
      if self.sources:Exists(sourceID) then
         self:InvalidateNextFrame(self.sources:Ensure(sourceID))
      end
   end

   CacheManager:RegisterEvent("TRANSMOG_COLLECTION_SOURCE_REMOVED")
   function CacheManager:TRANSMOG_COLLECTION_SOURCE_REMOVED(sourceID)
      if self.sources:Exists(sourceID) then
         self:InvalidateNextFrame(self.sources:Ensure(sourceID))
      end
   end

   CacheManager:RegisterEvent("NEW_MOUNT_ADDED")
   function CacheManager:NEW_MOUNT_ADDED(mountID)
      if self.mounts:Exists(mountID) then
         self:InvalidateNextFrame(self.mounts:Ensure(mountID))
      end
   end

   CacheManager:RegisterEvent("NEW_TOY_ADDED")
   function CacheManager:NEW_TOY_ADDED(toyID)
      if self.toys:Exists(toyID) then
         self:InvalidateNextFrame(self.toys:Ensure(toyID))
      end
   end

   CacheManager:RegisterEvent("HEIRLOOMS_UPDATED")
   function CacheManager:HEIRLOOMS_UPDATED(itemID)
      if self.heirlooms:Exists(itemID) then
         self:InvalidateNextFrame(self.heirlooms:Ensure(itemID))
      end
   end
end

---@class CacheData
---@field id string
---@field subscribers table<string, CacheData>
---@field has boolean
local CacheData = {} do
   ---@param id string
   function CacheData:Init(id)
      self.id = id
      self.subscribers = {}
   end

   ---@param name string
   ---@param subscriber CacheData
   function CacheData:AddSubscriber(name, subscriber)
      self.subscribers[name] = subscriber
   end

   ---@param name string
   function CacheData:RemoveSubscriber(name)
      self.subscribers[name] = nil
   end

   ---@param cache CacheData
   function CacheData:Subscribe(cache)
      cache:AddSubscriber(self.id, self)
   end

   ---@param cache CacheData
   function CacheData:Unsubscribe(cache)
      cache:RemoveSubscriber(self.id)
   end

   ---@param invalidator CacheData?
   ---@param skipPropogation boolean?
   function CacheData:Invalidate(invalidator, skipPropogation)
      if skipPropogation then
         return self.subscribers
      else
         for _, subscriber in pairs(self.subscribers) do
            subscriber:Invalidate(self, skipPropogation)
         end
      end
   end
end

---@class Cache
---@field caches table<string, CacheData>
---@field mixin CacheData
---@field name string
local Cache = {} do
   ---@param name string
   ---@param mixin CacheData
   function Cache:Init(name, mixin)
      self.caches = {}
      self.name = name
      self.mixin = mixin
   end

   function Cache:Exists(id)
      return self.caches[id] ~= nil
   end

   ---@param id number | string
   ---@param ... any
   ---@return CacheData
   function Cache:Ensure(id, ...)
      local cacheID = string.format("%s=%s", self.name, id)
      if not self.caches[cacheID] then
         local cache = CreateAndInitFromMixin(self.mixin, cacheID, id, ...)
         self.caches[cacheID] = cache
      end
      return self.caches[cacheID]
   end

   ---@param caches table<string, CacheData>
   ---@return table<string, CacheData>
   function Cache:Invalidate(caches, skipPropogation)
      ---@type table<string, CacheData>
      local toPropogate repeat
         toPropogate = {}
         for _, cache in pairs(caches) do
            local subscribers = cache:Invalidate(nil, true)
            if subscribers then
               for id, subscriber in pairs(subscribers) do
                  toPropogate[id] = subscriber
               end
            end
         end
         caches = toPropogate
      until skipPropogation or not next(caches)
      return caches
   end
end

do -- counter
   ---@class CounterCache : CacheData
   ---@field fields string[][]
   ---@field cache table<CacheData, boolean>
   ---@field count number
   local CounterCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param ... string
   function CounterCache:Init(id, _, ...)
      CacheData.Init(self, id)
      print('initializing counter', id, ...)
      self.fields = {}
      for i = 1, select("#", ...) do
         self.fields[i] = {strsplit(".", (select(i, ...)))}
      end
      self.cache = {}
      self.count = 0
   end

   ---@param tbl table
   ---@param paths string[][]
   local function dig(tbl, paths)
      local val = true
      for _, path in ipairs(paths) do
         local t = tbl
         for _, key in ipairs(path) do
            if type(t) == "table" then
               t = t[key]
            else
               val = not not t
               break
            end
            val = not not t
         end
         if not val then
            break
         end
      end
      return val
   end

   ---@param cache CacheData
   function CounterCache:Subscribe(cache)
      CacheData.Subscribe(self, cache)
      local val = dig(cache, self.fields)
      self.count = self.count + (val and 1 or 0)
      self.cache[cache] = val
   end

   ---@param cache CacheData
   function CounterCache:Unsubscribe(cache)
      if self.cache[cache] ~= nil then
         CacheData.Unsubscribe(self, cache)
         self.count = self.count - (self.cache[cache] and 1 or 0)
         self.cache[cache] = nil
      end
   end

   ---@param invalidator CacheData?
   ---@param skipPropogation boolean?
   function CounterCache:Invalidate(invalidator, skipPropogation)
      local newCount = 0
      if not invalidator then
         for cache in pairs(self.cache) do
            local newVal = dig(cache, self.fields)
            newCount = newCount + (newVal and 1 or 0)
            self.cache[cache] = newVal
         end
      elseif self.cache[invalidator] ~= nil then
         local newVal = dig(invalidator, self.fields)
         if newVal ~= self.cache[invalidator] then
            self.cache[invalidator] = newVal
            newCount = self.count + (newVal and 1 or -1)
         end
      end
      if newCount ~= self.count then
         self.count = newCount
         return CacheData.Invalidate(self, self, skipPropogation)
      end
   end

   CacheManager.counter = CreateAndInitFromMixin(Cache, 'counter', CounterCache)
end

do -- node

   ---@class NodeCache : CacheData
   ---@field static NodeData
   ---@field children NodeCache[]?
   ---@field items LeafCache[]?
   ---@field total number
   ---@field learned number
   ---@field fomoTotal number
   ---@field fomoLearned number
   ---@field cost number?
   ---@field template string
   local NodeCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param static NodeData
   function NodeCache:Init(id, _, static)
      CacheData.Init(self, id)
      self.static = static
      self.total = 0
      self.learned = 0
      self.fomoTotal = 0
      self.fomoLearned = 0
      self.template = static.template
      if static.children then
         self.children = {}
         for i, child in ipairs(static.children) do
            local childCache = CacheManager.node:Ensure(child.id, child) --[[@as NodeCache]]
            childCache:AddSubscriber(id, self)
            self.children[i] = childCache
            self.total = self.total + childCache.total
            self.learned = self.learned + childCache.learned
            self.fomoTotal = self.fomoTotal + childCache.fomoTotal
            self.fomoLearned = self.fomoLearned + childCache.fomoLearned
            if childCache.cost then
               self.cost = (self.cost or 0) + childCache.cost
            end
         end
      elseif static.items then
         self.items = {}
         for i, item in ipairs(static.items) do
            local leafNode = CacheManager.leaf:Ensure(item.id, static.itemType, item, static.itemTemplate) --[[@as LeafCache]]
            leafNode:AddSubscriber(string.format("node=%s", id), self)
            self.items[i] = leafNode
            self.total = self.total + 1
            if leafNode.static.fomo then
               self.fomoTotal = self.fomoTotal + 1
            end
            if leafNode.cache.has then
               self.learned = self.learned + 1
               if leafNode.static.fomo then
                  self.fomoLearned = self.fomoLearned + 1
               end
            else
               if item.cost then
                  self.cost = (self.cost or 0) + item.cost
               end
            end
         end
      end
   end

   function NodeCache:Invalidate(skipPropogation)
      local newLearned = 0
      local newFomoLearned = 0
      local newCost
      if self.children then
         for _, child in pairs(self.children) do
            newLearned = newLearned + (child.learned or 0)
            newFomoLearned = newFomoLearned + (child.fomoLearned or 0)
            if child.cost then
               newCost = (newCost or 0) + child.cost
            end
         end
      elseif self.items then
         for _, item in pairs(self.items) do
            if item.cache.has then
               newLearned = newLearned + 1
            elseif item.static.cost then
               newCost = (newCost or 0) + item.static.cost
            end
         end
      end
      if newLearned ~= self.learned or newCost ~= self.cost then
         self.learned = newLearned
         self.cost = newCost
         ns:QueueRedraw()
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.node = CreateAndInitFromMixin(Cache, 'node', NodeCache)
end

do -- leaf
   ---@class LeafCache : CacheData
   ---@field static ItemData
   ---@field cache ItemCache
   ---@field template string
   local LeafCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param type itemType
   ---@param static ItemData
   ---@param template string
   function LeafCache:Init(id, _, type, static, template)
      CacheData.Init(self, id)
      if static.itemType then
         type = static.itemType
      end
      self.static = static
      self.template = template
      self.cache = CacheManager.items:Ensure(static.id, type, static) --[[@as ItemCache]]
      self.cache:AddSubscriber(id, self)
      self.has = self.cache.has
   end

   function LeafCache:Invalidate(skipPropogation)
      local newHas = self.cache.has
      if newHas ~= self.has then
         self.has = newHas
         ns:QueueRedraw()
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.leaf = CreateAndInitFromMixin(Cache, 'leaf', LeafCache)
end

do -- items

   ---@enum itemType
   local itemTypes = {
      appearance = "appearance",
      ensemble   = "ensemble",
      toy        = "toy",
      mount      = "mount",
      heirloom   = "heirloom"
   }

   ---@class ItemCache : CacheData
   ---@field type itemType
   ---@field link string
   ---@field loaded boolean
   ---@field cache CacheData
   ---@field static ItemData
   local ItemCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param itemID number
   ---@param itemType itemType
   ---@param itemData ItemData
   function ItemCache:Init(id, itemID, itemType, itemData)
      assert(itemTypes[itemType] ~= nil, "Invalid item type")
      CacheData.Init(self, id)
      self.type = itemType
      self.has = false
      self.loaded = false
      self.static = itemData
      local item = Item:CreateFromItemID(itemID)
      item:ContinueOnItemLoad(function()
         self.link = item:GetItemLink()
         self.loaded = true
         if itemType == "mount" then
            local mountID = C_MountJournal.GetMountFromItem(itemID) --[[@as number]]
            self.cache = CacheManager.mounts:Ensure(mountID)
         elseif itemType == "toy" then
            self.cache = CacheManager.toys:Ensure(itemID)
         elseif itemType == "heirloom" then
            self.cache = CacheManager.heirlooms:Ensure(itemID)
         elseif itemType == "ensemble" then
            local setID = C_Item.GetItemLearnTransmogSet(itemID) --[[@as number]]
            self.cache = CacheManager.ensemble:Ensure(setID)
         elseif itemType == "appearance" then
            local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemID)) --[[@as number]]
            local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
            self.cache = CacheManager.appearances:Ensure(sourceInfo.visualID)
         end
         self.cache:AddSubscriber(id, self)
         CacheManager.counter:Ensure("item.learned", "has"):Subscribe(self.cache)
         CacheManager.counter:Ensure("item.total"):Subscribe(self.cache)
         if self.static.fomo then
            CacheManager.counter:Ensure("item.fomo.learned", "has"):Subscribe(self.cache)
            CacheManager.counter:Ensure("item.fomo.total"):Subscribe(self.cache)
         end
         if self.static.type ~= nil and self.static.type < 18 then
            CacheManager.counter:Ensure("item.weaponLearned", "has"):Subscribe(self.cache)
            CacheManager.counter:Ensure("item.weaponTotal"):Subscribe(self.cache)
         end
         if self.cache.has then
            CacheManager:InvalidateNextFrame(self)
         end
      end)
   end

   function ItemCache:Invalidate(skipPropogation)
      local newHas = self.cache.has
      if newHas ~= self.has then
         self.has = newHas
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.items = CreateAndInitFromMixin(Cache, 'item', ItemCache)
end

do -- heirlooms
   ---@class HeirloomCache : CacheData
   ---@field heirloomID number
   local HeirloomCache = CreateFromMixins(CacheData)

   ---@param id string
   function HeirloomCache:Init(id, heirloomID)
      CacheData.Init(self, id)
      self.heirloomID = heirloomID
      self.has = C_Heirloom.PlayerHasHeirloom(heirloomID)
   end

   function HeirloomCache:Invalidate(skipPropogation)
      local newHas = C_Heirloom.PlayerHasHeirloom(self.heirloomID)
      if newHas ~= self.has then
         self.has = newHas
         return CacheData.Invalidate(self, skipPropogation)
      end
   end
   CacheManager.heirlooms = CreateAndInitFromMixin(Cache, 'heirloom', HeirloomCache)
end

do -- toys

   ---@class ToyCache : CacheData
   ---@field toyID number
   local ToyCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param toyID number
   function ToyCache:Init(id, toyID)
      CacheData.Init(self, id)
      self.toyID = toyID
      self.has = PlayerHasToy(toyID)
   end

   function ToyCache:Invalidate(skipPropogation)
      local newHas = PlayerHasToy(self.toyID)
      if newHas ~= self.has then
         self.has = newHas
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.toys = CreateAndInitFromMixin(Cache, 'toy', ToyCache)
end

do -- mounts
   ---@class MountCache : CacheData
   ---@field mountID number
   local MountCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param mountID number
   function MountCache:Init(id, mountID)
      CacheData.Init(self, id)
      self.mountID = mountID
      local _, _, _, _, _, _, _, _, _, _, hasMount = C_MountJournal.GetMountInfoByID(mountID)
      self.has = hasMount
   end

   function MountCache:Invalidate(skipPropogation)
      local _, _, _, _, _, _, _, _, _, _, newHas = C_MountJournal.GetMountInfoByID(self.mountID)
      if newHas ~= self.has then
         self.has = newHas
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.mounts = CreateAndInitFromMixin(Cache, 'mount', MountCache)
end

do -- ensembles
   ---@class EnsembleCache : CacheData
   ---@field appearances table<number, CacheData>
   ---@field ensembleID number
   ---@field learned number
   ---@field total number
   local EnsembleCache = CreateFromMixins(CacheData)

   ---@param id string
   function EnsembleCache:Init(id, ensembleID)
      CacheData.Init(self, id)
      self.ensembleID = ensembleID
      self.appearances = {}
      self.learned = 0
      self.total = 0
      local setItems = C_Transmog.GetAllSetAppearancesByID(ensembleID) --[[@as TransmogSetItemInfo[]]
      if not setItems then print(id) end
      for i, itemData in ipairs(setItems) do
         local sourceID = itemData.itemModifiedAppearanceID
         local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
         if not self.appearances[sourceInfo.visualID] then
            self.total = self.total + 1
            local appearance = CacheManager.appearances:Ensure(sourceInfo.visualID)
            appearance:AddSubscriber(id, self)
            self.appearances[sourceInfo.visualID] = appearance
            if self.appearances[sourceInfo.visualID].has then
               self.learned = self.learned + 1
            end
         end
      end
      self.has = self.learned == self.total
   end

   function EnsembleCache:Invalidate(skipPropogation)
      local newLearned = 0
      for _, appearance in pairs(self.appearances) do
         if appearance.has then
            newLearned = newLearned + 1
         end
      end
      local newHas = newLearned == self.total
      if newHas ~= self.has or newLearned ~= self.learned then
         self.has = newHas
         self.learned = newLearned
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.ensemble = CreateAndInitFromMixin(Cache, 'ensemble', EnsembleCache)
end

do -- appearances
   ---@class AppearanceCache : CacheData
   ---@field appearanceID number
   ---@field sources table<number, CacheData>
   local AppearanceCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param appearanceID number
   function AppearanceCache:Init(id, appearanceID)
      CacheData.Init(self, id)
      self.appearanceID = appearanceID
      self.has = false
      self.sources = {}
      local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
      for _, sourceID in ipairs(sources) do
         local source = CacheManager.sources:Ensure(sourceID)
         source:AddSubscriber(id, self)
         self.sources[sourceID] = source
         if source.has then
            self.has = true
         end
      end
   end

   function AppearanceCache:Invalidate(skipPropogation)
      local newHas = false
      for _, source in pairs(self.sources) do
         if source.has then
            newHas = true
            break
         end
      end
      if newHas ~= self.has then
         self.has = newHas
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.appearances = CreateAndInitFromMixin(Cache, 'appearance', AppearanceCache)
end

do -- appearance sources
   ---@class SourceCache : CacheData
   ---@field sourceID number
   local SourceCache = CreateFromMixins(CacheData)

   ---@param id string
   ---@param sourceID number
   function SourceCache:Init(id, sourceID)
      CacheData.Init(self, id)
      self.sourceID = sourceID
      self.has = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
   end

   function SourceCache:Invalidate(skipPropogation)
      local newHas = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(self.sourceID)
      if newHas ~= self.has then
         self.has = newHas
         return CacheData.Invalidate(self, skipPropogation)
      end
   end

   CacheManager.sources = CreateAndInitFromMixin(Cache, 'source', SourceCache)
end

