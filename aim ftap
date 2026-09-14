local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TargetKONES
local function GetClosest(FOV)
    local Target = nil
    local Closest = FOV or math.huge

    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= game.Players.LocalPlayer
            and Player.Character
            and Player.Character:FindFirstChild("HumanoidRootPart") then

            local Distance = (Player.Character.HumanoidRootPart.Position
                - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if Distance < Closest then
                Closest = Distance
                Target = Player
            end
        end
    end

    return Target
end
local function click()
    local VIM = game:GetService("VirtualInputManager")
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.1)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end
local function HasFartherReach()
    local success, result = pcall(function()
        return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(
            game.Players.LocalPlayer.UserId,
            20837132
        )
    end)

    return success and result
end
local function aim(trueorfalse)
    local result = trueorfalse and 30 or 20
    local TargetKONES = GetClosest(result)
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, TargetKONES.Character.HumanoidRootPart.Position)
    click()
end

aim(HasFartherReach())
