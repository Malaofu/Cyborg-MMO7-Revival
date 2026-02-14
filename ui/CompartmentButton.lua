--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/CompartmentButton.lua
--~ Description: Addon compartment registration adapter

local Constants = CyborgMMO.Constants
local MEDIA_PATH = Constants.MEDIA_PATH
local Actions = CyborgMMO_OpenButtonActions or {}

local CompartmentAdapter = {}
CompartmentAdapter.Data = {
	text = "Cyborg MMO7",
	icon = MEDIA_PATH .. "Cyborg",
	notCheckable = true,
	func = function(_, menuInputData)
		Actions.OnMouseUp(_, menuInputData.buttonName)
	end,
	funcOnEnter = Actions.OnEnter,
	funcOnLeave = Actions.OnLeave,
}

local function GetCompartmentFrame()
	return _G.AddonCompartmentFrame
end

function CompartmentAdapter:Register()
	local frame = GetCompartmentFrame()
	if frame and frame.RegisterAddon then
		frame:RegisterAddon(self.Data)
	end
end

function CompartmentAdapter:Unregister()
	local frame = GetCompartmentFrame()
	if not frame then
		return
	end

	if frame.UnregisterAddon then
		frame:UnregisterAddon(self.Data.text)
		return
	end

	local registered = frame.registeredAddons
	if type(registered) ~= "table" then
		return
	end

	for i = 1, #registered do
		if registered[i] == self.Data then
			table.remove(registered, i)
			if frame.UpdateDisplay then
				frame:UpdateDisplay()
			end
			return
		end
	end
end

function RegisterCompartmentButton()
	CompartmentAdapter:Register()
end

function UnregisterCompartmentButton()
	CompartmentAdapter:Unregister()
end
