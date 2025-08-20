-- ⚡ Roblox FPS Booster + HUD Overlay ⚡
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- ========== HUD ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OverlayHUD"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
end)

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0.85, 0, 0.25, 0)
textLabel.Position = UDim2.new(0.075, 0, 0.7, 0)
textLabel.Font = Enum.Font.FredokaOne
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.TextStrokeTransparency = 0.3
textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.TextYAlignment = Enum.TextYAlignment.Center

-- Lấy Fragments từ nhiều chỗ
local function getFragment()
    local frag = "?"
    local paths = {
        {"Data", "Fragment"},
        {"Data", "Fragments"},
        {"leaderstats", "Fragment"},
        {"leaderstats", "Fragments"},
        {"leaderstats", "F"},
        {"Stats", "Fragments"},
    }

    for _, path in pairs(paths) do
        local root = player:FindFirstChild(path[1])
        if root and root:FindFirstChild(path[2]) then
            local success, value = pcall(function()
                return root[path[2]].Value
            end)
            if success then
                frag = value
                break
            end
        end
    end
    return frag
end

-- HUD loop
task.spawn(function()
    while true do
        local fps = math.floor(1 / RunService.RenderStepped:Wait())
        local name = player.Name
        local beli, level = "?", "?"

        if player:FindFirstChild("Data") then
            local data = player.Data
            if data:FindFirstChild("Beli") then
                beli = data.Beli.Value
            end
            if data:FindFirstChild("Level") then
                level = data.Level.Value
            end
        end

        local fragment = getFragment()

        textLabel.Text = string.format(
            "FPS: %d   |   Lv: %s\n$: %s   |   F: %s\nUser: %s",
            fps, level, beli, fragment, name
        )
        task.wait(1)
    end
end)

-- ========== FPS BOOSTER ==========
local function cleanObject(obj)
    if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
        local tex = obj:FindFirstChildOfClass("Texture")
        if tex then tex:Destroy() end
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
        obj.Enabled = false
    elseif obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion")
        or obj:IsA("Highlight") or obj:IsA("Shimmer") then
        obj:Destroy()
    elseif obj:IsA("Sound") then
        obj:Stop()
    elseif obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        obj:Destroy()
    elseif obj:IsA("Humanoid") then
        for _, anim in next, obj:GetPlayingAnimationTracks() do
            anim:Stop()
        end
    end
end

-- Lighting tối ưu
task.spawn(function()
    Lighting.GlobalShadows = false
    Lighting.FogStart = 0
    Lighting.FogEnd = 0
    Lighting.Brightness = 0
    Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
    Lighting.Ambient = Color3.new(0, 0, 0)

    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Sky") or v:IsA("SunRaysEffect") or v:IsA("BloomEffect")
            or v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") then
            v:Destroy()
        end
    end
end)

-- Terrain tối ưu
task.spawn(function()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterTransparency = 0
        terrain.WaterWaveSize = 0
        terrain.WaterReflectance = 0
        terrain.WaterColor = Color3.new(0, 0, 0)
        terrain.MaterialColors = Enum.MaterialColors.Plain
    end
end)

-- Xoá effect trong game
task.spawn(function()
    for _, obj in next, workspace:GetDescendants() do
        cleanObject(obj)
    end
    for _, obj in next, getnilinstances() do
        cleanObject(obj)
        for _, sub in next, obj:GetDescendants() do
            cleanObject(sub)
        end
    end
end)

workspace.DescendantAdded:Connect(function(obj)
    task.spawn(function()
        cleanObject(obj)
    end)
end)
