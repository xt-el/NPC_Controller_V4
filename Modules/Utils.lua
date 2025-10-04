-- Modules/Utils.lua

local Utils = {}

-- Services
Utils.Services = {
    Players = game:GetService("Players"),
    TweenService = game:GetService("TweenService"),
    RunService = game:GetService("RunService"),
    Workspace = game:GetService("Workspace"),
    Debris = game:GetService("Debris")
}

-- Variables
Utils.LocalPlayer = Utils.Services.Players.LocalPlayer
Utils.PlayerGui = Utils.LocalPlayer:WaitForChild("PlayerGui")
Utils.Mouse = Utils.LocalPlayer:GetMouse()
Utils.FastTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
Utils.ForcedAnimationId = "rbxassetid://507771019"

-- Highlight system (shared)
Utils.Highlight = Instance.new("Highlight")
Utils.Highlight.Parent = Utils.LocalPlayer
Utils.Highlight.FillTransparency = 1
Utils.Highlight.OutlineTransparency = 1

-- Funções Utilitárias

function Utils.lightNPC(adornee, color)
    task.spawn(function()
        Utils.Highlight.Adornee = adornee
        Utils.Highlight.OutlineColor = color
        Utils.Services.TweenService:Create(Utils.Highlight, Utils.FastTweenInfo, {OutlineTransparency = 0}):Play()
        task.wait(0.5)
        Utils.Services.TweenService:Create(Utils.Highlight, Utils.FastTweenInfo, {OutlineTransparency = 1}):Play()
    end)
end

function Utils.isNPC(model)
    local humanoid = model:FindFirstChildOfClass("Humanoid")
    local player = Utils.Services.Players:GetPlayerFromCharacter(model)
    return humanoid and not player and model
end

function Utils.hasNetworkOwnership(npc)
    local part = npc:FindFirstChild("HumanoidRootPart")
    -- Uma verificação mais robusta em executors pode ser necessária, mas mantendo a original:
    return part and part.ReceiveAge == 0 and not part.Anchored
end

function Utils.forceAnimation(npc, animationId)
    local hum = npc:FindFirstChildOfClass("Humanoid")
    if hum then
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        
        local track = animator:LoadAnimation(animation)
        track:Play()
        
        Utils.Services.Debris:AddItem(animation, track.Length)  
        return true
    end
    return false
end

return Utils
