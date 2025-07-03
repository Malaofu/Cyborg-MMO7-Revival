--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: OptionPage.lua
--~ Description: The settings page for the Cyborg MMO7 addon
--~ Copyright (C) 2012 Mad Catz Inc.
--~ Author: Christopher Hooks
--~ Modifications: Malaofu

--~ This program is free software; you can redistribute it and/or
--~ modify it under the terms of the GNU General Public License
--~ as published by the Free Software Foundation; either version 2
--~ of the License, or (at your option) any later version.

--~ This program is distributed in the hope that it will be useful,
--~ but WITHOUT ANY WARRANTY; without even the implied warranty of
--~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--~ GNU General Public License for more details.

--~ You should have received a copy of the GNU General Public License
--~ along with this program; if not, write to the Free Software
--~ Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

---@class GeneralSettings
---@field MiniMapButton boolean
---@field CyborgButton boolean
---@field PerSpecBindings boolean
---@field Cyborg number
---@field Plugin number
---@field MiniMapButtonAngle number
DefaultSettings = {
	MiniMapButton = true,
	CompartmentButton = true,
	CyborgButton = true,
	PerSpecBindings = false,
	Cyborg = 0.75,
	Plugin = 0.75,
	MiniMapButtonAngle = math.rad(150),
}

CyborgMMO_OptionPage = {
	Initialize = function(self)
		local category, layout = Settings.RegisterVerticalLayoutCategory("Cyborg MMO7")
		-- local subCategory = Settings.RegisterVerticalLayoutSubcategory(category, "Key Bindings")

		-- Settings.SetKeybindingsCategory(subCategory)

		local function SliderOptions(min, max, step)
			local options = Settings.CreateSliderOptions(min, max, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Min, min);
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Max, max);
			return options
		end

		 -- Minimap Icon Checkbox
		 do
            local variable = "CyborgMMO_OptionPageMiniMapButton"
            local name = CyborgMMO_StringTable.CyborgMMO_OptionPageMiniMapButtonTitle
            local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageMiniMapButtonTooltip
            local defaultValue = DefaultSettings.MiniMapButton

            local function GetValue()
                return CyborgMMO7SaveData.Settings.MiniMapButton
            end

            local function SetValue(value)
                CyborgMMO_SetMiniMapButton(value)
            end

            local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
            Settings.CreateCheckbox(category, setting, tooltip)
        end

		-- Compartment Icon Checkbox
		do
			-- Compartment is only available in Mainline
			if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
				local variable = "CyborgMMO_OptionPageCompartmentButton"
				local name = CyborgMMO_StringTable.CyborgMMO_OptionPageCompartmentButtonTitle
				local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageCompartmentButtonTooltip
				local defaultValue = DefaultSettings.CompartmentButton

				local function GetValue()
					return CyborgMMO7SaveData.Settings.CompartmentButton
				end

				local function SetValue(value)
					CyborgMMO_SetCompartmentButton(value)
				end

				local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end


        -- Cyborg Head Button Checkbox
        do
            local variable = "CyborgMMO_OptionPageCyborgButton"
            local name = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgButtonTitle
            local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgButtonTooltip
            local defaultValue = DefaultSettings.CyborgButton

            local function GetValue()
                return CyborgMMO7SaveData.Settings.CyborgButton
            end

            local function SetValue(value)
                CyborgMMO_SetCyborgHeadButton(value)
            end

            local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
            Settings.CreateCheckbox(category, setting, tooltip)
        end

        -- Per-Spec Bindings Checkbox
        do
            local variable = "CyborgMMO_OptionPagePerSpecBindings"
            local name = CyborgMMO_StringTable.CyborgMMO_OptionPagePerSpecBindingsTitle
            local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPagePerSpecBindingsTooltip
            local defaultValue = DefaultSettings.PerSpecBindings

            local function GetValue()
                return CyborgMMO7SaveData.Settings.PerSpecBindings
            end

            local function SetValue(value)
                CyborgMMO_SetPerSpecBindings(value)
            end

            local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
            Settings.CreateCheckbox(category, setting, tooltip)
        end

        -- Cyborg Head Button Size Slider
        do
            local variable = "CyborgMMO_OptionPageCyborgSize"
            local name = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgSizeSliderTitle
            local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgSizeSliderTooltip
            local defaultValue = DefaultSettings.Cyborg * 100
			
            local function GetValue()
                return CyborgMMO7SaveData.Settings.Cyborg * 100
            end

            local function SetValue(value)
                CyborgMMO_SetOpenButtonSize(value / 100)
            end

            local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
            local options = SliderOptions(50, 100, 1)
            Settings.CreateSlider(category, setting, options, tooltip)
        end

        -- Plugin Size Slider
        do
            local variable = "CyborgMMO_OptionPagePluginSize"
            local name = CyborgMMO_StringTable.CyborgMMO_OptionPagePluginSizeSliderTitle
            local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPagePluginSizeSliderTooltip
            local defaultValue = DefaultSettings.Plugin * 100

            local function GetValue()
                return CyborgMMO7SaveData.Settings.Plugin * 100
            end

            local function SetValue(value)
                CyborgMMO_SetMainPageSize(value / 100)
            end

            local setting = Settings.RegisterProxySetting(category, variable, type(defaultValue), name, defaultValue, GetValue, SetValue)
            local options = SliderOptions(50, 100, 1)
            Settings.CreateSlider(category, setting, options, tooltip)
        end

        -- Register the category
        Settings.RegisterAddOnCategory(category)
		self.Category = category
	end
}
CyborgMMO_OptionPage:Initialize()

