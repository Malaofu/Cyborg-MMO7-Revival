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
local ROW_PREFIX = "CyborgMMO_OptionSubPageRebindMouseRow"
local MODE_PREFIX = "CyborgMMO_OptionSubPageRebindMouseMode"

local function BuildButtonName(rowIndex, mode)
	return string.format("%s%XMode%d", ROW_PREFIX, rowIndex, mode)
end

local function BuildRowLabelKey(index)
	return "CyborgMMO_OptionPageRebindMouseRow" .. string.format("%X", index) .. "Name"
end

local function BuildModeButtonName(mode)
	return MODE_PREFIX .. mode
end

local function ParseButtonName(name)
	if type(name) ~= "string" then
		return nil, nil
	end
	local rowHex, modeStr = name:match("MouseRow([0-9A-F])Mode(%d+)")
	if not rowHex or not modeStr then
		return nil, nil
	end
	return tonumber(rowHex, 16), tonumber(modeStr)
end

local function GetButtonIndexFromName(name)
	local row, mode = ParseButtonName(name)
	if not row or not mode then
		return nil
	end
	return (mode - 1) * RAT_BUTTONS + row
end

local function ParseModeButtonName(name)
	if type(name) ~= "string" then
		return nil
	end
	local modeStr = name:match("CyborgMMO_OptionSubPageRebindMouseMode(%d+)")
	return modeStr and tonumber(modeStr) or nil
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
	return ParseModeButtonName(self.buttonName) ~= nil
end

function BindSession:GetMode()
	return ParseModeButtonName(self.buttonName)
end

local function SetBindingButtonText(name)
	local buttonIndex = GetButtonIndexFromName(name)
	if not buttonIndex then
		return
	end
	local button = _G[name]
	if not button then
		return
	end
	local binding = Globals.GetProfileKeyBindings()[buttonIndex]
	button:SetText(binding)
end

local function SetBindingModeButtonText(name, mode)
	local button = _G[name]
	if not button then
		return
	end
	local binding = Globals.GetProfileModeKeyBindings()[mode]
	button:SetText(binding)
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
	local buttonName = BuildButtonName(row.index, mode)
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
	local row = CreateFrame("Frame", string.format("%s%X", ROW_PREFIX, index), panel)
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
	local modeOverwriteRow = CreateFrame("Frame", MODE_PREFIX, panel)
	modeOverwriteRow:SetSize(160, 28)
	modeOverwriteRow:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -30)

	local modeOverwriteName = modeOverwriteRow:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	modeOverwriteName:SetPoint("TOPLEFT", 0, -10)
	modeOverwriteName:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMouseModeName)

	for mode = 1, RAT_MODES do
		local buttonName = BuildModeButtonName(mode)
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

local function CreateModeHeaders(panel)
	for mode = 1, RAT_MODES do
		local modeText = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		modeText:SetPoint("TOPLEFT", 147 + (mode - 1) * 135, -28)
		modeText:SetText(CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMode" .. mode])
	end
end

CyborgMMO_OptionSubPageRebind = {
	Initialize = function(self)
		local panel = CreateFrame("Frame", "CyborgMMO_OptionSubPageRebind", UIParent, "BackdropTemplate")
		self.Panel = panel
		panel:SetPoint("TOPLEFT", 15, -15)
		panel.name = CyborgMMO_StringTable.CyborgMMO_OptionPageRebindTitle

		local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", 0, 0)
		title:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindTitle)

		CreateModeHeaders(panel)

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

	local row, mode = ParseButtonName(name)
	if not row or not mode then
		return
	end

	local buttonStr = CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseRow" .. row .. "Name"]
	local bindingIndex = Core.UI.Rebind.GetButtonIndex(name)
	if not bindingIndex then
		return
	end

	ShowBindingDialog(
		buttonStr .. " Mode " .. mode,
		Globals.GetProfileKeyBindings()[bindingIndex]
	)
end

function Core.UI.Rebind.BindModeButton(mode)
	BindSession:SetTarget(BuildModeButtonName(mode))
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

function Core.UI.Rebind.GetButtonName(row, mode)
	return BuildButtonName(row, mode)
end

function Core.UI.Rebind.GetModeButtonName(mode)
	return BuildModeButtonName(mode)
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
		local buttonIndex = Core.UI.Rebind.GetButtonIndex(target)
		if not buttonIndex then
			return
		end
		Globals.GetProfileKeyBindings()[buttonIndex] = keyOrButton
		Core.UI.Rebind.SetBindingButtonText(target)
	end

	CyborgMMO_BindingFrame:Hide()
	Core.Rat.Model:LoadData()
	Core.UI.SetupAllModeCallbacks()
end

