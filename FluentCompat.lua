-- Standalone UI Library (single-file, no external folders) -- API (returns table UI): --   local UI = loadstring(game:HttpGet("<raw>", true))() --   local win = UI:Window({ Title = "MyHub", SubTitle = "[Free]", Size = Vector2.new(520, 360), Theme = "Dark" }) --   local tab = win:Tab("Main") --   tab:Toggle("Auto Farm", false, function(on) print("auto:", on) end) --   tab:Slider("WalkSpeed", 16, 200, 16, function(v) print("ws:", v) end) --   tab:Dropdown("Mode", {"Legit","Rage"}, 1, function(idx, val) print(idx, val) end) --   tab:Textbox("Webhook", "", function(text) print(text) end) --   tab:Label("v1.0.0") --   tab:Badge("BETA") --   win:SetStatus("Ready")

-- Notes: -- - Supports collapse instead of full hide (click the "-" button). -- - Will parent to CoreGui (syn.protect_gui / gethui when available). -- - Minimal styles; tweak Palette below.

local TweenService = game:GetService("TweenService") local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local HttpService = game:GetService("HttpService")

local function getParent() local cg = game:GetService("CoreGui") local ok, hui = pcall(function() return gethui and gethui() end) local ok2, protect = pcall(function() return syn and syn.protect_gui end) local gui = Instance.new("ScreenGui") gui.Name = "StandaloneUILib_"..HttpService:GenerateGUID(false) gui.ResetOnSpawn = false if ok and hui then gui.Parent = hui elseif ok2 and protect then protect(gui) gui.Parent = cg else gui.Parent = cg end return gui end

local Palette = { Dark = { Bg = Color3.fromRGB(18, 18, 20), Panel = Color3.fromRGB(28, 28, 32), Stroke = Color3.fromRGB(60, 60, 68), Accent = Color3.fromRGB(90, 120, 255), Text = Color3.fromRGB(230, 232, 236), SubText = Color3.fromRGB(170, 174, 184), Hovered = Color3.fromRGB(38, 38, 44), }, Light = { Bg = Color3.fromRGB(245, 246, 248), Panel = Color3.fromRGB(255, 255, 255), Stroke = Color3.fromRGB(210, 214, 220), Accent = Color3.fromRGB(55, 125, 255), Text = Color3.fromRGB(30, 32, 36), SubText = Color3.fromRGB(95, 100, 110), Hovered = Color3.fromRGB(235, 238, 242), } }

-- Helpers local function round(n) return math.floor(n + 0.5) end local function tplay(i, goal, dt) return TweenService:Create(i, TweenInfo.new(dt or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal):Play() end local function mk(class, props, children) local o = Instance.new(class) for k,v in pairs(props or {}) do o[k]=v end for _,c in ipairs(children or {}) do c.Parent = o end return o end local function stroke(parent, col) return mk("UIStroke", {Color=col, Thickness=1, Transparency=0.3, Parent=parent}) end local function corner(parent, r) return mk("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent=parent}) end local function padding(parent, p) return mk("UIPadding", {PaddingLeft=UDim.new(0,p),PaddingRight=UDim.new(0,p),PaddingTop=UDim.new(0,p),PaddingBottom=UDim.new(0,p), Parent=parent}) end local function list(parent, fill, pad) return mk("UIListLayout", {FillDirection = Enum.FillDirection.Vertical, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, pad or 6), Parent = parent}) end local function hlist(parent, pad) return mk("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, pad or 6), Parent = parent}) end local function szcon(parent) return mk("UISizeConstraint", {Parent = parent, MinSize = Vector2.new(150, 0)}) end

-- Drag helper local function makeDrag(handle, target) local dragging, startPos, startInput handle.InputBegan:Connect(function(io) if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType == Enum.UserInputType.Touch then dragging = true startPos = target.Position startInput = io end end) handle.InputEnded:Connect(function(io) if io == startInput then dragging = false end end) UserInputService.InputChanged:Connect(function(io) if dragging and (io.UserInputType == Enum.UserInputType.MouseMovement or io.UserInputType == Enum.UserInputType.Touch) then local delta = io.Delta target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end

-- UI Library root local UI = {} UI._palette = Palette.Dark

function UI:Window(cfg) cfg = cfg or {} local Title = cfg.Title or "Window" local SubTitle = cfg.SubTitle or "" local Size = cfg.Size or Vector2.new(520, 360) local Theme = Palette[cfg.Theme or "Dark"] or Palette.Dark self._palette = Theme

local root = getParent()
local bg = mk("Frame", {
	Parent = root,
	BackgroundColor3 = Theme.Bg,
	Size = UDim2.new(1,0,1,0),
	Visible = true,
	Name = "Backdrop",
	BackgroundTransparency = 1
})

local win = mk("Frame", {
	Parent = root,
	Name = "Window",
	BackgroundColor3 = Theme.Panel,
	Size = UDim2.fromOffset(Size.X, Size.Y),
	Position = UDim2.new(0, 120, 0, 120)
})
corner(win, 12)
stroke(win, Theme.Stroke)

local top = mk("Frame", {
	Parent = win,
	Name = "TitleBar",
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -16, 0, 44),
	Position = UDim2.new(0, 8, 0, 8)
})
hlist(top, 8)

