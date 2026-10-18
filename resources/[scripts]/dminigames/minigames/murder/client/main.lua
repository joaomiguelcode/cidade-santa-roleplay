---@alias vector4 {x: number, y: number, z: number, w: number}
---@alias vec3 {x: number, y: number, z: number}

-- Variável para armazenar os times da rodada atual (para contar sobreviventes)
local currentRoundTeams = nil

-- ✅ FIX: Sistema de gerenciamento de holster de armas via ControlsManager
-- Usa o controlsManager do MinigameClient ao invés de threads com Wait(1)
local holsterControlId = nil
local currentWeaponForHolster = nil -- weaponName (ex: 'WEAPON_KARAMBIT') para referência em logs

-- Tecla para holster (tecla 1) - definida em MurderConstants.WEAPONS.holsterKey
local HOLSTER_KEY = 157

-- Arma primária do assassino e fallback caso o addon não esteja carregado
local ASSASSIN_WEAPON_PRIMARY  = 'WEAPON_KARAMBIT'
local ASSASSIN_WEAPON_FALLBACK = 'WEAPON_HATCHET'
local ASSASSIN_WEAPON_IMAGES = {
    ['WEAPON_KARAMBIT'] = 'https://santaimagens.roleplayrp.com/img/inventory/WEAPON_KARAMBIT.png',
    ['WEAPON_HATCHET']  = 'https://santaimagens.roleplayrp.com/img/inventory/HATCHET.png',
}

---Resolve qual arma o assassino vai receber: karambit se disponível, hatchet como fallback
---@return string weaponName Nome da arma escolhida
local function resolveAssassinWeapon()
    local primaryHash = GetHashKey(ASSASSIN_WEAPON_PRIMARY)
    if IsWeaponValid(primaryHash) then
        return ASSASSIN_WEAPON_PRIMARY
    end
    --print('[MURDER] ⚠️ WEAPON_KARAMBIT indisponível — usando fallback WEAPON_HATCHET')
    return ASSASSIN_WEAPON_FALLBACK
end

---Inicia o controle de holster para uma arma usando o ControlsManager
---@param weaponName string Nome da arma (ex: 'WEAPON_KARAMBIT', 'WEAPON_REVOLVER')
---@return nil
local function startWeaponHolsterControl(weaponName)
    -- Para controle anterior se existir
    if holsterControlId and murder and murder.controlsManager then
        murder.controlsManager:unregister(holsterControlId)
        holsterControlId = nil
        currentWeaponForHolster = nil
    end

    if not murder or not murder.controlsManager then
        return
    end

    local weaponHash = GetHashKey(weaponName)

    holsterControlId = murder.controlsManager:register(HOLSTER_KEY, function()
        -- Verifica se ainda está em partida e não está em ghost mode
        if not murder:isInMatch() or murder:isGhostMode() then
            return
        end

        local ped = PlayerPedId()
        -- Verifica se TEM a arma antes de tentar equipar/desequipar
        if HasPedGotWeapon(ped, weaponHash, false) then
            local currentWeapon = GetSelectedPedWeapon(ped)
            if currentWeapon == weaponHash then
                -- Arma está equipada → Guarda
                SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
            else
                -- Arma está guardada → Equipa
                SetCurrentPedWeapon(ped, weaponHash, true)
            end
            SetPedCurrentWeaponVisible(ped, true, false, false, false)
        else
            -- Jogador não tem mais a arma (morreu, etc) - remove o controle
            if holsterControlId and murder and murder.controlsManager then
                murder.controlsManager:unregister(holsterControlId)
                holsterControlId = nil
                currentWeaponForHolster = nil
            end
        end
    end, {
        description = 'Holster ' .. weaponName
    })

    currentWeaponForHolster = weaponName
end

---Para o controle de holster da arma atual (se houver)
---@return nil
local function stopWeaponThread()
    if holsterControlId and murder and murder.controlsManager then
        murder.controlsManager:unregister(holsterControlId)
        holsterControlId = nil
        currentWeaponForHolster = nil
    end
end

-- ============================================
-- FUNCAO HELPER: Teleporta jogador de volta ao NPC do PVP
-- ============================================
---@param data table? Payload do framework com returnCoords por role
---@return boolean success
local function teleportToNPC(data)
    local npcCoords = type(data) == 'table' and data.returnCoords or nil

    if not (npcCoords and npcCoords.x and npcCoords.y and npcCoords.z) then
        npcCoords = PVP_NPC_COORDS
    end

    local playerPed = PlayerPedId()

    if DoesEntityExist(playerPed) and npcCoords then
        SetEntityCoordsNoOffset(playerPed, npcCoords.x, npcCoords.y, npcCoords.z, false, false, false)
        SetEntityHeading(playerPed, npcCoords.w or PVP_NPC_COORDS.w)
    end

    return true
end

