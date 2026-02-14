--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: ui/Tooltip.lua
--~ Description: Tooltip presentation helpers

function CyborgMMO_ShowProfileTooltip(self)
	if not CyborgMMO_ModeDetected then
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

function CyborgMMO_HideProfileTooltip()
	GameTooltip:Hide()
end
