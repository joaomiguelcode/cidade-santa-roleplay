local Taskbar = Proxy.getInterface( 'inventory/taskbar', 'hovers' )

---@type Minigame | nil
local gActiveMinigame = nil

---@type number | nil
local gActiveMinigameBlipId = nil

---@type boolean
local gRequestStartMinigameLock = false

---@type number
local gRequestCompleteMinigameCooldownEndsAt = 0

---@type number
local gTaskFailureCount = 0

---@type number
local gTaskFailureCooldownEndsAt = 0

---@type number
local MAX_TASK_FAILURE_COUNT = 2

---@type number
local TASK_FAILURE_COOLDOWN_DURATION = 70000

---@return Minigame | nil
function GetActiveMinigame()

    return GetMinigameBySource( GetPlayerServerId( PlayerId() ) )
end

---@param minigame Minigame
---@return eMinigameStartStatus
function OnBeforeMinigameStartedClient( minigame )

    -- print( 'OnBeforeMinigameStartedClient ::' )

    if ( minigame.def.flags & eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK ) ~= 0 then

        -- É necessario fazer um minigame de task antes de iniciar?

        -- Verificar se está em cooldown por falhas
        local currentTime = GetGameTimer()
        if currentTime < gTaskFailureCooldownEndsAt then
            local remainingTime = math.ceil( ( gTaskFailureCooldownEndsAt - currentTime ) / 1000 )
            TriggerEvent( 'Notify2', '#minigame.task.failed', { msg = remainingTime } )
            return eMinigameStartStatus.ERR_MINIGAME_UI_TASK_FAILED
        end

        -- print('OnBeforeMinigameStartedClient :: tasking taskbar')

        if not Taskbar.Task( 1, 20000 ) then

            -- Incrementar contador de falhas
            gTaskFailureCount = gTaskFailureCount + 1

            -- Verificar se atingiu 3 falhas
            if gTaskFailureCount >= MAX_TASK_FAILURE_COUNT then
                -- Aplicar cooldown de 60 segundos
                gTaskFailureCooldownEndsAt = currentTime + TASK_FAILURE_COOLDOWN_DURATION
                gTaskFailureCount = 0
                TriggerEvent( 'Notify2', '#minigame.task.failed', { msg = parseInt(TASK_FAILURE_COOLDOWN_DURATION/1000) } )
            end

            return eMinigameStartStatus.ERR_MINIGAME_UI_TASK_FAILED
        end

        -- Resetar contador de falhas em caso de sucesso
        gTaskFailureCount = 0
    end

    -- print( ('OnMinigameStarted :: minigame.id=%d minigame.def.name="%s"'):format( minigame.id, minigame.def.name ) )

    -- Desabilitar algumas keymappings!
    LocalPlayer.state['Buttons'] = true

    SetFreezePlayerDuringMinigame(minigame, true)

    local timeUntilEnd = ( minigame.startedAtMs + ( minigame.def.duration * 1000 ) ) - GetServerTime() - 300 -- Tempos para que o progress saia +/- na mesma hora que o farm acabada

    -- print('timeUntilEnd', timeUntilEnd, minigame.startedAtMs, minigame.def.duration, GetServerTime() )

    if minigame.def.duration > 0 then

        -- Precisar ser um multiplo de 1000
        TriggerEvent('Progress', 'Mundo', math.ceil( ( timeUntilEnd - 300 ) / 1000 ) * 1000 )
    end

    -- Desabilitar o hoverfy por X segundos
    TriggerEvent( 'hoverfy:removeHoverfy', timeUntilEnd )

    if minigame.def.scriptedInteractionName then

        exports.scripted_interactions:startScriptedInteraction( minigame.def.scriptedInteractionName )
    end

    return eMinigameStartStatus.OK
end

---@param minigame Minigame
function OnMinigameAddedClient( minigame )

    local volumePos = minigame.volumeDef.volume.coords

    local blipId = AddBlipForCoord( volumePos.x, volumePos.y, volumePos.z )

    gActiveMinigameBlipId = blipId

	SetBlipSprite( blipId, 1 )
	SetBlipColour( blipId, 5 )
	SetBlipScale( blipId, 0.6 )
	SetBlipAsShortRange( blipId, false )
	SetBlipRoute( blipId, true )
	BeginTextCommandSetBlipName( "STRING" )
	AddTextComponentString( minigame.def.displayName )
	EndTextCommandSetBlipName(blipId )
