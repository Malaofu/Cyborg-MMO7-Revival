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

local function getFrames()
	return Core.UI and Core.UI.Frames
end

local function toBoolean(value)
	return value and true or false
end

function Core.UI.MiniMapButtonReposition(angle)
	local frames = getFrames()
	local miniMapButton = frames and frames.GetMiniMapButton and frames.GetMiniMapButton() or _G.CyborgMMO_MiniMapButton
	if not miniMapButton then
		return
	end
	local radius = (Minimap:GetWidth() / 2) + 5
	local dx = radius * math.cos(angle)
	local dy = radius * math.sin(angle)
	miniMapButton:ClearAllPoints()
	miniMapButton:SetPoint("CENTER", "Minimap", "CENTER", dx, dy)
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

	local frames = getFrames()
	local miniMapTexture = frames and frames.GetMiniMapIcon and frames.GetMiniMapIcon() or _G.CyborgMMO_MiniMapButtonIcon
	local miniMapGlowTexture = frames and frames.GetMiniMapGlow and frames.GetMiniMapGlow() or _G.CyborgMMO_MiniMapButtonIconGlow
	local openButtonControl = frames and frames.GetOpenButtonControl and frames.GetOpenButtonControl() or _G.CyborgMMO_OpenButtonPageOpenMainForm
	if not miniMapTexture or not miniMapGlowTexture or not openButtonControl then
		return
	end
	local openButtonTexture = openButtonControl:GetNormalTexture()
	local openButtonGlowTexture = openButtonControl:GetHighlightTexture()
	miniMapTexture:SetVertexColor(unpack(colors.main))
	miniMapGlowTexture:SetVertexColor(unpack(colors.glow))
	openButtonTexture:SetVertexColor(colors.main[1], colors.main[2], colors.main[3], 0.75)
	openButtonGlowTexture:SetVertexColor(colors.glow[1], colors.glow[2], colors.glow[3], 0.5)
end

function Core.UI.SetMainPageSize(percent)
	local frames = getFrames()
	local mainPage = frames and frames.GetMainPage and frames.GetMainPage() or _G.CyborgMMO_MainPage
	if mainPage then
		mainPage:SetScale(percent)
	end
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.Plugin = percent
	end
end

function Core.UI.SetOpenButtonSize(percent)
	local frames = getFrames()
	local openButtonPage = frames and frames.GetOpenButtonPage and frames.GetOpenButtonPage() or _G.CyborgMMO_OpenButtonPage
	if openButtonPage then
		openButtonPage:SetScale(percent)
	end
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.Cyborg = percent
	end
end

function Core.UI.SetCyborgHeadButton(visible)
	local frames = getFrames()
	local openButtonPage = frames and frames.GetOpenButtonPage and frames.GetOpenButtonPage() or _G.CyborgMMO_OpenButtonPage
	if not openButtonPage then
		return
	end
	if visible then
		openButtonPage:Show()
	else
		openButtonPage:Hide()
	end
	if Core.Runtime.settingsLoaded then
		Core.Runtime.settings.CyborgButton = toBoolean(visible)
	end
end

function Core.UI.SetMiniMapButton(visible)
	local frames = getFrames()
	local miniMapButton = frames and frames.GetMiniMapButton and frames.GetMiniMapButton() or _G.CyborgMMO_MiniMapButton
	if not miniMapButton then
		return
	end
	if visible then
		miniMapButton:Show()
	else
		miniMapButton:Hide()
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
		Core.Rat.Model:LoadData()
	end
end

function Core.UI.SetDefaultSettings()
	local defaults = Core.Globals.GetDefaultSettings()
	local frames = getFrames()
	local openButtonControl = frames and frames.GetOpenButtonControl and frames.GetOpenButtonControl() or _G.CyborgMMO_OpenButtonPageOpenMainForm
	local mainPage = frames and frames.GetMainPage and frames.GetMainPage() or _G.CyborgMMO_MainPage

	if openButtonControl then
		openButtonControl:ClearAllPoints()
		openButtonControl:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
	end
	if mainPage then
		mainPage:ClearAllPoints()
		mainPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
	end

	Core.UI.SetOpenButtonSize(defaults.Cyborg)
	Core.UI.SetMainPageSize(defaults.Plugin)
	Core.UI.SetMiniMapButton(defaults.MiniMapButton)
	Core.UI.SetCyborgHeadButton(defaults.CyborgButton)
end

function Core.UI.SetupAllModeCallbacks()
	for modeNum = 1, RAT7.MODES do
		Core.Bindings.SetupModeCallbacks(modeNum)
	end
end