-- ============================================
-- FUNÇÃO HELPER: Limpeza completa ao sair do Murder
-- ============================================
---Executa toda a limpeza necessária quando o jogador sai da partida
---Usa pcall em cada etapa para garantir que uma falha não impede as outras
---@return boolean success Se todas as etapas foram executadas com sucesso
local function cleanupMurderMatch(data)
    local allSuccess = true
    
    pcall(function() stopWeaponThread() end)
    pcall(function() GunPickup.clearAllPickups() end)
    pcall(function()
        local ped = PlayerPedId()
        if DoesEntityExist(ped) then
            RemoveAllPedWeapons(ped, true)
        end
    end)
    pcall(function() SendNUIMessage({ type = "hideWeapon" }) end)
    pcall(function() NetworkEndTutorialSession() end)
    pcall(function() teleportToNPC(data) end)
    pcall(function() SendNUIMessage({ type = "setVisible", data = false }) end)
    pcall(function() exports['hud']:hideAllButLogoAndNotifications(false) end)
    pcall(function()
        if murder and murder.setInvincibility then
            murder:setInvincibility(false)
        end
    end)
    pcall(function()
        if murder and murder.disableGhostMode then
            murder:disableGhostMode()
        end
    end)
    
    return allSuccess
end

---@type MinigameClient
murder = MinigameClient({
    name = 'murder',

    queue = {
        cameras = {
            {
                center = vec3(2067.57, 2993.73, -63.51),
                from = vec3(2058.61, 2990.73, -62.30),
                to = vec3(2069.55, 2984.35, -62.30),
                interval = 10000,
            },
            {
                center = vec3(2060.87, 2983.45, -61.90),
                from = vec3(2052.21, 2971.66, -61.90),
                to = vec3(2038.74, 2951.31, -61.90),
                interval = 10000,
            }
        },
        onJoin = function(data)
            local payload = {
                type = "setPhase",
                data = {
                    phase         = "SEARCHING",
                    playersNeeded = data.playersNeeded,
                    gameMode      = 'murder'
                }
            }

            SendNUIMessage(payload)
            exports['hud']:hideAllButLogoAndNotifications(true)
        end,
        onLeave = function(data)
            -- Notifica o jogador que saiu da fila (com tradução)
            -- Obtém a mensagem traduzida do MurderTranslations
            local message = MurderTranslations.get('queue_left')
            TriggerEvent('Notify', 'Warning', message, 5000)
            
            -- Apenas esconde UI e teleporta (não precisa limpar armas/pickups que não existem ainda)
            pcall(function()
                SendNUIMessage({ type = "setVisible", data = false })
                exports['hud']:hideAllButLogoAndNotifications(false)
                teleportToNPC()
            end)
        end,
        onTimeout = function(data)
            -- Notifica o jogador que a fila expirou (com tradução)
            -- Obtém a mensagem traduzida do MurderTranslations
            local message = MurderTranslations.get('queue_timeout')
            TriggerEvent('Notify', 'Error', message, 5000)
            
            -- Apenas esconde UI e teleporta (não precisa limpar armas/pickups que não existem ainda)
            pcall(function()
                SendNUIMessage({ type = "setVisible", data = false })
                exports['hud']:hideAllButLogoAndNotifications(false)
                teleportToNPC()
            end)
        end,
        onPlayerDisconnect = function(data)
            -- Aqui você pode atualizar UI, notificar outros jogadores, etc.
        end
    },

    match = {
        -- Se deve respawnar automaticamente quando o jogador morre (usa o sistema de spawnpoints)
        -- ✅ Murder: false = jogador fica em ghost mode no lugar da morte até próxima rodada
        respawnOnDeath = false,

        -- ✅ Obrigatório: ativa GhostModeManager no cliente para virar ghost ao morrer (não renascer)
        enableGhostModeOnDeath = true,

        introGracePeriod = 5000,

        -- Callback quando a partida inicia
        onStart = function(data)

        end,

        -- Callback quando a partida termina
        -- data: { source, userId, players, matchId, matchDuration, teams, playerRole, queueId }
        onEnd = function(data)
            --print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
            --print('[MURDER] onEnd CHAMADO - Match ID:', data.matchId)
            --print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
            
            -- Notifica que a partida terminou (com tradução)
            local message = MurderTranslations.get('match_ended')
            TriggerEvent('Notify', 'Warning', message, 3000)
            
            -- Executa limpeza completa
            cleanupMurderMatch(data)
        end,

        -- Callback quando um jogador entra tardiamente na partida
        -- data: { userId, matchId, players, teams, matchDuration, playerRole, queueId }
        onLateJoin = function(data)
            -- Aqui você pode atualizar UI, mostrar informações, etc.
        end,

        -- Callback quando um jogador desconecta durante a partida
        -- data: { userId, matchId, remainingPlayers, teams, matchDuration, queueId }
        onPlayerDisconnect = function(data)
            -- Aqui você pode atualizar UI, notificar outros jogadores, etc.
        end,
        
        -- ✅ NOVO: Callback chamado para TODOS os clientes quando QUALQUER jogador morre
        -- Este é o lugar certo para lógica específica de morte (animações, efeitos, etc)
        -- data: { source, userId, matchId, attacker, weapon, playerRole }
        onMatchPlayerDeath = function(data)
            -- Aqui você pode:
            -- - Mostrar animação de morte
            -- - Tocar som de morte
            -- - Atualizar kill feed
            -- OBS: O contador de sobreviventes é atualizado em onPlayersStateUpdated
        end,
        
        -- Callback quando o jogador LOCAL morre durante a partida
        -- Este callback é chamado APENAS no cliente que morreu
        -- data: { source, userId, matchId, attacker, weapon, playerRole }
        onPlayerDeath = function(data)
            -- ✅ FIX BUG #5: Removida chamada redundante de enableGhostMode()
            -- O servidor já ativa automaticamente via evento 'enableGhostMode'
            -- Chamar duas vezes causava race conditions e ghost mode não funcionava

            -- ✅ FIX: Para thread de arma e esconde UI quando morre
            stopWeaponThread()
            SendNUIMessage({
                type = "hideWeapon"
            })
            -- Pickup do Detetive é criado pelo servidor (onPlayerDeath server-side)
            -- que também controla o timer de 30s e a promoção automática

            -- Atualiza UI para modo espectador
            -- SendNUIMessage({
            --     type = "setPhase",
            --     data = {
            --         phase = "SPECTATOR", -- ou "DEAD", "GHOST"
            --         gameMode = "murder"
            --     }
            -- })

            -- ✅ Atualiza status do jogador para morto (quando vira ghost)
            SendNUIMessage({
                type = "updatePlayerStatus",
                data = {
                    isAlive = false
                }
            })
            
            -- ✅ Atualização de sobreviventes agora é feita em onMatchPlayerDeath
            -- (chamado para TODOS os jogadores, não apenas o que morreu)
        end,

        -- Callback quando um jogador é adicionado à partida
        -- data: { source, userId, matchId, players, teams, playerRole, matchDuration, queueId }
        onAdd = function(data)
            -- Aqui você pode:
            -- - Atualizar UI com novo jogador
            -- - Mostrar notificação
            -- - Atualizar contador de jogadores
            LocalPlayer.state:set("isLafyMuted", true, true)
        end,

        -- Callback quando o JOGADOR LOCAL sai voluntariamente da partida (ANTES de remover)
        -- data: { source, userId, matchId, players, teams, playerRole, matchDuration, queueId }
        -- ✅ Este callback é chamado APENAS para o jogador que está saindo
        onLeave = function(data)
            -- Notifica que saiu da partida (com tradução)
            local message = MurderTranslations.get('match_left')
            TriggerEvent('Notify', 'Warning', message, 5000)
            LocalPlayer.state:set("isLafyMuted", false, true)
            -- Executa limpeza completa
            cleanupMurderMatch(data)
        end,

        -- Callback quando um jogador é removido da partida (broadcast para OUTROS jogadores)
        -- data: { source, userId, matchId, remainingPlayers, teams, playerRole, matchDuration, queueId, reason }
        -- ✅ Este callback é chamado para TODOS OS JOGADORES quando ALGUÉM sai
        -- ✅ Use para atualizar UI, mostrar notificações, etc (NÃO para limpeza pessoal)
        onRemove = function(data)
            -- Remove jogador de currentRoundTeams para manter consistência (evita dados obsoletos)
            if currentRoundTeams and data.source and data.playerRole and currentRoundTeams[data.playerRole] then
                currentRoundTeams[data.playerRole][data.source] = nil
            end
            -- OBS: O contador de sobreviventes é atualizado em onPlayersStateUpdated (via syncPlayersState)
        end,
        
        -- ✅ NOVO: Callback quando estado dos jogadores é atualizado (mais genérico)
        -- Chamado sempre que as listas alivePlayers/deadPlayers/ghostPlayers mudam
        -- Usado para atualizar contador de sobreviventes sem depender de eventos específicos
        onPlayersStateUpdated = function(data)
            --print('[HUD DEBUG] 📊 onPlayersStateUpdated chamado')
            --print('[HUD DEBUG] currentRoundTeams:', json.encode(currentRoundTeams or {}))
            --print('[HUD DEBUG] alivePlayers:', json.encode(data.alivePlayers or {}))
            --print('[HUD DEBUG] deadPlayers:', json.encode(data.deadPlayers or {}))
            
            -- Atualiza contador de sobreviventes sempre que estado muda
            -- (morte, saída, desconexão, etc)
            if currentRoundTeams then
                local remainingSurvivors = murder:countAlivePlayers(currentRoundTeams, nil, {
                    ['Inocentes'] = true,
                    ['Detetives'] = true
                })
                
                --print('[HUD DEBUG] ✅ remainingSurvivors calculado:', remainingSurvivors)
                
                SendNUIMessage({
                    type = "updateSurvivors",
                    data = {
                        remainingSurvivors = remainingSurvivors
                    }
                })
            else
                --print('[HUD DEBUG] ⚠️ currentRoundTeams é nil! Não pode atualizar contador')
            end
        end,

        -- ========================================
        -- CALLBACKS DE RODADAS
        -- ========================================

        -- Callback quando uma rodada inicia (chamado a cada rodada quando roundBased = true)
        -- data: { roundNumber, players, matchId, teams, playerRole, queueId }
        onRoundStart = function(data)
            -- ✅ FIX BUG INVENCIBILIDADE: Captura o número da rodada no início
            -- Será usado para validar se callbacks de timeout ainda são válidos
            local roundNumber = data.roundNumber
            
            exports['hud']:hideAllButLogoAndNotifications(true)
            NetworkStartSoloTutorialSession()

            -- Limpa todos os pickups de armas do chão quando uma nova rodada começa
            GunPickup.clearAllPickups()

            -- ✅ FIX: Para thread de arma anterior antes de remover armas
            stopWeaponThread()

            -- Remove todas as armas antes de dar as armas específicas do role
            RemoveAllPedWeapons(PlayerPedId(), true)

            -- ✅ FIX: Esconde UI de arma IMEDIATAMENTE no início da rodada
            -- Isso garante reset limpo antes da apresentação
            SendNUIMessage({
                type = "hideWeapon"
            })

            -- ✅ FIX UI: Garante que a UI está visível antes de mudar fase
            SendNUIMessage({
                type = "setVisible",
                data = true
            })

            -- Armazena os times da rodada atual para usar em outras funções
            currentRoundTeams = data.teams

            SendNUIMessage({
                type = "updatePlayerStatus",
                data = {
                    isAlive = true
                }
            })
            

            SendNUIMessage({
                type = "setPhase",
                data = {
                    phase = "ROLE_ASSIGNMENT",
                    gameMode = "murder"
                }
            })

            local roles = {
                ['Assassinos'] = 'ASSASSIN',
                ['Detetives']  = 'DETECTIVE',
                ['Inocentes']  = 'SURVIVOR',
            }

            SendNUIMessage({
                type = "setRole",
                data = {
                    role = roles[data.playerRole] or 'SURVIVOR'
                }
            })
            
            -- Notifica o jogador sobre seu role (com tradução)
            -- Isso ajuda jogadores que não olharam a tela de apresentação
            local roleMessages = {
                ['Assassinos'] = 'role_assassin',
                ['Detetives']  = 'role_detective',
                ['Inocentes']  = 'role_innocent',
            }
            local roleKey = roleMessages[data.playerRole]
            if roleKey then
                local message = MurderTranslations.get(roleKey)
                TriggerEvent('Notify', 'Warning', message, 7000)
            end

            -- Conta sobreviventes no início da rodada (todos estão vivos)
            -- Sobreviventes = Inocentes + Detetives (não conta Assassinos)
            if data.teams then
                local remainingSurvivors = murder:countAlivePlayers(data.teams, data.players, {
                    ['Inocentes'] = true,
                    ['Detetives'] = true
                })
                
                SendNUIMessage({
                    type = "updateSurvivors",
                    data = {
                        remainingSurvivors = remainingSurvivors
                    }
                })
            end

            -- A apresentação da câmera já cuida do teleporte
            -- Após a apresentação terminar (5 segundos), volta ao gameplay
            -- ✅ Usa registerTimeout do framework (cancela automaticamente se sair)
            murder:registerTimeout(function()
                -- ✅ FIX BUG INVENCIBILIDADE: Verifica se ainda é a mesma rodada
                -- Se a rodada mudou enquanto o timeout estava pendente, aborta
                if murder.currentRoundNumber ~= roundNumber then
                    return
                end
                
                -- ✅ VERIFICAÇÃO CRÍTICA: Confirma que ainda está na partida
                -- (Pode ter saído DURANTE a execução de onRoundStart, antes do timeout ser registrado)
                if not murder:isInMatch() then
                    return
                end

                -- ✅ Transita para GAMEPLAY (grace period terminou)
                murder:transitionToState(murder.GameState.MATCH_GAMEPLAY, 'intro grace period ended')

                SendNUIMessage({
                    type = "setPhase",
                    data = {
                        phase = "GAMEPLAY",
                        gameMode = "murder"
                    }
                })
                SendNUIMessage({
                    type = "updateTimer",
                    data = {
                        timer = (60 * 15) - murder.matchConfig.introGracePeriod / 1000 -- ou qualquer valor em segundos
                    }
                })

                NetworkEndTutorialSession()
                RemoveAllPedWeapons(PlayerPedId(), true)

                -- ✅ FIX: Esconde UI de arma ANTES de decidir qual arma dar
                -- Isso garante que Inocentes não mantenham UI da rodada anterior
                SendNUIMessage({
                    type = "hideWeapon"
                })

                -- ✅ VERIFICAÇÃO ANTES DE DAR ARMAS (pode ter saído durante as operações acima)
                if not murder:isInMatch() then
                    return
                end

                if (data.playerRole == 'Assassinos') then
                    local assassinWeapon = resolveAssassinWeapon()
                    local assassinHash   = GetHashKey(assassinWeapon)

                    SendNUIMessage({
                        type = "showWeapon",
                        data = {
                            weapon = {
                                image    = ASSASSIN_WEAPON_IMAGES[assassinWeapon],
                                quantity = 1
                            }
                        }
                    })

                    GiveWeaponToPed(PlayerPedId(), assassinHash, 100, true, false)

                    -- ✅ FIX BUG #8: Aumenta dano da faca para one-hit kill
                    SetWeaponDamageModifier(assassinHash, 5.0)

                    -- ✅ REFATORADO: Usa ControlsManager ao invés de thread com Wait(1)
                    stopWeaponThread()
                    startWeaponHolsterControl(assassinWeapon)
                end

                -- ✅ VERIFICAÇÃO ANTES DE DAR ARMAS AO DETETIVE
                if not murder:isInMatch() then
                    return
                end

                if (data.playerRole == 'Detetives') then
                    SendNUIMessage({
                        type = "showWeapon",
                        data = {
                            weapon = {
                                -- ✅ FIX BUG #4: Imagem correta do revolver (não mais Karambit)
                                image = "https://santaimagens.roleplayrp.com/img/inventory/magnum.png",
                                quantity = 1
                            }
                        }
                    })

                    GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_REVOLVER"), 300, true, false)

                    SetWeaponDamageModifier(GetHashKey("WEAPON_REVOLVER"), 5.0)

                    -- ✅ REFATORADO: Usa ControlsManager ao invés de thread com Wait(1)
                    stopWeaponThread()
                    startWeaponHolsterControl('WEAPON_REVOLVER')
                elseif (data.playerRole == 'Inocentes') then
                    -- ✅ FIX: Inocentes explicitamente escondem arma e param threads
                    stopWeaponThread()
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    SendNUIMessage({
                        type = "hideWeapon"
                    })
                end
                
                -- ✅ VERIFICAÇÃO EXTRA: Confirma que está no estado correto antes de definir invencibilidade
                local currentState = murder.currentState
                if currentState ~= murder.GameState.MATCH_GAMEPLAY then
                    return
                end
                
                -- ✅ FIX ARQUITETURA: Define invencibilidade SEM timeout com transparência
                -- O Murder vai remover manualmente após 7 segundos com validação de rodada
                -- makeTransparent=true aplica alpha 150 (estilo ghost mode) durante invencibilidade
                murder:setInvincibility(true, nil, true)
                
                -- ✅ Agenda remoção manual com validação de rodada
                local invincibilityRound = murder.currentRoundNumber
                
                murder:registerTimeout(function()
                    -- Valida se ainda é a mesma rodada
                    if murder.currentRoundNumber ~= invincibilityRound then
                        return
                    end
                    
                    -- Valida se ainda está na partida
                    if not murder:isInMatch() then
                        return
                    end
                    
                    -- Remove invencibilidade e transparência automaticamente
                    murder:setInvincibility(false)
                end, 7000)
            end, murder.matchConfig.introGracePeriod)

            murder.camera:doPlayerPresentationAtCoord(vec4(2019.46, 3021.36, -72.69 - 1.0, 257.35),
                murder.matchConfig.introGracePeriod)
        end,

        -- Callback quando uma rodada termina
        -- data: { roundNumber, matchId, winnerTeam, players, teams, roundDuration, reason, queueId }
        -- reason: 'team_elimination' (apenas um time vivo) ou 'time_limit' (tempo acabou)
        onRoundEnd = function(data)
            -- ✅ FIX: Para thread de arma ANTES de remover armas
            stopWeaponThread()

            -- Limpa todos os pickups de armas do chão quando a rodada termina
            GunPickup.clearAllPickups()

            -- Remove todas as armas ao final da rodada
            RemoveAllPedWeapons(PlayerPedId(), true)

            -- ✅ FIX: Esconde UI de arma ao fim da rodada
            SendNUIMessage({
                type = "hideWeapon"
            })

            -- Atualiza contagem final de sobreviventes
            -- Sobreviventes = Inocentes + Detetives (não conta Assassinos)
            if data.teams then
                -- ✅ FIX BUG #1: Removido Assassinos do contador de sobreviventes
                local remainingSurvivors = murder:countAlivePlayers(data.teams, nil, {
                    ['Inocentes'] = true,
                    ['Detetives'] = true
                })

                SendNUIMessage({
                    type = "updateSurvivors",
                    data = {
                        remainingSurvivors = remainingSurvivors
                    }
                })
            end

            -- gameEnd é enviado por murder.client:onRoundPointsEarned (valores reais do servidor)

            -- Aqui você pode:
            -- - Mostrar resultado da rodada (time vencedor)
            -- - Atualizar estatísticas
            -- - Preparar para próxima rodada
        end,

        -- Callback quando o jogador pega uma arma do chão (pickup) — usado por outros minigames
        -- Murder: Inocente→Detetive usa murder.client:onPickupPromotedToDetective (evento unificado)
        -- data: { weapon, pickupId }
        onWeaponPickup = function(data)
            local weaponName = data.weapon
            
            --print('[HUD DEBUG] 🔫 onWeaponPickup chamado | Arma:', weaponName)
            
            -- Define a imagem correta baseada na arma pega
            local weaponImage = ""
            if weaponName == 'WEAPON_KARAMBIT' or weaponName == 'WEAPON_HATCHET' then
                weaponImage = ASSASSIN_WEAPON_IMAGES[weaponName] or ASSASSIN_WEAPON_IMAGES[ASSASSIN_WEAPON_PRIMARY]
            elseif weaponName == 'WEAPON_REVOLVER' then
                weaponImage = "https://santaimagens.roleplayrp.com/img/inventory/magnum.png"
            end

            -- Atualiza UI para mostrar a arma
            SendNUIMessage({
                type = "showWeapon",
                data = {
                    weapon = {
                        image = weaponImage,
                        quantity = 1
                    }
                }
            })

            -- ✅ Usa ControlsManager para controle de holster
            stopWeaponThread()
            startWeaponHolsterControl(weaponName)
            
            -- ✅ FIX BUG #2: Se pegou revolver (arma de detetive), promove para Detetive
            if weaponName == 'WEAPON_REVOLVER' and currentRoundTeams then
                local localSource = GetPlayerServerId(PlayerId())
                
                --print('[HUD DEBUG] 🔫 Pegou REVOLVER | Source:', localSource)
                --print('[HUD DEBUG] currentRoundTeams antes:', json.encode(currentRoundTeams))
                
                -- Move de Inocentes para Detetives
                if currentRoundTeams['Inocentes'] and currentRoundTeams['Inocentes'][localSource] then
                    local userId = currentRoundTeams['Inocentes'][localSource]
                    currentRoundTeams['Inocentes'][localSource] = nil
                    
                    if not currentRoundTeams['Detetives'] then
                        currentRoundTeams['Detetives'] = {}
                    end
                    currentRoundTeams['Detetives'][localSource] = userId
                    
                    --print('[HUD DEBUG] ✅ Promovido para Detetive!')
                    --print('[HUD DEBUG] currentRoundTeams depois:', json.encode(currentRoundTeams))
                    
                    -- Atualiza contador de sobreviventes
                    local remainingSurvivors = murder:countAlivePlayers(currentRoundTeams, nil, {
                        ['Inocentes'] = true,
                        ['Detetives'] = true
                    })
                    
                    --print('[HUD DEBUG] 📊 Atualizando contador | Sobreviventes:', remainingSurvivors)
                    
                    SendNUIMessage({
                        type = "updateSurvivors",
                        data = { remainingSurvivors = remainingSurvivors }
                    })
                    
                    -- Atualiza role na UI
                    SendNUIMessage({
                        type = "updateRole",
                        data = { role = "Detetive" }
                    })
                    
                    --print('[HUD DEBUG] ✅ HUD atualizado para Detetive')
                else
                    --print('[HUD DEBUG] ⚠️ Jogador não está em Inocentes ou já é Detetive')
                end
            end
        end,
        
        -- Callback quando um jogador entra em modo fantasma de espera (entrada tardia durante rodada)
        -- data: { userId, matchId, queueId }
        onPlayerWaitingNextRound = function(data)
            -- ✅ FIX: Late joiners não devem ter armas ou threads de arma
            stopWeaponThread()
            RemoveAllPedWeapons(PlayerPedId(), true)

            -- ✅ FIX: Esconde UI de arma para late joiners
            SendNUIMessage({
                type = "hideWeapon"
            })

            -- ✅ FIX UI: Garante que a UI está visível antes de mudar fase (late joiners)
            SendNUIMessage({
                type = "setVisible",
                data = true
            })

            -- Atualiza UI para mostrar que está aguardando próxima rodada
            SendNUIMessage({
                type = "setPhase",
                data = {
                    phase = "WAITING_NEXT_ROUND",
                    gameMode = "murder"
                }
            })
        end,
    }
})

