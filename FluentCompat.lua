-- FluentCompat.lua — Drop‑in UI compatible layer for Fluent (single file, executor-ready)
-- Public API (subset):
--   local Fluent = require(...) or loadstring(... )()
--   local win = Fluent:CreateWindow{ Title, SubTitle, Size, TabWidth, MinimizeKey }
--   local tab = win:AddTab("Main")
--   tab:AddToggle("Auto", { Text="Auto", Default=false }, function(on) end)
--   tab:AddSlider("Speed", { Text="Speed", Default=16, Min=0, Max=100, Rounding=0 }, function(v) end)
--   tab:AddInput("Chat", { Text="Chat", Placeholder="..." }, function(text) end)
--   tab:AddDropdown("Mode", { Text="Mode", Values={"A","B"}, Default=1, Multi=false }, function(value) end)
--   tab:AddButton("Run", function() end)
--   win:Minimize()  -- collapse instead of hide
-- Notes:
--  • This is a clean-room compatibility shim (not the upstream code). Styling is close enough for continuity.
--  • Events & internals may differ from upstream; public shapes are preserved so existing scripts keep working.

local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local TS      = game:GetService("TweenService")
local Run     = game:GetService("RunService")

local function getParent()
    if typeof(gethui)=="function" then
        local ok, ui = pcall(gethui)
        if ok and ui then return ui end
    end
    local cg = game:FindFirstChildOfClass("CoreGui")
    if cg then return cg end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function new(inst, props, children)
    local o = Instance.new(inst)
    if props then for k,v in pairs(props) do o[k]=v end end
    if children then for _,c in ipairs(children) do c.Parent = o end end
    return o
end

local function ripple(btn)
    -- lightweight press feedback
    btn.MouseButton1Down:Connect(function()
        btn.AutoButtonColor = false
        TS:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0.15}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TS:Create(btn, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
    end)
end

local Fluent = {}; Fluent.__index = Fluent

local function prettify(key)
    if typeof(key)=="EnumItem" then return key.Name end
    return tostring(key)
end

