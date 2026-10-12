-- Run from the addon directory with a Lua interpreter.
-- Tests dispatch/wiring; WoW's security engine still requires in-game testing.
local function frame()
	return {
		scripts = {}, attributes = {},
		SetScript = function(self, name, fn) self.scripts[name] = fn end,
		GetScript = function(self, name) return self.scripts[name] end,
		SetAttribute = function(self, name, value) self.attributes[name] = value end,
		RegisterForClicks = function(self, ...) self.clicks = {...} end,
		RegisterForDrag = function() end,
		Show = function() end, Hide = function() end,
	}
end
CreateFrame = frame
function InCombatLockdown() return false end
UIParent = frame()
WOW_PROJECT_MAINLINE, WOW_PROJECT_ID = 1, 1
CharacterMicroButton, AchievementMicroButton = frame(), frame()
CyborgMMO = { Constants = { MEDIA_PATH = "" }, Core = { Debug = { Log = function() end } } }
local bindings = {}
function SetOverrideBinding(_, _, key, command) bindings[key] = command end
function SetOverrideBindingClick(_, _, key, name) bindings[key] = "CLICK " .. name end
function ToggleCharacter() error("Addon called ToggleCharacter") end
function ToggleAchievementFrame() error("Addon called ToggleAchievementFrame") end
dofile("CallbackFactory.lua")
dofile("objects/Core.lua")
dofile("objects/ObjectCallback.lua")
local core = CyborgMMO.Core
local factory = CyborgMMO_CallbackFactory

-- Replacing a Lua callback with a native binding must release the old button.
core.Objects.Create("callback", "Map"):SetBinding("F1")
assert(CyborgMMO_ObjectInternals.CallbackByBindingKey.F1)
local oldCallbackButton = CyborgMMO_ObjectInternals.CallbackByBindingKey.F1.button
local character = core.Objects.Create("callback", "CharacterPage")
character:SetBinding("F1")
assert(bindings.F1 == "TOGGLECHARACTER0")
assert(not CyborgMMO_ObjectInternals.CallbackByBindingKey.F1)
assert(oldCallbackButton:GetScript("OnClick") == nil)
local achievement = core.Objects.Create("callback", "Achievement")
achievement:SetBinding("F2")
assert(bindings.F2 == "TOGGLEACHIEVEMENT")
character:DoAction()
achievement:DoAction()
core.Objects.ClearBinding("F1")
assert(bindings.F1 == nil)
core.Objects.Create("callback", "Map"):SetBinding("F2")
assert(bindings.F2:match("^CLICK "))

-- Main-page wiring must preserve the XML-installed Blizzard handler.
local inheritedClick = function() end
local buttons = {}
for _, name in ipairs({"CharacterPage", "Achievement", "Map"}) do
	buttons[name] = frame()
	buttons[name]:SetScript("OnClick", inheritedClick)
end
core.UI = {
	FrameLookup = { GetNamedChild = function(_, name) return buttons[name] end },
	Frames = { SetMainPage = function() end },
}
core.Events = { Loaded = function() end }
core.CallbackIcons = { new = function() end, OnClick = function() end,
	OnDragStart = function() end, OnDragStop = function() end }
