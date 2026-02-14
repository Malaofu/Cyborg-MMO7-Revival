--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/OpenButtonShared.lua
--~ Description: Shared open/minimap/compartment button behaviors

local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.OpenButtonActions = Core.UI.OpenButtonActions or {}
local Actions = Core.UI.OpenButtonActions

function Actions.OnMouseUp(_, button)
	if button == "RightButton" then
		Settings.OpenToCategory(CyborgMMO_OptionPage.Category.ID)
	else
		Core.UI.Main.Toggle()
		if not Core.UI.Main.IsOpen() and CyborgMMO_RatQuickPage then
			CyborgMMO_RatQuickPage:Show()
		end
	end
end

function Actions.OnEnter(_)
	if not Core.UI.Main.IsOpen() and CyborgMMO_RatQuickPage then
		CyborgMMO_RatQuickPage:Show()
	end
end

function Actions.OnLeave(_)
	if CyborgMMO_RatQuickPage then
		CyborgMMO_RatQuickPage:Hide()
	end
	Core.UI.Tooltip.HideProfileTooltip()
end
