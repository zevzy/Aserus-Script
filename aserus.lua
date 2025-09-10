
--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

--// GUI Root
local gui = Instance.new("ScreenGui")
gui.Name = "ArdeluxGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--// Utils
local function addCorner(inst, r)
	Instance.new("UICorner", inst).CornerRadius = UDim.new(0, r or 8)
end

local function hoverify(btn, baseColor, hoverColor, textBase, textHover)
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = baseColor
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = hoverColor}):Play()
		if textHover then btn.TextColor3 = textHover end
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = baseColor}):Play()
		if textBase then btn.TextColor3 = textBase end
	end)
end

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 300)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
addCorner(mainFrame, 12)

-- Subtle dark gradient (zostawiam, ale prawie czarny)
local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 34)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 26))
}
bgGrad.Rotation = 35
bgGrad.Parent = mainFrame

--// Title Bar + Executor
local function detectExecutor()
	local name = "Unknown"
	pcall(function()
		if getexecutorname then
			name = getexecutorname()
		elseif identifyexecutor then
			local n, v = identifyexecutor()
			name = n .. (v and (" v" .. tostring(v)) or "")
		end
	end)
	return name
end

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,34)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
addCorner(titleBar, 12)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-70,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.BackgroundTransparency = 1
titleText.Text = "Aserus | Brookhaven RP Script  |  Executor: " .. detectExecutor()
titleText.TextColor3 = Color3.fromRGB(245,245,255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 15
titleText.Parent = titleBar

-- Minimize & Close
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,26,0,26)
minimizeBtn.Position = UDim2.new(1,-62,0,4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(90, 120, 230) -- jaśniejsze
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = titleBar
addCorner(minimizeBtn, 6)
hoverify(minimizeBtn, Color3.fromRGB(90,120,230), Color3.fromRGB(120,145,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Position = UDim2.new(1,-32,0,4)
closeBtn.BackgroundColor3 = Color3.fromRGB(235,70,90)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = titleBar
addCorner(closeBtn, 6)
hoverify(closeBtn, Color3.fromRGB(235,70,90), Color3.fromRGB(255,110,130), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))

-- Panels
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.3,0,1,-34)
leftPanel.Position = UDim2.new(0,0,0,34)
leftPanel.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame
addCorner(leftPanel, 10)

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,6)
uiList.Parent = leftPanel

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.7,0,1,-34)
rightPanel.Position = UDim2.new(0.3,0,0,34)
rightPanel.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame
addCorner(rightPanel, 10)

-- Minimize logic
local minimized = false
local originalSize = mainFrame.Size
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		leftPanel.Visible = false
		rightPanel.Visible = false
		mainFrame:TweenSize(UDim2.new(originalSize.X.Scale,originalSize.X.Offset,0,34),"Out","Quad",0.25,true)
	else
		mainFrame:TweenSize(originalSize,"Out","Quad",0.25,true,function()
			leftPanel.Visible = true
			rightPanel.Visible = true
		end)
	end
end)

-- Close GUI
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Dragging
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y
	)
end
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		updateDrag(input)
	end
end)

-- Channels system + cleanup support
local channels = {}
local activeCleanup = nil
local function showChannel(name)
	if activeCleanup then
		pcall(activeCleanup)
		activeCleanup = nil
	end
	for _, child in pairs(rightPanel:GetChildren()) do
		if not child:IsA("UICorner") then
			child:Destroy()
		end
	end
	local cleanup = channels[name] and channels[name]()
	if type(cleanup) == "function" then
		activeCleanup = cleanup
	end
end

local function addChannel(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,32)
	btn.BackgroundColor3 = Color3.fromRGB(88, 104, 190) -- jaśniejsze kategorie
	btn.TextColor3 = Color3.fromRGB(245,245,255)
	btn.Text = "•  "..name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = leftPanel
	addCorner(btn, 8)
	hoverify(btn, Color3.fromRGB(88,104,190), Color3.fromRGB(115,135,220), Color3.fromRGB(245,245,255), Color3.fromRGB(255,255,255))

	channels[name] = callback
	btn.MouseButton1Click:Connect(function()
		showChannel(name)
	end)
end

-- Roblox-like Toasts (stacking)
local toasts = {}
local function layoutToasts()
	for i, f in ipairs(toasts) do
		local targetY = -60 - (i-1)*48
		TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -270, 1, targetY)}):Play()
	end
