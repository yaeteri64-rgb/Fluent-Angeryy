--[[
Fluent Renewed — Core-Min (Pinned Icons+Themes URLs)
- Single file, similar to original usage: execute and done.
- Icons fetched from pinned URL. Themes fetched from pinned provider URL (path-aware).
- Keybinds: '-' collapse, RightControl hide.
]]
local __MODULES = {
    ["Src/Components/Assets"] = [=[
return { 
	Close = "rbxassetid://9886659671",
	Min = "rbxassetid://9886659276",
	Max = "rbxassetid://9886659406",
	Restore = "rbxassetid://9886659001",
}

]=],
    ["Src/Components/Button"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Modules.Creator)
local New = Creator.New

local Spring = Flipper.Spring.new

return function(Theme, Parent, DialogCheck)
	local Button = {}

	DialogCheck = DialogCheck or false

	Button.Title = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Button.HoverFrame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ThemeTag = {
			BackgroundColor3 = "Hover",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
	})

	Button.Frame = New("TextButton", {
		Size = UDim2.new(0, 0, 0, 32),
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "DialogButton",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = 0.65,
			ThemeTag = {
				Color = "DialogButtonBorder",
			},
		}),
		Button.HoverFrame,
		Button.Title,
	})

	local Motor, SetTransparency = Creator.SpringMotor(1, Button.HoverFrame, "BackgroundTransparency", DialogCheck)
	Creator.AddSignal(Button.Frame.MouseEnter, function()
		SetTransparency(0.97)
	end)
	Creator.AddSignal(Button.Frame.MouseLeave, function()
		SetTransparency(1)
	end)
	Creator.AddSignal(Button.Frame.MouseButton1Down, function()
		SetTransparency(1)
	end)
	Creator.AddSignal(Button.Frame.MouseButton1Up, function()
		SetTransparency(0.97)
	end)

	return Button
end

]=],
    ["Src/Components/Dialog"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)
local Button_Component = require(Root.Components.Button)
local Signal = require(Root.Packages.Signal)

local New = Creator.New

local Dialog = {
	Window = nil,
}

function Dialog:Init(Window)
	Dialog.Window = Window
	return Dialog
end

function Dialog:Create()
	local NewDialog, Library = {
		Buttons = 0,
		Closing = Signal.new(),
		Closed = Signal.new()
	}, require(Root)

	NewDialog.TintFrame = New("TextButton", {
		Text = "",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = Dialog.Window.Root,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
	})

	local TintMotor, TintTransparency = Creator.SpringMotor(1, NewDialog.TintFrame, "BackgroundTransparency", true)

	NewDialog.ButtonHolder = New("Frame", {
		Size = UDim2.new(1, -40, 1, -40),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 10),
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	NewDialog.ButtonHolderFrame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 70),
		Position = UDim2.new(0, 0, 1, -70),
		ThemeTag = {
			BackgroundColor3 = "DialogHolder",
		},
	}, {
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			ThemeTag = {
				BackgroundColor3 = "DialogHolderLine",
			},
		}),
		NewDialog.ButtonHolder,
	})

	NewDialog.Title = New("TextLabel", {
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.SemiBold,
			Enum.FontStyle.Normal
		),
		Text = "Dialog",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 22,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.fromOffset(20, 25),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewDialog.Scale = New("UIScale", {
		Scale = 1,
	})

	local ScaleMotor, Scale = Creator.SpringMotor(1.1, NewDialog.Scale, "Scale")

	NewDialog.Root = New("CanvasGroup", {
		Size = UDim2.fromOffset(300, 165),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		GroupTransparency = 1,
		Parent = NewDialog.TintFrame,
		ThemeTag = {
			BackgroundColor3 = "Dialog",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),
		New("UIStroke", {
			Transparency = 0.5,
			ThemeTag = {
				Color = "DialogBorder",
			},
		}),
		NewDialog.Scale,
		NewDialog.Title,
		NewDialog.ButtonHolderFrame,
	})

	local RootMotor, RootTransparency = Creator.SpringMotor(1, NewDialog.Root, "GroupTransparency")

	function NewDialog:Open()
		Library.DialogOpen = true
		NewDialog.Scale.Scale = 1.1
		TintTransparency(0.75)
		RootTransparency(0)
		Scale(1)
	end

	function NewDialog:Close()
		NewDialog.Closing:Fire()
		Library.DialogOpen = false
		TintTransparency(1)
		RootTransparency(1)
		Scale(1.1)
		NewDialog.Root.UIStroke:Destroy()
		task.wait(0.15)
		NewDialog.TintFrame:Destroy()
		NewDialog.Closed:Fire()
	end

	function NewDialog:Button(Title, Callback)
		NewDialog.Buttons = NewDialog.Buttons + 1
		Title = Title or "Button"
		Callback = Callback or function() end

		local Button = Button_Component("", NewDialog.ButtonHolder, true)
		Button.Title.Text = Title

		for _, Btn in next, NewDialog.ButtonHolder:GetChildren() do
			if Btn:IsA("TextButton") then
				Btn.Size = UDim2.new(1 / NewDialog.Buttons, -((NewDialog.Buttons - 1) * 10 / NewDialog.Buttons), 0, 32)
			end
		end

		Creator.AddSignal(Button.Frame.MouseButton1Click, function()
			Library:SafeCallback(Callback)
			pcall(function()
				NewDialog:Close()
			end)
		end)

		return Button
	end

	return NewDialog
end

return Dialog

]=],
    ["Src/Components/Element"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)
local New = Creator.New

return function(Title, Desc, Parent, Hover, Config)
	local Element = {
		CreatedAt = tick()
	}

	Config = typeof(Config) == "table" and Config or {}

	Element.TitleLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
		Text = Title,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Config.TitleAlignment or Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	}) :: TextLabel

	Element.DescLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		Text = Desc,
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Config.DescriptionAlignment or Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 14),
		ThemeTag = {
			TextColor3 = "SubText",
		},
	}) :: TextLabel

	Element.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -28, 0, 0),
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),
		New("UIPadding", {
			PaddingBottom = UDim.new(0, 13),
			PaddingTop = UDim.new(0, 13),
		}),
		Element.TitleLabel,
		Element.DescLabel,
	}) :: Frame

	Element.Border = New("UIStroke", {
		Transparency = 0.5,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = Color3.fromRGB(0, 0, 0),
		ThemeTag = {
			Color = "ElementBorder",
		},
	}) :: UIStroke

	Element.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 0.89,
		BackgroundColor3 = Color3.fromRGB(130, 130, 130),
		Parent = Parent,
		AutomaticSize = Enum.AutomaticSize.Y,
		Text = "",
		LayoutOrder = 7,
		ThemeTag = {
			BackgroundColor3 = "Element",
			BackgroundTransparency = "ElementTransparency",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		Element.Border,
		Element.LabelHolder,
	}) :: TextButton

	function Element:SetTitle(Set)
		Element.TitleLabel.Text = Set
	end

	function Element:SetDesc(Set)
		if Set == nil then
			Set = ""
		end
		if Set == "" then
			Element.DescLabel.Visible = false
		else
			Element.DescLabel.Visible = true
		end
		Element.DescLabel.Text = Set
	end

	function Element:Destroy()
		Element.Frame:Destroy()
	end

	Element:SetTitle(Title)
	Element:SetDesc(Desc)

	if Hover then
		local Themes = Root.Themes
		local Motor, SetTransparency = Creator.SpringMotor(
			Creator.GetThemeProperty("ElementTransparency"),
			Element.Frame,
			"BackgroundTransparency",
			false,
			true
		)

		Creator.AddSignal(Element.Frame.MouseEnter, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end)
		Creator.AddSignal(Element.Frame.MouseLeave, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency"))
		end)
		Creator.AddSignal(Element.Frame.MouseButton1Down, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") + Creator.GetThemeProperty("HoverChange"))
		end)
		Creator.AddSignal(Element.Frame.MouseButton1Up, function()
			SetTransparency(Creator.GetThemeProperty("ElementTransparency") - Creator.GetThemeProperty("HoverChange"))
		end)
	end

	return setmetatable(Element, {
		__newindex =  function(self, index, newvalue)
			if index == "Title" then
				Element:SetTitle(newvalue)
			elseif index == "Description" or index == "Desc" then
				Element:SetDesc(newvalue)
			end
			return rawset(self, index, newvalue)
		end
	})
end

]=],
    ["Src/Components/Notification"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent

local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Modules.Creator)
local Acrylic = require(Root.Modules.Acrylic)

local Spring = Flipper.Spring.new
local Instant = Flipper.Instant.new
local New = Creator.New

local SoundService = game:GetService("SoundService")

local Notification = {}

function Notification:Init(GUI)
	Notification.Holder = New("Frame", {
		Position = UDim2.new(1, -30, 1, -30),
		Size = UDim2.new(0, 310, 1, -30),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
		Parent = GUI,
	}, {
		New("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
			Padding = UDim.new(0, 20),
		}),
	})
end

function Notification:New(Config)
	local NewNotification = {
		Closed = false,
	}

	Config.Title = Config.Title or "Title"
	Config.Content = Config.Content or "Content"
	Config.SubContent = Config.SubContent or ""
	Config.Duration = Config.Duration or nil
	Config.Buttons = Config.Buttons or {}
	Config.Sound = Config.Sound or {}

	Config.Sound.Parent = SoundService
	Config.Sound.PlayOnRemove = true

	NewNotification.AcrylicPaint = Acrylic.AcrylicPaint()

	NewNotification.Title = New("TextLabel", {
		Position = UDim2.new(0, 14, 0, 17),
		Text = Config.Title,
		RichText = true,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextTransparency = 0,
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		TextSize = 13,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.new(1, -12, 0, 12),
		TextWrapped = true,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewNotification.ContentLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		Text = Config.Content,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundTransparency = 1,
		TextWrapped = true,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	NewNotification.SubContentLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		Text = Config.SubContent,
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextWrapped = true,
		ThemeTag = {
			TextColor3 = "SubText",
		},
	})

	NewNotification.LabelHolder = New("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(14, 40),
		Size = UDim2.new(1, -28, 0, 0),
	}, {
		New("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, 3),
		}),
		NewNotification.ContentLabel,
		NewNotification.SubContentLabel,
	})

	NewNotification.CloseButton = New("TextButton", {
		Text = "",
		Position = UDim2.new(1, -14, 0, 13),
		Size = UDim2.fromOffset(20, 20),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
	}, {
		New("ImageLabel", {
			Image = require(script.Parent.Assets).Close,
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			ThemeTag = {
				ImageColor3 = "Text",
			},
		}),
	})

	NewNotification.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.fromScale(1, 0),
	}, {
		NewNotification.AcrylicPaint.Frame,
		NewNotification.Title,
		NewNotification.CloseButton,
		NewNotification.LabelHolder,
	})

	if Config.Content == "" then
		NewNotification.ContentLabel.Visible = false
	end

	if Config.SubContent == "" then
		NewNotification.SubContentLabel.Visible = false
	end

	NewNotification.Holder = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 200),
		Parent = Notification.Holder,
	}, {
		NewNotification.Root,
	})

	local RootMotor = Flipper.GroupMotor.new({
		Scale = 1,
		Offset = 60,
	})

	RootMotor:onStep(function(Values)
		NewNotification.Root.Position = UDim2.new(Values.Scale, Values.Offset, 0, 0)
	end)

	Creator.AddSignal(NewNotification.CloseButton.MouseButton1Click, function()
		NewNotification:Close()
	end)

	function NewNotification:Open()
		local ContentSize = NewNotification.LabelHolder.AbsoluteSize.Y
		NewNotification.Holder.Size = UDim2.new(1, 0, 0, 58 + ContentSize)

		if Config.Sound.SoundId then
			NewNotification.Sound = New("Sound", Config.Sound)

			if not NewNotification.Sound.IsLoaded then
				NewNotification.Sound.Loaded:Wait()
			end

			NewNotification.Sound:Destroy()
			NewNotification.Sound = nil
		end

		RootMotor:setGoal({
			Scale = Spring(0, { frequency = 5 }),
			Offset = Spring(0, { frequency = 5 }),
		})
	end

	function NewNotification:Close()
		if not NewNotification.Closed then
			NewNotification.Closed = true
			task.spawn(function()
				RootMotor:setGoal({
					Scale = Spring(1, { frequency = 5 }),
					Offset = Spring(60, { frequency = 5 }),
				})
				task.wait(0.4)
				if require(Root).UseAcrylic then
					NewNotification.AcrylicPaint.Model:Destroy()
				end
				NewNotification.Holder:Destroy()
			end)
		end
	end

	NewNotification:Open()
	if Config.Duration then
		task.delay(Config.Duration, function()
			NewNotification:Close()
		end)
	end
	return NewNotification
end

return Notification

]=],
    ["Src/Components/Section"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New

return function(Title, Parent)
	local Section = {}

	Section.Layout = New("UIListLayout", {
		Padding = UDim.new(0, 5),
	})

	Section.Container = New("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		Position = UDim2.fromOffset(0, 24),
		BackgroundTransparency = 1,
	}, {
		Section.Layout,
	})

	Section.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 26),
		LayoutOrder = 7,
		Parent = Parent,
	}, {
		New("TextLabel", {
			RichText = true,
			Text = Title,
			TextTransparency = 0,
			FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
			TextSize = 18,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -16, 0, 18),
			Position = UDim2.fromOffset(0, 2),
			ThemeTag = {
				TextColor3 = "Text",
			},
		}),
		Section.Container,
	})

	Creator.AddSignal(Section.Layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if Section.Container.Size ~= UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y) or Section.Root.Size ~= UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 25) then
			Section.Container.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y)
			Section.Root.Size = UDim2.new(1, 0, 0, Section.Layout.AbsoluteContentSize.Y + 25)
		end
	end)

	return Section
end

]=],
    ["Src/Components/Tab"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local Spring = Flipper.Spring.new
local Instant = Flipper.Instant.new
local Components = Root.Components

local TabModule = {
	Window = nil,
	Tabs = {},
	Containers = {},
	SelectedTab = 0,
	TabCount = 0,
}

function TabModule:Init(Window)
	TabModule.Window = Window
	return TabModule
end

function TabModule:GetCurrentTabPos()
	local TabHolderPos = TabModule.Window.TabHolder.AbsolutePosition.Y
	local TabPos = TabModule.Tabs[TabModule.SelectedTab].Frame.AbsolutePosition.Y

	return TabPos - TabHolderPos
end

function TabModule:New(Title, Icon, Parent)
	local Library = require(Root)
	local Window = TabModule.Window
	local Elements = Library.Elements

	TabModule.TabCount = TabModule.TabCount + 1
	local TabIndex = TabModule.TabCount

	local Tab = {
		Selected = false,
		Name = Title,
		Type = "Tab",
	}

	Icon = Icon:find("^rbxasset[://|id://]") == nil and Library.Utilities:GetIcon(Icon) or {
		Image = Icon,
		ImageRectOffset = Vector2.zero,
		ImageRectSize = Vector2.zero
	}

	Tab.Frame = New("TextButton", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = "Tab",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		}),
		New("TextLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = Icon ~= nil and UDim2.new(0, 30, 0.5, 0) or UDim2.new(0, 12, 0.5, 0),
			Text = Title,
			RichText = true,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextTransparency = 0,
			FontFace = Font.new(
				"rbxasset://fonts/families/GothamSSm.json",
				Enum.FontWeight.Regular,
				Enum.FontStyle.Normal
			),
			TextSize = 12,
			TextXAlignment = "Left",
			TextYAlignment = "Center",
			Size = UDim2.new(1, -12, 1, 0),
			BackgroundTransparency = 1,
			ThemeTag = {
				TextColor3 = "Text",
			},
		}),
		New("ImageLabel", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.fromOffset(16, 16),
			Position = UDim2.new(0, 8, 0.5, 0),
			BackgroundTransparency = 1,
			ImageRectOffset = Icon and Icon.ImageRectOffset or Vector2.zero,
			ImageRectSize = Icon and Icon.ImageRectSize or Vector2.zero,
			Image = Icon and Icon.Image or nil,
			ThemeTag = {
				ImageColor3 = "Text",
			},
		}),
	})

	local ContainerLayout = New("UIListLayout", {
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})

	Tab.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = Window.ContainerHolder,
		Visible = false,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225",
		ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
		ScrollBarImageTransparency = 0.95,
		ScrollBarThickness = 3,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		ContainerLayout,
		New("UIPadding", {
			PaddingRight = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 1),
			PaddingTop = UDim.new(0, 1),
			PaddingBottom = UDim.new(0, 1),
		}),
	})

	Creator.AddSignal(ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if Tab.ContainerFrame.CanvasSize ~= UDim2.fromOffset(0, ContainerLayout.AbsoluteContentSize.Y + 2) then
			Tab.ContainerFrame.CanvasSize = UDim2.fromOffset(0, ContainerLayout.AbsoluteContentSize.Y + 2)
		end
	end)

	Tab.Motor, Tab.SetTransparency = Creator.SpringMotor(1, Tab.Frame, "BackgroundTransparency")

	Creator.AddSignal(Tab.Frame.MouseEnter, function()
		Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
	end)
	Creator.AddSignal(Tab.Frame.MouseLeave, function()
		Tab.SetTransparency(Tab.Selected and 0.89 or 1)
	end)
	Creator.AddSignal(Tab.Frame.MouseButton1Down, function()
		Tab.SetTransparency(0.92)
	end)
	Creator.AddSignal(Tab.Frame.MouseButton1Up, function()
		Tab.SetTransparency(Tab.Selected and 0.85 or 0.89)
	end)
	Creator.AddSignal(Tab.Frame.MouseButton1Click, function()
		TabModule:SelectTab(TabIndex)
	end)

	TabModule.Containers[TabIndex] = Tab.ContainerFrame
	TabModule.Tabs[TabIndex] = Tab

	Tab.Container = Tab.ContainerFrame
	Tab.ScrollFrame = Tab.Container

	function Tab:Section(SectionTitle)
		local Section = { 
			Type = "Section" 
		}

		local SectionFrame = require(Components.Section)(SectionTitle, Tab.Container)
		Section.Container = SectionFrame.Container
		Section.ScrollFrame = Tab.Container

		setmetatable(Section, Elements)
		return Section
	end

	Tab.CreateSection = Tab.Section
	Tab.AddSection = Tab.Section

	setmetatable(Tab, Elements)
	return Tab
