---@type table
Tunnel   = module('vrp', 'lib/Tunnel')
---@type table
Proxy    = module('vrp', 'lib/Proxy')
---@type table
vRP      = Proxy.getInterface('vRP')
---@type string
resource = GetCurrentResourceName()
---@type string
cityName = GetConvar('cityName', '')
---@type table
utils    = {}
---@type string
lang     = GetConvar("language", "pt-br") or "pt-br"
---@type "server"|"client"
scope    = IsDuplicityVersion() and 'server' or 'client'

if (scope == 'client') then
    -- inicializar sistema de RPC no cliente
    RPC = Tunnel.getInterface(resource)
    vSERVER = Tunnel.getInterface(resource)

    AddEventHandler('onClientResourceStart', function(resourceName)
        if resourceName ~= resource then
            return
        end

        LocalPlayer.state:set('minigame:active', false, true)
    end)

    -- print('lang: ' .. lang)

    local function clearMinigameSilhouettes()
        TriggerEvent('pvp.competitive:clearSilhouettes')

        for _, playerIdx in ipairs(GetActivePlayers()) do
            local ped = GetPlayerPed(playerIdx)
            if DoesEntityExist(ped) then
                SetEntityDrawOutline(ped, false)
            end
        end
    end

    -- everything below is for dev purposes, faster testing, and must be removed in production
    --[[
    RegisterCommand('resetminigame', function()
        NewLoadSceneStop()
        ClearFocus()
        clearMinigameSilhouettes()

        DoScreenFadeIn(1000)

        -- SetEntityCoords(PlayerPedId(), 156.95, -965.02, 30.09)
        SetEntityCoords(PlayerPedId(),160.15,-1073.19,29.19)

        FreezeEntityPosition(PlayerPedId(), false)
        RemoveAllPedWeapons(PlayerPedId(), true)

        local playerPed = PlayerPedId()

        -- Restaura alpha normal
        SetEntityAlpha(playerPed, 255, false)
        ResetEntityAlpha(playerPed)

        -- Desativa ghost mode
        SetLocalPlayerAsGhost(false)
        SetGhostedEntityAlpha(255)

        -- Remove state de invulnerável (deve ser antes de SetEntityInvincible)
        LocalPlayer["state"]["Invincible"] = false

        -- Remove invulnerabilidade
        SetEntityInvincible(playerPed, false)

        TriggerEvent("Notify:Text", "")

        LocalPlayer["state"]["minigame:active"] = false

        NetworkEndTutorialSession()

        -- Estado global do competitivo (ressurreição / spawn)
        _G.dminigames_competitive = nil

        -- Para ghost/visibilidade de todos os MinigameClient (evita NetworkConceal preso)
        if MinigameInstances then
            for _, client in pairs(MinigameInstances) do
                if client and client.stopVisibilityLoop then
                    client:stopVisibilityLoop()
                end
                if client and client.ghostModeManager then
                    client.ghostModeManager:cleanup()
                end
                if client and client.disableGhostMode then
                    client:disableGhostMode()
                end
                if client and client.alivePlayers then
                    for k in pairs(client.alivePlayers) do client.alivePlayers[k] = nil end
                end
                if client and client.deadPlayers then
                    for k in pairs(client.deadPlayers) do client.deadPlayers[k] = nil end
                end
                if client and client.ghostPlayers then
                    for k in pairs(client.ghostPlayers) do client.ghostPlayers[k] = nil end
                end
                if client and client.stopMatchBinds then
                    client:stopMatchBinds()
                end
                if client and client.gunpopup and client.gunpopup.worker then
                    client.gunpopup:worker(false)
                end
                if client and client.transitionToState then
                    client:transitionToState(MinigameClient.GameState.NONE, 'resetminigame')
                end
            end
        end

        -- Garante visibilidade de todos os players da sessão (não só os que estavam nas listas da partida)
        local myIdx = PlayerId()
        for _, playerIdx in ipairs(GetActivePlayers()) do
            if playerIdx ~= myIdx then
                NetworkConcealPlayer(playerIdx, false, false)
                local ped = GetPlayerPed(playerIdx)
                if DoesEntityExist(ped) then
                    SetEntityVisible(ped, true, false)
                    ResetEntityAlpha(ped)
                    SetEntityCollision(ped, true, true)
                end
            end
        end

        if PlayerStateManager and PlayerStateManager.getInstance then
            PlayerStateManager:getInstance():cancelAllOperations()
        end

        TriggerServerEvent('mundpadrao')
    end)
    ]]

    RegisterNetEvent('resetall...', function() 
        
        NewLoadSceneStop()
        ClearFocus()
        clearMinigameSilhouettes()

        DoScreenFadeIn(1000)

        -- SetEntityCoords(PlayerPedId(), 156.95, -965.02, 30.09)
        SetEntityCoords(PlayerPedId(),160.15,-1073.19,29.19)

        FreezeEntityPosition(PlayerPedId(), false)
        RemoveAllPedWeapons(PlayerPedId(), true)

        local playerPed = PlayerPedId()

        -- Restaura alpha normal
        SetEntityAlpha(playerPed, 255, false)
        ResetEntityAlpha(playerPed)
        SetEntityVisible(playerPed, true, false)

        -- Desativa ghost mode
        SetLocalPlayerAsGhost(false)
        SetGhostedEntityAlpha(255)

        -- Remove state de invulnerável (deve ser antes de SetEntityInvincible)
        LocalPlayer["state"]["Invincible"] = false

        -- Remove invulnerabilidade
        SetEntityInvincible(playerPed, false)

        TriggerEvent("Notify:Text", "")

        LocalPlayer["state"]["minigame:active"] = false

        NetworkEndTutorialSession()

        -- Estado global do competitivo (ressurreição / spawn)
        _G.dminigames_competitive = nil

        -- Para ghost/visibilidade de todos os MinigameClient (evita NetworkConceal preso)
        if MinigameInstances then
            for _, client in pairs(MinigameInstances) do
                if client and client.stopVisibilityLoop then
                    client:stopVisibilityLoop()
                end
                if client and client.ghostModeManager then
                    client.ghostModeManager:cleanup()
                end
                if client and client.disableGhostMode then
                    client:disableGhostMode()
                end
                if client and client.alivePlayers then
                    for k in pairs(client.alivePlayers) do client.alivePlayers[k] = nil end
                end
                if client and client.deadPlayers then
                    for k in pairs(client.deadPlayers) do client.deadPlayers[k] = nil end
                end
                if client and client.ghostPlayers then
                    for k in pairs(client.ghostPlayers) do client.ghostPlayers[k] = nil end
                end
                if client and client.stopMatchBinds then
                    client:stopMatchBinds()
                end
                if client and client.gunpopup and client.gunpopup.worker then
                    client.gunpopup:worker(false)
                end
                if client and client.transitionToState then
                    client:transitionToState(MinigameClient.GameState.NONE, 'resetminigame')
                end
            end
        end

        -- Garante visibilidade de todos os players da sessão (não só os que estavam nas listas da partida)
        local myIdx = PlayerId()
        for _, playerIdx in ipairs(GetActivePlayers()) do
            if playerIdx ~= myIdx then
                NetworkConcealPlayer(playerIdx, false, false)
                local ped = GetPlayerPed(playerIdx)
                if DoesEntityExist(ped) then
                    SetEntityVisible(ped, true, false)
                    ResetEntityAlpha(ped)
                    SetEntityCollision(ped, true, true)
                end
            end
        end

        if PlayerStateManager and PlayerStateManager.getInstance then
            PlayerStateManager:getInstance():cancelAllOperations()
        end

        TriggerServerEvent('mundpadrao')
    end)
