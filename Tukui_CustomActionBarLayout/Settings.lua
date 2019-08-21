------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Settings.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOn = select(2, ...)
local Constants = AddOn.Constants
local Strings = AddOn.Strings
local T, C, L = Tukui:unpack()
local Settings = {}
C[Constants.ConfigGroup] = Settings


------------------------------------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------------------------------------

local AddActionBarSettings = function(name, enable, firstButtonCorner, orientation, buttonsPerRow, maxRows)
	Settings[name..Constants.EnableConfig] = enable
	Settings[name..Constants.FirstButtonCornerConfig] = {
		["Options"] = {
			[Strings.TopLeft] = Constants.Corners.TL,
			[Strings.TopRight] = Constants.Corners.TR,
			[Strings.BottomLeft] = Constants.Corners.BL,
			[Strings.BottomRight] = Constants.Corners.BR,
		},
		["Value"] = firstButtonCorner,
	}
	Settings[name..Constants.OrientationConfig] = {
		["Options"] = {
			[Strings.Horizontal] = Constants.Orientations.H,
			[Strings.Vertical] = Constants.Orientations.V,
		},
		["Value"] = orientation,
	}
	Settings[name..Constants.ButtonsPerRowConfig] = buttonsPerRow
	Settings[name..Constants.MaxRowsConfig] = maxRows
end

AddActionBarSettings("ActionBar1", false, Constants.Corners.BL, Constants.Orientations.H, 12, 12)
AddActionBarSettings("ActionBar2", true, Constants.Corners.BR, Constants.Orientations.V, 3, 12)
AddActionBarSettings("ActionBar3", true, Constants.Corners.BL, Constants.Orientations.V, 3, 12)
AddActionBarSettings("ActionBar4", false, Constants.Corners.BL, Constants.Orientations.H, 12, 12)
AddActionBarSettings("ActionBar5", false, Constants.Corners.TR, Constants.Orientations.V, 12, 12)
