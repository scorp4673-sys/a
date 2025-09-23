-- Serviços
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Variáveis do personagem
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedFlyFreecamGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 260)
Frame.Position = UDim2.new(0.05, 0, 0.05, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Speed, Fly & Freecam"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Abas
local Tabs = Instance.new("Frame", Frame)
Tabs.Size = UDim2.new(1, 0, 0, 30)
Tabs.Position = UDim2.new(0, 0, 0, 30)
Tabs.BackgroundTransparency = 1

local function createTabButton(text, posX)
    local btn = Instance.new("TextButton", Tabs)
    btn.Text = text
    btn.Size = UDim2.new(0, 95, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    return btn
end

local speedTabBtn = createTabButton("Velocidade", 0)
local flyTabBtn = createTabButton("Voo", 100)
local freecamTabBtn = createTabButton("Freecam", 200)

-- Frames para abas
local speedFrame = Instance.new("Frame", Frame)
speedFrame.Size = UDim2.new(1, 0, 1, -60)
speedFrame.Position = UDim2.new(0, 0, 0, 60)
speedFrame.BackgroundTransparency = 1

local flyFrame = speedFrame:Clone()
flyFrame.Parent = Frame
flyFrame.Visible = false

local freecamFrame = speedFrame:Clone()
freecamFrame.Parent = Frame
freecamFrame.Visible = false

-- Função para trocar abas
local function switchTab(selected)
    speedFrame.Visible = (selected == "speed")
    flyFrame.Visible = (selected == "fly")
    freecamFrame.Visible = (selected == "freecam")

    speedTabBtn.BackgroundColor3 = selected == "speed" and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(70, 70, 70)
    flyTabBtn.BackgroundColor3 = selected == "fly" and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(70, 70, 70)
    freecamTabBtn.BackgroundColor3 = selected == "freecam" and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(70, 70, 70)
end

speedTabBtn.MouseButton1Click:Connect(function() switchTab("speed") end)
flyTabBtn.MouseButton1Click:Connect(function() switchTab("fly") end)
freecamTabBtn.MouseButton1Click:Connect(function() switchTab("freecam") end)

switchTab("speed") -- Aba inicial

-- --- Aba Velocidade ---
local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Text = "Defina a velocidade do personagem:"
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.TextSize = 16

local speedInput = Instance.new("TextBox", speedFrame)
speedInput.PlaceholderText = "Ex: 50"
speedInput.Size = UDim2.new(0.9, 0, 0, 30)
speedInput.Position = UDim2.new(0.05, 0, 0, 30)
speedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Font = Enum.Font.SourceSans
speedInput.TextSize = 16

local applySpeedBtn = Instance.new("TextButton", speedFrame)
applySpeedBtn.Text = "Aplicar Velocidade"
applySpeedBtn.Size = UDim2.new(0.9, 0, 0, 30)
applySpeedBtn.Position = UDim2.new(0.05, 0, 0, 70)
applySpeedBtn.BackgroundColor3 = Color3.fromRGB(30, 150, 30)
applySpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
applySpeedBtn.Font = Enum.Font.SourceSansBold
applySpeedBtn.TextSize = 16

local resetSpeedBtn = Instance.new("TextButton", speedFrame)
resetSpeedBtn.Text = "Resetar Velocidade"
resetSpeedBtn.Size = UDim2.new(0.9, 0, 0, 30)
resetSpeedBtn.Position = UDim2.new(0.05, 0, 0, 110)
resetSpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
resetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetSpeedBtn.Font = Enum.Font.SourceSansBold
resetSpeedBtn.TextSize = 16

local speedFeedback = Instance.new("TextLabel", speedFrame)
speedFeedback.Text = ""
speedFeedback.Size = UDim2.new(1, 0, 0, 25)
speedFeedback.Position = UDim2.new(0, 0, 0, 150)
speedFeedback.BackgroundTransparency = 1
speedFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
speedFeedback.Font = Enum.Font.SourceSansItalic
speedFeedback.TextSize = 14

applySpeedBtn.MouseButton1Click:Connect(function()
    local val = tonumber(speedInput.Text)
    if val and humanoid then
        humanoid.WalkSpeed = math.clamp(val, 1, 500)
        speedFeedback.Text = "Velocidade aplicada: " .. humanoid.WalkSpeed
        speedFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
    else
        speedFeedback.Text = "Valor inválido!"
        speedFeedback.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

resetSpeedBtn.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = 16
        speedFeedback.Text = "Velocidade resetada para 16"
        speedFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
    end
end)

-- --- Aba Voo ---
local flyBtn = Instance.new("TextButton", flyFrame)
flyBtn.Text = "Ativar Voo"
flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
flyBtn.Position = UDim2.new(0.05, 0, 0, 20)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 18

local flySpeedLabel = Instance.new("TextLabel", flyFrame)
flySpeedLabel.Text = "Velocidade do voo:"
flySpeedLabel.Size = UDim2.new(1, 0, 0, 25)
flySpeedLabel.Position = UDim2.new(0, 0, 0, 70)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.Font = Enum.Font.SourceSans
flySpeedLabel.TextSize = 16

local flySpeedInput = Instance.new("TextBox", flyFrame)
flySpeedInput.PlaceholderText = "Ex: 60"
flySpeedInput.Size = UDim2.new(0.9, 0, 0, 30)
flySpeedInput.Position = UDim2.new(0.05, 0, 0, 100)
flySpeedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flySpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedInput.Font = Enum.Font.SourceSans
flySpeedInput.TextSize = 16
flySpeedInput.Text = "60"

local flyFeedback = Instance.new("TextLabel", flyFrame)
flyFeedback.Text = ""
flyFeedback.Size = UDim2.new(1, 0, 0, 25)
flyFeedback.Position = UDim2.new(0, 0, 0, 140)
flyFeedback.BackgroundTransparency = 1
flyFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
flyFeedback.Font = Enum.Font.SourceSansItalic
flyFeedback.TextSize = 14

-- Voo lógica
local flying = false
local moveDirection = Vector3.zero
local bv, bg, bf
local flyConnection

local function updateFlyDirection()
    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

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
        dir += Vector3.new(0,1,0)
    end
    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
        dir -= Vector3.new(0,1,0)
    end

    moveDirection = dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

local function startFlying()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local speed = tonumber(flySpeedInput.Text) or 60

    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.new(0,0,0)
    bv.Parent = root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.P = 10000
    bg.CFrame = root.CFrame
    bg.Parent = root

    bf = Instance.new("BodyForce")
    bf.Force = Vector3.new(0, workspace.Gravity * root:GetMass(), 0)
    bf.Parent = root

    humanoid.PlatformStand = true

    flyConnection = RunService.Heartbeat:Connect(function()
        if not flying then return end
        updateFlyDirection()
        if moveDirection.Magnitude > 0 then
            bv.Velocity = moveDirection * speed
            bg.CFrame = workspace.CurrentCamera.CFrame
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
    end)

    flyFeedback.Text = "Voo ativado!"
    flyFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
end

local function stopFlying()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
        if bf then bf:Destroy() end
    end
    humanoid.PlatformStand = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    moveDirection = Vector3.zero
    flyFeedback.Text = "Voo desativado."
    flyFeedback.TextColor3 = Color3.fromRGB(255, 0, 0)
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        -- Se freecam estiver ativo, desativa para evitar conflito
        if freecamActive then
            stopFreecam()
        end
        flyBtn.Text = "Desativar Voo"
        startFlying()
        -- Deixar personagem invisível e sem colisão para não interferir
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Transparency = 0.5
                end
            end
        end
    else
        flyBtn.Text = "Ativar Voo"
        stopFlying()
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end
end)

-- --- Aba Freecam ---
local freecamBtn = Instance.new("TextButton", freecamFrame)
freecamBtn.Text = "Ativar Freecam"
freecamBtn.Size = UDim2.new(0.9, 0, 0, 40)
freecamBtn.Position = UDim2.new(0.05, 0, 0, 20)
freecamBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 180)
freecamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
freecamBtn.Font = Enum.Font.SourceSansBold
freecamBtn.TextSize = 18

