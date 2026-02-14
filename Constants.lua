--~ Warcraft Plugin for Cyborg MMO7
--~ Filename: Constants.lua
--~ Description: Shared constants for addon modules

CyborgMMO_Constants = {
	RAT_BUTTONS = 13,
	RAT_MODES = 3,
	RAT_SHIFT = 0,
	RANDOM_MOUNT_ID = 0xFFFFFFF,
	MEDIA_PATH = "Interface\\AddOns\\Cyborg-MMO7-Revival\\Graphics\\",
}

CyborgMMO = CyborgMMO or {}
CyborgMMO.Constants = CyborgMMO_Constants
CyborgMMO.Data = CyborgMMO.Data or {}

-- Canonical API: CyborgMMO.Constants / CyborgMMO.Data
-- Legacy globals are still maintained while modules migrate.
