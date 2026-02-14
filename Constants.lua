--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: Constants.lua
--~ Description: Shared constants for addon modules

CyborgMMO = CyborgMMO or {}

CyborgMMO.Constants = {
	RAT_BUTTONS = 13,
	RAT_MODES = 3,
	RAT_SHIFT = 0,
	RANDOM_MOUNT_ID = 0xFFFFFFF,
	MEDIA_PATH = "Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\",
}

CyborgMMO.Data = CyborgMMO.Data or {}
CyborgMMO.Core = CyborgMMO.Core or {}
CyborgMMO.Core.Globals = CyborgMMO.Core.Globals or {}

local G = CyborgMMO.Core.Globals
if not G.GetDefaultSettings then
	function G.GetDefaultSettings()
		return {
			MiniMapButton = true,
			CompartmentButton = true,
			CyborgButton = true,
			PerSpecBindings = false,
			Cyborg = 0.75,
			Plugin = 0.75,
			MiniMapButtonAngle = math.rad(150),
		}
	end
end
if not G.GetSaveData then
	function G.GetSaveData()
		return CyborgMMO7SaveData
	end
end
if not G.SetSaveData then
	function G.SetSaveData(data)
		CyborgMMO7SaveData = data
	end
end
if not G.EnsureSaveData then
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
end
if not G.GetProfileKeyBindings then
	function G.GetProfileKeyBindings()
		return CyborgMMO_ProfileKeyBindings
	end
end
if not G.GetProfileModeKeyBindings then
	function G.GetProfileModeKeyBindings()
		return CyborgMMO_ProfileModeKeyBindings
	end
end
if not G.GetDefaultKeyBindings then
	function G.GetDefaultKeyBindings()
		if CyborgMMO.Core.Localization and CyborgMMO.Core.Localization.DefaultKeyBindings then
			return CyborgMMO.Core.Localization.DefaultKeyBindings
		end
		return {}
	end
end
if not G.GetDefaultModeKeyBindings then
	function G.GetDefaultModeKeyBindings()
		if CyborgMMO.Core.Localization and CyborgMMO.Core.Localization.DefaultModeKeyBindings then
			return CyborgMMO.Core.Localization.DefaultModeKeyBindings
		end
		return {}
	end
end

-- Canonical API: CyborgMMO.Constants / CyborgMMO.Data

function CyborgMMO.GetMountMaps()
	local data = CyborgMMO.Data or {}
	local mountMap = data.MountMap or {}
	local localMountMap = data.LocalMountMap or {}
	return mountMap, localMountMap
end