function Fluent:CreateWindow(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, {__index = Fluent})
    self.Title      = cfg.Title or "Fluent"
    self.SubTitle   = cfg.SubTitle or ""
    self.Size       = cfg.Size or UDim2.fromOffset(830, 525)
    self.TabWidth   = math.clamp(tonumber(cfg.TabWidth) or 150, 110, 240)
    self.MinimizeKey= cfg.MinimizeKey or Enum.KeyCode.RightControl
    self._tabs      = {}
    self._selected  = nil
    self.Minimized  = false

    -- root
    local gui = new("ScreenGui", {
        Name="FluentCompatGUI", ResetOnSpawn=false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = getParent()
    })
    local root = new("Frame", {
        Name="Root", Size=self.Size, Position=UDim2.new(0.5,-self.Size.X.Offset/2, 0.5,-self.Size.Y.Offset/2),
        BackgroundColor3=Color3.fromRGB(22,22,26), BorderSizePixel=0, Parent=gui
    }, {
        new("UICorner", {CornerRadius=UDim.new(0,12)}),
        new("UIStroke", {Color=Color3.fromRGB(54,54,64), Thickness=1, Transparency=0.25})
    })

    -- title bar
    local titleBar = new("Frame", {
        Name="TitleBar", Size=UDim2.new(1,0,0,42), BackgroundColor3=Color3.fromRGB(28,28,34), BorderSizePixel=0, Parent=root
    }, {
        new("UICorner", {CornerRadius=UDim.new(0,12)}),
        new("UIStroke", {Color=Color3.fromRGB(60,60,70), Thickness=1, Transparency=0.5})
    })
    local title = new("TextLabel", {
        BackgroundTransparency=1, Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-140,1,0),
        Font=Enum.Font.GothamBold, Text= self.SubTitle~="" and (self.Title.." • "..self.SubTitle) or self.Title,
        TextColor3=Color3.fromRGB(236,236,236), TextSize=16, TextXAlignment=Enum.TextXAlignment.Left, Parent=titleBar
    })
    local minimizeBtn = new("TextButton", {
        Name="Minimize", AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
        Size=UDim2.fromOffset(28,28), Text="-", Font=Enum.Font.GothamBold, TextSize=18, TextColor3=Color3.new(1,1,1),
        AutoButtonColor=false, BackgroundColor3=Color3.fromRGB(40,40,48), Parent=titleBar
    }, { new("UICorner", {CornerRadius=UDim.new(0,8)}) })
    ripple(minimizeBtn)

    -- left tab bar
    local tabBar = new("ScrollingFrame", {
        Name="TabBar", Position=UDim2.fromOffset(8,50), Size=UDim2.new(0,self.TabWidth,1,-58),
        BackgroundTransparency=1, ScrollBarThickness=4, Parent=root
    }, { new("UIListLayout", {Padding=UDim.new(0,6)}) })

    -- content area
    local content = new("Frame", {
        Name="Content", Position=UDim2.fromOffset(self.TabWidth+18,50), Size=UDim2.new(1,-(self.TabWidth+26),1,-58),
        BackgroundTransparency=1, Parent=root
    })

    -- notify (simple toast)
    local toastHolder = new("Frame", {
        Name="ToastHolder", AnchorPoint=Vector2.new(1,1), Position=UDim2.new(1,-12,1,-12),
        Size=UDim2.fromOffset(320, 220), BackgroundTransparency=1, Parent=root
    })

    function self:Notify(opt)
        opt = opt or {}
        local card = new("Frame", {
            Size=UDim2.new(1,0,0,48), BackgroundColor3=Color3.fromRGB(34,34,42), Parent=toastHolder
        }, { new("UICorner", {CornerRadius=UDim.new(0,8)}), new("UIStroke", {Color=Color3.fromRGB(64,64,74), Transparency=0.35}) })
        local l1 = new("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(10,6), Size=UDim2.new(1,-20,0,18),
            Font=Enum.Font.GothamBold, Text= opt.Title or "Notice", TextColor3=Color3.fromRGB(240,240,240), TextSize=14, TextXAlignment=Enum.TextXAlignment.Left, Parent=card })
        local l2 = new("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(10,24), Size=UDim2.new(1,-20,0,18),
            Font=Enum.Font.Gotham, Text= opt.Content or "", TextColor3=Color3.fromRGB(220,220,220), TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, Parent=card })
        card.Position = UDim2.new(1,0,1,12)
        card.Visible = true
        TS:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {Position=UDim2.new(1,0,1,-60)}):Play()
        task.delay( (tonumber(opt.Time) or 4) , function()
            TS:Create(card, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {Position=UDim2.new(1,0,1,12)}):Play()
            task.delay(0.2, function() card:Destroy() end)
        end)
    end

    -- tab creation
    local currentPage

    local function selectPage(pg)
        if currentPage then currentPage.Visible=false end
        currentPage = pg; currentPage.Visible=true
    end

    function self:AddTab(name)
        name = name or "Tab"
        local btn = new("TextButton", {
            Size=UDim2.new(1,-12,0,32), BackgroundColor3=Color3.fromRGB(36,36,44),
            BorderSizePixel=0, AutoButtonColor=false, Text=name, Font=Enum.Font.Gotham, TextSize=14,
            TextColor3=Color3.fromRGB(220,220,220), Parent=tabBar
        }, { new("UICorner", {CornerRadius=UDim.new(0,8)}) })
        ripple(btn)

        local page = new("ScrollingFrame", {
            Name="Page_"..name, Size=UDim2.new(1,0,1,0), CanvasSize=UDim2.fromOffset(0,0),
            ScrollBarThickness=4, Visible=false, BackgroundTransparency=1, Parent=content
        }, { new("UIListLayout", {Padding=UDim.new(0,8)}) })

        if not currentPage then selectPage(page) end
        btn.MouseButton1Click:Connect(function() selectPage(page) end)

        page.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0,page.UIListLayout.AbsoluteContentSize.Y+12)
        end)

        local tab = {}
        local function rowBase(height)
            return new("Frame", {Size=UDim2.new(1,-6,0,height), BackgroundColor3=Color3.fromRGB(28,28,34), Parent=page},
                { new("UICorner", {CornerRadius=UDim.new(0,8)}), new("UIStroke", {Color=Color3.fromRGB(54,54,64), Transparency=0.35}) })
        end

        function tab:AddButton(text, callback)
            local row = rowBase(34)
            local btn2 = new("TextButton", {
                BackgroundTransparency=1, Size=UDim2.new(1,0,1,0), Text = text or "Button",
                Font=Enum.Font.Gotham, TextSize=14, TextColor3=Color3.fromRGB(235,235,235), Parent=row
            })
            ripple(btn2)
            btn2.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
            return row
        end

        function tab:AddToggle(id, opt, callback)
            -- supports signatures: (label, default, _, cb) or (id, {Text=..., Default=...}, cb)
            if type(opt) ~= "table" then
                -- legacy signature
                opt = { Text = id or "Toggle", Default = opt and true or false }
                id = tostring(id or "Toggle")
            else
                id = tostring(id or (opt.Text or "Toggle"))
            end
            local row = rowBase(34)
            local txt = new("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-48,1,0),
                Font=Enum.Font.Gotham, Text=opt.Text or id, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left,
                TextColor3=Color3.fromRGB(235,235,235), Parent=row })
            local knob = new("TextButton", { AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0),
                Size=UDim2.fromOffset(26,26), BackgroundColor3=Color3.fromRGB(64,64,72), AutoButtonColor=false, Text="", Parent=row},
                { new("UICorner", {CornerRadius=UDim.new(0,13)}) })
            ripple(knob)
            local state = opt.Default == true
            local function apply(v)
                state = v and true or false
                TS:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Sine), {
                    BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(64,64,72)
                }):Play()
                if callback then task.spawn(callback, state) end
            end
            knob.MouseButton1Click:Connect(function() apply(not state) end)
            apply(state)
            return { Set=function(v) apply(v) end, Get=function() return state end, Instance=row }
        end

        function tab:AddSlider(id, opt, callback)
            if type(opt) ~= "table" then
                opt = { Text = id or "Slider", Default = tonumber(opt) or 0, Min=0, Max=100, Rounding=0 }
                id = tostring(id or "Slider")
            else
                id = tostring(id or (opt.Text or "Slider"))
            end
            local min = tonumber(opt.Min) or 0
            local max = tonumber(opt.Max) or 100
            local round = tonumber(opt.Rounding) or 0
            local val = math.clamp(tonumber(opt.Default) or min, min, max)

            local row = rowBase(42)
            local lbl = new("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(12,2), Size=UDim2.new(1,-120,0,18),
                Font=Enum.Font.Gotham, Text=opt.Text or id, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left,
                TextColor3=Color3.fromRGB(235,235,235), Parent=row })
            local valueLbl = new("TextLabel", {BackgroundTransparency=1, AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-12,0,2), Size=UDim2.fromOffset(80,18),
                Font=Enum.Font.Gotham, Text="", TextSize=13, TextXAlignment=Enum.TextXAlignment.Right,
                TextColor3=Color3.fromRGB(220,220,220), Parent=row })
            local bar = new("Frame", {Position=UDim2.fromOffset(12,24), Size=UDim2.new(1,-24,0,10),
                BackgroundColor3=Color3.fromRGB(40,40,48), Parent=row }, { new("UICorner", {CornerRadius=UDim.new(0,6)}) })
            local fill = new("Frame", {Size=UDim2.fromScale(0,1), BackgroundColor3=Color3.fromRGB(0,170,0), Parent=bar },
                { new("UICorner", {CornerRadius=UDim.new(0,6)}) })

            local dragging=false
            local function fmt(x)
                if round and round>0 then
                    local m = 10^round
                    x = math.floor(x*m + 0.5)/m
                else
                    x = math.floor(x + 0.5)
                end
                return x
            end
            local function setValue(x)
                x = math.clamp(x, min, max)
                val = x
                local pct = (x-min)/(max-min)
                fill.Size = UDim2.fromScale(pct, 1)
                valueLbl.Text = tostring(fmt(x))
                if callback then task.spawn(callback, x) end
            end

            bar.InputBegan:Connect(function(io)
                if io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType==Enum.UserInputType.Touch then
                    dragging = true
                    local rel = (io.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
                    setValue(min + (max-min)*rel)
                end
            end)
            UIS.InputChanged:Connect(function(io)
                if dragging and (io.UserInputType==Enum.UserInputType.MouseMovement or io.UserInputType==Enum.UserInputType.Touch) then
                    local rel = (io.Position.X - bar.AbsolutePosition.X)/math.max(1, bar.AbsoluteSize.X)
                    setValue(min + (max-min)*rel)
                end
            end)
            UIS.InputEnded:Connect(function(io)
                if dragging and (io.UserInputType == Enum.UserInputType.MouseButton1 or io.UserInputType==Enum.UserInputType.Touch) then
                    dragging = false
                end
            end)

            setValue(val)
            return { Set=setValue, Get=function() return val end, Instance=row }
        end

        function tab:AddInput(id, opt, callback)
            if type(opt) ~= "table" then
                opt = { Text = id or "Input", Default = "" }
                id = tostring(id or "Input")
            else
                id = tostring(id or (opt.Text or "Input"))
            end
            local row = rowBase(36)
            local lbl = new("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(12,0), Size=UDim2.new(0,140,1,0),
                Font=Enum.Font.Gotham, Text=opt.Text or id, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left,
                TextColor3=Color3.fromRGB(235,235,235), Parent=row })
            local box = new("TextBox", {AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.fromOffset(200,26),
                Font=Enum.Font.Gotham, Text=opt.Default or "", PlaceholderText = opt.Placeholder or "",
                TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Color3.fromRGB(22,22,22),
                BackgroundColor3=Color3.fromRGB(240,240,240), ClearTextOnFocus=false, Parent=row }, { new("UICorner", {CornerRadius=UDim.new(0,6)}) })
            box.FocusLost:Connect(function(enter)
                if callback then task.spawn(callback, box.Text) end
            end)
            return { Set=function(t) box.Text=t end, Get=function() return box.Text end, Instance=row }
        end

        function tab:AddDropdown(id, opt, callback)
            if type(opt) ~= "table" then
                opt = { Text=id or "Dropdown", Values={}, Default=1, Multi=false }
                id = tostring(id or "Dropdown")
            else
                id = tostring(id or (opt.Text or "Dropdown"))
            end
            local values = opt.Values or {}
            local idx = tonumber(opt.Default) or 1
            if idx < 1 or idx > #values then idx = 1 end
            local row = rowBase(36)
            local lbl = new("TextLabel", {BackgroundTransparency=1, Position=UDim2.fromOffset(12,0), Size=UDim2.new(0,140,1,0),
                Font=Enum.Font.Gotham, Text=opt.Text or id, TextSize=14, TextXAlignment=Enum.TextXAlignment.Left,
                TextColor3=Color3.fromRGB(235,235,235), Parent=row })
            local btn = new("TextButton", {AnchorPoint=Vector2.new(1,0.5), Position=UDim2.new(1,-10,0.5,0), Size=UDim2.fromOffset(200,26),
                Font=Enum.Font.Gotham, Text="", TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, TextColor3=Color3.fromRGB(240,240,240),
                BackgroundColor3=Color3.fromRGB(40,40,48), AutoButtonColor=false, Parent=row }, { new("UICorner", {CornerRadius=UDim.new(0,6)}) })
            local currentVal = values[idx]
            btn.Text = currentVal and tostring(currentVal) or "—"
            ripple(btn)

            local open=false
            local list = new("Frame", {Visible=false, AnchorPoint=Vector2.new(1,0), Position=UDim2.new(1,-10,0,36),
                BackgroundColor3=Color3.fromRGB(32,32,40), Size=UDim2.fromOffset(200, (#values*26)+10 ), Parent=row}, {
                    new("UICorner", {CornerRadius=UDim.new(0,6)}),
                    new("UIStroke", {Color=Color3.fromRGB(60,60,70), Transparency=0.35}),
                    new("UIListLayout", {Padding=UDim.new(0,4)})
                })
            for i,v in ipairs(values) do
                local it = new("TextButton",{Size=UDim2.new(1,-8,0,22), Position=UDim2.fromOffset(4,0),
                    BackgroundColor3=Color3.fromRGB(38,38,46), AutoButtonColor=false, Text=tostring(v),
                    Font=Enum.Font.Gotham, TextSize=13, TextColor3=Color3.fromRGB(235,235,235), Parent=list}, { new("UICorner", {CornerRadius=UDim.new(0,6)}) })
                ripple(it)
                it.MouseButton1Click:Connect(function()
                    currentVal = v; idx = i
                    btn.Text = tostring(v)
                    list.Visible=false; open=false
                    if callback then task.spawn(callback, v) end
                end)
            end

            btn.MouseButton1Click:Connect(function()
                open = not open
                list.Visible = open
            end)

            return { Set=function(v)
                        local iFound
                        for i,val in ipairs(values) do if val==v then iFound=i break end end
                        if iFound then idx=iFound; currentVal=v; btn.Text=tostring(v); if callback then task.spawn(callback, v) end end
                    end,
                     Get=function() return currentVal end, Instance=row }
        end

        table.insert(self._tabs, {Button=btn, Page=page})
        return tab
    end

    -- collapse instead of hide
    local fullSize = root.Size
    local collapsedSize = UDim2.fromOffset(fullSize.X.Offset, 44)
    local anim = TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
    function self:Minimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            tabBar.Visible=false; content.Visible=false
            TS:Create(root, anim, {Size = collapsedSize}):Play()
        else
            TS:Create(root, anim, {Size = fullSize}):Play()
            task.delay(0.18, function() tabBar.Visible=true; content.Visible=true end)
        end
    end

    minimizeBtn.MouseButton1Click:Connect(function() self:Minimize() end)
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self.MinimizeKey then self:Minimize() end
    end)

    -- public handles
    self.Root = root
    self.TitleBar = titleBar
    self.TabHolder = tabBar
    self.ContainerCanvas = content
    self.Notify = self.Notify

    return self
end

return setmetatable({}, Fluent)
