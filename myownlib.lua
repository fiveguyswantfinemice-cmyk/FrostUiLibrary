-- THIS IS YOUR LIBRARY ENGINE (Save this on GitHub as myownlib.lua)
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local MyLibrary = {}

-- Function to create the main window
function MyLibrary:CreateWindow(windowName)
    local Window = {}
    
    -- 1. Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibraryUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- 2. Main Frame (The window box)
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(450, 300)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.Parent = ScreenGui

    -- Add a rounded corner to the window
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- Title Label
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = windowName or "My Custom UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.SourceSansBold
    Title.Parent = MainFrame

    -- Content Holder for buttons
    local ContentHolder = Instance.new("ScrollingFrame")
    ContentHolder.Size = UDim2.new(1, -20, 1, -60)
    ContentHolder.Position = UDim2.new(0, 10, 0, 50)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = ContentHolder

    -- Function to add buttons to your library
    function Window:AddButton(buttonText, callback)
        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 0, 35)
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.Text = buttonText
        Button.Font = Enum.Font.SourceSans
        Button.TextSize = 14
        Button.Parent = ContentHolder

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Button

        -- When the button is clicked, run the callback function
        Button.MouseButton1Click:Connect(function()
            if callback then
                task.spawn(callback)
            end
        end)
    end

    return Window
end

return MyLibrary