dofile("ui/MainPage.lua")
local mainPage = frame()
core.UI.Main.OnLoad(mainPage)
for name, target in pairs({CharacterPage = CharacterMicroButton, Achievement = AchievementMicroButton}) do
	local button = buttons[name]
	assert(button:GetScript("OnClick") == inheritedClick)
	assert(button.attributes.type1 == "click")
	assert(button.attributes.clickbutton1 == target)
	assert(button.attributes.useOnKeyDown == false)
	assert(button.clicks[1] == "LeftButtonUp" and #button.clicks == 1)
	assert(button:GetScript("OnDragStart") == core.CallbackIcons.OnDragStart)
	assert(button:GetScript("OnDragStop") == core.CallbackIcons.OnDragStop)
end
assert(buttons.Map:GetScript("OnClick") == core.CallbackIcons.OnClick)
assert(not factory:ConfigurePanelButton(frame(), "Map"))

-- Forever's Camelot project uses Legacy.
WOW_PROJECT_MAINLINE = 1
WOW_PROJECT_CAMELOT = 18
LegacyMicroButton = frame()
WOW_PROJECT_ID = WOW_PROJECT_CAMELOT
-- Simulate XML loading before Blizzard's Legacy handler is available.
factory:ConfigurePanelButton(buttons.Achievement, "Achievement")
assert(buttons.Achievement.attributes.clickbutton1 == nil)
local legacyClicks = 0
LegacyMicroButtonMixin = { OnClick = function() legacyClicks = legacyClicks + 1 end }
LegacyMicroButton.disabled = true
mainPage:GetScript("OnShow")(mainPage)
local legacyTarget = buttons.Achievement.attributes.clickbutton1
assert(legacyTarget and legacyTarget ~= LegacyMicroButton)
assert(legacyTarget:GetScript("OnClick") == LegacyMicroButtonMixin.OnClick)
assert(buttons.Achievement:GetScript("OnClick") == inheritedClick)
legacyTarget:GetScript("OnClick")(legacyTarget, "LeftButton", false)
assert(legacyClicks == 1)
for _, client in ipairs({
	{ name = "Forever", project = 18, camelot = 18, legacy = true },
	{ name = "Retail", project = 1 },
	{ name = "Era", project = 2 },
	{ name = "TBC", project = 5 },
	{ name = "Mists", project = 19 },
}) do
	WOW_PROJECT_ID = client.project
	WOW_PROJECT_CAMELOT = client.camelot
	local button = frame()
	assert(factory:ConfigurePanelButton(button, "Achievement"))
	local target = client.legacy and legacyTarget or AchievementMicroButton
	local command = client.legacy and "TOGGLELEGACYSYSTEM" or "TOGGLEACHIEVEMENT"
	assert(button.attributes.clickbutton1 == target, client.name)
	achievement:SetBinding("F3")
	assert(bindings.F3 == command, client.name)
	assert(factory:GetPanelBinding("CharacterPage") == "TOGGLECHARACTER0", client.name)
	local modernCharacter = client.legacy or client.project == WOW_PROJECT_MAINLINE
	local characterCalls = 0
	ToggleCharacter = function(tab)
		assert(not modernCharacter and tab == "PaperDollFrame", client.name)
		characterCalls = characterCalls + 1
	end
	-- Rebuild the UI for each client: Classic must replace the inherited handler;
	-- Retail/Forever must retain it and avoid direct addon calls.
	buttons.CharacterPage:SetScript("OnClick", inheritedClick)
	core.UI.Main.OnLoad(mainPage)
	local click = buttons.CharacterPage:GetScript("OnClick")
	assert(click == (modernCharacter and inheritedClick or core.CallbackIcons.OnClick), client.name)
	factory:GetCallback("CharacterPage")()
	assert(characterCalls == (modernCharacter and 0 or 1), client.name)
	InCombatLockdown = function() return true end
	factory:GetCallback("CharacterPage")()
	assert(characterCalls == (modernCharacter and 0 or 1), client.name)
	InCombatLockdown = function() return false end

	-- Spellbook must use the modern API on Forever even without SpellBookFrame.
	local modern = client.legacy or client.project == WOW_PROJECT_MAINLINE
	local calls = 0
	SpellBookFrame = not modern and frame() or nil
	PlayerSpellsUtil = modern and { ToggleSpellBookFrame = function() calls = calls + 1 end } or nil
	ToggleFrame = function(target)
		assert(not modern and target ~= nil and target == SpellBookFrame, client.name)
		calls = calls + 1
	end
	local spellbook = core.Objects.Create("callback", "Spellbook")
	spellbook:DoAction() -- Same entry point as the visible callback icon.
	spellbook:SetBinding("F4")
	local callback = CyborgMMO_ObjectInternals.CallbackByBindingKey.F4
	assert(callback, client.name)
	callback.button:GetScript("OnClick")() -- Mouse-bound callback.
	assert(calls == 2, client.name)
end

-- Removing/disabling the micro-menu button must not affect the delegate.
WOW_PROJECT_CAMELOT = 18
WOW_PROJECT_ID = WOW_PROJECT_CAMELOT
LegacyMicroButton = nil
local missingLegacyButton = frame()
assert(factory:ConfigurePanelButton(missingLegacyButton, "Achievement"))
assert(missingLegacyButton.attributes.clickbutton1 == legacyTarget)
assert(factory:GetPanelBinding("Achievement") == "TOGGLELEGACYSYSTEM")
print("Panel callback dispatch and binding replacement tests passed")
