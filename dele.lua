Akicho = function()
    for i,v in next, workspace:GetDescendants() do
        pcall(function()
            v.Transparency = 1
        end)
    end
    task.wait(1)
    workspace.DescendantAdded:Connect(function(v)
        pcall(function()
            v.Transparency = 1
        end)
    end)
    task.wait(1)
    workspace.ClientAnimatorThrottling = Enum.ClientAnimatorThrottlingMode.Enabled
    workspace.InterpolationThrottling = Enum.InterpolationThrottlingMode.Enabled
    settings():GetService("RenderSettings").EagerBulkExecution = false
    workspace.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
    game:GetService("Lighting").GlobalShadows = false
    settings().Rendering.QualityLevel = "Level01"
    task.wait(1)
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    task.wait(1)
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = false
    l.FogEnd = 9e9
    l.Brightness = 0
    task.wait(.5)
    for i, v in pairs(g:GetDescendants()) do
        if v.ClassName == "WedgePart" or v.ClassName == "Terrain" or v.ClassName == "MeshPart" then
            v.BrickColor = BrickColor.new(155, 155, 155)
            v.Material = "Plastic"
            v.Transparency = 1
        end
        task.wait(.5)
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            task.wait(.5)
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            task.wait(.5)
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
            task.wait(.5)
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            task.wait(.1)
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
            task.wait(.5)
        end
    end

    game.Workspace.ChildAdded:Connect(function(v)
        if v.ClassName == "WedgePart" or v.ClassName == "Terrain" or v.ClassName == "MeshPart" then
            v.BrickColor = BrickColor.new(155, 155, 155)
            v.Material = "Plastic"
            v.Transparency = 1
        end
        task.wait(.2)
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then 
            v.Material = "Plastic"
            v.Reflectance = 0
            task.wait(1)
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
            task.wait(.5)
        end
    end)

    for i, e in pairs(l:GetChildren()) do
        if e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end

    game.Lighting.ChildAdded:Connect(function(v)
        if v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
            v.Enabled = false
        end
    end)
end
Akicho()