---@class CyborgMMO_OptionSubPageRebind
---@field Panel Frame The main rebind subpage panel
---@field MouseRows table A table containing all mouse button rows
CyborgMMO_OptionSubPageRebind = {
    Initialize = function(self)
        -- Create the main subpage panel
        local panel = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebind", UIParent, "BackdropTemplate")
        self.Panel = panel
        panel:SetPoint("TOPLEFT", 15, -15)
        panel.name = CyborgMMO_StringTable.CyborgMMO_OptionPageRebindTitle

        -- Title
        local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", 0, 0)
        title:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindTitle)

        -- Description
        local description = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        description:SetPoint("TOPLEFT", 135, -2)
        description:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindDescription)

        -- Mode Headers
        local mode1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        mode1:SetPoint("TOPLEFT", 147, -28)
        mode1:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMode1)

        local mode2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        mode2:SetPoint("TOPLEFT", 282, -28)
        mode2:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMode2)

        local mode3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        mode3:SetPoint("TOPLEFT", 427, -28)
        mode3:SetText(CyborgMMO_StringTable.CyborgMMO_OptionPageRebindMode3)

        -- Mouse Button Rows
        self.MouseRows = {}
        local previousRow = nil
        for i = 1, 13 do
            local row = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebindMouseRow" .. string.format("%X", i), panel)
            row:SetSize(160, 28)
            if previousRow then
                row:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -2)
            else
                row:SetPoint("TOPLEFT", 0, -40)
            end

            -- Row Name
            local rowName = row:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            rowName:SetPoint("TOPLEFT", 0, -10)
            rowName:SetText(CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseRow" .. string.format("%X", i) .. "Name"])

            -- Mode Buttons
            for mode = 1, 3 do
                local button = CreateFrame("Button", row:GetName() .. "Mode" .. mode, row, "UIPanelButtonTemplate")
                button:SetSize(145, 28)
                button:SetPoint("TOPLEFT", 135 + (mode - 1) * 145, 0)
                button:SetScript("OnClick", function()
                    CyborgMMO_BindButton(button:GetName())
                end)
				button:SetScript("OnEvent", function(self, event)
					if event == "VARIABLES_LOADED" then
						CyborgMMO_SetBindingButtonText(button:GetName())
					end
				end)
				button:RegisterEvent("VARIABLES_LOADED")
                self.MouseRows[i] = self.MouseRows[i] or {}
                self.MouseRows[i][mode] = button
            end

            previousRow = row
        end

        -- Add buttons for mode select overwrite
        local modeOvewriteRow = CreateFrame("FRAME", "CyborgMMO_OptionSubPageRebindMouseMode", panel)
        modeOvewriteRow:SetSize(160, 28)
        modeOvewriteRow:SetPoint("TOPLEFT", previousRow, "BOTTOMLEFT", 0, -30)
        local modeOverwriteName = modeOvewriteRow:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        modeOverwriteName:SetPoint("TOPLEFT", 0, -10)
        modeOverwriteName:SetText(CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseModeName"])
        for mode = 1, 3 do
            local button = CreateFrame("Button", modeOvewriteRow:GetName() .. mode, modeOvewriteRow, "UIPanelButtonTemplate")
            button:SetSize(145, 28)
            button:SetPoint("TOPLEFT", 135 + (mode - 1) * 145, 0)
            button:SetScript("OnClick", function()
                CyborgMMO_BindModeButton(mode)
            end)
            button:SetScript("OnEvent", function(self, event)
                if event == "VARIABLES_LOADED" then
                    CyborgMMO_SetBindingModeButtonText(button:GetName(), mode)
                end
            end)
            button:RegisterEvent("VARIABLES_LOADED")
        end

        -- Register the subpage
        local category = Settings.RegisterCanvasLayoutSubcategory(CyborgMMO_OptionPage.Category, panel, panel.name)
        self.Category = category
        Settings.RegisterAddOnCategory(category)
    end
}

CyborgMMO_OptionSubPageRebind:Initialize()

---@class CyborgMMO_BindingFrame
---@field Frame Frame The main binding frame
---@field ButtonName FontString The button name text
---@field Key FontString The key text
CyborgMMO_BindingFrame = {
	Show = function(self)
		self.Frame:Show()
	end,
	Hide = function(self)
		self.Frame:Hide()
	end,
    Initialize = function(self)
        -- Create the main binding frame
        local frame = CreateFrame("Button", "CyborgMMO_BindingFrame", UIParent, "BackdropTemplate")
		self.Frame = frame
		frame:SetBackdrop({
			bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
			edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
			tile = true,
			tileSize = 32,
			edgeSize = 32,
			insets = { left = 11, right = 12, top = 12, bottom = 11 },
		})
        frame:SetSize(400, 200)
        frame:SetPoint("CENTER")
        frame:SetFrameStrata("DIALOG")
        frame:SetMovable(true)
        frame:EnableMouse(true)
        frame:EnableKeyboard(true)
        frame:Hide()

        -- Header Texture
        local header = frame:CreateTexture(nil, "ARTWORK")
        header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
        header:SetSize(500, 64)
        header:SetPoint("TOP", 0, 12)

        -- Header Text
        local headerText = frame:CreateFontString("CyborgMMO_BindingFrameHeaderText", "ARTWORK", "GameFontNormal")
        headerText:SetSize(500, 13)
        headerText:SetPoint("TOP", header, "TOP", 0, -13)

        -- Button Name
        local buttonName = frame:CreateFontString("CyborgMMO_BindingFrameButtonName", "ARTWORK", "GameFontNormalLarge")
        self.ButtonName = buttonName
		buttonName:SetPoint("CENTER", frame, "CENTER", 0, 32)

        -- Key Text
        local keyText = frame:CreateFontString("CyborgMMO_BindingFrameKey", "ARTWORK", "GameFontNormalLarge")
		self.Key = keyText
        keyText:SetPoint("CENTER", frame, "CENTER", 0, -16)

        -- Close Button
        local closeButton = CreateFrame("Button", "CyborgMMO_BindingFrameCloseButton", frame, "UIPanelCloseButton")
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)

        -- Exit Button
        local exitButton = CreateFrame("Button", "CyborgMMO_BindingFrameExitButton", frame, "UIPanelButtonTemplate")
        exitButton:SetSize(80, 26)
        exitButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, 12)
        exitButton:SetScript("OnClick", function()
            frame:Hide()
        end)

        -- Register for key and mouse input
        frame:SetScript("OnKeyDown", function(_, key)
            CyborgMMO_BindingFrameOnKeyDown(frame, key)
        end)
        frame:SetScript("OnMouseWheel", function(_, delta)
            if delta > 0 then
                CyborgMMO_BindingFrameOnKeyDown(frame, "MOUSEWHEELUP")
            else
                CyborgMMO_BindingFrameOnKeyDown(frame, "MOUSEWHEELDOWN")
            end
        end)
        frame:SetScript("OnClick", function(_, button)
            CyborgMMO_BindingFrameOnKeyDown(frame, button)
        end)

        -- Localize strings on load
        frame:SetScript("OnShow", function()
            CyborgMMO_LoadStrings(headerText)
            CyborgMMO_LoadStrings(exitButton)
        end)
    end
}

