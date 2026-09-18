local Crosshair = loadstring(game:HttpGet(
    "https://pastebin.com/raw/qpgfFUP8"
))()

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/katnaa-debug/SolarisUI/refs/heads/main/Library1.lua"
))()

--==================================================
-- WINDOW
--==================================================

local Window = Library:CreateWindow({
    Title = "CUCUMBER • Crosshair",
    Theme = "Void",
    ToggleKey = Enum.KeyCode.RightShift,

    Transparency = 0.15,

    ShowWatermark = {
        Enabled = true,
        Title = true,
        User = false,
        FPS = true,
        Time = false,
        Ping = true
    },

    ConfigFolder = "CucumberCrosshair",
    CornerRadius = 10,
    UiScale = 1
})

--==================================================
-- CONFIG
--==================================================

local cfgCrosshair = {
    --==================================================
    -- MAIN
    --==================================================

    enabled = false,

    --==================================================
    -- RAINBOW
    --==================================================

    rainbow = false,
    rainbowSpeed = 1.5,

    --==================================================
    -- PULSE
    --==================================================

    pulseEnabled = true,
    pulseAmplitude = 2.5,
    pulseSpeed = 2,
    pulseLerpSpeed = 10,

    --==================================================
    -- ROTATION
    --==================================================

    rotationEnabled = false,
    rotationSpeed = 1,

    --==================================================
    -- SIZE
    --==================================================

    baseLength = 12,
    baseThickness = 2,
    outlineThicknessExtra = 2,
    baseGap = 5,
    opacity = 1,

    --==================================================
    -- POSITION
    --==================================================

    xOffset = 0,
    yOffset = 0,

    --==================================================
    -- OUTLINE
    --==================================================

    outlineEnabled = true,

    --==================================================
    -- SPREAD
    --==================================================

    spreadEnabled = true,

    baseSpread = 0,

    walkSpread = 4,
    runSpread = 10,
    jumpSpread = 14,
    fireSpread = 7,

    spreadLerpSpeed = 12,
    extraFromVelocityMultiplier = 0.7,

    walkSpeedThreshold = 2,
    runSpeedThreshold = 16,

    --==================================================
    -- TEXT
    --==================================================

    textEnabled = true,
    customText = "CUCUMBER",
    textSize = 16,
    textOutlineEnabled = true,
    textOffset = 18,
    textFont = "Code",

    --==================================================
    -- COLOR
    --==================================================

    fixedColor = Color3.fromRGB(62, 207, 142),

    --==================================================
    -- CENTER / MOUSE
    --==================================================

    unlockCenterEnabled = false,
    unlockSmoothEnabled = true,
    unlockLerpSpeed = 12,
}

--==================================================
-- APPLY
--==================================================

local function SetCrosshair(name, value)
    cfgCrosshair[name] = value
    Crosshair.CrosshairVars[name] = value
end

for name, value in pairs(cfgCrosshair) do
    Crosshair.CrosshairVars[name] = value
end

--==================================================
-- ONE TAB
--==================================================

local CrosshairTab = Window:CreateTab(
    "Crosshair",
    true,
    "6031075938"
)

--==================================================
-- LEFT: MAIN
--==================================================

local MainBlock = CrosshairTab:CreateBlock({
    Name = "Main",
    Side = "Left"
})

MainBlock:CreateToggle({
    Name = "Enabled",
    Default = cfgCrosshair.enabled,
    Flag = "enabled",
    Callback = function(v)
        SetCrosshair("enabled", v)
    end
})

MainBlock:CreateColorPicker({
    Name = "Fixed Color",
    Default = cfgCrosshair.fixedColor,
    Flag = "fixed_color",
    Callback = function(v)
        SetCrosshair("fixedColor", v)
    end
})

MainBlock:CreateSlider({
    Name = "Length",
    Min = 1,
    Max = 100,
    Default = cfgCrosshair.baseLength,
    Flag = "base_length",
    Callback = function(v)
        SetCrosshair("baseLength", v)
    end
})

MainBlock:CreateSlider({
    Name = "Thickness",
    Min = 1,
    Max = 20,
    Default = cfgCrosshair.baseThickness,
    Flag = "base_thickness",
    Callback = function(v)
        SetCrosshair("baseThickness", v)
    end
})

MainBlock:CreateSlider({
    Name = "Gap",
    Min = 0,
    Max = 50,
    Default = cfgCrosshair.baseGap,
    Flag = "base_gap",
    Callback = function(v)
        SetCrosshair("baseGap", v)
    end
})

