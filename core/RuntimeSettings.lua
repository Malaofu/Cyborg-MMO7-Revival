local RAT7 = {
	MODES = CyborgMMO_Constants.RAT_MODES,
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

local function ToBoolean(value)
	return value and true or false
end

CyborgMMO_Runtime = CyborgMMO_Runtime or {
	varsLoaded = false,
	asyncDataLoaded = false,
	enteredWorld = false,
	bindingsLoaded = false,
	settingsLoaded = false,
	saveName = GetRealmName() .. "_" .. UnitName("player"),
	settings = nil,
	autoClosed = false,
}

function CyborgMMO_GetCurrentSpecIndex()
	if not CyborgMMO_Runtime.settings or not CyborgMMO_Runtime.settings.PerSpecBindings then
		return 1
	end
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE or WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
		return C_SpecializationInfo.GetSpecialization()
	end
	return GetActiveTalentGroup()
end

function CyborgMMO_IsLoadReady()
	return CyborgMMO_Runtime.varsLoaded and CyborgMMO_Runtime.asyncDataLoaded and CyborgMMO_Runtime.enteredWorld
end

function CyborgMMO_EnsureSettingsDefaults(data)
	CyborgMMO_Runtime.settings = data.Settings
	if not CyborgMMO_Runtime.settings then
		CyborgMMO_Runtime.settings = DefaultSettings
		data.Settings = CyborgMMO_Runtime.settings
	end
	if CyborgMMO_Runtime.settings.MiniMapButton == nil then
		CyborgMMO_Runtime.settings.MiniMapButton = DefaultSettings.MiniMapButton
	end
	if CyborgMMO_Runtime.settings.CompartmentButton == nil then
		CyborgMMO_Runtime.settings.CompartmentButton = DefaultSettings.CompartmentButton
	end
	if CyborgMMO_Runtime.settings.CyborgButton == nil then
		CyborgMMO_Runtime.settings.CyborgButton = DefaultSettings.CyborgButton
	end
	if CyborgMMO_Runtime.settings.PerSpecBindings == nil then
		CyborgMMO_Runtime.settings.PerSpecBindings = DefaultSettings.PerSpecBindings
	end
	if not CyborgMMO_Runtime.settings.Cyborg then
		CyborgMMO_Runtime.settings.Cyborg = DefaultSettings.Cyborg
	end
	if not CyborgMMO_Runtime.settings.Plugin then
		CyborgMMO_Runtime.settings.Plugin = DefaultSettings.Plugin
	end
	if not CyborgMMO_Runtime.settings.MiniMapButtonAngle then
		CyborgMMO_Runtime.settings.MiniMapButtonAngle = DefaultSettings.MiniMapButtonAngle
	end
end

function CyborgMMO_MiniMapButtonReposition(angle)
	local radius = (Minimap:GetWidth() / 2) + 5
	local dx = radius * math.cos(angle)
	local dy = radius * math.sin(angle)
	CyborgMMO_MiniMapButton:ClearAllPoints()
	CyborgMMO_MiniMapButton:SetPoint("CENTER", "Minimap", "CENTER", dx, dy)
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.MiniMapButtonAngle = angle
	end
end

function CyborgMMO_MiniMapButtonOnUpdate()
	local xpos, ypos = GetCursorPosition()
	local xmap, ymap = Minimap:GetCenter()

	xpos = xpos / Minimap:GetEffectiveScale() - xmap
	ypos = ypos / Minimap:GetEffectiveScale() - ymap

	local angle = math.atan2(ypos, xpos)
	CyborgMMO_MiniMapButtonReposition(angle)
end

function CyborgMMO_MouseModeChange(mode)
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

function CyborgMMO_SetMainPageSize(percent)
	CyborgMMO_MainPage:SetScale(percent)
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.Plugin = percent
	end
end

function CyborgMMO_SetOpenButtonSize(percent)
	CyborgMMO_OpenButtonPage:SetScale(percent)
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.Cyborg = percent
	end
end

function CyborgMMO_SetCyborgHeadButton(visible)
	if visible then
		CyborgMMO_OpenButtonPage:Show()
	else
		CyborgMMO_OpenButtonPage:Hide()
	end
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.CyborgButton = ToBoolean(visible)
	end
end

function CyborgMMO_SetMiniMapButton(visible)
	if visible then
		CyborgMMO_MiniMapButton:Show()
	else
		CyborgMMO_MiniMapButton:Hide()
	end
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.MiniMapButton = ToBoolean(visible)
	end
end

function CyborgMMO_SetCompartmentButton(visible)
	if visible then
		RegisterCompartmentButton()
	else
		UnregisterCompartmentButton()
	end
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.CompartmentButton = ToBoolean(visible)
	end
end

function CyborgMMO_SetPerSpecBindings(perSpec)
	if CyborgMMO_Runtime.settingsLoaded then
		CyborgMMO_Runtime.settings.PerSpecBindings = ToBoolean(perSpec)
	end
	if CyborgMMO_Runtime.bindingsLoaded then
		CyborgMMO_RatPageModel:LoadData()
	end
end

function CyborgMMO_SetDefaultSettings()
	CyborgMMO_OpenButtonPageOpenMainForm:ClearAllPoints()
	CyborgMMO_MainPage:ClearAllPoints()
	CyborgMMO_OpenButtonPageOpenMainForm:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
	CyborgMMO_MainPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)

	CyborgMMO_SetOpenButtonSize(0.75)
	CyborgMMO_SetMainPageSize(0.75)
	CyborgMMO_SetMiniMapButton(true)
	CyborgMMO_SetCyborgHeadButton(true)
end

function CyborgMMO_SetupAllModeCallbacks()
	for modeNum = 1, RAT7.MODES do
		CyborgMMO_SetupModeCallbacks(modeNum)
	end
end
