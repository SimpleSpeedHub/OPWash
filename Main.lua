-- OPWash Hub (WORKING FINAL FIX)

-- ===== SERVICIOS =====
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- ===== NOTIFICACIÓN =====
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "OPWash",
		Text = "Cargado correctamente",
		Duration = 3
	})
end)

-- ===== EVITAR DUPLICADOS =====
if PlayerGui:FindFirstChild("OPWashHub") then
	PlayerGui.OPWashHub:Destroy()
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "OPWashHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- ===== BOTÓN =====
local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -40, 0, 50)
button.Position = UDim2.new(0, 20, 0, 20)
button.Text = "Jump Boost: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.new(1,1,1)
button.BackgroundColor3 = Color3.fromRGB(70,70,70)
button.Parent = frame

Instance.new("UICorner", button).CornerRadius = UDim.new(0,8)

-- ===== JUMP BOOST =====
local enabled = false
local humanoid, hrp
local JUMP_FORCE = 90

local function updateButton()
	if enabled then
		button.Text = "Jump Boost: ON"
		button.BackgroundColor3 = Color3.fromRGB(60,160,60)
	else
		button.Text = "Jump Boost: OFF"
		button.BackgroundColor3 = Color3.fromRGB(70,70,70)
	end
end

local function onCharacter(char)
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end

if player.Character then onCharacter(player.Character) end
player.CharacterAdded:Connect(onCharacter)

-- FORZAR SALTO (FUNCIONA EN JUEGOS QUE BLOQUEAN)
UIS.InputBegan:Connect(function(input, gp)
	if gp or not enabled then return end
	if input.KeyCode ~= Enum.KeyCode.Space then return end
	if not humanoid or not hrp then return end

	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	hrp.Velocity = Vector3.new(hrp.Velocity.X, JUMP_FORCE, hrp.Velocity.Z)
end)

-- BOTÓN
button.MouseButton1Click:Connect(function()
	enabled = not enabled
	updateButton()
end)

-- TECLA V
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.V then
		enabled = not enabled
		updateButton()
	end
end)

-- ===== MOVER MENÚ =====
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
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

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- ===== OCULTAR / MOSTRAR CON G =====
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		gui.Enabled = not gui.Enabled
	end
end)

updateButton()
