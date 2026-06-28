--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/ObjectMount.lua
--~ Description: Mount-backed object model (including legacy companion conversion)

local O = CyborgMMO_ObjectInternals
local Constants = CyborgMMO.Constants
local Core = CyborgMMO.Core

local function GetMountIndexByID(mountID)
	if C_MountJournal.GetDisplayedMountInfo then
		local numMounts = C_MountJournal.GetNumDisplayedMounts and C_MountJournal.GetNumDisplayedMounts() or C_MountJournal.GetNumMounts()
		for index = 1, numMounts do
			local displayedMountID = select(12, C_MountJournal.GetDisplayedMountInfo(index))
			if displayedMountID == mountID then
				return index
			end
		end
	end

	return nil
end

local function GetMountInfoEx(mountID)
	if mountID == Constants.RANDOM_MOUNT_ID then
		return 0, "Interface/ICONS/ACHIEVEMENT_GUILDPERK_MOUNTUP"
	end

	local _, _, texture = C_MountJournal.GetMountInfoByID(mountID)
	return GetMountIndexByID(mountID), texture
end

local WowMount_methods = setmetatable({}, {__index = O.WowObject_methods})
local WowMount_mt = {__index = WowMount_methods}

local function WowMount(mountID)
	local mountIndex, texture = GetMountInfoEx(mountID)
	if not mountIndex then
		return nil
	end

	local self = O.WowObject("mount", mountID)
	Core.Debug.Log("creating mount binding:", mountID, texture)
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

	C_MountJournal.SummonByID(self.mountID)
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

CyborgMMO.Core.Objects.RegisterFactory("mount", WowMount)