-- Initialize the binding frame
CyborgMMO_BindingFrame:Initialize()

--- @type string
local lastButton = nil

function CyborgMMO_BindButton(name)
	lastButton = name
	local index = CyborgMMO_GetButtonIndex(name)
	local mode = 1
	while index > 13 do
		mode = mode + 1
		index = index - 13
	end
	local buttonStr = CyborgMMO_StringTable[("CyborgMMO_OptionPageRebindMouseRow" .. index .. "Name")]

	CyborgMMO_BindingFrame.ButtonName:SetText(buttonStr .. " Mode " .. mode)
	CyborgMMO_BindingFrame.Key:SetText(
		CyborgMMO_StringTable["CyborgMMO_CurrentBinding"] ..
			" " .. CyborgMMO_ProfileKeyBindings[CyborgMMO_GetButtonIndex(lastButton)]
	)
	CyborgMMO_BindingFrame:Show()
end

function CyborgMMO_BindModeButton(mode)
    lastButton = "CyborgMMO_OptionSubPageRebindMouseMode" .. mode
    local buttonStr = CyborgMMO_StringTable["CyborgMMO_OptionPageRebindMouseModeName"]

    CyborgMMO_BindingFrame.ButtonName:SetText(buttonStr .. " Mode " .. mode)
    CyborgMMO_BindingFrame.Key:SetText(
        CyborgMMO_StringTable["CyborgMMO_CurrentBinding"] .. " " .. CyborgMMO_ProfileModeKeyBindings[mode]
    )
    CyborgMMO_BindingFrame:Show()
