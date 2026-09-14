-- By FTAP Reverse Bot (исправленная версия)
-- t.me/ReverseFTAP

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Загрузка библиотеки SolarisUI
local Solaris = loadstring(game:HttpGet("https://raw.githubusercontent.com/katnaa-debug/SolarisUI/refs/heads/main/Lib.lua"))()

-- Сохранение начальных параметров мира
local WorldBackup = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows
}
local SkyBackup = {}
for _, obj in ipairs(Lighting:GetChildren()) do
    if obj:IsA("Sky") or obj:IsA("Atmosphere") then
        table.insert(SkyBackup, obj:Clone())
    end
end

-- Конфигурации
local ESPConfig = {
    OutlineEnabled = false,
    OutlineFillColor = Color3.fromRGB(150, 80, 255),
    NoOutlineEnabled = false,
    NoOutlineFillColor = Color3.fromRGB(150, 80, 255)
}

local LineConfig = {
    Enabled = false,
    BeamColor = Color3.fromRGB(255, 255, 255),
    Width = 1,
    TextureID = "rbxassetid://446111271",
    TextureSpeed = 2
}

local PalletConfig = {
    Color = Color3.fromRGB(139, 69, 19),
    Image = "",
    AutoApply = false,
    CustomMaterial = false,
    Material = Enum.Material.Plastic,
    XRayEnabled = false,
    XRayColor = Color3.fromRGB(100, 200, 255),
    XRayTransparency = 60
}

local FovConfig = {
    FovValue = 90,
    FovEnabled = false,
    DefaultFov = Camera.FieldOfView,
    FogEnabled = false,
    FogColor = Lighting.FogColor,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd
}

-- Кэши для восстановления материалов
local MaterialCache = {}
local SoapCache = setmetatable({}, { __mode = "k" })

-- Получение папок с игрушками (паллетами)
local LocalToysFolderName = LocalPlayer.Name .. "SpawnedInToys"
local ToysFolder = Workspace:FindFirstChild(LocalToysFolderName) or Workspace:WaitForChild(LocalToysFolderName)

local MenuToys = ReplicatedStorage:FindFirstChild("MenuToys")
local DestroyToyRemote
if MenuToys then
    DestroyToyRemote = MenuToys:FindFirstChild("DestroyToy")
end

-- Список материалов
local MaterialNames = {}
for _, mat in ipairs(Enum.Material:GetEnumItems()) do
    table.insert(MaterialNames, mat.Name)
end
table.sort(MaterialNames)

-- --- СОЗДАНИЕ GUI ---
local Window = Solaris:CreateWindow({
    Title = "Omnius Visuals",
    Theme = {
        Font = "Roboto",
        ImageTransparency = 15,
        BGTransparency = 65,
        OrbsTransparency = 100,
        BackgroundID = "1288582613",
        Main = Color3.fromRGB(20, 15, 30),
        Second = Color3.fromRGB(30, 25, 45),
        ElementAccent = Color3.fromRGB(90, 60, 130),
        TextColor = Color3.fromRGB(210, 190, 230),
        GradientStart = Color3.fromRGB(120, 70, 180),
        GradientEnd = Color3.fromRGB(40, 20, 60)
    },
    ToggleKey = Enum.KeyCode.RightShift,
    Transparency = 0.25,
    ShowWatermark = {
        Enabled = true,
        Title = false,
        User = false,
        FPS = true,
        Time = false,
        Ping = true
    },
    AutoSave = true,
    ConfigFolder = "Omnius-Visual",
    CustomIcon = "1288582613"
})

-- --- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ---

-- Сохранить оригинальные свойства части
local function CachePart(part)
    if not MaterialCache[part] then
        MaterialCache[part] = {
            Material = part.Material,
            Color = part.Color,
            Transparency = part.Transparency
        }
    end
end

