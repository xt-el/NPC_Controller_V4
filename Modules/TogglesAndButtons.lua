-- Modules/TogglesAndButtons.lua

local Utils = require(script.Parent.Utils)
local Core = require(script.Parent.CoreFunctions)
local GUIBuilder = require(script.Parent.GUIBuilder)

local Connections = {}

function Connections.setup(g2lTable, statusLabel, followToggleSwitch)
    local G2L = g2lTable -- A tabela G2L com a GUI principal
    
    -- Funções de Toggle/Botão

    G2L.clickToggle = GUIBuilder.createToggle(G2L["11"], "Selecionar NPCs", function(state)
        Core.clicknpc = state
        if state then
            Utils.lightNPC(Utils.LocalPlayer.Character, Color3.fromRGB(255, 255, 0))
            statusLabel.Text = "NPCs: Clique para selecionar"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        else
            statusLabel.Text = "NPCs: Seleção desativada"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
    
    GUIBuilder.createButton(G2L["11"], "Desselecionar NPCs", function()
        Core.deselectAllNPCs(statusLabel)
    end)

    GUIBuilder.createButton(G2L["11"], "Selecionar Todos e Teleportar", function()
        Core.selectAllAndTeleport(statusLabel)
    end)

    G2L.clickToMoveToggle = GUIBuilder.createToggle(G2L["11"], "NPCs Mover ao Clique", function(state)
        Core.clickToMove = state
        if state then
            statusLabel.Text = "NPCs: Mover ao Clique Ativado"
            statusLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
        else
            statusLabel.Text = "NPCs: Mover ao Clique Desativado"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)

    GUIBuilder.createButton(G2L["11"], "Parar Movimento", function()
        Core.stopMovement(statusLabel)
        followToggleSwitch(false) -- Desliga o Follow caso esteja ativo
    end)
    
    GUIBuilder.createButton(G2L["11"], "Forçar Animação", function()
        Core.forceAnimation(statusLabel)
    end)

    -- ... Adicione as outras chamadas createButton e createToggle aqui ...
    
    -- Exemplo: Toggle de Seguir
    G2L.followToggle = GUIBuilder.createToggle(G2L["11"], "NPCs Seguir", function(state)
        if state then
            if #Core.selectedNPCs > 0 then
                Core.connections.follow = Utils.Services.RunService.RenderStepped:Connect(function()
                    -- Lógica de seguir NPCs (simplificada)
                    local hrp = Utils.LocalPlayer.Character and Utils.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    Core.applyToSelectedNPCs(function(npc)
                        if Utils.hasNetworkOwnership(npc) then
                            local hum = npc:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local offset = Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
                                hum:MoveTo(hrp.Position + offset)
                            end
                        end
                    end, statusLabel)
                    
                    if #Core.selectedNPCs == 0 then  
                        G2L.followToggle.switch(false)
                    end
                end)
            else
                G2L.followToggle.switch(false)
            end
        else
            if Core.connections.follow then
                Core.connections.follow:Disconnect()
                Core.connections.follow = nil
            end
        end
    end)
    
    -- Retorna os Toggles para que o MainScript possa desconectá-los
    return G2L.followToggle 
end

return Connections