end

---@param minigame Minigame
function OnMinigameRemovedClient( minigame )
    RemoveBlip( gActiveMinigameBlipId )

    SetFreezePlayerDuringMinigame(minigame, false)

    gActiveMinigameBlipId = nil
end

---@param minigame      Minigame
---@param keepAnimation boolean
function OnMinigameDeletedClient( minigame, keepAnimation )

    -- print( ('OnMinigameDeletedClient :: minigame.id=%d minigame.def.name="%s" keepAnimation=%s'):format( minigame.id, minigame.def.name, keepAnimation ) )

    -- MinigameUpdate vai parar quando o minigame for invalidado pelo DeleteMinigame()

    LocalPlayer.state['Buttons'] = false

    TriggerEvent( 'Notify:Text', '' )

    TriggerEvent( 'Progress', 'Cancelando', 0 )

    -- Reativar o hoverfy
    TriggerEvent( 'hoverfy:returnHoverfy' )

    if not keepAnimation and minigame.def.scriptedInteractionName then

        if exports.scripted_interactions:isRunningScriptedInteraction( minigame.def.scriptedInteractionName ) then

            exports.scripted_interactions:stopScriptedInteraction({ interactionName = minigame.def.scriptedInteractionName })
        end
    end

    if minigame.def.flags & eMinigameDefFlags.MDF_FLAG_PLAYER_INVINCIBLE ~= 0 then
        SetLocalPlayerAsGhost(false)

        LocalPlayer.state['Invincible'] = false
        SetEntityInvincible(PlayerPedId(), false)
    end

    if minigame.def.flags & eMinigameDefFlags.MDF_FLAG_COLLISION_ENTITIES ~= 0 then
        OnToggleCollisionEntities(true)
    end
end

---@param minigameDef MinigameDef
function IsAllowedMinigameDef( minigameDef )

    if minigameDef.isAllowed then

        if minigameDef.isAllowed.groups then

            for _, groupName in ipairs( minigameDef.isAllowed.groups ) do

                if LocalPlayer.state[ 'Job' ] == groupName then

                    return true
                end
            end
        end

        return false
    end

    return true
end

---@param minigame Minigame
---@return eMinigameStartStatus
function CanStartMinigameClient( minigame )

    -- O jogador está proximo do ponto de minigame?
    if not IsPositionInsideMinigameVolume( minigame.volumeDef.volume, GetEntityCoords( PlayerPedId() ) ) then

        -- Longe demais do ponto!

        return eMinigameStartStatus.ERR_MINIGAMEPOINT_TOO_FAR
    end

    if not IsAllowedMinigameDef( minigame.def ) then

        -- TODO: Better error
        return eMinigameStartStatus.ERR_DUPLICATE_REQUEST
    end

    return eMinigameStartStatus.OK
end

---@param volumeDef MinigameVolumeDef
---@return boolean
function CanCreateMinigameClient( volumeDef )

    local minigameDef = MINIGAME_DEF_DATABASE[ volumeDef.minigameDefIndex ]

    if not IsAllowedMinigameDef( minigameDef ) then

        -- print('is allowed')

        return false
    end

    if GetActiveMinigame() then

        -- print('has active minigame')

        return false
    end

    if ( minigameDef.flags & eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT ) ~= 0 then

        -- print('flag only')

        return false
    end

    return true
end

--[[
---@param minigamePoint MinigamePoint
---@return boolean
function RequestCreateMinigame( minigamePoint )

    -- print( 'RequestCreateMinigame :: minigamePoint=', minigamePoint.minigameDefIndex, minigamePoint.index, minigamePoint.volume.coords )

    ---@type eMinigameCreateStatus, MinigameId
    local status, minigameId = lib.callback.await( 'minigame:request_create', false, minigamePoint.minigameDefIndex, minigamePoint.index )

    -- print( 'RequestCreateMinigame :: status=', status, minigameId )

    if status ~= eMinigameCreateStatus.OK then

        local statusMessage = GetMinigameCreateStatusMessage( minigamePoint, status ) or 'NOSTATUS'

        TriggerEvent( 'Notify', 'vermelho', statusMessage, 5000, 'Minigames' )

        return false
    end

    local minigame = CreateMinigame( minigamePoint, minigameId, GetPlayerServerId( PlayerId() ) )

    AddMinigame( minigame )

    OnMinigameCreated( minigame )

    return true
end
--]]