end

function TabModule:SelectTab(Tab)
	local Window = TabModule.Window

	TabModule.SelectedTab = Tab

	for _, TabObject in next, TabModule.Tabs do
		TabObject.SetTransparency(1)
		TabObject.Selected = false
	end

	TabModule.Tabs[Tab].SetTransparency(0.89)
	TabModule.Tabs[Tab].Selected = true

	Window.TabDisplay.Text = TabModule.Tabs[Tab].Name
	Window.SelectorPosMotor:setGoal(Spring(TabModule:GetCurrentTabPos(), { frequency = 6 }))

	task.spawn(function()
		Window.ContainerHolder.Parent = Window.ContainerAnim

		Window.ContainerPosMotor:setGoal(Spring(15, { frequency = 10 }))
		Window.ContainerBackMotor:setGoal(Spring(1, { frequency = 10 }))

		task.wait(0.12)

		for _, Container in next, TabModule.Containers do
			Container.Visible = false
		end

		TabModule.Containers[Tab].Visible = true
		Window.ContainerPosMotor:setGoal(Spring(0, { frequency = 5 }))
		Window.ContainerBackMotor:setGoal(Spring(0, { frequency = 8 }))

		task.wait(0.12)

		Window.ContainerHolder.Parent = Window.ContainerCanvas
	end)
end

return TabModule

]=],
    ["Src/Components/Textbox"] = [=[
local TextService = game:GetService("TextService")
local Root = __BUNDLE_ROOT.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Modules.Creator)
local New = Creator.New

return function(Parent, Acrylic)
	local Textbox = {}

	Acrylic = Acrylic or false

	Textbox.Input = New("TextBox", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(10, 0),
		ThemeTag = {
			TextColor3 = "Text",
			PlaceholderColor3 = "SubText",
		},
	})

	Textbox.Container = New("Frame", {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.new(0, 6, 0, 0),
		Size = UDim2.new(1, -12, 1, 0),
	}, {
		Textbox.Input,
	})

	Textbox.Indicator = New("Frame", {
		Size = UDim2.new(1, -4, 0, 1),
		Position = UDim2.new(0, 2, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = Acrylic and 0.5 or 0,
		ThemeTag = {
			BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine",
		},
	})

	Textbox.Frame = New("Frame", {
		Size = UDim2.new(0, 0, 0, 30),
		BackgroundTransparency = Acrylic and 0.9 or 0,
		Parent = Parent,
		ThemeTag = {
			BackgroundColor3 = Acrylic and "Input" or "DialogInput",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Transparency = Acrylic and 0.5 or 0.65,
			ThemeTag = {
				Color = Acrylic and "InElementBorder" or "DialogButtonBorder",
			},
		}),
		Textbox.Indicator,
		Textbox.Container,
	})

	local function Update()
		local PADDING = 2
		local Reveal = Textbox.Container.AbsoluteSize.X

		if not Textbox.Input:IsFocused() or Textbox.Input.TextBounds.X <= Reveal - 2 * PADDING then
			Textbox.Input.Position = UDim2.new(0, PADDING, 0, 0)
		else
			local Cursor = Textbox.Input.CursorPosition
			if Cursor ~= -1 then
				local subtext = string.sub(Textbox.Input.Text, 1, Cursor - 1)
				local width = TextService:GetTextSize(
					subtext,
					Textbox.Input.TextSize,
					Textbox.Input.Font,
					Vector2.new(math.huge, math.huge)
				).X

				local CurrentCursorPos = Textbox.Input.Position.X.Offset + width
				if CurrentCursorPos < PADDING then
					Textbox.Input.Position = UDim2.fromOffset(PADDING - width, 0)
				elseif CurrentCursorPos > Reveal - PADDING - 1 then
					Textbox.Input.Position = UDim2.fromOffset(Reveal - width - PADDING - 1, 0)
				end
			end
		end
	end

	task.spawn(Update)

	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("Text"), Update)
	Creator.AddSignal(Textbox.Input:GetPropertyChangedSignal("CursorPosition"), Update)

	Creator.AddSignal(Textbox.Input.Focused, function()
		Update()
		Textbox.Indicator.Size = UDim2.new(1, -2, 0, 2)
		Textbox.Indicator.Position = UDim2.new(0, 1, 1, 0)
		Textbox.Indicator.BackgroundTransparency = 0
		Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "InputFocused" or "DialogHolder" })
		Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = "Accent" })
	end)

	Creator.AddSignal(Textbox.Input.FocusLost, function()
		Update()
		Textbox.Indicator.Size = UDim2.new(1, -4, 0, 1)
		Textbox.Indicator.Position = UDim2.new(0, 2, 1, 0)
		Textbox.Indicator.BackgroundTransparency = 0.5
		Creator.OverrideTag(Textbox.Frame, { BackgroundColor3 = Acrylic and "Input" or "DialogInput" })
		Creator.OverrideTag(Textbox.Indicator, { BackgroundColor3 = Acrylic and "InputIndicator" or "DialogInputLine" })
	end)

	return Textbox
end

]=],
    ["Src/Components/TitleBar"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local AddSignal = Creator.AddSignal

return function(Config)
	local TitleBar = {}

	local Library = require(Root)

	local function BarButton(Icon, Pos, Parent, Debounce, Callback)
		local Button = {
			Callback = Callback or function() end,
			OnDebounce = false
		}

		Button.Frame = New("TextButton", {
			Size = UDim2.new(0, 34, 1, -8),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Parent = Parent,
			Position = Pos,
			Text = "",
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 7),
			}),
			New("ImageLabel", {
				Image = Icon,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Name = "Icon",
				ThemeTag = {
					ImageColor3 = "Text",
				},
			}),
		})

		local Motor, SetTransparency = Creator.SpringMotor(1, Button.Frame, "BackgroundTransparency")

		AddSignal(Button.Frame.MouseEnter, function()
			SetTransparency(0.94)
		end)

		AddSignal(Button.Frame.MouseLeave, function()
			SetTransparency(1, true)
		end)

		AddSignal(Button.Frame.MouseButton1Down, function()
			SetTransparency(0.96)
		end)

		AddSignal(Button.Frame.MouseButton1Up, function()
			SetTransparency(0.94)
		end)

		AddSignal(Button.Frame.MouseButton1Click, function(...)
			if not Button.OnDebounce then
				Button.OnDebounce = true
				task.delay(Debounce, rawset, Button, "OnDebounce", false)
				Button.Callback(...)
			end
		end)

		return Button
	end

	TitleBar.Frame = New("Frame", {
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundTransparency = 1,
		Parent = Config.Parent
	}, {
		New("Frame", {
			BackgroundTransparency = 0.5,
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			ThemeTag = {
				BackgroundColor3 = "TitleBarLine",
			}
		})
	})

	TitleBar.TitleHolder = New("Frame", {
		Size = UDim2.new(1, -16, 1, 0),
		Parent = TitleBar.Frame,
		Position = UDim2.new(0, 16, 0, 0),
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 5),
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		})
	})

	TitleBar.Title = New("TextLabel", {
		RichText = true,
		Text = Config.Title,
		Parent = TitleBar.TitleHolder,
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Regular,
			Enum.FontStyle.Normal
		),
		TextSize = 12,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		}
	})

	TitleBar.SubTitle = New("TextLabel", {
		RichText = true,
		Text = Config.SubTitle,
		Parent = TitleBar.TitleHolder,
		TextTransparency = 0.4,
		FontFace = Font.new(
			"rbxasset://fonts/families/GothamSSm.json",
			Enum.FontWeight.Regular,
			Enum.FontStyle.Normal
		),
		TextSize = 12,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		}
	})

	TitleBar.CloseButton = BarButton(Library.Utilities:GetIcon("Close"), UDim2.new(1, -4, 0, 4), TitleBar.Frame, 0, function()
		Library.CreatedWindow:Dialog{
			Title = "Close",
			Content = "Are you sure you want to unload the interface?",
			Buttons = {
				{
					Title = "Yes",
					Callback = Library.Destroy,
				},
				{
					Title = "No",
				}
			}
		}
	end)

	TitleBar.MaxButton = BarButton(Library.Utilities:GetIcon("Max"), UDim2.new(1, -40, 0, 4), TitleBar.Frame, 0, function()
		Config.Window.Maximize(not Config.Window.Maximized)
	end)

	TitleBar.MinButton = BarButton(Library.Utilities:GetIcon("Min"), UDim2.new(1, -80, 0, 4), TitleBar.Frame, 0, function()
		Config.Window:Minimize()
	end)

	-- Searchbox would take alot of time
	--[[ 
	TitleBar.SearchBox = New("TextBox", {
		AnchorPoint = Vector2.new(1, .5),
		Parent = TitleBar.Frame,
		Size = UDim2.fromScale(0, .65),
		Position = UDim2.new(1, -160, .5, 0),
		BackgroundTransparency = 1,
		ClearTextOnFocus = true,
		ThemeTag = {
			TextColor3 = "Text"
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(.5, 0)
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Thickness = 0,
			Transparency = 1,
			ThemeTag = {
				Color = "AcrylicBorder"
			}
		})
	})

	--local SizeMotor, SetSize = Creator.SpringMotor(UDim2.fromScale(0, .65), TitleBar.SearchBox, "Size") -- No Motors for Sizes? 😢
	--local ThicknessMotor, SetThickness = Creator.SpringMotor(1, TitleBar.SearchBox.UIStroke, "Thickness")
	--local TransparencyMotor, SetTransparency = Creator.SpringMotor(1, TitleBar.SearchBox.UIStroke, "Transparency") -- never mind motors are like way to fast, idk how they work

	local SearchButtonIcon = Library.Utilities:GetIcon("search")
	local SearchButton = BarButton(SearchButtonIcon.Image, UDim2.new(1, -120, 0, 4), TitleBar.Frame, 2/3, function()
		if TitleBar.IsSearchbarOpen then
			TitleBar.SearchBox:TweenSize(UDim2.fromScale(0, .65), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .5, true)
			TweenService:Create(TitleBar.SearchBox.UIStroke, TweenInfo.new(2/3), {Transparency = 1, Thickness = 0}):Play()

			TitleBar.IsSearchbarOpen = false
		else
			TitleBar.SearchBox:TweenSize(
				UDim2.new(0, TitleBar.Frame.AbsoluteSize.X 
					- (
						TitleBar.Title.TextBounds.X 
						+ TitleBar.SubTitle.TextBounds.X 
						+ 195
				),
			.65, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, .5, true)
			TweenService:Create(TitleBar.SearchBox.UIStroke, TweenInfo.new(2/3), {Transparency = 0, Thickness = 1.5}):Play()

			TitleBar.SearchBox:CaptureFocus()
			TitleBar.IsSearchbarOpen = true
		end
	end)

	SearchButton.Frame.Icon.ImageRectSize = SearchButtonIcon.ImageRectSize
	SearchButton.Frame.Icon.ImageRectOffset = SearchButtonIcon.ImageRectOffset

	TitleBar.SearchButton = SearchButton

	AddSignal(TitleBar.Frame:GetPropertyChangedSignal("AbsoluteSize"), function()
		if TitleBar.IsSearchbarOpen then
			TitleBar.SearchBox:TweenSize(
				UDim2.new(0, TitleBar.Frame.AbsoluteSize.X 
					- (
						TitleBar.Title.TextBounds.X 
						+ TitleBar.SubTitle.TextBounds.X 
						+ 195
				),
			.65, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0, true)
		end
	end)
	]]

	return TitleBar
end

]=],
    ["Src/Components/Window"] = [=[
-- a wise man once said: "i will rewrite this someday"

local Root = __BUNDLE_ROOT.Parent.Parent
local Flipper = require(Root.Packages.Flipper)
local Creator = require(Root.Modules.Creator)
local Acrylic = require(Root.Modules.Acrylic)
local Signal = require(Root.Packages.Signal)
local Assets = require(script.Parent.Assets)
local Components = script.Parent

local Library = require(Root)

local UserInputService = Library.Utilities:Clone(game:GetService("UserInputService"))
local Mouse = Library.Utilities:Clone(game:GetService("Players")).LocalPlayer:GetMouse()
local Camera = Library.Utilities:Clone(game:GetService("Workspace")).CurrentCamera

local Spring = Flipper.Spring.new
local Instant = Flipper.Instant.new
local New = Creator.New

return function(Config)
	assert(typeof(Config.Mobile) == "table", "Config key 'Mobile' must be a table!")
	assert(typeof(Config.Mobile.GetIcon) == "function", "Mobile Config key 'GetIcon' must be a function!")
	assert(typeof(Config.Mobile.Size) == "UDim2", "Mobile Config key 'Size' must be a UDim2!")

	local Window = {
		Minimized = false,
		OnMinimized = Signal.new(),
		PostMinimized = Signal.new(),
		Maximized = false,
		OnMaximized = Signal.new(),
		PostMaximized = Signal.new(),
		Size = Config.Size,
		MinSize = Config.MinSize,
		CurrentPos = 0,
		TabWidth = 0,
		Position = UDim2.fromOffset(
			Camera.ViewportSize.X / 2 - Config.Size.X.Offset / 2,
			Camera.ViewportSize.Y / 2 - Config.Size.Y.Offset / 2
		),
	}

	local Dragging, DragInput, MousePos, StartPos = false
	local Resizing, ResizePos = false
	local MinimizeNotif = false
	local IsDraggingHideButton, DragInputHideButton, DragStart, DragStartPos = false

	Window.AcrylicPaint = Acrylic.AcrylicPaint()
	Window.TabWidth = Config.TabWidth

	local Selector = New("Frame", {
		Size = UDim2.fromOffset(4, 0),
		BackgroundColor3 = Color3.fromRGB(76, 194, 255),
		Position = UDim2.fromOffset(0, 17),
		AnchorPoint = Vector2.new(0, 0.5),
		ThemeTag = {
			BackgroundColor3 = "Accent",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 2),
		}),
	})

	local ResizeStartFrame = New("Frame", {
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -20, 1, -20),
	})

	Window.TabHolder = New("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarImageTransparency = 1,
		ScrollBarThickness = 0,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, 4),
		}),
	})

	local TabFrame = New("Frame", {
		Size = UDim2.new(0, Window.TabWidth, 1, -66),
		Position = UDim2.new(0, 12, 0, 54),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, {
		Window.TabHolder,
		Selector,
	})

	Window.TabDisplay = New("TextLabel", {
		RichText = true,
		Text = "Tab",
		TextTransparency = 0,
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
		TextSize = 28,
		TextXAlignment = "Left",
		TextYAlignment = "Center",
		Size = UDim2.new(1, -16, 0, 28),
		Position = UDim2.fromOffset(Window.TabWidth + 26, 56),
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	Window.ContainerHolder = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})

	Window.ContainerAnim = New("CanvasGroup", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})

	Window.ContainerCanvas = New("Frame", {
		Size = UDim2.new(1, -Window.TabWidth - 32, 1, -102),
		Position = UDim2.fromOffset(Window.TabWidth + 26, 90),
		BackgroundTransparency = 1,
	}, {
		Window.ContainerAnim,
		Window.ContainerHolder
	})

	Window.Root = New("Frame", {
		BackgroundTransparency = 1,
		Size = Window.Size,
		Position = Window.Position,
		Parent = Config.Parent,
	}, {
		Window.AcrylicPaint.Frame,
		Window.TabDisplay,
		Window.ContainerCanvas,
		TabFrame,
		ResizeStartFrame,
	})

	Window.HideButton = New("ImageButton", {
		Visible = Library.Utilities:GetOS() == "Mobile",
		Size = Config.Mobile.Size,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -Config.Mobile.Size.X.Offset - 25, 0.5, -Config.Mobile.Size.Y.Offset / 2),
		Parent = Config.Parent,
		Image = Config.Mobile.GetIcon(false).Image,
		ImageRectOffset = Config.Mobile.GetIcon(false).ImageRectOffset,
		ImageRectSize = Config.Mobile.GetIcon(false).ImageRectSize
	})

	Window.TitleBar = require(script.Parent.TitleBar)({
		Title = Config.Title,
		SubTitle = Config.SubTitle,
		Parent = Window.Root,
		Window = Window,
	})

	if Library.UseAcrylic then
		Window.AcrylicPaint.AddParent(Window.Root)
	end

	local SizeMotor = Flipper.GroupMotor.new({
		X = Window.Size.X.Offset,
		Y = Window.Size.Y.Offset,
	})

	local PosMotor = Flipper.GroupMotor.new({
		X = Window.Position.X.Offset,
		Y = Window.Position.Y.Offset,
	})

	Window.SelectorPosMotor = Flipper.SingleMotor.new(17)
	Window.SelectorSizeMotor = Flipper.SingleMotor.new(0)
	Window.ContainerBackMotor = Flipper.SingleMotor.new(0)
	Window.ContainerPosMotor = Flipper.SingleMotor.new(94)

	SizeMotor:onStep(function(values)
		Window.Root.Size = UDim2.new(0, values.X, 0, values.Y)
	end)

	PosMotor:onStep(function(values)
		Window.Root.Position = UDim2.new(0, values.X, 0, values.Y)
	end)

	local LastValue = 0
	local LastTime = 0
	Window.SelectorPosMotor:onStep(function(Value)
		Selector.Position = UDim2.new(0, 0, 0, Value + 17)
		local Now = tick()
		local DeltaTime = Now - LastTime

		if LastValue ~= nil then
			Window.SelectorSizeMotor:setGoal(Spring((math.abs(Value - LastValue) / (DeltaTime * 60)) + 16))
			LastValue = Value
		end
		LastTime = Now
	end)

	Window.SelectorSizeMotor:onStep(function(Value)
		Selector.Size = UDim2.new(0, 4, 0, Value)
	end)

	Window.ContainerBackMotor:onStep(function(Value)
		Window.ContainerAnim.GroupTransparency = Value
	end)

	Window.ContainerPosMotor:onStep(function(Value)
		Window.ContainerAnim.Position = UDim2.fromOffset(0, Value)
	end)

	local OldSizeX
	local OldSizeY
	Window.Maximize = function(Value, NoPos, Instant)
		Window.OnMaximized:Fire(tick())

		Window.Maximized = Value
		Window.TitleBar.MaxButton.Frame.Icon.Image = Value and Assets.Restore or Assets.Max

		if Value then
			OldSizeX = Window.Size.X.Offset
			OldSizeY = Window.Size.Y.Offset
		end
		local SizeX = Value and Camera.ViewportSize.X or OldSizeX
		local SizeY = Value and Camera.ViewportSize.Y or OldSizeY
		SizeMotor:setGoal({
			X = Flipper[Instant and "Instant" or "Spring"].new(SizeX, { frequency = 6 }),
			Y = Flipper[Instant and "Instant" or "Spring"].new(SizeY, { frequency = 6 }),
		})
		Window.Size = UDim2.fromOffset(SizeX, SizeY)

		if not NoPos then
			PosMotor:setGoal({
				X = Spring(Value and 0 or Window.Position.X.Offset, { frequency = 6 }),
				Y = Spring(Value and 0 or Window.Position.Y.Offset, { frequency = 6 }),
			})
		end

		Window.PostMaximized:Fire(tick())
	end

	Creator.AddSignal(Window.TitleBar.Frame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
			MousePos = Input.Position
			StartPos = Window.Root.Position

			if Window.Maximized then
				StartPos = UDim2.fromOffset(
					Mouse.X - (Mouse.X * ((OldSizeX - 100) / Window.Root.AbsoluteSize.X)),
					Mouse.Y - (Mouse.Y * (OldSizeY / Window.Root.AbsoluteSize.Y))
				)
			end

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	Creator.AddSignal(Window.TitleBar.Frame.InputChanged, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragInput = Input
		end
	end)

	Creator.AddSignal(ResizeStartFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Resizing = true
			ResizePos = Input.Position
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if Input == DragInput and Dragging then
			local Delta = Input.Position - MousePos
			Window.Position = UDim2.fromOffset(StartPos.X.Offset + Delta.X, StartPos.Y.Offset + Delta.Y)
			PosMotor:setGoal({
				X = Instant(Window.Position.X.Offset),
				Y = Instant(Window.Position.Y.Offset),
			})

			if Window.Maximized then
				Window.Maximize(false, true, true)
			end
		end

		if
			(Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
			and Resizing
		then
			local Delta = Input.Position - ResizePos
			local StartSize = Window.Size

			local TargetSize = Vector3.new(StartSize.X.Offset, StartSize.Y.Offset, 0) + Vector3.new(1, 1, 0) * Delta
			local TargetSizeClamped =
				Vector2.new(math.clamp(TargetSize.X, Window.MinSize.X, 2048), math.clamp(TargetSize.Y, Window.MinSize.Y, 2048))

			SizeMotor:setGoal({
				X = Flipper.Instant.new(TargetSizeClamped.X),
				Y = Flipper.Instant.new(TargetSizeClamped.Y),
			})
		end
	end)

	Creator.AddSignal(UserInputService.InputEnded, function(Input)
		if Resizing == true or Input.UserInputType == Enum.UserInputType.Touch then
			Resizing = false
			Window.Size = UDim2.fromOffset(SizeMotor:getValue().X, SizeMotor:getValue().Y)
		end
	end)

	Creator.AddSignal(Window.TabHolder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
		if Window.TabHolder.CanvasSize ~= UDim2.fromOffset(0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y) then
			Window.TabHolder.CanvasSize = UDim2.fromOffset(0, Window.TabHolder.UIListLayout.AbsoluteContentSize.Y)
		end
	end)

	function Window:Minimize()
		Window.Minimized = not Window.Minimized
		Window.Root.Visible = not Window.Minimized

		Window.OnMinimized:Fire(tick(), Window.Root.Visible)

		if not MinimizeNotif then
			local Key = Library.MinimizeKeybind and Library.MinimizeKeybind.Value or typeof(Library.MinimizeKey) == "string" and Library.MinimizeKey or Library.MinimizeKey.Name

			MinimizeNotif = true

			Library:Notify({
				Title = "Interface",
				Content = `Press {Library.Utilities:Prettify(Key)} to toggle the interface.`,
				Duration = 6
			})
		end
		if Library.Utilities:GetOS() == "Mobile" then
			local Icon = Config.Mobile.GetIcon(Window.Minimized)
			Window.HideButton.Image = Icon.Image
			Window.HideButton.ImageRectOffset = Icon.ImageRectOffset
			Window.HideButton.ImageRectSize = Icon.ImageRectSiz
		end
		Window.PostMinimized:Fire(tick(), Window.Root.Visible)
	end

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			type(Library.MinimizeKeybind) == "table"
			and Library.MinimizeKeybind.Type == "Keybind"
			and not UserInputService:GetFocusedTextBox()
		then
			if Input.KeyCode.Name == Library.MinimizeKeybind.Value or Input.KeyCode.Name == Library.MinimizeKeybind.Value.Name then
				Window:Minimize()
			end
		elseif (Input.KeyCode == Library.MinimizeKey or Input.KeyCode.Name == Library.MinimizeKey) and not UserInputService:GetFocusedTextBox() then
			Window:Minimize()
		end
	end)

	Creator.AddSignal(Window.HideButton.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			IsDraggingHideButton = true
			DragStart = Input.Position
			DragStartPos = Window.HideButton.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					IsDraggingHideButton = false
				end
			end)
		end
	end)

	Creator.AddSignal(Window.HideButton.InputChanged, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			DragInputHideButton = Input
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if Input == DragInputHideButton and IsDraggingHideButton then
		        local delta = Input.Position - DragStart
			Window.HideButton.Position = UDim2.new(DragStartPos.X.Scale, DragStartPos.X.Offset + delta.X, DragStartPos.Y.Scale, DragStartPos.Y.Offset + delta.Y)
		end
	end)

	if Library.Utilities:GetOS() == "Mobile" then
		Creator.AddSignal(Window.HideButton.TouchTap, function()
			Window.Minimized = not Window.Minimized
       			Window.Root.Visible = not Window.Minimized
			local Icon = Config.Mobile.GetIcon(Window.Minimized)
			Window.HideButton.Image = Icon.Image
			Window.HideButton.ImageRectOffset = Icon.ImageRectOffset
			Window.HideButton.ImageRectSize = Icon.ImageRectSize
		end)
	else
		Creator.AddSignal(Window.HideButton.MouseButton1Click, function()
			Window.Minimized = not Window.Minimized
       			Window.Root.Visible = not Window.Minimized
		end)	
	end

	function Window:Destroy()
		if Library.UseAcrylic then
			Window.AcrylicPaint.Model:Destroy()
		end
		Window.Root:Destroy()
	end

	local DialogModule = require(Components.Dialog):Init(Window)
	function Window:Dialog(Config)
		local Dialog = DialogModule:Create()
		Dialog.Title.Text = Config.Title

		local Content = New("TextLabel", {
			FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
			Text = Config.Content,
			TextColor3 = Color3.fromRGB(240, 240, 240),
			TextSize = 14,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Size = UDim2.new(1, -40, 1, 0),
			Position = UDim2.fromOffset(20, 60),
			BackgroundTransparency = 1,
			Parent = Dialog.Root,
			ClipsDescendants = false,
			ThemeTag = {
				TextColor3 = "Text",
			},
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(300, 165),
			MaxSize = Vector2.new(620, math.huge),
			Parent = Dialog.Root,
		})

		Dialog.Root.Size = UDim2.fromOffset(Content.TextBounds.X + 40, 165)
		if Content.TextBounds.X + 40 > Window.Size.X.Offset - 120 then
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, 165)
			Content.TextWrapped = true
			Dialog.Root.Size = UDim2.fromOffset(Window.Size.X.Offset - 120, Content.TextBounds.Y + 150)
		end

		for _, Button in next, Config.Buttons do
			Dialog:Button(Button.Title, Button.Callback)
		end

		Dialog:Open()

		if Config.Yield then
			Dialog.Closed:Wait()
		end

		return Dialog
	end

	local TabModule = require(Components.Tab):Init(Window)

	function Window:Tab(TabConfig)
		return TabModule:New(TabConfig.Title, TabConfig.Icon, Window.TabHolder)
	end

	function Window:AddTab(TabConfig)
		return Window:Tab(TabConfig)
	end

	function Window:CreateTab(TabConfig)
		return Window:Tab(TabConfig)
	end

	function Window:SelectTab(Tab)
		TabModule:SelectTab(Tab)
	end

	Creator.AddSignal(Window.TabHolder:GetPropertyChangedSignal("CanvasPosition"), function()
		LastValue = TabModule:GetCurrentTabPos() + 16
		LastTime = 0
		Window.SelectorPosMotor:setGoal(Instant(TabModule:GetCurrentTabPos()))
	end)

	return Window
