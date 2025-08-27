local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ArdeluxGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- === STYL / UTIL ===
local function addCorner(inst, r) Instance.new("UICorner", inst).CornerRadius = UDim.new(0, r or 8) end

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

-- === MAIN FRAME ===
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 280)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 24, 32)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
addCorner(mainFrame, 12)

-- (USUNIĘTO BLOK "cień" z ImageLabel Shadow)

-- gradient na tle
local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 60, 140)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 35, 140))
})
bgGrad.Rotation = 35
bgGrad.Parent = mainFrame

-- === TITLE BAR ===
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,34)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
addCorner(titleBar, 12)

local titleGrad = Instance.new("UIGradient")
titleGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 85, 200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 85, 220))
})
titleGrad.Rotation = 90
titleGrad.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0.25),
	NumberSequenceKeypoint.new(1, 0.25)
}
titleGrad.Parent = titleBar

-- === DETEKCJA EXECUTORA (pokazywana z LEWEJ, przy nazwie) ===
local executorName = "Unknown"
pcall(function()
    if getexecutorname then
        executorName = getexecutorname()
    elseif identifyexecutor then
        local n, v = identifyexecutor()
        executorName = n .. (v and (" v"..v) or "")
    end
end)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-70,1,0)
titleText.Position = UDim2.new(0,10,0,0)
titleText.BackgroundTransparency = 1
titleText.Text = "Aserus | Brookhaven RP Script | Executor: "..executorName..""
titleText.TextColor3 = Color3.fromRGB(245,245,255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 15
titleText.Parent = titleBar

-- Minimize & close
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,26,0,26)
minimizeBtn.Position = UDim2.new(1,-62,0,4)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70,110,255)
minimizeBtn.Text = "–"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = titleBar
addCorner(minimizeBtn, 6)
hoverify(minimizeBtn, Color3.fromRGB(70,110,255), Color3.fromRGB(95,135,255), Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))

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

-- === PANELS ===
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.3,0,1,-34)
leftPanel.Position = UDim2.new(0,0,0,34)
leftPanel.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame
addCorner(leftPanel, 10)

local leftGrad = Instance.new("UIGradient")
leftGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 45, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 35, 60))
})
leftGrad.Rotation = 90
leftGrad.Parent = leftPanel

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,6)
uiList.Parent = leftPanel

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.7,0,1,-34)
rightPanel.Position = UDim2.new(0.3,0,0,34)
rightPanel.BackgroundColor3 = Color3.fromRGB(24, 26, 38)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame
addCorner(rightPanel, 10)

local rightGrad = Instance.new("UIGradient")
rightGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 35, 70)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 24, 48))
})
rightGrad.Rotation = 90
rightGrad.Parent = rightPanel

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

-- Dragging GUI
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
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
		update(input)
	end
end)

-- === CHANNELS SYSTEM ===
local channels = {}
local function showChannel(name)
	for _, child in pairs(rightPanel:GetChildren()) do
		if not child:IsA("UICorner") and not child:IsA("UIGradient") then
			child:Destroy()
		end
	end
	if channels[name] then
		channels[name]()
	end
end

local function addChannel(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,32)
	btn.BackgroundColor3 = Color3.fromRGB(48, 60, 130)
	btn.TextColor3 = Color3.fromRGB(245,245,255)
	btn.Text = "•  "..name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = leftPanel
	addCorner(btn, 8)
	hoverify(btn, Color3.fromRGB(48, 60, 130), Color3.fromRGB(70, 85, 170), Color3.fromRGB(245,245,255), Color3.fromRGB(255,255,255))

	channels[name] = callback
	btn.MouseButton1Click:Connect(function()
		showChannel(name)
	end)
end

