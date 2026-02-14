--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectSpell.lua
--~ Description: Spell-backed object model

local O = CyborgMMO_ObjectInternals

local WowSpell_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowSpell_mt = {__index = WowSpell_methods}

local function WowSpell(spellID)
	local texture = C_Spell.GetSpellTexture(spellID)
	if not texture then
		return nil
	end

	local self = O.WowObject("spell", spellID)
	self.spellID = spellID
	self.texture = texture
	setmetatable(self, WowSpell_mt)
	return self
end

function WowSpell_methods:DoAction()
	CyborgMMO_DPrint("Cast Spell")
end

function WowSpell_methods:Pickup()
	ClearCursor()
	return C_Spell.PickupSpell(self.spellID)
end

function WowSpell_methods:SetBinding(key)
	local spellInfo = C_Spell.GetSpellInfo(self.spellID)
	if not spellInfo then
		return
	end
	local name = spellInfo.name
	CyborgMMO_DPrint("binding spell:", self.spellID, name)
	SetOverrideBindingSpell(CyborgMMO_CallbackFactory.Frame, true, key, name)
end

CyborgMMO_RegisterObjectFactory("spell", WowSpell)
