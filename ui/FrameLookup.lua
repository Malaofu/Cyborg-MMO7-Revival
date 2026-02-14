--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/FrameLookup.lua
--~ Description: Centralized UI frame lookup helpers

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.FrameLookup = Core.UI.FrameLookup or {}

function Core.UI.FrameLookup.GetNamedChild(parentFrame, childSuffix)
	if not parentFrame then
		return nil
	end
	local parentName = parentFrame:GetName()
	if not parentName then
		return nil
	end
	return _G[parentName .. childSuffix]
end

function Core.UI.FrameLookup.GetRatModeButton(parentFrame, mode)
	if type(mode) ~= "number" then
		return nil
	end
	return Core.UI.FrameLookup.GetNamedChild(parentFrame, "Mode" .. mode)
end

function Core.UI.FrameLookup.GetRatSlotButton(parentFrame, slot)
	if type(slot) ~= "number" then
		return nil
	end
	return Core.UI.FrameLookup.GetNamedChild(parentFrame, "Slot" .. slot)
end
