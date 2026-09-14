local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ============ Silent Aim ============
local silentAimEnabled = true
local targetPlayer = nil
local MAX_DISTANCE = 30

if not getgenv().Settings then
    getgenv().Settings = {
        Fov = 150,
        Hitbox = { "Torso" },
        FovCircle = false
    }
end
local Settings = getgenv().Settings

local function getClosestTarget()
    local closest = nil
    local closestDist = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and LocalPlayer.Character then
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                local hitboxName = Settings.Hitbox[math.random(1, #Settings.Hitbox)]
                local hitPart = plr.Character:FindFirstChild(hitboxName)
                if hitPart then
                    local dist = (myRoot.Position - hitPart.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    targetPlayer = getClosestTarget()
end)

local oldNamecall
if hookmetamethod then
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if self == workspace and not checkcaller() and method == "Raycast" then
            if targetPlayer and silentAimEnabled then
                local tp = targetPlayer
                local char = tp and tp.Character
                local myChar = LocalPlayer.Character
                if char and myChar
                    and char:FindFirstChild("HumanoidRootPart")
                    and char:FindFirstChildOfClass("Humanoid")
                    and char.Humanoid.Health > 0
                    and myChar:FindFirstChild("HumanoidRootPart")
                    and not (tp:FindFirstChild("InPlot") and tp.InPlot.Value)
                then
                    local myRoot = myChar.HumanoidRootPart
                    local theirRoot = char.HumanoidRootPart
                    if (myRoot.Position - theirRoot.Position).Magnitude <= MAX_DISTANCE then
                        local hitboxName = Settings.Hitbox[math.random(1, #Settings.Hitbox)]
                        local hitPart = char:FindFirstChild(hitboxName)
                        if hitPart then
                            local args = { ... }
                            args[3] = (hitPart.Position - args[2]).Unit * 1000
                            local rp = RaycastParams.new()
                            rp.FilterDescendantsInstances = { char }
                            rp.FilterType = Enum.RaycastFilterType.Include
                            args[4] = rp
                            return oldNamecall(self, unpack(args))
                        end
                    end
                end
            end
        end
        return oldNamecall(self, ...)
    end)
end