end

]=],
    ["Src/Elements/Button"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Button"

function Element:New(Config)
	assert(Config.Title, "Button - Missing Title")
	Config.Callback = Config.Callback or function() end

	local ButtonFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	local ButtonIco = New("ImageLabel", {
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 1,
		Parent = ButtonFrame.Frame,
		ThemeTag = {
			ImageColor3 = "Text",
		}
	}) :: ImageLabel

	self.Library.Utilities.Icons:SetIcon(ButtonIco, "chevron-right")

	Creator.AddSignal(ButtonFrame.Frame.MouseButton1Click, function()
		if typeof(Config.Callback) == "function" then
			self.Library:SafeCallback(Config.Callback, Config.Value)
		end
	end)

	ButtonFrame.Instance = ButtonFrame

	return ButtonFrame
end

return Element

]=],
    ["Src/Elements/Colorpicker"] = [=[
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Colorpicker"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Title, "Colorpicker - Missing Title")
	assert(Config.Default, "AddColorPicker: Missing default value.")

	local Colorpicker = {
		Value = Config.Default or Config.Value,
		Transparency = Config.Transparency or 0,
		UpdateOnChange = Config.UpdateOnChange or Config.UpdateWhileSliding or false,
		Type = "Colorpicker",
		Title = type(Config.Title) == "string" and Config.Title or "Colorpicker",
		Callback = Config.Callback or function(Color) end,
	}

	function Colorpicker:SetHSVFromRGB(Color)
		local H, S, V = Color3.toHSV(Color)
		Colorpicker.Hue = H
		Colorpicker.Sat = S
		Colorpicker.Vib = V
	end

	Colorpicker:SetHSVFromRGB(Colorpicker.Value)

	local ColorpickerFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)

	Colorpicker.SetTitle = ColorpickerFrame.SetTitle
	Colorpicker.SetDesc = ColorpickerFrame.SetDesc

	local DisplayFrameColor = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Colorpicker.Value,
		Parent = ColorpickerFrame.Frame,
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
	}) :: Frame

	local DisplayFrame = New("ImageLabel", {
		Size = UDim2.fromOffset(26, 26),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Parent = ColorpickerFrame.Frame,
		Image = "http://www.roblox.com/asset/?id=14204231522",
		ImageTransparency = 0.45,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = UDim2.fromOffset(40, 40),
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 4),
		}),
		DisplayFrameColor,
	}) :: ImageLabel

	local function CreateColorDialog()
		local Dialog = require(Components.Dialog):Create()
		Dialog.Title.Text = Colorpicker.Title
		Dialog.Root.Size = UDim2.fromOffset(430, 330)

		local Hue, Sat, Vib = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib
		local Transparency = Colorpicker.Transparency

		local OrigHue, OrigSat, OrigVib, OrigTransparency = Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib, Colorpicker.Transparency

		local function CreateInput()
			local Box = require(Components.Textbox)()
			Box.Frame.Parent = Dialog.Root
			Box.Frame.Size = UDim2.new(0, 90, 0, 32)

			return Box
		end

		local function CreateInputLabel(Text, Pos): TextLabel
			return New("TextLabel", {
				FontFace = Font.new(
					"rbxasset://fonts/families/GothamSSm.json",
					Enum.FontWeight.Medium,
					Enum.FontStyle.Normal
				),
				Text = Text,
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.new(1, 0, 0, 32),
				Position = Pos,
				BackgroundTransparency = 1,
				Parent = Dialog.Root,
				ThemeTag = {
					TextColor3 = "Text",
				},
			}) :: TextLabel
		end

		local function GetRGB()
			local Value = Color3.fromHSV(Hue, Sat, Vib)
			return { R = math.floor(Value.R * 255), G = math.floor(Value.G * 255), B = math.floor(Value.B * 255) }
		end

		local SatCursor = New("ImageLabel", {
			Size = UDim2.new(0, 18, 0, 18),
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=4805639000",
		}) :: ImageLabel

		local SatVibMap = New("ImageLabel", {
			Size = UDim2.fromOffset(180, 160),
			Position = UDim2.fromOffset(20, 55),
			Image = "rbxassetid://4155801252",
			BackgroundColor3 = Colorpicker.Value,
			BackgroundTransparency = 0,
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			SatCursor,
		}) :: ImageLabel

		local OldColorFrame = New("Frame", {
			BackgroundColor3 = Colorpicker.Value,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = Colorpicker.Transparency,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		}) :: Frame

		local OldColorFrameChecker = New("ImageLabel", {
			Image = "http://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(112, 220),
			Size = UDim2.fromOffset(88, 24),
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				Thickness = 2,
				Transparency = 0.75,
			}),
			OldColorFrame,
		}) :: ImageLabel

		local DialogDisplayFrame = New("Frame", {
			BackgroundColor3 = Colorpicker.Value,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 0,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
		}) :: Frame

		local DialogDisplayFrameChecker = New("ImageLabel", {
			Image = "http://www.roblox.com/asset/?id=14204231522",
			ImageTransparency = 0.45,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.fromOffset(40, 40),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(20, 220),
			Size = UDim2.fromOffset(88, 24),
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 4),
			}),
			New("UIStroke", {
				Thickness = 2,
				Transparency = 0.75,
			}),
			DialogDisplayFrame,
		}) :: ImageLabel

		local SequenceTable = {}

		for Color = 0, 1, 0.1 do
			SequenceTable[#SequenceTable + 1] = ColorSequenceKeypoint.new(Color, Color3.fromHSV(Color, 1, 1))
		end

		local HueSliderGradient = New("UIGradient", {
			Color = ColorSequence.new(SequenceTable),
			Rotation = 90,
		}) :: UIGradient

		local HueDragHolder = New("Frame", {
			Size = UDim2.new(1, 0, 1, -10),
			Position = UDim2.fromOffset(0, 5),
			BackgroundTransparency = 1,
		}) :: Frame

		local HueDrag = New("ImageLabel", {
			Size = UDim2.fromOffset(14, 14),
			Image = "http://www.roblox.com/asset/?id=12266946128",
			Parent = HueDragHolder,
			ThemeTag = {
				ImageColor3 = "DialogInput",
			},
		}) :: ImageLabel

		local HueSlider = New("Frame", {
			Size = UDim2.fromOffset(12, 190),
			Position = UDim2.fromOffset(210, 55),
			Parent = Dialog.Root,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
			HueSliderGradient,
			HueDragHolder,
		}) :: Frame

		local HexInput = CreateInput()
		HexInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 55)
		CreateInputLabel("Hex", UDim2.fromOffset(Config.Transparency and 360 or 340, 55))

		local RedInput = CreateInput()
		RedInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 95)
		CreateInputLabel("Red", UDim2.fromOffset(Config.Transparency and 360 or 340, 95))

		local GreenInput = CreateInput()
		GreenInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 135)
		CreateInputLabel("Green", UDim2.fromOffset(Config.Transparency and 360 or 340, 135))

		local BlueInput = CreateInput()
		BlueInput.Frame.Position = UDim2.fromOffset(Config.Transparency and 260 or 240, 175)
		CreateInputLabel("Blue", UDim2.fromOffset(Config.Transparency and 360 or 340, 175))

		local AlphaInput
		if Config.Transparency then
			AlphaInput = CreateInput()
			AlphaInput.Frame.Position = UDim2.fromOffset(260, 215)
			CreateInputLabel("Alpha", UDim2.fromOffset(360, 215))
		end

		local TransparencySlider, TransparencyDrag, TransparencyColor
		if Config.Transparency then
			local TransparencyDragHolder = New("Frame", {
				Size = UDim2.new(1, 0, 1, -10),
				Position = UDim2.fromOffset(0, 5),
				BackgroundTransparency = 1,
			}) :: Frame

			TransparencyDrag = New("ImageLabel", {
				Size = UDim2.fromOffset(14, 14),
				Image = "http://www.roblox.com/asset/?id=12266946128",
				Parent = TransparencyDragHolder,
				ThemeTag = {
					ImageColor3 = "DialogInput",
				},
			}) :: ImageLabel

			TransparencyColor = New("Frame", {
				Size = UDim2.fromScale(1, 1),
			}, {
				New("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Rotation = 270,
				}),
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
			}) :: Frame

			TransparencySlider = New("Frame", {
				Size = UDim2.fromOffset(12, 190),
				Position = UDim2.fromOffset(230, 55),
				Parent = Dialog.Root,
				BackgroundTransparency = 1,
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),
				New("ImageLabel", {
					Image = "http://www.roblox.com/asset/?id=14204231522",
					ImageTransparency = 0.45,
					ScaleType = Enum.ScaleType.Tile,
					TileSize = UDim2.fromOffset(40, 40),
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Parent = Dialog.Root,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
				TransparencyColor,
				TransparencyDragHolder,
			}) :: Frame
		end

		local function Display()
			SatVibMap.BackgroundColor3 = Color3.fromHSV(Hue, 1, 1)
			HueDrag.Position = UDim2.new(0, -1, Hue, -6)
			SatCursor.Position = UDim2.new(Sat, 0, 1 - Vib, 0)
			DialogDisplayFrame.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)

			HexInput.Input.Text = `#{Color3.fromHSV(Hue, Sat, Vib):ToHex()}`
			RedInput.Input.Text = GetRGB()["R"]
			GreenInput.Input.Text = GetRGB()["G"]
			BlueInput.Input.Text = GetRGB()["B"]

			if Config.Transparency then
				TransparencyColor.BackgroundColor3 = Color3.fromHSV(Hue, Sat, Vib)
				DialogDisplayFrame.BackgroundTransparency = Transparency
				TransparencyDrag.Position = UDim2.new(0, -1, 1 - Transparency, -6)
				AlphaInput.Input.Text = `{Library.Utilities:Round((1 - Transparency) * 100, 0)}%`
			end

			if Colorpicker.UpdateOnChange then
				Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency)
			end
		end

		Creator.AddSignal(HexInput.Input.FocusLost, function(Enter)
			if Enter then
				local Success, Result = pcall(Color3.fromHex, HexInput.Input.Text)
				if Success and typeof(Result) == "Color3" then
					Hue, Sat, Vib = Color3.toHSV(Result)
				end
			end
			Display()
		end)

		Creator.AddSignal(RedInput.Input.FocusLost, function(Enter)
			if Enter then
				local CurrentColor = GetRGB()
				local Success, Result = pcall(Color3.fromRGB, RedInput.Input.Text, CurrentColor["G"], CurrentColor["B"])
				if Success and typeof(Result) == "Color3" then
					if tonumber(RedInput.Input.Text) <= 255 then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
			end
			Display()
		end)

		Creator.AddSignal(GreenInput.Input.FocusLost, function(Enter)
			if Enter then
				local CurrentColor = GetRGB()
				local Success, Result =
					pcall(Color3.fromRGB, CurrentColor["R"], GreenInput.Input.Text, CurrentColor["B"])
				if Success and typeof(Result) == "Color3" then
					if tonumber(GreenInput.Input.Text) <= 255 then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
			end
			Display()
		end)

		Creator.AddSignal(BlueInput.Input.FocusLost, function(Enter)
			if Enter then
				local CurrentColor = GetRGB()
				local Success, Result =
					pcall(Color3.fromRGB, CurrentColor["R"], CurrentColor["G"], BlueInput.Input.Text)
				if Success and typeof(Result) == "Color3" then
					if tonumber(BlueInput.Input.Text) <= 255 then
						Hue, Sat, Vib = Color3.toHSV(Result)
					end
				end
			end
			Display()
		end)

		if Config.Transparency then
			Creator.AddSignal(AlphaInput.Input.FocusLost, function(Enter)
				if Enter then
					pcall(function()
						local Value = tonumber(AlphaInput.Input.Text)
						Transparency = Value >= 0 and Value <= 100 and 1 - Value * 0.01 or Transparency
					end)
				end
				Display()
			end)
		end

		local function UpdateSatVib()
			local MinX = SatVibMap.AbsolutePosition.X
			local MaxX = MinX + SatVibMap.AbsoluteSize.X
			local MouseX = math.clamp(Mouse.X, MinX, MaxX)

			local MinY = SatVibMap.AbsolutePosition.Y
			local MaxY = MinY + SatVibMap.AbsoluteSize.Y
			local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

			Sat = (MouseX - MinX) / (MaxX - MinX)
			Vib = 1 - ((MouseY - MinY) / (MaxY - MinY))
			Display()
		end

		local function UpdateHue()
			local MinY = HueSlider.AbsolutePosition.Y
			local MaxY = MinY + HueSlider.AbsoluteSize.Y
			local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

			Hue = ((MouseY - MinY) / (MaxY - MinY))
			Display()
		end

		local function UpdateTransparency()
			local MinY = TransparencySlider.AbsolutePosition.Y
			local MaxY = MinY + TransparencySlider.AbsoluteSize.Y
			local MouseY = math.clamp(Mouse.Y, MinY, MaxY)

			Transparency = 1 - ((MouseY - MinY) / (MaxY - MinY))
			Display()
		end

		local MouseMoveConnection
		Creator.AddSignal(SatVibMap.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 
				or Input.UserInputType == Enum.UserInputType.Touch then

				MouseMoveConnection = Mouse.Move:Connect(UpdateSatVib)
				UpdateSatVib()
			end
		end)

		Creator.AddSignal(SatVibMap.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then

				if MouseMoveConnection then
					MouseMoveConnection:Disconnect()
					MouseMoveConnection = nil
				end
			end
		end)

		Creator.AddSignal(HueSlider.InputBegan, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then

				MouseMoveConnection = Mouse.Move:Connect(UpdateHue)
				UpdateHue()
			end
		end)

		Creator.AddSignal(HueSlider.InputEnded, function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch then

				if MouseMoveConnection then
					MouseMoveConnection:Disconnect()
					MouseMoveConnection = nil
				end
			end
		end)

		if Config.Transparency then
			Creator.AddSignal(TransparencySlider.InputBegan, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch then

					MouseMoveConnection = Mouse.Move:Connect(UpdateTransparency)
					UpdateTransparency()
				end
			end)

			Creator.AddSignal(TransparencySlider.InputEnded, function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch then

					if MouseMoveConnection then
						MouseMoveConnection:Disconnect()
						MouseMoveConnection = nil
					end
				end
			end)
		end

		Display()

		Dialog:Button("Done", function()
			Colorpicker:SetValue({ Hue, Sat, Vib }, Transparency)
		end)

		Dialog:Button("Cancel", function()
			Colorpicker:SetValue({ OrigHue, OrigSat, OrigVib }, OrigTransparency)
		end)

		Dialog:Open()
	end

	function Colorpicker:Display()
		rawset(Colorpicker, "Value", Color3.fromHSV(Colorpicker.Hue, Colorpicker.Sat, Colorpicker.Vib))

		DisplayFrameColor.BackgroundColor3 = Colorpicker.Value
		DisplayFrameColor.BackgroundTransparency = Colorpicker.Transparency

		if typeof(Colorpicker.Callback) == "function" then
			Library:SafeCallback(Colorpicker.Callback, Colorpicker.Value)
		end
		if typeof(Colorpicker.Changed) == "function" then
			Library:SafeCallback(Colorpicker.Changed, Colorpicker.Value)
		end
	end

	function Colorpicker:SetValue(HSV, Transparency)
		local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])

		rawset(Colorpicker, "Transparency", Transparency or 0)
		Colorpicker:SetHSVFromRGB(Color)
		Colorpicker:Display()
	end

	function Colorpicker:SetValueRGB(Color, Transparency)
		rawset(Colorpicker, "Transparency", Transparency or 0)
		Colorpicker:SetHSVFromRGB(Color)
		Colorpicker:Display()
	end

	function Colorpicker:OnChanged(Func)
		Colorpicker.Changed = Func
		Library:SafeCallback(Func, Colorpicker.Value, Colorpicker.Value)
	end

	function Colorpicker:Destroy()
		ColorpickerFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(ColorpickerFrame.Frame.MouseButton1Click, function()
		CreateColorDialog()
	end)

	Colorpicker:Display()

	Library.Options[Idx] = Colorpicker

	Colorpicker.Instance = ColorpickerFrame

	return setmetatable(Colorpicker, {
		__newindex =  function(self, index, newvalue)
			local NewValue_Type = typeof(newvalue)
			if index == "Value" then
				if NewValue_Type == "table" then
					task.spawn(Colorpicker.SetValue, Colorpicker, newvalue, Colorpicker.Transparency)
				else
					task.spawn(Colorpicker.SetValueRGB, Colorpicker, newvalue, Colorpicker.Transparency)
				end
			elseif index == "Transparency" and NewValue_Type == "number" then
				task.spawn(Colorpicker.SetValueRGB, Colorpicker, Colorpicker.Value, newvalue)
			else
				rawset(self, index, newvalue)
			end
		end
	})
