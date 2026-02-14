--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/RebindPage.lua
--~ Description: Rebind subpage and keybind mutation logic

---@class CyborgMMO_OptionSubPageRebind
---@field Panel Frame
---@field MouseRows table
local Constants = CyborgMMO.Constants

CyborgMMO_OptionSubPageRebind = {
	Initialize = function(self)
		local RAT_BUTTONS = Constants.RAT_BUTTONS
		local RAT_MODES = Constants.RAT_MODES

		local panel = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebind", UIParent, "BackdropTemplate")
		self.Panel = panel
		panel:SetPoint("TOPLEFT", 15, -15)
		panel.name = CyborgMMO_StringTable.CyborgMMO_OptionPageRebindTitle

		local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", 0, 0)
		title:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindTitle)

		local mode1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		mode1:SetPoint("TOPLEFT", 147, -28)
		mode1:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMode1)

		local mode2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		mode2:SetPoint("TOPLEFT", 282, -28)
		mode2:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMode2)

		local mode3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		mode3:SetPoint("TOPLEFT", 427, -28)
		mode3:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMode3)

		local function OnBindingButtonEvent(buttonName, event)
			if event == "VARIABLES_LOADED" then
				CyborgMMO_SetBindingButtonText(buttonName)
			end
		end

		local function OnBindingModeButtonEvent(buttonName, mode, event)
			if event == "VARIABLES_LOADED" then
				CyborgMMO_SetBindingModeButtonText(buttonName, mode)
			end
		end

		self.MouseRows = {}
		local previousRow
		for i = 1, RAT_BUTTONS do
			local row = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebindMouseRow" .. string.format("%X", i), panel)
			row:SetSize(160, 28)
			if previousRow then
				row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -2)
			else
				row:SetPoint("TOPLEFT", 0, -40)
			end

			local rowName = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
			rowName:SetPoint("TOPLEFT", 0, -10)
			rowName:SetText(CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseRow" .. string.format("%X", i) .. "Name"])

			for mode = 1, RAT_MODES do
				local buttonName = row:GetName() .. "Mode" .. mode
				local button = CreateFrame("Button", buttonName, row, "UIPanelButtonTemplate")
				button:SetSize(145, 28)
				button:SetPoint("TOPLEFT", 135 + (mode - 1) * 145, 0)
				button:SetScript("OnClick", function() CyborgMMO_BindButton(buttonName) end)
				button:SetScript("OnEvent", function(_, event) OnBindingButtonEvent(buttonName, event) end)
				button:RegisterEvent("VARIABLES_LOADED")
				self.MouseRows[i] = self.MouseRows[i] or {}
				self.MouseRows[i][mode] = button
			end

			previousRow = row
		end

		local modeOverwriteRow = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebindMouseMode", panel)
		modeOverwriteRow:SetSize(160, 28)
		modeOverwriteRow:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -30)
		local modeOverwriteName = modeOverwriteRow:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		modeOverwriteName:SetPoint("TOPLEFT", 0, -10)
		modeOverwriteName:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMouseModeName)

		for mode = 1, RAT_MODES do
			local buttonName = modeOverwriteRow:GetName() .. mode
			local button = CreateFrame("Button", buttonName, modeOverwriteRow, "UIPanelButtonTemplate")
			button:SetSize(145, 28)
			button:SetPoint("TOPLEFT", 135 + (mode - 1) * 145, 0)
			button:SetScript("OnClick", function() CyborgMMO_BindModeButton(mode) end)
			button:SetScript("OnEvent", function(_, event) OnBindingModeButtonEvent(buttonName, mode, event) end)
			button:RegisterEvent("VARIABLES_LOADED")
		end

		local category = Settings.RegisterCanvasLayoutSubcategory(CyborgMMO_OptionPage.Category, panel, panel.name)
		self.Category = category
		Settings.RegisterAddOnCategory(category)
	end
}

CyborgMMO_OptionSubPageRebind:Initialize()

local lastButton

function CyborgMMO_BindButton(name)
	lastButton = name
	local index = CyborgMMO_GetButtonIndex(name)
	local mode = 1
	while index > Constants.RAT_BUTTONS do
		mode = mode + 1
		index = index - Constants.RAT_BUTTONS
	end
	local buttonStr = CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseRow" .. index .. "Name"]

	CyborgMMO_BindingFrame.ButtonName:SetText(buttonStr .. " Mode " .. mode)
	CyborgMMO_BindingFrame.Key:SetText(
		CyborgMMO_StringTable.CyborgMMO_CurrentBinding ..
		" " .. CyborgMMO_ProfileKeyBindings[CyborgMMO_GetButtonIndex(lastButton)]
	)
	CyborgMMO_BindingFrame:Show()
end

function CyborgMMO_BindModeButton(mode)
	lastButton = "CyborgMMO_OptionSubPageRebindMouseMode" .. mode
	local buttonStr = CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMouseModeName

	CyborgMMO_BindingFrame.ButtonName:SetText(buttonStr .. " Mode " .. mode)
	CyborgMMO_BindingFrame.Key:SetText(
		CyborgMMO_StringTable.CyborgMMO_CurrentBinding .. " " .. CyborgMMO_ProfileModeKeyBindings[mode]
	)
	CyborgMMO_BindingFrame:Show()
end

function CyborgMMO_SetBindingButtonText(name)
	local binding = CyborgMMO_ProfileKeyBindings[CyborgMMO_GetButtonIndex(name)]
	_G[name]:SetText(binding)
end

function CyborgMMO_SetBindingModeButtonText(name, mode)
	local binding = CyborgMMO_ProfileModeKeyBindings[mode]
	_G[name]:SetText(binding)
end

function CyborgMMO_GetButtonIndex(name)
	local s_row, s_mode = name:match("Row(.)Mode(.)")
	local row = tonumber(s_row, 16)
	local mode = tonumber(s_mode)
	return (mode - 1) * Constants.RAT_BUTTONS + row
end

function CyborgMMO_SetNewKeybind(keyOrButton)
	local modeStr = lastButton:match("CyborgMMO_OptionSubPageRebindMouseMode(%d)")
	if modeStr then
		local mode = tonumber(modeStr) or 1
		CyborgMMO_ProfileModeKeyBindings[mode] = keyOrButton
		CyborgMMO_SetBindingModeButtonText(lastButton, mode)
	else
		CyborgMMO_ProfileKeyBindings[CyborgMMO_GetButtonIndex(lastButton)] = keyOrButton
		CyborgMMO_SetBindingButtonText(lastButton)
	end

	CyborgMMO_BindingFrame:Hide()
	CyborgMMO_RatPageModel:LoadData()
	CyborgMMO_SetupAllModeCallbacks()
end
