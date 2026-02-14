--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: RatPageView.lua
--~ Description: Interaction logic for the RatPage
--~ Copyright (C) 2012 Mad Catz Inc.
--~ Author: Christopher Hooks

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

local function RegisterChildren(frame)
	for _, child in ipairs(frame:GetChildren()) do
		child.Register()
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

CyborgMMO_RatPageView = {
	new = function(self)
		CyborgMMO_DPrint("new Rat Page View")
		RegisterChildren(self)

		self.SlotClicked = function(slot)
			CyborgMMO_DPrint("View Received Click")
			CyborgMMO_RatPageController:SlotClicked(slot)
		end

		self.ModeClicked = function(mode)
			CyborgMMO_DPrint("View Received Click")
			CyborgMMO_RatPageController:ModeClicked(mode)
		end

		self.RegisterMode = function()
			CyborgMMO_DPrint("ModeRegistered")
		end

		self.RegisterSlot = function()
			CyborgMMO_DPrint("SlotRegistered")
		end

		return self
	end,
}

CyborgMMO_RatQuickPageView = {
	new = function(self)
		RegisterChildren(self)

		self.SlotClicked = function(slot)
			CyborgMMO_RatPageController:SlotClicked(slot)
		end

		return self
	end,
}

-- Slot Class --
CyborgMMO_SlotView = {
	new = function(self)
		self._assignedWowObject = nil
		self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
		self.Id = self:GetID()
		CyborgMMO_RatPageModel:AddObserver(self)
		self.UnCheckedTexture = self:GetNormalTexture()

		-- Object Method --
		self.Clicked = function()
			self:GetParent().SlotClicked(self)

			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		--	GameTooltip:SetText(self:GetID())
		end

		self.Update = function(data, activeMode)
			UpdateSlotIcon(self, data, activeMode)
		end

		return self
	end,
}

CyborgMMO_SlotMiniView = {
	new = function(self)
		self._assignedWowObject = nil
		self.Id = self:GetID()
		CyborgMMO_RatPageModel:AddObserver(self)
		self.UnCheckedTexture = self:GetNormalTexture()

		self.Update = function(data, activeMode)
			UpdateSlotIcon(self, data, activeMode, 0.5)
		end

		return self
	end,
}


-- ModeButton --
CyborgMMO_ModeView = {
	new = function(self)
		self.Id = self:GetID()
		CyborgMMO_RatPageModel:AddObserver(self)
		if self.Id ~= 1 then
			self:Hide()
		end

		self.Clicked = function()
			local parent = self:GetParent()
			local nextMode
			if self.Id == 1 then
				nextMode = CyborgMMO_GetRatModeButton(parent, 2)
			elseif self.Id == 2 then
				nextMode = CyborgMMO_GetRatModeButton(parent, 3)
			else
				nextMode = CyborgMMO_GetRatModeButton(parent, 1)
			end
			if nextMode then
				parent.ModeClicked(nextMode)
			end
		end

		self.Update = function(data, activeMode)
			if self.Id == activeMode then
				self:Show()
			else
				self:Hide()
			end
		end

		return self
	end,
}

-- XML script handlers for Rat and Quick page templates.
function CyborgMMO_RatPage_OnLoad(self)
	CyborgMMO_RatPageView.new(self)
end

function CyborgMMO_RatQuickPage_OnLoad(self)
	CyborgMMO_RatQuickPageView.new(self)
end

function CyborgMMO_SlotTemplate_OnLoad(self)
	CyborgMMO_SlotView.new(self)
end

function CyborgMMO_SlotTemplate_OnMouseDown(self, button)
	if button == "LeftButton" and self.Clicked then
		self.Clicked()
	end
end

function CyborgMMO_ModeTemplate_OnLoad(self)
	CyborgMMO_ModeView.new(self)
end

function CyborgMMO_ModeTemplate_OnClick(self)
	if self.Clicked then
		self.Clicked()
	end
end

function CyborgMMO_SlotMiniTemplate_OnLoad(self)
	CyborgMMO_SlotMiniView.new(self)
end

function CyborgMMO_SlotMiniTemplate_OnClick(self)
	if self.Clicked then
		self.Clicked()
	end
end
