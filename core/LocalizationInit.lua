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

local function EnsureTable(tableValue)
	if type(tableValue) == "table" then
		return tableValue
	end
	return {}
end

local function FillMissingDefaults(target, defaults)
	for k, v in pairs(defaults) do
		if target[k] == nil then
			target[k] = v
		end
	end
end

CyborgMMO_ProfileModeKeyBindings = EnsureTable(CyborgMMO_ProfileModeKeyBindings)
FillMissingDefaults(CyborgMMO_ProfileModeKeyBindings, Core.Localization.DefaultModeKeyBindings)

Core.Localization.StringTable =
	stringTablesByLocale[locale] or stringTablesByLocale[defaultLocale] or {}
CyborgMMO_StringTable = Core.Localization.StringTable

Core.Localization.DefaultKeyBindings =
	defaultKeyBindingsByLocale[locale] or defaultKeyBindingsByLocale[defaultLocale] or {}

CyborgMMO_ProfileKeyBindings = EnsureTable(CyborgMMO_ProfileKeyBindings)
FillMissingDefaults(CyborgMMO_ProfileKeyBindings, Core.Localization.DefaultKeyBindings)

if locale ~= defaultLocale and stringTablesByLocale[defaultLocale] then
	setmetatable(CyborgMMO_StringTable, {__index = stringTablesByLocale[defaultLocale]})
end

Core.Localization.LoadStrings = function(self)
	self:SetText(CyborgMMO_StringTable[self:GetName()])
end
