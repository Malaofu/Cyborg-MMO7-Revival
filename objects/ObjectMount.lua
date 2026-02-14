--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectMount.lua
--~ Description: Mount-backed object model (including legacy companion conversion)

local O = CyborgMMO_ObjectInternals
local Constants = CyborgMMO.Constants

local function GetMountInfoEx(mountID)
	if mountID == Constants.RANDOM_MOUNT_ID then
		return 0, "Interface/ICONS/ACHIEVEMENT_GUILDPERK_MOUNTUP"
	end
	local _, _, texture = C_MountJournal.GetMountInfoByID(mountID)
	return mountID, texture
end

local function FindMountFromSpellID(spellID)
	local mountMap, localMountMap = CyborgMMO.GetMountMaps()
	for mount, spell in pairs(localMountMap) do
		if spell == spellID then
			return mount
		end
	end
	for mount, spell in pairs(mountMap) do
		if spell == spellID then
			return mount
		end
	end
	for i = 1, C_MountJournal.GetNumMounts() do
		local _, spell = C_MountJournal.GetMountInfoByID(i)
		if spell == spellID then
			C_MountJournal.Pickup(i)
			local _, mountID = GetCursorInfo()
			ClearCursor()
			return mountID
		end
	end
	return nil
end

local WowMount_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowMount_mt = {__index = WowMount_methods}

local function WowMount(mountID)
	local mountIndex, texture = GetMountInfoEx(mountID)
	if not mountIndex then
		return nil
	end

	local self = O.WowObject("mount", mountID)
	CyborgMMO_DPrint("creating mount binding:", mountID, texture)
	self.mountID = mountID
	self.texture = texture
	setmetatable(self, WowMount_mt)
	return self
end

function WowMount_methods:DoAction()
	local mountIndex = GetMountInfoEx(self.mountID)
	if not mountIndex then
		return
	end
	C_MountJournal.SummonByID(mountIndex)
end

function WowMount_methods:Pickup()
	local mountIndex = GetMountInfoEx(self.mountID)
	if not mountIndex then
		return
	end
	return C_MountJournal.Pickup(mountIndex)
end

function WowMount_methods:SetBinding(key)
	O.SetClickBindingWithCallback(key, function()
		self:DoAction()
	end)
end

CyborgMMO_RegisterObjectFactory("mount", WowMount)
CyborgMMO_RegisterObjectFactory("companion", function(spellID)
	local mountID = FindMountFromSpellID(spellID)
	if mountID then
		return WowMount(mountID)
	end
	return nil
end)
