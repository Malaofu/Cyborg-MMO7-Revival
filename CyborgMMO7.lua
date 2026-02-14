--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: CyborgMMO7.lua
--~ Description: Plugin entry point, String tables and other generic crap that I could not think to put anywhere else.
--~ Copyright (C) 2012 Mad Catz Inc.
--~ Author: Christopher Hooks
--~ Modifications: Malaofu

--~ This program is free software; you can redistribute it and/or
--~ modify it under the terms of the GNU General Public License
--~ as published by the Free Software Foundation; either version 2
--~ of the License, or (at your option) any later version.

--~ This program is distributed in the hope that it will be useful,
--~ but WITHOUT ANY WARRANTY; without even the implied warranty of
--~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--~ GNU General Public License for more details.

--~ You should have received a copy of the GNU General Public License
--~ along with this program; if not, write to the Free Software
--~ Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

local RAT7 = {
	BUTTONS = CyborgMMO_Constants.RAT_BUTTONS,
	MODES = CyborgMMO_Constants.RAT_MODES,
	SHIFT = CyborgMMO_Constants.RAT_SHIFT,
}

function CyborgMMO_LoadStrings(self)
--	CyborgMMO_DPrint("LoadStrings("..self:GetName()..") = "..CyborgMMO_StringTable[self:GetName()])
	self:SetText(CyborgMMO_StringTable[self:GetName()])
end

CyborgMMO_ModeDetected = false

function CyborgMMO_GetSaveData()
	assert(CyborgMMO_Runtime.varsLoaded)
	if not CyborgMMO7SaveData then
		CyborgMMO7SaveData = {
			Settings = DefaultSettings,
		}
	end
	return CyborgMMO7SaveData
end

function CyborgMMO_SetRatSaveData(objects)
	assert(CyborgMMO_Runtime.varsLoaded)
	local specIndex = CyborgMMO_GetCurrentSpecIndex()
	local ratData = {}
	for mode=1,RAT7.MODES do
		ratData[mode] = {}
		for button=1,RAT7.BUTTONS do
			if objects[mode][button] then
				ratData[mode][button] = objects[mode][button]:SaveData()
			end
		end
	end
	local saveData = CyborgMMO_GetSaveData()
	if not saveData.Rat then saveData.Rat = {} end
	saveData.Rat[specIndex] = ratData
end

function CyborgMMO_GetRatSaveData()
	local specIndex = CyborgMMO_GetCurrentSpecIndex()
	CyborgMMO_DPrint("returning rat data for spec:", specIndex)
	local saveData = CyborgMMO_GetSaveData()
	return saveData.Rat and saveData.Rat[specIndex]
end

function CyborgMMO_SetDefaultKeyBindings()
	for mode=1,RAT7.MODES do
		for button=1,RAT7.BUTTONS do
			local k = (mode - 1) * RAT7.BUTTONS + button
			CyborgMMO_ProfileKeyBindings[k] = CyborgMMO_DefaultKeyBindings[k]
			CyborgMMO_SetBindingButtonText(string.format("CyborgMMO_OptionPageRebindMouseRow%XMode%d", button, mode))
		end
		CyborgMMO_ProfileModeKeyBindings[mode] = CyborgMMO_DefaultModeKeyBindings[mode]
		CyborgMMO_SetBindingModeButtonText(string.format("CyborgMMO_OptionPageRebindMouseMode%d", mode), mode)
	end
end

function CyborgMMO_SetupModeCallbacks(modeNum)
	local fn = function()
		CyborgMMO_ModeDetected = true
		CyborgMMO_MouseModeChange(modeNum)
		CyborgMMO_RatPageModel:SetMode(modeNum)
	end

	local buttonFrame,parentFrame,name = CyborgMMO_CallbackFactory:AddCallback(fn)
	SetOverrideBindingClick(parentFrame, true, CyborgMMO_ProfileModeKeyBindings[modeNum], name, "LeftButton")
end

function CyborgMMO_GetDebugFrame()
	for i=1,NUM_CHAT_WINDOWS do
		local windowName = GetChatWindowInfo(i);
		if windowName == "Debug" then
			return _G["ChatFrame" .. i]
		end
	end
end

local log_prefix = "|cffff6666".."CyborgMMO Revival".."|r:"

function CyborgMMO_DPrint(...)
	local debugframe = CyborgMMO_GetDebugFrame()
	if debugframe then
		local t = {log_prefix, ...}
		for i=1,select('#', ...)+1 do
			t[i] = tostring(t[i])
		end
		debugframe:AddMessage(table.concat(t, ' '))
	end
end

