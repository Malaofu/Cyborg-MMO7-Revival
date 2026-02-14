--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/RuntimeState.lua
--~ Description: Runtime state container and readiness/spec helpers

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core

Core.Runtime = Core.Runtime or {
	varsLoaded = false,
	asyncDataLoaded = false,
	enteredWorld = false,
	bindingsLoaded = false,
	settingsLoaded = false,
	saveName = GetRealmName() .. "_" .. UnitName("player"),
	settings = nil,
	autoClosed = false,
}

function Core.GetCurrentSpecIndex()
	if not Core.Runtime.settings or not Core.Runtime.settings.PerSpecBindings then
		return 1
	end
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
		return C_SpecializationInfo.GetSpecialization()
	end
	return GetActiveTalentGroup()
end

function Core.IsLoadReady()
	return Core.Runtime.varsLoaded and Core.Runtime.asyncDataLoaded and Core.Runtime.enteredWorld
end
