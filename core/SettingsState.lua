--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/SettingsState.lua
--~ Description: Settings normalization and defaults

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core

local function setDefaultIfNil(tbl, key, defaultValue)
	if tbl[key] == nil then
		tbl[key] = defaultValue
	end
end

Core.Settings = Core.Settings or {}
local Globals = Core.Globals

function Core.Settings.EnsureDefaults(data)
	Core.Runtime.settings = data.Settings
	local defaultSettings = Globals.GetDefaultSettings()
	if not Core.Runtime.settings then
		Core.Runtime.settings = defaultSettings
		data.Settings = Core.Runtime.settings
	end

	setDefaultIfNil(Core.Runtime.settings, "MiniMapButton", defaultSettings.MiniMapButton)
	setDefaultIfNil(Core.Runtime.settings, "CompartmentButton", defaultSettings.CompartmentButton)
	setDefaultIfNil(Core.Runtime.settings, "CyborgButton", defaultSettings.CyborgButton)
	setDefaultIfNil(Core.Runtime.settings, "PerSpecBindings", defaultSettings.PerSpecBindings)
	setDefaultIfNil(Core.Runtime.settings, "Cyborg", defaultSettings.Cyborg)
	setDefaultIfNil(Core.Runtime.settings, "Plugin", defaultSettings.Plugin)
	setDefaultIfNil(Core.Runtime.settings, "MiniMapButtonAngle", defaultSettings.MiniMapButtonAngle)
end
