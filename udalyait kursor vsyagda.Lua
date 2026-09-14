local Players = game:GetService("Players")
local player = Players.LocalPlayer

local eneiblekursos = true

local function disableCrosshair()
    local playerGui = player:WaitForChild("PlayerGui")
    
    local crosshairs = playerGui:FindFirstChild("Crosshairs")
    if crosshairs then
        crosshairs.Enabled = false
    end
end

disableCrosshair()

Players.CharacterAdded:Connect(function()
    if not eneiblekursos then return end
    task.wait(0.5) 
    disableCrosshair()
end)