-- Применить настройки к отдельной части
local function ApplyToPart(part)
    if not part:IsA("BasePart") then return end
    if part.Name == "HoldPart" then return end

    CachePart(part)

    pcall(function()
        if PalletConfig.XRayEnabled then
            local tween = TweenService:Create(part, TweenInfo.new(0.5), {
                Color = PalletConfig.XRayColor,
                Transparency = PalletConfig.XRayTransparency / 100
            })
            tween:Play()
            part.Material = Enum.Material.ForceField

            local glow = part:FindFirstChild("XRayGlow")
            if not glow then
                glow = Instance.new("PointLight")
                glow.Name = "XRayGlow"
                glow.Parent = part
                glow.Range = 6
                glow.Brightness = 0.5
                glow.Shadows = false
            end
            glow.Color = PalletConfig.XRayColor

            for _, child in ipairs(part:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 1
                end
            end
            return
        end

        -- Удалить свечение если X-Ray выключен
        local glow = part:FindFirstChild("XRayGlow")
        if glow then glow:Destroy() end

        if PalletConfig.CustomMaterial then
            part.Material = PalletConfig.Material
        else
            part.Material = MaterialCache[part].Material
        end

        if PalletConfig.AutoApply then
            local tween = TweenService:Create(part, TweenInfo.new(0.5), {
                Color = PalletConfig.Color,
                Transparency = MaterialCache[part].Transparency
            })
            tween:Play()
            if PalletConfig.Image ~= "" then
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child:Destroy()
                    end
                end
                local decal = Instance.new("Decal")
                decal.Texture = PalletConfig.Image
                decal.Face = Enum.NormalId.Top
                decal.Parent = part
            end
        else
            if not PalletConfig.CustomMaterial then
                local tween = TweenService:Create(part, TweenInfo.new(0.5), {
                    Color = MaterialCache[part].Color,
                    Transparency = MaterialCache[part].Transparency
                })
                tween:Play()
                for _, child in ipairs(part:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = 0
                    end
                end
            end
        end
    end)
end

-- Обработка модели паллеты
local function HandlePallet(model)
    if not model:IsA("Model") or not string.find(model.Name, "Pallet") then return end
    if MaterialCache[model] then return end  -- уже обработано

    MaterialCache[model] = true

    for _, part in ipairs(model:GetDescendants()) do
        ApplyToPart(part)
    end

    local conn1 = model.DescendantAdded:Connect(function(child)
        task.wait()
        ApplyToPart(child)
    end)

    local conn2 = model.AncestryChanged:Connect(function()
        if not model.Parent then
            conn1:Disconnect()
            MaterialCache[model] = nil
            for _, desc in ipairs(model:GetDescendants()) do
                MaterialCache[desc] = nil
            end
        end
    end)
end

-- Применить ко всем существующим паллетам
local function ApplyToAllPallets()
    for _, child in ipairs(ToysFolder:GetChildren()) do
        if string.find(child.Name, "Pallet") then
            for _, part in ipairs(child:GetDescendants()) do
                ApplyToPart(part)
            end
        end
    end
end

-- Запуск отслеживания новых паллет
local ChildAddedConn
local function StartPalletWatcher()
    for _, child in ipairs(ToysFolder:GetChildren()) do
        task.spawn(HandlePallet, child)
    end
    if not ChildAddedConn then
        ChildAddedConn = ToysFolder.ChildAdded:Connect(function(child)
            task.wait(0.1)
            HandlePallet(child)
        end)
    end
end
StartPalletWatcher()

-- --- ФУНКЦИИ ДЛЯ СКАЙБОКСА ---
local function SetSkybox(id)
    if id == "" or not id then return end
    local num = tonumber(id)
    if not num then return end

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") or obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end

    pcall(function()
        local assets = game:GetObjects("rbxassetid://" .. num)
        if assets and #assets > 0 then
            assets[1].Parent = Lighting
        end
    end)
end

-- --- ФОГ ---
local function UpdateFog()
    if FovConfig.FogEnabled then
        Lighting.FogColor = FovConfig.FogColor
        Lighting.FogStart = FovConfig.FogStart
        Lighting.FogEnd = FovConfig.FogEnd
    else
        Lighting.FogColor = WorldBackup.FogColor
        Lighting.FogStart = WorldBackup.FogStart
        Lighting.FogEnd = WorldBackup.FogEnd
    end
end

-- Восстановление мира
local function ResetWorld()
    Lighting.ClockTime = WorldBackup.ClockTime
    Lighting.Brightness = WorldBackup.Brightness
    Lighting.Ambient = WorldBackup.Ambient
    Lighting.OutdoorAmbient = WorldBackup.OutdoorAmbient
    Lighting.FogColor = WorldBackup.FogColor
    Lighting.FogStart = WorldBackup.FogStart
    Lighting.FogEnd = WorldBackup.FogEnd
    Lighting.GlobalShadows = WorldBackup.GlobalShadows

    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") or obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end
    for _, copy in ipairs(SkyBackup) do
        copy:Clone().Parent = Lighting
    end

    FovConfig.FogEnabled = false
    Solaris:Notify({ Title = "World", Content = "Restored to Defaults", Duration = 2 })
end

-- --- ОБРАБОТКА ЦВЕТОВ КАРТЫ ---
local MapColors = {}
local MapGroups = {
    Snow = {},
    Sand = {},
    Grass = {},
    LushGrass = {},
    Rock = {},
    WasteGrass = {}
}

for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("BasePart") and MapGroups[obj.Name] then
        table.insert(MapGroups[obj.Name], obj)
        if not MapColors[obj] then
            MapColors[obj] = obj.Color
        end
    end
end

local function GetGroupColor(name, default)
    local group = MapGroups[name]
    if group and #group > 0 then
        return group[1].Color
    end
    return default
end

local function SetGroupColor(name, color)
    local group = MapGroups[name]
    if group then
        for _, part in ipairs(group) do
            if part and part.Parent then
                part.Color = color
            end
        end
    end
end

local function ResetMapColors()
    for part, color in pairs(MapColors) do
        if part and part.Parent then
            part.Color = color
        end
    end
    Solaris:Notify({ Title = "Map", Content = "Colors Restored", Duration = 2 })
end

-- --- СОЗДАНИЕ ВКЛАДОК И ЭЛЕМЕНТОВ ---

-- Вкладка "Players"
local PlayersTab = Window:CreateTab("Players", true)
local BlockOutline = PlayersTab:CreateBlock({ Name = "ESP With Outline", Side = "Left" })
local BlockNoOutline = PlayersTab:CreateBlock({ Name = "ESP Without Outline", Side = "Right" })

BlockOutline:CreateToggle({
    Name = "Enable ESP (Outline)",
    Default = false,
    Callback = function(val) ESPConfig.OutlineEnabled = val end
})
BlockOutline:CreateColorPicker({
    Name = "Fill Color",
    Default = ESPConfig.OutlineFillColor,
    Callback = function(val) ESPConfig.OutlineFillColor = val end
})

BlockNoOutline:CreateToggle({
    Name = "Enable ESP (Fill Only)",
    Default = false,
    Callback = function(val) ESPConfig.NoOutlineEnabled = val end
})
BlockNoOutline:CreateColorPicker({
    Name = "Fill Color",
    Default = ESPConfig.NoOutlineFillColor,
    Callback = function(val) ESPConfig.NoOutlineFillColor = val end
})

-- Вкладка "Line"
local LineTab = Window:CreateTab("Line", true)
local BlockLineVis = LineTab:CreateBlock({ Name = "Visual Settings", Side = "Left" })
local BlockLineProps = LineTab:CreateBlock({ Name = "Properties", Side = "Right" })

BlockLineVis:CreateToggle({
    Name = "Enable Custom Line",
    Default = false,
    Callback = function(val) LineConfig.Enabled = val end
})
BlockLineVis:CreateInput({
    Name = "Texture Image (ID)",
    Placeholder = "ID",
    Default = "",
    Callback = function(val)
        if tonumber(val) then
            LineConfig.TextureID = "rbxassetid://" .. val
        elseif val == "" then
            LineConfig.TextureID = "rbxassetid://446111271"
        else
            LineConfig.TextureID = val
        end
    end
})
BlockLineVis:CreateColorPicker({
    Name = "Beam Color",
    Default = LineConfig.BeamColor,
    Callback = function(val) LineConfig.BeamColor = val end
})
BlockLineProps:CreateSlider({
    Name = "Line Width",
    Min = 0,
    Max = 5000,
    Default = 10,
    Callback = function(val) LineConfig.Width = val / 10 end
})
BlockLineProps:CreateSlider({
    Name = "Anim Speed",
    Min = 0,
    Max = 5000,
    Default = 2,
    Callback = function(val) LineConfig.TextureSpeed = val end
})

-- Вкладка "Pallets"
local PalletsTab = Window:CreateTab("Pallets", true)
local BlockXRay = PalletsTab:CreateBlock({ Name = "X-Ray & Vision", Side = "Left" })
local BlockMat = PalletsTab:CreateBlock({ Name = "Material & Texture", Side = "Right" })

BlockXRay:CreateToggle({
    Name = "X-Ray Mode",
    Default = false,
    Callback = function(val)
        PalletConfig.XRayEnabled = val
        ApplyToAllPallets()
    end
})
BlockXRay:CreateColorPicker({
    Name = "X-Ray Color",
    Default = PalletConfig.XRayColor,
    Callback = function(val)
        PalletConfig.XRayColor = val
        if PalletConfig.XRayEnabled then ApplyToAllPallets() end
    end
})
BlockXRay:CreateSlider({
    Name = "Transparency",
    Min = 0,
    Max = 100,
    Default = 60,
    Callback = function(val)
        PalletConfig.XRayTransparency = val
        if PalletConfig.XRayEnabled then ApplyToAllPallets() end
    end
})

BlockMat:CreateSection("Material Override")
BlockMat:CreateToggle({
    Name = "Custom Material",
    Default = false,
    Callback = function(val)
        PalletConfig.CustomMaterial = val
        ApplyToAllPallets()
    end
})
BlockMat:CreateDropdown({
    Name = "Select Material",
    Items = MaterialNames,
    Default = "Plastic",
    Callback = function(val)
        PalletConfig.Material = Enum.Material[val]
        if PalletConfig.CustomMaterial then ApplyToAllPallets() end
    end
})
BlockMat:CreateSection("Texture Override")
BlockMat:CreateToggle({
    Name = "Auto Apply (Color/Img)",
    Default = false,
    Callback = function(val)
        PalletConfig.AutoApply = val
        ApplyToAllPallets()
    end
})
BlockMat:CreateColorPicker({
    Name = "Pallet Color",
    Default = PalletConfig.Color,
    Callback = function(val)
        PalletConfig.Color = val
        if PalletConfig.AutoApply then ApplyToAllPallets() end
    end
})
BlockMat:CreateInput({
    Name = "Pallet Image ID",
    Placeholder = "ID",
    Default = "",
    Callback = function(val)
        if tonumber(val) then
            PalletConfig.Image = "rbxassetid://" .. val
        else
            PalletConfig.Image = val
        end
        if PalletConfig.AutoApply then ApplyToAllPallets() end
    end
})

-- Вкладка "World"
local WorldTab = Window:CreateTab("World", true)
local BlockEnv = WorldTab:CreateBlock({ Name = "Environment", Side = "Left" })
local BlockMap = WorldTab:CreateBlock({ Name = "Map Customizer", Side = "Left" })
local BlockFog = WorldTab:CreateBlock({ Name = "Fog & System", Side = "Right" })

-- Map colors
BlockMap:CreateColorPicker({
    Name = "Snow Color",
    Default = GetGroupColor("Snow", Color3.fromRGB(255,255,255)),
    Callback = function(val) SetGroupColor("Snow", val) end
})
BlockMap:CreateColorPicker({
    Name = "Sand Color",
    Default = GetGroupColor("Sand", Color3.fromRGB(194,178,128)),
    Callback = function(val) SetGroupColor("Sand", val) end
})
BlockMap:CreateColorPicker({
    Name = "Grass Color",
    Default = GetGroupColor("Grass", Color3.fromRGB(110,148,56)),
    Callback = function(val) SetGroupColor("Grass", val) end
})
BlockMap:CreateColorPicker({
    Name = "Grass 2 Color",
    Default = GetGroupColor("LushGrass", Color3.fromRGB(82,124,38)),
    Callback = function(val) SetGroupColor("LushGrass", val) end
})
BlockMap:CreateColorPicker({
    Name = "Rock Color",
    Default = GetGroupColor("Rock", Color3.fromRGB(120,120,120)),
    Callback = function(val) SetGroupColor("Rock", val) end
})
BlockMap:CreateColorPicker({
    Name = "Waste Grass",
    Default = GetGroupColor("WasteGrass", Color3.fromRGB(100,100,70)),
    Callback = function(val) SetGroupColor("WasteGrass", val) end
})
BlockMap:CreateButton({
    Name = "Reset Map Colors",
    Callback = ResetMapColors
})

-- Environment
BlockEnv:CreateSlider({
    Name = "Time of Day",
    Min = 0,
    Max = 24,
    Default = 12,
    Callback = function(val) Lighting.ClockTime = val end
})
BlockEnv:CreateSlider({
    Name = "Brightness",
    Min = 0,
    Max = 10,
    Default = 2,
    Callback = function(val) Lighting.Brightness = val end
})
BlockEnv:CreateColorPicker({
    Name = "Ambient Color",
    Default = Lighting.OutdoorAmbient,
    Callback = function(val)
        Lighting.OutdoorAmbient = val
        Lighting.Ambient = val
    end
})
BlockEnv:CreateInput({
    Name = "Skybox ID",
    Placeholder = "ID",
    Default = "",
    Callback = SetSkybox
})

-- Fog
BlockFog:CreateToggle({
    Name = "Enable Fog",
    Default = false,
    Callback = function(val)
        FovConfig.FogEnabled = val
        UpdateFog()
    end
})
BlockFog:CreateColorPicker({
    Name = "Fog Color",
    Default = Lighting.FogColor,
    Callback = function(val)
        FovConfig.FogColor = val
        if FovConfig.FogEnabled then Lighting.FogColor = val end
    end
})
BlockFog:CreateSlider({
    Name = "Fog Distance",
    Min = 10,
    Max = 5000,
    Default = 1000,
    Callback = function(val)
        FovConfig.FogEnd = val
        if FovConfig.FogEnabled then Lighting.FogEnd = val end
    end
})
BlockFog:CreateSlider({
    Name = "Fog Start",
    Min = 0,
    Max = 500,
    Default = 0,
    Callback = function(val)
        FovConfig.FogStart = val
        if FovConfig.FogEnabled then Lighting.FogStart = val end
    end
})
BlockFog:CreateButton({
    Name = "Reset World Defaults",
    Callback = ResetWorld
})

-- Вкладка "Other"
local OtherTab = Window:CreateTab("Other", true)
local BlockCam = OtherTab:CreateBlock({ Name = "Camera", Side = "Left" })
local BlockServer = OtherTab:CreateBlock({ Name = "Server & Actions", Side = "Right" })

-- Camera
BlockCam:CreateSlider({
    Name = "FOV Value",
    Min = 1,
    Max = 120,
    Default = 70,
    Callback = function(val)
        FovConfig.FovValue = val
        if FovConfig.FovEnabled then Camera.FieldOfView = val end
    end
})
BlockCam:CreateKeybind({
    Name = "Toggle FOV Key",
    Default = Enum.KeyCode.V,
    Callback = function()
        FovConfig.FovEnabled = not FovConfig.FovEnabled
        if FovConfig.FovEnabled then
            Camera.FieldOfView = FovConfig.FovValue
            Solaris:Notify({ Title = "FOV", Content = "Enabled", Duration = 1 })
        else
            Camera.FieldOfView = FovConfig.DefaultFov
            Solaris:Notify({ Title = "FOV", Content = "Disabled", Duration = 1 })
        end
    end
})

-- Server
BlockServer:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        Solaris:Notify({ Title = "Rejoin", Content = "Rejoining...", Duration = 3 })
        if #Players:GetPlayers() <= 1 then
            LocalPlayer:Kick("Rejoining...")
            task.wait()
        end
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

BlockServer:CreateKeybind({
    Name = "Delete Pallets (Bind)",
    Default = Enum.KeyCode.Delete,
    Callback = function()
        if not DestroyToyRemote then
            Solaris:Notify({ Title = "Error", Content = "Remote not found!", Duration = 3 })
            return
        end
        local count = 0
        for _, child in ipairs(ToysFolder:GetChildren()) do
            if string.find(child.Name, "Pallet") then
                DestroyToyRemote:FireServer(child)
                count = count + 1
            end
        end
        if count > 0 then
            Solaris:Notify({ Title = "Pallets", Content = "Removed " .. count .. " items", Duration = 2 })
        else
            Solaris:Notify({ Title = "Pallets", Content = "No pallets found", Duration = 2 })
        end
    end
})

BlockServer:CreateButton({
    Name = "Clear All Toys (FPS Boost)",
    Callback = function()
        local deleted = 0
        for _, player in ipairs(Players:GetPlayers()) do
            local folder = Workspace:FindFirstChild(player.Name .. "SpawnedInToys")
            if folder then
                for _, obj in ipairs(folder:GetChildren()) do
                    obj:Destroy()
                    deleted = deleted + 1
                end
            end
        end
        if deleted > 0 then
            Solaris:Notify({ Title = "Optimization", Content = "Deleted " .. deleted .. " objects locally!", Duration = 3 })
        else
            Solaris:Notify({ Title = "Optimization", Content = "No objects found to delete.", Duration = 2 })
        end
    end
})

-- Soap Textures (FPS Boost)
local SoapConn
BlockServer:CreateToggle({
    Name = "Soap Textures (FPS Boost)",
    Default = false,
    Callback = function(val)
        if val then
            Solaris:Notify({ Title = "Optimization", Content = "Applying Soap Textures...", Duration = 2 })
            task.spawn(function()
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        if not SoapCache[obj] then
                            SoapCache[obj] = { Material = obj.Material, Color = obj.Color }
                        end
                        obj.Material = Enum.Material.Plastic
                        obj.Color = Color3.new(obj.Color.R * 0.7, obj.Color.G * 0.7, obj.Color.B * 0.7)
                    elseif obj:IsA("Texture") or obj:IsA("Decal") then
                        if not SoapCache[obj] then
                            SoapCache[obj] = { Transparency = obj.Transparency }
                        end
                        obj.Transparency = 1
                    end
                end
                Solaris:Notify({ Title = "Optimization", Content = "Soap Textures Applied!", Duration = 2 })
            end)
            SoapConn = Workspace.DescendantAdded:Connect(function(child)
                task.wait()
                if child:IsA("BasePart") then
                    if not SoapCache[child] then
                        SoapCache[child] = { Material = child.Material, Color = child.Color }
                    end
                    child.Material = Enum.Material.Plastic
                    child.Color = Color3.new(child.Color.R * 0.7, child.Color.G * 0.7, child.Color.B * 0.7)
                elseif child:IsA("Texture") or child:IsA("Decal") then
                    if not SoapCache[child] then
                        SoapCache[child] = { Transparency = child.Transparency }
                    end
                    child.Transparency = 1
                end
            end)
        else
            Solaris:Notify({ Title = "Optimization", Content = "Restoring Map...", Duration = 2 })
            if SoapConn then SoapConn:Disconnect() end
            task.spawn(function()
                for obj, data in pairs(SoapCache) do
                    if obj and obj.Parent then
                        if obj:IsA("BasePart") then
                            obj.Material = data.Material
                            obj.Color = data.Color
                        elseif obj:IsA("Texture") or obj:IsA("Decal") then
                            obj.Transparency = data.Transparency
                        end
                    end
                end
                SoapCache = setmetatable({}, { __mode = "k" })
                Solaris:Notify({ Title = "Optimization", Content = "Map Restored!", Duration = 2 })
            end)
        end
    end
})

-- --- ОСНОВНОЙ ЦИКЛ (Heartbeat) ---
RunService.Heartbeat:Connect(function()
    -- ESP
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local highlight = char:FindFirstChild("OmniusESP")
            if ESPConfig.OutlineEnabled or ESPConfig.NoOutlineEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "OmniusESP"
                    highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    highlight.Parent = char
                end
                if ESPConfig.OutlineEnabled then
                    highlight.FillColor = ESPConfig.OutlineFillColor
                    highlight.OutlineColor = Color3.fromRGB(255,255,255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                elseif ESPConfig.NoOutlineEnabled then
                    highlight.FillColor = ESPConfig.NoOutlineFillColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 1
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end

    -- Custom Line (GrabBeam)
    if LineConfig.Enabled then
        local grabParts = Workspace:FindFirstChild("GrabParts")
        if grabParts then
            for _, child in ipairs(grabParts:GetDescendants()) do
                if child:IsA("Beam") and child.Name == "GrabBeam" then
                    child.Texture = LineConfig.TextureID
                    child.Color = ColorSequence.new(LineConfig.BeamColor)
                    child.Width0 = LineConfig.Width
                    child.Width1 = LineConfig.Width
                    child.TextureSpeed = LineConfig.TextureSpeed
                    child.TextureMode = Enum.TextureMode.Wrap
                    child.TextureLength = 1
                    child.LightEmission = 1
                    child.Transparency = NumberSequence.new(0)
                end
            end
        end
    end
end)
