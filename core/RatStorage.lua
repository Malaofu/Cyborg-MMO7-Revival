--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/RatStorage.lua
--~ Description: SavedVariables access and per-spec rat data persistence

local Constants = CyborgMMO.Constants

local RAT7 = {
	BUTTONS = Constants.RAT_BUTTONS,
	MODES = Constants.RAT_MODES,
}
local Core = CyborgMMO.Core
Core.Storage = Core.Storage or {}
local Globals = Core.Globals

function Core.Storage.GetSaveData()
	assert(Core.Runtime.varsLoaded)
	return Globals.EnsureSaveData()
end

function Core.Storage.SetRatSaveData(objects)
	assert(Core.Runtime.varsLoaded)
	local specIndex = Core.GetCurrentSpecIndex()
	local ratData = {}
	for mode = 1, RAT7.MODES do
		ratData[mode] = {}
		for button = 1, RAT7.BUTTONS do
			if objects[mode][button] then
				ratData[mode][button] = objects[mode][button]:SaveData()
			end
		end
	end
	local saveData = Core.Storage.GetSaveData()
	if not saveData.Rat then
		saveData.Rat = {}
	end
	saveData.Rat[specIndex] = ratData
end

function Core.Storage.GetRatSaveData()
	local specIndex = Core.GetCurrentSpecIndex()
	Core.Debug.Log("returning rat data for spec:", specIndex)
	local saveData = Core.Storage.GetSaveData()
	return saveData.Rat and saveData.Rat[specIndex]
end
