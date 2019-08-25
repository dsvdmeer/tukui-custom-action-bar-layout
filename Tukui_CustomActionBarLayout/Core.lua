------------------------------------------------------------------------------------------
-- Tukui CustomActionBarLayout
-- Core.lua
------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------
-- SETUP
------------------------------------------------------------------------------------------
local AddOn = select(2, ...)
local T, C, L = Tukui:unpack()
local Constants = AddOn.Constants
local Settings = C[Constants.ConfigGroup]
local TukuiActionBars = T["ActionBars"]


------------------------------------------------------------------------------------------
-- CORE
------------------------------------------------------------------------------------------
local ValidateEnum = function(test, enum, default)
	if type(test) ~= "table" then
		return default
	end
	test = test.Value
	for _, value in pairs(enum) do
		if test == value then
			return test
		end
	end
	return default
end

local ValidateRange = function(test, minValue, maxValue, default)
	if type(test) ~= "number" then
		return default
	end
	if test < minValue then
		return minValue
	end
	if test > maxValue then
		return maxValue
	end
	return test
end

local Hook = function(t, functionName, pre, post)
	local OriginalFunction = t[functionName]
	t[functionName] = function(...)
		local Result
		if pre ~= nil then
			pre(...)
		end
		if OriginalFunction ~= nil then
			Result = OriginalFunction(...)
		end
		if post ~= nil then
			post(...)
		end
		return Result
	end
end

local HookScript = function(f, eventName, pre, post)
	local OriginalFunction = f:GetScript(eventName)
	f:SetScript(eventName, function(...)
		if pre ~= nil then
			pre(...)
		end
		if OriginalFunction ~= nil then
			OriginalFunction(...)
		end
		if post ~= nil then
			post(...)
		end
	end)
end

function AddOn:CalculateBarLayout(bar)
	if not Settings[bar.Name..Constants.EnableConfig] then
		return nil
	end

	local Layout = {}

	Layout.ButtonCount = bar.ButtonCount

	local FirstButtonCorner = ValidateEnum(Settings[bar.Name..Constants.FirstButtonCornerConfig], Constants.Corners, Constants.Corners.BL)
	local Orientation = ValidateEnum(Settings[bar.Name..Constants.OrientationConfig], Constants.Orientations, Constants.Orientations.H)
	local ButtonsPerRow = ValidateRange(Settings[bar.Name..Constants.ButtonsPerRowConfig], 1, Layout.ButtonCount, Layout.ButtonCount)
	local MaxRows = ValidateRange(Settings[bar.Name..Constants.MaxRowsConfig], 1, Layout.ButtonCount, Layout.ButtonCount)

	if Orientation == Constants.Orientations.H then
		Layout.Width = min(ButtonsPerRow, Layout.ButtonCount)
		Layout.Height = min(ceil(Layout.ButtonCount / ButtonsPerRow), MaxRows)
	else
		Layout.Height = min(ButtonsPerRow, Layout.ButtonCount)
		Layout.Width = min(ceil(Layout.ButtonCount / ButtonsPerRow), MaxRows)
	end

	for i = 1, Layout.ButtonCount do
		local ButtonLayout = {}

		if FirstButtonCorner == Constants.Corners.TL then
			if Orientation == Constants.Orientations.H then
				ButtonLayout.X = ((i - 1) % ButtonsPerRow) + 1
				ButtonLayout.Y = Layout.Height - floor((i - 1) / ButtonsPerRow)
			else
				ButtonLayout.X = floor((i - 1) / ButtonsPerRow) + 1
				ButtonLayout.Y = Layout.Height - ((i - 1) % ButtonsPerRow)
			end
		elseif FirstButtonCorner == Constants.Corners.TR then
			if Orientation == Constants.Orientations.H then
				ButtonLayout.X = Layout.Width - ((i - 1) % ButtonsPerRow)
				ButtonLayout.Y = Layout.Height - floor((i - 1) / ButtonsPerRow)
			else
				ButtonLayout.X = Layout.Width - floor((i - 1) / ButtonsPerRow)
				ButtonLayout.Y = Layout.Height - ((i - 1) % ButtonsPerRow)
			end
		elseif FirstButtonCorner == Constants.Corners.BL then
			if Orientation == Constants.Orientations.H then
				ButtonLayout.X = ((i - 1) % ButtonsPerRow) + 1
				ButtonLayout.Y = floor((i - 1) / ButtonsPerRow) + 1
			else
				ButtonLayout.X = floor((i - 1) / ButtonsPerRow) + 1
				ButtonLayout.Y = ((i - 1) % ButtonsPerRow) + 1
			end
		elseif FirstButtonCorner == Constants.Corners.BR then
			if Orientation == Constants.Orientations.H then
				ButtonLayout.X = Layout.Width - ((i - 1) % ButtonsPerRow)
				ButtonLayout.Y = floor((i - 1) / ButtonsPerRow) + 1
			else
				ButtonLayout.X = Layout.Width - floor((i - 1) / ButtonsPerRow)
				ButtonLayout.Y = ((i - 1) % ButtonsPerRow) + 1
			end
		end

		Layout["ButtonLayout"..i] = ButtonLayout
	end

	Layout.MaxWidth = nil
	Layout.MaxHeight = nil

	self.Layouts[bar.Name] = Layout
