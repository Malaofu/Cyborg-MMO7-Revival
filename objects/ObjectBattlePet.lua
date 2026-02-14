--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectBattlePet.lua
--~ Description: Battle-pet-backed object model

local O = CyborgMMO_ObjectInternals

local WowBattlePet_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowBattlePet_mt = {__index = WowBattlePet_methods}

local function WowBattlePet(petID)
	local texture = select(9, C_PetJournal.GetPetInfoByPetID(petID))
	if not texture then
		return nil
	end

	local self = O.WowObject("battlepet", petID)
	CyborgMMO_DPrint("creating battle pet binding:", petID)
	self.petID = petID
	self.texture = texture
	setmetatable(self, WowBattlePet_mt)
	return self
end

function WowBattlePet_methods:DoAction()
	C_PetJournal.SummonPetByGUID(self.petID)
end

function WowBattlePet_methods:Pickup()
	return C_PetJournal.PickupPet(self.petID)
end

function WowBattlePet_methods:SetBinding(key)
	O.SetClickBindingWithCallback(key, function()
		self:DoAction()
	end)
end

CyborgMMO.Core.Objects.RegisterFactory("battlepet", WowBattlePet)