end

local function robloxToast(message)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 250, 0, 40)
	frame.Position = UDim2.new(1, -270, 1, -60)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,35)
	frame.BorderSizePixel = 0
	frame.Parent = gui
	addCorner(frame, 8)

	local stroke = Instance.new("UIStroke", frame)
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(70, 70, 90)
	stroke.Transparency = 0.35

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1,-14,1,-10)
	label.Position = UDim2.new(0,10,0,5)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextColor3 = Color3.fromRGB(235,235,245)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.Text = message
	label.Parent = frame

	frame.BackgroundTransparency = 1
	label.TextTransparency = 1

	table.insert(toasts, 1, frame)
	layoutToasts()

	TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
	TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 0}):Play()

	task.delay(3, function()
		TweenService:Create(frame, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
		TweenService:Create(label, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
		task.wait(0.26)
		for i, f in ipairs(toasts) do
			if f == frame then
				table.remove(toasts, i)
				break
			end
		end
		frame:Destroy()
		layoutToasts()
	end)
end

-- Player join/leave toasts (global)
Players.PlayerAdded:Connect(function(p)
	robloxToast("Joined: " .. p.Name)
end)
Players.PlayerRemoving:Connect(function(p)
	robloxToast("Left: " .. p.Name)
end)

-- ====== CHANNEL: Information ======
addChannel("Information", function()
	local infoBox = Instance.new("Frame")
	infoBox.Size = UDim2.new(1,-20,0,200)
	infoBox.Position = UDim2.new(0,10,0,10)
	infoBox.BackgroundColor3 = Color3.fromRGB(26, 30, 50)
	infoBox.BorderSizePixel = 0
	infoBox.Parent = rightPanel
	addCorner(infoBox, 12)

	-- usunięty żółty tytuł (nie działał wg wymagań)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1,-20,0,150)
	scrollFrame.Position = UDim2.new(0,10,0,10)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.CanvasSize = UDim2.new(0,0,0,200)
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.Parent = infoBox

	local description = Instance.new("TextLabel")
	description.Size = UDim2.new(1,-10,0,200)
	description.Position = UDim2.new(0,0,0,0)
	description.BackgroundTransparency = 1
	description.Text = "Local Admin Panel for Brookhaven.\n\n• People: lista graczy, TP i View (live)\n• Fun: suwak WalkSpeed / JumpPower (lokalnie)\n• FE Scripts: Infinite Yield\n\njoin our discord: discord.gg/bdGpY6EPB5"
	description.TextColor3 = Color3.fromRGB(230,235,255)
	description.TextWrapped = true
	description.Font = Enum.Font.Gotham
	description.TextSize = 14
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.Parent = scrollFrame

	-- Przycisk Discord POD ramką info, na pełną szerokość
	local discordBtn = Instance.new("TextButton")
	discordBtn.Size = UDim2.new(1,-20,0,36)
	discordBtn.Position = UDim2.new(0,10,0,220)
	discordBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
	discordBtn.TextColor3 = Color3.fromRGB(255,255,255)
	discordBtn.Text = "Discord"
	discordBtn.Font = Enum.Font.GothamBold
	discordBtn.TextSize = 14
	discordBtn.BorderSizePixel = 0
	discordBtn.Parent = rightPanel
	addCorner(discordBtn, 10)
	hoverify(discordBtn, Color3.fromRGB(70,110,255), Color3.fromRGB(95,135,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))

	local DISCORD_LINK = "https://discord.gg/bdGpY6EPB5"
	discordBtn.MouseButton1Click:Connect(function()
		local ok = pcall(function()
			if setclipboard then setclipboard(DISCORD_LINK) end
		end)
		if ok then
			robloxToast("Link copied. Paste it in your browser.")
		else
			robloxToast("Copy failed. Link: "..DISCORD_LINK)
		end
	end)
end)

-- ====== CHANNEL: People (TP + View, live, filter) ======
addChannel("People", function()
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-20,1,-20)
	container.Position = UDim2.new(0,10,0,10)
	container.BackgroundTransparency = 1
	container.Parent = rightPanel

	-- Search + Selected
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1,0,0,36)
	topBar.BackgroundColor3 = Color3.fromRGB(26, 30, 50)
	topBar.BorderSizePixel = 0
	topBar.Parent = container
	addCorner(topBar, 8)

	local search = Instance.new("TextBox")
	search.Size = UDim2.new(0.6,-10,1,-10)
	search.Position = UDim2.new(0,8,0,5)
	search.BackgroundColor3 = Color3.fromRGB(34, 38, 70)
	search.PlaceholderText = "Search for a player"
	search.Text = ""
	search.TextColor3 = Color3.fromRGB(255,255,255)
	search.PlaceholderColor3 = Color3.fromRGB(200,205,215)
	search.Font = Enum.Font.Gotham
	search.TextSize = 13
	search.BorderSizePixel = 0
	search.Parent = topBar
	addCorner(search, 6)

	local selectedLbl = Instance.new("TextLabel")
	selectedLbl.Size = UDim2.new(0.4,-16,1,-10)
	selectedLbl.Position = UDim2.new(0.6,8,0,5)
	selectedLbl.BackgroundTransparency = 1
	selectedLbl.Text = "Selected: —"
	selectedLbl.TextColor3 = Color3.fromRGB(230,235,255)
	selectedLbl.Font = Enum.Font.Gotham
	selectedLbl.TextSize = 13
	selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
	selectedLbl.Parent = topBar

	-- List
	local frameList = Instance.new("Frame")
	frameList.Size = UDim2.new(1,0,1,-90)
	frameList.Position = UDim2.new(0,0,0,46)
	frameList.BackgroundColor3 = Color3.fromRGB(22, 24, 40)
	frameList.BorderSizePixel = 0
	frameList.Parent = container
	addCorner(frameList, 10)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-10,1,-10)
	scroll.Position = UDim2.new(0,5,0,5)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.Parent = frameList

	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = scroll
	listLayout.Padding = UDim.new(0,4)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Actions
	local actions = Instance.new("Frame")
	actions.Size = UDim2.new(1,0,0,38)
	actions.Position = UDim2.new(0,0,1,-38)
	actions.BackgroundColor3 = Color3.fromRGB(26, 30, 50)
	actions.BorderSizePixel = 0
	actions.Parent = container
	addCorner(actions, 8)

	local tpBtn = Instance.new("TextButton")
	tpBtn.Size = UDim2.new(0.5,-8,1,-8)
	tpBtn.Position = UDim2.new(0,8,0,4)
	tpBtn.BackgroundColor3 = Color3.fromRGB(70,110,255)
	tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
	tpBtn.Text = "Teleport"
	tpBtn.Font = Enum.Font.GothamBold
	tpBtn.TextSize = 14
	tpBtn.BorderSizePixel = 0
	tpBtn.Parent = actions
	addCorner(tpBtn, 8)
	hoverify(tpBtn, Color3.fromRGB(70,110,255), Color3.fromRGB(95,135,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))

	local viewBtn = Instance.new("TextButton")
	viewBtn.Size = UDim2.new(0.5,-8,1,-8)
	viewBtn.Position = UDim2.new(0.5,0,0,4)
	viewBtn.BackgroundColor3 = Color3.fromRGB(90, 120, 230)
	viewBtn.TextColor3 = Color3.fromRGB(255,255,255)
	viewBtn.Text = "View / Unview"
	viewBtn.Font = Enum.Font.GothamBold
	viewBtn.TextSize = 14
	viewBtn.BorderSizePixel = 0
	viewBtn.Parent = actions
	addCorner(viewBtn, 8)
	hoverify(viewBtn, Color3.fromRGB(90,120,230), Color3.fromRGB(120,145,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))

	-- Selection state
	local selectedPlayer : Player? = nil
	local viewingTarget : Player? = nil

	local function setSelected(plr)
		selectedPlayer = plr
		if plr then
			selectedLbl.Text = "Selected: " .. plr.Name .. " ("..plr.DisplayName..")"
		else
			selectedLbl.Text = "Selected: —"
		end
	end

	-- Build one row helper
	local function makeRow(plr)
		local row = Instance.new("TextButton")
		row.Size = UDim2.new(1, -8, 0, 26)
		row.BackgroundColor3 = Color3.fromRGB(40, 48, 90)
		row.TextColor3 = Color3.fromRGB(235,235,245)
		row.Font = Enum.Font.Gotham
		row.TextSize = 13
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.Text = "  " .. plr.Name .. "  (" .. plr.DisplayName .. ")"
		row.BorderSizePixel = 0
		row.Parent = scroll
		addCorner(row, 6)
		hoverify(row, Color3.fromRGB(40,48,90), Color3.fromRGB(60,70,120))

		row.MouseButton1Click:Connect(function()
			setSelected(plr)
		end)
	end

	-- Rebuild list with filter
	local function matches(plr, q)
		if not q or q == "" then return true end
		q = q:lower()
		return plr.Name:lower():find(q, 1, true) or plr.DisplayName:lower():find(q, 1, true)
	end

	local function rebuild()
		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		local q = search.Text
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and matches(plr, q) then
				makeRow(plr)
			end
		end
		scroll.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y + 6)
	end

	-- Actions handlers
	tpBtn.MouseButton1Click:Connect(function()
		local target = selectedPlayer
		if target and target.Character and player.Character then
			local hrp = target.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				player.Character:MoveTo(hrp.Position + Vector3.new(0,2,0))
			end
		end
	end)

	viewBtn.MouseButton1Click:Connect(function()
		local cam = workspace.CurrentCamera
		if viewingTarget then
			-- unview
			viewingTarget = nil
			if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				cam.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
			end
			robloxToast("Stopped viewing.")
			return
		end
		local target = selectedPlayer
		if target and target.Character and target.Character:FindFirstChildOfClass("Humanoid") then
			viewingTarget = target
			cam.CameraSubject = target.Character:FindFirstChildOfClass("Humanoid")
			robloxToast("Viewing: "..target.Name)
		end
	end)

	-- Live updates + cleanup
	local addedConn, removedConn, dispConn = nil, nil, {}

	addedConn = Players.PlayerAdded:Connect(function(plr)
		rebuild()
	end)
	removedConn = Players.PlayerRemoving:Connect(function(plr)
		if selectedPlayer == plr then setSelected(nil) end
		if viewingTarget == plr then
			viewingTarget = nil
			if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				workspace.CurrentCamera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
			end
		end
		rebuild()
	end)

	-- Rebuild when someone's DisplayName changes
	for _, plr in ipairs(Players:GetPlayers()) do
		table.insert(dispConn, plr:GetPropertyChangedSignal("DisplayName"):Connect(rebuild))
	end

	search:GetPropertyChangedSignal("Text"):Connect(rebuild)

	rebuild()

	-- Return cleanup function to disconnect events when kanał zmieniany
	return function()
		if addedConn then addedConn:Disconnect() end
		if removedConn then removedConn:Disconnect() end
		for _,c in ipairs(dispConn) do pcall(function() c:Disconnect() end) end
	end
