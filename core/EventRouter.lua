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
	if CyborgMMO7SaveData[CyborgMMO_Runtime.saveName] and not CyborgMMO7SaveData.Settings then
		local oldData = CyborgMMO7SaveData[CyborgMMO_Runtime.saveName]
		CyborgMMO7SaveData = {}
		CyborgMMO7SaveData.Settings = oldData.Settings
		CyborgMMO7SaveData.Rat = {}
		CyborgMMO7SaveData.Rat[1] = CyborgMMO_ConvertOldRatData(oldData.Rat)
		CyborgMMO7SaveData[CyborgMMO_Runtime.saveName] = oldData
	end
end

local function ApplyRuntimeSettings()
	local data = CyborgMMO_GetSaveData()
	CyborgMMO_EnsureSettingsDefaults(data)

	CyborgMMO_SetOpenButtonSize(CyborgMMO_Runtime.settings.Cyborg)
	CyborgMMO_SetMainPageSize(CyborgMMO_Runtime.settings.Plugin)
	CyborgMMO_SetMiniMapButton(CyborgMMO_Runtime.settings.MiniMapButton)
	CyborgMMO_SetCompartmentButton(CyborgMMO_Runtime.settings.CompartmentButton)
	CyborgMMO_MiniMapButtonReposition(CyborgMMO_Runtime.settings.MiniMapButtonAngle)
	CyborgMMO_SetCyborgHeadButton(CyborgMMO_Runtime.settings.CyborgButton)
	CyborgMMO_SetPerSpecBindings(CyborgMMO_Runtime.settings.PerSpecBindings)
	CyborgMMO_MouseModeChange(1)
end

local function LoadBindings()
	CyborgMMO_RatPageModel:LoadData()
	CyborgMMO_SetupAllModeCallbacks()
end

local function TryAdvanceLoadState()
	if not CyborgMMO_IsLoadReady() then
		return
	end

	if not CyborgMMO_Runtime.settingsLoaded then
		ApplyRuntimeSettings()
		CyborgMMO_Runtime.settingsLoaded = true
	end

	if not CyborgMMO_Runtime.bindingsLoaded then
		LoadBindings()
		CyborgMMO_Runtime.bindingsLoaded = true
	end
end

function eventHandlers.VARIABLES_LOADED()
	CyborgMMO_Runtime.varsLoaded = true
	EnsureSaveDataInitialized()
	RemoveStaleMountMapEntries()
	CyborgMMO_PreLoadSaveData(CyborgMMO7SaveData, CyborgMMO_Runtime.saveName)
end

function eventHandlers.CYBORGMMO_ASYNC_DATA_LOADED()
	CyborgMMO_Runtime.asyncDataLoaded = true
	MigrateLegacySaveFormatIfNeeded()
end

function eventHandlers.PLAYER_ENTERING_WORLD()
	CyborgMMO_Runtime.enteredWorld = true
end

function eventHandlers.PLAYER_REGEN_DISABLED()
	if CyborgMMO_IsOpen() then
		CyborgMMO_Runtime.autoClosed = true
		CyborgMMO_Close()
	end
end

function eventHandlers.PLAYER_REGEN_ENABLED()
	if CyborgMMO_Runtime.autoClosed then
		CyborgMMO_Runtime.autoClosed = false
		CyborgMMO_Open()
	end
end

function eventHandlers.ACTIVE_TALENT_GROUP_CHANGED()
	CyborgMMO_Runtime.bindingsLoaded = false
end

eventHandlers.PLAYER_SPECIALIZATION_CHANGED = eventHandlers.ACTIVE_TALENT_GROUP_CHANGED

function CyborgMMO_Event(event, ...)
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

function CyborgMMO_Loaded()
	disableOldAddon()
	for _, eventName in ipairs(REGISTERED_EVENTS) do
		CyborgMMO_MainPage:RegisterEvent(eventName)
	end
end
