-- xSaraap Hub - ENHANCED VERSION WITH ADVANCED GUI
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Game Detection
local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
if string.len(GameName) > 25 then
    GameName = string.sub(GameName, 1, 22) .. "..."
end

-- Settings
local ESPEnabled = true
local AimbotEnabled = false
local AimbotKey = Enum.UserInputType.MouseButton2
local ToggleKey = Enum.KeyCode.Delete
local AimPart = "Head"
local VisibilityCheck = true
local Smoothness = 0.5
local StreamSafe = true
local ScreenshotProtection = true

-- Team check function
local function isEnemy(player)
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    return true
end

-- Visibility check function
local function isVisible(targetPart)
    if not VisibilityCheck then return true end
    if not LocalPlayer.Character then return false end
    
    local camera = Workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local target = targetPart.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, target - origin, raycastParams)
    
    if raycastResult then
        return false
    end
    
    return true
end

-- Create GUI with advanced styling
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SFPSHub_Advanced"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Container with modern design
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Modern corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Gradient background effect
local GradientBackground = Instance.new("Frame")
GradientBackground.Size = UDim2.new(1, 0, 1, 0)
GradientBackground.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
GradientBackground.BorderSizePixel = 0
GradientBackground.ZIndex = 0
GradientBackground.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 45
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
})
UIGradient.Parent = GradientBackground

-- Enhanced Title Bar with game name
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

local TitleGlow = Instance.new("ImageLabel")
TitleGlow.Size = UDim2.new(1, 0, 1, 0)
TitleGlow.BackgroundTransparency = 1
TitleGlow.Image = "rbxassetid://8992230671"
TitleGlow.ImageColor3 = Color3.fromRGB(0, 100, 255)
TitleGlow.ScaleType = Enum.ScaleType.Slice
TitleGlow.SliceCenter = Rect.new(100, 100, 100, 100)
TitleGlow.SliceScale = 0.02
TitleGlow.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SFPS Hub - " .. GameName
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 3
Title.Parent = TitleBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(0, 60, 1, 0)
VersionLabel.Position = UDim2.new(1, -70, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.Text = "v2.1"
VersionLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
VersionLabel.TextSize = 12
VersionLabel.Font = Enum.Font.Gotham
VersionLabel.ZIndex = 3
VersionLabel.Parent = TitleBar

-- Tab Buttons with modern styling
local Tabs = {"Aimbot", "Visuals", "Settings"}
local TabButtons = {}
local TabFrames = {}

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 120, 1, -40)
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BorderSizePixel = 0
TabContainer.ZIndex = 2
TabContainer.Parent = MainFrame

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 8)
TabContainerCorner.Parent = TabContainer

-- Content Area with glass effect
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -120, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ContentFrame.BackgroundTransparency = 0.1
ContentFrame.BorderSizePixel = 0
ContentFrame.ZIndex = 2
ContentFrame.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentFrame

-- Create enhanced Tabs
for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0.9, 0, 0, 45)
    TabButton.Position = UDim2.new(0.05, 0, 0, (i-1) * 50 + 10)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 200)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.ZIndex = 3
    TabButton.Parent = TabContainer
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 6)
    TabButtonCorner.Parent = TabButton
    
    local TabHover = Instance.new("Frame")
    TabHover.Size = UDim2.new(1, 0, 1, 0)
    TabHover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabHover.BackgroundTransparency = 0.9
    TabHover.BorderSizePixel = 0
    TabHover.Visible = false
    TabHover.Parent = TabButton
    
    local TabHoverCorner = Instance.new("UICorner")
    TabHoverCorner.CornerRadius = UDim.new(0, 6)
    TabHoverCorner.Parent = TabHover
    
    TabButtons[tabName] = TabButton
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.ZIndex = 3
    TabFrame.Parent = ContentFrame
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseEnter:Connect(function()
        TabHover.Visible = true
        if TabFrame.Visible == false then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        TabHover.Visible = false
        if TabFrame.Visible == false then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}):Play()
        end
        TabFrame.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 100, 255)}):Play()
    end)
end

-- Enhanced Aimbot Tab Content
local AimbotFrame = TabFrames["Aimbot"]

