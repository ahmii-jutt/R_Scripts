-- ====================================================================
-- DOORS UTILITY & AUTOMATION SCRIPT (EXPERIMENTAL / PROOF OF CONCEPT)
-- Features: Auto Interacting, Auto Unlock, Speed Adjuster, Movement Tweaks
-- Target Game: DOORS (Roblox)
-- ====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration Flags
local Config = {
    AutoInteract = true,
    AutoUnlock = true,
    CustomSpeed = 22, -- Default DOORS walkspeed is around 15-16
    SpeedHackEnabled = true,
    InteractRadius = 15 -- Distance in studs to auto-interact
}

-- Re-acquire character reference upon respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- 1. SPEED & MOVEMENT ADJUSTER
-- Bypasses default walkspeed checks by binding to Heartbeat
RunService.Heartbeat:Connect(function()
    if Config.SpeedHackEnabled and Humanoid and Humanoid.Parent then
        if Humanoid.MoveDirection.Magnitude > 0 then
            Character:TranslateBy(Humanoid.MoveDirection * (Config.CustomSpeed / 50))
        end
    end
end)

-- 2. AUTO INTERACT & AUTO UNLOCK SYSTEM
local function scanAndInteract()
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local RootPart = Character.HumanoidRootPart

    -- Iterate through workspace objects for prompt triggers
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc:IsA("ProximityPrompt") and desc.Enabled then
            local parentObj = desc.Parent
            if parentObj and parentObj:IsA("BasePart") then
                local distance = (RootPart.Position - parentObj.Position).Magnitude
                
                if distance <= Config.InteractRadius then
                    -- AUTO UNLOCK: Target Keyhole / Locked Door Prompts
                    if Config.AutoUnlock and (string.find(string.lower(parentObj.Name), "keyhole") or string.find(string.lower(parentObj.Name), "lock")) then
                        pcall(function()
                            fireproximityprompt(desc)
                            print("[Auto Unlock] Interacted with keyhole/lock prompt.")
                        end)
                    
                    -- AUTO INTERACT: Pick up items, keys, knobs, drawer loot
                    elseif Config.AutoInteract then
                        pcall(function()
                            fireproximityprompt(desc)
                            print("[Auto Interact] Interacted with prompt: " .. desc.ObjectText .. " - " .. desc.ActionText)
                        end)
                    end
                end
            end
        end
    end
end

-- Main Execution Loop
task.spawn(function()
    print("[DOORS Automation] Engine Started Successfully.")
    
    while task.wait(0.2) do
        scanAndInteract()
    end
end)
