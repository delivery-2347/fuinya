local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GrabEvents = ReplicatedStorage:WaitForChild("GrabEvents")
local SetNetworkOwner = GrabEvents:WaitForChild("SetNetworkOwner")
local DestroyGrabLine = GrabEvents:WaitForChild("DestroyGrabLine")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")
local tar = Workspace.mot_2288.HumanoidRootPart
RunService.Heartbeat:Connect(function()
    local target = HRP.Position + Vector3.new(0, 10, 0)
    local direction = target - tar.Position
    SetNetworkOwner:FireServer(tar, tar.CFrame)
    if direction.Magnitude > 1 then
        tar.AssemblyLinearVelocity = direction.Unit * 50
    else
        tar.AssemblyLinearVelocity = Vector3.zero
    end
    DestroyGrabLine:FireServer(tar) 
    SetNetworkOwner:FireServer(tar, tar.CFrame)
end)