local title = mk("TextLabel", {
	Parent = top,
	Text = Title,
	TextColor3 = Theme.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -120, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Left
})
szcon(title)

local subtitle = mk("TextLabel", {
	Parent = top,
	Text = SubTitle,
	TextColor3 = Theme.SubText,
	Font = Enum.Font.Gotham,
	TextSize = 14,
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 120, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Right
})

local btns = mk("Frame", {Parent = top, BackgroundTransparency = 1, Size = UDim2.new(0, 60, 1, 0)})
hlist(btns, 6)

local collapseBtn = mk("TextButton", {Parent = btns, Text = "-", Font = Enum.Font.GothamBold, TextSize=16, TextColor3 = Theme.Text, BackgroundColor3 = Theme.Panel, Size = UDim2.new(0, 24, 0, 24)})
corner(collapseBtn, 6); stroke(collapseBtn, Theme.Stroke)
local closeBtn = mk("TextButton", {Parent = btns, Text = "x", Font = Enum.Font.GothamBold, TextSize=16, TextColor3 = Theme.Text, BackgroundColor3 = Theme.Panel, Size = UDim2.new(0, 24, 0, 24)})
corner(closeBtn, 6); stroke(closeBtn, Theme.Stroke)

local body = mk("Frame", {Parent = win, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 56), Size = UDim2.new(1, -16, 1, -64)})

local tabs = mk("Frame", {Parent = body, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32)})
hlist(tabs, 6)

local pages = mk("Frame", {Parent = body, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 36), Size = UDim2.new(1, 0, 1, -36)})
local pageLayout = mk("UIPageLayout", {Parent = pages, EasingStyle = Enum.EasingStyle.Quad, EasingDirection = Enum.EasingDirection.Out, TweenTime = 0.2, SortOrder = Enum.SortOrder.LayoutOrder, Circular = false})

local statusBar = mk("TextLabel", {Parent = win, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 1, -24), Size = UDim2.new(1, -24, 0, 16), Text = "", TextColor3=Theme.SubText, Font=Enum.Font.Gotham, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left})

makeDrag(top, win)

local collapsed = false
local fullSize = win.Size
local collapsedSize = UDim2.fromOffset(fullSize.X.Offset, 60)
collapseBtn.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	if collapsed then
		tplay(win, {Size = collapsedSize}, 0.18)
		body.Visible = false
		statusBar.Visible = false
	else
		body.Visible = true
		statusBar.Visible = true
		tplay(win, {Size = fullSize}, 0.18)
	end
end)
closeBtn.MouseButton1Click:Connect(function()
	win.Visible = false
end)

local WinAPI = {}
function WinAPI:SetStatus(text)
	statusBar.Text = tostring(text or "")
end

