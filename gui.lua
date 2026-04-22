--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// CONFIG - All magic numbers in one place
local CONFIG = {
	COLORS = {
		MAIN = Color3.fromRGB(170, 90, 255),
		BG = Color3.fromRGB(15, 15, 20),
		SIDEBAR_BG = Color3.fromRGB(12, 12, 16),
		DARK = Color3.fromRGB(10, 10, 14),
		BTN_INACTIVE = Color3.fromRGB(18, 18, 22),
		BTN_ACTIVE = Color3.fromRGB(60, 30, 110),
		CLOSE_BTN = Color3.fromRGB(255, 70, 120),
	},
	SIZES = {
		FRAME_WIDTH = 430,
		FRAME_HEIGHT = 290,
		SIDEBAR_WIDTH = 125,
		CORNER_RADIUS = 12,
	}
}

--// PREVENT DUPLICATE GUI
local old = player:WaitForChild("PlayerGui"):FindFirstChild("YuriHub")
if old then old:Destroy() end

--// CREATE GUI
local gui = Instance.new("ScreenGui")
gui.Name = "YuriHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// UTILITY FUNCTIONS
local function createFrame(parent, size, pos, bgColor, cornerRadius)
	local frame = Instance.new("Frame")
	frame.Size = size
	frame.Position = pos
	frame.BackgroundColor3 = bgColor
	frame.BorderSizePixel = 0
	frame.Parent = parent
	if cornerRadius then
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, cornerRadius)
	end
	return frame
end

local function createLabel(parent, text, size, pos, font, textSize, color, bgTransparency)
	local label = Instance.new("TextLabel")
	label.Size = size
	label.Position = pos
	label.Text = text
	label.Font = font
	label.TextSize = textSize
	label.TextColor3 = color
	label.BackgroundTransparency = bgTransparency or 1
	label.Parent = parent
	return label
end

local function createButton(parent, size, pos, text, bgColor, textColor, cornerRadius)
	local btn = Instance.new("TextButton")
	btn.Size = size
	btn.Position = pos
	btn.Text = text
	btn.BackgroundColor3 = bgColor
	btn.TextColor3 = textColor
	btn.BorderSizePixel = 0
	btn.Parent = parent
	if cornerRadius then
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, cornerRadius)
	end
	return btn
end

--// MAIN FRAME
local frame = createFrame(gui, UDim2.new(0, CONFIG.SIZES.FRAME_WIDTH, 0, CONFIG.SIZES.FRAME_HEIGHT), UDim2.new(0.5, -215, 0.5, -145), CONFIG.COLORS.BG, CONFIG.SIZES.CORNER_RADIUS)

--// TOP BAR
local topBar = createFrame(frame, UDim2.new(1, 0, 0.18, 0), UDim2.new(0, 0, 0, 0), CONFIG.COLORS.DARK, CONFIG.SIZES.CORNER_RADIUS)

createLabel(topBar, "Hub ni Yuri", UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), Enum.Font.Arcade, 22, CONFIG.COLORS.MAIN, 1)

--// CLOSE BUTTON
local closeBtn = createButton(topBar, UDim2.new(0, 24, 0, 24), UDim2.new(1, -40, 0.5, -12), "×", CONFIG.COLORS.CLOSE_BTN, Color3.fromRGB(255, 255, 255), 6)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14

--// MINI Y BUTTON (IMAGE BUTTON)
local mini = Instance.new("ImageButton")
mini.Size = UDim2.new(0, 42, 0, 42)
mini.Position = UDim2.new(0, 20, 0.5, -21)
mini.BackgroundColor3 = CONFIG.COLORS.MAIN
mini.BorderSizePixel = 0
mini.Visible = false
mini.ZIndex = 9999
mini.Parent = gui

Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 6)

mini.Image = "rbxassetid://129240920074049"
mini.ScaleType = Enum.ScaleType.Fit
mini.AutoButtonColor = true

--// DRAG SYSTEM
local draggingObjects = {}

local function createDragHandler(obj, handle)
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			draggingObjects[obj] = {dragging = true, start = i.Position, pos = obj.Position}
		end
	end)

	handle.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			if draggingObjects[obj] then
				draggingObjects[obj].dragging = false
			end
		end
	end)
end

UserInputService.InputChanged:Connect(function(i)
	for obj, data in pairs(draggingObjects) do
		if data.dragging then
			local delta = i.Position - data.start
			obj.Position = UDim2.new(data.pos.X.Scale, data.pos.X.Offset + delta.X, data.pos.Y.Scale, data.pos.Y.Offset + delta.Y)
		end
	end
end)

