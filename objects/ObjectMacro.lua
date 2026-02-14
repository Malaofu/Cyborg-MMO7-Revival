--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectMacro.lua
--~ Description: Macro-backed object model

local O = CyborgMMO_ObjectInternals
local Core = CyborgMMO.Core

local WowMacro_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowMacro_mt = {__index = WowMacro_methods}

local function WowMacro(name)
	local texture = select(2, GetMacroInfo(name))
	if not texture then
		return nil
	end

	local self = O.WowObject("macro", name)
	self.name = name
	self.texture = texture
	setmetatable(self, WowMacro_mt)
	return self
end

function WowMacro_methods:DoAction()
	Core.Debug.Log("Use Item")
end

function WowMacro_methods:Pickup()
	ClearCursor()
	return PickupMacro(self.name)
end

function WowMacro_methods:SetBinding(key)
	SetOverrideBindingMacro(CyborgMMO_CallbackFactory.Frame, true, key, self.name)
end

CyborgMMO.Core.Objects.RegisterFactory("macro", WowMacro)
