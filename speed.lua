-- Criar a GUI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local ButtonAumentar = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local TextBoxVelocidade = Instance.new("TextBox")
local UIS = game:GetService("UserInputService")

-- Parent da GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "SpeedGui"

-- Frame principal
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Position = UDim2.new(0.1, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Label de título
TextLabel.Parent = Frame
TextLabel.Text = "Velocidade: 16"
TextLabel.Size = UDim2.new(1, -30, 0, 30)
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0, 5, 0, 0)
TextLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Botão Aumentar Velocidade
ButtonAumentar.Parent = Frame
ButtonAumentar.Position = UDim2.new(0.05, 0, 0.35, 0)
ButtonAumentar.Size = UDim2.new(0.9, 0, 0.25, 0)
ButtonAumentar.Text = "Aumentar Velocidade"
ButtonAumentar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ButtonAumentar.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Caixa de Texto para digitar velocidade
TextBoxVelocidade.Parent = Frame
TextBoxVelocidade.Position = UDim2.new(0.05, 0, 0.65, 0)
TextBoxVelocidade.Size = UDim2.new(0.9, 0, 0.2, 0)
TextBoxVelocidade.PlaceholderText = "Digite a velocidade"
TextBoxVelocidade.Text = ""
TextBoxVelocidade.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TextBoxVelocidade.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Botão de Minimizar
MinimizeButton.Parent = Frame
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(1, -28, 0, 3)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Variáveis
local velocidade = 16
local player = game.Players.LocalPlayer
local humanoide = player.Character and player.Character:FindFirstChildOfClass("Humanoid")

-- Atualizar humanoide se o personagem for resetado
player.CharacterAdded:Connect(function(char)
    humanoide = char:WaitForChild("Humanoid")
    humanoide.WalkSpeed = velocidade
end)

-- Lógica de aumento de velocidade
ButtonAumentar.MouseButton1Click:Connect(function()
    if not humanoide then return end
    velocidade = velocidade + 5
    if velocidade > 100 then
        velocidade = 16
    end
    humanoide.WalkSpeed = velocidade
    TextLabel.Text = "Velocidade: " .. velocidade
end)

-- Lógica do campo de texto
TextBoxVelocidade.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(TextBoxVelocidade.Text)
        if value and humanoide then
            velocidade = math.clamp(value, 1, 500)
            humanoide.WalkSpeed = velocidade
            TextLabel.Text = "Velocidade: " .. velocidade
        else
            TextBoxVelocidade.Text = ""
            TextBoxVelocidade.PlaceholderText = "Valor inválido!"
        end
    end
end)

-- Minimizar/restaurar
local minimizado = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    if minimizado then
        ButtonAumentar.Visible = false
        TextBoxVelocidade.Visible = false
        Frame.Size = UDim2.new(0, 220, 0, 35)
        MinimizeButton.Text = "+"
    else
        ButtonAumentar.Visible = true
        TextBoxVelocidade.Visible = true
        Frame.Size = UDim2.new(0, 220, 0, 180)
        MinimizeButton.Text = "-"
    end
end)
