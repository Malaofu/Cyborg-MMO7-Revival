--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/MinimapButton.lua
--~ Description: Minimap button frame and interactions

local Constants = CyborgMMO.Constants
local MEDIA_PATH = Constants.MEDIA_PATH
local Actions = CyborgMMO_OpenButtonActions or {}

CyborgMMO_MiniMapButton = CreateFrame("Button", "CyborgMMO_MiniMapButton", Minimap)
CyborgMMO_MiniMapButton:SetFrameStrata("MEDIUM")
CyborgMMO_MiniMapButton:SetFixedFrameStrata(true)
CyborgMMO_MiniMapButton:SetFrameLevel(8)
CyborgMMO_MiniMapButton:SetFixedFrameLevel(true)
CyborgMMO_MiniMapButton:SetSize(33, 33)
CyborgMMO_MiniMapButton:SetPoint("TOPLEFT", 0, 0)
CyborgMMO_MiniMapButton:RegisterForDrag("LeftButton", "RightButton")

local MiniMapBorder = CyborgMMO_MiniMapButton:CreateTexture(nil, "OVERLAY")
MiniMapBorder:SetSize(50, 50)
MiniMapBorder:SetTexture(136430)
MiniMapBorder:SetPoint("TOPLEFT", CyborgMMO_MiniMapButton, "TOPLEFT")

CyborgMMO_MiniMapButtonIcon = CyborgMMO_MiniMapButton:CreateTexture("CyborgMMO_MiniMapButtonIcon", "BACKGROUND")
CyborgMMO_MiniMapButtonIcon:SetSize(20, 20)
CyborgMMO_MiniMapButtonIcon:SetTexture(MEDIA_PATH .. "Cyborg")
CyborgMMO_MiniMapButtonIcon:SetPoint("TOPLEFT", 6, -5)
CyborgMMO_MiniMapButtonIcon:SetVertexColor(0.0, 0.0, 0.0, 1)

CyborgMMO_MiniMapButtonIconGlow = CyborgMMO_MiniMapButton:CreateTexture("CyborgMMO_MiniMapButtonIconGlow", "ARTWORK")
CyborgMMO_MiniMapButtonIconGlow:SetSize(20, 20)
CyborgMMO_MiniMapButtonIconGlow:SetTexture(MEDIA_PATH .. "CyborgGlow")
CyborgMMO_MiniMapButtonIconGlow:SetPoint("TOPLEFT", 6, -5)
CyborgMMO_MiniMapButtonIconGlow:SetVertexColor(0.38, 0.85, 1.0, 0.90)

CyborgMMO_MiniMapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
CyborgMMO_MiniMapButton:SetScript("OnMouseUp", Actions.OnMouseUp)
CyborgMMO_MiniMapButton:SetScript("OnEnter", Actions.OnEnter)
CyborgMMO_MiniMapButton:SetScript("OnLeave", Actions.OnLeave)

local function MiniMapButtonOnUpdate(self)
	if self:IsDragging() then
		CyborgMMO_MiniMapButtonOnUpdate()
	end
end

CyborgMMO_MiniMapButton:SetScript("OnUpdate", MiniMapButtonOnUpdate)
