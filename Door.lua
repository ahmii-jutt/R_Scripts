-- ====================================================================
-- DOORS AUTOMATION SCRIPT WITH MOBILE-FRIENDLY UI
-- Target Game: DOORS (Roblox)
-- Responsive UI scaled using Scale/Constraint for all aspect ratios
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- State Settings
local Config = {
    AutoInteract = false,
    AutoUnlock = false,
    SpeedHack = false,
    CustomSpeed = 22,
    InteractRadius = 15
}

-- Destroy old UI if re-executing
if CoreGui:FindFirstChild("DoorsCheatUI") then
    CoreGui.DoorsCheatUI:Destroy()
end

-- ====================================================================
-- UI BUILDING (Mobile & Tablet Friendly)
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DoorsCheatUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Main Container Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.35, 0, 0.45, 0) -- Relative scale for responsiveness
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Aspect Ratio / Scale Constraints
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
UIAspectRatioConstraint.AspectRatio = 1.3
UIAspectRatioConstraint.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Header Title Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0.2, 0)
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
ContentFrame.Size = UDim2.new(1, 0, 0.8, 0)
ContentFrame.Position = UDim2.new(0, 0, 0.2, 0)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0.05, 0)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- Helper Function: Create Toggle Row (Matching Image Style)
local function createToggleRow(name, key, layoutOrder)
    local RowFrame = Instance.new("Frame")
    RowFrame.Size = UDim2.new(0.9, 0, 0.25, 0)
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
    ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45) -- Default RED (OFF)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = true
    ToggleButton.Parent = RowFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ToggleButton

    -- Click Event Hook
    ToggleButton.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        if Config[key] then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 215, 45) -- GREEN (ON)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45) -- RED (OFF)
        end
    end)
end

-- Render Toggles
createToggleRow("AUTO INTERACT", "AutoInteract", 1)
createToggleRow("AUTO UNLOCK", "AutoUnlock", 2)
createToggleRow("SPEED HACK", "SpeedHack", 3)

-- ====================================================================
-- AUTOMATION MECHANICS
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- Speed Adjuster Loop
RunService.Heartbeat:Connect(function()
    if Config.SpeedHack and Humanoid and Humanoid.Parent then
        if Humanoid.MoveDirection.Magnitude > 0 then
            Character:TranslateBy(Humanoid.MoveDirection * (Config.CustomSpeed / 50))
        end
    end
end)

-- Auto Interact & Unlock Loop
task.spawn(function()
    while task.wait(0.2) do
        if (Config.AutoInteract or Config.AutoUnlock) and Character and Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Character.HumanoidRootPart

            for _, desc in ipairs(Workspace:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and desc.Enabled then
                    local parentObj = desc.Parent
                    if parentObj and parentObj:IsA("BasePart") then
                        local distance = (RootPart.Position - parentObj.Position).Magnitude

                        if distance <= Config.InteractRadius then
                            -- Auto Unlock
                            if Config.AutoUnlock and (string.find(string.lower(parentObj.Name), "keyhole") or string.find(string.lower(parentObj.Name), "lock")) then
                                pcall(function() fireproximityprompt(desc) end)
                            -- Auto Interact
                            elseif Config.AutoInteract then
                                pcall(function() fireproximityprompt(desc) end)
                            end
                        end
                    end
                end
            end
        end
    end
end)
