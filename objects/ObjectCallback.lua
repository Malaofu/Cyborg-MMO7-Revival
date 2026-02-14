--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectCallback.lua
--~ Description: Callback-backed object model

local O = CyborgMMO_ObjectInternals

local WowCallback_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowCallback_mt = {__index = WowCallback_methods}

local function WowCallback(callbackName)
	local self = O.WowObject("callback", callbackName, "")
	self.callbackName = callbackName
	self.texture = O.MEDIA_PATH .. callbackName .. "Unselected"
	setmetatable(self, WowCallback_mt)
	return self
end

function WowCallback_methods:SetTextures(buttonFrame)
	buttonFrame:SetNormalTexture(O.MEDIA_PATH .. self.callbackName .. "Unselected")
	buttonFrame:SetPushedTexture(O.MEDIA_PATH .. self.callbackName .. "Down")
	buttonFrame:SetHighlightTexture(O.MEDIA_PATH .. self.callbackName .. "Over")
end

function WowCallback_methods:DoAction()
	local action = CyborgMMO_CallbackFactory:GetCallback(self.callbackName)
	action()
end

function WowCallback_methods:PickupCallback()
	local slot = CyborgMMO_RatPageController:FindHoveredSlot()
	CyborgMMO_DPrint("Slot type: " .. type(slot))
end

function WowCallback_methods:Pickup()
	PlaySound(SOUNDKIT.IG_ABILITY_ICON_DROP)
	ClearCursor()
	self:PickupCallback()
end

function WowCallback_methods:SetBinding(key)
	O.SetClickBindingWithCallback(key, function(...)
		return self:DoAction(...)
	end)
end

O.CreateCallbackObject = WowCallback
CyborgMMO_RegisterObjectFactory("callback", WowCallback)