end

return Element
]=],
    ["Src/Elements/Dropdown"] = [=[
local UserInputService = game:GetService("UserInputService")
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local Camera = game:GetService("Workspace").CurrentCamera

local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)
local Flipper = require(Root.Packages.Flipper)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Dropdown"

function Element:New(Idx, Config)
	local Library = self.Library

	local Dropdown = {
		Values = (function()
			local Idxes = {}

			for i,v in next, Config.Values or {} do
				Idxes[#Idxes + 1] = v
			end

			return Idxes
		end)(),
		Value = Config.Default or Config.Value,
		Multi = Config.Multi or false,
		AutoDeselect = Config.AutoDeselect or false,
		Searchable = Config.Searchable or false,
		FocusSearch = Config.FocusSearch or true,
		SearchPlaceholder = Config.SearchPlaceholder or "Search...",
		Displayer = typeof(Config.Displayer) == "function" and Config.Displayer or function(Value)
			return typeof(Value) ~= "number" and tostring(Library.Utilities:Prettify(Value)) or Value
		end,
		CustomDisplayer = (typeof(Config.Displayer) == "function" and Config.Displayer and true) or false,
		Buttons = {},
		Opened = false,
		Type = "Dropdown",
		Callback = Config.Callback or function() end,
		Changed = Config.Changed or function() end
	}

	local DropdownFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)
	DropdownFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)

	Dropdown.SetTitle = DropdownFrame.SetTitle
	Dropdown.SetDesc = DropdownFrame.SetDesc

	local DropdownDisplay = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		Text = "Value",
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, -30, 0, 14),
		Position = UDim2.new(0, 8, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local DropdownIco = New("ImageLabel", {
		Image = "rbxassetid://10709790948",
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -8, 0.5, 0),
		BackgroundTransparency = 1,
		ThemeTag = {
			ImageColor3 = "SubText",
		}
	})

	local DropdownInner = New("TextButton", {
		Size = UDim2.fromOffset(160, 30),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 0.9,
		Parent = DropdownFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "DropdownFrame"
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 5),
		}),
		New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "InElementBorder",
			},
		}),
		DropdownIco,
		DropdownDisplay,
	})

	local DropdownListLayout = New("UIListLayout", {
		Padding = UDim.new(0, 3),
	})

	local DropdownScrollFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, -5, 1, Dropdown.Searchable and -40 or -10),
		Position = UDim2.fromOffset(5, Dropdown.Searchable and 40 or 5),
		BackgroundTransparency = 1,
		BottomImage = "rbxassetid://6889812791",
		MidImage = "rbxassetid://6889812721",
		TopImage = "rbxassetid://6276641225",
		ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
		ScrollBarImageTransparency = 0.95,
		ScrollBarThickness = 4,
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
	}, {
		DropdownListLayout,
	})

	local DropdownHolderFrame = New("Frame", {
		Size = UDim2.fromScale(1, 0.6),
		ThemeTag = {
			BackgroundColor3 = "DropdownHolder",
		},
	}, {
		DropdownScrollFrame,
		New("UICorner", {
			CornerRadius = UDim.new(0, 7),
		}),
		New("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "DropdownBorder",
			},
		}),
		New("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "http://www.roblox.com/asset/?id=5554236805",
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(23, 23, 277, 277),
			Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
			Position = UDim2.fromOffset(-15, -15),
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			ImageTransparency = 0.1,
		}),
	}) :: Frame

	local SearchableTextbox = require(Components.Textbox)(DropdownHolderFrame, true)
	SearchableTextbox.Frame.Visible = Dropdown.Searchable
	SearchableTextbox.Frame.AnchorPoint = Vector2.new(0.5, 0)
	SearchableTextbox.Frame.Position = UDim2.new(0.5, 0, 0, 5)
	SearchableTextbox.Frame.Size = UDim2.new(1, -5, 0, 32)
	SearchableTextbox.Input.PlaceholderText = Dropdown.SearchPlaceholder
	SearchableTextbox.Input.Text = ""

	local SearchBox = SearchableTextbox.Input

	local ButtonSelector_BuildList = New("Frame", {
		Size = UDim2.fromOffset(4, 14),
		BackgroundColor3 = Color3.fromRGB(76, 194, 255),
		Position = UDim2.fromOffset(-1, 16),
		AnchorPoint = Vector2.new(0, 0.5),
		ThemeTag = {
			BackgroundColor3 = "Accent",
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 2),
		}),
	}) :: Frame

	local ButtonLabel_BuildList = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		TextColor3 = Color3.fromRGB(200, 200, 200),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(10, 0),
		Name = "ButtonLabel",
		ThemeTag = {
			TextColor3 = "Text"
		}
	}) :: TextLabel

	local Button_BuildList = New("TextButton", {
		Size = UDim2.new(1, -5, 0, 32),
		BackgroundTransparency = 1,
		ZIndex = 23,
		Text = "",
		ThemeTag = {
			BackgroundColor3 = "DropdownOption"
		}
	}, {
		ButtonSelector_BuildList,
		ButtonLabel_BuildList,
		New("UICorner", {
			CornerRadius = UDim.new(0, 6),
		})
	}) :: TextButton

	local DropdownHolderCanvas = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(170, 300),
		Parent = self.Library.GUI,
		Visible = false,
	}, {
		DropdownHolderFrame,
		New("UISizeConstraint", {
			MinSize = Vector2.new(170, 0),
		}),
	})

	Library.OpenFrames[#Library.OpenFrames + 1] = DropdownHolderCanvas

	local function RecalculateListPosition()
		local Add = 0
		if Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y < DropdownHolderCanvas.AbsoluteSize.Y - 5 then
			Add = DropdownHolderCanvas.AbsoluteSize.Y
				- 5
				- (Camera.ViewportSize.Y - DropdownInner.AbsolutePosition.Y)
				+ 40
		end
		DropdownHolderCanvas.Position =
			UDim2.fromOffset(DropdownInner.AbsolutePosition.X - 1, DropdownInner.AbsolutePosition.Y - 5 - Add)
	end

	local ListSizeX = 0
	local function RecalculateListSize()
		local Subtract = Dropdown.Searchable and 42 or 0
		local Add = Dropdown.Searchable and 35 or 0

		DropdownHolderCanvas.Size = UDim2.fromOffset(ListSizeX, math.min(392 - Subtract, DropdownListLayout.AbsoluteContentSize.Y + 10 + Add))
	end

	local function RecalculateCanvasSize()
		DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0, DropdownListLayout.AbsoluteContentSize.Y)
	end

	local function RepopulateDropdownList()
		Dropdown:BuildDropdownList()
	end

	RecalculateListPosition()
	RecalculateListSize()

	Creator.AddSignal(DropdownInner:GetPropertyChangedSignal("AbsolutePosition"), RecalculateListPosition)
	Creator.AddSignal(SearchBox:GetPropertyChangedSignal("Text"), RepopulateDropdownList)

	local ScrollFrame = self.ScrollFrame
	function Dropdown:Open()
		Dropdown.Opened = true
		ScrollFrame.ScrollingEnabled = false
		DropdownHolderCanvas.Visible = true
		DropdownHolderFrame:TweenSize(
			UDim2.fromScale(1, 1),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			.2
		)

		if Dropdown.Searchable then
			SearchBox.Text = ""

			if Dropdown.FocusSearch then
				SearchBox:CaptureFocus()
			end
		end
	end

	function Dropdown:Close()
		Dropdown.Opened = false
		ScrollFrame.ScrollingEnabled = true
		DropdownHolderFrame.Size = UDim2.fromScale(1, 0.6)
		DropdownHolderCanvas.Visible = false

		if Dropdown.Searchable then
			SearchBox.Text = ""
			SearchBox:ReleaseFocus()
		end
	end

	Creator.AddSignal(DropdownInner.MouseButton1Click, function()
		Dropdown:Open()
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			local AbsPos, AbsSize = DropdownHolderFrame.AbsolutePosition, DropdownHolderFrame.AbsoluteSize
			if
				Mouse.X < AbsPos.X
				or Mouse.X > AbsPos.X + AbsSize.X
				or Mouse.Y < (AbsPos.Y - 20 - 1)
				or Mouse.Y > AbsPos.Y + AbsSize.Y
			then
				Dropdown:Close()
			end
		end
	end)

	function Dropdown:Display()
		local Values = Dropdown.Values
		local Str = ""

		if Config.Multi then
			for Idx, Value in next, Values do
				if Dropdown.Value[Value] then
					Str = `{Str}{Dropdown.Displayer(Value)}, `
				end
			end
			Str = Str:sub(1, #Str - 2)
		else
			Str = Dropdown.Value and Dropdown.Displayer(Dropdown.Value) or ""
		end

		DropdownDisplay.Text = (Str == "" and "--" or Str)
	end

	function Dropdown:GetActiveValues()
		if Config.Multi then
			local Values = {}

			for Value, Bool in next, Dropdown.Value do
				Values[#Values + 1] = Value
			end

			return Values
		else
			return Dropdown.Value and 1 or 0
		end
	end

	function Dropdown:BuildDropdownList()
		local Values = Dropdown.Values
		local Buttons = {}

		for _, Element in next, DropdownScrollFrame:GetChildren() do
			if not Element:IsA("UIListLayout") then
				Element:Destroy()
			end
		end

		local Count = 0

		for Idx, Value in next, Values do
			Count += 1

			if Count % 30 == 0 then
				task.wait()
			end

			if Dropdown.Searchable and SearchBox.Text ~= "" and not string.lower(Dropdown.Displayer(Value)):match(string.lower(SearchBox.Text)) then
				continue
			end

			local Table = {}
			local Selected

			local Button = Button_BuildList:Clone()
			local ButtonSelector, ButtonLabel = Button.Frame, Button.ButtonLabel

			-- AddThemeObject causes some small stuttering, the reason for that is because of 'Creator.UpdateTheme'
			-- which is called every single time a dropdown is (re)built.
			-- I have no idea how to optimize this so suggestions are welcome.

			Creator.AddThemeObject(Button, {
				BackgroundColor3 = "DropdownOption"
			})

			Creator.AddThemeObject(ButtonSelector, {
				BackgroundColor3 = "Accent",
			})

			Creator.AddThemeObject(ButtonLabel, {
				TextColor3 = "Text"
			})

			if Config.Multi then
				Selected = Dropdown.Value[Value]
			else
				Selected = Dropdown.Value == Value
			end

			local BackMotor, SetBackTransparency = Creator.SpringMotor(1, Button, "BackgroundTransparency")
			local SelMotor, SetSelTransparency = Creator.SpringMotor(1, ButtonSelector, "BackgroundTransparency")
			local SelectorSizeMotor = Flipper.SingleMotor.new(6)

			SelectorSizeMotor:onStep(function(value)
				ButtonSelector.Size = UDim2.new(0, 4, 0, value)
			end)

			Creator.AddSignal(Button.MouseEnter, function()
				SetBackTransparency(Selected and 0.85 or 0.89)
			end)

			Creator.AddSignal(Button.MouseLeave, function()
				SetBackTransparency(Selected and 0.89 or 1)
			end)

			Creator.AddSignal(Button.MouseButton1Down, function()
				SetBackTransparency(0.92)
			end)

			Creator.AddSignal(Button.MouseButton1Up, function()
				SetBackTransparency(Selected and 0.85 or 0.89)
			end)

			function Table:UpdateButton()
				if Config.Multi then
					Selected = Dropdown.Value[Value]
					if Selected then
						SetBackTransparency(0.89)
					end
				else
					Selected = Dropdown.Value == Value
					SetBackTransparency(Selected and 0.89 or 1)
				end

				SelectorSizeMotor:setGoal(Flipper.Spring.new(Selected and 14 or 6, { frequency = 6 }))
				SetSelTransparency(Selected and 0 or 1)
			end

			ButtonLabel.InputBegan:Connect(function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					local Try = not Selected

					if Dropdown:GetActiveValues() == 1 and not Try and not Config.AllowNull then
					else
						if Config.Multi then
							Selected = Try
							Dropdown.Value[Value] = Selected and true or nil

							if typeof(Dropdown.Callback) == "function" then
								Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
							end
							if typeof(Dropdown.Changed) == "function" then
								Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
							end
						else
							Selected = Try
							Dropdown:SetValue(Selected and Value or nil)

							for _, OtherButton in next, Buttons do
								OtherButton:UpdateButton()
							end
						end

						Table:UpdateButton()
						Dropdown:Display()
					end
				end
			end)

			ButtonLabel.Text = Dropdown.Displayer(Value)
			Button.Parent = DropdownScrollFrame

			Table:UpdateButton()
			Dropdown:Display()

			Buttons[Button] = Table
		end

		ListSizeX = 0

		for Button, Table in next, Buttons do
			if Button.ButtonLabel then
				if Button.ButtonLabel.TextBounds.X > ListSizeX then
					ListSizeX = Button.ButtonLabel.TextBounds.X
				end
			end
		end

		ListSizeX = ListSizeX + 30

		RecalculateCanvasSize()
		RecalculateListSize()
	end

	function Dropdown:SetValues(NewValues)
		if NewValues then
			rawset(Dropdown, "Values", NewValues)
		end

		Dropdown:BuildDropdownList()
	end

	function Dropdown:OnChanged(Func)
		Dropdown.Changed = Func
		Library:SafeCallback(Func, Dropdown.Value, Dropdown.Value)
	end

	function Dropdown:SetValue(Val)
		if Dropdown.Multi then
			local nTable = {}

			for Value, Bool in next, Val do
				if table.find(Dropdown.Values, Value) then
					nTable[Value] = true
				end
			end

			rawset(Dropdown, "Value", nTable)
		else
			if not Val then
				rawset(Dropdown, "Value", nil)
			elseif table.find(Dropdown.Values, Val) then
				rawset(Dropdown, "Value", Val)
			end
		end

		Dropdown:BuildDropdownList()

		if typeof(Dropdown.Callback) == "function" then
			Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
		end
		if typeof(Dropdown.Changed) == "function" then
			Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
		end
	end

	function Dropdown:Destroy()
		DropdownFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Dropdown:BuildDropdownList()
	Dropdown:Display()

	local Defaults = {}

	if type(Config.Default) == "table" then
		for _, Value in next, Config.Default do
			local Indx = table.find(Dropdown.Values, Value)

			if Indx then
				Defaults[#Defaults + 1] = Indx
			end
		end
		table.clear(Config.Default)
	elseif type(Config.Default) == "number" and Dropdown.Values[Config.Default] ~= nil then
		Defaults[#Defaults + 1] = Config.Default
	else
		local Indx = table.find(Dropdown.Values, Config.Default)
		if Indx then
			Defaults[#Defaults + 1] = Indx
		end
	end

	if next(Defaults) then
		for i = 1, #Defaults do
			local Index = Defaults[i]

			if Config.Multi then
				Dropdown.Value[Dropdown.Values[Index]] = true
			else
				Dropdown.Value = Dropdown.Values[Index]
				break
			end
		end

		Dropdown:BuildDropdownList()
		Dropdown:Display()
	end

	Library.Options[Idx] = Dropdown

	Dropdown.Instance = DropdownFrame

	return setmetatable(Dropdown, {
		__newindex = function(self, index, newvalue)
			if index == "Value" then
				task.spawn(Dropdown.SetValue, Dropdown, newvalue)
			elseif index == "Values" or index == "List" then
				task.spawn(Dropdown.SetValues, Dropdown, newvalue)
			end
			rawset(self, index, newvalue)
		end
	})
end

return Element

]=],
    ["Src/Elements/Input"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local AddSignal = Creator.AddSignal
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Input"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Title, "Input - Missing Title")
	Config.Callback = Config.Callback or function() end

	local Input = {
		Value = Config.Default or Config.Value or "",
		Numeric = Config.Numeric or false,
		Finished = Config.Finished or false,
		Callback = Config.Callback or function(Value) end,
		ClearOnFocusLost = Config.ClearOnFocusLost or false,
		Type = "Input",
	}

	local InputFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, false)

	Input.SetTitle = InputFrame.SetTitle
	Input.SetDesc = InputFrame.SetDesc

	local Textbox = require(Components.Textbox)(InputFrame.Frame, true)
	Textbox.Frame.Position = UDim2.new(1, -10, 0.5, 0)
	Textbox.Frame.AnchorPoint = Vector2.new(1, 0.5)
	Textbox.Frame.Size = UDim2.fromOffset(160, 30)
	Textbox.Input.Text = Config.Default or ""
	Textbox.Input.PlaceholderText = Config.Placeholder or ""

	local Box = Textbox.Input

	function Input:SetValue(Text)
		if Config.MaxLength and #Text > Config.MaxLength then
			Text = Text:sub(1, Config.MaxLength)
		end

		if Input.Numeric then
			if (not tonumber(Text)) and Text:len() > 0 then
				Text = Input.Value
			end
		end

		rawset(Input, "Value", Text)
		Box.Text = Text

		if typeof(Input.Callback) == "function" then
			Library:SafeCallback(Input.Callback, Input.Value)
		end
		if typeof(Input.Changed) == "function" then
			Library:SafeCallback(Input.Changed, Input.Value)
		end
	end

	if Input.Finished then
		AddSignal(Box.FocusLost, function(enter: boolean, input: InputObject)
			if not enter then
				return
			end

			Input:SetValue(Box.Text)

			if Config.ClearOnFocusLost then
				Box.Text = ""
			end
		end)
	else
		AddSignal(Box:GetPropertyChangedSignal("Text"), function()
			Input:SetValue(Box.Text)
		end)
	end

	function Input:OnChanged(Func)
		Input.Changed = Func
		Library:SafeCallback(Func, Input.Value, Input.Value)
	end

	function Input:Destroy()
		InputFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Library.Options[Idx] = Input

	Input.Instance = InputFrame

	return setmetatable(Input, {
		__newindex =  function(self, index, newvalue)
			if index == "Value" then
				task.spawn(Input.SetValue, Input, newvalue)
			end
			rawset(self, index, newvalue)
		end
	})
end

return Element

]=],
    ["Src/Elements/Keybind"] = [=[
local UserInputService = game:GetService("UserInputService")

local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Keybind"

function Element:New(Idx, Config)
	local Library = self.Library

	local Keybind = {
		Value = Config.Default or Config.Value or Enum.KeyCode.Unknown,
		Toggled = false,
		Mode = Config.Mode or "Toggle",
		Type = "Keybind",
		Callback = Config.Callback or function(Value) end,
		ChangedCallback = Config.ChangedCallback or function(New) end,
	}

	local Picking = false

	local KeybindFrame = require(Components.Element)(Config.Title or "Keybind", Config.Description, self.Container, true)

	Keybind.SetTitle = KeybindFrame.SetTitle
	Keybind.SetDesc = KeybindFrame.SetDesc

	local KeybindDisplayLabel = New("TextLabel", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
		Text = Library.Utilities:Prettify(Keybind.Value),
		TextColor3 = Color3.fromRGB(240, 240, 240),
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(0, 0, 0, 14),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundTransparency = 1,
		ThemeTag = {
			TextColor3 = "Text",
		},
	})

	local KeybindDisplayFrame = New("TextButton", {
		Size = UDim2.fromOffset(0, 30),
		Position = UDim2.new(1, -10, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundTransparency = 0.9,
		Parent = KeybindFrame.Frame,
		AutomaticSize = Enum.AutomaticSize.X,
		ThemeTag = {
			BackgroundColor3 = "Keybind",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 5),
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8),
		}),
		New("UIStroke", {
			Transparency = 0.5,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			ThemeTag = {
				Color = "InElementBorder",
			},
		}),
		KeybindDisplayLabel,
	}) :: TextButton

	function Keybind:GetState()
		if UserInputService:GetFocusedTextBox() and Keybind.Mode ~= "Always" then
			return false
		end

		if Keybind.Mode == "Always" then
			return true
		elseif Keybind.Mode == "Hold" then
			if Keybind.Value == "None" then
				return false
			end

			local Key = Keybind.Value

			if Key == "LeftMousebutton" or Key == "RightMousebutton" then
				return Key == "LeftMousebutton" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
					or Key == "RightMousebutton"
						and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			else
				return UserInputService:IsKeyDown(Enum.KeyCode[Keybind.Value])
			end
		else
			return Keybind.Toggled
		end
	end

	function Keybind:SetValue(Key, Mode)
		Key = Key or Keybind.Value
		Mode = Mode or Keybind.Mode

		rawset(Keybind, "Value", Key)
		Keybind.Mode = Mode

		KeybindDisplayLabel.Text = Library.Utilities:Prettify(Keybind.Value)

		if typeof(Keybind.ChangedCallback) == "function" then
			Library:SafeCallback(Keybind.ChangedCallback, Key)
		end
		if typeof(Keybind.Changed) == "function" then
			Library:SafeCallback(Keybind.Changed, Key)
		end
	end

	function Keybind:OnClick(Callback)
		Keybind.Clicked = Callback
	end

	function Keybind:OnChanged(Callback)
		Keybind.Changed = Callback
		Library:SafeCallback(Callback, Keybind.Value, Keybind.Value)
	end

	function Keybind:DoClick()
		if typeof(Keybind.Callback) == "function" then
			Library:SafeCallback(Keybind.Callback, Keybind.Toggled)
		end
		if typeof(Keybind.Clicked) == "function" then
			Library:SafeCallback(Keybind.Clicked, Keybind.Toggled)
		end
	end

	function Keybind:Destroy()
		KeybindFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Picking = true
			KeybindDisplayLabel.Text = "..."

			wait(0.2)

			UserInputService.InputBegan:Once(function(Input)
				local Key

				if Input.UserInputType == Enum.UserInputType.Keyboard then
					Key = Input.KeyCode.Name
				elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
					Key = "LeftMousebutton"
				elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
					Key = "RightMousebutton"
				end

				UserInputService.InputEnded:Once(function(Input)
					if (Input.KeyCode.Name == Key
						or Key == "LeftMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton1
						or Key == "RightMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton2)
						and not Library.Unloaded
					then
						Picking = false

						Keybind.Value = Key

						KeybindDisplayLabel.Text = Library.Utilities:Prettify(Keybind.Value)

						Library:SafeCallback(Keybind.ChangedCallback, Input.KeyCode or Input.UserInputType)
						Library:SafeCallback(Keybind.Changed, Input.KeyCode or Input.UserInputType)
					end
				end)
			end)
		end
	end)

	Creator.AddSignal(UserInputService.InputBegan, function(Input)
		if not Picking and not UserInputService:GetFocusedTextBox() then
			if Keybind.Mode == "Toggle" then
				local Key = Keybind.Value

				if Key == "LeftMousebutton" or Key == "RightMousebutton" then
					if
						Key == "LeftMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton1
						or Key == "RightMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton2
					then
						Keybind.Toggled = not Keybind.Toggled
						Keybind:DoClick()
					end
				elseif Input.UserInputType == Enum.UserInputType.Keyboard then
					if Input.KeyCode.Name == Key or Input.KeyCode == Key then
						Keybind.Toggled = not Keybind.Toggled
						Keybind:DoClick()
					end
				end
			end
		end
	end)

	Keybind:SetValue(Keybind.Value)

	Library.Options[Idx] = Keybind

	Keybind.Instance = KeybindFrame

	return setmetatable(Keybind, {
		__newindex =  function(self, index, newvalue)
			if index == "Value" then
				task.spawn(Keybind.SetValue, Keybind, newvalue)
			end
			rawset(self, index, newvalue)
		end
	})
