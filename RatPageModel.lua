--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: RatPageModel.lua
--~ Description: Code model of the MMO7 mouse
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
-- Constants --

local Constants = CyborgMMO.Constants

local RAT7 = {
	BUTTONS = Constants.RAT_BUTTONS,
	MODES = Constants.RAT_MODES,
	SHIFT = Constants.RAT_SHIFT,
}
local Core = CyborgMMO.Core
Core.Rat = Core.Rat or {}
local Globals = Core.Globals

local function GetBindingIndex(mode, button)
	return ((mode - 1) * RAT7.BUTTONS) + button
end

------------------------------------------------------------------------------

local RatPageModel_methods = {}
local RatPageModel_mt = {__index=RatPageModel_methods}

local function RatPageModel()
	local self = {}
	self.mode = 1
	self.observers = {}
	self.objects = {}

	for mode=1,RAT7.MODES do
		self.objects[mode] = {}
	end

	setmetatable(self, RatPageModel_mt)

	return self
end

function RatPageModel_methods:LoadData()
	CyborgMMO_DPrint("Loading...")
	local data = Core.Storage.GetRatSaveData()
	for mode=1,RAT7.MODES do
		for button=1,RAT7.BUTTONS do
			local buttonData = data and data[mode] and data[mode][button]
			if buttonData and buttonData.type then
				local object = Core.Objects.Create(buttonData.type, buttonData.detail, buttonData.subdetail)
				self:SetObjectOnButtonNoUpdate(button, mode, object)
			else
				self:SetObjectOnButtonNoUpdate(button, mode, nil)
			end
		end
	end
	self:RefreshObservers()
end

function RatPageModel_methods:PersistBindings()
	CyborgMMO_DPrint("Saving...")
	Core.Storage.SetRatSaveData(self.objects)
end

function RatPageModel_methods:SetMode(mode)
	self.mode = mode
	self:RefreshObservers()
end

function RatPageModel_methods:GetMode()
	return self.mode
end

function RatPageModel_methods:GetObjectOnButton(button)
	return self.objects[self.mode][button]
end

function RatPageModel_methods:SetObjectOnButtonNoUpdate(button, mode, object)
	self.objects[mode][button] = object
	local binding = Globals.GetProfileKeyBindings()[GetBindingIndex(mode, button)]
	if object then
		object:SetBinding(binding)
	else
		Core.Objects.ClearBinding(binding)
	end
end

function RatPageModel_methods:SetObjectOnButton(button, mode, object)
	if not object then
		CyborgMMO_DPrint("clearing "..button)
	end
	self:SetObjectOnButtonNoUpdate(button, mode, object)
	self:RefreshObservers()
	self:PersistBindings()
end

function RatPageModel_methods:AddObserver(view)
	table.insert(self.observers, view)
end

function RatPageModel_methods:GetAllObservers()
	return self.observers
end

function RatPageModel_methods:RefreshObservers()
	for i = 1, #self.observers do
		self.observers[i].Update(self.objects, self.mode)
	end
end

------------------------------------------------------------------------------

Core.Rat.Model = RatPageModel()

