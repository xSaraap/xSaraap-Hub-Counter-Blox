-- xSaraap Hub - COMPLETE WORKING VERSION WITH ADVANCED GUI
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Game Detection
local GameName = "Unknown Game"
pcall(function()
    GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
    if string.len(GameName) > 25 then
        GameName = string.sub(GameName, 1, 22) .. "..."
    end
end)

-- Settings
local ESPEnabled = true
local AimbotEnabled = false
local TriggerbotEnabled = false
local TriggerbotMode = "Tap" -- "Tap", "Burst", "Rapid"
local AimbotKey = Enum.UserInputType.MouseButton2
local ToggleKey = Enum.KeyCode.Delete
local AimPart = "Head"
local VisibilityCheck = true
local Smoothness = 0.5
local ScreenshotProtection = true
local TriggerbotDelay = 0.2
local LastShotTime = 0
local IsDragging = false
local DragStartPos = UDim2.new()
local GUIStartPos = UDim2.new()

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
MainFrame.Size = UDim2.new(0, 500, 0, 550)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Active = true
MainFrame.Selectable = true
MainFrame.Parent = ScreenGui

-- Modern corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Enhanced Title Bar with game name (now draggable)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = MainFrame

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 8)
TitleBarCorner.Parent = TitleBar

-- Logo Image
local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(0, 40, 0, 40)
LogoImage.Position = UDim2.new(0, 10, 0.5, -20)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "https://mir-s3-cdn-cf.behance.net/project_modules/1400/7064f8105512449.5f7b1e51a8e7a.jpg"
LogoImage.ZIndex = 3
LogoImage.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 60, 0, 0)
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
VersionLabel.Text = "v2.3"
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
TabContainer.Size = UDim2.new(0, 130, 1, -50)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BorderSizePixel = 0
TabContainer.ZIndex = 2
TabContainer.Parent = MainFrame

local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 8)
TabContainerCorner.Parent = TabContainer

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -130, 1, -50)
ContentFrame.Position = UDim2.new(0, 130, 0, 50)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
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
    
    TabButtons[tabName] = TabButton
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.ZIndex = 3
    TabFrame.Parent = ContentFrame
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        end
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    end)
end

-- Create UI elements function
local function createModernToggle(text, position, parent)
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

local function createModernButton(text, position, parent)
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
    
    return Button
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

local AimbotToggleData = createModernToggle("Aimbot: OFF", UDim2.new(0.05, 0, 0.1, 0), AimbotFrame)
local KeyBindButton = createModernButton("Aim Key: RMB", UDim2.new(0.05, 0, 0.2, 0), AimbotFrame)
local AimPartButton = createModernButton("Aim Part: Head", UDim2.new(0.05, 0, 0.28, 0), AimbotFrame)
local VisibilityToggleData = createModernToggle("Visibility Check: ON", UDim2.new(0.05, 0, 0.36, 0), AimbotFrame)

-- Triggerbot Section
local TriggerbotSectionTitle = Instance.new("TextLabel")
TriggerbotSectionTitle.Size = UDim2.new(0.9, 0, 0, 25)
TriggerbotSectionTitle.Position = UDim2.new(0.05, 0, 0.45, 0)
TriggerbotSectionTitle.BackgroundTransparency = 1
TriggerbotSectionTitle.Text = "TRIGGERBOT"
TriggerbotSectionTitle.TextColor3 = Color3.fromRGB(200, 200, 220)
TriggerbotSectionTitle.TextSize = 14
TriggerbotSectionTitle.Font = Enum.Font.GothamBold
TriggerbotSectionTitle.TextXAlignment = Enum.TextXAlignment.Left
TriggerbotSectionTitle.Parent = AimbotFrame

local TriggerbotToggleData = createModernToggle("Triggerbot: OFF", UDim2.new(0.05, 0, 0.53, 0), AimbotFrame)

-- Triggerbot Mode Buttons
local TriggerbotModeFrame = Instance.new("Frame")
TriggerbotModeFrame.Size = UDim2.new(0.9, 0, 0, 80)
TriggerbotModeFrame.Position = UDim2.new(0.05, 0, 0.63, 0)
TriggerbotModeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TriggerbotModeFrame.BorderSizePixel = 0
TriggerbotModeFrame.Parent = AimbotFrame

