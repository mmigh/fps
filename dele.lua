-- ============ AFK EXTREME OPTIMIZED ============
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Terrain = Workspace.Terrain

-- ===== FPS LOCK =====
pcall(function()
    setfpscap(10) -- hoặc setfps(10)
end)

-- ===== TẮT RENDER 3D =====
RunService:Set3dRenderingEnabled(false)

-- ===== CORE HIDE FUNCTION =====
local function Hide(v)
    if v:IsA("BasePart") then
        v.Transparency = 1
        v.CastShadow = false
        v.Material = Enum.Material.Plastic
        v.Reflectance = 0

    elseif v:IsA("Decal") or v:IsA("Texture") then
        v.Transparency = 1

    elseif v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam") then
        v:Destroy()

    elseif v:IsA("Light") then
        v.Enabled = false

    elseif v:IsA("Explosion") then
        v.Visible = false
        v.BlastPressure = 1 -- giữ damage
    end
end

-- ===== NUKE MAP + SKILL (1 LẦN) =====
for _,v in ipairs(Workspace:GetDescendants()) do
    Hide(v)
end

-- ===== SPAWN SAU =====
Workspace.DescendantAdded:Connect(Hide)

-- ===== ẨN PLAYER KHÁC =====
local function HideCharacter(char)
    for _,v in ipairs(char:GetDescendants()) do
        Hide(v)
    end
end

for _,plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        if plr.Character then
            HideCharacter(plr.Character)
        end
        plr.CharacterAdded:Connect(HideCharacter)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(HideCharacter)
    end
end)

-- ===== LIGHTING OFF =====
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e9
Lighting.Brightness = 0

for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

Lighting.ChildAdded:Connect(function(v)
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end)

-- ===== TERRAIN =====
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 1

-- ===== WORKSPACE PERF =====
Workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
Workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
Workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
-- ==============================================