local SectionTitle1 = Instance.new("TextLabel")
SectionTitle1.Size = UDim2.new(0.9, 0, 0, 25)
SectionTitle1.Position = UDim2.new(0.05, 0, 0.02, 0)
SectionTitle1.BackgroundTransparency = 1
SectionTitle1.Text = "AIMBOT SETTINGS"
SectionTitle1.TextColor3 = Color3.fromRGB(200, 200, 220)
SectionTitle1.TextSize = 14
SectionTitle1.Font = Enum.Font.GothamBold
SectionTitle1.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle1.Parent = AimbotFrame

local AimbotToggle = createModernToggle("Aimbot: OFF", UDim2.new(0.05, 0, 0.12, 0), AimbotFrame)

local KeyBindButton = createModernButton("Aim Key: RMB", UDim2.new(0.05, 0, 0.22, 0), AimbotFrame)

local AimPartButton = createModernButton("Aim Part: Head", UDim2.new(0.05, 0, 0.32, 0), AimbotFrame)

local VisibilityToggle = createModernToggle("Visibility Check: ON", UDim2.new(0.05, 0, 0.42, 0), AimbotFrame)

-- Enhanced Smoothness Slider
local SmoothnessFrame = Instance.new("Frame")
SmoothnessFrame.Size = UDim2.new(0.9, 0, 0, 60)
SmoothnessFrame.Position = UDim2.new(0.05, 0, 0.55, 0)
SmoothnessFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SmoothnessFrame.BorderSizePixel = 0
SmoothnessFrame.Parent = AimbotFrame

local SmoothnessCorner = Instance.new("UICorner")
SmoothnessCorner.CornerRadius = UDim.new(0, 6)
SmoothnessCorner.Parent = SmoothnessFrame

local SmoothnessLabel = Instance.new("TextLabel")
SmoothnessLabel.Size = UDim2.new(1, 0, 0, 20)
SmoothnessLabel.BackgroundTransparency = 1
SmoothnessLabel.Text = "Smoothness: 50%"
SmoothnessLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
SmoothnessLabel.TextSize = 12
SmoothnessLabel.Font = Enum.Font.Gotham
SmoothnessLabel.Parent = SmoothnessFrame

local SmoothnessSlider = Instance.new("Frame")
SmoothnessSlider.Size = UDim2.new(0.9, 0, 0, 12)
SmoothnessSlider.Position = UDim2.new(0.05, 0, 0.5, 0)
SmoothnessSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
SmoothnessSlider.BorderSizePixel = 0
SmoothnessSlider.Parent = SmoothnessFrame

local SmoothnessSliderCorner = Instance.new("UICorner")
SmoothnessSliderCorner.CornerRadius = UDim.new(0, 6)
SmoothnessSliderCorner.Parent = SmoothnessSlider

local SmoothnessFill = Instance.new("Frame")
SmoothnessFill.Size = UDim2.new(0.5, 0, 1, 0)
SmoothnessFill.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
SmoothnessFill.BorderSizePixel = 0
SmoothnessFill.Parent = SmoothnessSlider

local SmoothnessFillCorner = Instance.new("UICorner")
SmoothnessFillCorner.CornerRadius = UDim.new(0, 6)
SmoothnessFillCorner.Parent = SmoothnessFill

local SmoothnessButton = Instance.new("TextButton")
SmoothnessButton.Size = UDim2.new(0, 18, 0, 18)
SmoothnessButton.Position = UDim2.new(0.5, -9, 0.5, -9)
SmoothnessButton.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
SmoothnessButton.Text = ""
SmoothnessButton.ZIndex = 2
SmoothnessButton.Parent = SmoothnessSlider

local SmoothnessButtonCorner = Instance.new("UICorner")
SmoothnessButtonCorner.CornerRadius = UDim.new(1, 0)
SmoothnessButtonCorner.Parent = SmoothnessButton

-- Enhanced Visuals Tab Content
local VisualsFrame = TabFrames["Visuals"]

local SectionTitle2 = Instance.new("TextLabel")
SectionTitle2.Size = UDim2.new(0.9, 0, 0, 25)
SectionTitle2.Position = UDim2.new(0.05, 0, 0.02, 0)
SectionTitle2.BackgroundTransparency = 1
SectionTitle2.Text = "VISUAL SETTINGS"
SectionTitle2.TextColor3 = Color3.fromRGB(200, 200, 220)
SectionTitle2.TextSize = 14
SectionTitle2.Font = Enum.Font.GothamBold
SectionTitle2.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle2.Parent = VisualsFrame

