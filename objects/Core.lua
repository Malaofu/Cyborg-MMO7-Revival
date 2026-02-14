--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/Core.lua
--~ Description: Shared object model infrastructure and factory registry

CyborgMMO_ObjectInternals = CyborgMMO_ObjectInternals or {}
local O = CyborgMMO_ObjectInternals
local Constants = CyborgMMO.Constants
CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core
Core.Objects = Core.Objects or {}

O.MEDIA_PATH = Constants.MEDIA_PATH
O.FactoryByType = O.FactoryByType or {}

--- @alias objectType string
--- | "item"
--- | "macro"
--- | "spell"
--- | "companion"
--- | "equipmentset"
--- | "battlepet"
--- | "mount"
--- | "callback"

--- @class WowObject_methods
--- @field type objectType
--- @field detail any
--- @field subdetail any
O.WowObject_methods = O.WowObject_methods or {}
O.WowObject_mt = O.WowObject_mt or {__index = O.WowObject_methods}

---@param objectType objectType
---@param detail any
---@param subdetail any
---@return table
function O.WowObject(objectType, detail, subdetail)
	local self = {}
	self.type = objectType
	self.detail = detail
	self.subdetail = subdetail
	setmetatable(self, O.WowObject_mt)
	return self
end

function O.WowObject_methods:SaveData()
	return {
		type = self.type,
		detail = self.detail,
		subdetail = self.subdetail,
	}
end

function O.WowObject_methods:DoAction()
	CyborgMMO_DPrint("Nothing To Do")
end

function O.WowObject_methods:Pickup()
	CyborgMMO_DPrint("Pick up Item")
end

function O.WowObject_methods:SetBinding(_key)
end

function O.SetClickBindingWithCallback(key, fn)
	local _, parentFrame, name = CyborgMMO_CallbackFactory:AddCallback(fn)
	SetOverrideBindingClick(parentFrame, true, key, name, "LeftButton")
end

---@param objectType objectType
---@param factoryFn function
function Core.Objects.RegisterFactory(objectType, factoryFn)
	O.FactoryByType[objectType] = factoryFn
end

---@param objectType objectType
---@param ... unknown
---@return table|nil
function Core.Objects.Create(objectType, ...)
	local factory = O.FactoryByType[objectType]
	if not factory then
		CyborgMMO_DPrint("unsupported wow object:", objectType, ...)
		return nil
	end

	local object = factory(...)
	if not object then
		CyborgMMO_DPrint("creating " .. tostring(objectType) .. " object failed:", objectType, ...)
	end
	return object
end

function Core.Objects.ClearBinding(key)
	SetOverrideBinding(CyborgMMO_CallbackFactory.Frame, true, key, nil)
end
