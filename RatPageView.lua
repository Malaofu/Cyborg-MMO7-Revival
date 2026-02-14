--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: RatPageView.lua
--~ Description: Interaction logic for Rat and RatQuick pages
--~ Copyright (C) 2012 Mad Catz Inc.
--~ Author: Christopher Hooks

local RAT_BUTTONS = CyborgMMO_Constants.RAT_BUTTONS
local RAT_MODES = CyborgMMO_Constants.RAT_MODES

local function UpdateSlotIcon(frame, data, activeMode, alpha)
	local icon = _G[frame:GetName() .. "Icon"]
	local object = data[activeMode][frame.Id]
	if object then
		frame:SetChecked(true)
		icon:SetTexture(object.texture)
		if alpha then
			icon:SetAlpha(alpha)
		end
	else
		icon:SetTexture(nil)
		frame:SetChecked(false)
	end
end

local function SlotOnMouseDown(self, button)
	if button == "LeftButton" and self.Clicked then
		self:Clicked()
	end
end

local function ModeOnClick(self)
	if self.Clicked then
		self:Clicked()
	end
end

local function BindSlotView(slot, parentFrame, alpha, clickable)
	if not slot then
		return
	end

	slot.Id = slot:GetID()
	CyborgMMO_RatPageModel:AddObserver(slot)

	if clickable then
		slot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		slot:SetScript("OnMouseDown", SlotOnMouseDown)
		function slot:Clicked()
			parentFrame.SlotClicked(self)
		end
	end

	slot.Update = function(data, activeMode)
		UpdateSlotIcon(slot, data, activeMode, alpha)
	end
end

local function BindModeView(modeFrame, parentFrame)
	if not modeFrame then
		return
	end

	modeFrame.Id = modeFrame:GetID()
	CyborgMMO_RatPageModel:AddObserver(modeFrame)
	modeFrame:SetScript("OnClick", ModeOnClick)

	function modeFrame:Clicked()
		local nextModeId = (self.Id % RAT_MODES) + 1
		local nextMode = parentFrame._modeFrames[nextModeId]
		if nextMode then
			parentFrame.ModeClicked(nextMode)
		end
	end

	modeFrame.Update = function(_, activeMode)
		if modeFrame.Id == activeMode then
			modeFrame:Show()
		else
			modeFrame:Hide()
		end
	end

	if modeFrame.Id ~= 1 then
		modeFrame:Hide()
	end
end

function CyborgMMO_RatPage_OnLoad(frame)
	CyborgMMO_DPrint("new Rat Page View")

	function frame.SlotClicked(slot)
		CyborgMMO_DPrint("View Received Click")
		CyborgMMO_RatPageController:SlotClicked(slot)
	end

	function frame.ModeClicked(modeFrame)
		CyborgMMO_DPrint("View Received Click")
		CyborgMMO_RatPageController:ModeClicked(modeFrame)
	end

	frame._modeFrames = {}
	for mode = 1, RAT_MODES do
		local modeFrame = CyborgMMO_GetRatModeButton(frame, mode)
		frame._modeFrames[mode] = modeFrame
		BindModeView(modeFrame, frame)
	end

	for slotId = 1, RAT_BUTTONS do
		local slot = CyborgMMO_GetRatSlotButton(frame, slotId)
		BindSlotView(slot, frame, nil, true)
	end
end

function CyborgMMO_RatQuickPage_OnLoad(frame)
	function frame.SlotClicked(slot)
		CyborgMMO_RatPageController:SlotClicked(slot)
	end
	
	for slotId = 1, RAT_BUTTONS do
		local slot = CyborgMMO_GetRatSlotButton(frame, slotId)
		BindSlotView(slot, frame, 0.5, false)
	end
end
