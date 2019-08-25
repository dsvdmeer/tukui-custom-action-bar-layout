------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Strings.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOn = select(2, ...)
local T, C, L = Tukui:unpack()
local Strings = {}
AddOn.Strings = Strings


------------------------------------------------------------------------------------------
-- Strings
------------------------------------------------------------------------------------------
Strings.TopLeft = "Top-left"
Strings.TopRight = "Top-right"
Strings.BottomLeft = "Bottom-left"
Strings.BottomRight = "Bottom-right"

Strings.Horizontal = "Horizontal"
Strings.Vertical = "Vertical"

Strings.ActionBar1ConfigName = "Main Action Bar - Bottom"
Strings.ActionBar2ConfigName = "Bottom-left Action Bar"
Strings.ActionBar3ConfigName = "Bottom-right Action Bar"
Strings.ActionBar4ConfigName = "Main Action Bar - Top"
Strings.ActionBar5ConfigName = "Right Action Bar"
Strings.EnableCustomActionBarLayout = "Enable custom layout for this action bar"
Strings.FirstButtonCorner = "Corner of first button"
Strings.Orientation = "Layout direction"
Strings.ButtonsPerRow = "Number of buttons per row"
Strings.MaxRows = "Maximum number of rows"