end

function AddOn:CalculateBarLayouts()
	self.Layouts = {}
	for i = 1, #Constants.AllBars do
		self:CalculateBarLayout(Constants.AllBars[i])
	end
end

function AddOn:LayoutBar(bar)
	local Layout = self.Layouts[bar.Name]
	if type(Layout) ~= "table" then
		return
	end

	local Bar = T.Panels[bar.Name]

	local Button, ButtonLayout
	local Size = 0
	local Spacing = C.ActionBars.ButtonSpacing
	for i = 1, Layout.ButtonCount do
		Button = Bar["Button"..i]
		ButtonLayout = Layout["ButtonLayout"..i]

		if i == 1 then
			Size = Button:GetWidth()
		end

		Button:ClearAllPoints()
		Button:SetPoint("BOTTOMLEFT", Bar, ((ButtonLayout.X - 1) * Size) + (ButtonLayout.X * Spacing), ((ButtonLayout.Y - 1) * Size) + (ButtonLayout.Y * Spacing))
	end
end

function AddOn:LayoutBars()
	for i = 1, #Constants.AllBars do
		self:LayoutBar(Constants.AllBars[i])
	end
end

function AddOn:ResizeBar(bar)
	local Layout = self.Layouts[bar.Name]
	if type(Layout) ~= "table" then
		return
	end

	local Width
	if type(Layout.MaxWidth) == "number" then
		Width = min(Layout.Width, Layout.MaxWidth)
	else
		Width = Layout.Width
	end
	local Height
	if type(Layout.MaxHeight) == "number" then
		Height = min(Layout.Height, Layout.MaxHeight)
	else
		Height = Layout.Height
	end

	local Bar = T.Panels[bar.Name]

	local Button, ButtonLayout
	local Size = 0
	local Spacing = C.ActionBars.ButtonSpacing
	for i = 1, Layout.ButtonCount do
		Button = Bar["Button"..i]
		ButtonLayout = Layout["ButtonLayout"..i]

		if i == 1 then
			Size = Button:GetWidth()
		end

		if ButtonLayout.X >= 1 and ButtonLayout.X <= Width and ButtonLayout.Y >= 1 and ButtonLayout.Y <= Height then
			Button:Show()
		else
			Button:Hide()
		end
	end

	Bar:SetWidth((Width * Size) + ((Width + 1) * Spacing))
	Bar:SetHeight((Height * Size) + ((Height + 1) * Spacing))
end

function AddOn:ResizeBars()
	for i = 1, #Constants.AllBars do
		self:ResizeBar(Constants.AllBars[i])
	end
end

function AddOn:ResizeToggleButton(bar)
	if not Settings[bar.Name..Constants.EnableConfig] then
		return nil
	end

	if type(bar.ToggleButtonName) ~= "string" or type(bar.ToggleButtonOrientation) ~= "string" then
		return
	end

	local Bar = T.Panels[bar.Name]
	local ToggleButton = T.Panels[bar.ToggleButtonName]

	if bar.ToggleButtonOrientation == Constants.Orientations.H then
		local Width = Bar:GetWidth()
		if not Bar:IsVisible() then
			if type(bar.ToggleButtonHiddenWidth) == "number" then
				Width = bar.ToggleButtonHiddenWidth
			elseif type(bar.ToggleButtonHiddenWidth) == "function" then
				Width = bar.ToggleButtonHiddenWidth()
			end
		end
		ToggleButton:SetWidth(Width)
	else
		local Height = Bar:GetHeight()
		if not Bar:IsVisible() then
			if type(bar.ToggleButtonHiddenHeight) == "number" then
				Height = bar.ToggleButtonHiddenHeight
			elseif type(bar.ToggleButtonHiddenHeight) == "function" then
				Height = bar.ToggleButtonHiddenHeight()
			end
		end
		ToggleButton:SetHeight(Height)
	end
end

function AddOn:ResizeToggleButtons()
	for i = 1, #Constants.AllBars do
		self:ResizeToggleButton(Constants.AllBars[i])
	end
