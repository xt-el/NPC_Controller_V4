-- Modules/GUIBuilder.lua

local Utils = require(script.Parent.Utils) -- Assume que Utils está no mesmo nível
local TweenService = Utils.Services.TweenService
local FastTweenInfo = Utils.FastTweenInfo

local GUIBuilder = {}

-- A função para criar o StatusLabel deve ser chamada no MainScript, mas está aqui para referência
function GUIBuilder.createStatusLabel(parentFrame)
    local statusLabel = Instance.new("TextLabel")
    statusLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    statusLabel.Size = UDim2.new(1, 0, 0.1, 0)
    statusLabel.Text = "NPCs: Nenhum selecionado"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.BorderSizePixel = 0
    statusLabel.Parent = parentFrame
    
    local statusCorner = Instance.new("UICorner", statusLabel)
    statusCorner.CornerRadius = UDim.new(0.1, 0)
    
    return statusLabel
end

function GUIBuilder.createButton(parentFrame, text, callback)
    local button = Instance.new("TextButton", parentFrame)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Size = UDim2.new(1, 0, 0.1, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0.1, 0)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, FastTweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, FastTweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
    end)
    
    button.MouseButton1Click:Connect(callback)
    return button
end

function GUIBuilder.createToggle(parentFrame, text, callback)
    local frame = Instance.new("Frame", parentFrame)
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    frame.Size = UDim2.new(1, 0, 0.1, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0.1, 0)
    
    local label = Instance.new("TextLabel", frame)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.8, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0.05, 0, 0, 0)
    
    local toggle = Instance.new("Frame", frame)
    toggle.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    toggle.Size = UDim2.new(0.12, 0, 0.6, 0)
    toggle.Position = UDim2.new(0.85, 0, 0.2, 0)
    toggle.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner", toggle)
    toggleCorner.CornerRadius = UDim.new(0.3, 0)
    
    local button = Instance.new("TextButton", frame)
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(1, 0, 1, 0)
    button.Text = ""
    
    local isOn = false
    
    local function switch(state)
        isOn = state
        local color = isOn and Color3.fromRGB(50, 220, 50) or Color3.fromRGB(220, 50, 50)
        TweenService:Create(toggle, FastTweenInfo, {BackgroundColor3 = color}):Play()
    end
    
    button.MouseButton1Click:Connect(function()
        switch(not isOn)
        callback(isOn)
    end)
    
    return {
        switch = switch,
        frame = frame,
        label = label,
        toggle = toggle
    }
end

return GUIBuilder
