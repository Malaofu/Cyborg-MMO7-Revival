--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/Frames.lua
--~ Description: Centralized frame registry/getters for UI globals

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.Frames = Core.UI.Frames or {}

local Frames = Core.UI.Frames

function Frames.SetMainPage(frame)
	Frames.mainPage = frame
end

function Frames.GetMainPage()
	return Frames.mainPage or _G.CyborgMMO_MainPage
end

function Frames.SetRatQuickPage(frame)
	Frames.ratQuickPage = frame
end

function Frames.GetRatQuickPage()
	return Frames.ratQuickPage or _G.CyborgMMO_RatQuickPage
end

function Frames.SetOpenButtonPage(frame)
	Frames.openButtonPage = frame
end

function Frames.GetOpenButtonPage()
	return Frames.openButtonPage or _G.CyborgMMO_OpenButtonPage
end

function Frames.SetOpenButtonControl(button)
	Frames.openButtonControl = button
end

function Frames.GetOpenButtonControl()
	return Frames.openButtonControl or _G.CyborgMMO_OpenButtonPageOpenMainForm
end

function Frames.SetMiniMapButton(button)
	Frames.miniMapButton = button
end

function Frames.GetMiniMapButton()
	return Frames.miniMapButton or _G.CyborgMMO_MiniMapButton
end

function Frames.SetMiniMapIcon(texture)
	Frames.miniMapIcon = texture
end

function Frames.GetMiniMapIcon()
	return Frames.miniMapIcon or _G.CyborgMMO_MiniMapButtonIcon
end

function Frames.SetMiniMapGlow(texture)
	Frames.miniMapGlow = texture
end

function Frames.GetMiniMapGlow()
	return Frames.miniMapGlow or _G.CyborgMMO_MiniMapButtonIconGlow
end
