-- OPWash Hub (FINAL + Jump Boost)

-- ===== SERVICIOS =====
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")
local CAS = game:GetService("ContextActionService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ===== NOTIFICACIÓN DE CARGA =====
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "OPWash",
		Text = "Cargado correctamente",
		Duration = 4
	})
end)

-- ===== EVITAR DUPLICADOS =====
if CoreGui:FindFirstChild("OPWashHub") then
	CoreGui.OPWashHub:Destroy()
end

-- ===== CREAR GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OPWashHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui
screenGui.Enabled = true

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- ===== BOTÓN JUMP BOOST =====
local btnJump = Instance.new("TextButton")
btnJump.Size = UDim2.new(1, -40, 0, 50)
btnJump.Position = UDim2.new(0, 20, 0, 20)
btnJump.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnJump.TextColor3 = Color3.fromRGB(255, 255, 255)
btnJump.Text = "Jump Boost: OFF"
btnJump.Font = Enum.Font.SourceSansBold
btnJump.TextSize = 18
btnJump.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btnJump

-- ===== JUMP BOOST LÓGICA =====
local jumpEnabled = false
local humanoid, hrp
local JUMP_FORCE = 100

local function onCharacter(char)
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
end

if player.Character then
	onCharacter(player.Character)
end
player.CharacterAdded:Connect(onCharacter)

-- Salto forzado
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if not jumpEnabled then return end
	if input.KeyCode ~= Enum.KeyCode.Space then return end
	if not humanoid or not hrp then return end

	hrp.AssemblyLinearVelocity = Vector3.new(
		hrp.AssemblyLinearVelocity.X,
		JUMP_FORCE,
		hrp.AssemblyLinearVelocity.Z
	)
end)

-- ===== BOTÓN ON / OFF =====
local function updateButton()
	if jumpEnabled then
		btnJump.Text = "Jump Boost: ON"
		btnJump.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
	else
		btnJump.Text = "Jump Boost: OFF"
		btnJump.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	end
end

btnJump.MouseButton1Click:Connect(function()
	jumpEnabled = not jumpEnabled
	updateButton()
end)

-- ===== TECLA V (TOGGLE JUMP) =====
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.V then
		jumpEnabled = not jumpEnabled
		updateButton()
	end
end)

-- ===== MENÚ ARRASTRABLE =====
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
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

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- ===== OCULTAR / MOSTRAR CON G =====
local visible = true

local function toggleMenu(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		visible = not visible
		screenGui.Enabled = visible
	end
end

CAS:BindAction(
	"OPWashToggle",
	toggleMenu,
	false,
	Enum.KeyCode.G
)
