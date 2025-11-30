-- xSaraap Hub - INSTANT ESP & WORKING CONTROLS
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Game Detection
local gameName = "Unknown Game"
local success, gameInfo = pcall(function()
    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
end)
if success and gameInfo then
    gameName = gameInfo.Name
end
warn("xSaraap Hub loaded in: " .. gameName)

-- Team Check Function
local function isEnemy(player)
    if player == LocalPlayer then return false end
    
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    
    if LocalPlayer.TeamColor and player.TeamColor then
        return LocalPlayer.TeamColor ~= player.TeamColor
    end
    
    return true
end

-- Safe Character Check
local function getCharacter(player)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        return character
    end
    return nil
end

-- Safe Body Part Check
local function getBodyPart(character, partName)
    if character and character:FindFirstChild(partName) then
        return character[partName]
    end
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart
    end
    return nil
end

-- Settings
local ESPEnabled = true
local AimbotEnabled = false
local AimbotKey = Enum.UserInputType.MouseButton2
local ToggleKey = Enum.KeyCode.Delete
local AimPart = "Head"
local VisibilityCheck = false
local Smoothness = 0.1
local StreamSafe = true
local ScreenshotProtection = true

-- Visibility Check Function
local function isVisible(targetPart)
    if not VisibilityCheck then return true end
    local localChar = getCharacter(LocalPlayer)
    if not localChar then return false end
    
    local camera = Workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local target = targetPart.Position
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {localChar, targetPart.Parent}
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, target - origin, raycastParams)
    
    return raycastResult == nil
end

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "xSaraapHub"
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "xSaraap Hub - " .. gameName
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = TitleBar

-- Tab Buttons
local Tabs = {"Aimbot", "Visuals", "Settings"}
local TabButtons = {}
local TabFrames = {}

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 100, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -100, 1, -30)
ContentFrame.Position = UDim2.new(0, 100, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
ContentFrame.BorderSizePixel = 0
ContentFrame.Parent = MainFrame

for i, tabName in pairs(Tabs) do
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
    TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    TabButton.BorderSizePixel = 0
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.Parent = TabContainer
    TabButtons[tabName] = TabButton
    
    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.Parent = ContentFrame
    TabFrames[tabName] = TabFrame
    
    TabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        end
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    end)
end

-- Aimbot Tab
local AimbotFrame = TabFrames["Aimbot"]

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(0.9, 0, 0, 30)
AimbotToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.TextSize = 12
AimbotToggle.Font = Enum.Font.GothamBold
AimbotToggle.Parent = AimbotFrame

local KeyBindButton = Instance.new("TextButton")
KeyBindButton.Size = UDim2.new(0.9, 0, 0, 30)
KeyBindButton.Position = UDim2.new(0.05, 0, 0.25, 0)
KeyBindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
KeyBindButton.Text = "Aim Key: RMB"
KeyBindButton.TextColor3 = Color3.fromRGB(220, 220, 220)
KeyBindButton.TextSize = 12
KeyBindButton.Font = Enum.Font.Gotham
KeyBindButton.Parent = AimbotFrame

-- FIXED: Working Aim Part Button
local AimPartButton = Instance.new("TextButton")
AimPartButton.Size = UDim2.new(0.9, 0, 0, 30)
AimPartButton.Position = UDim2.new(0.05, 0, 0.4, 0)
AimPartButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
AimPartButton.Text = "Aim Part: Head"
AimPartButton.TextColor3 = Color3.fromRGB(220, 220, 220)
AimPartButton.TextSize = 12
AimPartButton.Font = Enum.Font.Gotham
AimPartButton.Parent = AimbotFrame

local VisibilityToggle = Instance.new("TextButton")
VisibilityToggle.Size = UDim2.new(0.9, 0, 0, 30)
VisibilityToggle.Position = UDim2.new(0.05, 0, 0.55, 0)
VisibilityToggle.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
VisibilityToggle.Text = "Visibility Check: OFF"
VisibilityToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
VisibilityToggle.TextSize = 12
VisibilityToggle.Font = Enum.Font.Gotham
VisibilityToggle.Parent = AimbotFrame

