-- Character Resizer GUI (Xeno Compatible)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Xeno-compatible GUI parent
local guiParent = (typeof(gethui) == "function" and gethui())-- Character Resizer GUI (Xeno Compatible)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Xeno-compatible GUI parent
local guiParent = (typeof(gethui) == "function" and gethui())
    or (pcall(game.GetService, game, "CoreGui") and game:GetService("CoreGui"))
    or player:WaitForChild("PlayerGui")

-- Destroy old GUI if it exists
local old = guiParent:FindFirstChild("CharacterResizerGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CharacterResizerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0.5, -120, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- Custom drag via UserInputService (no deprecated Draggable)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 200, 120)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.Parent = frame

-- Title bar gradient
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 180, 90)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = Color3.fromRGB(20, 180, 90)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 200, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 160, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 220))
})
gradient.Parent = titleBar

local gradientFix = gradient:Clone()
gradientFix.Parent = titleFix

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Character Resizer"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = titleBar

-- Scale display
local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(1, 0, 0, 34)
scaleLabel.Position = UDim2.new(0, 0, 0, 50)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Text = "Scale: 1x"
scaleLabel.TextColor3 = Color3.fromRGB(40, 200, 120)
scaleLabel.Font = Enum.Font.GothamBold
scaleLabel.TextSize = 18
scaleLabel.Parent = frame

local currentScale = 1

local function resizeCharacter(scale)
    local character = player.Character
    if not character then return end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * (scale / currentScale)
        end
    end
    currentScale = scale
    scaleLabel.Text = "Scale: " .. tostring(scale) .. "x"
    pcall(function()
        scaleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(scaleLabel, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(40, 200, 120)}):Play()
    end)
end

local function makeButton(text, yPos, color1, color2, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.82, 0, 0, 38)
    btn.Position = UDim2.new(0.09, 0, 0, yPos)
    btn.BackgroundColor3 = color1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new(color1, color2)
    btnGrad.Rotation = 90
    btnGrad.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = color1
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn

    pcall(function()
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.86, 0, 0, 40)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.82, 0, 0, 38)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
        end)
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeButton("Grow (2x)", 94, Color3.fromRGB(20, 180, 90), Color3.fromRGB(15, 120, 60), function()
    resizeCharacter(currentScale * 2)
end)

makeButton("Shrink (0.5x)", 142, Color3.fromRGB(220, 70, 50), Color3.fromRGB(160, 40, 30), function()
    resizeCharacter(currentScale * 0.5)
end)

makeButton("Reset", 190, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 55), function()
    resizeCharacter(1)
end)

makeButton("Close", 238, Color3.fromRGB(35, 35, 45), Color3.fromRGB(20, 20, 28), function()
    screenGui:Destroy()
end)
    or (pcall(game.GetService, game, "CoreGui") and game:GetService("CoreGui"))
    or player:WaitForChild("PlayerGui")

-- Destroy old GUI if it exists
local old = guiParent:FindFirstChild("CharacterResizerGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CharacterResizerGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = guiParent

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0.5, -120, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui

-- Custom drag via UserInputService (no deprecated Draggable)
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(40, 200, 120)
stroke.Thickness = 1.5
stroke.Transparency = 0.4
stroke.Parent = frame

-- Title bar gradient
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 180, 90)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = Color3.fromRGB(20, 180, 90)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 200, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 160, 220)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 220))
})
gradient.Parent = titleBar

local gradientFix = gradient:Clone()
gradientFix.Parent = titleFix

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Character Resizer"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = titleBar

-- Scale display
local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(1, 0, 0, 34)
scaleLabel.Position = UDim2.new(0, 0, 0, 50)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Text = "Scale: 1x"
scaleLabel.TextColor3 = Color3.fromRGB(40, 200, 120)
scaleLabel.Font = Enum.Font.GothamBold
scaleLabel.TextSize = 18
scaleLabel.Parent = frame

local currentScale = 1

local function resizeCharacter(scale)
    local character = player.Character
    if not character then return end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Size = part.Size * (scale / currentScale)
        end
    end
    currentScale = scale
    scaleLabel.Text = "Scale: " .. tostring(scale) .. "x"
    pcall(function()
        scaleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(scaleLabel, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(40, 200, 120)}):Play()
    end)
end

local function makeButton(text, yPos, color1, color2, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.82, 0, 0, 38)
    btn.Position = UDim2.new(0.09, 0, 0, yPos)
    btn.BackgroundColor3 = color1
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.AutoButtonColor = false
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    local btnGrad = Instance.new("UIGradient")
    btnGrad.Color = ColorSequence.new(color1, color2)
    btnGrad.Rotation = 90
    btnGrad.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = color1
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.6
    btnStroke.Parent = btn

    pcall(function()
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.86, 0, 0, 40)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {Size = UDim2.new(0.82, 0, 0, 38)}):Play()
            TweenService:Create(btnStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
        end)
    end)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

makeButton("Grow (2x)", 94, Color3.fromRGB(20, 180, 90), Color3.fromRGB(15, 120, 60), function()
    resizeCharacter(currentScale * 2)
end)

makeButton("Shrink (0.5x)", 142, Color3.fromRGB(220, 70, 50), Color3.fromRGB(160, 40, 30), function()
    resizeCharacter(currentScale * 0.5)
end)

makeButton("Reset", 190, Color3.fromRGB(60, 60, 80), Color3.fromRGB(40, 40, 55), function()
    resizeCharacter(1)
end)

makeButton("Close", 238, Color3.fromRGB(35, 35, 45), Color3.fromRGB(20, 20, 28), function()
    screenGui:Destroy()
end)
