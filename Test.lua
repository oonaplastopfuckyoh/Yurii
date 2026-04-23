--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

--// CLEAN OLD GUI
local old = player:WaitForChild("PlayerGui"):FindFirstChild("WorldHub")
if old then old:Destroy() end

--// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "WorldHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// MAIN FRAME (FIXED HEIGHT)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 320) -- FIXED (was 210 → too small)
frame.Position = UDim2.new(0.5, -130, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text =  "Hub ni Yuri"
title.TextColor3 = Color3.fromRGB(170, 90, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

--// MINIMIZE BUTTON (X → Y)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -35, 0, 0)
minimizeBtn.Text = "X"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = frame

Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

--// STATE
local minimized = false
local savedSize = frame.Size

--// TOGGLE
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		-- hide children ONLY (safe)
		for _, v in ipairs(frame:GetChildren()) do
			if v:IsA("GuiObject") and v ~= minimizeBtn then
				v.Visible = false
			end
		end

		-- shrink frame
		frame.Size = UDim2.new(0, 50, 0, 50)

		-- center the button inside
		minimizeBtn.Size = UDim2.new(1, 0, 1, 0)
		minimizeBtn.Position = UDim2.new(0, 0, 0, 0)
		minimizeBtn.Text = "Y"

	else
		-- show back ONLY GUI objects
		for _, v in ipairs(frame:GetChildren()) do
			if v:IsA("GuiObject") then
				v.Visible = true
			end
		end

		-- restore frame
		frame.Size = savedSize

		minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
		minimizeBtn.Position = UDim2.new(1, -35, 0, 0)
		minimizeBtn.Text = "X"
	end
end)

frame.ClipsDescendants = true

--// STATUS
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0, 30)
status.BackgroundTransparency = 1
status.Text = "Status: Idle"
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.Parent = frame

--// DRAG SYSTEM
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

--// WORLD DATA
local World1 = {
	Vector3.new(52.3, 0.6, 1814.5),
	Vector3.new(-1344.1, 1604.4, 1590.8),
	Vector3.new(-1265.8, 1.4, -1191.8),
	Vector3.new(1074.6, 1.8, 1276.2),
  Vector3.new(2304.6, 6.2, 2224.0),
	Vector3.new(-1124.2, 13.9, 372.6),
	Vector3.new(-16.5, 1.9, -1840.6),
	Vector3.new(668.3, 1.9, -1696.0),
  Vector3.new(-16.5, 1.9, -1840.6),
  Vector3.new(-668.3, 1.9, -1696.0),
  Vector3.new(-364.8, -0.2, -1099.1),
  Vector3.new(1398.3, 8.5, 492.0),
  Vector3.new(-409.6, -1.1, -990.2),
  Vector3.new(-788.4, -4.2, -433.5),
  Vector3.new(176.0, 11.2, -159.7),
}

local World2 = {
	Vector3.new(-1578.9, 2.7, 1847.7),
	Vector3.new(-3075.8, 7.5, -668.2),
	Vector3.new(-325.4, -3.7, -122.0),
}

--// STATE
local currentWorld = World1
local index = 1
local running = false

--// TELEPORT
local function tp(pos)
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = CFrame.new(pos)
	end
end

--// LOOP
task.spawn(function()
	while true do
		task.wait(0.65)
		if running then
			tp(currentWorld[index])
			index += 1
			if index > #currentWorld then
				index = 1
			end
		end
	end
end)

--// BUTTON CREATOR (SPACING FIXED)
local function makeButton(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.8, 0, 0, 30)
	btn.Position = UDim2.new(0.1, 0, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(50, 30, 80)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = frame

	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

--// BUTTONS (FIXED SPACING - NO CUT OFF)
local w1 = makeButton("World 1", 65)
local w2 = makeButton("World 2", 100)
local toggle = makeButton("Start Auto", 135)
local anti = makeButton("Anti Pause", 170)
local extra1 = makeButton("Weapon 1", 205)
local extra2 = makeButton("Weapon 2", 240)

--// EVENTS
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

--// ANTI GAMEPLAY PAUSE
local networkPaused

local function antiPause()
	pcall(function()
		if networkPaused then
			networkPaused:Disconnect()
		end
	end)

	networkPaused = CoreGui.RobloxGui.ChildAdded:Connect(function(obj)
		if obj.Name == "CoreScripts/NetworkPause" then
			obj:Destroy()
		end
	end)

	local existing = CoreGui.RobloxGui:FindFirstChild("CoreScripts/NetworkPause")
	if existing then
		existing:Destroy()
	end
end

anti.MouseButton1Click:Connect(function()
	antiPause()
	status.Text = "Status: Anti Pause Enabled"
end)

--// WEAPON SWITCH SYSTEM (3s COOLDOWN CLEAN VERSION)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

--// STATE
local switchEnabled = false
local weapon1 = nil
local weapon2 = nil
local currentWeapon = 1

local switching = false
local COOLDOWN = 3

--// GET EQUIPPED TOOL
local function getEquippedTool()
	local char = player.Character
	if not char then return nil end

	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") then
			return v
		end
	end
	return nil
end

--// SAFE EQUIP FUNCTION
local function equipTool(tool)
	local char = player.Character or player.CharacterAdded:Wait()
	local backpack = player:WaitForChild("Backpack")

	if not tool then return end

	-- move all tools back first
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Tool") then
			v.Parent = backpack
		end
	end

	task.wait(0.1)
	tool.Parent = char
end

--// SWITCH LOOP
task.spawn(function()
	while true do
		task.wait(0.2)

		if switchEnabled and weapon1 and weapon2 and not switching then
			switching = true

			if currentWeapon == 1 then
				equipTool(weapon2)
				currentWeapon = 2
			else
				equipTool(weapon1)
				currentWeapon = 1
			end

			task.delay(COOLDOWN, function()
				switching = false
			end)
		end
	end
end)

--// UI BUTTON HELPERS (assumes you already have makeButton + status)

local setW1 = makeButton("Set Weapon 1", 205)
local setW2 = makeButton("Set Weapon 2", 240)
local toggleSwitch = makeButton("Auto Switch: OFF", 275)

--// SET WEAPON 1
setW1.MouseButton1Click:Connect(function()
	local tool = getEquippedTool()
	if tool then
		weapon1 = tool
		status.Text = "Weapon 1 set: " .. tool.Name
	else
		status.Text = "Equip a weapon first"
	end
end)

--// SET WEAPON 2
setW2.MouseButton1Click:Connect(function()
	local tool = getEquippedTool()
	if tool then
		weapon2 = tool
		status.Text = "Weapon 2 set: " .. tool.Name
	else
		status.Text = "Equip a weapon first"
	end
end)

--// TOGGLE SWITCH
toggleSwitch.MouseButton1Click:Connect(function()
	if not weapon1 or not weapon2 then
		status.Text = "Set both weapons first"
		return
	end

	switchEnabled = not switchEnabled

	if switchEnabled then
		toggleSwitch.Text = "Auto Switch: ON"
		status.Text = "Weapon switching enabled"
	else
		toggleSwitch.Text = "Auto Switch: OFF"
		status.Text = "Weapon switching stopped"
	end
end)
