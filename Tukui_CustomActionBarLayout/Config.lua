------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Config.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOn = select(2, ...)
local T, C, L = Tukui:unpack()
local Constants = AddOn.Constants
local Strings = AddOn.Strings
local GUI = T["GUI"]


------------------------------------------------------------------------------------------
-- CONFIG
------------------------------------------------------------------------------------------
local CustomActionBarLayout = function(self)
	local Window = self:GetWindow("Actionbars")

	for i = 1, #Constants.AllBars do
		local Bar = Constants.AllBars[i]
		if Bar.Configurable then
			Window:CreateSection(Strings[Bar.Name.."ConfigName"] or Bar.Name)
			Window:CreateSwitch(Constants.ConfigGroup, Bar.Name..Constants.EnableConfig, Strings.EnableCustomActionBarLayout)
			Window:CreateDropdown(Constants.ConfigGroup, Bar.Name..Constants.FirstButtonCornerConfig, Strings.FirstButtonCorner)
			Window:CreateDropdown(Constants.ConfigGroup, Bar.Name..Constants.OrientationConfig, Strings.Orientation)
			Window:CreateSlider(Constants.ConfigGroup, Bar.Name..Constants.ButtonsPerRowConfig, Strings.ButtonsPerRow, 1, Bar.ButtonCount, 1)
			Window:CreateSlider(Constants.ConfigGroup, Bar.Name..Constants.MaxRowsConfig, Strings.MaxRows, 1, Bar.ButtonCount, 1)
		end
	end
end
GUI:AddWidgets(CustomActionBarLayout)
