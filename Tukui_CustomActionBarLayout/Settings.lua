------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Settings.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOn = select(2, ...)
local T, C, L = Tukui:unpack()
local Constants = AddOn.Constants
local Strings = AddOn.Strings
local Settings = {}
C[Constants.ConfigGroup] = Settings


------------------------------------------------------------------------------------------
-- SETTINGS
------------------------------------------------------------------------------------------

local AddActionBarSettings = function(bar, enable, firstButtonCorner, orientation, buttonsPerRow, maxRows)
	Settings[bar.Name..Constants.EnableConfig] = enable
	Settings[bar.Name..Constants.FirstButtonCornerConfig] = {
		["Options"] = {
			[Strings.TopLeft] = Constants.Corners.TL,
			[Strings.TopRight] = Constants.Corners.TR,
			[Strings.BottomLeft] = Constants.Corners.BL,
			[Strings.BottomRight] = Constants.Corners.BR,
		},
		["Value"] = firstButtonCorner,
	}
	Settings[bar.Name..Constants.OrientationConfig] = {
		["Options"] = {
			[Strings.Horizontal] = Constants.Orientations.H,
			[Strings.Vertical] = Constants.Orientations.V,
		},
		["Value"] = orientation,
	}
	Settings[bar.Name..Constants.ButtonsPerRowConfig] = buttonsPerRow
	Settings[bar.Name..Constants.MaxRowsConfig] = maxRows
end

AddActionBarSettings(Constants.Bars.Primary, false, Constants.Corners.BL, Constants.Orientations.H, 12, 12)
AddActionBarSettings(Constants.Bars.BottomLeft, true, Constants.Corners.BR, Constants.Orientations.V, 3, 12)
AddActionBarSettings(Constants.Bars.BottomRight, true, Constants.Corners.BL, Constants.Orientations.V, 3, 12)
AddActionBarSettings(Constants.Bars.Secondary, false, Constants.Corners.BL, Constants.Orientations.H, 12, 12)
AddActionBarSettings(Constants.Bars.Right, false, Constants.Corners.TR, Constants.Orientations.V, 12, 12)
