local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ArdeluxGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,6)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(35,35,35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1,-60,1,0)
titleText.Position = UDim2.new(0,5,0,0)
titleText.BackgroundTransparency = 1
titleText.Text = "Aserus | Brookhaven RP Script | Console Script"
titleText.TextColor3 = Color3.fromRGB(255,255,255)
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14
titleText.Parent = titleBar

-- Minimize & close
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0,25,0,25)
minimizeBtn.Position = UDim2.new(1,-55,0,2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-25,0,2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

-- Panels
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.3,0,1,-30)
leftPanel.Position = UDim2.new(0,0,0,30)
leftPanel.BackgroundColor3 = Color3.fromRGB(40,40,40)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0,6)
local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,5)
uiList.Parent = leftPanel

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.7,0,1,-30)
rightPanel.Position = UDim2.new(0.3,0,0,30)
rightPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0,6)

-- Minimize logic
local minimized = false
local originalSize = mainFrame.Size
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		leftPanel.Visible = false
		rightPanel.Visible = false
		mainFrame:TweenSize(UDim2.new(originalSize.X.Scale,originalSize.X.Offset,0,30),"Out","Quad",0.3,true)
	else
		mainFrame:TweenSize(originalSize,"Out","Quad",0.3,true,function()
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
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	end
end)

-- Channels system
local channels = {}
local function showChannel(name)
	for _, child in pairs(rightPanel:GetChildren()) do
		if not child:IsA("UICorner") then
			child:Destroy()
		end
	end
	if channels[name] then
		channels[name]()
	end
end

local function addChannel(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,30)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	btn.Parent = leftPanel
	channels[name] = callback
	btn.MouseButton1Click:Connect(function()
		showChannel(name)
	end)
end

-- Information channel
addChannel("Information", function()
	local infoBox = Instance.new("Frame")
	infoBox.Size = UDim2.new(1,-20,0,220)
	infoBox.Position = UDim2.new(0,10,0,10)
	infoBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
	infoBox.BorderSizePixel = 0
	infoBox.Parent = rightPanel
	Instance.new("UICorner", infoBox).CornerRadius = UDim.new(0,12)

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

	local description = Instance.new("TextLabel")
	description.Size = UDim2.new(1,-20,0,80)
	description.Position = UDim2.new(0,10,0,50)
	description.BackgroundTransparency = 1
	description.Text = "This script is still in development (beta).\n\nIf you want to help or share ideas, contact me on Discord: kyllersv_"
	description.TextColor3 = Color3.fromRGB(255,255,255)
	description.TextWrapped = true
	description.Font = Enum.Font.Gotham
	description.TextSize = 14
	description.TextXAlignment = Enum.TextXAlignment.Left
	description.TextYAlignment = Enum.TextYAlignment.Top
	description.Parent = infoBox
end)

-- Fun channel (Speed & Jump)
addChannel("Fun", function()
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,-20,1,-20)
	container.Position = UDim2.new(0,10,0,10)
	container.BackgroundTransparency = 1
	container.Parent = rightPanel
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,15)
	layout.Parent = container

	local function createSlider(name, minVal, maxVal, defaultVal, callback)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1,0,0,60)
		frame.BackgroundTransparency = 1
		frame.Parent = container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,0,20)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255,255,255)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = name.." | "..defaultVal
		label.Parent = frame

		local sliderFrame = Instance.new("Frame")
		sliderFrame.Size = UDim2.new(1,0,0,20)
		sliderFrame.Position = UDim2.new(0,0,0,35)
		sliderFrame.BackgroundColor3 = Color3.fromRGB(70,70,70)
		sliderFrame.BorderSizePixel = 0
		sliderFrame.Parent = frame
		Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0,10)

		local sliderFill = Instance.new("Frame")
		sliderFill.Size = UDim2.new(0,0,1,0)
		sliderFill.BackgroundColor3 = Color3.fromRGB(255,215,0)
		sliderFill.BorderSizePixel = 0
		sliderFill.Parent = sliderFrame
		Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0,10)

		local function updateSlider(posX)
			local relative = math.clamp(posX / sliderFrame.AbsoluteSize.X, 0, 1)
			local value = math.floor(defaultVal + (maxVal - defaultVal) * relative)
			sliderFill.Size = UDim2.new(relative, 0, 1, 0)
			label.Text = name.." | "..value
			callback(value)
		end

		sliderFrame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				updateSlider(input.Position.X - sliderFrame.AbsolutePosition.X)

				local moveConn
				moveConn = game:GetService("UserInputService").InputChanged:Connect(function(moveInput)
					if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
						updateSlider(moveInput.Position.X - sliderFrame.AbsolutePosition.X)
					end
				end)

				local endConn
				endConn = game:GetService("UserInputService").InputEnded:Connect(function(endInput)
					if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
						moveConn:Disconnect()
						endConn:Disconnect()
					end
				end)
			end
		end)

		-- ustawienie początkowe
		sliderFill.Size = UDim2.new(0,0,1,0)
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

-- FE Scripts channel
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

    local function createButton(name,func)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,40)
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Text = name
        btn.BorderSizePixel = 0
        btn.Parent = container
        btn.MouseButton1Click:Connect(func)
    end

    createButton("Infinite Yield (All Games)", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end)

-- Start with Information
showChannel("Information")