local TriggerbotModeCorner = Instance.new("UICorner")
TriggerbotModeCorner.CornerRadius = UDim.new(0, 6)
TriggerbotModeCorner.Parent = TriggerbotModeFrame

local TapButton = createModernButton("Tap", UDim2.new(0.05, 0, 0.1, 0), TriggerbotModeFrame)
local BurstButton = createModernButton("Burst", UDim2.new(0.35, 0, 0.1, 0), TriggerbotModeFrame)
local RapidButton = createModernButton("Rapid", UDim2.new(0.65, 0, 0.1, 0), TriggerbotModeFrame)

TapButton.Size = UDim2.new(0.3, 0, 0.5, 0)
BurstButton.Size = UDim2.new(0.3, 0, 0.5, 0)
RapidButton.Size = UDim2.new(0.3, 0, 0.5, 0)

-- Enhanced Smoothness Slider
local SmoothnessFrame = Instance.new("Frame")
SmoothnessFrame.Size = UDim2.new(0.9, 0, 0, 60)
SmoothnessFrame.Position = UDim2.new(0.05, 0, 0.83, 0)
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

local ESPToggleData = createModernToggle("ESP: ON", UDim2.new(0.05, 0, 0.12, 0), VisualsFrame)

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

local ScreenshotProtectionToggleData = createModernToggle("Screenshot Protect: ON", UDim2.new(0.05, 0, 0.12, 0), SettingsFrame)
local HideGUIToggleData = createModernToggle("Hide GUI: OFF", UDim2.new(0.05, 0, 0.22, 0), SettingsFrame)

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
TabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(60, 100, 255)

-- Variables
local KeyListening = false
local AimbotActive = false
local CurrentTarget = nil
local GUIHidden = false
local ESPHighlights = {}
local IsRapidFiring = false
local BurstCount = 0
local LastBurstTime = 0

-- Make GUI draggable
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = true
        DragStartPos = input.Position
        GUIStartPos = MainFrame.Position
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if IsDragging then
            local delta = input.Position - DragStartPos
            MainFrame.Position = UDim2.new(
                GUIStartPos.X.Scale,
                GUIStartPos.X.Offset + delta.X,
                GUIStartPos.Y.Scale,
                GUIStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = false
    end
end)

-- ESP Function (UNLIMITED RANGE)
local function createESP(player)
    if player == LocalPlayer then return end
    if not isEnemy(player) then return end
    
    local character = player.Character
    if not character then return end
    
    -- Remove old ESP
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
    
    if not ESPEnabled then return end

    local function setupESP()
        if not character or not character.Parent then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        highlight.FillColor = Color3.new(0, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.Enabled = true
        
        -- NO RANGE LIMIT: Always visible regardless of distance
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Adornee = character
        
        -- Parent to player's character for unlimited range
        highlight.Parent = character
        
        -- Ensure it stays enabled even when far away
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                if highlight then
                    highlight:Destroy()
                end
            end)
        end
        
        ESPHighlights[player] = highlight
    end

    -- Wait for character to fully load
    if character:FindFirstChild("Humanoid") then
        setupESP()
    else
        character.ChildAdded:Connect(function(child)
            if child:IsA("Humanoid") then
                wait(0.5)
                setupESP()
            end
        end)
    end
    
    -- Handle character respawns
    player.CharacterAdded:Connect(function(newCharacter)
        wait(1) -- Wait for character to load
        if ESPEnabled and isEnemy(player) then
            setupESP()
        end
    end)
end

local function removeESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            removeESP(player)
            if ESPEnabled and isEnemy(player) then
                createESP(player)
            end
        end
    end
end

-- Aimbot Functions (UPDATED)
local function getClosestEnemy()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then
        return nil
    end
    
    local myHead = LocalPlayer.Character.Head
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local aimPart = character:FindFirstChild(AimPart)
            
            -- Only consider alive players
            if humanoid and humanoid.Health > 0 and aimPart then
                if VisibilityCheck and not isVisible(aimPart) then
                    -- Skip if not visible
                else
                    local distance = (myHead.Position - aimPart.Position).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function smoothAim(targetPosition)
    local camera = Workspace.CurrentCamera
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    
    local smoothFactor = math.clamp(Smoothness, 0.1, 0.9)
    local newCFrame = currentCFrame:Lerp(targetCFrame, 1 - smoothFactor)
    
    camera.CFrame = newCFrame
