--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: core/Debug.lua
--~ Description: Debug chat frame lookup and logging helper

function CyborgMMO_GetDebugFrame()
	for i = 1, NUM_CHAT_WINDOWS do
		local windowName = GetChatWindowInfo(i)
		if windowName == "Debug" then
			return _G["ChatFrame" .. i]
		end
	end
end

local log_prefix = "|cffff6666" .. "CyborgMMO Revival" .. "|r:"

function CyborgMMO_DPrint(...)
	local debugframe = CyborgMMO_GetDebugFrame()
	if debugframe then
		local t = { log_prefix, ... }
		for i = 1, select("#", ...) + 1 do
			t[i] = tostring(t[i])
		end
		debugframe:AddMessage(table.concat(t, " "))
	end
end
