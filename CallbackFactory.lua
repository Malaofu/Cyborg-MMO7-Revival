--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: CallbackFactory.lua
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

local legacyClickTarget

local function GetLegacyClickTarget()
	-- The Legacy micro button can be disabled by its renown gate even though the
	-- native binding opens the window. Use Blizzard's unmodified click handler
	-- on a separate target, reached through the template's out-of-combat action.
	if not legacyClickTarget and LegacyMicroButtonMixin and LegacyMicroButtonMixin.OnClick then
		legacyClickTarget = CreateFrame("Button", nil, UIParent)
		legacyClickTarget:SetScript("OnClick", LegacyMicroButtonMixin.OnClick)
		legacyClickTarget:RegisterForClicks("LeftButtonUp")
	end
	return legacyClickTarget
end

local function GetClientFamily()
	if WOW_PROJECT_CAMELOT ~= nil and WOW_PROJECT_ID == WOW_PROJECT_CAMELOT then
		return "forever"
	elseif WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
		return "retail"
	end
	return "classic"
end

local panelActions = {
	CharacterPage = { binding = "TOGGLECHARACTER0", button = "CharacterMicroButton" },
	Achievement = { binding = "TOGGLEACHIEVEMENT", button = "AchievementMicroButton" },
}

-- Bindings always use native commands. Only the visible icon route varies.
local panelOverrides = {
	classic = {
		-- Classic's Character micro button has mouse-down/up scripts, no OnClick.
		CharacterPage = { binding = "TOGGLECHARACTER0", directClick = true },
	},
	forever = {
		-- The regular Achievement micro button opens the wrong UI on Forever.
		Achievement = { binding = "TOGGLELEGACYSYSTEM", getClickTarget = GetLegacyClickTarget },
	},
}

local function GetPanelAction(name)
	local overrides = panelOverrides[GetClientFamily()]
	return (overrides and overrides[name]) or panelActions[name]
end

function CallbackFactory_methods:GetPanelBinding(name)
	local action = GetPanelAction(name)
	return action and action.binding
end

function CallbackFactory_methods:ConfigurePanelButton(button, name)
	-- True means the XML-installed Blizzard OnClick handler must be preserved.
	local action = GetPanelAction(name)
	if not action then
		return false
	end
	button:RegisterForClicks("LeftButtonUp")
	if action.directClick then
		return false
	end
	-- These buttons inherit InsecureActionButtonTemplate. Preserve its Blizzard
	-- OnClick script: calling Click or ToggleCharacter from addon Lua retains taint.
	button:SetAttribute("useOnKeyDown", false)
	button:SetAttribute("type1", "click")
	local target
	if action.getClickTarget then
		target = action.getClickTarget()
	else
		target = _G[action.button]
	end
	button:SetAttribute("clickbutton1", target)
	return true
end

function CallbackFactory_methods:GetCallback(name)
	return callbacks[name] or (self.Callbacks[name] and self.Callbacks[name]:GetScript("OnClick"))
end

------------------------------------------------------------------------------

function callbacks.Map()
	ToggleWorldMap()
end

function callbacks.CharacterPage()
	if GetPanelAction("CharacterPage").directClick and not InCombatLockdown() then
		ToggleCharacter("PaperDollFrame")
	end
end

function callbacks.Spellbook()
	if GetClientFamily() ~= "classic" then
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

function callbacks.Inventory()
	ToggleAllBags()
end

------------------------------------------------------------------------------

CyborgMMO_CallbackFactory = CallbackFactory()

