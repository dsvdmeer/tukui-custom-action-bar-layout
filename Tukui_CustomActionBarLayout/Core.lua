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
	local Enable = Settings[bar.Name..Constants.EnableConfig]
	if not Enable then
		return nil
	end

	local FirstButtonCorner = ValidateEnum(Settings[bar.Name..Constants.FirstButtonCornerConfig], Constants.Corners, Constants.Corners.BL)
	local Orientation = ValidateEnum(Settings[bar.Name..Constants.OrientationConfig], Constants.Orientations, Constants.Orientations.H)
	local ButtonsPerRow = ValidateRange(Settings[bar.Name..Constants.ButtonsPerRowConfig], 1, 12, 12)
	local MaxRows = ValidateRange(Settings[bar.Name..Constants.MaxRowsConfig], 1, 12, 12)

	local Layout = {}

	Layout.ButtonCount = NUM_ACTIONBAR_BUTTONS

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

function AddOn:ResizeBar(bar, maxWidth, maxHeight)
	local Layout = self.Layouts[bar.Name]
	if type(Layout) ~= "table" then
		return
	end

	local Width
	if type(maxWidth) == "number" then
		Width = min(Layout.Width, maxWidth)
	else
		Width = Layout.Width
	end
	local Height
	if type(maxHeight) == "number" then
		Height = min(Layout.Height, maxHeight)
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
	if type(bar.ToggleButtonName) ~= "string" then
		return
	end

	local Bar = T.Panels[bar.Name]
	local ToggleButton = T.Panels[bar.ToggleButtonName]

	if bar.ToggleButtonOrientation == Constants.Orientations.H then
		ToggleButton:SetWidth(Bar:GetWidth())
	else
		ToggleButton:SetHeight(Bar:GetHeight())
	end
end

function AddOn:ResizeToggleButtons()
	for i = 1, #Constants.AllBars do
		self:ResizeToggleButton(Constants.AllBars[i])
	end
end

function AddOn:HookToggleButtons()
	HookScript(T.Panels[Constants.Bars.Secondary.ToggleButtonName], "OnClick", nil, function(self)
		AddOn:ResizeToggleButton(Constants.Bars.BottomLeft)
		AddOn:ResizeToggleButton(Constants.Bars.BottomRight)
	end)
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
end)

Hook(TukuiActionBars, "ShowTopButtons", nil, function()
	AddOn:ResizeBar(Constants.Bars.BottomLeft)
	AddOn:ResizeBar(Constants.Bars.BottomRight)
end)

Hook(TukuiActionBars, "HideTopButtons", nil, function()
	local MaxHeight = 1
	local PrimaryLayout = AddOn.Layouts[Constants.Bars.Primary.Name]
	if type(PrimaryLayout) == "table" then
		MaxHeight = PrimaryLayout.Height
	end
	AddOn:ResizeBar(Constants.Bars.BottomLeft, nil, MaxHeight)
	AddOn:ResizeBar(Constants.Bars.BottomRight, nil, MaxHeight)	
end)
