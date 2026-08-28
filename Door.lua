-- ====================================================================
-- DOORS AUTOMATION SCRIPT WITH MOBILE RESPONSIVE UI
-- Target Game: DOORS (Roblox)
-- Features: Auto Puzzle Solver, Speed Adjuster, Fullbright/No Fog, Door ESP
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Script State Flags
local Config = {
    AutoPuzzle = false,
    SpeedHack = false,
    Fullbright = false,
    DoorESP = false,
    CustomSpeed = 22
}

-- Destroy Previous UI Instance
if CoreGui:FindFirstChild("DoorsNewCheatUI") then
    CoreGui.DoorsNewCheatUI:Destroy()
end

-- Storage for ESP Highlights
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "DoorsESPFolder"
ESPFolder.Parent = CoreGui

-- ====================================================================
-- MOBILE RESPONSIVE UI (Image Style Layout)
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DoorsNewCheatUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.38, 0, 0.55, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 1.2
UIAspectRatioConstraint.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0.18, 0)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.8, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "DOORS MENU"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.Font = Enum.Font.FredokaOne
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Header

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 0.82, 0)
ContentFrame.Position = UDim2.new(0, 0, 0.18, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0.03, 0)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- Helper Function to Create Dynamic Toggle Buttons
local function createToggleRow(name, key, layoutOrder, callback)
    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(0.9, 0, 0.2, 0)
    RowFrame.BackgroundTransparency = 1
    RowFrame.LayoutOrder = layoutOrder
    RowFrame.Parent = ContentFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextScaled = true
    Label.Font = Enum.Font.FredokaOne
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = RowFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0.25, 0, 0.8, 0)
    ToggleButton.Position = UDim2.new(0.75, 0, 0.1, 0)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45) -- RED (OFF)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = true
    ToggleButton.Parent = RowFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ToggleButton

    ToggleButton.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        if Config[key] then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 215, 45) -- GREEN (ON)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45) -- RED (OFF)
        end
        if callback then callback(Config[key]) end
    end)
end

-- ====================================================================
-- FEATURE LOGIC IMPLEMENTATIONS
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- 1. SPEED / MOVEMENT ADJUSTER
RunService.Heartbeat:Connect(function()
    if Config.SpeedHack and Humanoid and Humanoid.Parent then
        if Humanoid.MoveDirection.Magnitude > 0 then
            Character:TranslateBy(Humanoid.MoveDirection * (Config.CustomSpeed / 50))
        end
    end
end)

-- 2. FULLBRIGHT / NO FOG
local originalBrightness = Lighting.Brightness
local originalClockTime = Lighting.ClockTime
local originalFogEnd = Lighting.FogEnd
local originalGlobalShadows = Lighting.GlobalShadows

local function updateFullbright(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = originalBrightness
        Lighting.ClockTime = originalClockTime
        Lighting.FogEnd = originalFogEnd
        Lighting.GlobalShadows = originalGlobalShadows
    end
end

Lighting.Changed:Connect(function()
    if Config.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
end)

-- 3. DOOR ESP SYSTEM
local function updateDoorESP()
    ESPFolder:ClearAllChildren()
    if not Config.DoorESP then return end

    local currentRooms = Workspace:FindFirstChild("CurrentRooms")
    if not currentRooms then return end

    for _, room in ipairs(currentRooms:GetChildren()) do
        local door = room:FindFirstChild("Door")
        if door and door:FindFirstChild("Door") then
            local doorPart = door.Door
            
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "DoorESP_" .. room.Name
            Highlight.Adornee = doorPart
            Highlight.FillColor = Color3.fromRGB(0, 255, 140)
            Highlight.FillTransparency = 0.5
            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            Highlight.OutlineTransparency = 0
            Highlight.Parent = ESPFolder
        end
    end
end

-- 4. AUTO PUZZLE SOLVER (Library Code & Breaker Panel)
local function solvePuzzles()
    if not Config.AutoPuzzle then return end

    local currentRooms = Workspace:FindFirstChild("CurrentRooms")
    if not currentRooms then return end

    -- Door 50 Library Paper & Pad Logic
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Padlock" and obj:FindFirstChild("Paper") then
            -- Triggers remote or auto inputs code directly if collected
            pcall(function()
                if obj:FindFirstChild("Remotes") and obj.Remotes:FindFirstChild("SubmitCode") then
                    obj.Remotes.SubmitCode:FireServer("AutoSolved")
                end
            end)
        end
    end

    -- Door 100 Electrical Breaker Minigame Auto Win
    local breakerBox = Workspace:FindFirstChild("ElevatorBreaker", true)
    if breakerBox and breakerBox:FindFirstChild("BreakerMinigame") then
        pcall(function()
            local minigame = breakerBox.BreakerMinigame
            if minigame:FindFirstChild("BreakerReset") then
                minigame.BreakerReset:FireServer()
            end
        end)
    end
end

-- Main Automation Loop
task.spawn(function()
    while task.wait(0.5) do
        if Config.DoorESP then
            updateDoorESP()
        end
        if Config.AutoPuzzle then
            solvePuzzles()
        end
    end
end)

-- Initialize Toggles
createToggleRow("AUTO PUZZLE", "AutoPuzzle", 1)
createToggleRow("SPEED HACK", "SpeedHack", 2)
createToggleRow("FULLBRIGHT", "Fullbright", 3, updateFullbright)
createToggleRow("DOOR ESP", "DoorESP", 4, function(state)
    if not state then ESPFolder:ClearAllChildren() end
end)
