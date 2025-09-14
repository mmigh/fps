-- ⚡ Roblox FPS Booster (FullBright + Gray Character + HUD) ⚡

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local grayColor = Color3.fromRGB(150, 150, 150) -- xám trung tính

-- ================= HUD =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OverlayHUD_Basic"
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0.6, 0, 0.15, 0)
textLabel.Position = UDim2.new(0.2, 0, 0.8, 0)
textLabel.Font = Enum.Font.SourceSans
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextStrokeTransparency = 0.5
textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)

local function getStats()
    local bani, level = "?", "?"
    if player:FindFirstChild("Data") then
        local data = player.Data
        if data:FindFirstChild("Beli") then bani = data.Beli.Value end
        if data:FindFirstChild("Level") then level = data.Level.Value end
    end
    return bani, level
end

-- HUD update loop
task.spawn(function()
    local fpsCounter, frames, lastTime = 0, 0, tick()
    while true do
        RunService.RenderStepped:Wait()
        frames += 1
        local now = tick()
        if now - lastTime >= 1 then
            fpsCounter = frames
            frames = 0
            lastTime = now
            local bani, level = getStats()
            textLabel.Text = string.format("FPS: %d | Lv: %s | $: %s", fpsCounter, level, bani)
        end
    end
end)

-- ================= FPS BOOSTER =================
local function cleanObject(obj)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Color = grayColor
        obj.Reflectance = 0
        obj.CastShadow = false
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
        obj.Enabled = false
    elseif obj:IsA("Light") then
        obj.Brightness = 0
    elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
        obj.Enabled = false
    elseif obj:IsA("Sound") then
        obj.Volume = 0
    elseif obj:IsA("Accessory") then
        obj:Destroy()
    end
end

local function applyCleanToDescendants(container)
    for _, obj in ipairs(container:GetDescendants()) do
        cleanObject(obj)
    end
end

-- Map & Terrain
task.spawn(function()
    local terrain = Workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterTransparency = 0.6
        terrain.WaterWaveSize = 0
        terrain.WaterReflectance = 0
        terrain.WaterColor = grayColor
    end
end)

applyCleanToDescendants(Workspace)

-- Auto clean object mới spawn
Workspace.DescendantAdded:Connect(function(obj)
    task.delay(0.1, function()
        cleanObject(obj)
    end)
end)

-- Nhân vật xám ngay khi spawn
local function onCharacter(char)
    task.delay(0.5, function()
        applyCleanToDescendants(char)
    end)
end

if player.Character then
    onCharacter(player.Character)
end
player.CharacterAdded:Connect(onCharacter)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(onCharacter)
end)

-- ================= FULLBRIGHT =================
task.spawn(function()
    while true do
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        task.wait(1)
    end
end)
