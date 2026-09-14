local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local FolderSpawnedInToys = player.Name .. "SpawnedInToys"
local Inventory = game:GetService("Workspace"):FindFirstChild(FolderSpawnedInToys)
local clone = Inventory.YouDecoy:Clone()
clone.Name = "pizdabole"
clone.Parent = workspace

for _, playerPart in ipairs(character:GetDescendants()) do
    if playerPart:IsA("BasePart") then
        for _, targetPart in ipairs(workspace.pizdabole:GetDescendants()) do
            if targetPart:IsA("BasePart") then
                local constraint = Instance.new("NoCollisionConstraint")
                constraint.Part0 = playerPart
                constraint.Part1 = targetPart
                constraint.Parent = playerPart
            end
        end
    end
end

task.spawn(function()
    RunService.Heartbeat:Connect(function()
        workspace.pizdabole.HumanoidRootPart.CFrame = workspace.YourPCLD.CFrame * CFrame.new(0, 0.5, 0.25)
    end)
end)

local function getMotors(model)
    local motors = {}

    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("Motor6D") then
            motors[v.Name] = v
        end
    end

    return motors
end

local myMotors = getMotors(character)
local cloneMotors = getMotors(clone)
local delayTime = 0.2
local history = {}

RunService.Heartbeat:Connect(function(dt)
    for name, myMotor in pairs(myMotors) do
        local cloneMotor = cloneMotors[name]

        if cloneMotor then
            history[name] = history[name] or {}

            table.insert(history[name], {
                time = os.clock(),
                transform = myMotor.Transform
            })

            while #history[name] > 0 and os.clock() - history[name][1].time >= delayTime do
                local old = table.remove(history[name], 1)
                cloneMotor.Transform = old.transform
            end
        end
    end
end)
