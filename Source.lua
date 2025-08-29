-- MyUILib.lua — single-file UI library (executor-ready)
local UIS, TS, Players = game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("Players")

local function guiParent()
    if gethui then return gethui() end
    local cg = game:FindFirstChildOfClass("CoreGui")
    if cg then return cg end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local Update = {}; Update.__index = Update

function Update:Window(cfg)
    cfg = cfg or {}
    local win = setmetatable({}, self)
    win._title   = cfg.Title or "MyHub"
    win._subtitle= cfg.SubTitle
    win._size    = cfg.Size or UDim2.new(0, 585, 0, 420)
    win._collapsed = false

    -- Root
    local gui = Instance.new("ScreenGui")
    gui.Name = "MyUILib"; gui.ResetOnSpawn = false; gui.Parent = guiParent()

    local frame = Instance.new("Frame")
    frame.Name="Window"; frame.Size = win._size
    frame.Position = UDim2.new(0.5, -win._size.X.Offset/2, 0.5, -win._size.Y.Offset/2)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,24); frame.BorderSizePixel = 0; frame.Parent = gui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

    local title = Instance.new("TextLabel")
    title.Name="Title"; title.BackgroundTransparency=1
    title.Size=UDim2.new(1,-40,0,36); title.Position=UDim2.new(0,12,0,6)
    title.Font=Enum.Font.GothamBold; title.TextSize=18; title.TextXAlignment=Enum.TextXAlignment.Left
    title.TextColor3=Color3.new(1,1,1)
    title.Text = win._subtitle and (win._title.." "..win._subtitle) or win._title
    title.Parent=frame

    local collapseBtn = Instance.new("TextButton")
    collapseBtn.Name="Collapse"; collapseBtn.AnchorPoint=Vector2.new(1,0)
    collapseBtn.Size=UDim2.new(0,28,0,28); collapseBtn.Position=UDim2.new(1,-6,0,6)
    collapseBtn.Text="-"; collapseBtn.AutoButtonColor=false
    collapseBtn.BackgroundColor3=Color3.fromRGB(34,34,38); collapseBtn.Parent=frame
    Instance.new("UICorner", collapseBtn).CornerRadius = UDim.new(0,8)

    -- Tabs bar
    local tabBar = Instance.new("Frame")
    tabBar.Name="TabBar"; tabBar.Size=UDim2.new(0,140,1,-48); tabBar.Position=UDim2.new(0,0,0,48)
    tabBar.BackgroundTransparency=1; tabBar.Parent=frame
    local tabList = Instance.new("UIListLayout", tabBar); tabList.Padding = UDim.new(0,6)

    -- Content
    local content = Instance.new("Frame")
    content.Name="Content"; content.Size=UDim2.new(1,-150,1,-60); content.Position=UDim2.new(0,150,0,48)
    content.BackgroundTransparency=1; content.Parent=frame

    local currentPage

    local function selectPage(pg)
        if currentPage then currentPage.Visible=false end
        currentPage = pg; currentPage.Visible=true
    end

    function win:Tab(name)
        name = name or "Tab"
        local btn = Instance.new("TextButton")
        btn.Size=UDim2.new(1,-12,0,32); btn.Position=UDim2.new(0,6,0,0)
        btn.BackgroundColor3=Color3.fromRGB(34,34,38); btn.AutoButtonColor=false
        btn.Text=name; btn.Font=Enum.Font.Gotham; btn.TextSize=14; btn.TextColor3=Color3.fromRGB(220,220,220)
        Instance.new("UICorner", btn).CornerRadius=UDim.new(0,8); btn.Parent=tabBar

        local page = Instance.new("ScrollingFrame")
        page.Name="Page_"..name; page.Size=UDim2.new(1,0,1,0); page.Visible=false
        page.CanvasSize=UDim2.new(0,0,0,0); page.ScrollBarThickness=4; page.Parent=content
        local layout = Instance.new("UIListLayout", page); layout.Padding=UDim.new(0,8)

        if not currentPage then selectPage(page) end
        btn.MouseButton1Click:Connect(function() selectPage(page) end)
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0,0,0, layout.AbsoluteContentSize.Y + 12)
        end)

        local tab = {}

        function tab:Toggle(label, default, _, callback)
            default = default or false
            local row = Instance.new("Frame")
            row.Name="Toggle_"..(label or "Toggle"); row.Size=UDim2.new(1,-6,0,34)
            row.BackgroundColor3=Color3.fromRGB(28,28,32); row.Parent=page
            Instance.new("UICorner", row).CornerRadius=UDim.new(0,8)

            local txt = Instance.new("TextLabel")
            txt.BackgroundTransparency=1; txt.Size=UDim2.new(1,-44,1,0); txt.Position=UDim2.new(0,12,0,0)
            txt.Font=Enum.Font.Gotham; txt.TextSize=14; txt.TextXAlignment=Enum.TextXAlignment.Left
            txt.TextColor3=Color3.fromRGB(230,230,230); txt.Text=label or "Toggle"; txt.Parent=row

            local knob = Instance.new("TextButton")
            knob.AnchorPoint=Vector2.new(1,0.5); knob.Position=UDim2.new(1,-10,0.5,0); knob.Size=UDim2.new(0,26,0,26)
            knob.Text=""; knob.AutoButtonColor=false; knob.Parent=row
            Instance.new("UICorner", knob).CornerRadius=UDim.new(0,13)

            local state = default
            local function apply(v)
                state = v
                knob.BackgroundColor3 = v and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,66)
                if callback then task.spawn(callback, v) end
            end
            knob.MouseButton1Click:Connect(function() apply(not state) end)
            apply(default)
            return { Set=apply, Get=function() return state end, Instance=row }
        end

        -- Ví dụ control mới: Badge (pill text)
        function tab:Badge(text)
            local badge = Instance.new("TextLabel")
            badge.Name="Badge_"..(text or "Badge")
            badge.Size=UDim2.new(0,90,0,24); badge.BackgroundColor3=Color3.fromRGB(45,45,52)
            badge.Text=text or "Badge"; badge.Font=Enum.Font.GothamMedium; badge.TextSize=12
            badge.TextColor3=Color3.fromRGB(255,255,255); badge.Parent=page
            Instance.new("UICorner", badge).CornerRadius = UDim.new(1,0)
            return badge
        end

        return tab
    end

    -- Collapse thay vì ẩn toàn bộ
    local fullSize = frame.Size
    local collapsedSize = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 44)
    local function setCollapsed(v)
        win._collapsed = v
        TS:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Size = v and collapsedSize or fullSize
        }):Play()
        tabBar.Visible = not v
        content.Visible = not v
        collapseBtn.Text = v and "+" or "-"
    end
    collapseBtn.MouseButton1Click:Connect(function() setCollapsed(not win._collapsed) end)
    UIS.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == Enum.KeyCode.Minus then
            setCollapsed(not win._collapsed)
        end
    end)

    win._gui, win._frame = gui, frame
    return win
end

return setmetatable({}, Update)
