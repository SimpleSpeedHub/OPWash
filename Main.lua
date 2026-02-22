-- OPWash Hub (executor compatible)

local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

-- Notificación de carga
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "OPWash",
        Text = "Cargado correctamente",
        Duration = 4
    })
end)

-- Evitar duplicados
if CoreGui:FindFirstChild("OPWashHub") then
    CoreGui.OPWashHub:Destroy()
end

-- Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OPWashHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Botón
local btnTest = Instance.new("TextButton")
btnTest.Size = UDim2.new(1, -40, 0, 50)
btnTest.Position = UDim2.new(0, 20, 0, 20)
btnTest.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnTest.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTest.Text = "¡Prueba OPWash!"
btnTest.Font = Enum.Font.SourceSansBold
btnTest.TextSize = 18
btnTest.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btnTest

btnTest.MouseButton1Click:Connect(function()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "OPWash",
            Text = "Botón presionado",
            Duration = 3
        })
    end)
end)
