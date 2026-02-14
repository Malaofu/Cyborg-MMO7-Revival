--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/RebindPage.lua
--~ Description: Rebind subpage and keybind mutation logic

---@class CyborgMMO_OptionSubPageRebind
---@field Panel Frame
---@field MouseRows table
local Constants = CyborgMMO.Constants
local Core = CyborgMMO.Core
local Globals = Core.Globals
Core.UI = Core.UI or {}
Core.UI.Rebind = Core.UI.Rebind or {}

local RAT_BUTTONS = Constants.RAT_BUTTONS
local RAT_MODES = Constants.RAT_MODES

local function BuildButtonName(rowName, mode)
	return rowName .. "Mode" .. mode
end

local function BuildRowLabelKey(index)
	return "CyborgMMO_OptionPageRebindMouseRow" .. string.format("%X", index) .. "Name"
end

local function GetButtonIndexFromName(name)
	local s_row, s_mode = name:match("Row(.)Mode(.)")
	local row = tonumber(s_row, 16)
	local mode = tonumber(s_mode)
	return (mode - 1) * RAT_BUTTONS + row
end

local BindSession = {
	buttonName = nil,
}

function BindSession:SetTarget(buttonName)
	self.buttonName = buttonName
end

function BindSession:GetTarget()
	return self.buttonName
end

function BindSession:IsModeBinding()
	return self.buttonName and self.buttonName:match("CyborgMMO_OptionSubPageRebindMouseMode(%d)") ~= nil
end

function BindSession:GetMode()
	if not self.buttonName then
		return nil
	end
	local modeStr = self.buttonName:match("CyborgMMO_OptionSubPageRebindMouseMode(%d)")
	if not modeStr then
		return nil
	end
	return tonumber(modeStr)
end

local function SetBindingButtonText(name)
	local binding = Globals.GetProfileKeyBindings()[GetButtonIndexFromName(name)]
	_G[name]:SetText(binding)
end

local function SetBindingModeButtonText(name, mode)
	local binding = Globals.GetProfileModeKeyBindings()[mode]
	_G[name]:SetText(binding)
end

local function ShowBindingDialog(titleText, currentBinding)
	CyborgMMO_BindingFrame.ButtonName:SetText(titleText)
	CyborgMMO_BindingFrame.Key:SetText(CyborgMMO_StringTable.CyborgMMO_CurrentBinding .. " " .. currentBinding)
	CyborgMMO_BindingFrame:Show()
end

local function OnBindingButtonEvent(buttonName, event)
	if event == "VARIABLES_LOADED" then
		SetBindingButtonText(buttonName)
	end
end

local function OnBindingModeButtonEvent(buttonName, mode, event)
	if event == "VARIABLES_LOADED" then
		SetBindingModeButtonText(buttonName, mode)
	end
end

local function CreateBindingButton(row, mode, owner)
	local buttonName = BuildButtonName(row:GetName(), mode)
	local button = CreateFrame("Button", buttonName, row, "UIPanelButtonTemplate")
	button:SetSize(145, 28)
	button:SetPoint("TOPLEFT", 135 + (mode - 1) * 145, 0)
	button:SetScript("OnClick", function()
		Core.UI.Rebind.BindButton(buttonName)
	end)
	button:SetScript("OnEvent", function(_, event)
		OnBindingButtonEvent(buttonName, event)
	end)
	button:RegisterEvent("VARIABLES_LOADED")

	owner.MouseRows[row.index] = owner.MouseRows[row.index] or {}
	owner.MouseRows[row.index][mode] = button
end

local function CreateMouseRow(panel, index, previousRow, owner)
	local row = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebindMouseRow" .. string.format("%X", index), panel)
	row.index = index
	row:SetSize(160, 28)
	if previousRow then
		row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -2)
	else
		row:SetPoint("TOPLEFT", 0, -40)
	end

	local rowName = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	rowName:SetPoint("TOPLEFT", 0, -10)
	rowName:SetText(CyborgMMO_StringTable[BuildRowLabelKey(index)])

	for mode = 1, RAT_MODES do
		CreateBindingButton(row, mode, owner)
	end

	return row
end

local function CreateModeOverwriteRow(panel, previousRow)
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
		button:SetScript("OnClick", function()
			Core.UI.Rebind.BindModeButton(mode)
		end)
		button:SetScript("OnEvent", function(_, event)
			OnBindingModeButtonEvent(buttonName, mode, event)
		end)
		button:RegisterEvent("VARIABLES_LOADED")
	end
end

CyborgMMO_OptionSubPageRebind = {
	Initialize = function(self)
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

		self.MouseRows = {}
		local previousRow
		for i = 1, RAT_BUTTONS do
			previousRow = CreateMouseRow(panel, i, previousRow, self)
		end

		CreateModeOverwriteRow(panel, previousRow)

		local category = Settings.RegisterCanvasLayoutSubcategory(CyborgMMO_OptionPage.Category, panel, panel.name)
		self.Category = category
		Settings.RegisterAddOnCategory(category)
	end
}

CyborgMMO_OptionSubPageRebind:Initialize()

function Core.UI.Rebind.BindButton(name)
	BindSession:SetTarget(name)
	local index = Core.UI.Rebind.GetButtonIndex(name)
	local mode = 1
	while index > RAT_BUTTONS do
		mode = mode + 1
		index = index - RAT_BUTTONS
	end
	local buttonStr = CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseRow" .. index .. "Name"]

	ShowBindingDialog(
		buttonStr .. " Mode " .. mode,
		Globals.GetProfileKeyBindings()[Core.UI.Rebind.GetButtonIndex(BindSession:GetTarget())]
	)
end

function Core.UI.Rebind.BindModeButton(mode)
	BindSession:SetTarget("CyborgMMO_OptionSubPageRebindMouseMode" .. mode)
	local buttonStr = CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMouseModeName

	ShowBindingDialog(buttonStr .. " Mode " .. mode, Globals.GetProfileModeKeyBindings()[mode])
end

function Core.UI.Rebind.SetBindingButtonText(name)
	SetBindingButtonText(name)
end

function Core.UI.Rebind.SetBindingModeButtonText(name, mode)
	SetBindingModeButtonText(name, mode)
end

function Core.UI.Rebind.GetButtonIndex(name)
	return GetButtonIndexFromName(name)
end

function Core.UI.Rebind.SetNewKeybind(keyOrButton)
	local target = BindSession:GetTarget()
	if not target then
		return
	end

	if BindSession:IsModeBinding() then
		local mode = BindSession:GetMode() or 1
		Globals.GetProfileModeKeyBindings()[mode] = keyOrButton
		Core.UI.Rebind.SetBindingModeButtonText(target, mode)
	else
		Globals.GetProfileKeyBindings()[Core.UI.Rebind.GetButtonIndex(target)] = keyOrButton
		Core.UI.Rebind.SetBindingButtonText(target)
	end

	CyborgMMO_BindingFrame:Hide()
	CyborgMMO_RatPageModel:LoadData()
	Core.UI.SetupAllModeCallbacks()
end
