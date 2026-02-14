--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/OpenButtonShared.lua
--~ Description: Shared open/minimap/compartment button behaviors

CyborgMMO_OpenButtonActions = CyborgMMO_OpenButtonActions or {}
local Actions = CyborgMMO_OpenButtonActions

function Actions.OnMouseUp(_, button)
	if button == "RightButton" then
		Settings.OpenToCategory(CyborgMMO_OptionPage.Category.ID)
	else
		CyborgMMO_Toggle()
		if not CyborgMMO_IsOpen() and CyborgMMO_RatQuickPage then
			CyborgMMO_RatQuickPage:Show()
		end
	end
end

function Actions.OnEnter(_)
	if not CyborgMMO_IsOpen() and CyborgMMO_RatQuickPage then
		CyborgMMO_RatQuickPage:Show()
	end
end

function Actions.OnLeave(_)
	if CyborgMMO_RatQuickPage then
		CyborgMMO_RatQuickPage:Hide()
	end
	CyborgMMO_HideProfileTooltip()
end
