--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/UIStateApply.lua
--~ Description: UI state mutation and mode/color application

local Constants = CyborgMMO.Constants

local RAT7 = {
	MODES = Constants.RAT_MODES,
}

local MODE_COLOR_MAP = {
	[1] = {
		main = {1, 0, 0, 1},
		glow = {1, 0.26, 0.26, 0.75},
	},
	[2] = {
		main = {0.07, 0.22, 1, 1},
		glow = {0.13, 0.56, 1, 0.75},
	},
	[3] = {
		main = {0.52, 0.08, 0.89, 1},
		glow = {0.67, 0.31, 0.85, 0.75},
	},
}

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core
Core.UI = Core.UI or {}

local function toBoolean(value)
	return value and true or false
end

function Core.UI.MiniMapButtonReposition(angle)
	local radius = (Minimap:GetWidth() / 2) + 5
	local dx = radius * math.cos(angle)
	local dy = radius * math.sin(angle)
	CyborgMMO_MiniMapButton:ClearAllPoints()
	CyborgMMO_MiniMapButton:SetPoint("CENTER", "Minimap", "CENTER", dx, dy)
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.MiniMapButtonAngle = angle
	end
end

function Core.UI.MiniMapButtonOnUpdate()
	local xpos, ypos = GetCursorPosition()
	local xmap, ymap = Minimap:GetCenter()

	xpos = xpos / Minimap:GetEffectiveScale() - xmap
	ypos = ypos / Minimap:GetEffectiveScale() - ymap

	local angle = math.atan2(ypos, xpos)
	Core.UI.MiniMapButtonReposition(angle)
end

function Core.UI.MouseModeChange(mode)
	local colors = MODE_COLOR_MAP[mode]
	if not colors then
		return
	end

	local miniMapTexture = CyborgMMO_MiniMapButtonIcon
	local miniMapGlowTexture = CyborgMMO_MiniMapButtonIconGlow
	local openButtonTexture = CyborgMMO_OpenButtonPageOpenMainForm:GetNormalTexture()
	local openButtonGlowTexture = CyborgMMO_OpenButtonPageOpenMainForm:GetHighlightTexture()
	miniMapTexture:SetVertexColor(unpack(colors.main))
	miniMapGlowTexture:SetVertexColor(unpack(colors.glow))
	openButtonTexture:SetVertexColor(colors.main[1], colors.main[2], colors.main[3], 0.75)
	openButtonGlowTexture:SetVertexColor(colors.glow[1], colors.glow[2], colors.glow[3], 0.5)
end

function Core.UI.SetMainPageSize(percent)
	CyborgMMO_MainPage:SetScale(percent)
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.Plugin = percent
	end
end

function Core.UI.SetOpenButtonSize(percent)
	CyborgMMO_OpenButtonPage:SetScale(percent)
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.Cyborg = percent
	end
end

function Core.UI.SetCyborgHeadButton(visible)
	if visible then
		CyborgMMO_OpenButtonPage:Show()
	else
		CyborgMMO_OpenButtonPage:Hide()
	end
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.CyborgButton = toBoolean(visible)
	end
end

function Core.UI.SetMiniMapButton(visible)
	if visible then
		CyborgMMO_MiniMapButton:Show()
	else
		CyborgMMO_MiniMapButton:Hide()
	end
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.MiniMapButton = toBoolean(visible)
	end
end

function Core.UI.SetCompartmentButton(visible)
	if visible then
		RegisterCompartmentButton()
	else
		UnregisterCompartmentButton()
	end
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.CompartmentButton = toBoolean(visible)
	end
end

function Core.UI.SetPerSpecBindings(perSpec)
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.PerSpecBindings = toBoolean(perSpec)
	end
	if Core.Runtime.bindingsLoaded then
		CyborgMMO_RatPageModel:LoadData()
	end
end

function Core.UI.SetDefaultSettings()
	CyborgMMO_OpenButtonPageOpenMainForm:ClearAllPoints()
	CyborgMMO_MainPage:ClearAllPoints()
	CyborgMMO_OpenButtonPageOpenMainForm:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
	CyborgMMO_MainPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)

	Core.UI.SetOpenButtonSize(0.75)
	Core.UI.SetMainPageSize(0.75)
	Core.UI.SetMiniMapButton(true)
	Core.UI.SetCyborgHeadButton(true)
end

function Core.UI.SetupAllModeCallbacks()
	for modeNum = 1, RAT7.MODES do
		Core.Bindings.SetupModeCallbacks(modeNum)
	end
end
