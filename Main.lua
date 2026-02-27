-- OPWash Hub (FINAL FIXED VERSION)

-- ===== SERVICES =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- ===== NOTIFICATION =====
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "OPWash",
		Text = "Loaded successfully",
		Duration = 4
	})
end)

-- ===== CLEAN OLD GUI =====
if CoreGui:FindFirstChild("OPWashHub") then
	CoreGui.OPWashHub:Destroy()
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "OPWashHub"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 330)
frame.Position = UDim2.new(0.5, -160, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ===== JUMP BOOST BUTTON =====
local btnJump = Instance.new("TextButton")
btnJump.Size = UDim2.new(1, -40, 0, 45)
btnJump.Position = UDim2.new(0, 20, 0, 20)
btnJump.Text = "Jump Boost: OFF"
btnJump.Font = Enum.Font.GothamBold
btnJump.TextSize = 18
btnJump.TextColor3 = Color3.new(1,1,1)
btnJump.BackgroundColor3 = Color3.fromRGB(70,70,70)
btnJump.Parent = frame
Instance.new("UICorner", btnJump).CornerRadius = UDim.new(0,8)

-- Jump info
local jumpInfo = Instance.new("TextLabel")
jumpInfo.Size = UDim2.new(1, -40, 0, 30)
jumpInfo.Position = UDim2.new(0, 20, 0, 70)
jumpInfo.BackgroundTransparency = 1
jumpInfo.Text = "Jump Boost ON / OFF | Key: V"
jumpInfo.TextColor3 = Color3.fromRGB(180,180,180)
jumpInfo.Font = Enum.Font.Gotham
jumpInfo.TextSize = 14
jumpInfo.TextWrapped = true
jumpInfo.Parent = frame

-- ===== NOCLIP BUTTON =====
local btnNoclip = Instance.new("TextButton")
btnNoclip.Size = UDim2.new(1, -40, 0, 45)
btnNoclip.Position = UDim2.new(0, 20, 0, 110)
btnNoclip.Text = "Noclip: OFF"
btnNoclip.Font = Enum.Font.GothamBold
btnNoclip.TextSize = 18
btnNoclip.TextColor3 = Color3.new(1,1,1)
btnNoclip.BackgroundColor3 = Color3.fromRGB(70,70,70)
btnNoclip.Parent = frame
Instance.new("UICorner", btnNoclip).CornerRadius = UDim.new(0,8)

-- Noclip info
local noclipInfo = Instance.new("TextLabel")
noclipInfo.Size = UDim2.new(1, -40, 0, 50)
noclipInfo.Position = UDim2.new(0, 20, 0, 160)
noclipInfo.BackgroundTransparency = 1
noclipInfo.Text = "Noclip ON / OFF | Key: N\nMove: WASD | Up: E | Down: Q"
noclipInfo.TextColor3 = Color3.fromRGB(180,180,180)
noclipInfo.Font = Enum.Font.Gotham
noclipInfo.TextSize = 14
noclipInfo.TextWrapped = true
noclipInfo.Parent = frame

-- ===== VARIABLES =====
local jumpEnabled = false
local noclipEnabled = false
local humanoid, hrp

local JUMP_FORCE = 100
local NOCLIP_SPEED = 100
local noclipConn

-- ===== CHARACTER =====
local function onCharacter(char)
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end

if player.Character then
	onCharacter(player.Character)
end
player.CharacterAdded:Connect(onCharacter)

-- ===== JUMP BOOST =====
local function updateJumpUI()
	btnJump.Text = jumpEnabled and "Jump Boost: ON" or "Jump Boost: OFF"
	btnJump.BackgroundColor3 = jumpEnabled and Color3.fromRGB(60,160,60) or Color3.fromRGB(70,70,70)
end

btnJump.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	updateJumpUI()
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.V then
		jumpEnabled = not jumpEnabled
		updateJumpUI()
	end
end)

UIS.InputBegan:Connect(function(input, gp)
	if gp or not jumpEnabled or not hrp then return end
	if input.KeyCode == Enum.KeyCode.Space then
		hrp.AssemblyLinearVelocity = Vector3.new(
			hrp.AssemblyLinearVelocity.X,
			JUMP_FORCE,
			hrp.AssemblyLinearVelocity.Z
		)
	end
end)

-- ===== NOCLIP =====
local function setCollision(state)
	if not player.Character then return end
	for _,v in pairs(player.Character:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = state
		end
	end
end

local function noclipStep(dt)
	if not hrp then return end
	setCollision(false)

	local cam = workspace.CurrentCamera
	if not cam then return end

	local dir = Vector3.zero
	if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
	if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
	if UIS:IsKeyDown(Enum.KeyCode.E) then dir += Vector3.new(0,1,0) end
	if UIS:IsKeyDown(Enum.KeyCode.Q) then dir -= Vector3.new(0,1,0) end

	if dir.Magnitude > 0 then
		hrp.CFrame = hrp.CFrame + dir.Unit * NOCLIP_SPEED * dt
	end
end

local function updateNoclipUI()
	btnNoclip.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
	btnNoclip.BackgroundColor3 = noclipEnabled and Color3.fromRGB(160,60,60) or Color3.fromRGB(70,70,70)
end

local function toggleNoclip()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		noclipConn = RunService.Heartbeat:Connect(noclipStep)
	else
		if noclipConn then noclipConn:Disconnect() end
		setCollision(true)
	end
	updateNoclipUI()
end

btnNoclip.MouseButton1Click:Connect(toggleNoclip)

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.N then
		toggleNoclip()
	end
end)

-- ===== DRAG =====
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
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

-- ===== TOGGLE GUI (G) =====
local visible = true
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		visible = not visible
		gui.Enabled = visible
	end
end)
