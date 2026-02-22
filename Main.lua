-- OPWash Hub (FINAL STABLE)

-- ===== SERVICIOS =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- ===== NOTIFICACIÓN =====
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "OPWash",
		Text = "Cargado correctamente",
		Duration = 4
	})
end)

-- ===== LIMPIAR GUI =====
if CoreGui:FindFirstChild("OPWashHub") then
	CoreGui.OPWashHub:Destroy()
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "OPWashHub"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0.5, -150, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ===== BOTÓN JUMP =====
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

-- ===== BOTÓN NOCLIP =====
local btnNoclip = Instance.new("TextButton")
btnNoclip.Size = UDim2.new(1, -40, 0, 45)
btnNoclip.Position = UDim2.new(0, 20, 0, 80)
btnNoclip.Text = "Noclip: OFF"
btnNoclip.Font = Enum.Font.GothamBold
btnNoclip.TextSize = 18
btnNoclip.TextColor3 = Color3.new(1,1,1)
btnNoclip.BackgroundColor3 = Color3.fromRGB(70,70,70)
btnNoclip.Parent = frame
Instance.new("UICorner", btnNoclip).CornerRadius = UDim.new(0,8)

-- ===== VARIABLES =====
local jumpEnabled = false
local noclipEnabled = false
local humanoid, hrp
local JUMP_FORCE = 100
local NOCLIP_SPEED = 100
local noclipConn

-- ===== CHARACTER =====
local function onChar(char)
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end

if player.Character then onChar(player.Character) end
player.CharacterAdded:Connect(onChar)

-- ===== JUMP BOOST =====
local function updateJumpUI()
	btnJump.Text = jumpEnabled and "Jump Boost: ON" or "Jump Boost: OFF"
	btnJump.BackgroundColor3 = jumpEnabled and Color3.fromRGB(60,160,60) or Color3.fromRGB(70,70,70)
end

btnJump.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	updateJumpUI()
end)

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.V then
		jumpEnabled = not jumpEnabled
		updateJumpUI()
	end
end)

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if not jumpEnabled then return end
	if i.KeyCode ~= Enum.KeyCode.Space then return end
	if hrp then
		hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, JUMP_FORCE, hrp.AssemblyLinearVelocity.Z)
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
	if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
	if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

	if dir.Magnitude > 0 then
		hrp.CFrame += dir.Unit * NOCLIP_SPEED * dt
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

UIS.InputBegan:Connect(function(i,gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.N then
		toggleNoclip()
	end
end)

-- ===== DRAG =====
local drag, dragStart, startPos
frame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		drag = true
		dragStart = i.Position
		startPos = frame.Position
		i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then drag = false end
		end)
	end
end)

UIS.InputChanged:Connect(function(i)
	if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

-- ===== TOGGLE MENÚ (G) =====
local visible = true
CAS:BindAction("OPWashToggle", function(_,state)
	if state == Enum.UserInputState.Begin then
		visible = not visible
		gui.Enabled = visible
	end
end,false,Enum.KeyCode.G)