end

return Element

]=],
    ["Src/Elements/Paragraph"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Paragraph"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Title, "Paragraph - Missing Title")
	Config.Content = Config.Content or ""

	local Paragraph = {
		Value = Config.Content,
		Callback = Config.Callback or function(Value: string) end,
		Type = "Paragraph",
	}

	local ParagraphFrame = require(Components.Element)(Config.Title, Paragraph.Value, self.Container, false, {
		TitleAlignment = Config.TitleAlignment == "Middle" and "Center" or Config.TitleAlignment,
		DescriptionAlignment = Config.ContentAlignment == "Middle" and "Center" or Config.ContentAlignment
	})

	ParagraphFrame.Frame.BackgroundTransparency = 0.92
	ParagraphFrame.Border.Transparency = 0.6


	function Paragraph:OnChanged(Func)
		Paragraph.Changed = Func
		Library:SafeCallback(Func, Paragraph.Value, Paragraph.Value)
	end

	function Paragraph:SetContent(Value)
		Value = Value or ""
		rawset(Paragraph, "Value", Value)

		ParagraphFrame:SetDesc(Value)

		ParagraphFrame.Frame.BackgroundTransparency = 0.92
		ParagraphFrame.Border.Transparency = 0.6

		if typeof(Paragraph.Callback) == "function" then
			Library:SafeCallback(Paragraph.Callback, Paragraph.Value)
		end
		if typeof(Paragraph.Changed) == "function" then
			Library:SafeCallback(Paragraph.Changed, Paragraph.Value)
		end
	end

	function Paragraph:SetValue(Value)
		Paragraph:SetContent(Value)
	end

	function Paragraph:Destroy()
		ParagraphFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Paragraph:SetValue(Paragraph.Value)

	Library.Options[Idx] = Paragraph

	Paragraph.Instance = ParagraphFrame

	return setmetatable(Paragraph, {
		__newindex =  function(self, index, newvalue)
			if index == "Value" then
				task.spawn(Paragraph.SetValue, Paragraph, newvalue)
			end
			rawset(self, index, newvalue)
		end
	})

end

return Element

]=],
    ["Src/Elements/Slider"] = [=[
local UserInputService = game:GetService("UserInputService")
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Slider"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Max, "Slider - Missing maximum value.")

	local Slider = {
		Value = nil,
		Min = typeof(Config.Min) == "number" and Config.Min or 0,
		Max = Config.Max,
		Rounding = typeof(Config.Rounding) == "number" and Config.Rounding or 0,
		Callback = typeof(Config.Callback) == "function" and Config.Callback or function(Value, OldValue) end,
		Changed = Config.Changed or function() end,
		Type = "Slider"
	}

	local Dragging = false

	local SliderFrame = require(Components.Element)(Config.Title or "Slider", Config.Description, self.Container, false)
	SliderFrame.DescLabel.Size = UDim2.new(1, -170, 0, 14)

	Slider.SetTitle = SliderFrame.SetTitle
	Slider.SetDesc = SliderFrame.SetDesc

	local SliderDot = New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, -7, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		Image = "http://www.roblox.com/asset/?id=12266946128",
		ThemeTag = {
			ImageColor3 = "Accent",
		}
	})

	local SliderRail = New("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(7, 0),
		Size = UDim2.new(1, -14, 1, 0)
	}, {
		SliderDot,
	})

	local SliderFill = New("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		ThemeTag = {
			BackgroundColor3 = "Accent",
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		})
	})

	local SliderDisplay = New("TextBox", {
		FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
		Text = "Value",
		ClearTextOnFocus = true,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 100, 0, 14),
		Position = UDim2.new(0, -4, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		ThemeTag = {
			TextColor3 = "SubText",
		}
	})

	local SliderInner = New("Frame", {
		Size = UDim2.new(1, 0, 0, 4),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		BackgroundTransparency = 0.4,
		Parent = SliderFrame.Frame,
		ThemeTag = {
			BackgroundColor3 = "SliderRail",
		}
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),
		New("UISizeConstraint", {
			MaxSize = Vector2.new(150, math.huge),
		}),
		SliderDisplay,
		SliderFill,
		SliderRail
	})

	Creator.AddSignal(SliderDot.InputBegan, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = true
		end
	end)

	Creator.AddSignal(SliderDot.InputEnded, function(Input)
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			Dragging = false
		end
	end)

	function Slider:OnChanged(Func)
		Slider.Changed = Func
		Library:SafeCallback(Func, Slider.Value, Slider.Value)
	end

	function Slider:SetValue(Value: number)
		local OldValue = self.Value or Value

		rawset(self, "Value", Library.Utilities:Round(math.clamp(Value, Slider.Min, Slider.Max), Slider.Rounding))

		SliderDot.Position = UDim2.new((self.Value - Slider.Min) / (Slider.Max - Slider.Min), -7, 0.5, 0)
		SliderFill.Size = UDim2.fromScale((self.Value - Slider.Min) / (Slider.Max - Slider.Min), 1)
		SliderDisplay.Text = tostring(self.Value)

		if typeof(Slider.Callback) == "function" then
			Library:SafeCallback(Slider.Callback, self.Value, OldValue)
		end
		if typeof(Slider.Changed) == "function" then
			Library:SafeCallback(Slider.Changed, self.Value, OldValue)
		end
	end

	Creator.AddSignal(UserInputService.InputChanged, function(Input)
		if
			Dragging
			and (
				Input.UserInputType == Enum.UserInputType.MouseMovement
				or Input.UserInputType == Enum.UserInputType.Touch
			)
		then
			local SizeScale =
				math.clamp((Input.Position.X - SliderRail.AbsolutePosition.X) / SliderRail.AbsoluteSize.X, 0, 1)
			Slider:SetValue(Slider.Min + ((Slider.Max - Slider.Min) * SizeScale))
		end
	end)

	Creator.AddSignal(SliderDisplay.FocusLost, function()
		Slider:SetValue(tonumber(SliderDisplay.Text) or Slider.Value)
	end)

	function Slider:Destroy()
		SliderFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Slider:SetValue(typeof(Config.Default) == "number" and Config.Default or Slider.Min)

	Library.Options[Idx] = Slider

	Slider.Instance = SliderFrame

	return setmetatable(Slider, {
		__newindex =  function(self, index, newvalue)
			if index == "Value" then
				task.spawn(Slider.SetValue, Slider, newvalue)
			end
			rawset(self, index, newvalue)
		end
	})
