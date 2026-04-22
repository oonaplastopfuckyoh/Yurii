--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// CONFIG
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

--// MINI BUTTON (FIXED)
local mini = Instance.new("ImageButton")
mini.Size = UDim2.new(0, 60, 0, 30)
mini.Position = UDim2.new(0.5, -30, 0.5, -15)
mini.BackgroundColor3 = CONFIG.COLORS.SIDEBAR_BG
mini.Visible = false
mini.ZIndex = 9999
mini.Parent = gui
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 6)

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
local PlayerP = newPage("Player")
local Webhook = newPage("Webhook")
local Misc = newPage("Misc")
local Config = newPage("Config")

main.Visible = true

local function switch(tab)
	for n, p in pairs(pages) do
		p.Visible = (n == tab)
	end
end

--// AUTO SYSTEM (FIXED, SINGLE VERSION ONLY)
local autoPages = {}

local autoTopBar = createFrame(Auto, UDim2.new(1, 0, 0, 32), UDim2.new(0, 0, 0, 0), CONFIG.COLORS.SIDEBAR_BG, 6)

local function newAutoPage(name)
	local p = createFrame(Auto, UDim2.new(1, 0, 1, -32), UDim2.new(0, 0, 0, 32), CONFIG.COLORS.BG, 0)
	p.BackgroundTransparency = 1
	p.Visible = false
	autoPages[name] = p
	return p
end

local AutoMob = newAutoPage("AutoMob")
local AutoBoss = newAutoPage("AutoBoss")
local AutoWeapon = newAutoPage("AutoWeapon")
local AutoBuy = newAutoPage("AutoBuy")

AutoMob.Visible = true

local function switchAuto(tab)
	for n, p in pairs(autoPages) do
		p.Visible = (n == tab)
	end
end

local autoBtns = {
	{"AutoMob","Mob"},
	{"AutoBoss","Boss"},
	{"AutoWeapon","Weapon"},
	{"AutoBuy","Buy"},
}

for i, data in ipairs(autoBtns) do
	local btn = createButton(autoTopBar, UDim2.new(0, 70, 0, 22), UDim2.new(0, (i-1)*75 + 10, 0, 5), data[2], CONFIG.COLORS.BTN_INACTIVE, CONFIG.COLORS.MAIN, 4)
	btn.MouseButton1Click:Connect(function()
		switchAuto(data[1])
	end)
end

--// SIDEBAR TABS
local tabs = {
	{ "", "main", "Home"},
	{ "⚡", "Auto", "Auto"},
	{ "👤", "Player", "Player"},
	{ "🌐", "Webhook", "Webhook"},
	{ "•••", "Misc", "Misc"},
	{ "⚙️", "Config", "Config"}
}

for _, tab in ipairs(tabs) do
	local btn = createButton(sidebar, UDim2.new(1, -10, 0, 30), UDim2.new(0, 0, 0, 0), tab[3], CONFIG.COLORS.BTN_INACTIVE, CONFIG.COLORS.MAIN, 8)
	btn.MouseButton1Click:Connect(function()
		switch(tab[2])
	end)
end

--// TOGGLE
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
	frame.Visible = true
	mini.Visible = false
end)end

-- Show first sub-page by default
autoSubPages.AutoMob.Visible = true

--// ACTIVE TAB
local activeBtn
local function setActive(btn)
	if activeBtn then
		activeBtn.BackgroundColor3 = CONFIG.COLORS.BTN_INACTIVE
	end
	activeBtn = btn
	btn.BackgroundColor3 = CONFIG.COLORS.BTN_ACTIVE
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
