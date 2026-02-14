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
Core.Bindings.ModeCallbackRefs = Core.Bindings.ModeCallbackRefs or {}

function Core.Bindings.SetDefaultKeyBindings()
	local profileKeyBindings = Globals.GetProfileKeyBindings()
	local defaultKeyBindings = Globals.GetDefaultKeyBindings()
	local profileModeKeyBindings = Globals.GetProfileModeKeyBindings()
	local defaultModeKeyBindings = Globals.GetDefaultModeKeyBindings()
	local rebindUI = Core.UI and Core.UI.Rebind

	for mode = 1, RAT7.MODES do
		for button = 1, RAT7.BUTTONS do
			local k = (mode - 1) * RAT7.BUTTONS + button
			profileKeyBindings[k] = defaultKeyBindings[k]
			local buttonName = rebindUI and rebindUI.GetButtonName and rebindUI.GetButtonName(button, mode)
				or string.format("CyborgMMO_OptionSubPageRebindMouseRow%XMode%d", button, mode)
			Core.UI.Rebind.SetBindingButtonText(buttonName)
		end
		profileModeKeyBindings[mode] = defaultModeKeyBindings[mode]
		local modeName = rebindUI and rebindUI.GetModeButtonName and rebindUI.GetModeButtonName(mode)
			or string.format("CyborgMMO_OptionSubPageRebindMouseMode%d", mode)
		Core.UI.Rebind.SetBindingModeButtonText(modeName, mode)
	end
end

function Core.Bindings.SetupModeCallbacks(modeNum)
	local callbackRef = Core.Bindings.ModeCallbackRefs[modeNum]
	if not callbackRef then
		local fn = function()
			Core.Bindings.ModeDetected = true
			Core.UI.MouseModeChange(modeNum)
			Core.Rat.Model:SetMode(modeNum)
		end
		local button, parentFrame, name = CyborgMMO_CallbackFactory:AddCallback(fn)
		callbackRef = {
			button = button,
			parentFrame = parentFrame,
			name = name,
			boundKey = nil,
		}
		Core.Bindings.ModeCallbackRefs[modeNum] = callbackRef
	end

	if callbackRef.boundKey and callbackRef.boundKey ~= Globals.GetProfileModeKeyBindings()[modeNum] then
		SetOverrideBinding(callbackRef.parentFrame, true, callbackRef.boundKey, nil)
	end

	callbackRef.boundKey = Globals.GetProfileModeKeyBindings()[modeNum]
	if not callbackRef.boundKey then
		return
	end

	SetOverrideBindingClick(
		callbackRef.parentFrame,
		true,
		callbackRef.boundKey,
		callbackRef.name,
		"LeftButton"
	)
end