-- === Information channel ===
addChannel("Information", function()
	local infoBox = Instance.new("Frame")
	infoBox.Size = UDim2.new(1,-20,0,220)
	infoBox.Position = UDim2.new(0,10,0,10)
	infoBox.BackgroundColor3 = Color3.fromRGB(30, 36, 75)
	infoBox.BorderSizePixel = 0
	infoBox.Parent = rightPanel
	addCorner(infoBox, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,-20,0,40)
	title.Position = UDim2.new(0,10,0,10)
	title.BackgroundTransparency = 1
	title.Text = "Project in Development"
	title.TextColor3 = Color3.fromRGB(255,215,0)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = infoBox

	-- Scrolling frame for long text
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1,-20,0,150)
	scrollFrame.Position = UDim2.new(0,10,0,50)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.CanvasSize = UDim2.new(0,0,0,440) -- zwiększone, żeby zmieścił się podpis
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.Parent = infoBox

	local description = Instance.new("TextLabel")
	description.Size = UDim2.new(1,-10,0,440) -- dopasowane do CanvasSize
	description.Position = UDim2.new(0,0,0,0)
	description.BackgroundTransparency = 1
	description.Text = "This script is currently in beta and mainly designed\nas an Admin Panel for Brookhaven (works in any Roblox game).\n\nBrookhaven security prevents player trolling features:\n- Replication Filtering\n- Server Authority\n- Remote Validation\n- Integrity Checks\n\nBecause of this, actions such as Fling cannot affect other players.\nFling works only for the Local Player, since local physics and collisions\ndo not replicate to the server.\n\nFuture updates will focus on stability and expanding local features.\n\n---\nAuthor: !zevzy\nDiscord: kyllersv_\nPolish programmer"
	description.TextColor3 = Color3.fromRGB(230,235,255)
	description.TextWrapped = true
	description.Font = Enum.Font.Gotham
	description.TextSize = 14
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.Parent = scrollFrame
end)


-- === Fun channel (Speed & Jump) ===
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
		frame.BackgroundColor3 = Color3.fromRGB(30, 34, 60)
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
			local rel = math.clamp(posX / sliderFrame.AbsoluteSize.X, 0, 1)
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

-- === Troll channel ===