---@class CreateMinigameParams
---@field minigameDefIndex number
---@field volumeLocalIdx number

---@param params CreateMinigameParams
---@return boolean
function RequestCreateMinigameFromVolume( params )

    local minigameDefIndex = params.minigameDefIndex
    local volumeLocalIdx = params.volumeLocalIdx

    local minigameDef = MINIGAME_DEF_DATABASE[ minigameDefIndex ]

    assert( minigameDef, ('MinigameDef not found with minigameDefIndex=%s!'):format( minigameDefIndex ) )

    local volumeDef = minigameDef.volumes[ volumeLocalIdx ]

    assert( volumeDef, ('MinigameVolumeDef not found with minigameDefIndex=%s and volumeLocalIdx=%s!'):format( minigameDefIndex, volumeLocalIdx ) )

    local status, minigameId = lib.callback.await('minigame:request_create_from_volume', false, minigameDefIndex, volumeLocalIdx )

    if status ~= eMinigameCreateStatus.OK then

        TriggerEvent( 'Notify', 'vermelho', GetMinigameCreateStatusMessage( minigameDef, status ), 5000, 'Minigames' )

        return false
    end

    assert( minigameId, 'SendStartMinigameRequest returned an invalid minigameId' )

    local minigame = CreateMinigame( minigameDef, volumeDef, minigameId, GetPlayerServerId(PlayerId()) )

    -- O minigame ja é valido nesse momento
    -- então é necessário adicionar ele a lista de minigames para poder ser deletado caso necessario
    AddMinigame( minigame )

    StartMinigame( minigame )

    OnMinigameCreated( minigame )
end

---@param minigame Minigame
---@return boolean
function RequestStartMinigame( minigame )

    if gRequestStartMinigameLock then
        return
    end

    gRequestStartMinigameLock = true

    ---@type eMinigameStartStatus
    local status = lib.callback.await( 'minigame:request_start', false )

    -- print('RequestStartMinigame -> status=', status)

    if status == eMinigameStartStatus.OK then
        StartMinigame( minigame )
    end

    gRequestStartMinigameLock = false

    return status == eMinigameStartStatus.OK
end

--[[
---@param minigamePoint MinigamePoint
---@param status   eMinigameStartStatus
---@return string
local function GetMinigameStartStatusMessage( minigamePoint, status )

    if      status == eMinigameStartStatus.ERR_DUPLICATE_REQUEST then

        return 'Request duplicado'

    elseif  status == eMinigameStartStatus.ERR_NOT_ALLOWED then

        return 'Você não tem permissão para iniciar esse minigame!'

    elseif  status == eMinigameStartStatus.ERR_MINIGAMEPOINT_NOT_FOUND then

        return ('Error interno, contate a staff! ref( %s, %s )'):format( minigamePoint.minigameDefIndex, minigamePoint.index )

    elseif status == eMinigameStartStatus.ERR_MINIGAMEPOINT_TOO_FAR then

        return ('Você está longe demais da area do(a) %s!'):format( minigamePoint.minigameDef.displayName:upper() )

    elseif status == eMinigameStartStatus.ERR_REQUIREMENTS_NOT_MET then

        return 'Você não possui os itens necessários para iniciar o minigame!'

    elseif status == eMinigameStartStatus.ERR_MINIGAME_DUPLICATE_FOUND then


        return 'Você já está em um minigame!'

    elseif status == eMinigameStartStatus.ERR_MINIGAME_UI_TASK_FAILED then

        return 'Você falhou!'

    elseif status == eMinigameStartStatus.ERR_INVENTORY_FULL then

        return 'Não é possivel iniciar o minigame pois seu inventário está cheio!'
    else

        return ('UNHANDLED eMinigameStartStatus "%s"!'):format( status )
    end
end
--]]

--[[
---@param minigamePoint MinigamePoint
function RequestCreateAndStartMinigame( minigamePoint )

    assert( minigamePoint.minigameDef.flags & eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT == 0, ( 'Minigame "%s" só pode ser criado por outros scripts!' ):format( minigamePoint.minigameDef.displayName ) )

    ---@type eMinigameCreateStatus, MinigameId
    local status, minigameId = lib.callback.await( 'minigame:request_create_and_start', false, minigamePoint.minigameDefIndex, minigamePoint.index )

    if status ~= eMinigameCreateStatus.OK then

        TriggerEvent( 'Notify', 'vermelho', GetMinigameCreateStatusMessage( minigamePoint, status ), 5000, 'Minigames' )

        return false
    end

    assert( minigameId, 'SendStartMinigameRequest returned an invalid minigameId' )

    local minigame = CreateMinigame( minigamePoint, minigameId, GetPlayerServerId( PlayerId() ) )

    -- O minigame ja é valido nesse momento
    -- então é necessário adicionar ele a lista de minigames para poder ser deletado caso necessario
    AddMinigame( minigame )

    StartMinigame( minigame )

    OnMinigameCreated( minigame )
end
--]]

