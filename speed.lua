local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Variáveis para o estado de voo
local flying = false
local flyPlatform = nil
local connection = nil
local FlySpeed = 60
local moveDirection = Vector3.zero

-- Função para criar GUI e configurar tudo
local function criarGUI()
    -- Remove GUI antiga se existir
    local oldGui = player.PlayerGui:FindFirstChild("SpeedFlyGui")
    if oldGui then
        oldGui:Destroy()
    end

    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Criar GUI
    local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
    ScreenGui.Name = "SpeedFlyGui"

    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 240, 0, 230)
    Frame.Position = UDim2.new(0.05, 0, 0.05, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel", Frame)
    Title.Text = "Velocidade + Voo"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18

    local TextBox = Instance.new("TextBox", Frame)
    TextBox.PlaceholderText = "Digite a velocidade (ex: 50)"
    TextBox.Text = ""
    TextBox.Size = UDim2.new(0.9, 0, 0, 30)
    TextBox.Position = UDim2.new(0.05, 0, 0, 40)
    TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 16

    local ApplySpeedButton = Instance.new("TextButton", Frame)
    ApplySpeedButton.Text = "Aplicar Velocidade"
    ApplySpeedButton.Size = UDim2.new(0.9, 0, 0, 30)
    ApplySpeedButton.Position = UDim2.new(0.05, 0, 0, 80)
    ApplySpeedButton.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
    ApplySpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ApplySpeedButton.Font = Enum.Font.SourceSansBold
    ApplySpeedButton.TextSize = 16

    local ResetSpeedButton = Instance.new("TextButton", Frame)
    ResetSpeedButton.Text = "Resetar Velocidade"
    ResetSpeedButton.Size = UDim2.new(0.9, 0, 0, 30)
    ResetSpeedButton.Position = UDim2.new(0.05, 0, 0, 120)
    ResetSpeedButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    ResetSpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ResetSpeedButton.Font = Enum.Font.SourceSansBold
    ResetSpeedButton.TextSize = 16

    local FlyButton = Instance.new("TextButton", Frame)
    FlyButton.Text = "Ativar Voo"
    FlyButton.Size = UDim2.new(0.9, 0, 0, 30)
    FlyButton.Position = UDim2.new(0.05, 0, 0, 160)
    FlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlyButton.Font = Enum.Font.SourceSansBold
    FlyButton.TextSize = 16

    local StatusLabel = Instance.new("TextLabel", Frame)
    StatusLabel.Size = UDim2.new(0.9, 0, 0, 25)
    StatusLabel.Position = UDim2.new(0.05, 0, 0, 200)
    StatusLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- vermelho = parado
    StatusLabel.Font = Enum.Font.SourceSansBold
    StatusLabel.TextSize = 18
    StatusLabel.Text = "Status: Parado"
    StatusLabel.TextStrokeTransparency = 0.7
    StatusLabel.TextScaled = true
    StatusLabel.TextWrapped = true
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Aplicar velocidade com feedback visual
    ApplySpeedButton.MouseButton1Click:Connect(function()
        local value = tonumber(TextBox.Text)
        if value and humanoid then
            humanoid.WalkSpeed = math.clamp(value, 1, 500)
            ApplySpeedButton.Text = "Velocidade aplicada: " .. humanoid.WalkSpeed
            delay(2, function()
                ApplySpeedButton.Text = "Aplicar Velocidade"
            end)
        else
            ApplySpeedButton.Text = "Valor inválido!"
            delay(2, function()
                ApplySpeedButton.Text = "Aplicar Velocidade"
            end)
        end
    end)

    -- Resetar velocidade
    ResetSpeedButton.MouseButton1Click:Connect(function()
        if humanoid then
            humanoid.WalkSpeed = 16
            ApplySpeedButton.Text = "Velocidade: 16"
            delay(2, function()
                ApplySpeedButton.Text = "Aplicar Velocidade"
            end)
        end
    end)

    -- Atualizar direção do movimento para voo
    local function updateDirection()
        local cam = workspace.CurrentCamera
        local dir = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            dir += cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            dir -= cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            dir -= cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            dir += cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            dir += Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            dir -= Vector3.new(0, 1, 0)
        end

        if dir.Magnitude > 0 then
            moveDirection = dir.Unit
        else
            moveDirection = Vector3.zero
        end
    end

    -- Funções para voo via plataforma
    local function startFlyingPlatform()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        flyPlatform = Instance.new("Part")
        flyPlatform.Size = Vector3.new(6, 0.5, 6)
        flyPlatform.Transparency = 1
        flyPlatform.Anchored = true
        flyPlatform.CanCollide = true
        flyPlatform.Name = "FlyPlatform"
        flyPlatform.Parent = workspace

        humanoid.PlatformStand = true

        connection = RunService.Heartbeat:Connect(function(dt)
            if not flying or not flyPlatform or not root then return end

            updateDirection()

            local newPos = flyPlatform.Position + moveDirection * FlySpeed * dt

            if moveDirection.Magnitude == 0 then
                newPos = root.Position - Vector3.new(0, 3, 0)
            end

            flyPlatform.Position = newPos

            root.CFrame = CFrame.new(flyPlatform.Position.X, flyPlatform.Position.Y + 3, flyPlatform.Position.Z)
        end)
    end

    local function stopFlyingPlatform()
        if flyPlatform then
            flyPlatform:Destroy()
            flyPlatform = nil
        end

        humanoid.PlatformStand = false

        if connection then
            connection:Disconnect()
            connection = nil
        end
    end

    FlyButton.MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            FlyButton.Text = "Desativar Voo"
            StatusLabel.Text = "Status: Voando"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            startFlyingPlatform()
        else
            FlyButton.Text = "Ativar Voo"
            StatusLabel.Text = "Status: Parado"
            StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            stopFlyingPlatform()
        end
    end)

    -- Retorna humanoid para conexões externas, se precisar
    return humanoid
end

-- Reconstruir GUI quando personagem nascer
player.CharacterAdded:Connect(function(char)
    flying = false
    if flyPlatform then
        flyPlatform:Destroy()
        flyPlatform = nil
    end
    criarGUI()
end)

-- Criar GUI inicial (caso personagem já exista)
if player.Character then
    criarGUI()
end
