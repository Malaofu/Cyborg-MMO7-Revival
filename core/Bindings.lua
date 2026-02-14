--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/Bindings.lua
--~ Description: Keybind defaults and hardware mode callback setup

local RAT7 = {
	BUTTONS = CyborgMMO_Constants.RAT_BUTTONS,
	MODES = CyborgMMO_Constants.RAT_MODES,
}

CyborgMMO_ModeDetected = false

function CyborgMMO_SetDefaultKeyBindings()
	for mode = 1, RAT7.MODES do
		for button = 1, RAT7.BUTTONS do
			local k = (mode - 1) * RAT7.BUTTONS + button
			CyborgMMO_ProfileKeyBindings[k] = CyborgMMO_DefaultKeyBindings[k]
			CyborgMMO_SetBindingButtonText(string.format("CyborgMMO_OptionPageRebindMouseRow%XMode%d", button, mode))
		end
		CyborgMMO_ProfileModeKeyBindings[mode] = CyborgMMO_DefaultModeKeyBindings[mode]
		CyborgMMO_SetBindingModeButtonText(string.format("CyborgMMO_OptionPageRebindMouseMode%d", mode), mode)
	end
end

function CyborgMMO_SetupModeCallbacks(modeNum)
	local fn = function()
		CyborgMMO_ModeDetected = true
		CyborgMMO_MouseModeChange(modeNum)
		CyborgMMO_RatPageModel:SetMode(modeNum)
	end

	local _, parentFrame, name = CyborgMMO_CallbackFactory:AddCallback(fn)
	SetOverrideBindingClick(parentFrame, true, CyborgMMO_ProfileModeKeyBindings[modeNum], name, "LeftButton")
end
