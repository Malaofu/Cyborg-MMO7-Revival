--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: OpenButtonPage.lua
--~ Description: The Cyborg Head logo button which opens and closes the UI
--~ Author: Malaofu

--~ This program is free software; you can redistribute it and/or
--~ modify it under the terms of the GNU General Public License
--~ as published by the Free Software Foundation; either version 2
--~ of the License, or (at your option) any later version.

--~ This program is distributed in the hope that it will be useful,
--~ but WITHOUT ANY WARRANTY; without even the implied warranty of
--~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--~ GNU General Public License for more details.

--~ You should have received a copy of the GNU General Public License
--~ along with this program; if not, write to the Free Software
--~ Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

-- Main Page Frame
CyborgMMO_OpenButtonPage = CreateFrame("Frame", "CyborgMMO_OpenButtonPage", UIParent, "BackdropTemplate")
CyborgMMO_OpenButtonPage:SetSize(50, 50)
CyborgMMO_OpenButtonPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
CyborgMMO_OpenButtonPage:EnableMouse(true)
CyborgMMO_OpenButtonPage:SetMovable(true)
CyborgMMO_OpenButtonPage:Hide()

-- Open Main Form Button
CyborgMMO_OpenButtonPageOpenMainForm = CreateFrame("Button", "CyborgMMO_OpenButtonPageOpenMainForm", CyborgMMO_OpenButtonPage)
CyborgMMO_OpenButtonPageOpenMainForm:SetSize(75, 75)
CyborgMMO_OpenButtonPageOpenMainForm:SetPoint("TOPLEFT", 16, -14)
CyborgMMO_OpenButtonPageOpenMainForm:RegisterForDrag("LeftButton", "RightButton")
CyborgMMO_OpenButtonPageOpenMainForm:SetMovable(true)

CyborgMMO_OpenButtonPageOpenMainForm:SetNormalTexture("Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\Cyborg")
CyborgMMO_OpenButtonPageOpenMainForm:SetHighlightTexture("Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\CyborgGlow")

local function OnDragStart(self)
    self:StartMoving()
    self.isMoving = true
end

local function OnDragStop(self)
    self:StopMovingOrSizing()
    self.isMoving = false
end

CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnDragStart", OnDragStart)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnDragStop", OnDragStop)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnClick", CyborgMMO_Toggle)

local function OpenButtonOnEnter(self)
    CyborgMMO_ShowProfileTooltip(self:GetNormalTexture())
end

CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnLeave", CyborgMMO_HideProfileTooltip)
CyborgMMO_OpenButtonPageOpenMainForm:SetScript("OnEnter", OpenButtonOnEnter)

-- Shared Button Functionality
local buttonOnMouseUp = function(_, button)
    if button == "RightButton" then
        Settings.OpenToCategory(CyborgMMO_OptionPage.Category.ID)
    else
        CyborgMMO_Toggle()
        if not CyborgMMO_IsOpen() then
            CyborgMMO_RatQuickPage:Show()
        end
    end
end

local buttonOnEnter = function(_)
    if not CyborgMMO_IsOpen() then
        CyborgMMO_RatQuickPage:Show()
    end
    -- CyborgMMO_ShowProfileTooltip(getglobal(self:GetName().."Icon"))
end

local buttonOnLeave = function(_)
    CyborgMMO_RatQuickPage:Hide()
    CyborgMMO_HideProfileTooltip()
end

-- MiniMap Button
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
MiniMapBorder:SetTexture(136430) --"Interface\\Minimap\\MiniMap-TrackingBorder"
MiniMapBorder:SetPoint("TOPLEFT", CyborgMMO_MiniMapButton, "TOPLEFT")

CyborgMMO_MiniMapButtonIcon = CyborgMMO_MiniMapButton:CreateTexture("CyborgMMO_MiniMapButtonIcon", "BACKGROUND")
CyborgMMO_MiniMapButtonIcon:SetSize(20, 20)
CyborgMMO_MiniMapButtonIcon:SetTexture("Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\Cyborg")
CyborgMMO_MiniMapButtonIcon:SetPoint("TOPLEFT", 6, -5)
CyborgMMO_MiniMapButtonIcon:SetVertexColor(0.0, 0.0, 0.0, 1)

CyborgMMO_MiniMapButtonIconGlow = CyborgMMO_MiniMapButton:CreateTexture("CyborgMMO_MiniMapButtonIconGlow", "ARTWORK")
CyborgMMO_MiniMapButtonIconGlow:SetSize(20, 20)
CyborgMMO_MiniMapButtonIconGlow:SetTexture("Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\CyborgGlow")
CyborgMMO_MiniMapButtonIconGlow:SetPoint("TOPLEFT", 6, -5)
CyborgMMO_MiniMapButtonIconGlow:SetVertexColor(0.38, 0.85, 1.0, 0.90)

CyborgMMO_MiniMapButton:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")

CyborgMMO_MiniMapButton:SetScript("OnMouseUp", buttonOnMouseUp)
CyborgMMO_MiniMapButton:SetScript("OnEnter", buttonOnEnter)
CyborgMMO_MiniMapButton:SetScript("OnLeave", buttonOnLeave)

local function MiniMapButtonOnUpdate(self)
    if self:IsDragging() then
        CyborgMMO_MiniMapButtonOnUpdate()
    end
end

CyborgMMO_MiniMapButton:SetScript("OnUpdate", MiniMapButtonOnUpdate)

-- Addon Compartment Button
local CompartmentAdapter = {}
CompartmentAdapter.Data = {
    text = "Cyborg MMO7",
    icon = "Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\Cyborg",
    notCheckable = true,
    func = function(_, menuInputData)
        buttonOnMouseUp(_, menuInputData.buttonName)
    end,
    funcOnEnter = buttonOnEnter,
    funcOnLeave = buttonOnLeave,
}

local function GetCompartmentFrame()
    return _G.AddonCompartmentFrame
end

function CompartmentAdapter:Register()
    local frame = GetCompartmentFrame()
    if frame and frame.RegisterAddon then
        frame:RegisterAddon(self.Data)
    end
end

function CompartmentAdapter:Unregister()
    local frame = GetCompartmentFrame()
    if not frame then
        return
    end

    if frame.UnregisterAddon then
        frame:UnregisterAddon(self.Data.text)
        return
    end

    local registered = frame.registeredAddons
    if type(registered) ~= "table" then
        return
    end

    for i = 1, #registered do
        if registered[i] == self.Data then
            table.remove(registered, i)
            if frame.UpdateDisplay then
                frame:UpdateDisplay()
            end
            return
        end
    end
end

function RegisterCompartmentButton()
    CompartmentAdapter:Register()
end

function UnregisterCompartmentButton()
    CompartmentAdapter:Unregister()
end
