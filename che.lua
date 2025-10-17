--// Roblox Player Counter UI - Gradient Border (Green -> Yellow -> Orange -> Red)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild("PlayerCounterUI") then
    CoreGui.PlayerCounterUI:Destroy()
end

-- Tạo GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerCounterUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

-- Khung chính
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 95, 0, 32)
frame.Position = UDim2.new(0.5, -47, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui

-- Bo góc
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = frame

-- Viền (UIStroke)
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Color = Color3.fromRGB(46, 204, 113) -- xanh lá ban đầu
stroke.Parent = frame

-- Icon người
local icon = Instance.new("ImageLabel")
icon.BackgroundTransparency = 1
icon.Size = UDim2.new(0, 20, 0, 20)
icon.Position = UDim2.new(0, 6, 0.5, -10)
icon.Image = "rbxassetid://6035047409"
icon.ImageColor3 = Color3.fromRGB(0, 162, 255)
icon.Parent = frame

-- Text hiển thị số người
local text = Instance.new("TextLabel")
text.BackgroundTransparency = 1
text.Size = UDim2.new(1, -30, 1, 0)
text.Position = UDim2.new(0, 30, 0, 0)
text.Font = Enum.Font.GothamBold
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.TextSize = 20
text.TextXAlignment = Enum.TextXAlignment.Left
text.Text = "0/12"
text.Parent = frame

-- Hàm nội suy màu (linear blend)
local function LerpColor(c1, c2, t)
	return Color3.new(
		c1.R + (c2.R - c1.R) * t,
		c1.G + (c2.G - c1.G) * t,
		c1.B + (c2.B - c1.B) * t
	)
end

-- Màu chuyển tiếp: xanh → vàng → cam → đỏ
local colorPoints = {
	{percent = 0.0, color = Color3.fromRGB(46, 204, 113)}, -- xanh lá
	{percent = 0.33, color = Color3.fromRGB(241, 196, 15)}, -- vàng
	{percent = 0.66, color = Color3.fromRGB(255, 140, 0)},  -- cam
	{percent = 1.0, color = Color3.fromRGB(231, 76, 60)}    -- đỏ
}

-- Lấy màu theo tỉ lệ
local function getGradientColor(ratio)
	for i = 1, #colorPoints - 1 do
		local c1, c2 = colorPoints[i], colorPoints[i + 1]
		if ratio >= c1.percent and ratio <= c2.percent then
			local t = (ratio - c1.percent) / (c2.percent - c1.percent)
			return LerpColor(c1.color, c2.color, t)
		end
	end
	return colorPoints[#colorPoints].color
end

-- Cập nhật UI
local function update()
	local current = #Players:GetPlayers()
	local max = 12
	text.Text = string.format("%d/%d", current, max)

	local ratio = math.clamp(current / max, 0, 1)
	local newColor = getGradientColor(ratio)

	TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Color = newColor
	}):Play()
end

-- Kết nối sự kiện
update()
Players.PlayerAdded:Connect(update)
Players.PlayerRemoving:Connect(update)

-- Auto update mỗi 5s
task.spawn(function()
	while task.wait(5) do
		update()
	end
end)
