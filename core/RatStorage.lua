--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/RatStorage.lua
--~ Description: SavedVariables access and per-spec rat data persistence

local Constants = CyborgMMO.Constants

local RAT7 = {
	BUTTONS = Constants.RAT_BUTTONS,
	MODES = Constants.RAT_MODES,
}

function CyborgMMO_GetSaveData()
	assert(CyborgMMO_Runtime.varsLoaded)
	if not CyborgMMO7SaveData then
		CyborgMMO7SaveData = {
			Settings = DefaultSettings,
		}
	end
	return CyborgMMO7SaveData
end

function CyborgMMO_SetRatSaveData(objects)
	assert(CyborgMMO_Runtime.varsLoaded)
	local specIndex = CyborgMMO_GetCurrentSpecIndex()
	local ratData = {}
	for mode = 1, RAT7.MODES do
		ratData[mode] = {}
		for button = 1, RAT7.BUTTONS do
			if objects[mode][button] then
				ratData[mode][button] = objects[mode][button]:SaveData()
			end
		end
	end
	local saveData = CyborgMMO_GetSaveData()
	if not saveData.Rat then
		saveData.Rat = {}
	end
	saveData.Rat[specIndex] = ratData
end

function CyborgMMO_GetRatSaveData()
	local specIndex = CyborgMMO_GetCurrentSpecIndex()
	CyborgMMO_DPrint("returning rat data for spec:", specIndex)
	local saveData = CyborgMMO_GetSaveData()
	return saveData.Rat and saveData.Rat[specIndex]
end
