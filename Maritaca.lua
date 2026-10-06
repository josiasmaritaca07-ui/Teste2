-- Maritaca Hub | GK - The Classic Soccer Edition
-- UI preta com botão flutuante e minimizar

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ==================== CONFIG ====================
local Config = {
    AutoDive = false,
    AutoCatch = false,
    Reach = 5,
    DiveDir = "Auto", -- Auto, LeftHigh, LeftLow, RightHigh, RightLow, Center
}

-- ==================== PARENT GUI ====================
local parentGui
pcall(function() parentGui = game:GetService("CoreGui") end)
if not parentGui then
    parentGui = LocalPlayer:WaitForChild("PlayerGui")
end

for _, gui in ipairs(parentGui:GetChildren()) do
    if gui.Name == "MaritacaHubUI" then gui:Destroy() end
end

-- ==================== UI PRINCIPAL ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MaritacaHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = parentGui

-- Painel principal (preto)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 460)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -230)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 80, 80)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 45)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "MARITACA HUB | GK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Botão minimizar
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -70, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 20
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinBtn

-- Botão fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 25, 25)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- Container
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -30, 1, -70)
Container.Position = UDim2.new(0, 15, 0, 55)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- Função botão
local function createButton(text, order, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, (order - 1) * 50)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.BorderSizePixel = 0
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamMedium
    btn.AutoButtonColor = false
    btn.Parent = parent or Container

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(70, 70, 70)
    s.Thickness = 1
    s.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end)
    return btn
end

local AutoDiveBtn = createButton("Auto Dive", 1)
local AutoCatchBtn = createButton("Auto Catch", 2)

-- Seletor de direção do dive
local DirLabel = Instance.new("TextLabel")
DirLabel.Size = UDim2.new(1, 0, 0, 22)
DirLabel.Position = UDim2.new(0, 0, 0, 105)
DirLabel.BackgroundTransparency = 1
DirLabel.Text = "Direção do Dive: Auto"
DirLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DirLabel.TextSize = 14
DirLabel.Font = Enum.Font.GothamMedium
DirLabel.TextXAlignment = Enum.TextXAlignment.Left
DirLabel.Parent = Container

local dirs = {"Auto", "LeftHigh", "LeftLow", "Center", "RightHigh", "RightLow"}
local DirIndex = 1

local DirBtn = createButton("Mudar Direção", 3)
DirBtn.Position = UDim2.new(0, 0, 0, 130)
DirBtn.Size = UDim2.new(1, 0, 0, 38)

DirBtn.MouseButton1Click:Connect(function()
    DirIndex = DirIndex + 1
    if DirIndex > #dirs then DirIndex = 1 end
    Config.DiveDir = dirs[DirIndex]
    DirLabel.Text = "Direção do Dive: " .. Config.DiveDir
end)

-- Label Reach
local ReachLabel = Instance.new("TextLabel")
ReachLabel.Size = UDim2.new(1, 0, 0, 22)
ReachLabel.Position = UDim2.new(0, 0, 0, 185)
ReachLabel.BackgroundTransparency = 1
ReachLabel.Text = "Reach (hitbox): 5"
ReachLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ReachLabel.TextSize = 14
ReachLabel.Font = Enum.Font.GothamMedium
ReachLabel.TextXAlignment = Enum.TextXAlignment.Left
ReachLabel.Parent = Container

-- Slider Reach
local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(1, 0, 0, 10)
SliderBG.Position = UDim2.new(0, 0, 0, 215)
SliderBG.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
SliderBG.BorderSizePixel = 0
SliderBG.Parent = Container

local SCorner = Instance.new("UICorner")
SCorner.CornerRadius = UDim.new(0, 5)
SCorner.Parent = SliderBG

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SFillCorner = Instance.new("UICorner")
SFillCorner.CornerRadius = UDim.new(0, 5)
SFillCorner.Parent = SliderFill

local SliderKnob = Instance.new("Frame")
SliderKnob.Size = UDim2.new(0, 18, 0, 18)
SliderKnob.Position = UDim2.new(0.5, -9, 0.5, -9)
SliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderKnob.BorderSizePixel = 0
SliderKnob.ZIndex = 2
SliderKnob.Parent = SliderBG

local SKnobCorner = Instance.new("UICorner")
SKnobCorner.CornerRadius = UDim.new(1, 0)
SKnobCorner.Parent = SliderKnob

local isDragging = false

local function updateSlider(x)
    local bgAbs = SliderBG.AbsolutePosition.X
    local bgSize = SliderBG.AbsoluteSize.X
    if bgSize <= 0 then return end
    local rel = math.clamp((x - bgAbs) / bgSize, 0, 1)
    local val = math.floor(rel * 9 + 1)
    Config.Reach = val
    local fill = (val - 1) / 9
    SliderFill.Size = UDim2.new(fill, 0, 1, 0)
    SliderKnob.Position = UDim2.new(fill, -9, 0.5, -9)
    ReachLabel.Text = "Reach (hitbox): " .. val
end

