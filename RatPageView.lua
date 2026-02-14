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
local Frames = Core.UI.Frames

local RAT_BUTTONS = Constants.RAT_BUTTONS
local RAT_MODES = Constants.RAT_MODES
local MEDIA_PATH = Constants.MEDIA_PATH

local RAT_LAYOUTS = CyborgMMO.Data and CyborgMMO.Data.RatLayouts or {}
local MAIN_SLOT_LAYOUT = RAT_LAYOUTS.mainSlots or {}
local QUICK_SLOT_LAYOUT = RAT_LAYOUTS.quickSlots or {}

local SlotView = {}
local ModeView = {}

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

local function UpdateSlotIcon(slot, data, activeMode)
	local icon = _G[slot:GetName() .. "Icon"]
	if not icon then
		return
	end

	local activeModeData = data and data[activeMode]
	local object = activeModeData and activeModeData[slot.Id]
	if object then
		slot:SetChecked(true)
		icon:SetTexture(object.texture)
		if slot._iconAlpha then
			icon:SetAlpha(slot._iconAlpha)
		end
	else
		icon:SetTexture(nil)
		slot:SetChecked(false)
	end
end

function SlotView.OnMouseDown(self, button)
	if button ~= "LeftButton" then
		return
	end
	if not self._isClickable or not self._ratParent then
		return
	end
	self._ratParent.SlotClicked(self)
end

function SlotView.OnModelUpdate(self, data, activeMode)
	UpdateSlotIcon(self, data, activeMode)
end

function SlotView.Bind(slot, parentFrame, options)
	if not slot then
		return
	end

	slot.Id = slot:GetID()
	slot._ratParent = parentFrame
	slot._iconAlpha = options and options.alpha or nil
	slot._isClickable = options and options.clickable or false

	Core.Rat.Model:AddObserver(slot)

	if slot._isClickable then
		slot:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		slot:SetScript("OnMouseDown", SlotView.OnMouseDown)
	else
		slot:SetScript("OnMouseDown", nil)
	end

	slot.Update = function(data, activeMode)
		SlotView.OnModelUpdate(slot, data, activeMode)
	end
end

function ModeView.OnClick(self)
	if not self._ratParent then
		return
	end
	local nextModeId = (self.Id % RAT_MODES) + 1
	local nextMode = self._ratParent._modeFrames[nextModeId]
	if nextMode then
		self._ratParent.ModeClicked(nextMode)
	end
end

function ModeView.OnModelUpdate(self, _, activeMode)
	if self.Id == activeMode then
		self:Show()
	else
		self:Hide()
	end
end

function ModeView.Bind(modeFrame, parentFrame)
	if not modeFrame then
		return
	end

	modeFrame.Id = modeFrame:GetID()
	modeFrame._ratParent = parentFrame
	Core.Rat.Model:AddObserver(modeFrame)
	modeFrame:SetScript("OnClick", ModeView.OnClick)
	modeFrame.Update = function(data, activeMode)
		ModeView.OnModelUpdate(modeFrame, data, activeMode)
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
		ModeView.Bind(modeFrame, frame)
	end

	for slotId = 1, RAT_BUTTONS do
		local slot = FrameLookup.GetRatSlotButton(frame, slotId)
		SlotView.Bind(slot, frame, { clickable = true })
	end
end

function Core.UI.RatPageView.RatQuickPageOnLoad(frame)
	Frames.SetRatQuickPage(frame)
	EnsureRatSlots(frame, "CyborgMMO_TemplateSmallSlot", QUICK_SLOT_LAYOUT, false)

	function frame.SlotClicked(slot)
		Core.Rat.Controller:SlotClicked(slot)
	end

	for slotId = 1, RAT_BUTTONS do
		local slot = FrameLookup.GetRatSlotButton(frame, slotId)
		SlotView.Bind(slot, frame, { alpha = 0.5, clickable = false })
	end
end

