--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/MinimapButton.lua
--~ Description: Minimap button frame and interactions

local Constants = CyborgMMO.Constants
local MEDIA_PATH = Constants.MEDIA_PATH
local Core = CyborgMMO.Core
local Actions = Core.UI.OpenButtonActions or {}
local Frames = Core.UI.Frames

local miniMapButton = CreateFrame("Button", "CyborgMMO_MiniMapButton", Minimap)
miniMapButton:SetFrameStrata("MEDIUM")
miniMapButton:SetFixedFrameStrata(true)
miniMapButton:SetFrameLevel(8)
miniMapButton:SetFixedFrameLevel(true)
miniMapButton:SetSize(33, 33)
miniMapButton:SetPoint("TOPLEFT", 0, 0)
miniMapButton:RegisterForDrag("LeftButton", "RightButton")

local miniMapBorder = miniMapButton:CreateTexture(nil, "OVERLAY")
miniMapBorder:SetSize(50, 50)
miniMapBorder:SetTexture(136430)
miniMapBorder:SetPoint("TOPLEFT", miniMapButton, "TOPLEFT")

local miniMapButtonIcon = miniMapButton:CreateTexture("CyborgMMO_MiniMapButtonIcon", "BACKGROUND")
miniMapButtonIcon:SetSize(20, 20)
miniMapButtonIcon:SetTexture(MEDIA_PATH .. "Cyborg")
miniMapButtonIcon:SetPoint("TOPLEFT", 6, -5)
miniMapButtonIcon:SetVertexColor(0.0, 0.0, 0.0, 1)

local miniMapButtonIconGlow = miniMapButton:CreateTexture("CyborgMMO_MiniMapButtonIconGlow", "ARTWORK")
miniMapButtonIconGlow:SetSize(20, 20)
miniMapButtonIconGlow:SetTexture(MEDIA_PATH .. "CyborgGlow")
miniMapButtonIconGlow:SetPoint("TOPLEFT", 6, -5)
miniMapButtonIconGlow:SetVertexColor(0.38, 0.85, 1.0, 0.90)

Frames.SetMiniMapButton(miniMapButton)
Frames.SetMiniMapIcon(miniMapButtonIcon)
Frames.SetMiniMapGlow(miniMapButtonIconGlow)

miniMapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
miniMapButton:SetScript("OnMouseUp", Actions.OnMouseUp)
miniMapButton:SetScript("OnEnter", Actions.OnEnter)
miniMapButton:SetScript("OnLeave", Actions.OnLeave)

local function MiniMapButtonOnUpdate(self)
	if self:IsDragging() then
		Core.UI.MiniMapButtonOnUpdate()
	end
end

miniMapButton:SetScript("OnUpdate", MiniMapButtonOnUpdate)