end

function CyborgMMO_SetBindingButtonText(name)
	local binding = CyborgMMO_ProfileKeyBindings[CyborgMMO_GetButtonIndex(name)]
	getglobal(name):SetText(binding)
end

function CyborgMMO_SetBindingModeButtonText(name, mode)
    local binding = CyborgMMO_ProfileModeKeyBindings[mode]
    getglobal(name):SetText(binding)
end

function CyborgMMO_GetButtonIndex(name)
	local row, mode = name:match("Row(.)Mode(.)")
	row = tonumber(row, 16)
	mode = tonumber(mode)
	local modeStr = string.sub(name, mode + 1, mode + 2)
	local rowStr = string.sub(name, row - 1, row - 1)
	return (mode - 1) * 13 + row
end

function CyborgMMO_ShowProfileTooltip(self)
	if not CyborgMMO_ModeDetected then
		GameTooltip:SetOwner(self:GetParent(), "ANCHOR_RIGHT")
		GameTooltip:SetText(CyborgMMO_StringTable["CyborgMMO_ToolTipLine1"], nil, nil, nil, nil, 1)
		GameTooltip:AddLine(nil, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable["CyborgMMO_ToolTipLine2"], 0.8, 1.0, 0.8)
		GameTooltip:AddLine(nil, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable["CyborgMMO_ToolTipLine3"], 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable["CyborgMMO_ToolTipLine4"], 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable["CyborgMMO_ToolTipLine5"], 0.8, 1.0, 0.8)
		GameTooltip:AddLine(nil, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable["CyborgMMO_ToolTipLine6"], 0.8, 1.0, 0.8)
		GameTooltip:Show()
	end
end

function CyborgMMO_HideProfileTooltip(self)
	GameTooltip:Hide()
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
end

function CyborgMMO_BindingFrameOnKeyDown(self, keyOrButton)
	if keyOrButton == "ESCAPE" then
		CyborgMMO_BindingFrame:Hide()
		return
	end

	if GetBindingFromClick(keyOrButton) == "SCREENSHOT" then
		RunBinding("SCREENSHOT")
		return
	end

	local keyPressed = keyOrButton

	if keyPressed == "UNKNOWN" then
		return
	end

	-- Map mouse buttons using a table instead of multiple if-else statements
	local buttonMap = {
		LeftButton = "BUTTON1",
		RightButton = "BUTTON2",
		MiddleButton = "BUTTON3",
		Button4 = "BUTTON4",
		Button5 = "BUTTON5",
		Button6 = "BUTTON6",
		Button7 = "BUTTON7",
		Button8 = "BUTTON8",
		Button9 = "BUTTON9",
		Button10 = "BUTTON10",
		Button11 = "BUTTON11",
		Button12 = "BUTTON12",
		Button13 = "BUTTON13",
		Button14 = "BUTTON14",
		Button15 = "BUTTON15",
		Button16 = "BUTTON16",
		Button17 = "BUTTON17",
		Button18 = "BUTTON18",
		Button19 = "BUTTON19",
		Button20 = "BUTTON20",
		Button21 = "BUTTON21",
		Button22 = "BUTTON22",
		Button23 = "BUTTON23",
		Button24 = "BUTTON24",
		Button25 = "BUTTON25",
		Button26 = "BUTTON26",
		Button27 = "BUTTON27",
		Button28 = "BUTTON28",
		Button29 = "BUTTON29",
		Button30 = "BUTTON30",
		Button31 = "BUTTON31",
	}

	keyPressed = buttonMap[keyPressed] or keyPressed

	-- Skip modifier-only presses
	if keyPressed == "LSHIFT" or keyPressed == "RSHIFT" or keyPressed == "LCTRL" or keyPressed == "RCTRL" or
	   keyPressed == "LALT" or keyPressed == "RALT" then
		return
	end

	-- Combine with modifiers if needed
	if IsShiftKeyDown() then
		keyPressed = "SHIFT-" .. keyPressed
	end
	if IsControlKeyDown() then
		keyPressed = "CTRL-" .. keyPressed
	end
	if IsAltKeyDown() then
		keyPressed = "ALT-" .. keyPressed
	end

	-- Skip left and right mouse buttons
	if keyPressed == "BUTTON1" or keyPressed == "BUTTON2" then
		return
	end

	CyborgMMO_SetNewKeybind(keyPressed)
end
