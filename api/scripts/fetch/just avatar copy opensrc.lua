--[[
	WARNING: Heads up! This script has not been verified by MZX. Use at your own risk!
]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local lastUsername = nil

local function apply_avatar(username)
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid", 10)
        if not hum then return end

        local targetPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == username:lower() then
                targetPlayer = p
                break
            end
        end

        local desc
        if targetPlayer and targetPlayer.Character then
            local targetHum = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if targetHum then
                desc = targetHum:GetAppliedDescription()
            end
        end

        if not desc then
            local ok, userId = pcall(Players.GetUserIdFromNameAsync, Players, username)
            if not ok then warn("Not Found User") return end
            local ok2, d = pcall(Players.GetHumanoidDescriptionFromUserId, Players, userId)
            if not ok2 then warn("Bad") return end
            desc = d
        end

        for _, c in ipairs(char:GetChildren()) do
            if c:IsA("Accessory") or c:IsA("Hat") or c:IsA("BodyColors") or
               c:IsA("CharacterMesh") or c:IsA("Shirt") or c:IsA("Pants") or
               c:IsA("ShirtGraphic") then
                c:Destroy()
            end
        end

        pcall(function()
            if hum.ApplyDescriptionClientServer then
                hum:ApplyDescriptionClientServer(desc)
            else
                hum:ApplyDescription(desc)
            end
        end)

        local bc = char:FindFirstChildOfClass("BodyColors") or Instance.new("BodyColors")
        bc.Parent = char
        bc.HeadColor3 = desc.HeadColor
        bc.TorsoColor3 = desc.TorsoColor
        bc.LeftArmColor3 = desc.LeftArmColor
        bc.RightArmColor3 = desc.RightArmColor
        bc.LeftLegColor3 = desc.LeftLegColor
        bc.RightLegColor3 = desc.RightLegColor
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    if lastUsername then
        char:WaitForChild("Humanoid", 10)
        task.wait(0.65)
        apply_avatar(lastUsername)
    end
end)

local function start(username)
    lastUsername = username
    apply_avatar(username)
end

start("user name")
