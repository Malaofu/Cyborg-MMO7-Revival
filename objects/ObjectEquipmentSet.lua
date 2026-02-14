--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectEquipmentSet.lua
--~ Description: Equipment-set-backed object model

local O = CyborgMMO_ObjectInternals

local WowEquipmentSet_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowEquipmentSet_mt = {__index = WowEquipmentSet_methods}

local function WowEquipmentSet(name)
	local equipmentSetId = C_EquipmentSet.GetEquipmentSetID(name)
	local _, texture = C_EquipmentSet.GetEquipmentSetInfo(equipmentSetId)
	if not texture then
		return nil
	end

	local self = O.WowObject("equipmentset", name)
	self.name = name
	self.texture = texture
	setmetatable(self, WowEquipmentSet_mt)
	return self
end

function WowEquipmentSet_methods:DoAction()
	local equipmentSetId = C_EquipmentSet.GetEquipmentSetID(self.name)
	C_EquipmentSet.UseEquipmentSet(equipmentSetId)
end

function WowEquipmentSet_methods:Pickup()
	ClearCursor()
	local equipmentSetId = C_EquipmentSet.GetEquipmentSetID(self.name)
	return C_EquipmentSet.PickupEquipmentSet(equipmentSetId)
end

function WowEquipmentSet_methods:SetBinding(key)
	O.SetClickBindingWithCallback(key, function()
		self:DoAction()
	end)
end

CyborgMMO.Core.Objects.RegisterFactory("equipmentset", WowEquipmentSet)

