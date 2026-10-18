GunPickup = class()

-- Tabela global para armazenar todos os pickups ativos
local activePickups = {}

function GunPickup:__init()
    self.screenWidth, self.screenHeight = GetActiveScreenResolution()

    self.ped                            = PlayerPedId()

    self.uniqueId                       = math.random(1000000000, 9999999999)
    self.url                            = ('nui://%s/web/index.html#/weapon-pickup'):format(resource, self.uniqueId)

    self.dict                           = ('%s_txd_%s'):format(resource, self.uniqueId)
    self.texture                        = ('%s_texture_%s'):format(resource, self.uniqueId)
    self.scale                          = 1.0
    self.faceCamera                     = true
    self.seeThroughWalls                = false
    self.onPickup                       = nil
    self.weapon                         = nil
    
    -- ✅ NOVO: PropHandler para gerenciar props 3D de armas no chão
    self.propHandler                    = PropHandler()
    self.propId                         = nil -- ID do prop associado a este pickup
end

function GunPickup:setWeapon(weapon)
    self.weapon = weapon
end

---Configura mapeamento de armas para modelos de props
---Permite que cada minigame configure seus próprios mapeamentos
---@param weaponName string Nome da arma (ex: 'WEAPON_REVOLVER')
---@param propModel string|number Hash ou nome do modelo do prop
---@return nil
function GunPickup:setWeaponPropMapping(weaponName, propModel)
    self.propHandler:setWeaponPropMapping(weaponName, propModel)
end

---Configura múltiplos mapeamentos de uma vez
---@param mappings table<string, string|number> Tabela de mapeamentos [weaponName] = propModel
---@return nil
function GunPickup:setWeaponPropMappings(mappings)
    self.propHandler:setWeaponPropMappings(mappings)
end

function GunPickup:setSeeThroughWalls(seeThroughWalls)
    self.seeThroughWalls = seeThroughWalls
end

function GunPickup:setFaceCamera(faceCamera)
    self.faceCamera = faceCamera
end

function GunPickup:create()
    self.duiObject  = CreateDui(self.url, self.screenWidth, self.screenHeight)
    self.duihandle  = GetDuiHandle(self.duiObject)
    self.runtimeTxd = CreateRuntimeTxd(self.dict)
    self.txdObject  = CreateRuntimeTextureFromDuiHandle(self.runtimeTxd, self.texture, self.duihandle)
    self.alpha      = 255

    Wait(100)

    self:message({
        type = "setVisible",
        data = true
    })

    return true, 'dui created'
end

function GunPickup:destroy()
    -- ✅ NOVO: Remove prop 3D associado quando destroi o pickup
    if self.propId and self.propHandler then
        self.propHandler:delete(self.propId)
        self.propId = nil
    end
    
    if (not self.duiObject) then
        return
    end

    self.running = false -- para as threads primeiro
    Wait(100)            -- aguarda as threads finalizarem

    -- ✅ Usa pcall para evitar crash se o handle do DUI for inválido
    -- Isso pode acontecer se o DUI já foi destruído ou está corrompido
    local success, err = pcall(function()
        DestroyDui(self.duiObject)
    end)
    
    if not success then
        -- DUI já foi destruído ou é inválido, apenas limpa a referência silenciosamente
        -- Isso é normal em casos de race conditions ou cleanup múltiplo
    end

    self.duiObject = nil
    if activeDui == self then
        activeDui = nil
    end
end

function GunPickup:message(payload)
    if not self.duiObject then
        return false
    end

    SendDuiMessage(self.duiObject, json.encode(payload))
    return true
end

