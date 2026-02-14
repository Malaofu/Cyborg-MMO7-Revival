--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/XmlCallbacks.lua
--~ Description: Global XML/UI callback shims that delegate to Core namespaces

local Core = CyborgMMO.Core

function CyborgMMO_MainPage_OnLoad(self)
	Core.UI.Main.OnLoad(self)
end

function CyborgMMO_RatPage_OnLoad(frame)
	Core.UI.RatPageView.RatPageOnLoad(frame)
end

function CyborgMMO_RatQuickPage_OnLoad(frame)
	Core.UI.RatPageView.RatQuickPageOnLoad(frame)
end

function CyborgMMO_LoadStrings(self)
	Core.Localization.LoadStrings(self)
end
