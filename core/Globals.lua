--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/Globals.lua
--~ Description: Single boundary for WoW global SavedVariables and config globals

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core
Core.Globals = Core.Globals or {}

local G = Core.Globals
local DEFAULT_SETTINGS_FALLBACK = {
	MiniMapButton = true,
	CompartmentButton = true,
	CyborgButton = true,
	PerSpecBindings = false,
	Cyborg = 0.75,
	Plugin = 0.75,
	MiniMapButtonAngle = math.rad(150),
}

function G.GetDefaultSettings()
	if Core.Config and Core.Config.DefaultSettings then
		return Core.Config.DefaultSettings
	end
	return DEFAULT_SETTINGS_FALLBACK
end

function G.GetSaveData()
	return CyborgMMO7SaveData
end

function G.SetSaveData(data)
	CyborgMMO7SaveData = data
end

function G.EnsureSaveData()
	local saveData = G.GetSaveData()
	if not saveData then
		saveData = {
			Settings = G.GetDefaultSettings(),
		}
		G.SetSaveData(saveData)
	end
	return saveData
end

function G.GetProfileKeyBindings()
	return CyborgMMO_ProfileKeyBindings
end

function G.GetProfileModeKeyBindings()
	return CyborgMMO_ProfileModeKeyBindings
end

function G.GetDefaultKeyBindings()
	if Core.Localization and Core.Localization.DefaultKeyBindings then
		return Core.Localization.DefaultKeyBindings
	end
	return {}
end

function G.GetDefaultModeKeyBindings()
	if Core.Localization and Core.Localization.DefaultModeKeyBindings then
		return Core.Localization.DefaultModeKeyBindings
	end
	return {}
end
