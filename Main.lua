game.StarterGui:SetCore("SendNotification", {
    Title = "OPWash",
    Text = "Cargado correctamente",
    Duration = 5
})

-- Crear la GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "OPWashHub"
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Crear un botón
local btnTest = Instance.new("TextButton")
btnTest.Size = UDim2.new(0, 200, 0, 50)
btnTest.Position = UDim2.new(0.5, -100, 0, 20)
btnTest.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
btnTest.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTest.Text = "¡Prueba OPWash!"
btnTest.Parent = mainFrame

-- Acción del botón
btnTest.MouseButton1Click:Connect(function()
    print("Botón OPWash presionado")
end)
