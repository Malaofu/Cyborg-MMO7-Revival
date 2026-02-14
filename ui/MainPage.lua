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

local function BindMainPageButtons(mainPage)
	for _, suffix in ipairs(MAIN_PAGE_CALLBACK_SUFFIXES) do
		local button = CyborgMMO_GetNamedChild(mainPage, suffix)
		if button then
			CyborgMMO_CallbackIcons.new(button)
			button:SetScript("OnClick", CyborgMMO_CallbackButton_OnClick)
			button:SetScript("OnDragStart", CyborgMMO_CallbackButton_OnDragStart)
			button:SetScript("OnDragStop", CyborgMMO_CallbackButton_OnDragStop)
		end
	end

	local closeButton = CyborgMMO_GetNamedChild(mainPage, "CloseButton")
	if closeButton then
		closeButton:SetScript("OnClick", CyborgMMO_MainPageCloseButton_OnClick)
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
	CyborgMMO_Event(event, ...)
end

function CyborgMMO_MainPage_OnLoad(self)
	BindMainPageButtons(self)
	CyborgMMO_Loaded()
	self:RegisterForDrag("LeftButton", "RightButton")
	self:SetScript("OnDragStart", MainPageOnDragStart)
	self:SetScript("OnDragStop", MainPageOnDragStop)
	self:SetScript("OnEvent", MainPageOnEvent)
end

function CyborgMMO_MainPageCloseButton_OnClick()
	CyborgMMO_Close()
end

function CyborgMMO_Close()
	CyborgMMO_MainPage:Hide()
end

function CyborgMMO_Open()
	CyborgMMO_MainPage:Show()
	CyborgMMO_RatQuickPage:Hide()
end

function CyborgMMO_IsOpen()
	return CyborgMMO_MainPage:IsVisible()
end

function CyborgMMO_Toggle()
	if CyborgMMO_IsOpen() then
		CyborgMMO_Close()
	else
		CyborgMMO_Open()
	end
end