function GunPickup:render3dSprite()
    if not self.duiObject then
        return
    end

    if not self.running then
        return
    end

    -- ✅ FIX: Não renderiza pickup se o jogador está em ghost mode
    if getActiveMinigameName then
        local minigameName = getActiveMinigameName()
        if minigameName and MinigameInstances and MinigameInstances[minigameName] then
            local minigame = MinigameInstances[minigameName]
            if minigame and minigame.isGhostMode and minigame:isGhostMode() then
                -- Jogador está em ghost mode, não renderiza o pickup
                return
            end
        end
    end

    local coords = self.coords

    if not coords then
        return
    end

    local offset          = self.offset
    local playerCoords    = GetEntityCoords(self.ped)
    local distance        = #(playerCoords - vec3(coords.x, coords.y, coords.z))

    -- usa tamanho fixo do sprite (configurável em atCoords via options.spriteScale ou options.scale)
    local scale = self.spriteScale or 0.7

    self.alpha = math.max(0, math.min(255, self.alpha))

    if (self.seeThroughWalls) then
        scale = 1.0
        SetDrawOrigin(coords.x, coords.y, coords.z, false)
        DrawInteractiveSprite(self.dict, self.texture, 0, 0, scale, scale, 0.0, 255, 255, 255, self.alpha)
        ClearDrawOrigin()
    else
        DrawMarker(
            28,                  -- type - tipo 28 suporta texturas customizadas
            coords.x + offset.x, -- posX
            coords.y + offset.y, -- posY
            coords.z + offset.z, -- posZ
            0.0,                 -- dirX
            0.0,                 -- dirY
            0.0,                 -- dirZ
            0.0,                 -- rotX
            0.0,                 -- rotY
            0.0,                 -- rotZ
            scale * 1.75,        -- scaleX (dinâmico baseado na distância)
            scale,               -- scaleY (dinâmico baseado na distância)
            scale * 2.0,         -- scaleZ (dinâmico baseado na distância)
            255,                 -- red
            255,                 -- green
            255,                 -- blue
            self.alpha,          -- alpha
            false,               -- bobUpAndDown
            self.faceCamera,     -- faceCamera
            2,                   -- rotationOrder
            false,               -- rotate
            self.dict,           -- textureDict
            self.texture,        -- textureName
            false                -- drawOnEnts
        )
    end

    self.currentDistance = distance
end

function GunPickup:setOptions(options)
    self.seeThroughWalls = options.seeThroughWalls or false

    -- opções de escala
    self.scaleMaxDistance = options.scaleMaxDistance or self.scaleMaxDistance or 500.0
    self.scaleMinDistance = options.scaleMinDistance or self.scaleMinDistance or 30.0
    self.scaleMin = options.scaleMin or self.scaleMin or 3.0
    self.scaleMax = options.scaleMax or self.scaleMax or 75.0
    self.fadeDistance = options.fadeDistance or self.fadeDistance or 30.0
end

function GunPickup:atCoords(coords, offset, options, onPickup)
    if (not self.duiObject) then
        return
    end

    self.coords = coords
    self.entity = nil
    self.offset = offset or {
        x = 0.0,
        y = 0.0,
        z = 0.0
    }

    -- opções
    options = options or {}
    self.seeThroughWalls = options.seeThroughWalls or false

    self.onPickup = onPickup
    -- raio de interação para pegar a arma (em unidades; maior = mais fácil pegar de longe)
    self.pickupInteractionRadius = options.pickupInteractionRadius or 1.5
    -- opções de escala
    self.scaleMaxDistance = options.scaleMaxDistance or 500.0 -- distância onde o scale é máximo
    self.scaleMinDistance = options.scaleMinDistance or 30.0  -- distância onde o scale começa a diminuir mais rápido
    self.scaleMin = options.scaleMin or 3.0                   -- tamanho mínimo
    self.scaleMax = options.scaleMax or 75.0                  -- tamanho máximo
    self.fadeDistance = options.fadeDistance or 30.0          -- distância onde começa a fazer fade
    -- tamanho fixo do sprite (ex.: 0.7 = padrão, 1.0 = maior, 1.5 = bem maior)
    self.spriteScale = options.spriteScale or options.scale or 0.7
end