function WinAPI:Tab(name)
	name = tostring(name or "Tab")
	local tabBtn = mk("TextButton", {Parent = tabs, Text = name, Font = Enum.Font.Gotham, TextSize = 14, TextColor3=Theme.Text, BackgroundColor3 = Theme.Panel, AutoButtonColor = false, Size = UDim2.new(0, 100, 1, 0)})
	corner(tabBtn, 8); stroke(tabBtn, Theme.Stroke)
	tabBtn.MouseEnter:Connect(function() tplay(tabBtn, {BackgroundColor3 = Theme.Hovered}, 0.1) end)
	tabBtn.MouseLeave:Connect(function() tplay(tabBtn, {BackgroundColor3 = Theme.Panel}, 0.1) end)

	local page = mk("ScrollingFrame", {Parent = pages, Name = name, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 4})
	padding(page, 8); list(page, true, 8)

	local function select()
		for _,p in ipairs(pages:GetChildren()) do
			if p:IsA("ScrollingFrame") then p.Visible = (p == page) end
		end
		pageLayout:JumpTo(page)
	end
	tabBtn.MouseButton1Click:Connect(select)
	if #pages:GetChildren() == 1 then select() end

	local api = {}
	local function makeRow(h)
		local row = mk("Frame", {BackgroundColor3 = Theme.Panel, Size = UDim2.new(1, 0, 0, h or 36), Parent = page})
		corner(row, 8); stroke(row, Theme.Stroke); padding(row, 8)
		return row
	end

	function api:Label(text)
		local row = makeRow(28)
		mk("TextLabel", {Parent=row, BackgroundTransparency=1, Text=tostring(text or ""), TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1,0,1,0)})
	end

	function api:Badge(text)
		local row = makeRow(28)
		local lbl = mk("TextLabel", {Parent=row, BackgroundTransparency=1, Text=tostring(text or ""), TextColor3=Theme.Accent, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(0, 100, 1, 0)})
	end

	function api:Toggle(label, default, callback)
		local state = not not default
		local row = makeRow(36)
		mk("TextLabel", {Parent=row, BackgroundTransparency=1, Text=label or "Toggle", TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1, -60, 1, 0)})
		local btn = mk("TextButton", {Parent=row, Text = state and "ON" or "OFF", Font=Enum.Font.GothamBold, TextSize = 12, TextColor3 = state and Color3.new(1,1,1) or Theme.Text, BackgroundColor3 = state and Theme.Accent or Theme.Panel, Size = UDim2.new(0, 48, 0, 24), Position = UDim2.new(1, -56, 0.5, -12)})
		corner(btn, 6); stroke(btn, Theme.Stroke)
		local function set(v)
			state = not not v
			btn.Text = state and "ON" or "OFF"
			btn.BackgroundColor3 = state ? Theme.Accent : Theme.Panel
			if callback then task.spawn(callback, state) end
		end
		btn.MouseButton1Click:Connect(function() set(not state) end)
		return set
	end

	function api:Slider(label, min, max, default, callback)
		min = tonumber(min) or 0
		max = tonumber(max) or 100
		local val = math.clamp(tonumber(default) or min, min, max)
		local row = makeRow(44)
		mk("TextLabel", {Parent=row, BackgroundTransparency=1, Text=string.format("%s: %s", label or "Slider", tostring(val)), TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1, -20, 0, 20)})
		local bar = mk("Frame", {Parent=row, BackgroundColor3=Theme.Hovered, Size=UDim2.new(1, -16, 0, 6), Position=UDim2.new(0,8,0,26)})
		corner(bar, 3)
		local fill = mk("Frame", {Parent=bar, BackgroundColor3=Theme.Accent, Size=UDim2.new((val-min)/(max-min), 0, 1, 0)})
		corner(fill, 3)
		local dragging = false
		bar.InputBegan:Connect(function(io)
			if io.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
		end)
		UserInputService.InputEnded:Connect(function(io)
			if io.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
		end)
		UserInputService.InputChanged:Connect(function(io)
			if dragging and io.UserInputType == Enum.UserInputType.MouseMovement then
				local rel = math.clamp((io.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
				val = round(min + rel*(max-min))
				fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
				row:FindFirstChildOfClass("TextLabel").Text = string.format("%s: %s", label or "Slider", tostring(val))
				if callback then task.spawn(callback, val) end
			end
		end)
		return function(v)
			val = math.clamp(tonumber(v) or val, min, max)
			fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
			row:FindFirstChildOfClass("TextLabel").Text = string.format("%s: %s", label or "Slider", tostring(val))
			if callback then task.spawn(callback, val) end
		end
	end

	function api:Dropdown(label, options, defaultIndex, callback)
		options = options or {}
		local index = tonumber(defaultIndex) or 1
		index = math.clamp(index, 1, math.max(1, #options))
		local row = makeRow(36)
		local lbl = mk("TextLabel", {Parent=row, BackgroundTransparency=1, Text=label or "Dropdown", TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1, -120, 1, 0)})
		local btn = mk("TextButton", {Parent=row, Text = tostring(options[index] or "-"), Font = Enum.Font.Gotham, TextSize=13, TextColor3=Theme.Text, BackgroundColor3 = Theme.Panel, AutoButtonColor=false, Size = UDim2.new(0, 120, 0, 24), Position = UDim2.new(1, -128, 0.5, -12)})
		corner(btn, 6); stroke(btn, Theme.Stroke)
		btn.MouseButton1Click:Connect(function()
			index = (index % #options) + 1
			btn.Text = tostring(options[index] or "-")
			if callback then task.spawn(callback, index, options[index]) end
		end)
		return function(i)
			index = math.clamp(tonumber(i) or index, 1, math.max(1,#options))
			btn.Text = tostring(options[index] or "-")
			if callback then task.spawn(callback, index, options[index]) end
		end
	end

	function api:Textbox(label, default, callback)
		local text = tostring(default or "")
		local row = makeRow(36)
		mk("TextLabel", {Parent=row, BackgroundTransparency=1, Text=label or "Textbox", TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Size=UDim2.new(1, -200, 1, 0)})
		local box = mk("TextBox", {Parent=row, Text = text, PlaceholderText = "enter...", ClearTextOnFocus=false, Font=Enum.Font.Gotham, TextSize=13, TextColor3=Theme.Text, BackgroundColor3 = Theme.Panel, Size = UDim2.new(0, 200, 0, 24), Position = UDim2.new(1, -208, 0.5, -12)})
		corner(box, 6); stroke(box, Theme.Stroke)
		box.FocusLost:Connect(function(enter)
			text = box.Text
			if callback then task.spawn(callback, text, enter) end
		end)
		return function(v)
			text = tostring(v)
			box.Text = text
			if callback then task.spawn(callback, text) end
		end
	end

	return api
end

return WinAPI

end

return UI

