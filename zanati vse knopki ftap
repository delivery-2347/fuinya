local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SetNetworkOwner = ReplicatedStorage.GrabEvents.SetNetworkOwner
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")

local targetPlot = "Plot1" -- Plot1 - Plot2 - Plot3 - Plot4 - Plot5
do 
    local Plot = workspace.Plots:FindFirstChild(targetPlot)
    local PlotSign = Plot:FindFirstChild("PlotSign")
    
    for _, Sign in ipairs(PlotSign:GetChildren()) do
        HRP.AssemblyLinearVelocity = Vector3.zero
        HRP.AssemblyAngularVelocity = Vector3.zero
        if Sign.Name == "Sign" then
            task.spawn(function()
                for _, Plus in ipairs(Sign:GetDescendants()) do
                    if Plus.Name == "Plus" then
                        local PlusGrabPart = Plus:FindFirstChild("PlusGrabPart")
                        HRP.CFrame = PlusGrabPart.CFrame * CFrame.new(0, 0, 0)

                        task.wait(0.15)
                        if PlusGrabPart then
                            HRP.AssemblyLinearVelocity = Vector3.zero
                            HRP.AssemblyAngularVelocity = Vector3.zero
                            SetNetworkOwner:FireServer(PlusGrabPart, PlusGrabPart.CFrame)
                        end
                    end
                end
            end)
        end
    end
end
print("67")