---@param minigame Minigame
function RequestEndMinigame( minigame )

    if not DeleteMinigame( minigame, false ) then
        return
    end

    -- Notificar o servidor que o minigame terminou!
    --
    -- ( Isso daqui precisa ser um callback? )
    lib.callback.await( 'minigame:end', false )
end

local COOLDOWN_REQUEST_COMPLETE_MINIGAME = 3000

---@param minigame Minigame
---@return boolean
function RequestCompleteMinigame( minigame )
    local currentTime = GetGameTimer()

    if currentTime < gRequestCompleteMinigameCooldownEndsAt then
        return false
    end

    gRequestCompleteMinigameCooldownEndsAt = currentTime + COOLDOWN_REQUEST_COMPLETE_MINIGAME

    ---@type eMinigameCompleteStatus
    local status = lib.callback.await( 'minigame:request_complete', false )

    if status == eMinigameCompleteStatus.ERR_CUSTOM_MESSAGE then 
        return
    end

    assert( status )

    if
        status ~= eMinigameCompleteStatus.OK            and
        status ~= eMinigameCompleteStatus.OK_RESETING
    then

        -- Não foi possivel completar o minigame, vamos notificar o jogador o motivo...

        local statusMessage = GetMinigameCompleteStatusMessage( status ) or 'NOSTATUS'

        if statusMessage ~= '' then
            TriggerEvent( 'Notify', 'vermelho', statusMessage, 5000, 'Minigames' )
        end

        if
            status == eMinigameCompleteStatus.ERR_INVENTORY_FULL        or
            status == eMinigameCompleteStatus.ERR_REQUIREMENTS_NOT_MET
        then

            -- Não tem espaço no inventário ou não tem os items necessários
            -- para completar o minigame, os dois status são "panico", que força
            -- a ter que finalizar o minigame imediatamente!
            --
            -- se não vai causar um loop infinito de request

            RequestEndMinigame( minigame )
        end

        return false
    end

    -- #
    -- Caso o status seja "OK_RESTARTING", nós ainda vamos deletar
    -- o minigame no client, e o server será encarregado de pedir para
    -- que o client re-crie o minigame com o mesmo id.
    -- #

    -- Manter a animação do minigame atual
    -- para o novo minigame que será criado?
    --
    -- Isso evita problema visual ao cancelar
    -- e começar a mesma animação novamente.

    if status == eMinigameCompleteStatus.OK_RESETING then

        return
    end

    -- Caso esse tipo de minigame seja em loop, vamos tentar outro minigame do mesmo tipo!
    if not DeleteMinigame( minigame, false ) then

        -- O minigame sempre deve ser deletado com sucesso aqui, mas caso não seja, só vamos ignorar...

        -- print( ('CompleteMinigame :: not deleted!') )

        return false
    end

    return true
end

--[[
---@param minigameId         MinigameId
---@param minigameDefIndex   number
---@param minigamePointIndex number
---@param isStarted?         boolean
RegisterNetEvent( 'minigame:created_by_server', function( minigameId, minigameDefIndex, minigamePointIndex, isStarted )

    -- Nesse ponto, o minigame foi deletado pelo "CompleteMinigame"
    -- e será recriado com o mesmo minigameId e possivelmente outros dados
    -- como minigamePoint, etc...
    -- não é feita nenhuma validação aqui pois elas já foram feitas pelo servidor.

    print( ('minigame:created_by_server =>'), minigameId, minigameDefIndex, minigamePointIndex)

    local minigamepoint = CreateMinigamePoint( minigameDefIndex, minigamePointIndex )

    assert( minigamepoint )

    local minigame = CreateMinigame( minigamepoint, minigameId, GetPlayerServerId( PlayerId() ) )

    AddMinigame( minigame )

    OnMinigameCreated( minigame )
end)
--]]

