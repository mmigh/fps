local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CONFIG
local MAX_PLAYERS = Players.MaxPlayers

-- COLORS
local COLORS = {
	Green = Color3.fromRGB(0, 255, 0),
	Yellow = Color3.fromRGB(255, 255, 0),
	Orange = Color3.fromRGB(255, 170, 0),
	Red = Color3.fromRGB(255, 0, 0),
}

-- GUI CONTAINER
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerCountDisplay"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- FRAME (HUD BAR)
local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(100, 28)
frame.Position = UDim2.new(0.5, 0, 0, 30) -- 🎯 Slightly below the top bar
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.2
frame.Parent = screenGui
frame.ZIndex = 5

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = COLORS.Green
stroke.Transparency = 0.2
stroke.Parent = frame

-- GLOW (Subtle light)
local glow = Instance.new("ImageLabel")
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://4996891970"
glow.ImageColor3 = COLORS.Green
glow.ImageTransparency = 0.6
glow.ScaleType = Enum.ScaleType.Slice
glow.SliceCenter = Rect.new(24, 24, 276, 276)
glow.Size = UDim2.new(1, 12, 1, 12)
glow.Position = UDim2.fromScale(0.5, 0.5)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.ZIndex = 4
glow.Parent = frame

-- 👥 ICON
local icon = Instance.new("TextLabel")
icon.BackgroundTransparency = 1
icon.Size = UDim2.new(0.4, 0, 1, 0)
icon.Font = Enum.Font.GothamBold
icon.Text = "👥"
icon.TextScaled = true
icon.TextColor3 = Color3.new(1, 1, 1)
icon.ZIndex = 6
icon.Parent = frame

local iconConstraint = Instance.new("UITextSizeConstraint", icon)
iconConstraint.MaxTextSize = 18

-- PLAYER COUNT TEXT
local countLabel = Instance.new("TextLabel")
countLabel.BackgroundTransparency = 1
countLabel.Size = UDim2.new(0.6, -4, 1, 0)
countLabel.Position = UDim2.new(0.4, 0, 0, 0)
countLabel.Font = Enum.Font.GothamBold
countLabel.TextScaled = true
countLabel.TextColor3 = Color3.new(1, 1, 1)
countLabel.Text = "0/" .. MAX_PLAYERS
countLabel.ZIndex = 6
countLabel.Parent = frame

local textConstraint = Instance.new("UITextSizeConstraint", countLabel)
textConstraint.MaxTextSize = 16

-- COLOR FUNCTION
local function getColor(ratio)
	if ratio <= 0.33 then
		return COLORS.Green:Lerp(COLORS.Yellow, ratio / 0.33)
	elseif ratio <= 0.66 then
		return COLORS.Yellow:Lerp(COLORS.Orange, (ratio - 0.33) / 0.33)
	else
		return COLORS.Orange:Lerp(COLORS.Red, (ratio - 0.66) / 0.34)
	end
end

-- UPDATE FUNCTION
local function updateUI()
	local currentPlayers = #Players:GetPlayers()
	local ratio = math.clamp(currentPlayers / MAX_PLAYERS, 0, 1)
	local color = getColor(ratio)

	countLabel.Text = string.format("%d/%d", currentPlayers, MAX_PLAYERS)
	stroke.Color = color
	glow.ImageColor3 = color
end

-- REAL-TIME EVENTS
Players.PlayerAdded:Connect(updateUI)
Players.PlayerRemoving:Connect(updateUI)

-- INITIAL UPDATE
updateUI()
