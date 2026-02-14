--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/MainPage.lua
--~ Description: Main frame wiring and page visibility controls

local MAIN_PAGE_CALLBACK_SUFFIXES = {
	"CharacterPage",
	"Inventory",
	"Spellbook",
	"Macros",
	"Achievement",
	"QuestLog",
	"Map",
}
local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.Main = Core.UI.Main or {}
local FrameLookup = Core.UI.FrameLookup
local Frames = Core.UI.Frames

local function BindMainPageButtons(mainPage)
	for _, suffix in ipairs(MAIN_PAGE_CALLBACK_SUFFIXES) do
		local button = FrameLookup.GetNamedChild(mainPage, suffix)
		if button then
			Core.CallbackIcons.new(button)
			button:SetScript("OnClick", Core.CallbackIcons.OnClick)
			button:SetScript("OnDragStart", Core.CallbackIcons.OnDragStart)
			button:SetScript("OnDragStop", Core.CallbackIcons.OnDragStop)
		end
	end

	local closeButton = FrameLookup.GetNamedChild(mainPage, "CloseButton")
	if closeButton then
		closeButton:SetScript("OnClick", Core.UI.Main.Close)
	end
end

local function MainPageOnDragStart(self)
	self:StartMoving()
	self.isMoving = true
end

local function MainPageOnDragStop(self)
	self:StopMovingOrSizing()
	self.isMoving = false
end

local function MainPageOnEvent(self, event, ...)
	Core.Events.Dispatch(event, ...)
end

function Core.UI.Main.OnLoad(self)
	Frames.SetMainPage(self)
	BindMainPageButtons(self)
	Core.Events.Loaded()
	self:RegisterForDrag("LeftButton", "RightButton")
	self:SetScript("OnDragStart", MainPageOnDragStart)
	self:SetScript("OnDragStop", MainPageOnDragStop)
	self:SetScript("OnEvent", MainPageOnEvent)
end

function Core.UI.Main.Close()
	local mainPage = Frames.GetMainPage()
	if mainPage then
		mainPage:Hide()
	end
end

function Core.UI.Main.Open()
	local mainPage = Frames.GetMainPage()
	local quickPage = Frames.GetRatQuickPage()
	if mainPage then
		mainPage:Show()
	end
	if quickPage then
		quickPage:Hide()
	end
end

function Core.UI.Main.IsOpen()
	local mainPage = Frames.GetMainPage()
	return mainPage and mainPage:IsVisible() or false
end

function Core.UI.Main.Toggle()
	if Core.UI.Main.IsOpen() then
		Core.UI.Main.Close()
	else
		Core.UI.Main.Open()
	end
end