function GunPickup:worker(running)
    self.running = running

    local function render() -- each frame
        while self.running and self.duiObject do
            local success, err = pcall(function()
                self:render3dSprite()
            end)

            if not success then 
                -- Continua rodando mesmo com erro
            end

            local dist = #(GetEntityCoords(self.ped) - vec3(self.coords.x, self.coords.y, self.coords.z))


            -- ✅ FIX: Verifica se o jogador está em ghost mode ou invencível antes de permitir interação
            local canPickup = true
            if getActiveMinigameName then
                local minigameName = getActiveMinigameName()
                if minigameName and MinigameInstances and MinigameInstances[minigameName] then
                    local minigame = MinigameInstances[minigameName]
                    
                    -- Não permite pickup se estiver em ghost mode
                    if minigame and minigame.isGhostMode and minigame:isGhostMode() then
                        canPickup = false
                    end
                    
                    -- ✅ FIX BUG: Não permite pickup se estiver invencível (período de proteção)
                    if minigame and minigame.isInvincible and minigame:isInvincible() then
                        canPickup = false
                    end
                end
            end


            local radius = self.pickupInteractionRadius or 1.5
            if dist < radius and canPickup and (IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)) then
                if self.onPickup then
                    self.onPickup(self.weapon)
                end
            end

            Wait(0)
        end 
    end

    if running then
        CreateThread(render)
    end
end

---Cria um pickup de arma localmente (chamado quando recebe notificação do servidor)
---@param weapon string Nome da arma
---@param coords vector3 Coordenadas onde criar o pickup
---@param pickupId? string ID único do pickup (opcional)
---@param propModel? string|number Modelo do prop 3D (opcional, se não fornecido tenta usar mapeamento configurado)
---@return GunPickup? Instância do pickup criado
function GunPickup:createPickupLocal(weapon, coords, pickupId, propModel)
    if (not weapon or not coords) then
        return nil
    end

    -- Cria uma nova instância de GunPickup para esta arma dropada
    local pickup = GunPickup()
    
    -- Armazena o ID do pickup se fornecido
    if pickupId then
        pickup.pickupId = pickupId
    end
    
    -- Configura a arma
    pickup:setWeapon(weapon)
    
    -- Cria o DUI se ainda não existir
    if not pickup.duiObject then
        pickup:create()
    end
    
    -- Configura as coordenadas onde a arma foi dropada
    -- Offset para posicionar um pouco acima do chão
    local offset = {
        x = 0.0,
        y = 0.0,
        z = -0.5
    }
    
    -- Configura opções padrão
    local options = {
        seeThroughWalls = false,
        scaleMaxDistance = 500.0,
        scaleMinDistance = 30.0,
        scaleMin = 3.0,
        scaleMax = 75.0,
        fadeDistance = 30.0
    }
    
    -- ✅ NOVO: Cria prop 3D da arma no chão (se modelo fornecido ou mapeamento configurado)
    if propModel or pickup.propHandler:getWeaponPropModel(weapon) then
        local propId = pickup.pickupId and ('prop_%s'):format(pickup.pickupId) or nil
        local propSuccess, propError
        
        if propModel then
            -- Usa modelo fornecido diretamente
            propSuccess, propError = pickup.propHandler:create(propModel, coords, 0.0, propId, {
                frozen = true,
                collision = true,
                visible = true
            })
        else
            -- Tenta usar mapeamento configurado
            propSuccess, propError = pickup.propHandler:createWeaponProp(weapon, coords, 0.0, propId, {
                frozen = true,
                collision = true,
                visible = true
            })
        end
        
        if propSuccess then
            pickup.propId = propSuccess
        else
            -- Log de erro mas continua (prop é opcional, pickup DUI ainda funciona)
            -- Não loga se não houver mapeamento (é esperado se não foi configurado)
            if propError and not propError:find('No prop model mapping found') then
                -- print(('[GunPickup] Erro ao criar prop: %s'):format(propError))
            end
        end
    end
    
    -- Configura o callback quando alguém pegar a arma
    local onPickup = function(pickedWeapon)
        -- Notifica o servidor que o pickup foi pego
        TriggerServerEvent('dminigames.server:pickupWeapon', pickup.pickupId, pickedWeapon)
        
        -- ✅ NOVO: Remove prop 3D quando pickup é pego
        if pickup.propId and pickup.propHandler then
            pickup.propHandler:delete(pickup.propId)
            pickup.propId = nil
        end
        
        -- Remove a arma do chão quando for pega
        pickup:destroy()
        
        -- Remove da lista de pickups ativos
        for i, activePickup in ipairs(activePickups) do
            if activePickup == pickup then
                table.remove(activePickups, i)
                break
            end
        end
    end
    
    -- Posiciona o pickup nas coordenadas
    pickup:atCoords(coords, offset, options, onPickup)
    
    -- Inicia o worker para renderizar o pickup
    pickup:worker(true)
    
    -- Adiciona à lista de pickups ativos
    table.insert(activePickups, pickup)
    
    return pickup