end

return Element

]=],
    ["Src/Elements/Toggle"] = [=[
local TweenService, UserInputService = game:GetService("TweenService"), game:GetService("UserInputService")
local Root = __BUNDLE_ROOT.Parent.Parent
local Creator = require(Root.Modules.Creator)

local New = Creator.New
local Components = Root.Components

local Element = {}
Element.__index = Element
Element.__type = "Toggle"

function Element:New(Idx, Config)
	local Library = self.Library
	assert(Config.Title, "Toggle - Missing Title")

	local Toggle = {
		Value = Config.Default or Config.Value or false,
		Callback = Config.Callback or function(Value) end,
		Type = "Toggle",
	}

	local ToggleFrame = require(Components.Element)(Config.Title, Config.Description, self.Container, true)
	ToggleFrame.DescLabel.Size = UDim2.new(1, -54, 0, 14)

	Toggle.SetTitle = ToggleFrame.SetTitle
	Toggle.SetDesc = ToggleFrame.SetDesc

	local ToggleCircle = New("ImageLabel", {
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.new(0, 2, 0.5, 0),
		Image = "http://www.roblox.com/asset/?id=12266946128",
		ImageTransparency = 0.5,
		ThemeTag = {
			ImageColor3 = "ToggleSlider",
		},
	}) :: ImageLabel

	local ToggleBorder = New("UIStroke", {
		Transparency = 0.5,
		ThemeTag = {
			Color = "ToggleSlider",
		},
	})

	local ToggleSlider = New("Frame", {
		Size = UDim2.fromOffset(36, 18),
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Parent = ToggleFrame.Frame,
		BackgroundTransparency = 1,
		ThemeTag = {
			BackgroundColor3 = "Accent",
		},
	}, {
		New("UICorner", {
			CornerRadius = UDim.new(0, 9),
		}),
		ToggleBorder,
		ToggleCircle,
	}) :: Frame

	function Toggle:OnChanged(Func)
		Toggle.Changed = Func
		Library:SafeCallback(Func, Toggle.Value, Toggle.Value)
	end

	function Toggle:SetValue(Value)
		Value = not not Value

		rawset(Toggle, "Value", Value)

		Creator.OverrideTag(ToggleBorder, { Color = Toggle.Value and "Accent" or "ToggleSlider" })
		Creator.OverrideTag(ToggleCircle, { ImageColor3 = Toggle.Value and "ToggleToggled" or "ToggleSlider" })

		ToggleCircle:TweenPosition(
			UDim2.new(0, Toggle.Value and 19 or 2, 0.5, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quint,
			.25,
			true
		)

		TweenService:Create(
			ToggleSlider,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ BackgroundTransparency = Toggle.Value and 0 or 1 }
		):Play()

		ToggleCircle.ImageTransparency = Toggle.Value and 0 or 0.5

		if typeof(Toggle.Callback) == "function" then
			Library:SafeCallback(Toggle.Callback, Toggle.Value)
		end
		if typeof(Toggle.Changed) == "function" then
			Library:SafeCallback(Toggle.Changed, Toggle.Value)
		end
	end

	function Toggle:Destroy()
		ToggleFrame:Destroy()
		Library.Options[Idx] = nil
	end

	Creator.AddSignal(ToggleFrame.Frame.MouseButton1Click, function()
		Toggle:SetValue(not Toggle.Value)
	end)

	Toggle.Keybind = setmetatable({}, { -- TODO: Rewrite this piece of shit
		__call = function(_, self, Idx, Config)
			local Keybind = {
				Value = Config.Default or Config.Value or Enum.KeyCode.Unknown,
				Toggled = false,
				Mode = Config.Mode or "Toggle",
				Type = "Keybind",
				Callback = Config.Callback or function(Value) end,
				ChangedCallback = Config.ChangedCallback or function(New) end,
				Instance = nil
			}

			local Picking = false

			local KeybindDisplayLabel = New("TextLabel", {
				FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				Text = Library.Utilities:Prettify(Keybind.Value),
				TextColor3 = Color3.fromRGB(240, 240, 240),
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.new(0, 0, 0, 14),
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				ThemeTag = {
					TextColor3 = "Text",
				},
			})

			local KeybindDisplayFrame: TextButton = New("TextButton", {
				Size = UDim2.fromOffset(0, 30),
				Position = UDim2.new(1, -10, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				BackgroundTransparency = 0.9,
				Parent = ToggleFrame.Frame,
				AutomaticSize = Enum.AutomaticSize.X,
				ThemeTag = {
					BackgroundColor3 = "Keybind",
				},
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 5),
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, 8),
					PaddingRight = UDim.new(0, 8),
				}),
				New("UIStroke", {
					Transparency = 0.5,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					ThemeTag = {
						Color = "InElementBorder",
					},
				}),
				KeybindDisplayLabel
			})

			Keybind.Instance = setmetatable({
				CreatedAt = tick()
			}, {
				__index = function(self, idx)
					if rawget(self, idx) then
						return rawget(self, idx)
					else
						return KeybindDisplayFrame[idx]
					end
				end
			})

			local function UpdateTogglePosition()
				ToggleSlider.Position = UDim2.new(1, KeybindDisplayFrame.Position.X.Offset - KeybindDisplayFrame.AbsoluteSize.X - 10, 0.5, 0)
			end

			function Keybind:GetState()
				if UserInputService:GetFocusedTextBox() and self.Mode ~= "Always" then
					return false
				end

				if self.Mode == "Always" then
					return true
				elseif self.Mode == "Hold" then
					if self.Value == "None" then
						return false
					end

					local Key = self.Value

					if Key == "LeftMousebutton" or Key == "RightMousebutton" then
						return Key == "LeftMousebutton" and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
							or Key == "RightMousebutton"
								and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
					else
						return UserInputService:IsKeyDown(Enum.KeyCode[self.Value])
					end
				else
					return self.Toggled
				end
			end

			function Keybind:SetValue(Key, Mode)
				Key = Key or self.Value
				Mode = Mode or self.Mode

				self.Value = Key
				self.Mode = Mode

				KeybindDisplayLabel.Text = Library.Utilities:Prettify(self.Value)
			end

			function Keybind:OnClick(Callback)
				self.Clicked = Callback
			end

			function Keybind:OnChanged(Callback)
				self.Changed = Callback
				Library:SafeCallback(Callback, self.Value, self.Value)
			end

			function Keybind:DoClick()
				Toggle:SetValue(not Toggle.Value)

				if typeof(self.Callback) == "function" then
					Library:SafeCallback(self.Callback, self.Value)
				end
				if typeof(self.Clicked) == "function" then
					Library:SafeCallback(self.Clicked, self.Value)
				end
			end

			function Keybind:Destroy()
				KeybindDisplayFrame.Size = UDim2.new()
				KeybindDisplayFrame.Position = UDim2.new()
				KeybindDisplayFrame:Destroy()
				Library.Options[Idx] = nil
			end

			Creator.AddSignal(KeybindDisplayFrame.InputBegan, function(Input)
				if
					Input.UserInputType == Enum.UserInputType.MouseButton1
					or Input.UserInputType == Enum.UserInputType.Touch
				then
					Picking = true
					KeybindDisplayLabel.Text = "..."

					wait(0.2)

					UserInputService.InputBegan:Once(function(Input)
						local Key

						if Input.UserInputType == Enum.UserInputType.Keyboard then
							Key = Input.KeyCode.Name
						elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
							Key = "LeftMousebutton"
						elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
							Key = "RightMousebutton"
						end

						UserInputService.InputEnded:Once(function(Input)
							if (Input.KeyCode.Name == Key
								or Key == "LeftMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton1
								or Key == "RightMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton2)
								and not Library.Unloaded
							then
								Picking = false

								Keybind:SetValue(Key)

								Library:SafeCallback(self.ChangedCallback, Input.KeyCode or Input.UserInputType)
								Library:SafeCallback(self.Changed, Input.KeyCode or Input.UserInputType)
							end
						end)
					end)
				end
			end)

			Creator.AddSignal(UserInputService.InputBegan, function(Input)
				if not Picking and not UserInputService:GetFocusedTextBox() then
					if Keybind.Mode == "Toggle" then
						local Key = Keybind.Value

						if Key == "LeftMousebutton" or Key == "RightMousebutton" then
							if
								Key == "LeftMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton1
								or Key == "RightMousebutton" and Input.UserInputType == Enum.UserInputType.MouseButton2
							then
								Keybind.Toggled = not Keybind.Toggled
								Keybind:DoClick()
							end
						elseif Input.UserInputType == Enum.UserInputType.Keyboard then
							if Input.KeyCode.Name == Key or Input.KeyCode == Key then
								Keybind.Toggled = not Keybind.Toggled
								Keybind:DoClick()
							end
						end
					end
				end
			end)

			Creator.AddSignal(KeybindDisplayFrame:GetPropertyChangedSignal("AbsoluteSize"), UpdateTogglePosition)

			Library.Options[Idx] = Keybind

			Toggle.Keybind = Keybind

			return setmetatable(Toggle.Keybind, {
				__newindex =  function(self, index, newvalue)
					if index == "Value" then
						task.spawn(Keybind.SetValue, Keybind, newvalue)
					end
					rawset(self, index, newvalue)
				end
			})
		end
	})

	Toggle:SetValue(Toggle.Value)

	Library.Options[Idx] = Toggle

	Toggle.Instance = ToggleFrame

	return setmetatable(Toggle, {
		__newindex =  function(self, index, newvalue)
			if index == "Value" then
				task.spawn(Toggle.SetValue, Toggle, newvalue)
			end
			rawset(self, index, newvalue)
		end
	})
end

return Element

]=],
    ["Src/Elements/init"] = [=[
local Elements = {}

for _, Element in next, script:GetChildren() do
	Elements[#Elements + 1] = require(Element)
end

return Elements

]=],
    ["Src/Modules/Acrylic/AcrylicBlur"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent.Parent
local Creator = require(Root.Modules.Creator)
local createAcrylic = require(script.Parent.CreateAcrylic)
local viewportPointToWorld, getOffset = unpack(require(script.Parent.Utils))

local BlurFolder = Instance.new("Folder", game:GetService("Workspace").CurrentCamera)

local function createAcrylicBlur(distance)
	local cleanups = {}

	distance = distance or 0.001
	local positions = {
		topLeft = Vector2.new(),
		topRight = Vector2.new(),
		bottomRight = Vector2.new(),
	}
	local model = createAcrylic()
	local mesh = model:FindFirstChildWhichIsA("SpecialMesh")

	model.Parent = BlurFolder

	local function updatePositions(size, position)
		positions.topLeft = position
		positions.topRight = position + Vector2.new(size.X, 0)
		positions.bottomRight = position + size
	end

	local function render()
		local camera = game:GetService("Workspace").CurrentCamera
		local cameraTransform = if camera then camera.CFrame else CFrame.identity

		local topLeft = positions.topLeft
		local topRight = positions.topRight
		local bottomRight = positions.bottomRight

		local topLeft3D = viewportPointToWorld(topLeft, distance)
		local topRight3D = viewportPointToWorld(topRight, distance)
		local bottomRight3D = viewportPointToWorld(bottomRight, distance)

		local width = (topRight3D - topLeft3D).Magnitude
		local height = (topRight3D - bottomRight3D).Magnitude

		model.CFrame =
			CFrame.fromMatrix((topLeft3D + bottomRight3D) / 2, cameraTransform.XVector, cameraTransform.YVector, cameraTransform.ZVector)

		if mesh then
			mesh.Scale = Vector3.new(width, height, 0)
		end
	end

	local function onChange(rbx)
		local offset = getOffset()
		local size = rbx.AbsoluteSize - Vector2.new(offset, offset)
		local position = rbx.AbsolutePosition + Vector2.new(offset / 2, offset / 2)

		updatePositions(size, position)
		task.spawn(render)
	end

	local function renderOnChange()
		local camera = game:GetService("Workspace").CurrentCamera
		if not camera then
			return
		end

		cleanups[#cleanups + 1] = camera:GetPropertyChangedSignal("CFrame"):Connect(render)
		cleanups[#cleanups + 1] = camera:GetPropertyChangedSignal("ViewportSize"):Connect(render)
		cleanups[#cleanups + 1] = camera:GetPropertyChangedSignal("FieldOfView"):Connect(render)
		task.spawn(render)
	end

	model.Destroying:Connect(function()
		for _, item in cleanups do
			pcall(function()
				item:Disconnect()
			end)
		end
	end)

	renderOnChange()

	return onChange, model
end

return function(distance)
	local Blur = {}
	local onChange, model = createAcrylicBlur(distance)

	local comp = Creator.New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	})

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsolutePosition"), function()
		onChange(comp)
	end)

	Creator.AddSignal(comp:GetPropertyChangedSignal("AbsoluteSize"), function()
		onChange(comp)
	end)

	Blur.AddParent = function(Parent)
		Creator.AddSignal(Parent:GetPropertyChangedSignal("Visible"), function()
			Blur.SetVisibility(Parent.Visible)
		end)
	end

	Blur.SetVisibility = function(Value)
		model.Transparency = Value and 0.98 or 1
	end

	Blur.Frame = comp
	Blur.Model = model

	return Blur
end

]=],
    ["Src/Modules/Acrylic/AcrylicPaint"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent.Parent
local Creator = require(Root.Modules.Creator)
local AcrylicBlur = require(script.Parent.AcrylicBlur)

local New = Creator.New

return function(props)
	local AcrylicPaint = {}

	AcrylicPaint.Frame = New("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 0.9,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, {
		New("ImageLabel", {
			Image = "rbxassetid://8992230677",
			ScaleType = "Slice",
			SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, 120, 1, 116),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(0, 0, 0),
			ImageTransparency = 0.7,
		}),

		New("UICorner", {
			CornerRadius = UDim.new(0, 8),
		}),

		New("Frame", {
			BackgroundTransparency = 0.45,
			Size = UDim2.fromScale(1, 1),
			Name = "Background",
			ThemeTag = {
				BackgroundColor3 = "AcrylicMain",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.4,
			Size = UDim2.fromScale(1, 1),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),

			New("UIGradient", {
				Rotation = 90,
				ThemeTag = {
					Color = "AcrylicGradient",
				},
			}),
		}),

		New("ImageLabel", {
			Image = "rbxassetid://9968344105",
			ImageTransparency = 0.98,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.new(0, 128, 0, 128),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("ImageLabel", {
			Image = "rbxassetid://9968344227",
			ImageTransparency = 0.9,
			ScaleType = Enum.ScaleType.Tile,
			TileSize = UDim2.new(0, 128, 0, 128),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			ThemeTag = {
				ImageTransparency = "AcrylicNoise",
			},
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
		}),

		New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 8),
			}),
			New("UIStroke", {
				Transparency = 0.5,
				Thickness = 1,
				ThemeTag = {
					Color = "AcrylicBorder",
				},
			}),
		}),
	})

	local Blur

	if require(Root).UseAcrylic then
		Blur = AcrylicBlur()
		Blur.Frame.Parent = AcrylicPaint.Frame
		AcrylicPaint.Model = Blur.Model
		AcrylicPaint.AddParent = Blur.AddParent
		AcrylicPaint.SetVisibility = Blur.SetVisibility
	end

	return AcrylicPaint
