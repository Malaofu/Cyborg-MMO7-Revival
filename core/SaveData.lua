local RAT7 = {
	BUTTONS = CyborgMMO_Constants.RAT_BUTTONS,
	MODES = CyborgMMO_Constants.RAT_MODES,
}

local KNOWN_OLD_OBJECT_TYPES = {
	item = true,
	macro = true,
	spell = true,
	petaction = true,
	merchant = true,
	companion = true,
	equipmentset = true,
	callback = true,
}

local STEP_TIMEOUT_SECONDS = 1
local TOTAL_TIMEOUT_SECONDS = 15
local PreloadFrame

local function GetSpellID(name)
	local link = C_Spell.GetSpellLink(name)
	if not link then
		return nil
	end
	local id = link:match("spell:(%d+)|")
	if id then
		return tonumber(id)
	end
	return nil
end

function CyborgMMO_ConvertOldRatData(oldData)
	local newData = {}
	for mode, modeData in ipairs(oldData) do
		newData[mode] = {}
		for button, buttonData in ipairs(modeData) do
			CyborgMMO_DPrint("converting mode:", mode, "button:", button)
			local objectType = buttonData.Type
			if objectType == "item" then
				-- not possible, the old object "Type" field was overwritten by item class
			elseif objectType == "macro" then
				newData[mode][button] = {
					type = objectType,
					detail = buttonData.Name,
				}
			elseif objectType == "spell" then
				local id = GetSpellID(buttonData.Name)
				CyborgMMO_DPrint("converting spell:", buttonData.Name, id)
				if id then
					newData[mode][button] = {
						type = objectType,
						detail = id,
					}
				end
			elseif objectType == "petaction" then
				-- no longer supported
			elseif objectType == "merchant" then
				-- no longer supported
			elseif objectType == "companion" then
				local id = GetSpellID(buttonData.Name)
				CyborgMMO_DPrint("converting companion:", buttonData.Name, id)
				if id then
					newData[mode][button] = {
						type = objectType,
						detail = buttonData.Subdetail,
						subdetail = id,
					}
				end
			elseif objectType == "equipmentset" then
				CyborgMMO_DPrint("converting equipment set:", buttonData.Detail)
				newData[mode][button] = {
					type = objectType,
					detail = buttonData.Detail,
				}
			elseif objectType == "callback" then
				CyborgMMO_DPrint("converting callback:", buttonData.Detail)
				newData[mode][button] = {
					type = objectType,
					detail = buttonData.Detail,
				}
			elseif not KNOWN_OLD_OBJECT_TYPES[objectType] then
				local id = buttonData.Detail
				local class = select(6, C_Item.GetItemInfo(id))
				if class == objectType then
					CyborgMMO_DPrint("converting item:", id, objectType, class)
					newData[mode][button] = {
						type = "item",
						detail = id,
					}
				end
			else
				CyborgMMO_DPrint("cannot convert:", objectType)
			end
		end
	end
	return newData
end

local function PreloadFrameOnUpdate(self, dt)
	self.step_timeout = self.step_timeout - dt
	self.total_timeout = self.total_timeout - dt
	if self.step_timeout >= 0 then
		return
	end

	local items, pets = 0, 0
	for itemID in pairs(self.itemIDs) do
		if C_Item.GetItemInfo(itemID) then
			self.itemIDs[itemID] = nil
		else
			items = items + 1
		end
	end
	for petID in pairs(self.petIDs) do
		if C_PetJournal.GetPetInfoByPetID(petID) then
			self.petIDs[petID] = nil
		else
			pets = pets + 1
		end
	end

	CyborgMMO_DPrint("PreloadFrameUpdate step", self.total_timeout, "items:", items, "pets:", pets)
	if self.total_timeout < 0 or (next(self.itemIDs) == nil and next(self.petIDs) == nil) then
		self:Hide()
		self:SetParent(nil)
		PreloadFrame = nil
		CyborgMMO_Event("CYBORGMMO_ASYNC_DATA_LOADED")
	else
		self.step_timeout = STEP_TIMEOUT_SECONDS
	end
end

function CyborgMMO_PreLoadSaveData(data, saveName)
	local itemIDs = {}
	local petIDs = {}

	if data.Rat then
		for _, specData in pairs(data.Rat) do
			for mode = 1, RAT7.MODES do
				for button = 1, RAT7.BUTTONS do
					local buttonData = specData[mode] and specData[mode][button]
					if buttonData then
						if buttonData.type == "item" then
							local itemID = buttonData.detail
							if not C_Item.GetItemInfo(itemID) then
								itemIDs[itemID] = true
							end
						elseif buttonData.type == "battlepet" then
							local petID = buttonData.detail
							if not C_PetJournal.GetPetInfoByPetID(petID) then
								petIDs[petID] = true
							end
						end
					end
				end
			end
		end
	end

	if data[saveName] and data[saveName].Rat then
		for mode = 1, RAT7.MODES do
			for button = 1, RAT7.BUTTONS do
				local buttonData = data[saveName].Rat[mode][button]
				if buttonData and not KNOWN_OLD_OBJECT_TYPES[buttonData.Type] and type(buttonData.Detail) == "number" then
					local itemID = buttonData.Detail
					if not C_Item.GetItemInfo(itemID) then
						itemIDs[itemID] = true
					end
				end
			end
		end
	end

	PreloadFrame = CreateFrame("Frame")
	PreloadFrame.itemIDs = itemIDs
	PreloadFrame.petIDs = petIDs
	PreloadFrame.total_timeout = TOTAL_TIMEOUT_SECONDS
	PreloadFrame.step_timeout = STEP_TIMEOUT_SECONDS
	PreloadFrame:SetScript("OnUpdate", PreloadFrameOnUpdate)
	PreloadFrame:Show()
end