-- ✅ Configura mapeamentos de armas para props 3D
-- Cada minigame pode configurar seus próprios mapeamentos
if murder and murder.gunpopup then
    murder.gunpopup:setWeaponPropMappings({
        ['WEAPON_REVOLVER'] = 'w_pi_revolver_g',
        -- Adicione mais mapeamentos conforme necessário
    })
end

-- ✅ MOVIDO PARA O FRAMEWORK: O evento murder.client:onWeaponPickupRemoved agora é tratado pelo framework
-- A lógica de UI e controle de holster foi movida para o match callback do MinigameClient

-- ========================================
-- SISTEMA DE DESCONEXÃO E TROCA DE PAPÉIS
-- ========================================

-- Evento quando jogador é promovido a Assassino (após desconexão de outro Assassino)
-- ✅ FIX: Atualiza currentRoundTeams para o jogador promovido (ele não recebe onRoleChange)
RegisterNetEvent('murder.client:promoteToAssassin', function(data)
    local localSource = GetPlayerServerId(PlayerId())
    if murder and currentRoundTeams then
        local userId = currentRoundTeams['Inocentes'] and currentRoundTeams['Inocentes'][localSource]
        if userId then
            currentRoundTeams['Inocentes'][localSource] = nil
            if not currentRoundTeams['Assassinos'] then
                currentRoundTeams['Assassinos'] = {}
            end
            currentRoundTeams['Assassinos'][localSource] = userId
            local remainingSurvivors = murder:countAlivePlayers(currentRoundTeams, nil, {
                ['Inocentes'] = true,
                ['Detetives'] = true
            })
            SendNUIMessage({
                type = "updateSurvivors",
                data = { remainingSurvivors = remainingSurvivors }
            })
        end
    end


    -- ✅ FIX: Notificação visual
    TriggerEvent('Notify', 'Warning', MurderTranslations.get('promoted_to_assassin'), 5000)

    -- Para thread de arma anterior
    stopWeaponThread()
    
    -- Remove todas as armas antes de dar a nova
    RemoveAllPedWeapons(PlayerPedId(), true)
    
    local assassinWeapon = resolveAssassinWeapon()
    local assassinHash   = GetHashKey(assassinWeapon)

    -- Mostra UI da arma
    SendNUIMessage({
        type = "showWeapon",
        data = {
            weapon = {
                image    = ASSASSIN_WEAPON_IMAGES[assassinWeapon],
                quantity = 1
            }
        }
    })

    GiveWeaponToPed(PlayerPedId(), assassinHash, 100, true, false)

    -- ✅ FIX BUG #8: Aumenta dano da faca para one-hit kill
    SetWeaponDamageModifier(assassinHash, 5.0)

    -- ✅ REFATORADO: Usa ControlsManager ao invés de thread com Wait(1)
    startWeaponHolsterControl(assassinWeapon)
    
    -- Atualiza role na UI
    SendNUIMessage({
        type = "setRole",
        data = {
            role = "ASSASSIN"
        }
    })
end)