end

if (scope == 'server') then
    rpc = {}
    vRPC = Tunnel.getInterface('vRP')
    Tunnel.bindInterface(resource, rpc)

    --[[
    function DminigamesCanUseDevCommand(source)
        return true
    end

    local COMPETITIVE_DEV_RANKING_STATS = {
        'comp_points',
        'comp_level',
        'comp_wins',
        'comp_losses',
        'comp_kills',
        'comp_deaths',
        'comp_assists',
        'comp_damage',
        'comp_headshots',
    }

    local function notifyDevCommand(source, color, message)
        if source and source > 0 then
            TriggerClientEvent('Notify', source, color or 'amarelo', message, 5000, 'DMINIGAMES')
        end

        if sx and sx.logger then
            -- sx.logger:info(('[dminigames] %s'):format(message))
        end
    end

    function rpc.canUseDevCommand()
        return DminigamesCanUseDevCommand(source)
    end
    ]]

    RegisterServerEvent('mundpadrao', function()
        local source = source
        Player(source).state:set('minigame:active', false, true)
        exports["vrp"]:ChangePlayerBucket(source, 1)  -- Dimensão 1 = mundo principal
    end)
    --[[
    RegisterCommand('resetcompstats', function(source)
        source = tonumber(source) or 0

        if not (Ranking and Ranking._query and Ranking._columnExists) then
            notifyDevCommand(source, 'vermelho', 'RankingManager indisponivel para limpar as stats do competitivo.')
            return
        end

        local setParts = {}
        for _, statKey in ipairs(COMPETITIVE_DEV_RANKING_STATS) do
            if statKey:match('^comp_') and Ranking:_columnExists(statKey) then
                table.insert(setParts, ('`%s` = 0'):format(statKey))
            end
        end

        if #setParts <= 0 then
            notifyDevCommand(source, 'amarelo', 'Nenhuma coluna competitiva encontrada para limpar.')
            return
        end

        local ok, err = pcall(function()
            Ranking:_query(('UPDATE `dminigames_ranking` SET %s'):format(table.concat(setParts, ', ')), {})
            if Ranking.invalidateLeaderboardCache then
                Ranking:invalidateLeaderboardCache('comp_points')
            end
            if Ranking.refreshLeaderboardCache then
                Ranking:refreshLeaderboardCache('comp_points', {
                    'comp_wins',
                    'comp_losses',
                    'comp_kills',
                    'comp_deaths',
                    'comp_assists',
                    'comp_damage',
                    'comp_headshots',
                    'comp_level',
                })
            end
        end)

        if not ok then
            notifyDevCommand(source, 'vermelho', ('Erro ao limpar stats do competitivo: %s'):format(tostring(err)))
            return
        end

        notifyDevCommand(source, 'verde', 'Stats do competitivo zeradas com sucesso.')
    end)
    ]]

    RegisterCommand('debugall', function(source)
        local source = tonumber(source) or 0
        if source ~= 0 then return end

        TriggerClientEvent('resetall...', -1)
    end)
end
