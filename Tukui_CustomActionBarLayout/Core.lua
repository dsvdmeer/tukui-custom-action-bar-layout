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

	local Layout = {}

	Layout.ButtonCount = NUM_ACTIONBAR_BUTTONS

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
	if type(bar.ToggleButtonName) ~= "string" or type(bar.ToggleButtonOrientation) ~= "string" then
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
	for i = 1, #Constants.AllBars do
		if Constants.AllBars[i].ToggleButtonName ~= nil then
			local ToggleButton = T.Panels[Constants.AllBars[i].ToggleButtonName]
			HookScript(ToggleButton, "OnClick", nil, function(self)
				if IsShiftKeyDown() then
					AddOn:ResizeBar(Constants.AllBars[self.Num])
				end
				AddOn:ResizeToggleButtons()
			end)			
			HookScript(ToggleButton, "OnEnter", nil, function(self)
				if GameTooltipTextLeft2 ~= nil and GameTooltipTextLeft2:GetText() == "Shift-click to set the amount of buttons" then
					GameTooltipTextLeft2:Hide()
					GameTooltip:Show()
				end
			end)			
		end
	end
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


local TopButtonsBars = {Constants.Bars.BottomLeft, Constants.Bars.BottomRight}

Hook(TukuiActionBars, "ShowTopButtons", nil, function()
	for i = 1, #TopButtonsBars do
		local Layout = AddOn.Layouts[TopButtonsBars[i].Name]
		if type(Layout) == "table" then
			Layout.MaxHeight = nil
			AddOn:ResizeBar(TopButtonsBars[i])
		end
	end
end)

Hook(TukuiActionBars, "HideTopButtons", nil, function()
	local MaxHeight = 1
	local PrimaryLayout = AddOn.Layouts[Constants.Bars.Primary.Name]
	if type(PrimaryLayout) == "table" then
		MaxHeight = PrimaryLayout.Height
	end

	for i = 1, #TopButtonsBars do
		local Layout = AddOn.Layouts[TopButtonsBars[i].Name]
		if type(Layout) == "table" then
			Layout.MaxHeight = MaxHeight
			AddOn:ResizeBar(TopButtonsBars[i])
		end
	end
end)
