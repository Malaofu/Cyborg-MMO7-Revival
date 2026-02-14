--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/LocalizationInit.lua
--~ Description: Localization runtime initialization from preloaded data tables

CyborgMMO = CyborgMMO or {}
CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core

Core.Localization = Core.Localization or {}
Core.Localization.Runtime = Core.Localization.Runtime or {}

local data = Core.Localization.Data or {}
local modes = data.Modes or {}
local defaultKeyBindingsByLocale = data.DefaultKeyBindingsByLocale or {}
local stringTablesByLocale = data.StringTablesByLocale or {}

local locale = GetLocale()
local defaultLocale = "enUS"

Core.Localization.DefaultModeKeyBindings =
	modes[locale] or modes[defaultLocale] or {}

CyborgMMO_ProfileModeKeyBindings = {}
for k, v in pairs(Core.Localization.DefaultModeKeyBindings) do
	CyborgMMO_ProfileModeKeyBindings[k] = v
end

Core.Localization.StringTable =
	stringTablesByLocale[locale] or stringTablesByLocale[defaultLocale] or {}
CyborgMMO_StringTable = Core.Localization.StringTable

Core.Localization.DefaultKeyBindings =
	defaultKeyBindingsByLocale[locale] or defaultKeyBindingsByLocale[defaultLocale] or {}

CyborgMMO_ProfileKeyBindings = {}
for k, v in pairs(Core.Localization.DefaultKeyBindings) do
	CyborgMMO_ProfileKeyBindings[k] = v
end

if locale ~= defaultLocale and stringTablesByLocale[defaultLocale] then
	setmetatable(CyborgMMO_StringTable, {__index = stringTablesByLocale[defaultLocale]})
end

Core.Localization.LoadStrings = function(self)
	self:SetText(CyborgMMO_StringTable[self:GetName()])
end