-- === People channel ===
addChannel("People", function()
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-20,1,-20)
	container.Position = UDim2.new(0,10,0,10)
	container.BackgroundTransparency = 1
	container.Parent = rightPanel

	-- nagłówek
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,22)
	title.BackgroundTransparency = 1
	title.Text = "Gracze (kliknij, aby się teleportować)"
	title.TextColor3 = Color3.fromRGB(255,215,0)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 12
	title.Parent = container

	-- ramka na listę graczy
	local playersFrame = Instance.new("Frame")
	playersFrame.Size = UDim2.new(1,0,0.5,0) -- 50% wysokości
	playersFrame.Position = UDim2.new(0,0,0,25)
	playersFrame.BackgroundColor3 = Color3.fromRGB(26,29,45)
	playersFrame.BorderSizePixel = 0
	playersFrame.Parent = container
	addCorner(playersFrame, 10)

	-- scroll w środku ramki
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-10,1,-10)
	scroll.Position = UDim2.new(0,5,0,5)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.CanvasSize = UDim2.new(0,0,0,0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Parent = playersFrame

	local layout = Instance.new("UIListLayout")
	layout.Parent = scroll
	layout.Padding = UDim.new(0,4)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	-- teleport smooth
	local function smoothTeleport(targetHRP)
		local char = player.Character
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp or not targetHRP then return end

		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end

		local steps = 14
		local startPos = hrp.Position
		local endPos = targetHRP.Position + Vector3.new(0, 3, 0)
		local delta = (endPos - startPos) / steps

		for i = 1, steps do
			hrp.CFrame = CFrame.new(startPos + delta * i)
			task.wait(0.04)
		end

		task.delay(0.3, function()
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end)
	end

	-- przyciski graczy (mniejsze)
	local function makePlayerButton(plr)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -8, 0, 24)
		btn.BackgroundColor3 = Color3.fromRGB(45, 55, 110)
		btn.TextColor3 = Color3.fromRGB(230, 235, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.BorderSizePixel = 0
		btn.Parent = scroll
		addCorner(btn, 6)

		local displayName = (plr.DisplayName ~= "" and plr.DisplayName) or plr.Name
		btn.Text = plr.Name .. " (" .. displayName .. ")"

		hoverify(btn, Color3.fromRGB(45,55,110), Color3.fromRGB(70,85,160))

		btn.MouseButton1Click:Connect(function()
			local targetChar = plr.Character
			local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
			if targetHRP then
				smoothTeleport(targetHRP)
			end
		end)
	end

	-- rebuild list
	local function rebuild()
		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("TextButton") then c:Destroy() end
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				makePlayerButton(plr)
			end
		end
		scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 5)
	end

	Players.PlayerAdded:Connect(function(plr)
		if plr ~= player then makePlayerButton(plr) end
		scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 5)
	end)
	Players.PlayerRemoving:Connect(function(plr)
		for _, c in ipairs(scroll:GetChildren()) do
			if c:IsA("TextButton") and c.Text:find("^"..plr.Name.." %(") then
				c:Destroy()
			end
		end
		scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 5)
	end)

	for _, plr in ipairs(Players:GetPlayers()) do
		plr:GetPropertyChangedSignal("DisplayName"):Connect(function()
			rebuild()
		end)
	end
	rebuild()

	-- ramka do "View" (niżej, z większą przerwą)
	local viewFrame = Instance.new("Frame")
	viewFrame.Size = UDim2.new(1,0,0,70)
	viewFrame.Position = UDim2.new(0,0,0.55,40) -- 55% + większa przerwa
	viewFrame.BackgroundColor3 = Color3.fromRGB(30,34,70)
	viewFrame.BorderSizePixel = 0
	viewFrame.Parent = container
	addCorner(viewFrame, 10)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 20)
	label.Position = UDim2.new(0,5,0,5)
	label.BackgroundTransparency = 1
	label.Text = "Enter part of a nickname to view the player:"
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = viewFrame

	local nameBox = Instance.new("TextBox")
	nameBox.Size = UDim2.new(0.65, -5, 0, 24)
	nameBox.Position = UDim2.new(0,5,0,35)
	nameBox.BackgroundColor3 = Color3.fromRGB(35,40,90)
	nameBox.PlaceholderText = "Nick gracza..."
	nameBox.TextColor3 = Color3.fromRGB(255,255,255)
	nameBox.Font = Enum.Font.Gotham
	nameBox.TextSize = 12
	nameBox.BorderSizePixel = 0
	nameBox.Parent = viewFrame
	addCorner(nameBox, 6)

	local viewBtn = Instance.new("TextButton")
	viewBtn.Size = UDim2.new(0.3, 0, 0, 24)
	viewBtn.Position = UDim2.new(0.7,0,0,35)
	viewBtn.BackgroundColor3 = Color3.fromRGB(70, 110, 255)
	viewBtn.TextColor3 = Color3.fromRGB(255,255,255)
	viewBtn.Font = Enum.Font.GothamBold
	viewBtn.TextSize = 12
	viewBtn.Text = "View"
	viewBtn.BorderSizePixel = 0
	viewBtn.Parent = viewFrame
	addCorner(viewBtn, 6)
	hoverify(viewBtn, Color3.fromRGB(70,110,255), Color3.fromRGB(95,135,255))

	-- wyszukiwanie po fragmencie nicku
	local function findPlayerByPartialName(input)
		input = input:lower()
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				if plr.Name:lower():sub(1, #input) == input or plr.DisplayName:lower():sub(1, #input) == input then
					return plr
				end
			end
		end
		return nil
	end

	-- === VIEW SYSTEM ===
	local viewingTarget = nil

	local function startViewing(plr)
		if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") then
			viewingTarget = plr
			workspace.CurrentCamera.CameraSubject = plr.Character:FindFirstChild("Humanoid")
			print("Patrzysz na gracza: " .. plr.Name)
		end
	end

	local function stopViewing()
		viewingTarget = nil
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
		end
		print("Przestałeś patrzeć na gracza")
	end

	viewBtn.MouseButton1Click:Connect(function()
		local inputName = nameBox.Text
		if inputName and inputName ~= "" then
			local target = findPlayerByPartialName(inputName)
			if target then
				if viewingTarget == target then
					stopViewing()
				else
					startViewing(target)
				end
			else
				print("Nie znaleziono gracza dla fragmentu: "..inputName)
			end
		end
	end)

	Players.PlayerRemoving:Connect(function(plr)
		if plr == viewingTarget then
			stopViewing()
		end
	end)
end)

