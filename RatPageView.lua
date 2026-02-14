--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: RatPageView.lua
--~ Description: Interaction logic for Rat and RatQuick pages
--~ Copyright (C) 2012 Mad Catz Inc.
--~ Author: Christopher Hooks

local Constants = CyborgMMO.Constants
local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.RatPageView = Core.UI.RatPageView or {}
Core.Rat = Core.Rat or {}
local FrameLookup = Core.UI.FrameLookup
local RAT_BUTTONS = Constants.RAT_BUTTONS
local RAT_MODES = Constants.RAT_MODES
local MEDIA_PATH = Constants.MEDIA_PATH

local RAT_LAYOUTS = CyborgMMO.Data and CyborgMMO.Data.RatLayouts or {}
local MAIN_SLOT_LAYOUT = RAT_LAYOUTS.mainSlots or {}
local QUICK_SLOT_LAYOUT = RAT_LAYOUTS.quickSlots or {}

local function EnsureSlotBackdrop(slot, textureName)
	if not textureName then
		return
	end

	local backdrop = slot._slotBackdrop
	if not backdrop then
		backdrop = slot:CreateTexture(nil, "ARTWORK")
		backdrop:SetSize(33, 33)
		backdrop:SetPoint("CENTER", 0, 0)
		slot._slotBackdrop = backdrop
	end
	backdrop:SetTexture(MEDIA_PATH .. textureName)
end

local function EnsureSlotButton(parentFrame, templateName, slotId, layout, includeBackdrop)
	if not layout then
		return nil
	end

	local slotName = parentFrame:GetName() .. "Slot" .. slotId
	local slot = _G[slotName]
	if not slot then
		slot = CreateFrame("CheckButton", slotName, parentFrame, templateName)
	end

	slot:SetID(slotId)
	slot:ClearAllPoints()
	slot:SetPoint("TOPLEFT", layout.x, layout.y)

	if includeBackdrop then
		EnsureSlotBackdrop(slot, layout.texture)
	end

	return slot
end

local function EnsureRatSlots(parentFrame, templateName, layouts, includeBackdrop)
	for slotId = 1, RAT_BUTTONS do
		EnsureSlotButton(parentFrame, templateName, slotId, layouts[slotId], includeBackdrop)
	end
end

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
	Core.Rat.Model:AddObserver(slot)

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
	Core.Rat.Model:AddObserver(modeFrame)
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

function Core.UI.RatPageView.RatPageOnLoad(frame)
	Core.Debug.Log("new Rat Page View")
	EnsureRatSlots(frame, "CyborgMMO_TemplateSlot", MAIN_SLOT_LAYOUT, true)

	function frame.SlotClicked(slot)
		Core.Debug.Log("View Received Click")
		Core.Rat.Controller:SlotClicked(slot)
	end

	function frame.ModeClicked(modeFrame)
		Core.Debug.Log("View Received Click")
		Core.Rat.Controller:ModeClicked(modeFrame)
	end

	frame._modeFrames = {}
	for mode = 1, RAT_MODES do
		local modeFrame = FrameLookup.GetRatModeButton(frame, mode)
		frame._modeFrames[mode] = modeFrame
		BindModeView(modeFrame, frame)
	end

	for slotId = 1, RAT_BUTTONS do
		local slot = FrameLookup.GetRatSlotButton(frame, slotId)
		BindSlotView(slot, frame, nil, true)
	end
end

function Core.UI.RatPageView.RatQuickPageOnLoad(frame)
	EnsureRatSlots(frame, "CyborgMMO_TemplateSmallSlot", QUICK_SLOT_LAYOUT, false)

	function frame.SlotClicked(slot)
		Core.Rat.Controller:SlotClicked(slot)
	end
	
	for slotId = 1, RAT_BUTTONS do
		local slot = FrameLookup.GetRatSlotButton(frame, slotId)
		BindSlotView(slot, frame, 0.5, false)
	end
end

