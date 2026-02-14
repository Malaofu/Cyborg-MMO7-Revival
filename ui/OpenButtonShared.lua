--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/OpenButtonShared.lua
--~ Description: Shared open/minimap/compartment button behaviors

local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.OpenButtonActions = Core.UI.OpenButtonActions or {}
local Actions = Core.UI.OpenButtonActions
local Frames = Core.UI.Frames

function Actions.OnMouseUp(_, button)
	if button == "RightButton" then
		Settings.OpenToCategory(CyborgMMO_OptionPage.Category.ID)
	else
		Core.UI.Main.Toggle()
		local quickPage = Frames.GetRatQuickPage()
		if not Core.UI.Main.IsOpen() and quickPage then
			quickPage:Show()
		end
	end
end

function Actions.OnEnter(_)
	local quickPage = Frames.GetRatQuickPage()
	if not Core.UI.Main.IsOpen() and quickPage then
		quickPage:Show()
	end
end

function Actions.OnLeave(_)
	local quickPage = Frames.GetRatQuickPage()
	if quickPage then
		quickPage:Hide()
	end
	Core.UI.Tooltip.HideProfileTooltip()
end