-- Evento unificado: Inocente pegou arma do chão e foi promovido a Detetive
-- Um único fluxo, sem race conditions (substitui promoteToDetective + onWeaponPickupRemoved para o picker)
-- ✅ FIX: Atualiza currentRoundTeams para o picker (ele não recebe onRoleChange)
RegisterNetEvent('murder.client:onPickupPromotedToDetective', function(data)
    local localSource = GetPlayerServerId(PlayerId())
    if murder and currentRoundTeams then
        local userId = currentRoundTeams['Inocentes'] and currentRoundTeams['Inocentes'][localSource]
        if userId then
            currentRoundTeams['Inocentes'][localSource] = nil
            if not currentRoundTeams['Detetives'] then
                currentRoundTeams['Detetives'] = {}
            end
            currentRoundTeams['Detetives'][localSource] = userId
            local remainingSurvivors = murder:countAlivePlayers(currentRoundTeams, nil, {
                ['Inocentes'] = true,
                ['Detetives'] = true
            })
            SendNUIMessage({
                type = "updateSurvivors",
                data = { remainingSurvivors = remainingSurvivors }
            })
        end
    end

    -- ✅ FIX: Notificação visual
    TriggerEvent('Notify', 'Warning', MurderTranslations.get('promoted_to_detective'), 5000)
    TriggerEvent('Notify', 'Aviso', MurderTranslations.get('detective_weapon_pickup'), 3000)

    local weaponName = data.weapon or 'WEAPON_REVOLVER'
    local ammo = data.ammo or 300
    local weaponHash = GetHashKey(weaponName)

    -- ✅ FIX BUG: Valida se a arma existe antes de dar ao jogador
    if not IsWeaponValid(weaponHash) then
        --print(string.format("[MURDER] ❌ ERRO: Arma inválida: %s (hash: %d)", weaponName, weaponHash))
        return
    end

    -- Remove pickup da tela (pode já estar destruído pelo gunpopup ao pressionar E)
    if data.pickupId and murder and murder.gunpopup then
        pcall(function()
            GunPickup.removePickupById(data.pickupId)
        end)
    end

    stopWeaponThread()
    RemoveAllPedWeapons(PlayerPedId(), true)

    -- ✅ FIX BUG: Corrige parâmetros de GiveWeaponToPed (true, false ao invés de false, true)
    -- Parâmetros: (ped, weaponHash, ammo, isHidden, equipNow)
    -- isHidden=true: arma fica escondida (padrão do minigame)
    -- equipNow=false: não equipa automaticamente (evita conflitos com holster)
    GiveWeaponToPed(PlayerPedId(), weaponHash, ammo, true, false)
    SetWeaponDamageModifier(weaponHash, 5.0)
    
    -- ✅ FIX BUG: Força equipar a arma após dar (garante que está disponível)
    Wait(100) -- Pequeno delay para garantir que GiveWeaponToPed processou
    SetCurrentPedWeapon(PlayerPedId(), weaponHash, true)

    SendNUIMessage({
        type = "showWeapon",
        data = {
            weapon = {
                image = "https://santaimagens.roleplayrp.com/img/inventory/magnum.png",
                quantity = 1
            }
        }
    })

    startWeaponHolsterControl(weaponName)

    SendNUIMessage({
        type = "setRole",
        data = { role = "DETECTIVE" }
    })
end)

