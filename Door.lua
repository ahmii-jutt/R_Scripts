-- ====================================================================
-- DOORS AUTOMATION SCRIPT WITH WORKING AUTO UNLOCK & MOBILE UI
-- Target Game: DOORS (Roblox)
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
    InteractRadius = 18
}

-- Old UI Clean Up
if CoreGui:FindFirstChild("DoorsCheatUI") then
    CoreGui.DoorsCheatUI:Destroy()
end

-- ====================================================================
-- MOBILE RESPONSIVE UI
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DoorsCheatUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.38, 0, 0.48, 0)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

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
    ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = true
    ToggleButton.Parent = RowFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ToggleButton

    ToggleButton.MouseButton1Click:Connect(function()
        Config[key] = not Config[key]
        if Config[key] then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 215, 45)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(215, 45, 45)
        end
    end)
end

createToggleRow("AUTO INTERACT", "AutoInteract", 1)
createToggleRow("AUTO UNLOCK", "AutoUnlock", 2)
createToggleRow("SPEED HACK", "SpeedHack", 3)

-- ====================================================================
-- AUTOMATION & FIXES
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    if Config.SpeedHack and Humanoid and Humanoid.Parent then
        if Humanoid.MoveDirection.Magnitude > 0 then
            Character:TranslateBy(Humanoid.MoveDirection * (Config.CustomSpeed / 50))
        end
    end
end)

-- Auto Unlock Handler (Direct Key Interaction Fix)
local function tryUnlockDoor(lockPart)
    local keyTool = Character:FindFirstChild("Key") or LocalPlayer.Backpack:FindFirstChild("Key")
    if keyTool then
        -- Equip key automatically
        if keyTool.Parent == LocalPlayer.Backpack then
            keyTool.Parent = Character
        end
        -- Trigger doors unlock module event
        pcall(function()
            if lockPart:FindFirstChild("LockPrompt") then
                fireproximityprompt(lockPart.LockPrompt)
            elseif lockPart:FindFirstChild("UnlockEvent") then
                lockPart.UnlockEvent:FireServer()
            end
        end)
    end
end

-- Main Task Loop
task.spawn(function()
    while task.wait(0.15) do
        if Character and Character:FindFirstChild("HumanoidRootPart") then
            local RootPart = Character.HumanoidRootPart

            -- AUTO UNLOCK SCAN
            if Config.AutoUnlock then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj.Name == "Lock" or obj.Name == "Keyhole") and obj:IsA("BasePart") then
                        if (RootPart.Position - obj.Position).Magnitude <= Config.InteractRadius then
                            tryUnlockDoor(obj)
                        end
                    end
                end
            end

            -- AUTO INTERACT SCAN
            if Config.AutoInteract then
                for _, desc in ipairs(Workspace:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") and desc.Enabled then
                        if desc.Parent and desc.Parent:IsA("BasePart") then
                            if (RootPart.Position - desc.Parent.Position).Magnitude <= Config.InteractRadius then
                                pcall(function() fireproximityprompt(desc) end)
                            end
                        end
                    end
                end
            end

        end
    end
end)