end

]=],
    ["Src/Modules/Acrylic/CreateAcrylic"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent.Parent
local Creator = require(Root.Modules.Creator)

local function createAcrylic()
	local Part = Creator.New("Part", {
		Name = "Body",
		Color = Color3.new(0, 0, 0),
		Material = Enum.Material.Glass,
		Size = Vector3.new(1, 1, 0),
		Anchored = true,
		CanCollide = false,
		Locked = true,
		CastShadow = false,
		Transparency = 0.98,
	}, {
		Creator.New("SpecialMesh", {
			MeshType = Enum.MeshType.Brick,
			Offset = Vector3.new(0, 0, -0.000001),
		})
	})

	return Part
end

return createAcrylic

]=],
    ["Src/Modules/Acrylic/Utils"] = [=[
local function map(value, inMin, inMax, outMin, outMax)
	return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

local function viewportPointToWorld(location, distance)
	local unitRay = game:GetService("Workspace").CurrentCamera:ScreenPointToRay(location.X, location.Y)
	return unitRay.Origin + unitRay.Direction * distance
end

local function getOffset()
	local viewportSizeY = game:GetService("Workspace").CurrentCamera.ViewportSize.Y
	return map(viewportSizeY, 0, 2560, 8, 56)
end

return { viewportPointToWorld, getOffset }

]=],
    ["Src/Modules/Acrylic/init"] = [=[
local Acrylic = {
	AcrylicBlur = require(script.AcrylicBlur),
	CreateAcrylic = require(script.CreateAcrylic),
	AcrylicPaint = require(script.AcrylicPaint),
}

function Acrylic.init()
	local baseEffect = Instance.new("DepthOfFieldEffect")
	baseEffect.FarIntensity = 0
	baseEffect.InFocusRadius = 0.1
	baseEffect.NearIntensity = 1

	local depthOfFieldDefaults = {}

	function Acrylic.Enable()
		for _, effect in next, depthOfFieldDefaults do
			effect.Enabled = false
		end
		baseEffect.Parent = game:GetService("Lighting")
	end

	function Acrylic.Disable()
		for _, effect in next, depthOfFieldDefaults do
			effect.Enabled = effect.enabled
		end
		baseEffect.Parent = nil
	end

	local function registerDefaults()
		local function register(object)
			if object:IsA("DepthOfFieldEffect") then
				depthOfFieldDefaults[object] = { enabled = object.Enabled }
			end
		end

		for _, child in next, game:GetService("Lighting"):GetChildren() do
			register(child)
		end

		if game:GetService("Workspace").CurrentCamera then
			for _, child in next, game:GetService("Workspace").CurrentCamera:GetChildren() do
				register(child)
			end
		end
	end

	registerDefaults()
	Acrylic.Enable()
end

return Acrylic

]=],
    ["Src/Modules/Creator"] = [=[
local Root = __BUNDLE_ROOT.Parent.Parent
local Themes = require(Root.Themes)
local Flipper, Ripple = require(Root.Packages.Flipper), require(Root.Packages.Ripple)
local Signal = require(Root.Packages.Signal)

local Creator = {
	Registry = {},
	Signals = {},
	TransparencyMotors = {},
	DefaultProperties = {
		ScreenGui = {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		},
		Frame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ScrollingFrame = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ScrollBarImageColor3 = Color3.new(0, 0, 0),
		},
		TextLabel = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			TextSize = 14,
			RichText = true,
		},
		TextButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
			RichText = true,
		},
		TextBox = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			ClearTextOnFocus = false,
			Font = Enum.Font.SourceSans,
			Text = "",
			TextColor3 = Color3.new(0, 0, 0),
			TextSize = 14,
			RichText = true,
		},
		ImageLabel = {
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		},
		ImageButton = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			AutoButtonColor = false,
		},
		CanvasGroup = {
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderColor3 = Color3.new(0, 0, 0),
			BorderSizePixel = 0,
		}
	},
	Theme = {
		Updating = false,
		Updated = Signal.new()
	}
}

local function ApplyCustomProps(Object, Props: { [string]: any }?)
	if typeof(Props) == "table" and Props.ThemeTag then
		Creator.AddThemeObject(Object, Props.ThemeTag)
	end
end

function Creator.AddSignal(Signal: RBXScriptSignal, Function)
	Creator.Signals[#Creator.Signals+1] = Signal:Connect(Function)
end

function Creator.Disconnect()
	for Idx = #Creator.Signals, 1, -1 do
		local Connection = table.remove(Creator.Signals, Idx)

		if Connection then
			Connection:Disconnect()
		end
	end
end

function Creator.GetThemeProperty(Property)
	if Themes[require(Root).Theme][Property] then
		return Themes[require(Root).Theme][Property]
	end

	return Themes["Dark"][Property]
end

function Creator.UpdateTheme(RegistryIndex: Instance?)
	if Creator.Theme.Updating then
		Creator.Theme.Updated:Wait()
	end

	Creator.Theme.Updating = true

	local Count = 0

	if typeof(RegistryIndex) == "Instance" and Creator.Registry[RegistryIndex] then
		for Property, ColorIdx in next, Creator.Registry[RegistryIndex].Properties do
			Count += 1

			if Count % 135 == 0 then
				task.wait()
			end

			RegistryIndex[Property] = Creator.GetThemeProperty(ColorIdx)
		end
	else
		for _, Object in next, Creator.Registry do
			Count += 1

			if Count % 135 == 0 then
				task.wait()
			end

			for Property, ColorIdx in next, Object.Properties do
				Count += 1

				if Count % 135 == 0 then
					task.wait()
				end

				Object.Object[Property] = Creator.GetThemeProperty(ColorIdx)
			end
		end
	end	

	for Idx: number, Motor in next, Creator.TransparencyMotors do
		if Idx % 135 == 0 then
			task.wait()
		end

		Motor:setGoal(Flipper.Instant.new(Creator.GetThemeProperty("ElementTransparency")))
	end

	Creator.Theme.Updating = false
	Creator.Theme.Updated:Fire()
end

function Creator.AddThemeObject(Object: Instance, Properties:{ [string]: any })
	local Idx = #Creator.Registry + 1
	local Data = {
		Object = Object,
		Properties = Properties,
		Idx = Idx,
	}

	Creator.Registry[Object] = Data
	Creator.UpdateTheme(Object)

	return Object
end

function Creator.OverrideTag(Object, Properties)
	Creator.Registry[Object].Properties = Properties
	Creator.UpdateTheme(Object)
end

function Creator.New(Name, Properties: { [string]: any }?, Children: { [number]: Instance }?): Instance
	local Object = Instance.new(Name)

	-- Default properties
	for Name, Value in next, Creator.DefaultProperties[Name] or {} do
		Object[Name] = Value
	end

	-- Properties
	for Name, Value in next, Properties or {} do
		if Name ~= "ThemeTag" then
			Object[Name] = Value
		end
	end

	-- Children
	for _, Child in next, Children or {} do
		Child.Parent = Object
	end

	ApplyCustomProps(Object, Properties)

	return Object
end

function Creator.SpringMotor(Initial: any, Instance: Object, Prop: string, IgnoreDialogCheck: boolean?, ResetOnThemeChange: boolean?)
	IgnoreDialogCheck = IgnoreDialogCheck or false
	ResetOnThemeChange = ResetOnThemeChange or false
	local Motor = Flipper.SingleMotor.new(Initial)
	Motor:onStep(function(value)
		Instance[Prop] = value
	end)

	if ResetOnThemeChange then
		Creator.TransparencyMotors[#Creator.TransparencyMotors + 1] = Motor
	end

	local function SetValue(Value, Ignore: boolean?)
		Ignore = Ignore or false
		if not IgnoreDialogCheck then
			if not Ignore then
				if Prop == "BackgroundTransparency" and require(Root).DialogOpen then
					return
				end
			end
		end
		Motor:setGoal(Flipper.Spring.new(Value, { frequency = 8 }))
	end

	return Motor, SetValue
end

return Creator

]=],
    ["Src/init"] = [=[
local function Clone<Original>(ToClone: any & Original): (Original, boolean)
	local Type = typeof(ToClone)

	if Type == "function" and (clonefunc or clonefunction) then
		return (clonefunc or clonefunction)(ToClone), true
	elseif Type == "Instance" and (cloneref or clonereference) then
		return (cloneref or clonereference)(ToClone), true
	elseif Type == "table" then
		local function deepcopy(orig, copies: { [any]: any }?)
			local Copies = copies or {}
			local orig_type, copy = typeof(orig), nil

			if orig_type == 'table' then
				if Copies[orig] then
					copy = Copies[orig]
				else	
					copy = {}

					Copies[orig] = copy

					for orig_key, orig_value in next, orig, nil do
						copy[deepcopy(orig_key, Copies)] = deepcopy(orig_value, Copies)
					end

					(setrawmetatable or setmetatable)(copy, deepcopy((getrawmetatable or getmetatable)(orig), Copies))
				end
			elseif orig_type == 'Instance' or orig_type == 'function' then
				copy = Clone(orig)
			else
				copy = orig
			end

			return copy
		end

		return deepcopy(ToClone), true
	else
		return ToClone, false
	end
end

local MarketplaceService = Clone(game:GetService("MarketplaceService"))
local TweenService = Clone(game:GetService("TweenService"))
local Camera = Clone(game:GetService("Workspace")).CurrentCamera
local UserInputService = Clone(game:GetService("UserInputService"))
local GuiService = Clone(game:GetService("GuiService"))

local Root = __BUNDLE_ROOT
local Components = Root.Components

local Creator = require(Root.Modules.Creator)
local ElementsTable = require(Root.Elements)
local Acrylic = require(Root.Modules.Acrylic)
local Icons = require(Root.Modules.Icons)
local Themes = require(Root.Themes)
local Signal = require(Root.Packages.Signal)

local NotificationModule = require(Components.Notification)

local SharedTable = shared or _G or (getgenv and getgenv()) or getfenv(1)
local New = Creator.New

local BaseContainer = New("ScreenGui", {
	Name = "Fluent Renewed Base GUI"
})

BaseContainer.Parent = (function() -- https://github.com/Pepsied-5229/Pepsi-UI-Library/blob/main/Pepsi-UI-Library.lua#L503
	local success, result = pcall(function()
		return (gethui or get_hidden_ui)()
	end)

	if success and result then
		return result
	end

	success, result = pcall(function()
		local CoreGui = game:GetService("CoreGui")

		CoreGui:GetFullName()

		return CoreGui
	end)

	if success and result then
		return result
	end

	success, result = pcall(function()
		return (game:IsLoaded() or game.Loaded:Wait() or true) and game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui", 10)
	end)

	if success and result then
		return result
	end

	success, result = pcall(function()
		local StarterGui = game:GetService("StarterGui")

		StarterGui:GetFullName()

		return StarterGui
	end)

	if success and result then
		return result
	end

	return error("Seriously bad engine. Can't find a place to store the GUI. Robust code can't help this much incompetence.", 0)
end)()

SharedTable.FluentRenewed = SharedTable.FluentRenewed or {}

NotificationModule:Init(BaseContainer)

local Library = {
	Version = "1.0.5",

	OpenFrames = {},
	Options = {},
	Themes = Themes.Names,

	OnUnload = Signal.new(),
	PostUnload = Signal.new(),
	ThemeChanged = Signal.new(),
	CreatedWindow = nil,
	WindowFrame = nil,
	UIContainer = BaseContainer.Parent,
	Utilities = {
		Themes = Themes,
		Shared = SharedTable,
		Creator = Creator,
		Icons = Icons
	},
	Connections = Creator.Signals,
	Unloaded = false,
	Loaded = true,

	Theme = "Dark",
	DialogOpen = false,
	UseAcrylic = false,
	Acrylic = false,
	Transparency = true,
	MinimizeKey = Enum.KeyCode.LeftControl,

	GUI = BaseContainer
}

function Library:SafeCallback(Function, ...)
	assert(typeof(Function) == "function", debug.traceback(`Library:SafeCallback expects type 'function' at Argument #1, got '{typeof(Function)}'`, 2))

	task.spawn(function(...)
		local Success, Event = pcall(Function, ...)

		if not Success then
			local _, i = Event:find(":%d+: ")

			task.defer(error, debug.traceback(Event, 2))

			Library:Notify({
				Title = "Interface",
				Content = "Callback error",
				SubContent = if typeof(i) == "number" then Event:sub(i + 1) else Event,
				Duration = 5,
			})
		end
	end, ...)
end

function Library.Utilities:Resize(X: number, Y: number): (number, number)
    local x, y, CurrentSize = X / 1920, Y / 1080, Camera.ViewportSize
    return CurrentSize.X * x, CurrentSize.Y * y
end

function Library.Utilities:Truncate(number: number, decimals: number, round: boolean): number
	local shift = 10 ^ (typeof(decimals) == "number" and math.max(decimals, 0) or 0)

	if round then
		return math.round(number * shift) // 1 / shift
	else
		return number * shift // 1 / shift
	end
end

function Library.Utilities:Round(Number: number, Factor: number): number

--[[
  Compatibility key behavior (collapse vs hide)
  - '-' or 'KeypadMinus': collapse/expand content (keep header)
  - RightControl: hide/show entire UI
]]

Library.MinimizeKey = Enum.KeyCode.Unknown
Library.MinimizeKeybind = false

local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local function findScreenGuiFrom(frame)
    local p = frame
    while p and not p:IsA("ScreenGui") do p = p.Parent end
    return p
end

local function getRootFrame()
    return Library.CreatedWindow and (Library.CreatedWindow.Root or Library.CreatedWindow.Frame or Library.CreatedWindow) or nil
end

local ScreenGui
local function toggleCollapse()
    local root = getRootFrame()
    if not root then return end
    if root:GetAttribute("Collapsed") then
        root:SetAttribute("Collapsed", false)
        local prev = root:GetAttribute("PrevSize")
        if typeof(prev) == "UDim2" then root.Size = prev end
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = true
            end
        end
    else
        root:SetAttribute("Collapsed", true)
        root:SetAttribute("PrevSize", root.Size)
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = false
            end
        end
        local header = root:FindFirstChild("Top") or root:FindFirstChild("TitleBar")
        local h = header and header.AbsoluteSize.Y or 40
        root.Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, h)
    end
end

local function CollapseAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        toggleCollapse()
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function HideAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        if not ScreenGui then
            local rf = getRootFrame()
            if rf then ScreenGui = findScreenGuiFrom(rf) end
        end
        if ScreenGui then ScreenGui.Enabled = not ScreenGui.Enabled end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("FluentRenewedCollapse", CollapseAction, false, 999999, Enum.KeyCode.Minus, Enum.KeyCode.KeypadMinus)
CAS:BindActionAtPriority("FluentRenewedHide", HideAction, false, 999999, Enum.KeyCode.RightControl)

return Library.Utilities:Truncate(Number, Factor, true)
end

function Library.Utilities:GetIcon(Name: string): { Image: string, ImageRectSize: Vector2, ImageRectOffset: Vector2 }
	return Name ~= "SetIcon" and Icons[Name] or nil
end

function Library.Utilities:Prettify(ToPrettify: EnumItem & string & number): string | number

	if typeof(ToPrettify) == "EnumItem" then
		return ({ToPrettify.Name:gsub("(%l)(%u)", "%1 %2")})[1]
	elseif typeof(ToPrettify) == "string" then
		return ({ToPrettify:gsub("(%l)(%u)", "%1 %2")})[1]
	elseif typeof(ToPrettify) == "number" then

--[[
  Compatibility key behavior (collapse vs hide)
  - '-' or 'KeypadMinus': collapse/expand content (keep header)
  - RightControl: hide/show entire UI
]]

Library.MinimizeKey = Enum.KeyCode.Unknown
Library.MinimizeKeybind = false

local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local function findScreenGuiFrom(frame)
    local p = frame
    while p and not p:IsA("ScreenGui") do p = p.Parent end
    return p
end

local function getRootFrame()
    return Library.CreatedWindow and (Library.CreatedWindow.Root or Library.CreatedWindow.Frame or Library.CreatedWindow) or nil
end

local ScreenGui
local function toggleCollapse()
    local root = getRootFrame()
    if not root then return end
    if root:GetAttribute("Collapsed") then
        root:SetAttribute("Collapsed", false)
        local prev = root:GetAttribute("PrevSize")
        if typeof(prev) == "UDim2" then root.Size = prev end
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = true
            end
        end
    else
        root:SetAttribute("Collapsed", true)
        root:SetAttribute("PrevSize", root.Size)
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = false
            end
        end
        local header = root:FindFirstChild("Top") or root:FindFirstChild("TitleBar")
        local h = header and header.AbsoluteSize.Y or 40
        root.Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, h)
    end
end

local function CollapseAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        toggleCollapse()
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function HideAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        if not ScreenGui then
            local rf = getRootFrame()
            if rf then ScreenGui = findScreenGuiFrom(rf) end
        end
        if ScreenGui then ScreenGui.Enabled = not ScreenGui.Enabled end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("FluentRenewedCollapse", CollapseAction, false, 999999, Enum.KeyCode.Minus, Enum.KeyCode.KeypadMinus)
CAS:BindActionAtPriority("FluentRenewedHide", HideAction, false, 999999, Enum.KeyCode.RightControl)

return Library.Utilities:Round(ToPrettify, 2)
	else
		return tostring(ToPrettify)
	end
end

function Library.Utilities:Clone<Original>(ToClone: {[any]: any} & (...any) -> (...any) & Object & Original): (Original, boolean)
	return Clone(ToClone)
end

function Library.Utilities:GetOS()
	local OSName = "Unknown"

	if GuiService:IsTenFootInterface() then
		local L2Button_Name = UserInputService:GetStringForKeyCode(Enum.KeyCode.ButtonL2)

		OSName = if L2Button_Name == "ButtonLT" then "Xbox" elseif L2Button_Name == "ButtonL2" then "PlayStation" else "Console"
	elseif GuiService.IsWindows then
		OSName = "Windows"
	elseif version():find("^0.") == 1 then
		OSName = "macOS"
	elseif version():find("^2.") == 1 then
		OSName = UserInputService.VREnabled and "MetaHorizon" or "Mobile"
	end

	return OSName
end

local Elements = {}
Elements.__index = Elements
Elements.__namecall = function(Table, Key, ...)
	return Elements[Key](...)
end

for _, ElementComponent in next, ElementsTable do
	Elements[`Create{ElementComponent.__type}`] = function(self, Idx, Config)
		ElementComponent.Container = self.Container
		ElementComponent.Type = self.Type
		ElementComponent.ScrollFrame = self.ScrollFrame
		ElementComponent.Library = Library

		return ElementComponent:New(Idx, Config)
	end

	Elements[`Add{ElementComponent.__type}`] = Elements[`Create{ElementComponent.__type}`]
	Elements[ElementComponent.__type] = Elements[`Create{ElementComponent.__type}`]