-- Evento quando jogador é promovido a Detetive (timeout sem ninguém pegar, etc)
-- data.giveWeapon (opcional): Se true, dá a arma. Se false ou nil, apenas atualiza role
-- ✅ FIX: Atualiza currentRoundTeams para o jogador promovido (ele não recebe onRoleChange)
RegisterNetEvent('murder.client:promoteToDetective', function(data)
    local localSource = GetPlayerServerId(PlayerId())
    if murder and currentRoundTeams then
        local userId = currentRoundTeams['Inocentes'] and currentRoundTeams['Inocentes'][localSource]
        if userId then
            currentRoundTeams['Inocentes'][localSource] = nil
            if not currentRoundTeams['Detetives'] then
                currentRoundTeams['Detetives'] = {}
            end
            currentRoundTeams['Detetives'][localSource] = userId
            local remainingSurvivors = murder:countAlivePlayers(currentRoundTeams, nil, {
                ['Inocentes'] = true,
                ['Detetives'] = true
            })
            SendNUIMessage({
                type = "updateSurvivors",
                data = { remainingSurvivors = remainingSurvivors }
            })
        end
    end

    -- ✅ FIX: Notificação visual
    TriggerEvent('Notify', 'Warning', MurderTranslations.get('promoted_to_detective'), 5000)

    local shouldGiveWeapon = data.giveWeapon ~= false -- Por padrão dá a arma, a menos que explicitamente false
    
    if shouldGiveWeapon then
        -- Para thread de arma anterior
        stopWeaponThread()
        
        -- Remove todas as armas antes de dar a nova
        RemoveAllPedWeapons(PlayerPedId(), true)
        
        -- Mostra UI da arma
        SendNUIMessage({
            type = "showWeapon",
            data = {
                weapon = {
                    image = "https://santaimagens.roleplayrp.com/img/inventory/magnum.png",
                    quantity = 1
                }
            }
        })
        
        -- Dá a arma WEAPON_REVOLVER com 300 munições
        local revolverHash = GetHashKey("WEAPON_REVOLVER")
        
        -- ✅ FIX BUG: Valida se a arma existe antes de dar ao jogador
        if not IsWeaponValid(revolverHash) then
            --print("[MURDER] ❌ ERRO: WEAPON_REVOLVER não encontrada no servidor")
            return
        end
        
        GiveWeaponToPed(PlayerPedId(), revolverHash, 300, true, false)
        
        -- ✅ REFATORADO: Usa ControlsManager ao invés de thread com Wait(1)
        startWeaponHolsterControl('WEAPON_REVOLVER')
    end
    
    -- Atualiza role na UI (sempre, independente de dar arma ou não)
    SendNUIMessage({
        type = "setRole",
        data = {
            role = "DETECTIVE"
        }
    })
end)