createDragHandler(frame, topBar)
createDragHandler(mini, mini)

--// BODY
local body = createFrame(frame, UDim2.new(1, 0, 0.82, 0), UDim2.new(0, 0, 0.18, 0), CONFIG.COLORS.BG, 0)
body.BackgroundTransparency = 1

--// SIDEBAR
local sidebar = createFrame(body, UDim2.new(0, CONFIG.SIZES.SIDEBAR_WIDTH, 1, 0), UDim2.new(0, 0, 0, 0), CONFIG.COLORS.SIDEBAR_BG, 10)

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 6)
list.Parent = sidebar

local pad = Instance.new("UIPadding")
pad.PaddingTop = UDim.new(0, 10)
pad.PaddingLeft = UDim.new(0, 8)
pad.Parent = sidebar

--// PAGE SYSTEM
local pageHolder = createFrame(body, UDim2.new(1, -CONFIG.SIZES.SIDEBAR_WIDTH, 1, 0), UDim2.new(0, CONFIG.SIZES.SIDEBAR_WIDTH, 0, 0), CONFIG.COLORS.BG, 0)
pageHolder.BackgroundTransparency = 1

local pages = {}
local function newPage(name)
	local p = createFrame(pageHolder, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), CONFIG.COLORS.BG, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	pages[name] = p
	return p
end

local main = newPage("main")



local Auto = newPage("Auto")

--// AUTO PAGE (CLEAN - SINGLE SYSTEM)

local Auto = newPage("Auto")
Auto.BackgroundTransparency = 1

local autoPages = {}

-- TOP BAR
local autoTopBar = createFrame(
	Auto,
	UDim2.new(1, 0, 0, 24),
	UDim2.new(0, 0, 0, 0),
	CONFIG.COLORS.SIDEBAR_BG,
	6
)

-- LAYOUT
local autoLayout = Instance.new("UIListLayout")
autoLayout.FillDirection = Enum.FillDirection.Horizontal
autoLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
autoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
autoLayout.Padding = UDim.new(0, 6)
autoLayout.Parent = autoTopBar

-- PADDING
local autoPad = Instance.new("UIPadding")
autoPad.PaddingLeft = UDim.new(0, 8)
autoPad.PaddingRight = UDim.new(0, 8)
autoPad.PaddingTop = UDim.new(0, 1)
autoPad.PaddingBottom = UDim.new(0, 1)
autoPad.Parent = autoTopBar

-- PAGE HOLDER
local autoHolder = createFrame(
	Auto,
	UDim2.new(1, 0, 1, -24),
	UDim2.new(0, 0, 0, 24),
	CONFIG.COLORS.BG,
	0
)
autoHolder.BackgroundTransparency = 1

-- CREATE PAGES
local function createAutoPage(name)
	local p = createFrame(autoHolder, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), CONFIG.COLORS.BG, 0)
	p.Visible = false
	p.BackgroundTransparency = 1
	autoPages[name] = p
	return p
end

local AutoMob = createAutoPage("AutoMob")
local AutoBoss = createAutoPage("AutoBoss")
local AutoWeapon = createAutoPage("AutoWeapon")
local AutoBuy = createAutoPage("AutoBuy")

AutoMob.Visible = true

-- SWITCH
local function switchAuto(tab)
	for n,p in pairs(autoPages) do
		p.Visible = (n == tab)
	end
end

-- ACTIVE BTN
local activeAutoBtn
local function setActiveAutoBtn(btn)
	if activeAutoBtn then
		activeAutoBtn.BackgroundColor3 = CONFIG.COLORS.BTN_INACTIVE
	end
	activeAutoBtn = btn
	btn.BackgroundColor3 = CONFIG.COLORS.BTN_ACTIVE
end

-- BUTTONS
local autoTabs = {
	{"AutoMob","Mob"},
	{"AutoBoss","Boss"},
	{"AutoWeapon","Weapon"},
	{"AutoBuy","Buy"}
}

for i, data in ipairs(autoTabs) do
	local btn = createButton(
		autoTopBar,
		UDim2.new(0, 70, 0, 20),
		UDim2.new(0, 0, 0, 0),
		data[2],
		CONFIG.COLORS.BTN_INACTIVE,
		CONFIG.COLORS.MAIN,
		4
	)

	btn.Font = Enum.Font.Gotham
	btn.TextSize = 11

	btn.MouseButton1Click:Connect(function()
		switchAuto(data[1])
		setActiveAutoBtn(btn)
	end)

	if i == 1 then
		setActiveAutoBtn(btn)
	end
