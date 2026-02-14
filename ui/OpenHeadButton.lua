--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/OpenHeadButton.lua
--~ Description: The Cyborg head logo button frame

local Constants = CyborgMMO.Constants
local MEDIA_PATH = Constants.MEDIA_PATH
local Core = CyborgMMO.Core
local Frames = Core.UI.Frames

local openButtonPage = CreateFrame("Frame", "CyborgMMO_OpenButtonPage", UIParent, "BackdropTemplate")
openButtonPage:SetSize(50, 50)
openButtonPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
openButtonPage:EnableMouse(true)
openButtonPage:SetMovable(true)
openButtonPage:Hide()

local openButtonControl = CreateFrame("Button", "CyborgMMO_OpenButtonPageOpenMainForm", openButtonPage)
openButtonControl:SetSize(75, 75)
openButtonControl:SetPoint("TOPLEFT", 16, -14)
openButtonControl:RegisterForDrag("LeftButton", "RightButton")
openButtonControl:SetMovable(true)
openButtonControl:SetNormalTexture(MEDIA_PATH .. "Cyborg")
openButtonControl:SetHighlightTexture(MEDIA_PATH .. "CyborgGlow")

Frames.SetOpenButtonPage(openButtonPage)
Frames.SetOpenButtonControl(openButtonControl)

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

openButtonControl:SetScript("OnDragStart", OnDragStart)
openButtonControl:SetScript("OnDragStop", OnDragStop)
openButtonControl:SetScript("OnClick", Core.UI.Main.Toggle)
openButtonControl:SetScript("OnLeave", Core.UI.Tooltip.HideProfileTooltip)
openButtonControl:SetScript("OnEnter", OpenButtonOnEnter)
