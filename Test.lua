
// SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer

// CLEAN OLD GUI
local old = player:WaitForChild("PlayerGui"):FindFirstChild("WorldHub")
if old then old:Destroy() end

// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "WorldHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(0.5, -130, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "World Teleport Hub"
title.TextColor3 = Color3.fromRGB(170, 90, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

// STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 30)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(255, 255, 255)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = frame

// WORLD POS
local World1 = {
	Vector3.new(52.3, 0.6, 1814.5),
	Vector3.new(-1344.1, 1604.4, 1590.8),
	Vector3.new(-1265.8, 1.4, -1191.8),
	Vector3.new(1074.6, 1.8, 1276.2),
	Vector3.new(-1124.2, 13.9, 372.6),
	Vector3.new(-16.5, 1.9, -1840.6),
	Vector3.new(668.3, 1.9, -1696.0),
	Vector3.new(1398.3, 8.5, 492.0),
}

local World2 = {
	Vector3.new(-1578.9, 2.7, 1847.7),
	Vector3.new(-3075.8, 7.5, -668.2),
	Vector3.new(-325.4, -3.7, -122.0),
}

// STATE
local currentWorld = World1
local index = 1
local running = false

// TELEPORT FUNCTION
local function tp(pos)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(pos)
	end
end

// LOOP
task.spawn(function()
	while true do
		task.wait(0.4)

		if running then
			tp(currentWorld[index])

			index += 1
			if index > #currentWorld then
				index = 1
			end
		end
	end
end)

// BUTTONS
local function makeButton(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 30)
	btn.Position = UDim2.new(0.1, 0, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 30, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = frame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

// BUTTONS
local w1 = makeButton("World 1", 65)
local w2 = makeButton("World 2", 100)
local toggle = makeButton("Start Auto", 135)

// EVENTS
w1.MouseButton1Click:Connect(function()
	currentWorld = World1
	index = 1
	status.Text = "Status: World 1 Selected"
end)

w2.MouseButton1Click:Connect(function()
	currentWorld = World2
	index = 1
	status.Text = "Status: World 2 Selected"
end)

toggle.MouseButton1Click:Connect(function()
	running = not running
	toggle.Text = running and "Pause Auto" or "Start Auto"
	status.Text = running and "Status: Running" or "Status: Paused"
end)
  