end
	 
local PlayerP = newPage("Player")



local Webhook = newPage("Webhook")



local Misc = newPage("Misc")


local Config = newPage("Config")

--// UI SCALE CONFIG (50% - 150%)

local scaleValue = 1 -- 1 = 100%
local minScale = 0.5
local maxScale = 1.5

-- CONTAINER
local scaleFrame = createFrame(
	Config,
	UDim2.new(0, 300, 0, 60),
	UDim2.new(0, 20, 0, 20),
	CONFIG.COLORS.SIDEBAR_BG,
	8
)

-- LABEL
local title = createLabel(
	scaleFrame,
	"UI Scale",
	UDim2.new(0, 100, 0, 20),
	UDim2.new(0, 10, 0, 5),
	Enum.Font.GothamBold,
	14,
	CONFIG.COLORS.MAIN,
	1
)

-- BAR BACKGROUND
local barBg = createFrame(
	scaleFrame,
	UDim2.new(0, 140, 0, 10),
	UDim2.new(0, 100, 0, 25),
	CONFIG.COLORS.DARK,
	6
)

-- BAR FILL
local barFill = createFrame(
	barBg,
	UDim2.new(1, 0, 1, 0),
	UDim2.new(0, 0, 0, 0),
	CONFIG.COLORS.MAIN,
	6
)

-- PERCENT LABEL
local percentLabel = createLabel(
	scaleFrame,
	"100%",
	UDim2.new(0, 60, 0, 20),
	UDim2.new(0, 250, 0, 20),
	Enum.Font.GothamBold,
	14,
	CONFIG.COLORS.MAIN,
	1
)

-- BUTTONS (- / +)
local minusBtn = createButton(
	scaleFrame,
	UDim2.new(0, 30, 0, 30),
	UDim2.new(0, 250, 0, 5),
	"-",
	CONFIG.COLORS.BTN_INACTIVE,
	CONFIG.COLORS.MAIN,
	6
)

local plusBtn = createButton(
	scaleFrame,
	UDim2.new(0, 30, 0, 30),
	UDim2.new(0, 280, 0, 5),
	"+",
	CONFIG.COLORS.BTN_INACTIVE,
	CONFIG.COLORS.MAIN,
	6
)

-- FUNCTION TO UPDATE UI
local function updateScale()
	local percent = math.floor(scaleValue * 100)

	percentLabel.Text = percent .. "%"

	barFill.Size = UDim2.new(scaleValue, 0, 1, 0)
end

-- BUTTON LOGIC
minusBtn.MouseButton1Click:Connect(function()
	scaleValue = math.clamp(scaleValue - 0.1, minScale, maxScale)
	updateScale()
end)

plusBtn.MouseButton1Click:Connect(function()
	scaleValue = math.clamp(scaleValue + 0.1, minScale, maxScale)
	updateScale()
end)

updateScale()

main.Visible = true

local function switch(tab)
	for n, p in pairs(pages) do
		p.Visible = (n == tab)
	end
end


--// TABS
local tabs = {
	{icon = "", name = "main", displayName = "Home"},
	{icon = "⚡", name = "Auto", displayName = "Auto"},
	{icon = "👤", name = "Player", displayName = "Player"},
	{icon = "🌐", name = "Webhook", displayName = "Webhook"},
	{icon = "•••", name = "Misc", displayName = "Misc"},
	{icon = "⚙️", name = "Config", displayName = "Config"}
}

for _, tab in ipairs(tabs) do
	local btn = createButton(sidebar, UDim2.new(1, -10, 0, 30), UDim2.new(0, 0, 0, 0), "", CONFIG.COLORS.BTN_INACTIVE, CONFIG.COLORS.MAIN, 8)
	
	createLabel(btn, tab.icon, UDim2.new(0, 22, 1, 0), UDim2.new(0, 8, 0, 0), Enum.Font.Gotham, 14, CONFIG.COLORS.MAIN, 1)
	createLabel(btn, tab.displayName, UDim2.new(1, -40, 1, 0), UDim2.new(0, 35, 0, 0), Enum.Font.Gotham, 15, CONFIG.COLORS.MAIN, 1).TextXAlignment = Enum.TextXAlignment.Left

	btn.MouseButton1Click:Connect(function()
		switch(tab.name)
		setActive(btn)
	end)
end

--// CLOSE / MINI TOGGLE
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)

--// CLEANUP
local connection
connection = Players.PlayerRemoving:Connect(function(p)
	if p == player then
		gui:Destroy()
		connection:Disconnect()
	end
end)