MainBlock:CreateSlider({
    Name = "Opacity",
    Min = 0,
    Max = 1,
    Default = cfgCrosshair.opacity,
    Flag = "opacity",
    Callback = function(v)
        SetCrosshair("opacity", v)
    end
})

MainBlock:CreateToggle({
    Name = "Outline",
    Default = cfgCrosshair.outlineEnabled,
    Flag = "outline",
    Callback = function(v)
        SetCrosshair("outlineEnabled", v)
    end
})

MainBlock:CreateSlider({
    Name = "Outline Extra",
    Min = 0,
    Max = 20,
    Default = cfgCrosshair.outlineThicknessExtra,
    Flag = "outline_extra",
    Callback = function(v)
        SetCrosshair("outlineThicknessExtra", v)
    end
})

--==================================================
-- LEFT: EFFECTS
--==================================================

local EffectsBlock = CrosshairTab:CreateBlock({
    Name = "Effects",
    Side = "Left"
})

EffectsBlock:CreateToggle({
    Name = "Rainbow",
    Default = cfgCrosshair.rainbow,
    Flag = "rainbow",
    Callback = function(v)
        SetCrosshair("rainbow", v)
    end
})

EffectsBlock:CreateSlider({
    Name = "Rainbow Speed",
    Min = 0,
    Max = 20,
    Default = cfgCrosshair.rainbowSpeed,
    Flag = "rainbow_speed",
    Callback = function(v)
        SetCrosshair("rainbowSpeed", v)
    end
})

EffectsBlock:CreateToggle({
    Name = "Pulse",
    Default = cfgCrosshair.pulseEnabled,
    Flag = "pulse",
    Callback = function(v)
        SetCrosshair("pulseEnabled", v)
    end
})

EffectsBlock:CreateSlider({
    Name = "Pulse Amplitude",
    Min = 0,
    Max = 50,
    Default = cfgCrosshair.pulseAmplitude,
    Flag = "pulse_amplitude",
    Callback = function(v)
        SetCrosshair("pulseAmplitude", v)
    end
})

EffectsBlock:CreateSlider({
    Name = "Pulse Speed",
    Min = 0,
    Max = 20,
    Default = cfgCrosshair.pulseSpeed,
    Flag = "pulse_speed",
    Callback = function(v)
        SetCrosshair("pulseSpeed", v)
    end
})

EffectsBlock:CreateSlider({
    Name = "Pulse Lerp",
    Min = 0,
    Max = 30,
    Default = cfgCrosshair.pulseLerpSpeed,
    Flag = "pulse_lerp",
    Callback = function(v)
        SetCrosshair("pulseLerpSpeed", v)
    end
})

EffectsBlock:CreateToggle({
    Name = "Rotation",
    Default = cfgCrosshair.rotationEnabled,
    Flag = "rotation",
    Callback = function(v)
        SetCrosshair("rotationEnabled", v)
    end
})

EffectsBlock:CreateSlider({
    Name = "Rotation Speed",
    Min = 0,
    Max = 20,
    Default = cfgCrosshair.rotationSpeed,
    Flag = "rotation_speed",
    Callback = function(v)
        SetCrosshair("rotationSpeed", v)
    end
})

--==================================================
-- RIGHT: SPREAD
--==================================================

local SpreadBlock = CrosshairTab:CreateBlock({
    Name = "Spread",
    Side = "Right"
})

