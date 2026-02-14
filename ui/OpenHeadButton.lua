--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/OpenHeadButton.lua
--~ Description: The Cyborg head logo button frame

local Constants = CyborgMMO.Constants
local MEDIA_PATH = Constants.MEDIA_PATH
local Core = CyborgMMO.Core
local Frames = Core.UI.Frames

CyborgMMO_OpenButtonPage = CreateFrame("Frame", "CyborgMMO_OpenButtonPage", UIParent, "BackdropTemplate")
CyborgMMO_OpenButtonPage:SetSize(50, 50)
CyborgMMO_OpenButtonPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
CyborgMMO_OpenButtonPage:EnableMouse(true)
CyborgMMO_OpenButtonPage:SetMovable(true)
CyborgMMO_OpenButtonPage:Hide()

CyborgMMO_OpenButtonPageOpenMainForm = CreateFrame("Button", "CyborgMMO_OpenButtonPageOpenMainForm", CyborgMMO_OpenButtonPage)
CyborgMMO_OpenButtonPageOpenMainForm:SetSize(75, 75)
CyborgMMO_OpenButtonPageOpenMainForm:SetPoint("TOPLEFT", 16, -14)
CyborgMMO_OpenButtonPageOpenMainForm:RegisterForDrag("LeftButton", "RightButton")
CyborgMMO_OpenButtonPageOpenMainForm:SetMovable(true)
CyborgMMO_OpenButtonPageOpenMainForm:SetNormalTexture(MEDIA_PATH .. "Cyborg")
CyborgMMO_OpenButtonPageOpenMainForm:SetHighlightTexture(MEDIA_PATH .. "CyborgGlow")

Frames.SetOpenButtonPage(CyborgMMO_OpenButtonPage)
Frames.SetOpenButtonControl(CyborgMMO_OpenButtonPageOpenMainForm)

local function OnDragStart(self)
	self:StartMoving()
	self.isMoving = true
end

local function OnDragStop(self)
	self:StopMovingOrSizing()
	self.isMoving = false
end

local function OpenButtonOnEnter(self)
	Core.UI.Tooltip.ShowProfileTooltip(self:GetNormalTexture())
end

CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnDragStart", OnDragStart)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnDragStop", OnDragStop)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnClick", Core.UI.Main.Toggle)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnLeave", Core.UI.Tooltip.HideProfileTooltip)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnEnter", OpenButtonOnEnter)