local freecamSpeedLabel = Instance.new("TextLabel", freecamFrame)
freecamSpeedLabel.Text = "Velocidade da Freecam:"
freecamSpeedLabel.Size = UDim2.new(1, 0, 0, 25)
freecamSpeedLabel.Position = UDim2.new(0, 0, 0, 70)
freecamSpeedLabel.BackgroundTransparency = 1
freecamSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
freecamSpeedLabel.Font = Enum.Font.SourceSans
freecamSpeedLabel.TextSize = 16

local freecamSpeedInput = Instance.new("TextBox", freecamFrame)
freecamSpeedInput.PlaceholderText = "Ex: 50"
freecamSpeedInput.Size = UDim2.new(0.9, 0, 0, 30)
freecamSpeedInput.Position = UDim2.new(0.05, 0, 0, 100)
freecamSpeedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
freecamSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
freecamSpeedInput.Font = Enum.Font.SourceSans
freecamSpeedInput.TextSize = 16
freecamSpeedInput.Text = "50"

local freecamFeedback = Instance.new("TextLabel", freecamFrame)
freecamFeedback.Text = ""
freecamFeedback.Size = UDim2.new(1, 0, 0, 25)
freecamFeedback.Position = UDim2.new(0, 0, 0, 140)
freecamFeedback.BackgroundTransparency = 1
freecamFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
freecamFeedback.Font = Enum.Font.SourceSansItalic
freecamFeedback.TextSize = 14

