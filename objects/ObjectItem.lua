--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectItem.lua
--~ Description: Item-backed object model

local O = CyborgMMO_ObjectInternals

local WowItem_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowItem_mt = {__index = WowItem_methods}

local function WowItem(itemID)
	local texture = select(10, C_Item.GetItemInfo(itemID))
	if not texture then
		return nil
	end

	local self = O.WowObject("item", itemID)
	self.itemID = itemID
	self.texture = texture
	setmetatable(self, WowItem_mt)
	return self
end

function WowItem_methods:Pickup()
	ClearCursor()
	return C_Item.PickupItem(self.itemID)
end

function WowItem_methods:SetBinding(key)
	local name = C_Item.GetItemInfo(self.itemID)
	SetOverrideBindingItem(CyborgMMO_CallbackFactory.Frame, true, key, name)
end

CyborgMMO_RegisterObjectFactory("item", WowItem)
