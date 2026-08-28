-- ====================================================================
-- +1 SPEED WHEEL CHAIR ESCAPE AUTOMATION SCRIPT WITH MOBILE RESPONSIVE UI
-- Target Game: +1 Speed Wheel Chair Escape (Roblox)
-- Features: Auto Farm, Auto Speed, Auto Win, Claim Rewards
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Configuration Flags
local Config = {
    AutoFarm = false,
    AutoSpeed = false,
    AutoWin = false,
    ClaimRewards = false
}

-- Destroy Previous UI Instance if re-executing
if CoreGui:FindFirstChild("WheelChairUI") then
    CoreGui.WheelChairUI:Destroy()
end

-- ====================================================================
-- MOBILE RESPONSIVE UI
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WheelChairUI"
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
TitleText.Text = "WHEELCHAIR ESCAPE"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.Font = Enum.Font.FredokaOne
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Header

-- Content Frame
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

-- Helper Function: Create Toggle Buttons
local function createToggleRow(name, key, layoutOrder)
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

-- Render Toggles
createToggleRow("AUTO FARM", "AutoFarm", 1)
createToggleRow("AUTO SPEED", "AutoSpeed", 2)
createToggleRow("AUTO WIN", "AutoWin", 3)
createToggleRow("CLAIM REWARDS", "ClaimRewards", 4)

-- ====================================================================
-- AUTOMATION & MECHANICS LOGIC
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

-- Safe Remote Helper
local function fireRemote(remotePath, ...)
    local args = {...}
    pcall(function()
        local current = ReplicatedStorage
        for _, name in ipairs(remotePath) do
            current = current:FindFirstChild(name)
        end
        if current then
            if current:IsA("RemoteEvent") then
                current:FireServer(unpack(args))
            elseif current:IsA("RemoteFunction") then
                current:InvokeServer(unpack(args))
            end
        end
    end)
end

-- 1 & 2. AUTO FARM & AUTO SPEED (Auto Clicking & Tapping Remotes)
local function processSpeedAndFarm()
    if Config.AutoFarm or Config.AutoSpeed then
        fireRemote({"Events", "AddSpeed"})
        fireRemote({"Events", "Click"})
        fireRemote({"Remotes", "AddSpeed"})
        fireRemote({"Network", "Tap"})
    end
end

-- 3. AUTO WIN (Teleports to the Finish Line / Wins Part)
local function processAutoWin()
    if not Config.AutoWin or not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name == "Finish" or part.Name == "Win" or part.Name == "EndPad") then
            pcall(function()
                Character.HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 3, 0)
            end)
            break
        end
    end
end

-- 4. CLAIM REWARDS (Gifts & Playtime Tasks)
local function processClaimRewards()
    if not Config.ClaimRewards then return end
    for i = 1, 12 do
        fireRemote({"Events", "ClaimGift"}, i)
        fireRemote({"Remotes", "ClaimReward"}, i)
    end
    fireRemote({"Events", "ClaimDaily"})
end

-- Main Task Loop Thread
task.spawn(function()
    print("[Wheel Chair Escape] Script running.")
    while task.wait(0.15) do
        processSpeedAndFarm()
        if Config.AutoWin then
            processAutoWin()
        end
        if Config.ClaimRewards then
            processClaimRewards()
        end
    end
end)