-- Freecam lógica
local freecamActive = false
local freecamPos = Vector3.new()
local yaw = 0
local pitch = 0
local freecamConnection

local function startFreecam()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    freecamPos = root.Position
    yaw = 0
    pitch = 0

    humanoid.PlatformStand = true
    -- Personagem invisível e sem colisão
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5
            end
        end
    end

    freecamConnection = RunService.RenderStepped:Connect(function()
        if not freecamActive then return end

        local delta = Vector3.new()
        local cam = Camera
        local speed = tonumber(freecamSpeedInput.Text) or 50

        if UIS:IsKeyDown(Enum.KeyCode.W) then delta = delta + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then delta = delta - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then delta = delta - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then delta = delta + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then delta = delta + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then delta = delta - Vector3.new(0,1,0) end

        if delta.Magnitude > 0 then
            freecamPos = freecamPos + delta.Unit * speed
        end

        local mouseDelta = UIS:GetMouseDelta()
        local sensitivity = 0.002

        yaw = yaw - mouseDelta.X * sensitivity
        pitch = math.clamp(pitch - mouseDelta.Y * sensitivity, -math.pi/2, math.pi/2)

        local camCFrame = CFrame.new(freecamPos) * CFrame.Angles(pitch, yaw, 0)
        Camera.CFrame = camCFrame
    end)

    freecamFeedback.Text = "Freecam ativada!"
    freecamFeedback.TextColor3 = Color3.fromRGB(0, 255, 0)
end

local function stopFreecam()
    if freecamConnection then
        freecamConnection:Disconnect()
        freecamConnection = nil
    end
    humanoid.PlatformStand = false
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                part.Transparency = 0
            end
        end
    end
    freecamActive = false
    freecamFeedback.Text = "Freecam desativada."
    freecamFeedback.TextColor3 = Color3.fromRGB(255, 0, 0)
    -- Resetar câmera para personagem
    if character and character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraSubject = humanoid
    end
end

freecamBtn.MouseButton1Click:Connect(function()
    freecamActive = not freecamActive
    if freecamActive then
        -- Se voo estiver ativo, desativa para evitar conflito
        if flying then
            flying = false
            flyBtn.Text = "Ativar Voo"
            stopFlying()
        end
        freecamBtn.Text = "Desativar Freecam"
        startFreecam()
    else
        freecamBtn.Text = "Ativar Freecam"
        stopFreecam()
    end
end)

-- Atualizar humanoid após respawn para manter referência
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    -- Se estiver voando ou freecam, manter estado (opcional)
end)