local ESPToggle = createModernToggle("ESP: ON", UDim2.new(0.05, 0, 0.12, 0), VisualsFrame)

local StreamSafeToggle = createModernToggle("Stream Safe: ON", UDim2.new(0.05, 0, 0.22, 0), VisualsFrame)

local BoxESPToggle = createModernToggle("Box ESP: OFF", UDim2.new(0.05, 0, 0.32, 0), VisualsFrame)

local TracerToggle = createModernToggle("Tracers: OFF", UDim2.new(0.05, 0, 0.42, 0), VisualsFrame)

-- Enhanced Settings Tab Content
local SettingsFrame = TabFrames["Settings"]

local SectionTitle3 = Instance.new("TextLabel")
SectionTitle3.Size = UDim2.new(0.9, 0, 0, 25)
SectionTitle3.Position = UDim2.new(0.05, 0, 0.02, 0)
SectionTitle3.BackgroundTransparency = 1
SectionTitle3.Text = "SYSTEM SETTINGS"
SectionTitle3.TextColor3 = Color3.fromRGB(200, 200, 220)
SectionTitle3.TextSize = 14
SectionTitle3.Font = Enum.Font.GothamBold
SectionTitle3.TextXAlignment = Enum.TextXAlignment.Left
SectionTitle3.Parent = SettingsFrame

local ScreenshotProtectionToggle = createModernToggle("Screenshot Protect: ON", UDim2.new(0.05, 0, 0.12, 0), SettingsFrame)

local HideGUIToggle = createModernToggle("Hide GUI: OFF", UDim2.new(0.05, 0, 0.22, 0), SettingsFrame)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.9, 0, 0, 40)
CloseButton.Position = UDim2.new(0.05, 0, 0.35, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "CLOSE GUI"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = SettingsFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Status Bar at bottom
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, 0, 0, 25)
StatusBar.Position = UDim2.new(0, 0, 1, -25)
StatusBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 2
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -10, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Ready | FPS: -- | Ping: --"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
StatusLabel.TextSize = 12
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusBar

-- Set default tab
TabFrames["Aimbot"].Visible = true
TweenService:Create(TabButtons["Aimbot"], TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 100, 255)}):Play()

-- Helper functions for creating modern UI elements
function createModernToggle(text, position, parent)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 35)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 20)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
    ToggleKnob.Position = UDim2.new(0, 2, 0, 2)
    ToggleKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    ToggleKnob.Parent = ToggleButton
    
    local ToggleKnobCorner = Instance.new("UICorner")
    ToggleKnobCorner.CornerRadius = UDim.new(1, 0)
    ToggleKnobCorner.Parent = ToggleKnob
    
    return {Frame = ToggleFrame, Label = ToggleLabel, Button = ToggleButton, Knob = ToggleKnob}
end

function createModernButton(text, position, parent)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(220, 220, 240)
    Button.TextSize = 13
    Button.Font = Enum.Font.Gotham
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    local ButtonHover = Instance.new("Frame")
    ButtonHover.Size = UDim2.new(1, 0, 1, 0)
    ButtonHover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonHover.BackgroundTransparency = 0.9
    ButtonHover.BorderSizePixel = 0
    ButtonHover.Visible = false
    ButtonHover.Parent = Button
    
    local ButtonHoverCorner = Instance.new("UICorner")
    ButtonHoverCorner.CornerRadius = UDim.new(0, 6)
    ButtonHoverCorner.Parent = ButtonHover
    
    Button.MouseEnter:Connect(function()
        ButtonHover.Visible = true
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        ButtonHover.Visible = false
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    
    return Button
end

-- [REST OF THE CODE REMAINS THE SAME AS BEFORE FOR FUNCTIONALITY]
-- [ESP Functions, Aimbot Functions, Screenshot Protection, GUI Functions, etc.]

-- Update status bar with performance info
spawn(function()
    while true do
        wait(1)
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        local ping = "N/A"
        if game:GetService("Stats") and game:GetService("Stats").Network then
            ping = tostring(math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()))
        end
        StatusLabel.Text = "Status: Active | FPS: " .. fps .. " | Ping: " .. ping .. "ms"
    end
end)

warn("SFPS Hub Enhanced loaded successfully! Playing: " .. GameName)