end

---Cria um pickup de arma e sincroniza com todos os jogadores da partida
---@param weapon string Nome da arma
---@param minigameName? string Nome do minigame (opcional, será obtido automaticamente se não fornecido)
---@return nil
function GunPickup:createPickup(weapon, minigameName)
    local ped    = PlayerPedId()
    local coords = GetEntityCoords(ped)

    if (not weapon) then
        return
    end

    -- Se não forneceu o nome do minigame, tenta obter do contexto atual
    -- Verifica se há uma instância de minigame ativa (via variável global)
    if not minigameName then
        -- Tenta obter via getActiveMinigameName se disponível (definido em minigame.lua)
        if getActiveMinigameName then
            minigameName = getActiveMinigameName()
        end
    end

    if not minigameName then
         return
    end

    -- Envia ao servidor para sincronizar com todos os jogadores
    TriggerServerEvent('dminigames.server:createWeaponPickup', minigameName, weapon, coords)
end

---Remove um pickup específico pelo ID (remove duplicatas se existirem)
---@param pickupId string ID do pickup a ser removido
---@return boolean success Se pelo menos um pickup foi removido
function GunPickup.removePickupById(pickupId)
    local removedCount = 0
    -- Itera de trás para frente para remover múltiplos com segurança
    for i = #activePickups, 1, -1 do
        local activePickup = activePickups[i]
        if activePickup.pickupId == pickupId then
            -- destroy() já remove o prop automaticamente
            activePickup:destroy()
            table.remove(activePickups, i)
            removedCount = removedCount + 1
        end
    end
    
    if removedCount > 1 then
        -- print(('[GunPickup] AVISO: Removidos %d pickups duplicados para ID %s'):format(removedCount, pickupId))
    end
    
    return removedCount > 0
end

---Limpa todos os pickups de armas ativos
---@return nil
function GunPickup.clearAllPickups()
    for _, pickup in ipairs(activePickups) do
        if pickup and pickup.destroy then
            -- destroy() já remove os props automaticamente
            pickup:destroy()
        end
    end
    activePickups = {}
end

-- -- Instância global do GunPickup
-- local gunPickupInstance = nil

-- -- Pickup de teste (dev): um único pickup de arma para validar render + interação (E).
-- -- Requer worker(true) após atCoords para o sprite aparecer e o callback ao pegar.
-- CreateThread(function()
--     Wait(2000) -- aguarda um pouco após carregar o resource

--     gunPickupInstance = GunPickup()
--     gunPickupInstance:create()
--     gunPickupInstance:setSeeThroughWalls(false)
--     gunPickupInstance:setWeapon("WEAPON_PISTOL")

--     local coords = { x = 160.53, y = -970.41, z = 30.09 }
--     local offset = { x = 0.0, y = 0.0, z = -0.5 }
--     local options = {
--         pickupInteractionRadius = 1.5,
--         scale = 0.7  -- tamanho do sprite (0.5 = padrão; 1.2 = maior)
--     }

--     gunPickupInstance:atCoords(coords, offset, options, function(weapon)
--         print('[GunPickup Test] Pegou arma:', weapon)
--     end)

--     gunPickupInstance:worker(true) -- inicia render + checagem de E
-- end)
