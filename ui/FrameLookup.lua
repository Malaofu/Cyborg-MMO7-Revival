--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/FrameLookup.lua
--~ Description: Centralized UI frame lookup helpers

function CyborgMMO_GetNamedChild(parentFrame, childSuffix)
	if not parentFrame then
		return nil
	end
	local parentName = parentFrame:GetName()
	if not parentName then
		return nil
	end
	return _G[parentName .. childSuffix]
end

function CyborgMMO_GetRatModeButton(parentFrame, mode)
	if type(mode) ~= "number" then
		return nil
	end
	return CyborgMMO_GetNamedChild(parentFrame, "Mode" .. mode)
end

function CyborgMMO_GetRatSlotButton(parentFrame, slot)
	if type(slot) ~= "number" then
		return nil
	end
	return CyborgMMO_GetNamedChild(parentFrame, "Slot" .. slot)
end
