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

function Core.Settings.EnsureDefaults(data)
	Core.Runtime.settings = data.Settings
	if not Core.Runtime.settings then
		Core.Runtime.settings = DefaultSettings
		data.Settings = Core.Runtime.settings
	end

	setDefaultIfNil(Core.Runtime.settings, "MiniMapButton", DefaultSettings.MiniMapButton)
	setDefaultIfNil(Core.Runtime.settings, "CompartmentButton", DefaultSettings.CompartmentButton)
	setDefaultIfNil(Core.Runtime.settings, "CyborgButton", DefaultSettings.CyborgButton)
	setDefaultIfNil(Core.Runtime.settings, "PerSpecBindings", DefaultSettings.PerSpecBindings)
	setDefaultIfNil(Core.Runtime.settings, "Cyborg", DefaultSettings.Cyborg)
	setDefaultIfNil(Core.Runtime.settings, "Plugin", DefaultSettings.Plugin)
	setDefaultIfNil(Core.Runtime.settings, "MiniMapButtonAngle", DefaultSettings.MiniMapButtonAngle)
end