SpreadBlock:CreateToggle({
    Name = "Enabled",
    Default = cfgCrosshair.spreadEnabled,
    Flag = "spread_enabled",
    Callback = function(v)
        SetCrosshair("spreadEnabled", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Base",
    Min = 0,
    Max = 100,
    Default = cfgCrosshair.baseSpread,
    Flag = "base_spread",
    Callback = function(v)
        SetCrosshair("baseSpread", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Walk",
    Min = 0,
    Max = 100,
    Default = cfgCrosshair.walkSpread,
    Flag = "walk_spread",
    Callback = function(v)
        SetCrosshair("walkSpread", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Run",
    Min = 0,
    Max = 100,
    Default = cfgCrosshair.runSpread,
    Flag = "run_spread",
    Callback = function(v)
        SetCrosshair("runSpread", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Jump",
    Min = 0,
    Max = 100,
    Default = cfgCrosshair.jumpSpread,
    Flag = "jump_spread",
    Callback = function(v)
        SetCrosshair("jumpSpread", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Fire",
    Min = 0,
    Max = 100,
    Default = cfgCrosshair.fireSpread,
    Flag = "fire_spread",
    Callback = function(v)
        SetCrosshair("fireSpread", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Lerp Speed",
    Min = 0,
    Max = 50,
    Default = cfgCrosshair.spreadLerpSpeed,
    Flag = "spread_lerp",
    Callback = function(v)
        SetCrosshair("spreadLerpSpeed", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Velocity Multiplier",
    Min = 0,
    Max = 10,
    Default = cfgCrosshair.extraFromVelocityMultiplier,
    Flag = "velocity_multiplier",
    Callback = function(v)
        SetCrosshair("extraFromVelocityMultiplier", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Walk Threshold",
    Min = 0,
    Max = 30,
    Default = cfgCrosshair.walkSpeedThreshold,
    Flag = "walk_threshold",
    Callback = function(v)
        SetCrosshair("walkSpeedThreshold", v)
    end
})

SpreadBlock:CreateSlider({
    Name = "Run Threshold",
    Min = 0,
    Max = 50,
    Default = cfgCrosshair.runSpeedThreshold,
    Flag = "run_threshold",
    Callback = function(v)
        SetCrosshair("runSpeedThreshold", v)
    end
})

--==================================================
-- RIGHT: TEXT / POSITION
--==================================================

local TextBlock = CrosshairTab:CreateBlock({
    Name = "Text / Position",
    Side = "Right"
})

TextBlock:CreateToggle({
    Name = "Text Enabled",
    Default = cfgCrosshair.textEnabled,
    Flag = "text_enabled",
    Callback = function(v)
        SetCrosshair("textEnabled", v)
    end
})

TextBlock:CreateInput({
    Name = "Text",
    Placeholder = "Crosshair text",
    Default = cfgCrosshair.customText,
    Flag = "custom_text",
    Callback = function(v)
        SetCrosshair("customText", v)
    end
})

TextBlock:CreateSlider({
    Name = "Text Size",
    Min = 1,
    Max = 100,
    Default = cfgCrosshair.textSize,
    Flag = "text_size",
    Callback = function(v)
        SetCrosshair("textSize", v)
    end
})

TextBlock:CreateToggle({
    Name = "Text Outline",
    Default = cfgCrosshair.textOutlineEnabled,
    Flag = "text_outline",
    Callback = function(v)
        SetCrosshair("textOutlineEnabled", v)
    end
})

TextBlock:CreateSlider({
    Name = "Text Offset",
    Min = -100,
    Max = 100,
    Default = cfgCrosshair.textOffset,
    Flag = "text_offset",
    Callback = function(v)
        SetCrosshair("textOffset", v)
    end
})

TextBlock:CreateDropdown({
    Name = "Font",
    Items = {
        "Gotham",
        "GothamBold",
        "SourceSans",
        "SourceSansBold",
        "Oswald",
        "Roboto",
        "RobotoMono",
        "Sarpanch",
        "Code",
        "AmaticSC",
        "FredokaOne",
        "Jura",
        "Arcade",
        "SciFi",
        "Ubuntu",
        "Arial",
        "Cartoon",
        "Highway",
        "Bodoni",
        "Garamond",
        "Nunito"
    },
    Default = cfgCrosshair.textFont,
    Flag = "text_font",
    Callback = function(v)
        SetCrosshair("textFont", v)
    end
})

TextBlock:CreateSlider({
    Name = "X Offset",
    Min = -500,
    Max = 500,
    Default = cfgCrosshair.xOffset,
    Flag = "x_offset",
    Callback = function(v)
        SetCrosshair("xOffset", v)
    end
})

TextBlock:CreateSlider({
    Name = "Y Offset",
    Min = -500,
    Max = 500,
    Default = cfgCrosshair.yOffset,
    Flag = "y_offset",
    Callback = function(v)
        SetCrosshair("yOffset", v)
    end
})

TextBlock:CreateToggle({
    Name = "Unlock Center",
    Default = cfgCrosshair.unlockCenterEnabled,
    Flag = "unlock_center",
    Callback = function(v)
        SetCrosshair("unlockCenterEnabled", v)
    end
})

TextBlock:CreateToggle({
    Name = "Unlock Smooth",
    Default = cfgCrosshair.unlockSmoothEnabled,
    Flag = "unlock_smooth",
    Callback = function(v)
        SetCrosshair("unlockSmoothEnabled", v)
    end
})

TextBlock:CreateSlider({
    Name = "Unlock Lerp Speed",
    Min = 0,
    Max = 50,
    Default = cfgCrosshair.unlockLerpSpeed,
    Flag = "unlock_lerp",
    Callback = function(v)
        SetCrosshair("unlockLerpSpeed", v)
    end
})

--==================================================
-- LOADED
--==================================================

Library:Notify({
    Title = "Crosshair",
    Content = "All settings loaded",
    Duration = 3
})