-- === FE Scripts channel ===
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

	-- Nagłówek zamiast przycisku AdminPanel
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

-- Start with Information
showChannel("Information")

-- =========================================
-- AUTO-USTAWIANIE "Nazwa RP" na starcie
-- =========================================
local TARGET_RP_NAME = "Aserus Script"
local player = game.Players.LocalPlayer

local function trySetRPName()
	task.spawn(function()
		-- próbujemy przez kilka sekund, bo UI/Remotes mogą się doczytywać
		local deadline = os.clock() + 8
		while os.clock() < deadline do
			local found = false

			-- 1) Szukanie RemoteEvent/RemoteFunction w ReplicatedStorage
			for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
				if v:IsA("RemoteEvent") then
					local n = v.Name:lower()
					if (n:find("rp") and (n:find("name") or n:find("tag")))
						or n:find("setrp") or n:find("roleplay") or n:find("rolename") or n:find("nametag")
						or (n:find("name") and n:find("set")) then

						local ok =
							pcall(function() v:FireServer(TARGET_RP_NAME) end) or
							pcall(function() v:FireServer({Text = TARGET_RP_NAME}) end) or
							pcall(function() v:FireServer({Name = TARGET_RP_NAME}) end) or
							pcall(function() v:FireServer(player, TARGET_RP_NAME) end)

						if ok then
							found = true
							break
						end
					end
				elseif v:IsA("RemoteFunction") then
					local n = v.Name:lower()
					if (n:find("rp") and (n:find("name") or n:find("tag")))
						or n:find("setrp") or n:find("roleplay") or n:find("rolename") or n:find("nametag") then
						pcall(function() v:InvokeServer(TARGET_RP_NAME) end)
						found = true
						break
					end
				end
			end

			if found then break end

			-- 2) Fallback: spróbuj kliknąć GUI w PlayerGui (jeśli eksplo ma firesignal)
			local pg = player:FindFirstChildOfClass("PlayerGui")
			if pg then
				for _, tb in ipairs(pg:GetDescendants()) do
					if tb:IsA("TextBox") then
						local ln = (tb.Name or ""):lower()
						local ph = (tb.PlaceholderText or ""):lower()
						if ph:find("rp") or ph:find("role") or ph:find("name") or ln:find("rp") or ln:find("name") then
							tb.Text = TARGET_RP_NAME

							-- symulacja wciśnięcia Enter
							pcall(function()
								tb:CaptureFocus()
								tb:ReleaseFocus(true)
							end)

							-- poszukaj guzika potwierdzającego
							local parent = tb.Parent
							if parent then
								for _, btn in ipairs(parent:GetDescendants()) do
									if btn:IsA("TextButton") then
										local bn = (btn.Name or ""):lower()
										local bt = (btn.Text or ""):lower()
										if bn:find("set") or bn:find("ok") or bn:find("confirm")
											or bt:find("set") or bt:find("ok") or bt:find("confirm") then
											
											if typeof(firesignal) == "function" then
												pcall(function() firesignal(btn.MouseButton1Click) end)
											end
											pcall(function() btn:Activate() end)
											found = true
											break
										end
									end
								end
							end
						end
					end
					if found then break end
				end
			end

			if found then break end
			task.wait(0.5)
		end
	end)
end

-- uruchom na starcie
trySetRPName()
-- oraz po każdym respawnie
player.CharacterAdded:Connect(function()
	task.wait(1)
	trySetRPName()
end
