--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: objects/CallbackIcons.lua
--~ Description: Rat-page corner callback icon view-model helpers

CyborgMMO_CallbackIcons = {
	new = function(self)
		self.point, self.relativeTo, self.relativePoint, self.xOfs, self.yOfs = self:GetPoint()
		self.strata = self:GetFrameStrata()
		local callbackName = string.gsub(self:GetName(), self:GetParent():GetName(), "", 1)
		self.wowObject = CyborgMMO_CreateWowObject("callback", callbackName)
		if self.wowObject then
			self.wowObject:SetTextures(self)
		end
		self:RegisterForDrag("LeftButton", "RightButton")
		self:SetResizable(false)

		self.OnClick = function()
			if self.wowObject then
				self.wowObject:DoAction()
			end
		end

		self.DragStart = function()
			self:SetMovable(true)
			self:StartMoving()
			self.isMoving = true
			self:SetFrameStrata("TOOLTIP")
		end

		self.DragStop = function()
			self:SetFrameStrata(self.strata)
			self.isMoving = false
			self:SetMovable(false)
			self:StopMovingOrSizing()
			self:ClearAllPoints()
			self:SetPoint(self.point, self.relativeTo, self.relativePoint, self.xOfs, self.yOfs)
			CyborgMMO_RatPageController:CallbackDropped(self)
		end

		return self
	end
}

function CyborgMMO_CallbackButton_OnLoad(self)
	CyborgMMO_CallbackIcons.new(self)
end

function CyborgMMO_CallbackButton_OnClick(self)
	if self.OnClick then
		self.OnClick()
	end
end

function CyborgMMO_CallbackButton_OnDragStart(self)
	if self.DragStart then
		self.DragStart()
	end
end

function CyborgMMO_CallbackButton_OnDragStop(self)
	if self.DragStop then
		self.DragStop()
	end
end