end)

-- ====== CHANNEL: Fun (slidery) ======
addChannel("Fun", function()
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-20,1,-20)
	container.Position = UDim2.new(0,10,0,10)
	container.BackgroundTransparency = 1
	container.Parent = rightPanel

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,14)
	layout.Parent = container

	local function createSlider(name, minVal, maxVal, defaultVal, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1,0,0,70)
		frame.BackgroundColor3 = Color3.fromRGB(26, 30, 50)
		frame.BorderSizePixel = 0
		frame.Parent = container
		addCorner(frame, 10)

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,-20,0,20)
		label.Position = UDim2.new(0,10,0,8)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(230,235,255)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = name.." | "..defaultVal
		label.Parent = frame

		local sliderFrame = Instance.new("Frame")
		sliderFrame.Size = UDim2.new(1,-20,0,18)
		sliderFrame.Position = UDim2.new(0,10,0,40)
		sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 55, 110)
		sliderFrame.BorderSizePixel = 0
		sliderFrame.Parent = frame
		addCorner(sliderFrame, 9)

		local sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new(0,0,1,0)
		sliderFill.BackgroundColor3 = Color3.fromRGB(255,215,0)
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderFrame
		addCorner(sliderFill, 9)

		local function updateSlider(posX)
			local rel = math.clamp(posX / math.max(1, sliderFrame.AbsoluteSize.X), 0, 1)
			local value = math.floor(minVal + (maxVal - minVal) * rel + 0.5)
			sliderFill.Size = UDim2.new(rel, 0, 1, 0)
			label.Text = name.." | "..value
			callback(value)
		end

		sliderFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				updateSlider(input.Position.X - sliderFrame.AbsolutePosition.X)

				local moveConn
				moveConn = UIS.InputChanged:Connect(function(moveInput)
					if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
						updateSlider(moveInput.Position.X - sliderFrame.AbsolutePosition.X)
					end
				end)

				local endConn
				endConn = UIS.InputEnded:Connect(function(endInput)
					if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
						if moveConn then moveConn:Disconnect() end
						if endConn then endConn:Disconnect() end
					end
				end)
			end
		end)

		local rel0 = (defaultVal - minVal) / (maxVal - minVal)
		sliderFill.Size = UDim2.new(math.clamp(rel0,0,1),0,1,0)
		callback(defaultVal)
	end

	createSlider("WalkSpeed", 16, 500, 16, function(val)
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = val
		end
	end)
	createSlider("JumpPower", 50, 500, 50, function(val)
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.JumpPower = val
		end
	end)