end

function AddOn:HookToggleButtons()
	for i = 1, #Constants.AllBars do
		local Bar = Constants.AllBars[i]
		if Bar.ToggleButtonName ~= nil then
			local ToggleButton = T.Panels[Bar.ToggleButtonName]
			HookScript(ToggleButton, "OnClick", nil, function(self)
				if IsShiftKeyDown() then
					for i = 1, #Constants.AllBars do
						if T.Panels[Constants.AllBars[i].Name] == self.Bar then
							AddOn:ResizeBar(Constants.AllBars[i])
						end
					end
				end
				AddOn:ResizeToggleButtons()
			end)
			if Settings[Bar.Name..Constants.EnableConfig] then
				HookScript(ToggleButton, "OnEnter", nil, function(self)
					if GameTooltipTextLeft2 ~= nil and GameTooltipTextLeft2:GetText() == "Shift-click to set the amount of buttons" then
						GameTooltipTextLeft2:Hide()
						GameTooltip:Show()
					end
				end)
			end
		end
	end
end

local TopButtonsBars = {Constants.Bars.BottomLeft, Constants.Bars.BottomRight}

function AddOn:ShowTopButtons()
	for i = 1, #TopButtonsBars do
		local Layout = self.Layouts[TopButtonsBars[i].Name]
		if type(Layout) == "table" then
			Layout.MaxHeight = nil
			self:ResizeBar(TopButtonsBars[i])
		end
	end
end

function AddOn:HideTopButtons()
	local MaxHeight = 1
	local PrimaryLayout = self.Layouts[Constants.Bars.Primary.Name]
	if type(PrimaryLayout) == "table" then
		MaxHeight = PrimaryLayout.Height
	end

	for i = 1, #TopButtonsBars do
		local Layout = self.Layouts[TopButtonsBars[i].Name]
		if type(Layout) == "table" then
			Layout.MaxHeight = MaxHeight
			self:ResizeBar(TopButtonsBars[i])
		end
	end
end

function AddOn:FixSecondaryActionBar()
	local PrimaryLayout = self.Layouts[Constants.Bars.Primary.Name]
	local SecondaryLayout = self.Layouts[Constants.Bars.Secondary.Name]

	local PrimaryBar = T.Panels[Constants.Bars.Primary.Name]
	local PrimaryButtonSize = PrimaryBar["Button1"]:GetWidth()
	local SecondaryBar = T.Panels[Constants.Bars.Secondary.Name]
	local SecondaryButtonSize = PrimaryBar["Button1"]:GetWidth()
	local Spacing = C.ActionBars.ButtonSpacing

	if PrimaryLayout == nil then
		if SecondaryLayout == nil then
			return
		end
		PrimaryLayout = {
			["Width"] = Constants.Bars.Primary.ButtonCount,
			["Height"] = 1,
		}
	end

	if SecondaryLayout == nil then
		SecondaryLayout = {
			["Width"] = Constants.Bars.Secondary.ButtonCount,
			["Height"] = 1,
		}
		SecondaryBar:SetWidth((SecondaryLayout.Width * SecondaryButtonSize) + ((SecondaryLayout.Width + 1) * Spacing))
		SecondaryBar:SetHeight((SecondaryLayout.Height * SecondaryButtonSize) + ((SecondaryLayout.Height + 1) * Spacing))
	end

	SecondaryBar:ClearAllPoints()
	SecondaryBar:SetPoint("BOTTOM", PrimaryBar, "TOP", 0, -Spacing)
	SecondaryBar.Backdrop:ClearAllPoints()
	SecondaryBar.Backdrop:SetPoint("TOPLEFT")
	SecondaryBar.Backdrop:SetPoint("BOTTOMRIGHT", 0, -PrimaryLayout.Height * (PrimaryButtonSize + Spacing))
end


Hook(TukuiActionBars, "Enable", function()
	-- Pre Enable
	AddOn:CalculateBarLayouts()
end, function()
	-- Post Enable
	AddOn:LayoutBars()
	AddOn:ResizeBars()
	AddOn:ResizeToggleButtons()
	AddOn:HookToggleButtons()

	HookScript(T.Panels.ActionBar1, "OnEvent", nil, function(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			AddOn:LayoutBar(Constants.Bars.Primary)
			AddOn:ResizeBar(Constants.Bars.Primary)
			AddOn:FixSecondaryActionBar()
		end
	end)
end)


Hook(TukuiActionBars, "ShowTopButtons", nil, function()
	AddOn:ShowTopButtons()
end)

Hook(TukuiActionBars, "HideTopButtons", nil, function()
	AddOn:HideTopButtons()
end)
