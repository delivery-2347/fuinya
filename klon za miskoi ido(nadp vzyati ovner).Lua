local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local mouse = LocalPlayer:GetMouse()
local PathfindingService = game:GetService("PathfindingService")

while task.wait(0.2) do
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        continue
    end

    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and not Players:GetPlayerFromCharacter(model) then
            local controller = model:FindFirstChildWhichIsA("Humanoid") or model:FindFirstChild("Pet")
            if controller and typeof(controller.MoveTo) == "function" then
                pcall(function()
                    controller.WalkSpeed = 100
                    controller:MoveTo(mouse.Hit.Position)
                end)
            end
        end
    end
end
