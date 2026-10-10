-- Save this file on GitHub as myownlib.lua
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Library = {}

function Library:CreateWindow(config)
    local Window = {}
    
    -- Main ScreenGui setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "NexusUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- Container Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(550, 360)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 21, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Header Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name or "Nexus Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    -- Scrolling Area for Elements
    local ContentContainer = Instance.new("ScrollingFrame")
    ContentContainer.Size = UDim2.new(1, -30, 1, -55)
    ContentContainer.Position = UDim2.new(0, 15, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.ScrollBarThickness = 3
    ContentContainer.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 8)
    Layout.Parent = ContentContainer

    -- Make UI Draggable
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Tab Builder Method
    function Window:CreateTab(tabName)
        local Tab = {}

        -- 1. BUTTON ELEMENT
        function Tab:CreateButton(btnConfig)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 38)
            Button.BackgroundColor3 = Color3.fromRGB(27, 28, 35)
            Button.TextColor3 = Color3.fromRGB(240, 240, 240)
            Button.Text = btnConfig.Name or "Button"
            Button.Font = Enum.Font.SourceSans
            Button.TextSize = 14
            Button.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Button

            Button.MouseButton1Click:Connect(function()
                if btnConfig.Callback then task.spawn(btnConfig.Callback) end
            end)
        end

        -- 2. TOGGLE ELEMENT
        function Tab:CreateToggle(toggleConfig)
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(27, 28, 35)
            ToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
            ToggleBtn.Text = "   " .. (toggleConfig.Name or "Toggle")
            ToggleBtn.Font = Enum.Font.SourceSans
            ToggleBtn.TextSize = 14
            ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
            ToggleBtn.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ToggleBtn

            local state = toggleConfig.Default or false
            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.fromOffset(16, 16)
            Indicator.Position = UDim2.new(1, -26, 0.5, -8)
            Indicator.BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(50, 50, 60)
            Indicator.Parent = ToggleBtn

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator

            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                Indicator.BackgroundColor3 = state and Color3.fromRGB(99, 102, 241) or Color3.fromRGB(50, 50, 60)
                if toggleConfig.Callback then task.spawn(function() toggleConfig.Callback(state) end) end
            end)
        end

        -- 3. SLIDER ELEMENT
        function Tab:CreateSlider(sliderConfig)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 45)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(27, 28, 35)
            SliderFrame.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 4)
            Label.BackgroundTransparency = 1
            Label.Text = (sliderConfig.Name or "Slider") .. ": " .. tostring(sliderConfig.CurrentValue or 16)
            Label.TextColor3 = Color3.fromRGB(240, 240, 240)
            Label.TextSize = 13
            Label.Font = Enum.Font.SourceSans
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame
        end

        -- 4. DROPDOWN ELEMENT
        function Tab:CreateDropdown(dropConfig)
            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 38)
            DropBtn.BackgroundColor3 = Color3.fromRGB(27, 28, 35)
            DropBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
            DropBtn.Text = "   " .. (dropConfig.Name or "Dropdown")
            DropBtn.Font = Enum.Font.SourceSans
            DropBtn.TextSize = 14
            DropBtn.TextXAlignment = Enum.TextXAlignment.Left
            DropBtn.Parent = ContentContainer

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = DropBtn
        end

        return Tab
    end

    function Library:LoadConfiguration()
        print("Config auto-loader initialized!")
    end

    return Window
end

return Library
