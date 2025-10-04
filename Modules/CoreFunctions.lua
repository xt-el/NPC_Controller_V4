-- Modules/CoreFunctions.lua

local Utils = require(script.Parent.Utils)

local Core = {}
Core.selectedNPCs = {}
Core.connections = {}
Core.chr = nil -- Para controle de NPC
Core.rad = 100 -- SimulationRadius
Core.minimizebool = false
Core.clickToMove = false
Core.clicknpc = false
Core.autoControlRange = 20

local function updateStatusLabel(statusLabel, message, color)
    if statusLabel and statusLabel:IsA("TextLabel") then
        statusLabel.Text = message
        statusLabel.TextColor3 = color
    end
end

-- Função central para aplicar ações aos NPCs selecionados (corrigida)
function Core.applyToSelectedNPCs(action, statusLabel)
    local newSelectedNPCs = {}
    local statusUpdated = false
    
    for _, npc in pairs(Core.selectedNPCs) do
        if npc and npc.Parent and Utils.hasNetworkOwnership(npc) then
            action(npc)
            table.insert(newSelectedNPCs, npc)
        else
            statusUpdated = true 
        end
    end
    
    Core.selectedNPCs = newSelectedNPCs
    
    if statusUpdated or #Core.selectedNPCs == 0 then
        if #Core.selectedNPCs == 0 then
            updateStatusLabel(statusLabel, "NPCs: Nenhum selecionado", Color3.fromRGB(255, 255, 255))
        else
            updateStatusLabel(statusLabel, "NPCs: " .. #Core.selectedNPCs .. " selecionados (limpo)", Color3.fromRGB(0, 255, 0))
        end
    end
end

-- Funções de Ação

function Core.deselectAllNPCs(statusLabel)
    Core.selectedNPCs = {}
    updateStatusLabel(statusLabel, "NPCs: Nenhum selecionado", Color3.fromRGB(255, 255, 255))
end

function Core.selectAllAndTeleport(statusLabel)
    Core.selectedNPCs = {}
    local lpChar = Utils.LocalPlayer.Character
    if not lpChar then return end
    
    for _, model in pairs(Utils.Services.Workspace:GetDescendants()) do
        if Utils.isNPC(model) and Utils.hasNetworkOwnership(model) then
            table.insert(Core.selectedNPCs, model)
            model:PivotTo(lpChar:GetPivot() + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
            Utils.lightNPC(model, Color3.fromRGB(0, 255, 0))
        end
    end
    updateStatusLabel(statusLabel, "NPCs: " .. #Core.selectedNPCs .. " selecionados", Color3.fromRGB(0, 255, 0))
end

function Core.stopMovement(statusLabel)
    Core.applyToSelectedNPCs(function(npc)
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:MoveTo(npc:GetPivot().Position) 
            Utils.lightNPC(npc, Color3.fromRGB(255, 255, 255))
        end
    end, statusLabel)

    -- Desconecta conexões de movimento
    if Core.connections.follow then 
        Core.connections.follow:Disconnect() 
        Core.connections.follow = nil
    end
    for name, conn in pairs(Core.connections) do
        if name:match("randomwalk_") or name:match("jump_") then
            conn:Disconnect()
            Core.connections[name] = nil
        end
    end
end

function Core.forceAnimation(statusLabel)
    Core.applyToSelectedNPCs(function(npc)
        if not Utils.forceAnimation(npc, Utils.ForcedAnimationId) then
            updateStatusLabel(statusLabel, "Erro: NPC não tem Animator ou falha ao carregar animação.", Color3.fromRGB(255, 100, 100))
        end
        Utils.lightNPC(npc, Color3.fromRGB(255, 105, 180))
    end, statusLabel)
end

-- ... Adicione as outras funções de ação aqui (Eliminar, Teleportar, Punir, etc.) ...

function Core.eliminateNPCs(statusLabel)
    Core.applyToSelectedNPCs(function(npc)
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Dead)
            Utils.lightNPC(npc, Color3.fromRGB(255, 0, 0))
        end
    end, statusLabel)
end

function Core.teleportNPCs(statusLabel)
    local lpChar = Utils.LocalPlayer.Character
    if lpChar then
        Core.applyToSelectedNPCs(function(npc)
            npc:PivotTo(lpChar:GetPivot() + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
            Utils.lightNPC(npc, Color3.fromRGB(0, 255, 0))
        end, statusLabel)
    end
end

return Core
