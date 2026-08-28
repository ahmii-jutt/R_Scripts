-- ====================================================================
-- MM2 OF THE LOCUST AUTOMATION SCRIPT WITH MOBILE RESPONSIVE UI
-- Target Game: MM2 of The Locust (Roblox)
-- Features: Kill All, Auto Gun Grab, Sheriff Silent Aim
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Script State Flags
local Config = {
    KillAll = false,
    AutoGunGrab = false,
    SilentAim = false
}

-- Destroy Previous UI Instance if re-executing
if CoreGui:FindFirstChild("MM2LocustUI") then
    CoreGui.MM2LocustUI:Destroy()
end

-- ====================================================================
-- MOBILE RESPONSIVE UI
-- ====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2LocustUI"
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

-- Header Title
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
TitleText.Text = "MM2 LOCUST"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextScaled = true
TitleText.Font = Enum.Font.FredokaOne
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = Header

-- Content Frame
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

-- Toggle Row Function
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

createToggleRow("KILL ALL", "KillAll", 1)
createToggleRow("AUTO GUN GRAB", "AutoGunGrab", 2)
createToggleRow("SILENT AIM", "SilentAim", 3)

-- ====================================================================
-- MECHANICS IMPLEMENTATION
-- ====================================================================

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

-- Helper: Get Target Murderer/Locust Player
local function getLocustPlayer()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            -- Check for Locust / Knife weapon in hand or backpack
            if plr.Character:FindFirstChild("Knife") or plr.Character:FindFirstChild("LocustBlade") or 
               (plr:FindFirstChild("Backpack") and (plr.Backpack:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("LocustBlade"))) then
                return plr.Character
            end
        end
    end
    return nil
end

-- 1. KILL ALL (Teleports & executes attacks on all survivors)
local function executeKillAll()
    if not Config.KillAll or not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local tool = Character:FindFirstChildOfClass("Tool")
    if not tool then return end

    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("Humanoid") then
            if target.Character.Humanoid.Health > 0 then
                -- Move to target
                Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                
                -- Trigger Tool Attack
                pcall(function()
                    tool:Activate()
                end)
                task.wait(0.1)
            end
        end
    end
end

-- 2. AUTO GUN GRAB (Detects dropped gun on map and teleports to claim)
local function executeAutoGunGrab()
    if not Config.AutoGunGrab or not Character or not Character:FindFirstChild("HumanoidRootPart") then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "GunDrop" or obj.Name == "DroppedGun" or (obj:IsA("Tool") and string.find(string.lower(obj.Name), "gun")) then
            local handle = obj:FindFirstChild("Handle") or obj
            if handle:IsA("BasePart") then
                pcall(function()
                    -- Teleport to gun drop position
                    Character.HumanoidRootPart.CFrame = handle.CFrame
                    -- Fire prompt if applicable
                    if obj:FindFirstChildOfClass("ProximityPrompt") then
                        fireproximityprompt(obj:FindFirstChildOfClass("ProximityPrompt"))
                    end
                end)
                break
            end
        end
    end
end

-- 3. SHERIFF SILENT AIM (Hook mouse/touch target to the Locust)
local rawMeta = getrawmetatable(game)
local oldIndex = rawMeta.__index
setreadonly(rawMeta, false)

rawMeta.__index = newcclosure(function(self, index)
    if not checkcaller() and Config.SilentAim and (index == "Hit" or index == "Target") then
        local locustChar = getLocustPlayer()
        if locustChar and locustChar:FindFirstChild("HumanoidRootPart") then
            if index == "Hit" then
                return locustChar.HumanoidRootPart.CFrame
            elseif index == "Target" then
                return locustChar.HumanoidRootPart
            end
        end
    end
    return oldIndex(self, index)
end)

setreadonly(rawMeta, true)

-- Main Loop Thread
task.spawn(function()
    while task.wait(0.2) do
        if Config.KillAll then
            executeKillAll()
        end
        if Config.AutoGunGrab then
            executeAutoGunGrab()
        end
    end
end)