end)

-- ====== CHANNEL: FE Scripts ======
addChannel("FE Scripts", function()
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-20,1,-20)
	container.Position = UDim2.new(0,10,0,10)
	container.BackgroundTransparency = 1
	container.Parent = rightPanel

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,10)
	layout.Parent = container

	local adminTitle = Instance.new("TextLabel")
	adminTitle.Size = UDim2.new(1,-20,0,28)
	adminTitle.Position = UDim2.new(0,10,0,0)
	adminTitle.BackgroundTransparency = 1
	adminTitle.Text = "AdminPanel"
	adminTitle.TextColor3 = Color3.fromRGB(255,215,0)
	adminTitle.Font = Enum.Font.GothamBold
	adminTitle.TextSize = 18
	adminTitle.TextXAlignment = Enum.TextXAlignment.Left
	adminTitle.Parent = container

	local function createButton(name, func)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,40)
		btn.BackgroundColor3 = Color3.fromRGB(60, 75, 160)
		btn.TextColor3 = Color3.fromRGB(245,245,255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.Text = name
		btn.BorderSizePixel = 0
		btn.Parent = container
		addCorner(btn, 10)
		hoverify(btn, Color3.fromRGB(60,75,160), Color3.fromRGB(85,100,190), Color3.fromRGB(245,245,255), Color3.fromRGB(255,255,255))
		btn.MouseButton1Click:Connect(func)
	end

	createButton("Infinite Yield (All Games)", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end)
end)

