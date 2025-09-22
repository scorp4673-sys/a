-- GUI com velocidade + voo + reset
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "SpeedFlyGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 220)
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

-- Atualizar humanoid após respawn
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
end)

-- Aplicar velocidade
ApplySpeedButton.MouseButton1Click:Connect(function()
	local value = tonumber(TextBox.Text)
	if value and humanoid then
		humanoid.WalkSpeed = math.clamp(value, 1, 500)
		ApplySpeedButton.Text = "Velocidade: " .. humanoid.WalkSpeed
	else
		ApplySpeedButton.Text = "Valor inválido!"
	end
end)

-- Resetar velocidade
ResetSpeedButton.MouseButton1Click:Connect(function()
	if humanoid then
		humanoid.WalkSpeed = 16
		ApplySpeedButton.Text = "Velocidade: 16"
	end
end)

-- Sistema de voo
local flying = false
local FlySpeed = 60
local connection = nil

local function startFlying()
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.new(0, 0, 0)
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Name = "FlyVelocity"
	bv.Parent = root

	local bg = Instance.new("BodyGyro")
	bg.CFrame = root.CFrame
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.Name = "FlyGyro"
	bg.P = 10000
	bg.Parent = root

	connection = game:GetService("RunService").RenderStepped:Connect(function()
		if not flying then
			if bv then bv:Destroy() end
			if bg then bg:Destroy() end
			if connection then connection:Disconnect() end
			return
		end

		local cam = workspace.CurrentCamera
		bv.Velocity = cam.CFrame.LookVector * FlySpeed
		bg.CFrame = cam.CFrame
	end)
end

-- Botão de voo
FlyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		FlyButton.Text = "Desativar Voo"
		startFlying()
	else
		FlyButton.Text = "Ativar Voo"
	end
end)
