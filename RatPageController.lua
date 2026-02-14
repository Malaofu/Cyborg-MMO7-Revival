--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: RatPageController.lua
--~ Description: Controller logic for the RatPage
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

------------------------------------------------------------------------------

local RatPageController_methods = {}
local RatPageController_mt = {__index=RatPageController_methods}

local function RatPageController()
	local self = {}
--	CyborgMMO_RatPageModel:SetMode(1)
	setmetatable(self, RatPageController_mt)
	return self
end

local UnsupportedCursorTypes = {
	petaction = true,
	money = true,
	merchant = true,
}

local Constants = CyborgMMO.Constants
local Core = CyborgMMO.Core

local function ResolveUnknownMountCursor(mountID)
	local mountMap, localMountMap = CyborgMMO.GetMountMaps()
	if mountID == Constants.RANDOM_MOUNT_ID or mountMap[mountID] or localMountMap[mountID] then
		return
	end

	local reverse = {}
	for mount, spell in pairs(mountMap) do
		reverse[spell] = mount
	end
	for mount, spell in pairs(localMountMap) do
		reverse[spell] = mount
	end

	local _, spell = C_MountJournal.GetMountInfoByID(mountID)
	if not reverse[spell] then
		C_MountJournal.Pickup(mountID)
		local _, resolvedMountID = GetCursorInfo()
		ClearCursor()
		if resolvedMountID then
			localMountMap[resolvedMountID] = spell
		end
	end
end

local CursorObjectFactories = {
	item = function(a)
		return Core.Objects.Create("item", a)
	end,
	spell = function(_, _, c)
		return Core.Objects.Create("spell", c)
	end,
	macro = function(a)
		local name = GetMacroInfo(a)
		return Core.Objects.Create("macro", name)
	end,
	battlepet = function(a)
		return Core.Objects.Create("battlepet", a)
	end,
	mount = function(a)
		return Core.Objects.Create("mount", a)
	end,
	equipmentset = function(a)
		return Core.Objects.Create("equipmentset", a)
	end,
}

function RatPageController_methods:SlotClicked(slot)
	local slotObject = CyborgMMO_RatPageModel:GetObjectOnButton(slot.Id)
	CyborgMMO_RatPageModel:SetObjectOnButton(slot.Id, CyborgMMO_RatPageModel:GetMode(), self:GetCursorObject())

	if slotObject then
		slotObject:Pickup()
	end
end

function RatPageController_methods:ModeClicked(mode)
	CyborgMMO_DPrint("Setting mode "..tostring(mode.Id))
	CyborgMMO_RatPageModel:SetMode(mode.Id)
end

function RatPageController_methods:FindHoveredSlot()
	local observers = CyborgMMO_RatPageModel:GetAllObservers()
	for i = 1, #observers do
		if MouseIsOver(observers[i]) then
			return observers[i]
		end
	end
	return nil
end

function RatPageController_methods:GetCursorObject()
	local cursorType, a, b, c = GetCursorInfo()
	ClearCursor()

	if cursorType == "mount" then
		ResolveUnknownMountCursor(a)
	end

	if cursorType == nil or UnsupportedCursorTypes[cursorType] then
		return nil
	end

	local factory = CursorObjectFactories[cursorType]
	if factory then
		return factory(a, b, c)
	end

	CyborgMMO_DPrint("unexpected cursor info:", cursorType, a, b, c)
	return nil
end

function RatPageController_methods:CallbackDropped(callbackObject)
	local slot = self:FindHoveredSlot()
	if slot then
		CyborgMMO_RatPageModel:SetObjectOnButton(slot.Id, CyborgMMO_RatPageModel:GetMode(), callbackObject.wowObject)
	end
end

------------------------------------------------------------------------------

CyborgMMO_RatPageController = RatPageController()