end

Library.Elements = Elements

function Library:Window(Config: {
		Title: string?,
		SubTitle: string?,
		TabWidth: number?,
		MinSize: Vector2?,
		Size: UDim2?,
		Resize: boolean?,
		MinimizeKey: Enum.KeyCode?,
		Acrylic: boolean?,
		Theme: string?,
		Mobile: {
			GetIcon: (IsMinimized: boolean) -> { Image: string, ImageRectOffset: Vector2, ImageRectSize: Vector2 },
			Size: UDim2
		}?
	})
	assert(Library.CreatedWindow == nil, debug.traceback("You cannot create more than one window.", 2))

	if not Config.Title then
		local Success, Game_Info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)

		Config.Title = Success and Game_Info.Name or "Fluent Renewed"
	end

	Config.MinSize = if typeof(Config.MinSize) == "Vector2" then Config.MinSize else Vector2.new(470, 380)

	Config.Size = if Config.Resize ~= true then Config.Size else UDim2.fromOffset(Library.Utilities:Resize((Config.Size and Config.Size.X.Offset) or 470, (Config.Size and Config.Size.Y.Offset) or 380))
	Config.MinSize = if Config.Resize ~= true then Config.MinSize else Vector2.new(Library.Utilities:Resize((Config.MinSize and Config.MinSize.X) or 470, (Config.MinSize and Config.MinSize.Y) or 380))

	Library.MinimizeKey = if typeof(Config.MinimizeKey) == "string" or typeof(Config.MinimizeKey) == "EnumItem" and Config.MinimizeKey.EnumType == Enum.KeyCode then Config.MinimizeKey else Enum.KeyCode.LeftControl
	Library.UseAcrylic = if typeof(Config.Acrylic) == "boolean" then Config.Acrylic else false
	Library.Acrylic = if typeof(Config.Acrylic) == "boolean" then Config.Acrylic else false
	Library.Theme = if typeof(Config.Theme) == "string" then Config.Theme else "Vynixu"

	if Config.Acrylic then
		Acrylic.init()
	end

	local Window = require(Components.Window){
		Config = Config,
		Parent = BaseContainer,

		Size = Config.Size,
		MinSize = Config.MinSize,

		Title = Config.Title,
		SubTitle = Config.SubTitle or "Made with Fluent Renewed",

		TabWidth = Config.TabWidth or 160,
		Mobile = Config.Mobile or {
			GetIcon = function(IsMinimized: boolean): { Image: string, ImageRectOffset: Vector2, ImageRectSize: Vector2 }

--[[
  Compatibility key behavior (collapse vs hide)
  - '-' or 'KeypadMinus': collapse/expand content (keep header)
  - RightControl: hide/show entire UI
]]

Library.MinimizeKey = Enum.KeyCode.Unknown
Library.MinimizeKeybind = false

local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local function findScreenGuiFrom(frame)
    local p = frame
    while p and not p:IsA("ScreenGui") do p = p.Parent end
    return p
end

local function getRootFrame()
    return Library.CreatedWindow and (Library.CreatedWindow.Root or Library.CreatedWindow.Frame or Library.CreatedWindow) or nil
end

local ScreenGui
local function toggleCollapse()
    local root = getRootFrame()
    if not root then return end
    if root:GetAttribute("Collapsed") then
        root:SetAttribute("Collapsed", false)
        local prev = root:GetAttribute("PrevSize")
        if typeof(prev) == "UDim2" then root.Size = prev end
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = true
            end
        end
    else
        root:SetAttribute("Collapsed", true)
        root:SetAttribute("PrevSize", root.Size)
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = false
            end
        end
        local header = root:FindFirstChild("Top") or root:FindFirstChild("TitleBar")
        local h = header and header.AbsoluteSize.Y or 40
        root.Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, h)
    end
end

local function CollapseAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        toggleCollapse()
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function HideAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        if not ScreenGui then
            local rf = getRootFrame()
            if rf then ScreenGui = findScreenGuiFrom(rf) end
        end
        if ScreenGui then ScreenGui.Enabled = not ScreenGui.Enabled end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("FluentRenewedCollapse", CollapseAction, false, 999999, Enum.KeyCode.Minus, Enum.KeyCode.KeypadMinus)
CAS:BindActionAtPriority("FluentRenewedHide", HideAction, false, 999999, Enum.KeyCode.RightControl)

return Library.Utilities:GetIcon(IsMinimized and "phosphor-eye" or "phosphor-eye-slash")
			end,
			Size = UDim2.fromOffset(30, 30)
		}
	}

	BaseContainer.Name = `FluentRenewed_{Config.Title}`

	Library.CreatedWindow = Window
	Library:SetTheme(Library.Theme)

	return Window
end

function Library:AddWindow(Config)

--[[
  Compatibility key behavior (collapse vs hide)
  - '-' or 'KeypadMinus': collapse/expand content (keep header)
  - RightControl: hide/show entire UI
]]

Library.MinimizeKey = Enum.KeyCode.Unknown
Library.MinimizeKeybind = false

local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local function findScreenGuiFrom(frame)
    local p = frame
    while p and not p:IsA("ScreenGui") do p = p.Parent end
    return p
end

local function getRootFrame()
    return Library.CreatedWindow and (Library.CreatedWindow.Root or Library.CreatedWindow.Frame or Library.CreatedWindow) or nil
end

local ScreenGui
local function toggleCollapse()
    local root = getRootFrame()
    if not root then return end
    if root:GetAttribute("Collapsed") then
        root:SetAttribute("Collapsed", false)
        local prev = root:GetAttribute("PrevSize")
        if typeof(prev) == "UDim2" then root.Size = prev end
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = true
            end
        end
    else
        root:SetAttribute("Collapsed", true)
        root:SetAttribute("PrevSize", root.Size)
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = false
            end
        end
        local header = root:FindFirstChild("Top") or root:FindFirstChild("TitleBar")
        local h = header and header.AbsoluteSize.Y or 40
        root.Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, h)
    end
end

local function CollapseAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        toggleCollapse()
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function HideAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        if not ScreenGui then
            local rf = getRootFrame()
            if rf then ScreenGui = findScreenGuiFrom(rf) end
        end
        if ScreenGui then ScreenGui.Enabled = not ScreenGui.Enabled end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("FluentRenewedCollapse", CollapseAction, false, 999999, Enum.KeyCode.Minus, Enum.KeyCode.KeypadMinus)
CAS:BindActionAtPriority("FluentRenewedHide", HideAction, false, 999999, Enum.KeyCode.RightControl)

return Library:Window(Config)
end

function Library:CreateWindow(Config)

--[[
  Compatibility key behavior (collapse vs hide)
  - '-' or 'KeypadMinus': collapse/expand content (keep header)
  - RightControl: hide/show entire UI
]]

Library.MinimizeKey = Enum.KeyCode.Unknown
Library.MinimizeKeybind = false

local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local function findScreenGuiFrom(frame)
    local p = frame
    while p and not p:IsA("ScreenGui") do p = p.Parent end
    return p
end

local function getRootFrame()
    return Library.CreatedWindow and (Library.CreatedWindow.Root or Library.CreatedWindow.Frame or Library.CreatedWindow) or nil
end

local ScreenGui
local function toggleCollapse()
    local root = getRootFrame()
    if not root then return end
    if root:GetAttribute("Collapsed") then
        root:SetAttribute("Collapsed", false)
        local prev = root:GetAttribute("PrevSize")
        if typeof(prev) == "UDim2" then root.Size = prev end
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = true
            end
        end
    else
        root:SetAttribute("Collapsed", true)
        root:SetAttribute("PrevSize", root.Size)
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = false
            end
        end
        local header = root:FindFirstChild("Top") or root:FindFirstChild("TitleBar")
        local h = header and header.AbsoluteSize.Y or 40
        root.Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, h)
    end
end

local function CollapseAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        toggleCollapse()
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function HideAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        if not ScreenGui then
            local rf = getRootFrame()
            if rf then ScreenGui = findScreenGuiFrom(rf) end
        end
        if ScreenGui then ScreenGui.Enabled = not ScreenGui.Enabled end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("FluentRenewedCollapse", CollapseAction, false, 999999, Enum.KeyCode.Minus, Enum.KeyCode.KeypadMinus)
CAS:BindActionAtPriority("FluentRenewedHide", HideAction, false, 999999, Enum.KeyCode.RightControl)

return Library:Window(Config)
end

function Library:SetTheme(Name: string)
	if Library.CreatedWindow and table.find(Library.Themes, Name) then
		Library.Theme = Name
		Creator.UpdateTheme()
		Library.ThemeChanged:Fire(Name)
	end
end

function Library:Destroy()
	if Library.CreatedWindow then
		Library.Unloaded = true
		Library.Loaded = false

		Library.OnUnload:Fire(tick())

		if Library.UseAcrylic then
			Library.CreatedWindow.AcrylicPaint.Model:Destroy()
		end

		Creator.Disconnect()

		for i,v in next, Library.Connections do
			local type = typeof(v)

			if type == "RBXScriptConnection" and v.Connected then
				v:Disconnect()
			end
		end

		local info, tweenProps, doTween = TweenInfo.new(2 / 3, Enum.EasingStyle.Quint), {}, false

		local function IsA(obj: Object, class: string)
			local isClass = obj:IsA(class)

			if isClass then
				doTween = true
			end

			return isClass
		end

		for i,v in next, Library.GUI:GetDescendants() do
			table.clear(tweenProps)

			if IsA(v, "GuiObject") then
				tweenProps.BackgroundTransparency = 1
			end

			if IsA(v, "ScrollingFrame") then
				tweenProps.ScrollBarImageTransparency = 1		
			end

			if IsA(v, "TextLabel") or IsA(v, "TextBox") then
				tweenProps.TextStrokeTransparency = 1
				tweenProps.TextTransparency = 1
			end

			if IsA(v, "UIStroke") then
				tweenProps.Transparency = 1
			end

			if IsA(v, "ImageLabel") or IsA(v, "ImageButton") then
				tweenProps.ImageTransparency = 1
			end

			if doTween then
				doTween = false
				TweenService:Create(v, info, tweenProps):Play()
			end
		end

		task.delay(info.Time, function()
			Library.GUI:Destroy()

			Library.PostUnload:Fire(tick())
		end)
	end
end

function Library:ToggleAcrylic(Value: boolean)
	if Library.CreatedWindow then
		if Library.UseAcrylic then
			Library.Acrylic = Value
			Library.CreatedWindow.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
			if Value then
				Acrylic.Enable()
			else
				Acrylic.Disable()
			end
		end
	end
end

function Library:ToggleTransparency(Value: boolean)
	if Library.CreatedWindow then
		Library.CreatedWindow.AcrylicPaint.Frame.Background.BackgroundTransparency = Value and 0.35 or 0
	end
end

function Library:Notify(Config)
	return NotificationModule:New(Config)
end


--[[
  Compatibility key behavior (collapse vs hide)
  - '-' or 'KeypadMinus': collapse/expand content (keep header)
  - RightControl: hide/show entire UI
]]

Library.MinimizeKey = Enum.KeyCode.Unknown
Library.MinimizeKeybind = false

local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")

local function findScreenGuiFrom(frame)
    local p = frame
    while p and not p:IsA("ScreenGui") do p = p.Parent end
    return p
end

local function getRootFrame()
    return Library.CreatedWindow and (Library.CreatedWindow.Root or Library.CreatedWindow.Frame or Library.CreatedWindow) or nil
end

local ScreenGui
local function toggleCollapse()
    local root = getRootFrame()
    if not root then return end
    if root:GetAttribute("Collapsed") then
        root:SetAttribute("Collapsed", false)
        local prev = root:GetAttribute("PrevSize")
        if typeof(prev) == "UDim2" then root.Size = prev end
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = true
            end
        end
    else
        root:SetAttribute("Collapsed", true)
        root:SetAttribute("PrevSize", root.Size)
        for _,obj in ipairs(root:GetChildren()) do
            if obj:IsA("GuiObject") and obj.Name ~= "Top" and obj.Name ~= "TitleBar" then
                obj.Visible = false
            end
        end
        local header = root:FindFirstChild("Top") or root:FindFirstChild("TitleBar")
        local h = header and header.AbsoluteSize.Y or 40
        root.Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, h)
    end
end

local function CollapseAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        toggleCollapse()
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

local function HideAction(_, state, input)
    if state == Enum.UserInputState.Begin then
        if not ScreenGui then
            local rf = getRootFrame()
            if rf then ScreenGui = findScreenGuiFrom(rf) end
        end
        if ScreenGui then ScreenGui.Enabled = not ScreenGui.Enabled end
        return Enum.ContextActionResult.Sink
    end
    return Enum.ContextActionResult.Pass
end

CAS:BindActionAtPriority("FluentRenewedCollapse", CollapseAction, false, 999999, Enum.KeyCode.Minus, Enum.KeyCode.KeypadMinus)
CAS:BindActionAtPriority("FluentRenewedHide", HideAction, false, 999999, Enum.KeyCode.RightControl)

return Library

]=]
}

local __BUNDLE_ROOT = {
["Src"] = {
    ["Components"] = {
        ["Assets"] = "Src/Components/Assets",
        ["Button"] = "Src/Components/Button",
        ["Dialog"] = "Src/Components/Dialog",
        ["Element"] = "Src/Components/Element",
        ["Notification"] = "Src/Components/Notification",
        ["Section"] = "Src/Components/Section",
        ["Tab"] = "Src/Components/Tab",
        ["Textbox"] = "Src/Components/Textbox",
        ["TitleBar"] = "Src/Components/TitleBar",
        ["Window"] = "Src/Components/Window"
        },
    ["Elements"] = {
        ["Button"] = "Src/Elements/Button",
        ["Colorpicker"] = "Src/Elements/Colorpicker",
        ["Dropdown"] = "Src/Elements/Dropdown",
        ["Input"] = "Src/Elements/Input",
        ["Keybind"] = "Src/Elements/Keybind",
        ["Paragraph"] = "Src/Elements/Paragraph",
        ["Slider"] = "Src/Elements/Slider",
        ["Toggle"] = "Src/Elements/Toggle",
        ["init"] = "Src/Elements/init"
        },
    ["Modules"] = {
        ["Acrylic"] = {
            ["AcrylicBlur"] = "Src/Modules/Acrylic/AcrylicBlur",
            ["AcrylicPaint"] = "Src/Modules/Acrylic/AcrylicPaint",
            ["CreateAcrylic"] = "Src/Modules/Acrylic/CreateAcrylic",
            ["Utils"] = "Src/Modules/Acrylic/Utils",
            ["init"] = "Src/Modules/Acrylic/init"
            },
        ["Creator"] = "Src/Modules/Creator"
        },
    ["init"] = "Src/init"
    }
}


local __CACHE = {}
local __ICONS_URL = "https://raw.githubusercontent.com/yaeteri64-rgb/Fluent-Angeryy/refs/heads/main/Icon/Icon.lua"
local __THEMES_URL = "https://raw.githubusercontent.com/yaeteri64-rgb/Fluent-Angeryy/refs/heads/main/Themes/Theme.lua"

local function __bundle_require_raw(path, env)
    local src = __MODULES[path]
    if not src then return nil, "missing" end
    local chunk, err = loadstring(src)
    if not chunk then error("compile error in "..path..": "..tostring(err)) end
    setfenv(chunk, env or getfenv(1))
    local ok, result = pcall(chunk)
    if not ok then error("runtime error in "..path..": "..tostring(result)) end
    return result
end

local function __fetch(url)
    if syn and syn.request then
        local res = syn.request({Url = url, Method = "GET"})
        if res and res.Body then return res.Body end
    end
    return game:HttpGet(url)
end

local function __icons_provider()
    local body = __fetch(__ICONS_URL)
    local chunk, err = loadstring(body)
    assert(chunk, "icons load error (PINNED): "..tostring(err))
    setfenv(chunk, getfenv(1))
    return chunk()
end

local function __themes_provider()
    local body = __fetch(__THEMES_URL)
    local chunk, err = loadstring(body)
    assert(chunk, "themes provider load error (PINNED): "..tostring(err))
    setfenv(chunk, getfenv(1))
    local mod = chunk()
    if type(mod) == "function" then
        return mod
    elseif type(mod) == "table" then
        -- Wrap common table styles: direct map, map without prefix, or methods
        return function(path)
            local v = mod[path]
                or mod[path:gsub("^Src/Themes/", "")]
                or (type(mod.Get) == "function" and mod.Get(path))
                or (type(mod.Provider) == "function" and mod.Provider(path))
            if type(v) == "string" then
                local f, e = loadstring(v)
                assert(f, "theme source compile error: "..tostring(e))
                setfenv(f, getfenv(1))
                return f()
            end
            return v
        end
    else
        error("themes provider must return function or table")
    end
end

local __ICONS = false
local function __get_icons()
    if not __ICONS then __ICONS = __icons_provider() end
    return __ICONS
end

local __THEMES = false
local function __get_theme(path)
    if not __THEMES then __THEMES = __themes_provider() end
    local v = __THEMES(path)
    return v
end

local __ORIG_REQUIRE = require
local function require(arg)
    if type(arg) == "string" then
        if __CACHE[arg] ~= nil then return __CACHE[arg] end
        local result, missing = __bundle_require_raw(arg)
        if missing == "missing" then
            if arg == "Src/Modules/Icons" then
                result = __get_icons()
            elseif string.sub(arg, 1, 11) == "Src/Themes/" then
                result = __get_theme(arg)
            else
                -- Optional: generic hook
                local g = (rawget(getfenv(), "getgenv") and getgenv()) or {}
                if type(g.FLUENT_REQUIRE) == "function" then
                    local ok, res = pcall(g.FLUENT_REQUIRE, arg)
                    if ok then result = res end
                end
            end
        end
        if result == nil then error("module not found: "..tostring(arg)) end
        __CACHE[arg] = result
        return result
    else
        return __ORIG_REQUIRE(arg)
    end
end


-- Entry
return __bundle_require_raw("Src/init")