-- ====== RP Name Auto-Set via UI (Brookhaven) ======
local TARGET_RP_NAME = "Aserus The Best Script"

local function trySetRPNameUI()
	task.spawn(function()
		local deadline = os.clock() + 10
		local success = false
		while os.clock() < deadline and not success do
			local pg = player:FindFirstChildOfClass("PlayerGui")
			if pg then
				for _, tb in ipairs(pg:GetDescendants()) do
					if tb:IsA("TextBox") then
						local nameLower = (tb.Name or ""):lower()
						local ph = (tb.PlaceholderText or ""):lower()
						-- typowe pola RP / name w Brookhaven UI
						if ph:find("rp") or ph:find("role") or ph:find("name") or nameLower:find("rp") or nameLower:find("name") then
							pcall(function()
								tb.Text = TARGET_RP_NAME
								tb:CaptureFocus()
								tb:ReleaseFocus(true) -- symulacja enter/submit
							end)
							-- poszukaj guzika confirm w pobliżu
							local parent = tb.Parent
							if parent then
								for _, btn in ipairs(parent:GetDescendants()) do
									if btn:IsA("TextButton") then
										local bn = (btn.Name or ""):lower()
										local bt = (btn.Text or ""):lower()
										if bn:find("set") or bn:find("ok") or bn:find("confirm") or bt:find("set") or bt:find("ok") or bt:find("confirm") then
											pcall(function()
												if typeof(firesignal) == "function" then
													firesignal(btn.MouseButton1Click)
												end
												btn:Activate()
											end)
											success = true
											break
										end
									end
								end
							end
							if success then break end
						end
					end
				end
			end
			if not success then task.wait(0.4) end
		end
		if success then
			robloxToast("RP Name set: "..TARGET_RP_NAME)
		end
	end)
end

-- Run once and on respawn
trySetRPNameUI()
player.CharacterAdded:Connect(function()
	task.wait(1.2)
	trySetRPNameUI()
end)

-- Start on Information
showChannel("Information")