end

-- TRIGGERBOT FUNCTION with different modes
local function triggerbotShoot()
    if not TriggerbotEnabled then return end
    if not LocalPlayer.Character then return end
    
    local camera = Workspace.CurrentCamera
    local mousePos = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    
    -- Create ray from center of screen
    local unitRay = camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(unitRay.Origin, unitRay.Direction * 1000, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        local hitPart = raycastResult.Instance
        local hitCharacter = hitPart.Parent
        
        if hitCharacter and hitCharacter:FindFirstChild("Humanoid") then
            local humanoid = hitCharacter:FindFirstChild("Humanoid")
            local hitPlayer = Players:GetPlayerFromCharacter(hitCharacter)
            
            -- Check if hit player is an enemy
            if hitPlayer and isEnemy(hitPlayer) and humanoid.Health > 0 then
                -- Check visibility if enabled
                if VisibilityCheck and not isVisible(hitPart) then
                    IsRapidFiring = false
                    BurstCount = 0
                    return
                end
                
                local currentTime = tick()
                
                if TriggerbotMode == "Tap" then
                    -- Tap mode: Single shot every 0.2 seconds
                    if currentTime - LastShotTime > TriggerbotDelay then
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        LastShotTime = currentTime
                    end
                    
                elseif TriggerbotMode == "Burst" then
                    -- Burst mode: 3-4 shots in quick succession
                    if BurstCount == 0 then
                        -- Start new burst
                        BurstCount = 1
                        LastBurstTime = currentTime
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    elseif BurstCount < 4 and currentTime - LastBurstTime > 0.1 then
                        -- Continue burst
                        BurstCount = BurstCount + 1
                        LastBurstTime = currentTime
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    elseif BurstCount >= 4 and currentTime - LastBurstTime > TriggerbotDelay then
                        -- Reset burst after delay
                        BurstCount = 0
                    end
                    
                elseif TriggerbotMode == "Rapid" then
                    -- Rapid mode: Continuous firing
                    if not IsRapidFiring then
                        IsRapidFiring = true
                    end
                    
                    -- Keep mouse button pressed
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    return -- Don't release mouse button in rapid mode
                    
                end
            else
                -- Target is not valid, reset states
                IsRapidFiring = false
                BurstCount = 0
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        else
            -- Not hitting an enemy, reset states
            IsRapidFiring = false
            BurstCount = 0
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    else
        -- Not hitting anything, reset states
        IsRapidFiring = false
        BurstCount = 0
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- Screenshot Protection
local ScreenshotKeys = {
    Enum.KeyCode.Print,
    Enum.KeyCode.F12,
    Enum.KeyCode.F11,
    Enum.KeyCode.F10,
    Enum.KeyCode.F9
}

local function hideEverything()
    if not ScreenshotProtection then return end
    
    MainFrame.Visible = false
    
    for _, highlight in pairs(ESPHighlights) do
        if highlight then
            highlight.Enabled = false
        end
    end
end

local function showEverything()
    if not ScreenshotProtection then return end
    
    MainFrame.Visible = not GUIHidden
    
    for _, highlight in pairs(ESPHighlights) do
        if highlight then
            highlight.Enabled = true
        end
    end
end

-- GUI Functions
local function toggleGUI()
    MainFrame.Visible = not MainFrame.Visible
end

-- Button Handlers
AimbotToggleData.Button.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggleData.Label.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    
    if AimbotEnabled then
        TweenService:Create(AimbotToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
        TweenService:Create(AimbotToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
    else
        TweenService:Create(AimbotToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
        TweenService:Create(AimbotToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
    end
end)

TriggerbotToggleData.Button.MouseButton1Click:Connect(function()
    TriggerbotEnabled = not TriggerbotEnabled
    TriggerbotToggleData.Label.Text = "Triggerbot: " .. (TriggerbotEnabled and "ON" or "OFF")
    
    if TriggerbotEnabled then
        TweenService:Create(TriggerbotToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
        TweenService:Create(TriggerbotToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
    else
        TweenService:Create(TriggerbotToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
        TweenService:Create(TriggerbotToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
    end
end)

ESPToggleData.Button.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggleData.Label.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    
    if ESPEnabled then
        TweenService:Create(ESPToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
        TweenService:Create(ESPToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
    else
        TweenService:Create(ESPToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
        TweenService:Create(ESPToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
    end
    updateESP()
end)

VisibilityToggleData.Button.MouseButton1Click:Connect(function()
    VisibilityCheck = not VisibilityCheck
    VisibilityToggleData.Label.Text = "Visibility Check: " .. (VisibilityCheck and "ON" or "OFF")
    
    if VisibilityCheck then
        TweenService:Create(VisibilityToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
        TweenService:Create(VisibilityToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
    else
        TweenService:Create(VisibilityToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
        TweenService:Create(VisibilityToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
    end
end)

ScreenshotProtectionToggleData.Button.MouseButton1Click:Connect(function()
    ScreenshotProtection = not ScreenshotProtection
    ScreenshotProtectionToggleData.Label.Text = "Screenshot Protect: " .. (ScreenshotProtection and "ON" or "OFF")
    
    if ScreenshotProtection then
        TweenService:Create(ScreenshotProtectionToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
        TweenService:Create(ScreenshotProtectionToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
    else
        TweenService:Create(ScreenshotProtectionToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
        TweenService:Create(ScreenshotProtectionToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
    end
end)

HideGUIToggleData.Button.MouseButton1Click:Connect(function()
    GUIHidden = not GUIHidden
    HideGUIToggleData.Label.Text = "Hide GUI: " .. (GUIHidden and "ON" or "OFF")
    MainFrame.Visible = not GUIHidden
    
    if GUIHidden then
        TweenService:Create(HideGUIToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
        TweenService:Create(HideGUIToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
    else
        TweenService:Create(HideGUIToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 0, 0)}):Play()
        TweenService:Create(HideGUIToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    GUIHidden = true
    HideGUIToggleData.Label.Text = "Hide GUI: ON"
    TweenService:Create(HideGUIToggleData.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 0)}):Play()
    TweenService:Create(HideGUIToggleData.Knob, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0, 2)}):Play()
end)

AimPartButton.MouseButton1Click:Connect(function()
    if AimPart == "Head" then
        AimPart = "HumanoidRootPart"
        AimPartButton.Text = "Aim Part: Torso"
    else
        AimPart = "Head"
        AimPartButton.Text = "Aim Part: Head"
    end
end)

-- Triggerbot Mode Button Handlers
local function updateTriggerbotModeButtons()
    TapButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    BurstButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    RapidButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    
    if TriggerbotMode == "Tap" then
        TapButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    elseif TriggerbotMode == "Burst" then
        BurstButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    elseif TriggerbotMode == "Rapid" then
        RapidButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
    end
end

TapButton.MouseButton1Click:Connect(function()
    TriggerbotMode = "Tap"
    updateTriggerbotModeButtons()
end)

BurstButton.MouseButton1Click:Connect(function()
    TriggerbotMode = "Burst"
    updateTriggerbotModeButtons()
end)

RapidButton.MouseButton1Click:Connect(function()
    TriggerbotMode = "Rapid"
    updateTriggerbotModeButtons()
end)

-- Initialize triggerbot mode buttons
updateTriggerbotModeButtons()

-- Slider Functionality
local smoothDragging = false
SmoothnessButton.MouseButton1Down:Connect(function()
    smoothDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        smoothDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if smoothDragging then
            local xPos = math.clamp(input.Position.X - SmoothnessSlider.AbsolutePosition.X, 0, SmoothnessSlider.AbsoluteSize.X)
            local ratio = xPos / SmoothnessSlider.AbsoluteSize.X
            Smoothness = math.clamp(ratio, 0.1, 0.9)
            
            SmoothnessButton.Position = UDim2.new(ratio, -9, 0.5, -9)
            SmoothnessFill.Size = UDim2.new(ratio, 0, 1, 0)
            SmoothnessLabel.Text = "Smoothness: " .. math.floor(Smoothness * 100) .. "%"
        end
    end
end)

-- Improved Key Binding (FIXED for RMB)
KeyBindButton.MouseButton1Click:Connect(function()
    KeyListening = true
    KeyBindButton.Text = "Press any key or mouse button..."
    KeyBindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if KeyListening then
        KeyListening = false
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            AimbotKey = input.KeyCode
            KeyBindButton.Text = "Aim Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
            AimbotKey = Enum.UserInputType.MouseButton1
            KeyBindButton.Text = "Aim Key: LMB"
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            AimbotKey = Enum.UserInputType.MouseButton2
            KeyBindButton.Text = "Aim Key: RMB"
        elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
            AimbotKey = Enum.UserInputType.MouseButton3
            KeyBindButton.Text = "Aim Key: MMB"
        else
            AimbotKey = input.UserInputType
            KeyBindButton.Text = "Aim Key: " .. tostring(input.UserInputType):gsub("Enum.UserInputType.", "")
        end
        
        KeyBindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        return
    end
    
    -- Screenshot detection
    if table.find(ScreenshotKeys, input.KeyCode) and ScreenshotProtection then
        hideEverything()
        wait(0.5)
        showEverything()
    end
    
    if input.KeyCode == ToggleKey then
        toggleGUI()
    end
    
    -- Improved aimbot key detection
    local isAimbotKey = false
    if type(AimbotKey) == "userdata" then
        if AimbotKey.EnumType == Enum.KeyCode then
            isAimbotKey = input.KeyCode == AimbotKey
        elseif AimbotKey.EnumType == Enum.UserInputType then
            isAimbotKey = input.UserInputType == AimbotKey
        end
    end
    
    if isAimbotKey and AimbotEnabled then
        AimbotActive = true
        CurrentTarget = getClosestEnemy()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Improved aimbot key detection
    local isAimbotKey = false
    if type(AimbotKey) == "userdata" then
        if AimbotKey.EnumType == Enum.KeyCode then
            isAimbotKey = input.KeyCode == AimbotKey
        elseif AimbotKey.EnumType == Enum.UserInputType then
            isAimbotKey = input.UserInputType == AimbotKey
        end
    end
    
    if isAimbotKey then
        AimbotActive = false
        CurrentTarget = nil
    end
end)

-- Aimbot Loop (UPDATED)
RunService.Heartbeat:Connect(function()
    if AimbotActive and AimbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        -- Check if current target is still valid
        local targetIsValid = false
        
        if CurrentTarget and CurrentTarget.Character then
            local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
            local aimPart = CurrentTarget.Character:FindFirstChild(AimPart)
            
            -- Check if target is alive and has the aim part
            if humanoid and humanoid.Health > 0 and aimPart then
                if not VisibilityCheck or isVisible(aimPart) then
                    targetIsValid = true
                end
            end
        end
        
        -- If current target is not valid, find a new one
        if not targetIsValid then
            CurrentTarget = getClosestEnemy()
            
            -- If no valid target found, cancel aimbot
            if not CurrentTarget then
                AimbotActive = false
                return
            end
        end
        
        -- Aim at the valid target
        local aimPart = CurrentTarget.Character:FindFirstChild(AimPart)
        if aimPart then
            smoothAim(aimPart.Position)
        else
            -- If aim part is missing, find new target
            CurrentTarget = getClosestEnemy()
            if not CurrentTarget then
                AimbotActive = false
            end
        end
    end
end)

-- Triggerbot Loop
RunService.Heartbeat:Connect(function()
    if TriggerbotEnabled and LocalPlayer.Character then
        triggerbotShoot()
    else
        -- Release mouse button if triggerbot is disabled
        if IsRapidFiring then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            IsRapidFiring = false
            BurstCount = 0
        end
    end
end)

-- Optional: Add a cleanup function to reset when character dies
LocalPlayer.CharacterAdded:Connect(function()
    -- Reset aimbot when respawning
    AimbotActive = false
    CurrentTarget = nil
    LastShotTime = 0
    IsRapidFiring = false
    BurstCount = 0
end)

LocalPlayer.CharacterRemoving:Connect(function()
    -- Clean up when character is removed
    AimbotActive = false
    CurrentTarget = nil
    LastShotTime = 0
    IsRapidFiring = false
    BurstCount = 0
end)

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

-- Auto setup for players
for _, player in pairs(Players:GetPlayers()) do
    if player.Character then
        spawn(function() createESP(player) end)
    end
    player.CharacterAdded:Connect(function(character)
        spawn(function() 
            wait(1)
            createESP(player) 
        end)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        spawn(function()
            wait(1)
            createESP(player)
        end)
    end)
end)

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    spawn(function()
        wait(0.5)
        updateESP()
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

warn("SFPS Hub Enhanced loaded successfully! Playing: " .. GameName)