-- Evento quando um jogador muda de role (notificação para outros jogadores)
-- Atualiza currentRoundTeams para manter contador de sobreviventes correto (evita overcount quando Inocente vira Assassino)
RegisterNetEvent('murder.client:onRoleChange', function(data)
    -- ✅ DEBUG: Log quando evento é recebido
    --print('[MURDER CLIENT DEBUG] 📨 Recebido onRoleChange:', json.encode(data))

    -- ✅ FIX CRÍTICO: Mostra notificação ANTES da validação
    -- Assim TODOS veem a notificação, mesmo que não consigam atualizar os times locais
    if data.newRole == 'Assassinos' then
        --print('[MURDER CLIENT DEBUG] 🔔 Mostrando notificação: Um novo Assassino entrou em ação')
        local message = MurderTranslations.get('new_assassin_action')
        TriggerEvent('Notify', 'Warning', message, 8000)
    elseif data.newRole == 'Detetives' then
        --print('[MURDER CLIENT DEBUG] 🔔 Mostrando notificação: Novo Detetive')
        local message = MurderTranslations.get('new_detective_assigned')
        TriggerEvent('Notify', 'Warning', message, 8000)
    end

    -- Validação: necessária apenas para atualizar times locais
    if not murder or not currentRoundTeams or not data.source or not data.oldRole or not data.newRole then
        --print('[MURDER CLIENT DEBUG] ❌ Validação falhou - murder:', murder ~= nil, 'currentRoundTeams:', currentRoundTeams ~= nil, 'data.source:', data.source ~= nil, 'data.oldRole:', data.oldRole ~= nil, 'data.newRole:', data.newRole ~= nil)
        --print('[MURDER CLIENT DEBUG] ⚠️ Notificação foi mostrada, mas times locais não serão atualizados')
        return
    end
    
    local source = data.source
    local userId = data.userId
    -- Remove da role antiga
    if currentRoundTeams[data.oldRole] then
        currentRoundTeams[data.oldRole][source] = nil
    end
    -- Adiciona na role nova
    if not currentRoundTeams[data.newRole] then
        currentRoundTeams[data.newRole] = {}
    end
    currentRoundTeams[data.newRole][source] = userId

    -- Atualiza HUD imediatamente
    local remainingSurvivors = murder:countAlivePlayers(currentRoundTeams, nil, {
        ['Inocentes'] = true,
        ['Detetives'] = true
    })
    SendNUIMessage({
        type = "updateSurvivors",
        data = { remainingSurvivors = remainingSurvivors }
    })
end)

