--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/BindingDialog.lua
--~ Description: Binding capture popup and input handling

---@class CyborgMMO_BindingFrame
---@field Frame Frame
---@field ButtonName FontString
---@field Key FontString
CyborgMMO_BindingFrame = {
	Show = function(self)
		self.Frame:Show()
	end,
	Hide = function(self)
		self.Frame:Hide()
	end,
	Initialize = function(self)
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

		local header = frame:CreateTexture(nil, "ARTWORK")
		header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
		header:SetSize(500, 64)
		header:SetPoint("TOP", 0, 12)

		local headerText = frame:CreateFontString("CyborgMMO_BindingFrameHeaderText", "ARTWORK", "GameFontNormal")
		headerText:SetSize(500, 13)
		headerText:SetPoint("TOP", header, "TOP", 0, -13)

		local buttonName = frame:CreateFontString("CyborgMMO_BindingFrameButtonName", "ARTWORK", "GameFontNormalLarge")
		self.ButtonName = buttonName
		buttonName:SetPoint("CENTER", frame, "CENTER", 0, 32)

		local keyText = frame:CreateFontString("CyborgMMO_BindingFrameKey", "ARTWORK", "GameFontNormalLarge")
		self.Key = keyText
		keyText:SetPoint("CENTER", frame, "CENTER", 0, -16)

		local closeButton = CreateFrame("Button", "CyborgMMO_BindingFrameCloseButton", frame, "UIPanelCloseButton")
		closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)

		local exitButton = CreateFrame("Button", "CyborgMMO_BindingFrameExitButton", frame, "UIPanelButtonTemplate")
		exitButton:SetSize(80, 26)
		exitButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -12, 12)
		exitButton:SetScript("OnClick", function() frame:Hide() end)

		frame:SetScript("OnKeyDown", function(_, key)
			CyborgMMO_BindingFrameOnKeyDown(key)
		end)
		frame:SetScript("OnMouseWheel", function(_, delta)
			if delta > 0 then
				CyborgMMO_BindingFrameOnKeyDown("MOUSEWHEELUP")
			else
				CyborgMMO_BindingFrameOnKeyDown("MOUSEWHEELDOWN")
			end
		end)
		frame:SetScript("OnClick", function(_, button)
			CyborgMMO_BindingFrameOnKeyDown(button)
		end)
		frame:SetScript("OnShow", function()
			CyborgMMO_LoadStrings(headerText)
			CyborgMMO_LoadStrings(exitButton)
		end)
	end
}

CyborgMMO_BindingFrame:Initialize()

function CyborgMMO_BindingFrameOnKeyDown(keyOrButton)
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

	if keyPressed == "LSHIFT" or keyPressed == "RSHIFT" or keyPressed == "LCTRL" or
		keyPressed == "RCTRL" or keyPressed == "LALT" or keyPressed == "RALT" then
		return
	end

	if IsShiftKeyDown() then
		keyPressed = "SHIFT-" .. keyPressed
	end
	if IsControlKeyDown() then
		keyPressed = "CTRL-" .. keyPressed
	end
	if IsAltKeyDown() then
		keyPressed = "ALT-" .. keyPressed
	end

	if keyPressed == "BUTTON1" or keyPressed == "BUTTON2" then
		return
	end

	CyborgMMO_SetNewKeybind(keyPressed)
end
