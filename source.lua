-- ========================================================
-- ADVANCED RAYFIELD-STYLE UI LIBRARY ENGINE
-- ========================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local Library = {
    Flags = {},
    Theme = {
        MainBg = Color3.fromRGB(15, 16, 22),
        SidebarBg = Color3.fromRGB(20, 22, 30),
        ElementBg = Color3.fromRGB(26, 28, 38),
        ElementHover = Color3.fromRGB(34, 37, 50),
        Accent = Color3.fromRGB(99, 102, 241),
        Text = Color3.fromRGB(245, 247, 250),
        SubText = Color3.fromRGB(140, 145, 160),
        Border = Color3.fromRGB(38, 42, 56)
    }
}

-- Notification System
function Library:Notify(config)
    local NotificationHolder = CoreGui:FindFirstChild("RayfieldNotifyHolder")
    if not NotificationHolder then
        NotificationHolder = Instance.new("ScreenGui")
        NotificationHolder.Name = "RayfieldNotifyHolder"
        NotificationHolder.Parent = CoreGui
        
        local HolderFrame = Instance.new("Frame")
        HolderFrame.Name = "Container"
        HolderFrame.Size = UDim2.new(0, 300, 1, -20)
        HolderFrame.Position = UDim2.new(1, -310, 0, 10)
        HolderFrame.BackgroundTransparency = 1
        HolderFrame.Parent = NotificationHolder

        local List = Instance.new("UIListLayout")
        List.VerticalAlignment = Enum.VerticalAlignment.Bottom
        List.Padding = UDim.new(0, 8)
        List.Parent = HolderFrame
    end

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(1, 0, 0, 60)
    NotifyFrame.BackgroundColor3 = Library.Theme.ElementBg
    NotifyFrame.Parent = NotificationHolder.Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifyFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Library.Theme.Accent
    Stroke.Thickness = 1
    Stroke.Parent = NotifyFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 22)
    Title.Position = UDim2.new(0, 10, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = config.Title or "Notification"
    Title.TextColor3 = Library.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = NotifyFrame

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -20, 0, 20)
    Desc.Position = UDim2.new(0, 10, 0, 30)
    Desc.BackgroundTransparency = 1
    Desc.Text = config.Content or ""
    Desc.TextColor3 = Library.Theme.SubText
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 12
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = NotifyFrame

    task.delay(config.Duration or 3, function()
        TweenService:Create(NotifyFrame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
        TweenService:Create(Desc, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
        task.wait(0.3)
        NotifyFrame:Destroy()
    end)
end

-- Create Window
function Library:CreateWindow(config)
    local Window = { ActiveTab = nil }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "Custom_UI_Suite"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local Main = Instance.new("Frame")
    Main.Size = UDim2.fromOffset(560, 380)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Library.Theme.MainBg
    Main.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Library.Theme.Border
    MainStroke.Thickness = 1
    MainStroke.Parent = Main

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.SidebarBg
    Sidebar.Parent = Main

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 10)
    SidebarCorner.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 45)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name or "Hub Interface"
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(1, 0, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer

    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.Parent = TabContainer

    local PagesFolder = Instance.new("Folder")
    PagesFolder.Name = "Pages"
    PagesFolder.Parent = Main

    -- Dragging Logic
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Create Tab Method
    function Window:CreateTab(tabName)
        local Tab = {}

        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 34)
        TabBtn.BackgroundColor3 = Library.Theme.SidebarBg
        TabBtn.Text = tabName
        TabBtn.TextColor3 = Library.Theme.SubText
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = TabContainer

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabBtn

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, -175, 1, -20)
        Page.Position = UDim2.new(0, 168, 0, 10)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Library.Theme.Border
        Page.Parent = PagesFolder

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 8)
        PageList.Parent = Page

        TabBtn.MouseButton1Click:Connect(function()
            if Window.ActiveTab then
                Window.ActiveTab.Page.Visible = false
                TweenService:Create(Window.ActiveTab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Library.Theme.SidebarBg,
                    TextColor3 = Library.Theme.SubText
                }):Play()
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.Theme.ElementBg,
                TextColor3 = Library.Theme.Text
            }):Play()
            Window.ActiveTab = { Page = Page, Button = TabBtn }
        end)

        if not Window.ActiveTab then
            Page.Visible = true
            TabBtn.BackgroundColor3 = Library.Theme.ElementBg
            TabBtn.TextColor3 = Library.Theme.Text
            Window.ActiveTab = { Page = Page, Button = TabBtn }
        end

        -- 1. BUTTON
        function Tab:CreateButton(btnConfig)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -6, 0, 38)
            Button.BackgroundColor3 = Library.Theme.ElementBg
            Button.Text = btnConfig.Name or "Button"
            Button.TextColor3 = Library.Theme.Text
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 13
            Button.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Button

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Library.Theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = Button

            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), { BackgroundColor3 = Library.Theme.Accent }):Play()
                task.delay(0.1, function()
                    TweenService:Create(Button, TweenInfo.new(0.15), { BackgroundColor3 = Library.Theme.ElementBg }):Play()
                end)
                if btnConfig.Callback then task.spawn(btnConfig.Callback) end
            end)
        end

        -- 2. TOGGLE
        function Tab:CreateToggle(toggleConfig)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -6, 0, 38)
            ToggleFrame.BackgroundColor3 = Library.Theme.ElementBg
            ToggleFrame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ToggleFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Library.Theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = toggleConfig.Name or "Toggle"
            Label.TextColor3 = Library.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.fromOffset(36, 20)
            Switch.Position = UDim2.new(1, -44, 0.5, -10)
            Switch.BackgroundColor3 = toggleConfig.Default and Library.Theme.Accent or Library.Theme.SidebarBg
            Switch.Parent = ToggleFrame

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Knob = Instance.new("Frame")
            Knob.Size = UDim2.fromOffset(14, 14)
            Knob.Position = toggleConfig.Default and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
            Knob.BackgroundColor3 = Library.Theme.Text
            Knob.Parent = Switch

            local KnobCorner = Instance.new("UICorner")
            KnobCorner.CornerRadius = UDim.new(1, 0)
            KnobCorner.Parent = Knob

            local state = toggleConfig.Default or false
            local Clickable = Instance.new("TextButton")
            Clickable.Size = UDim2.fromScale(1, 1)
            Clickable.BackgroundTransparency = 1
            Clickable.Text = ""
            Clickable.Parent = ToggleFrame

            Clickable.MouseButton1Click:Connect(function()
                state = not state
                if toggleConfig.Flag then Library.Flags[toggleConfig.Flag] = state end
                TweenService:Create(Switch, TweenInfo.new(0.15), {
                    BackgroundColor3 = state and Library.Theme.Accent or Library.Theme.SidebarBg
                }):Play()
                TweenService:Create(Knob, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
                }):Play()
                if toggleConfig.Callback then task.spawn(function() toggleConfig.Callback(state) end) end
            end)
        end

        -- 3. SLIDER
        function Tab:CreateSlider(sliderConfig)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -6, 0, 50)
            SliderFrame.BackgroundColor3 = Library.Theme.ElementBg
            SliderFrame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SliderFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Library.Theme.Border
            Stroke.Thickness = 1
            Stroke.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.BackgroundTransparency = 1
            Label.Text = (sliderConfig.Name or "Slider") .. ": " .. tostring(sliderConfig.CurrentValue or sliderConfig.Range[1])
            Label.TextColor3 = Library.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local Track = Instance.new("Frame")
            Track.Size = UDim2.new(1, -24, 0, 6)
            Track.Position = UDim2.new(0, 12, 0, 32)
            Track.BackgroundColor3 = Library.Theme.SidebarBg
            Track.Parent = SliderFrame

            local TrackCorner = Instance.new("UICorner")
            TrackCorner.CornerRadius = UDim.new(1, 0)
            TrackCorner.Parent = Track

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.fromScale(((sliderConfig.CurrentValue or sliderConfig.Range[1]) - sliderConfig.Range[1]) / (sliderConfig.Range[2] - sliderConfig.Range[1]), 1)
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.Parent = Track

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill
        end

        -- 4. KEYBIND
        function Tab:CreateKeybind(keyConfig)
            local KeyFrame = Instance.new("Frame")
            KeyFrame.Size = UDim2.new(1, -6, 0, 38)
            KeyFrame.BackgroundColor3 = Library.Theme.ElementBg
            KeyFrame.Parent = Page

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = KeyFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = keyConfig.Name or "Keybind"
            Label.TextColor3 = Library.Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = KeyFrame

            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.fromOffset(60, 24)
            BindBtn.Position = UDim2.new(1, -68, 0.5, -12)
            BindBtn.BackgroundColor3 = Library.Theme.SidebarBg
            BindBtn.Text = keyConfig.CurrentKeybind or "E"
            BindBtn.TextColor3 = Library.Theme.SubText
            BindBtn.Font = Enum.Font.GothamBold
            BindBtn.TextSize = 12
            BindBtn.Parent = KeyFrame

            local BindCorner = Instance.new("UICorner")
            BindCorner.CornerRadius = UDim.new(0, 4)
            BindCorner.Parent = BindBtn
        end

        return Tab
    end

    return Window
end

return Library