---@param packet NetworkMinigameResetEvent
RegisterNetEvent( 'minigame:reseted_by_server', function( packet )

    -- print( 'minigame:reseted_by_server :: packet=', json.encode( packet, { indent = true } ) )

    local minigame = GetActiveMinigame()

    -- print( 'minigame:reseted_by_server', packet.minigameId, packet.volumeLocalIdx )

    assert( minigame )

    assert( minigame.id == packet.minigameId )

    -- Resetar horario de inicio, etc...
    ResetMinigameState( minigame, packet.startedAtMs )

    if packet.hasVolumeChanged then

        local volumeDef = minigame.def.volumes[ packet.newVolumeLocalIdx ]

        assert( volumeDef, ('MinigameVolumeDef not found with minigameDefIndex=%s and index=%s !'):format( minigame.def.index, packet.newVolumeLocalIdx ) )

        minigame.volumeDef = volumeDef
    end

    OnMinigameRemovedClient( minigame )

    -- Recriar blips
    OnMinigameAddedClient( minigame )

    if packet.startAutomatically then

        StartMinigame( minigame )
    end

    -- print( 'minigame:reseted_by_server :: minigame.point.index=', minigame.volumeDef.volumeLocalIdx )
end)

---Evento executado quando o servidor cria um minigame e
---o client tem 0 noção de que esse minigame foi criado!
---@param packet NetworkMinigameCreatedEvent
RegisterNetEvent( 'minigames.minigame_created', function( packet )

    -- print( 'minigames.minigame_created :: packet=', json.encode( packet, { indent = true } ) )

    local minigameDef = MINIGAME_DEF_DATABASE[ packet.minigameDefIndex ]

    assert( minigameDef, ('MinigameDef not found with index=%s !'):format( packet.minigameDefIndex ) )

    ---@type MinigameVolumeDef
    local volumeDef = nil

    if packet.isTempVolume then

        ---@type SphereMinigameVolumeDef
        volumeDef =
        {
            type = eMinigameVolumeType.Sphere,

            index = MINIGAMEVOLUME_DEF_TEMPORARY_INDEX,
            localIndex = MINIGAMEVOLUME_DEF_TEMPORARY_INDEX,
            volume = nil,
            minigameDefIndex = packet.minigameDefIndex, 

            coords = GetEntityCoords( PlayerPedId() ),
            radius = minigameDef.duration
        }

        volumeDef.volume = CreateMinigameVolume( minigameDef, volumeDef )
    else

        volumeDef = minigameDef.volumes[ packet.volumeLocalIndex ]

        assert( volumeDef, ('MinigameVolumeDef not found with minigameDefIndex=%s and index=%s !'):format( packet.minigameDefIndex, packet.volumeLocalIndex ) )
    end

    local minigame = CreateMinigame( minigameDef, volumeDef, packet.minigameId, GetPlayerServerId( PlayerId() ) )

    AddMinigame( minigame )

    StartMinigame( minigame, packet.startedAtMs )

    OnMinigameCreated( minigame )

    -- sx.logger:info( 'minigames.minigame_created :: minigame.id=', minigame.id )
end)

---@param variation 'North' | 'South'
AddEventHandler('routes:NPCStart', function( variation )

    if GetActiveMinigame() then

        RequestEndMinigame( GetActiveMinigame() )
    end

    local minigameDefSuffix = string.lower( variation )

    for _, volumeDef in ipairs( gMinigameVolumeDefs ) do

        local minigameDef = MINIGAME_DEF_DATABASE[ volumeDef.minigameDefIndex ]

        if minigameDef.name:find( 'minigame_routes' ) and minigameDef.name:find( minigameDefSuffix ) then

            if IsAllowedMinigameDef( minigameDef ) then

                print('volumeDef', volumeDef.localIndex)

                RequestCreateMinigameFromVolume({ minigameDefIndex = minigameDef.index, volumeLocalIdx = volumeDef.localIndex })

                break
            end
        end
    end
end)

AddEventHandler('actions:Cancel', function()
    -- Ao pressionar o botão de cancelar (F6)

    local minigame = GetActiveMinigame()
    
    if not minigame then
        return
    end

    RequestEndMinigame( minigame )
end)

AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStopped', function( interactionName )

    local minigame = GetActiveMinigame()

    if not minigame then
        return
    end

    if minigame.def.scriptedInteractionName ~= interactionName then
        return
    end

    RequestEndMinigame( minigame )
end)
