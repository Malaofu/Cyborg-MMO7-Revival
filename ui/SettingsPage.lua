--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/SettingsPage.lua
--~ Description: Settings category construction

---@class GeneralSettings
---@field MiniMapButton boolean
---@field CyborgButton boolean
---@field PerSpecBindings boolean
---@field Cyborg number
---@field Plugin number
---@field MiniMapButtonAngle number
local Core = CyborgMMO.Core
Core.Config = Core.Config or {}
Core.Config.DefaultSettings = {
	MiniMapButton = true,
	CompartmentButton = true,
	CyborgButton = true,
	PerSpecBindings = false,
	Cyborg = 0.75,
	Plugin = 0.75,
	MiniMapButtonAngle = math.rad(150),
}

local DefaultSettings = Core.Config.DefaultSettings
local Globals = Core.Globals

local function SliderOptions(min, max, step)
	local options = Settings.CreateSliderOptions(min, max, step)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Min, min)
	options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Max, max)
	return options
end

local function RegisterCheckbox(category, config)
	local setting = Settings.RegisterProxySetting(
		category,
		config.variable,
		type(config.defaultValue),
		config.name,
		config.defaultValue,
		config.getter,
		config.setter
	)
	Settings.CreateCheckbox(category, setting, config.tooltip)
end

local function RegisterSlider(category, config)
	local setting = Settings.RegisterProxySetting(
		category,
		config.variable,
		type(config.defaultValue),
		config.name,
		config.defaultValue,
		config.getter,
		config.setter
	)
	Settings.CreateSlider(category, setting, SliderOptions(config.min, config.max, config.step), config.tooltip)
end

local function ShouldShowCompartmentSetting()
	return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end

local SettingsConfig = {
	{
		type = "checkbox",
		variable = "CyborgMMO_OptionPageMiniMapButton",
		name = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageMiniMapButtonTitle end,
		tooltip = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageMiniMapButtonTooltip end,
		defaultValue = function() return DefaultSettings.MiniMapButton end,
		getter = function() return Globals.EnsureSaveData().Settings.MiniMapButton end,
		setter = function(value) Core.UI.SetMiniMapButton(value) end,
	},
	{
		type = "checkbox",
		show = ShouldShowCompartmentSetting,
		variable = "CyborgMMO_OptionPageCompartmentButton",
		name = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageCompartmentButtonTitle end,
		tooltip = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageCompartmentButtonTooltip end,
		defaultValue = function() return DefaultSettings.CompartmentButton end,
		getter = function() return Globals.EnsureSaveData().Settings.CompartmentButton end,
		setter = function(value) Core.UI.SetCompartmentButton(value) end,
	},
	{
		type = "checkbox",
		variable = "CyborgMMO_OptionPageCyborgButton",
		name = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgButtonTitle end,
		tooltip = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgButtonTooltip end,
		defaultValue = function() return DefaultSettings.CyborgButton end,
		getter = function() return Globals.EnsureSaveData().Settings.CyborgButton end,
		setter = function(value) Core.UI.SetCyborgHeadButton(value) end,
	},
	{
		type = "checkbox",
		variable = "CyborgMMO_OptionPagePerSpecBindings",
		name = function() return CyborgMMO_StringTable.CyborgMMO_OptionPagePerSpecBindingsTitle end,
		tooltip = function() return CyborgMMO_StringTable.CyborgMMO_OptionPagePerSpecBindingsTooltip end,
		defaultValue = function() return DefaultSettings.PerSpecBindings end,
		getter = function() return Globals.EnsureSaveData().Settings.PerSpecBindings end,
		setter = function(value) Core.UI.SetPerSpecBindings(value) end,
	},
	{
		type = "slider",
		variable = "CyborgMMO_OptionPageCyborgSize",
		name = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgSizeSliderTitle end,
		tooltip = function() return CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgSizeSliderTooltip end,
		defaultValue = function() return DefaultSettings.Cyborg * 100 end,
		getter = function() return Globals.EnsureSaveData().Settings.Cyborg * 100 end,
		setter = function(value) Core.UI.SetOpenButtonSize(value / 100) end,
		min = 50,
		max = 100,
		step = 1,
	},
	{
		type = "slider",
		variable = "CyborgMMO_OptionPagePluginSize",
		name = function() return CyborgMMO_StringTable.CyborgMMO_OptionPagePluginSizeSliderTitle end,
		tooltip = function() return CyborgMMO_StringTable.CyborgMMO_OptionPagePluginSizeSliderTooltip end,
		defaultValue = function() return DefaultSettings.Plugin * 100 end,
		getter = function() return Globals.EnsureSaveData().Settings.Plugin * 100 end,
		setter = function(value) Core.UI.SetMainPageSize(value / 100) end,
		min = 50,
		max = 100,
		step = 1,
	},
}

local function ResolveConfig(config)
	return {
		variable = config.variable,
		name = config.name(),
		tooltip = config.tooltip(),
		defaultValue = config.defaultValue(),
		getter = config.getter,
		setter = config.setter,
		min = config.min,
		max = config.max,
		step = config.step,
	}
end

CyborgMMO_OptionPage = {
	Initialize = function(self)
		local category = Settings.RegisterVerticalLayoutCategory("Cyborg MMO7")

		for _, config in ipairs(SettingsConfig) do
			if not config.show or config.show() then
				local resolved = ResolveConfig(config)
				if config.type == "checkbox" then
					RegisterCheckbox(category, resolved)
				elseif config.type == "slider" then
					RegisterSlider(category, resolved)
				end
			end
		end

		Settings.RegisterAddOnCategory(category)
		self.Category = category
	end
}

CyborgMMO_OptionPage:Initialize()

