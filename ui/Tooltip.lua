--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/Tooltip.lua
--~ Description: Tooltip presentation helpers

CyborgMMO.Core = CyborgMMO.Core or {}
local Core = CyborgMMO.Core
Core.UI = Core.UI or {}
Core.UI.Tooltip = Core.UI.Tooltip or {}

function Core.UI.Tooltip.ShowProfileTooltip(self)
	local modeDetected = CyborgMMO.Core and CyborgMMO.Core.Bindings and CyborgMMO.Core.Bindings.ModeDetected
	if not modeDetected then
		GameTooltip:SetOwner(self:GetParent(), "ANCHOR_RIGHT")
		GameTooltip:SetText(CyborgMMO_StringTable.CyborgMMO_ToolTipLine1, nil, nil, nil, nil, 1)
		GameTooltip:AddLine(nil, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable.CyborgMMO_ToolTipLine2, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(nil, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable.CyborgMMO_ToolTipLine3, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable.CyborgMMO_ToolTipLine4, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable.CyborgMMO_ToolTipLine5, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(nil, 0.8, 1.0, 0.8)
		GameTooltip:AddLine(CyborgMMO_StringTable.CyborgMMO_ToolTipLine6, 0.8, 1.0, 0.8)
		GameTooltip:Show()
	end
end

function Core.UI.Tooltip.HideProfileTooltip()
	GameTooltip:Hide()
end