-- Evento quando um pickup de arma do Detetive é criado (desconexão ou saída voluntária)
-- O framework cria o pickup físico, este handler serve APENAS para notificação visual
RegisterNetEvent('murder.client:onWeaponPickupCreated', function(data)
    if data.source == 'detective_disconnect' or data.source == 'detective_leave' or data.source == 'detective_death' then
        TriggerEvent('Notify', 'Warning', MurderTranslations.get('detective_weapon_dropped'), 5000)
    end
end)



-- Evento: pontos reais da rodada (enviado pelo servidor ao fim de cada rodada)
RegisterNetEvent('murder.client:onRoundPointsEarned')
AddEventHandler('murder.client:onRoundPointsEarned', function(payload)
    local pointsEarned = payload.pointsEarned or 0
    local roundDurationSec = payload.roundDurationSec or 0
    local winnerTeam = payload.winnerTeam

    local result = "DRAW"
    if winnerTeam == 'Assassinos' then
        result = "ASSASSIN_WIN"
    elseif winnerTeam == 'Inocentes' then
        result = "INNOCENTS_WIN"
    end

    --print('pointsEarned', pointsEarned)

    SendNUIMessage({
        type = "gameEnd",
        data = {
            result = result,
            matchDuration = roundDurationSec,
            pointsEarned = pointsEarned
        }
    })
end)

RegisterCommand('scoreboard', function()
    local data = vSERVER.getRankingData('murder', 1)
    if data and data.scoreboardData then
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "showScoreboard",
            data = {
                show = true,
                gameMode = data.gameMode or "murder",
                scoreboardData = data.scoreboardData
            }
        })
    end
end)
