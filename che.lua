local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- GUI chính
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerCountDisplay"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 90, 0, 28)
frame.Position = UDim2.new(0.5, 0, 0.05, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.3
frame.ZIndex = 2
frame.Parent = screenGui

-- Bo góc & viền
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.8
stroke.Color = Color3.fromRGB(0, 255, 0)
stroke.Transparency = 0.25

-- Hiệu ứng glow mờ
local glow = Instance.new("ImageLabel", frame)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://4996891970" -- hiệu ứng phát sáng
glow.ImageColor3 = stroke.Color
glow.ImageTransparency = 0.6
glow.ScaleType = Enum.ScaleType.Slice
glow.SliceCenter = Rect.new(24, 24, 276, 276)
glow.Size = UDim2.new(1, 16, 1, 16)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.ZIndex = 0

-- Text hiển thị
local countLabel = Instance.new("TextLabel", frame)
countLabel.BackgroundTransparency = 1
countLabel.Size = UDim2.new(1, 0, 1, 0)
countLabel.Font = Enum.Font.GothamBold
countLabel.TextScaled = true
countLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
countLabel.Text = "0/0"
countLabel.ZIndex = 2

local padding = Instance.new("UIPadding", countLabel)
padding.PaddingTop = UDim.new(0, 2)

local textConstraint = Instance.new("UITextSizeConstraint", countLabel)
textConstraint.MaxTextSize = 16
textConstraint.MinTextSize = 9

-- Hiệu ứng fade-in khi load
frame.BackgroundTransparency = 1
countLabel.TextTransparency = 1
stroke.Transparency = 1
glow.ImageTransparency = 1

TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.3}):Play()
TweenService:Create(countLabel, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {TextTransparency = 0}):Play()
TweenService:Create(stroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Transparency = 0.25}):Play()
TweenService:Create(glow, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {ImageTransparency = 0.6}):Play()

-- Hàm đổi màu viền theo tỉ lệ
local function getColor(ratio)
	local green = Color3.fromRGB(0, 255, 0)
	local yellow = Color3.fromRGB(255, 255, 0)
	local orange = Color3.fromRGB(255, 170, 0)
	local red = Color3.fromRGB(255, 0, 0)

	if ratio <= 0.33 then
		return green:lerp(yellow, ratio / 0.33)
	elseif ratio <= 0.66 then
		return yellow:lerp(orange, (ratio - 0.33) / 0.33)
	else
		return orange:lerp(red, (ratio - 0.66) / 0.34)
	end
end

-- Cập nhật UI
local function updateUI()
	local currentPlayers = #Players:GetPlayers()
	local maxPlayers = Players.MaxPlayers or 12
	local ratio = math.clamp(currentPlayers / maxPlayers, 0, 1)
	local color = getColor(ratio)

	countLabel.Text = string.format("%d/%d", currentPlayers, maxPlayers)

	TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Color = color}):Play()
	TweenService:Create(glow, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {ImageColor3 = color}):Play()
end

-- Auto update mỗi 5s và khi player thay đổi
task.spawn(function()
	while task.wait(5) do
		updateUI()
	end
end)

Players.PlayerAdded:Connect(updateUI)
Players.PlayerRemoving:Connect(updateUI)

updateUI()
