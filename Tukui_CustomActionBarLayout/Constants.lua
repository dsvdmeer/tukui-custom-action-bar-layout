------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Constants.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOnName, AddOn = ...
local Constants = {}
AddOn.Constants = Constants


------------------------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------------------------
Constants.AddOnName = AddOnName

Constants.Corners = {
	["TL"] = "TOPLEFT",
	["TR"] = "TOPRIGHT",
	["BL"] = "BOTTOMLEFT",
	["BR"] = "BOTTOMRIGHT",
}
Constants.Orientations = {
	["H"] = "HORIZONTAL",
	["V"] = "VERTICAL",
}

Constants.ConfigGroup = "CustomActionBarLayout"
Constants.EnableConfig = "Enable"
Constants.FirstButtonCornerConfig = "FirstButtonCorner"
Constants.OrientationConfig = "Orientation"
Constants.ButtonsPerRowConfig = "ButtonsPerRow"
Constants.MaxRowsConfig = "MaxRows"
