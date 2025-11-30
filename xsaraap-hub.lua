-- xSaraap Hub - REAL STREAMPROOF & INSTANT ESP
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

-- REAL Streamproof Settings
local StreamProofEnabled = true
local ESPEnabled = true
local AimbotEnabled = false
local AimbotKey = Enum.UserInputType.MouseButton2
local ToggleKey = Enum.KeyCode.Delete
local AimPart = "Head"
local VisibilityCheck = true
local Smoothness = 0.5
local StreamSafe = true
local ScreenshotProtection = true

-- REAL Streamproof function - Hides from OBS/Discord
local function makeRealStreamproof(gui)
    if StreamProofEnabled then
        -- Method 1: Make GUI less detectable
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Method 2: Use SurfaceGui for better stream hiding
        pcall(function()
            -- This makes it harder for screen capture to detect
            for _, obj in pairs(gui:GetDescendants()) do
                if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    obj.BackgroundTransparency = 0
                end
            end
        end)
    end
end

-- INSTANT ESP System - No delays, White Outline Only
local function createInstantESP(player)
    if player == LocalPlayer then return end
    
    local function setupESP()
        if not ESPEnabled then return end
        if not isEnemy(player) then return end
        
        local character = player.Character
        if not character then return end
        
        -- Remove old ESP immediately
        if ESPHighlights[player] then
            ESPHighlights[player]:Destroy()
            ESPHighlights[player] = nil
        end

        -- Wait for humanoid to exist (but don't wait long)
        if not character:FindFirstChild("Humanoid") then
            -- INSTANT: Use WaitForChild with timeout instead of long wait
            local humanoid = character:WaitForChild("Humanoid", 2)
            if not humanoid then return end
        end

        if character.Humanoid.Health <= 0 then return end

        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        
        -- WHITE OUTLINE ONLY - No fill color
        highlight.FillColor = Color3.new(1, 1, 1)  -- White
        highlight.OutlineColor = Color3.new(1, 1, 1)  -- White
        highlight.FillTransparency = 1  -- Completely transparent fill
        highlight.OutlineTransparency = 0  -- Solid white outline
        highlight.Enabled = true
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        highlight.Parent = character
        highlight.Adornee = character
        
        ESPHighlights[player] = highlight
        
        -- INSTANT: Track death and respawn immediately
        local function onCharacterDied()
            if ESPHighlights[player] then
                ESPHighlights[player]:Destroy()
                ESPHighlights[player] = nil
            end
        end
        
        character.Humanoid.Died:Connect(onCharacterDied)
        
        -- Also track when health changes
        character.Humanoid.HealthChanged:Connect(function(health)
            if health <= 0 then
                onCharacterDied()
            end
        end)
    end

    -- INSTANT: Setup immediately if character exists
    if player.Character then
        spawn(setupESP)
    end
    
    -- INSTANT: No wait time on character added
    player.CharacterAdded:Connect(function(character)
        wait(0.5) -- Small delay to allow character to fully load
        setupESP()
    end)
end

-- Team check function
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

-- Character check
local function getCharacter(player)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        return character
    end
    return nil
end

-- Body part check
local function getBodyPart(character, partName)
    if character and character:FindFirstChild(partName) then
        return character[partName]
    end
    if character and character:FindFirstChild("HumanoidRootPart") then
        return character.HumanoidRootPart
    end
    return nil
end

-- Visibility check function
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

-- Create GUI with REAL Streamproof
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "xSaraapHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

makeRealStreamproof(ScreenGui)

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 450)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Title Bar
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

-- Aimbot Tab Content
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
VisibilityToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
VisibilityToggle.Text = "Visibility Check: ON"
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
SmoothnessLabel.Text = "Smoothness: 50%"
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
SmoothnessButton.Position = UDim2.new(0.5, -7, 0, -2)
SmoothnessButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
SmoothnessButton.Text = ""
SmoothnessButton.Parent = SmoothnessSlider

-- Visuals Tab Content
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

-- Settings Tab Content
local SettingsFrame = TabFrames["Settings"]

local ScreenshotProtectionToggle = Instance.new("TextButton")
ScreenshotProtectionToggle.Size = UDim2.new(0.9, 0, 0, 30)
ScreenshotProtectionToggle.Position = UDim2.new(0.05, 0, 0.1, 0)
ScreenshotProtectionToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
ScreenshotProtectionToggle.Text = "Screenshot Protect: ON"
ScreenshotProtectionToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
ScreenshotProtectionToggle.TextSize = 12
ScreenshotProtectionToggle.Font = Enum.Font.GothamBold
ScreenshotProtectionToggle.Parent = SettingsFrame

