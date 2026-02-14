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

CyborgMMO_OptionPage = {
	Initialize = function(self)
		local category = Settings.RegisterVerticalLayoutCategory("Cyborg MMO7")

		local function SliderOptions(min, max, step)
			local options = Settings.CreateSliderOptions(min, max, step)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Min, min)
			options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Max, max)
			return options
		end

		do
			local variable = "CyborgMMO_OptionPageMiniMapButton"
			local name = CyborgMMO_StringTable.CyborgMMO_OptionPageMiniMapButtonTitle
			local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageMiniMapButtonTooltip
			local defaultValue = DefaultSettings.MiniMapButton
			local setting = Settings.RegisterProxySetting(
				category,
				variable,
				type(defaultValue),
				name,
				defaultValue,
				function() return Globals.EnsureSaveData().Settings.MiniMapButton end,
				function(value) Core.UI.SetMiniMapButton(value) end
			)
			Settings.CreateCheckbox(category, setting, tooltip)
		end

		do
			if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
				local variable = "CyborgMMO_OptionPageCompartmentButton"
				local name = CyborgMMO_StringTable.CyborgMMO_OptionPageCompartmentButtonTitle
				local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageCompartmentButtonTooltip
				local defaultValue = DefaultSettings.CompartmentButton
				local setting = Settings.RegisterProxySetting(
					category,
					variable,
					type(defaultValue),
					name,
					defaultValue,
					function() return Globals.EnsureSaveData().Settings.CompartmentButton end,
					function(value) Core.UI.SetCompartmentButton(value) end
				)
				Settings.CreateCheckbox(category, setting, tooltip)
			end
		end

		do
			local variable = "CyborgMMO_OptionPageCyborgButton"
			local name = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgButtonTitle
			local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgButtonTooltip
			local defaultValue = DefaultSettings.CyborgButton
			local setting = Settings.RegisterProxySetting(
				category,
				variable,
				type(defaultValue),
				name,
				defaultValue,
				function() return Globals.EnsureSaveData().Settings.CyborgButton end,
				function(value) Core.UI.SetCyborgHeadButton(value) end
			)
			Settings.CreateCheckbox(category, setting, tooltip)
		end

		do
			local variable = "CyborgMMO_OptionPagePerSpecBindings"
			local name = CyborgMMO_StringTable.CyborgMMO_OptionPagePerSpecBindingsTitle
			local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPagePerSpecBindingsTooltip
			local defaultValue = DefaultSettings.PerSpecBindings
			local setting = Settings.RegisterProxySetting(
				category,
				variable,
				type(defaultValue),
				name,
				defaultValue,
				function() return Globals.EnsureSaveData().Settings.PerSpecBindings end,
				function(value) Core.UI.SetPerSpecBindings(value) end
			)
			Settings.CreateCheckbox(category, setting, tooltip)
		end

		do
			local variable = "CyborgMMO_OptionPageCyborgSize"
			local name = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgSizeSliderTitle
			local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPageCyborgSizeSliderTooltip
			local defaultValue = DefaultSettings.Cyborg * 100
			local setting = Settings.RegisterProxySetting(
				category,
				variable,
				type(defaultValue),
				name,
				defaultValue,
				function() return Globals.EnsureSaveData().Settings.Cyborg * 100 end,
				function(value) Core.UI.SetOpenButtonSize(value / 100) end
			)
			Settings.CreateSlider(category, setting, SliderOptions(50, 100, 1), tooltip)
		end

		do
			local variable = "CyborgMMO_OptionPagePluginSize"
			local name = CyborgMMO_StringTable.CyborgMMO_OptionPagePluginSizeSliderTitle
			local tooltip = CyborgMMO_StringTable.CyborgMMO_OptionPagePluginSizeSliderTooltip
			local defaultValue = DefaultSettings.Plugin * 100
			local setting = Settings.RegisterProxySetting(
				category,
				variable,
				type(defaultValue),
				name,
				defaultValue,
				function() return Globals.EnsureSaveData().Settings.Plugin * 100 end,
				function(value) Core.UI.SetMainPageSize(value / 100) end
			)
			Settings.CreateSlider(category, setting, SliderOptions(50, 100, 1), tooltip)
		end

		Settings.RegisterAddOnCategory(category)
		self.Category = category
	end
}

CyborgMMO_OptionPage:Initialize()
