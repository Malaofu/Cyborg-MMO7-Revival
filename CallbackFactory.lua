--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: CalbackFactory.lua
--~ Description: Creates lua callbacks that can be executed from a user keycombination
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

------------------------------------------------------------------------------

local CallbackFactory_methods = {}
local CallbackFactory_mt = {__index=CallbackFactory_methods}

local function CallbackFactory()
	local self = {}
	self.Frame = CreateFrame("Frame", "CallbackFactoryFrame", UIParent)
	self.Callbacks = {}
	self.FreeNames = {}
	self.Id = 1

	setmetatable(self, CallbackFactory_mt)

	return self
end

local function AcquireName(self)
	if #self.FreeNames > 0 then
		return table.remove(self.FreeNames)
	end
	local name = "CyborgMMO_CallbackButton" .. self.Id
	self.Id = self.Id + 1
	return name
end

function CallbackFactory_methods:AddCallback(fn)
	local name = AcquireName(self)
	local button = self.Callbacks[name]
	if not button then
		button = CreateFrame("Button", name, self.Frame)
		self.Callbacks[name] = button
	end
	button:SetScript("OnClick", fn)
	button:Show()
	return button, self.Frame, name
end

function CallbackFactory_methods:RemoveCallback(name)
	local button = self.Callbacks[name]
	if not button then
		return
	end
	button:SetScript("OnClick", nil)
	button:Hide()
	table.insert(self.FreeNames, name)
end

local callbacks = {}

function CallbackFactory_methods:GetCallback(name)
	return callbacks[name] or (self.Callbacks[name] and self.Callbacks[name]:GetScript("OnClick"))
end

------------------------------------------------------------------------------

function callbacks.Map()
	ToggleWorldMap()
end

function callbacks.CharacterPage()
	ToggleCharacter("PaperDollFrame")
end

function callbacks.Spellbook()
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		PlayerSpellsUtil.ToggleSpellBookFrame()
	else
		ToggleFrame(SpellBookFrame)
	end
	
end

function callbacks.Macros()
	if MacroFrame and MacroFrame:IsShown() and MacroFrame:IsVisible() then
		HideUIPanel(MacroFrame)
	else
		ShowMacroFrame()
	end
end

function callbacks.QuestLog()
	ToggleQuestLog()
end

function callbacks.Achievement()
	ToggleAchievementFrame()
end

function callbacks.Inventory()
	ToggleAllBags()
end

------------------------------------------------------------------------------

CyborgMMO_CallbackFactory = CallbackFactory()