-- Smoothness Slider
local SmoothnessFrame = Instance.new("Frame")
SmoothnessFrame.Size = UDim2.new(0.9, 0, 0, 50)
SmoothnessFrame.Position = UDim2.new(0.05, 0, 0.75, 0)
SmoothnessFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
SmoothnessFrame.BorderSizePixel = 0
SmoothnessFrame.Parent = AimbotFrame

local SmoothnessLabel = Instance.new("TextLabel")
SmoothnessLabel.Size = UDim2.new(1, 0, 0, 20)
SmoothnessLabel.BackgroundTransparency = 1
SmoothnessLabel.Text = "Smoothness: 10%"
SmoothnessLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
SmoothnessLabel.TextSize = 12
SmoothnessLabel.Font = Enum.Font.Gotham
SmoothnessLabel.Parent = SmoothnessFrame

local SmoothnessSlider = Instance.new("Frame")
SmoothnessSlider.Size = UDim2.new(0.9, 0, 0, 10)
SmoothnessSlider.Position = UDim2.new(0.05, 0, 0.6, 0)
SmoothnessSlider.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
SmoothnessSlider.BorderSizePixel = 0
SmoothnessSlider.Parent = SmoothnessFrame

local SmoothnessButton = Instance.new("TextButton")
SmoothnessButton.Size = UDim2.new(0, 15, 0, 15)
SmoothnessButton.Position = UDim2.new(Smoothness, -7, 0, -2)
SmoothnessButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
SmoothnessButton.Text = ""
SmoothnessButton.Parent = SmoothnessSlider

-- Visuals Tab
local VisualsFrame = TabFrames["Visuals"]

local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0.9, 0, 0, 30)
ESPToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
ESPToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
ESPToggle.Text = "ESP: ON"
ESPToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPToggle.TextSize = 12
ESPToggle.Font = Enum.Font.GothamBold
ESPToggle.Parent = VisualsFrame

-- Settings Tab
local SettingsFrame = TabFrames["Settings"]

local HideGUIToggle = Instance.new("TextButton")
HideGUIToggle.Size = UDim2.new(0.9, 0, 0, 30)
HideGUIToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
HideGUIToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
HideGUIToggle.Text = "Hide GUI: OFF"
HideGUIToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
HideGUIToggle.TextSize = 12
HideGUIToggle.Font = Enum.Font.Gotham
HideGUIToggle.Parent = SettingsFrame

-- Set default tab
TabFrames["Aimbot"].Visible = true
TabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(50, 50, 55)

-- Variables
local KeyListening = false
local AimbotActive = false
local CurrentTarget = nil
local GUIHidden = false
local ESPHighlights = {}
local smoothDragging = false

-- FIXED: INSTANT ESP Function - No wait time
local function createESP(player)
    if player == LocalPlayer then return end
    
    local function setupESP()
        local character = getCharacter(player)
        if not character then return end
        
        if not isEnemy(player) then 
            if ESPHighlights[player] then
                ESPHighlights[player]:Destroy()
                ESPHighlights[player] = nil
            end
            return 
        end
        
        if ESPHighlights[player] then
            ESPHighlights[player]:Destroy()
        end
        
        if not ESPEnabled then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        highlight.FillColor = Color3.new(0, 0, 0)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.Enabled = true
        
        highlight.Parent = character
        highlight.Adornee = character
        
        ESPHighlights[player] = highlight
        
        -- Track respawn instantly
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                if ESPHighlights[player] then
                    ESPHighlights[player]:Destroy()
                    ESPHighlights[player] = nil
                end
            end)
        end
    end

    -- FIXED: Instant setup without wait
    if player.Character then
        setupESP()
    end
    
    -- FIXED: Instant ESP on character added
    player.CharacterAdded:Connect(function(character)
        setupESP() -- No wait time
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

-- Aimbot Functions
local function getClosestEnemy()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    local localChar = getCharacter(LocalPlayer)
    if not localChar then return nil end
    
    local localHead = getBodyPart(localChar, "Head")
    if not localHead then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            local character = getCharacter(player)
            local aimPart = getBodyPart(character, AimPart)
            
            if character and aimPart then
                if VisibilityCheck and not isVisible(aimPart) then
                    -- Skip if not visible
                else
                    local distance = (localHead.Position - aimPart.Position).Magnitude
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
    if not camera then return end
    
    local currentCFrame = camera.CFrame
    local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
    
    local newCFrame = currentCFrame:Lerp(targetCFrame, 1 - Smoothness)
    camera.CFrame = newCFrame
end

-- GUI toggle
local function toggleGUI()
    MainFrame.Visible = not MainFrame.Visible
    GUIHidden = not MainFrame.Visible
    HideGUIToggle.Text = "Hide GUI: " .. (GUIHidden and "ON" or "OFF")
    HideGUIToggle.BackgroundColor3 = GUIHidden and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 65)