SliderBG.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        updateSlider(input.Position.X)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input.Position.X)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ==================== BOTÃO FLUTUANTE (minimizado) ====================
local FloatBtn = Instance.new("TextButton")
FloatBtn.Name = "FloatBtn"
FloatBtn.Size = UDim2.new(0, 55, 0, 55)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -27)
FloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FloatBtn.Text = "GK"
FloatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatBtn.TextSize = 18
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.BorderSizePixel = 0
FloatBtn.Visible = false
FloatBtn.Active = true
FloatBtn.Draggable = true
FloatBtn.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatBtn

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Thickness = 2
FloatStroke.Parent = FloatBtn

-- Para usar a foto no botão flutuante, descomente e coloque o ID:
-- local FloatImg = Instance.new("ImageLabel")
-- FloatImg.Size = UDim2.new(1, -6, 1, -6)
-- FloatImg.Position = UDim2.new(0, 3, 0, 3)
-- FloatImg.BackgroundTransparency = 1
-- FloatImg.Image = "rbxassetid://SEU_ID_AQUI"
-- FloatImg.Parent = FloatBtn
-- local FloatImgCorner = Instance.new("UICorner")
-- FloatImgCorner.CornerRadius = UDim.new(1, 0)
-- FloatImgCorner.Parent = FloatImg
-- FloatBtn.Text = "" -- esconde o texto "GK"

-- Minimizar / restaurar
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatBtn.Visible = true
end)

FloatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==================== BOTÕES ON/OFF ====================
local function updateButtonVisual(btn, state, name)
    if state then
        btn.Text = name .. ": ON"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    else
        btn.Text = name .. ": OFF"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
    end
end

AutoDiveBtn.MouseButton1Click:Connect(function()
    Config.AutoDive = not Config.AutoDive
    updateButtonVisual(AutoDiveBtn, Config.AutoDive, "Auto Dive")
end)

AutoCatchBtn.MouseButton1Click:Connect(function()
    Config.AutoCatch = not Config.AutoCatch
    updateButtonVisual(AutoCatchBtn, Config.AutoCatch, "Auto Catch")
end)

-- ==================== DETECÇÃO DE BOLA (Classic Soccer) ====================
local function getBall()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n == "ball" or n:find("soccerball") or n:find("bola") then
                return obj
            end
        end
    end
    return nil
end

local function getGoal()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local n = obj.Name:lower()
            if n:find("goal") or n:find("gol") then
                return obj
            end
        end
    end
    return nil
end

-- ==================== AUTO DIVE ====================
local lastDive = 0

local function autoDive()
    if not Config.AutoDive then return end
    if tick() - lastDive < 1.5 then return end

    local ball = getBall()
    if not ball then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not humanoid then return end

    local vel = ball.AssemblyLinearVelocity
    if vel.Magnitude < 5 then return end

    local dir = (ball.Position - hrp.Position)
    if dir.Magnitude > 60 then return end

    local diveDir = Config.DiveDir
    if diveDir == "Auto" then
        local localBall = hrp.CFrame:PointToObjectSpace(ball.Position)
        if localBall.X < -2 then
            diveDir = localBall.Y > 0 and "LeftHigh" or "LeftLow"
        elseif localBall.X > 2 then
            diveDir = localBall.Y > 0 and "RightHigh" or "RightLow"
        else
            diveDir = "Center"
        end
    end

    local impulse = Vector3.zero
    if diveDir == "LeftHigh" then
        impulse = Vector3.new(-40, 45, 0)
    elseif diveDir == "LeftLow" then
        impulse = Vector3.new(-45, 15, 0)
    elseif diveDir == "RightHigh" then
        impulse = Vector3.new(40, 45, 0)
    elseif diveDir == "RightLow" then
        impulse = Vector3.new(45, 15, 0)
    elseif diveDir == "Center" then
        impulse = Vector3.new(0, 50, 0)
    end

    local toBall = (ball.Position - hrp.Position).Unit
    impulse = Vector3.new(impulse.X, impulse.Y, toBall.Z * 30)

    hrp.AssemblyLinearVelocity = impulse
    lastDive = tick()
end

-- ==================== AUTO CATCH ====================
local function autoCatch()
    if not Config.AutoCatch then return end

    local ball = getBall()
    if not ball then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (ball.Position - hrp.Position).Magnitude
    if dist <= Config.Reach * 3 then
        ball.CFrame = hrp.CFrame * CFrame.new(0, -1, -2.5)
        ball.AssemblyLinearVelocity = Vector3.zero
        ball.AssemblyAngularVelocity = Vector3.zero
    end
end

-- ==================== REACH (HITBOX) ====================
local function applyReach()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetSize = Vector3.new(2 + Config.Reach * 0.5, 2 + Config.Reach * 0.5, 1 + Config.Reach * 0.3)
    if hrp.Size ~= targetSize then
        hrp.Size = targetSize
        hrp.Transparency = 0.7
        hrp.CanCollide = false
    end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
            local baseSize = Vector3.new(1, 1, 1)
            part.Size = baseSize * (1 + Config.Reach * 0.1)
        end
    end
end

-- ==================== LOOP ====================
RunService.Heartbeat:Connect(function()
    pcall(function() if Config.AutoDive then autoDive() end end)
    pcall(function() if Config.AutoCatch then autoCatch() end end)
    pcall(applyReach)
end)

print("[Maritaca Hub] GK Script - The Classic Soccer carregado!")
