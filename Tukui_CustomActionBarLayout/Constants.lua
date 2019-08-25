------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Constants.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOnName, AddOn = ...
local T, C, L = Tukui:unpack()
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

Constants.Bars = {
	["Primary"] = {
		["Name"] = "ActionBar1",
	},
	["Secondary"] = {
		["Name"] = "ActionBar4",
		["ToggleButtonName"] = "ActionBar4ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.H,
	},
	["BottomLeft"] = {
		["Name"] = "ActionBar2",
		["ToggleButtonName"] = "ActionBar2ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.V,
	},
	["BottomRight"] = {
		["Name"] = "ActionBar3",
		["ToggleButtonName"] = "ActionBar3ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.V,
	},
	["Right"] = {
		["Name"] = "ActionBar5",
		["ToggleButtonName"] = "ActionBar5ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.H,
		["ToggleButtonHiddenWidth"] = function() return MultiBarBottomLeftButton1:GetWidth() end,
	},
}
Constants.AllBars = {Constants.Bars.Primary, Constants.Bars.Secondary, Constants.Bars.BottomLeft, Constants.Bars.BottomRight, Constants.Bars.Right}

Constants.ConfigGroup = "CustomActionBarLayout"
Constants.EnableConfig = "Enable"
Constants.FirstButtonCornerConfig = "FirstButtonCorner"
Constants.OrientationConfig = "Orientation"
Constants.ButtonsPerRowConfig = "ButtonsPerRow"
Constants.MaxRowsConfig = "MaxRows"