end

-- Button Handlers
AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    AimbotToggle.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    ESPToggle.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    ESPToggle.BackgroundColor3 = ESPEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    updateESP()
end)

VisibilityToggle.MouseButton1Click:Connect(function()
    VisibilityCheck = not VisibilityCheck
    VisibilityToggle.Text = "Visibility Check: " .. (VisibilityCheck and "ON" or "OFF")
    VisibilityToggle.BackgroundColor3 = VisibilityCheck and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

HideGUIToggle.MouseButton1Click:Connect(function()
    toggleGUI()
end)

-- FIXED: Working Aim Part Button
AimPartButton.MouseButton1Click:Connect(function()
    if AimPart == "Head" then
        AimPart = "HumanoidRootPart"
        AimPartButton.Text = "Aim Part: Torso"
    else
        AimPart = "Head"
        AimPartButton.Text = "Aim Part: Head"
    end
end)

-- FIXED: Working Key Binding
KeyBindButton.MouseButton1Click:Connect(function()
    KeyListening = true
    KeyBindButton.Text = "Press any key..."
    KeyBindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
end)

-- Smoothness Slider
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
            Smoothness = math.clamp(ratio, 0.05, 0.9)
            
            SmoothnessButton.Position = UDim2.new(ratio, -7, 0, -2)
            SmoothnessLabel.Text = "Smoothness: " .. math.floor(Smoothness * 100) .. "%"
        end
    end
end)

-- FIXED: Input handling with working key binding
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- FIXED: Working key binding
    if KeyListening then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            AimbotKey = input.KeyCode
            KeyBindButton.Text = "Aim Key: " .. tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        else
            AimbotKey = input.UserInputType
            KeyBindButton.Text = "Aim Key: " .. tostring(input.UserInputType):gsub("Enum.UserInputType.", "")
        end
        KeyBindButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
        KeyListening = false
        return
    end
    
    if input.KeyCode == ToggleKey then
        toggleGUI()
    end
    
    -- FIXED: Working aim key detection
    if (input.KeyCode == AimbotKey or input.UserInputType == AimbotKey) and AimbotEnabled then
        AimbotActive = true
        CurrentTarget = getClosestEnemy()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if (input.KeyCode == AimbotKey or input.UserInputType == AimbotKey) then
        AimbotActive = false
        CurrentTarget = nil
    end
end)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if AimbotActive and AimbotEnabled then
        local target = CurrentTarget or getClosestEnemy()
        
        if target then
            local targetChar = getCharacter(target)
            local aimPart = getBodyPart(targetChar, AimPart)
            
            if targetChar and aimPart then
                smoothAim(aimPart.Position)
                CurrentTarget = target
            else
                CurrentTarget = nil
            end
        else
            CurrentTarget = nil
        end
    end
end)

-- FIXED: Instant player tracking
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

warn("xSaraap Hub - INSTANT ESP & WORKING CONTROLS loaded successfully!")
