-- ====================================================================
-- +1 WALL HOP OBBY ESCAPE AUTOMATION SCRIPT WITH MOBILE RESPONSIVE UI
-- Target Game: +1 Wall Hop Obby Escape (Roblox)
-- Features: Speed Adjuster, Infinite Jump, Auto Wall Hop, Auto Teleport Stage
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration Flags
local Config = {
    SpeedHack = false,
    CustomSpeed = 35,
    InfiniteJump = false,
    AutoWallHop = false,
    AutoTeleport = false,
    TeleportDelay = 0.5
}

-- Destroy Previous UI Instance if re-executing
if CoreGui:FindFirstChild("WallHopObbyUI") then
    CoreGui.WallHopObbyUI:Destroy()
end

-- ====================================================================
-- MOBILE RESPONSIVE UI
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WallHopObbyUI"
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
Header.Parent = Header

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.8, 0, 1, 0)
TitleText.Position = UDim2.new(0.05, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "WALL HOP OBBY"
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

-- Helper Function: Create Toggle Row
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
createToggleRow("SPEED HACK", "SpeedHack", 1)
createToggleRow("INFINITE JUMP", "InfiniteJump", 2)
createToggleRow("AUTO WALL HOP", "AutoWallHop", 3)
createToggleRow("AUTO TELEPORT", "AutoTeleport", 4)

-- ====================================================================
-- AUTOMATION & MECHANICS LOGIC
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- 1. SPEED ADJUSTER
RunService.Heartbeat:Connect(function()
    if Config.SpeedHack and Humanoid and Humanoid.Parent then
        if Humanoid.MoveDirection.Magnitude > 0 then
            Character:TranslateBy(Humanoid.MoveDirection * (Config.CustomSpeed / 50))
        end
    end
end)

-- 2. INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and Humanoid and Humanoid.Parent then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 3. AUTO WALL HOP (Fires automatic jump when touching vertical surfaces)
RunService.Stepped:Connect(function()
    if Config.AutoWallHop and Character and Character:FindFirstChild("HumanoidRootPart") then
        local root = Character.HumanoidRootPart
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude

        -- Cast ray forward to detect walls
        local rayResult = Workspace:Raycast(root.Position, root.CFrame.LookVector * 2.5, raycastParams)
        if rayResult and rayResult.Instance then
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- 4. AUTO TELEPORT STAGE (Iterates through Obby Checkpoints)
local function getSortedStages()
    local stagesFolder = Workspace:FindFirstChild("Stages") or Workspace:FindFirstChild("Checkpoints")
    local stages = {}

    if stagesFolder then
        for _, stage in ipairs(stagesFolder:GetChildren()) do
            local stageNum = tonumber(stage.Name)
            if stageNum then
                table.insert(stages, {Num = stageNum, Part = stage})
            end
        end
        table.sort(stages, function(a, b) return a.Num < b.Num end)
    end

    return stages
end

task.spawn(function()
    while task.wait(Config.TeleportDelay) do
        if Config.AutoTeleport and Character and Character:FindFirstChild("HumanoidRootPart") then
            local stages = getSortedStages()
            for _, stageData in ipairs(stages) do
                if not Config.AutoTeleport then break end
                local stagePart = stageData.Part:IsA("BasePart") and stageData.Part or stageData.Part:FindFirstChildWhichIsA("BasePart")
                
                if stagePart then
                    Character.HumanoidRootPart.CFrame = stagePart.CFrame * CFrame.new(0, 3, 0)
                    task.wait(Config.TeleportDelay)
                end
            end
        end
    end
end)
