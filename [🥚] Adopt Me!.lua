-- ====================================================================
-- ADOPT ME! AUTOMATION SCRIPT WITH MOBILE RESPONSIVE UI
-- Target Game: Adopt Me! (Roblox)
-- Features: Auto Care (Needs Farm), Auto Hatch Eggs, Teleport Locations
-- Note: Infinite Cash is server-restricted and excluded for safety.
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Configuration Flags
local Config = {
    AutoCare = false,
    AutoHatch = false,
    Teleporting = false
}

-- Location Coordinates (Tween Targets)
local Locations = {
    MainMap = Vector3.new(-192, 18, -9, 0),
    Nursery = Vector3.new(-255, 30, -1520),
    PetShop = Vector3.new(-180, 30, -1650),
    Playground = Vector3.new(-220, 18, -640),
    Beach = Vector3.new(-680, 18, -1390)
}

-- Destroy Previous UI Instance if re-executing
if CoreGui:FindFirstChild("AdoptMeUI") then
    CoreGui.AdoptMeUI:Destroy()
end

-- ====================================================================
-- MOBILE RESPONSIVE UI
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdoptMeUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.4, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 1.15
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
Header.Size = UDim2.new(1, 0, 0.16, 0)
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
TitleText.Text = "ADOPT ME HUB"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.Font = Enum.Font.FredokaOne
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Header

-- Content Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 0.84, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0.16, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.3, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0.02, 0)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Helper Function: Create Toggle Row
local function createToggleRow(name, key, layoutOrder)
    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(0.9, 0, 0.15, 0)
    RowFrame.BackgroundTransparency = 1
    RowFrame.LayoutOrder = layoutOrder
    RowFrame.Parent = ScrollingFrame

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
    ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45) -- RED
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = true
    ToggleButton.Parent = RowFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ToggleButton

    ToggleButton.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        if Config[key] then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 215, 45) -- GREEN
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45) -- RED
        end
    end)
end

-- Helper Function: Create Teleport Action Button
local function createTeleportButton(name, targetVector, layoutOrder)
    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(0.9, 0, 0.15, 0)
    RowFrame.BackgroundTransparency = 1
    RowFrame.LayoutOrder = layoutOrder
    RowFrame.Parent = ScrollingFrame

    local ActionButton = Instance.new("TextButton")
    ActionButton.Size = UDim2.new(1, 0, 0.85, 0)
    ActionButton.Position = UDim2.new(0, 0, 0.05, 0)
    ActionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ActionButton.Text = "TELEPORT: " .. string.upper(name)
    ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionButton.TextScaled = true
    ActionButton.Font = Enum.Font.FredokaOne
    ActionButton.Parent = RowFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ActionButton

    ActionButton.MouseButton1Click:Connect(function()
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local root = Character.HumanoidRootPart
            local distance = (root.Position - targetVector).Magnitude
            local tweenInfo = TweenInfo.new(distance / 50, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(targetVector)})
            tween:Play()
        end
    end)
end

-- Render Interface Items
createToggleRow("AUTO CARE (NEEDS)", "AutoCare", 1)
createToggleRow("AUTO HATCH EGGS", "AutoHatch", 2)
createTeleportButton("Nursery", Locations.Nursery, 3)
createTeleportButton("Main Map", Locations.MainMap, 4)
createTeleportButton("Playground", Locations.Playground, 5)

-- ====================================================================
-- AUTOMATION & MECHANICS LOGIC
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

-- Safe Remote Helper
local function fireAPI(folder, remoteName, ...)
    local args = {...}
    pcall(function()
        local API = ReplicatedStorage:FindFirstChild("API")
        if API then
            local targetRemote = API:FindFirstChild(folder .. "/" .. remoteName) or API:FindFirstChild(remoteName)
            if targetRemote and targetRemote:IsA("RemoteEvent") then
                targetRemote:FireServer(unpack(args))
            elseif targetRemote and targetRemote:IsA("RemoteFunction") then
                targetRemote:InvokeServer(unpack(args))
            end
        end
    end)
end

-- 1. AUTO CARE (Process Pet & Baby Ailments)
local function processAutoCare()
    if not Config.AutoCare then return end
    
    -- Pass standard ailment handling requests to API
    fireAPI("HousingAPI", "ActivateFurniture", "Bed", "Use")
    fireAPI("HousingAPI", "ActivateFurniture", "Shower", "Use")
    fireAPI("AilmentsAPI", "ChooseAilment", "sleepy")
    fireAPI("AilmentsAPI", "ChooseAilment", "dirty")
    fireAPI("AilmentsAPI", "ChooseAilment", "hungry")
    fireAPI("AilmentsAPI", "ChooseAilment", "thirsty")
end

-- 2. AUTO HATCH EGGS
local function processAutoHatch()
    if not Config.AutoHatch then return end
    
    -- Trigger egg purchase and hatch confirmation routines
    fireAPI("ShopAPI", "BuyItem", "pets", "cracked_egg", {})
    fireAPI("PetAPI", "HatchEgg")
end

-- Main Execution Thread
task.spawn(function()
    print("[Adopt Me! Script] Execution started.")
    while task.wait(0.5) do
        if Config.AutoCare then
            processAutoCare()
        end
        if Config.AutoHatch then
            processAutoHatch()
        end
    end
end)
