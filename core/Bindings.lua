--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/Bindings.lua
--~ Description: Keybind defaults and hardware mode callback setup

local Constants = CyborgMMO.Constants

local RAT7 = {
	BUTTONS = Constants.RAT_BUTTONS,
	MODES = Constants.RAT_MODES,
}
local Core = CyborgMMO.Core
Core.Bindings = Core.Bindings or {}
local Globals = Core.Globals

Core.Bindings.ModeDetected = false

function Core.Bindings.SetDefaultKeyBindings()
	local profileKeyBindings = Globals.GetProfileKeyBindings()
	local defaultKeyBindings = Globals.GetDefaultKeyBindings()
	local profileModeKeyBindings = Globals.GetProfileModeKeyBindings()
	local defaultModeKeyBindings = Globals.GetDefaultModeKeyBindings()
	for mode = 1, RAT7.MODES do
		for button = 1, RAT7.BUTTONS do
			local k = (mode - 1) * RAT7.BUTTONS + button
			profileKeyBindings[k] = defaultKeyBindings[k]
			Core.UI.Rebind.SetBindingButtonText(string.format("CyborgMMO_OptionPageRebindMouseRow%XMode%d", button, mode))
		end
		profileModeKeyBindings[mode] = defaultModeKeyBindings[mode]
		Core.UI.Rebind.SetBindingModeButtonText(string.format("CyborgMMO_OptionPageRebindMouseMode%d", mode), mode)
	end
end

function Core.Bindings.SetupModeCallbacks(modeNum)
	local fn = function()
		Core.Bindings.ModeDetected = true
		Core.UI.MouseModeChange(modeNum)
		CyborgMMO_RatPageModel:SetMode(modeNum)
	end

	local _, parentFrame, name = CyborgMMO_CallbackFactory:AddCallback(fn)
	SetOverrideBindingClick(parentFrame, true, Globals.GetProfileModeKeyBindings()[modeNum], name, "LeftButton")
end