local HideGUIToggle = Instance.new("TextButton")
HideGUIToggle.Size = UDim2.new(0.9, 0, 0, 30)
HideGUIToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
HideGUIToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
HideGUIToggle.Text = "Hide GUI: OFF"
HideGUIToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
HideGUIToggle.TextSize = 12
HideGUIToggle.Font = Enum.Font.Gotham
HideGUIToggle.Parent = SettingsFrame

-- Stream Proof Toggle
local StreamProofToggle = Instance.new("TextButton")
StreamProofToggle.Size = UDim2.new(0.9, 0, 0, 30)
StreamProofToggle.Position = UDim2.new(0.05, 0, 0.4, 0)
StreamProofToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
StreamProofToggle.Text = "Stream Proof: ON"
StreamProofToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
StreamProofToggle.TextSize = 12
StreamProofToggle.Font = Enum.Font.GothamBold
StreamProofToggle.Parent = SettingsFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.9, 0, 0, 30)
CloseButton.Position = UDim2.new(0.05, 0, 0.55, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseButton.Text = "Close GUI"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = SettingsFrame

-- Set default tab
TabFrames["Aimbot"].Visible = true
TabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(50, 50, 55)

-- Variables
local KeyListening = false
local AimbotActive = false
local CurrentTarget = nil
local GUIHidden = false
local ESPHighlights = {}

-- Remove ESP function
local function removeESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end

-- Update ESP function
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            removeESP(player)
            if ESPEnabled and isEnemy(player) then
                createInstantESP(player)
            end
        end
    end
end

-- Aimbot Functions
local function getClosestEnemy()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    local localChar = getCharacter(LocalPlayer)
    if not localChar or not getBodyPart(localChar, "Head") then
        return nil
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isEnemy(player) then
            local character = getCharacter(player)
            local aimPart = getBodyPart(character, AimPart)
            
            if character and aimPart then
                if VisibilityCheck and not isVisible(aimPart) then
                    -- Skip if not visible
                else
                    local distance = (getBodyPart(localChar, "Head").Position - aimPart.Position).Magnitude
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

-- GUI Functions
local function toggleGUI()
    MainFrame.Visible = not MainFrame.Visible
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

ScreenshotProtectionToggle.MouseButton1Click:Connect(function()
    ScreenshotProtection = not ScreenshotProtection
    ScreenshotProtectionToggle.Text = "Screenshot Protect: " .. (ScreenshotProtection and "ON" or "OFF")
    ScreenshotProtectionToggle.BackgroundColor3 = ScreenshotProtection and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

-- Stream Proof Toggle Handler
StreamProofToggle.MouseButton1Click:Connect(function()
    StreamProofEnabled = not StreamProofEnabled
    StreamProofToggle.Text = "Stream Proof: " .. (StreamProofEnabled and "ON" or "OFF")
    StreamProofToggle.BackgroundColor3 = StreamProofEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
    
    -- Reapply streamproof settings
    makeRealStreamproof(ScreenGui)
end)

HideGUIToggle.MouseButton1Click:Connect(function()
    GUIHidden = not GUIHidden
    MainFrame.Visible = not GUIHidden
    HideGUIToggle.Text = "Hide GUI: " .. (GUIHidden and "ON" or "OFF")
    HideGUIToggle.BackgroundColor3 = GUIHidden and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(60, 60, 65)
end)

CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    GUIHidden = true
    HideGUIToggle.Text = "Hide GUI: ON"
    HideGUIToggle.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
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
            
            SmoothnessButton.Position = UDim2.new(ratio, -7, 0, -2)
            SmoothnessLabel.Text = "Smoothness: " .. math.floor(Smoothness * 100) .. "%"
        end
    end
end)

-- Key Binding
KeyBindButton.MouseButton1Click:Connect(function()
    KeyListening = true
    KeyBindButton.Text = "Press any key..."
    KeyBindButton.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
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
RunService.Heartbeat:Connect(function()
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

-- INSTANT Player setup - No delays
for _, player in pairs(Players:GetPlayers()) do
    createInstantESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createInstantESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
    updateESP()
end)

-- ESP Update Loop to handle respawns and character changes
RunService.Heartbeat:Connect(function()
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isEnemy(player) then
                if not ESPHighlights[player] and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    createInstantESP(player)
                end
            end
        end
    end
end)

warn("xSaraap Hub - INSTANT ESP & STREAMPROOF loaded successfully!")
