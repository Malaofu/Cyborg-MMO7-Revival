--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: MainPage.lua
--~ Description: Lua description of the MMO7 UI
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

-- Define the callback button template
local function CyborgMMO_TemplateCallbackButton_OnLoad(self)
    self = CyborgMMO_CallbackIcons.new(self)
end

local function CyborgMMO_TemplateCallbackButton_OnClick(self)
    self.OnClick()
end

local function CyborgMMO_TemplateCallbackButton_OnDragStart(self)
    self.DragStart()
end

local function CyborgMMO_TemplateCallbackButton_OnDragStop(self)
    self.DragStop()
end

-- Create the main page frame
CyborgMMO_MainPage = CreateFrame("Frame", "CyborgMMO_MainPage", UIParent, "CyborgMMO_TemplateIcon")
CyborgMMO_MainPage:SetSize(512, 512)
CyborgMMO_MainPage:SetPoint("LEFT", UIParent, "LEFT", 0, 0)
CyborgMMO_MainPage:SetMovable(true)
CyborgMMO_MainPage:EnableMouse(true)

-- Background Texture
local backgroundTexture = CyborgMMO_MainPage:CreateTexture(nil, "BACKGROUND")
backgroundTexture:SetTexture("Interface\\AddOns\\CyborgMMO7\\Graphics\\ParchmentAndAllIcons")
backgroundTexture:SetSize(512, 512)
backgroundTexture:SetPoint("TOPLEFT")

-- Artwork Texture
local ratCalloutsTexture = CyborgMMO_MainPage:CreateTexture(nil, "ARTWORK")
ratCalloutsTexture:SetTexture("Interface\\AddOns\\CyborgMMO7\\Graphics\\Lines")
ratCalloutsTexture:SetSize(512, 512)
ratCalloutsTexture:SetPoint("TOPLEFT")

-- Define Buttons
local function CreateCallbackButton(name, parent, x, y)
    local button = CreateFrame("Button", name, parent, "CyborgMMO_TemplateIcon")
    button:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    button:SetScript("OnLoad", CyborgMMO_TemplateCallbackButton_OnLoad)
    button:SetScript("OnClick", CyborgMMO_TemplateCallbackButton_OnClick)
    button:SetScript("OnDragStart", CyborgMMO_TemplateCallbackButton_OnDragStart)
    button:SetScript("OnDragStop", CyborgMMO_TemplateCallbackButton_OnDragStop)
    return button
end

CreateCallbackButton("CyborgMMO_MainPageCharacterPage", CyborgMMO_MainPage, 379, -411)
CreateCallbackButton("CyborgMMO_MainPageInventory", CyborgMMO_MainPage, 379, -446)
CreateCallbackButton("CyborgMMO_MainPageSpellbook", CyborgMMO_MainPage, 414, -411)
CreateCallbackButton("CyborgMMO_MainPageMacros", CyborgMMO_MainPage, 449, -446)
CreateCallbackButton("CyborgMMO_MainPageAchievement", CyborgMMO_MainPage, 449, -411)
CreateCallbackButton("CyborgMMO_MainPageQuestLog", CyborgMMO_MainPage, 344, -446)
CreateCallbackButton("CyborgMMO_MainPageMap", CyborgMMO_MainPage, 414, -446)

-- Close Button
local closeButton = CreateFrame("Button", "CyborgMMO_MainPageCloseButton", CyborgMMO_MainPage)
closeButton:SetSize(23, 24)
closeButton:SetPoint("TOPLEFT", CyborgMMO_MainPage, "TOPLEFT", 474, -8)
closeButton:SetNormalTexture("Interface\\AddOns\\CyborgMMO7\\Graphics\\CloseButton")
closeButton:SetPushedTexture("Interface\\AddOns\\CyborgMMO7\\Graphics\\CloseButtonDown")
closeButton:SetHighlightTexture("Interface\\AddOns\\CyborgMMO7\\Graphics\\CloseButtonOver", "ADD")
closeButton:SetScript("OnClick", function() CyborgMMO_Close() end)

-- Slot List Frame
local slotList = CreateFrame("Frame", "CyborgMMO_MainPageSlotList", CyborgMMO_MainPage, "CyborgMMO_TemplateRatPage")
slotList:SetPoint("TOPLEFT", CyborgMMO_MainPage, "TOPLEFT", 0, 0)

-- Scripts
CyborgMMO_MainPage:SetScript("OnLoad", function(self)
    CyborgMMO_Loaded()
    self:RegisterForDrag("LeftButton", "RightButton")
end)

CyborgMMO_MainPage:SetScript("OnDragStart", function(self)
    self:StartMoving()
    self.isMoving = true
end)

CyborgMMO_MainPage:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    self.isMoving = false
end)

CyborgMMO_MainPage:SetScript("OnEvent", CyborgMMO_Event)
