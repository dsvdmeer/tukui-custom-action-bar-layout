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
		["ButtonCount"] = 12,
		["Configurable"] = true,
	},
	["Secondary"] = {
		["Name"] = "ActionBar4",
		["ButtonCount"] = 12,
		["ToggleButtonName"] = "ActionBar4ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.H,
		["Configurable"] = true,
	},
	["BottomLeft"] = {
		["Name"] = "ActionBar2",
		["ButtonCount"] = 12,
		["ToggleButtonName"] = "ActionBar2ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.V,
		["Configurable"] = true,
	},
	["BottomRight"] = {
		["Name"] = "ActionBar3",
		["ButtonCount"] = 12,
		["ToggleButtonName"] = "ActionBar3ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.V,
		["Configurable"] = true,
	},
	["Right"] = {
		["Name"] = "ActionBar5",
		["ButtonCount"] = 12,
		["ToggleButtonName"] = "ActionBar5ToggleButton",
		["ToggleButtonOrientation"] = Constants.Orientations.H,
		["ToggleButtonHiddenWidth"] = function() return MultiBarBottomLeftButton1:GetWidth() end,
		["Configurable"] = true,
	},
}
Constants.AllBars = {Constants.Bars.Primary, Constants.Bars.Secondary, Constants.Bars.BottomLeft, Constants.Bars.BottomRight, Constants.Bars.Right}

Constants.ConfigGroup = "CustomActionBarLayout"
Constants.EnableConfig = "Enable"
Constants.FirstButtonCornerConfig = "FirstButtonCorner"
Constants.OrientationConfig = "Orientation"
Constants.ButtonsPerRowConfig = "ButtonsPerRow"
Constants.MaxRowsConfig = "MaxRows"
