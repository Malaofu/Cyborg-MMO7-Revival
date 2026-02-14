--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/EventRouter.lua
--~ Description: Event registration and startup/load-state orchestration

local REGISTERED_EVENTS = {
	"VARIABLES_LOADED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_REGEN_DISABLED",
	"PLAYER_REGEN_ENABLED",
	"ACTIVE_TALENT_GROUP_CHANGED",
	"PLAYER_SPECIALIZATION_CHANGED",
}

local eventHandlers = {}
local Core = CyborgMMO.Core
Core.Events = Core.Events or {}

local function EnsureSaveDataInitialized()
	if not CyborgMMO7SaveData then
		CyborgMMO7SaveData = {
			Settings = DefaultSettings,
		}
	end
end

local function RemoveStaleMountMapEntries()
	local mountMap, localMountMap = CyborgMMO.GetMountMaps()
	for mount in pairs(mountMap) do
		localMountMap[mount] = nil
	end
end

local function MigrateLegacySaveFormatIfNeeded()
	if CyborgMMO7SaveData[Core.Runtime.saveName] and not CyborgMMO7SaveData.Settings then
		local oldData = CyborgMMO7SaveData[Core.Runtime.saveName]
		CyborgMMO7SaveData = {}
		CyborgMMO7SaveData.Settings = oldData.Settings
		CyborgMMO7SaveData.Rat = {}
		CyborgMMO7SaveData.Rat[1] = Core.SaveData.ConvertOldRatData(oldData.Rat)
		CyborgMMO7SaveData[Core.Runtime.saveName] = oldData
	end
end

local function ApplyRuntimeSettings()
	local data = Core.Storage.GetSaveData()
	Core.Settings.EnsureDefaults(data)

	Core.UI.SetOpenButtonSize(Core.Runtime.settings.Cyborg)
	Core.UI.SetMainPageSize(Core.Runtime.settings.Plugin)
	Core.UI.SetMiniMapButton(Core.Runtime.settings.MiniMapButton)
	Core.UI.SetCompartmentButton(Core.Runtime.settings.CompartmentButton)
	Core.UI.MiniMapButtonReposition(Core.Runtime.settings.MiniMapButtonAngle)
	Core.UI.SetCyborgHeadButton(Core.Runtime.settings.CyborgButton)
	Core.UI.SetPerSpecBindings(Core.Runtime.settings.PerSpecBindings)
	Core.UI.MouseModeChange(1)
end

local function LoadBindings()
	CyborgMMO_RatPageModel:LoadData()
	Core.UI.SetupAllModeCallbacks()
end

local function TryAdvanceLoadState()
	if not Core.IsLoadReady() then
		return
	end

	if not Core.Runtime.settingsLoaded then
		ApplyRuntimeSettings()
		Core.Runtime.settingsLoaded = true
	end

	if not Core.Runtime.bindingsLoaded then
		LoadBindings()
		Core.Runtime.bindingsLoaded = true
	end
end

function eventHandlers.VARIABLES_LOADED()
	Core.Runtime.varsLoaded = true
	EnsureSaveDataInitialized()
	RemoveStaleMountMapEntries()
	Core.SaveData.PreLoadSaveData(CyborgMMO7SaveData, Core.Runtime.saveName)
end

function eventHandlers.CYBORGMMO_ASYNC_DATA_LOADED()
	Core.Runtime.asyncDataLoaded = true
	MigrateLegacySaveFormatIfNeeded()
end

function eventHandlers.PLAYER_ENTERING_WORLD()
	Core.Runtime.enteredWorld = true
end

function eventHandlers.PLAYER_REGEN_DISABLED()
	if Core.UI.Main.IsOpen() then
		Core.Runtime.autoClosed = true
		Core.UI.Main.Close()
	end
end

function eventHandlers.PLAYER_REGEN_ENABLED()
	if Core.Runtime.autoClosed then
		Core.Runtime.autoClosed = false
		Core.UI.Main.Open()
	end
end

function eventHandlers.ACTIVE_TALENT_GROUP_CHANGED()
	Core.Runtime.bindingsLoaded = false
end

eventHandlers.PLAYER_SPECIALIZATION_CHANGED = eventHandlers.ACTIVE_TALENT_GROUP_CHANGED

function Core.Events.Dispatch(event, ...)
	local handler = eventHandlers[event]
	if handler then
		handler(...)
	else
		CyborgMMO_DPrint("Event is " .. tostring(event))
	end

	TryAdvanceLoadState()
end

local function disableOldAddon()
	if C_AddOns.DoesAddOnExist("CyborgMMO7") then
		local enabledState = C_AddOns.GetAddOnEnableState(UnitName("player"), "CyborgMMO7")
		local isEnabled = (enabledState == true) or (type(enabledState) == "number" and enabledState > 0)
		if isEnabled then
			C_AddOns.DisableAddOn("CyborgMMO7")
			CyborgMMO_DPrint("Old CyborgMMO7 addon was disabled")
		end
	end
end

function Core.Events.Loaded()
	disableOldAddon()
	for _, eventName in ipairs(REGISTERED_EVENTS) do
		CyborgMMO_MainPage:RegisterEvent(eventName)
	end
end
