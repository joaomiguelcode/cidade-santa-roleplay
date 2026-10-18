--- TODO: Remover quando a VRP REINICIAR!
IS_SERVER = GetGameName() == 'fxserver'
IS_CLIENT = not IS_SERVER

GetServerTime =
    GetGameName() == 'fxserver'
        and GetGameTimer
        or  GetNetworkTimeAccurate

---@enum eMinigameCreateStatus
---@diagnostic disable-next-line: lowercase-global
eMinigameCreateStatus =
{
    OK = 0,

    ERR = 10,
    ERR_NOT_ALLOWED = 11,
    ERR_MINIGAMEPOINT_TOO_FAR = 12,
    ERR_REQUIREMENTS_NOT_MET = 13,
    ERR_MINIGAME_DUPLICATE_FOUND = 14,
    ERR_INVENTORY_FULL = 15,
}

---@param minigameDef MinigameDef
---@param status        eMinigameCreateStatus
---@return string | nil
function GetMinigameCreateStatusMessage( minigameDef, status )

    -- print('GetMinigameCreateStatusMessage', minigameDef, status, minigameDef)

    if      status == eMinigameCreateStatus.ERR then

        return _t("minigame_status_duplicate_request")

    elseif  status == eMinigameCreateStatus.ERR_NOT_ALLOWED then

        return _t("minigame_status_not_allowed")

    elseif  status == eMinigameCreateStatus.ERR_MINIGAMEPOINT_TOO_FAR then

        return _t("minigame_status_point_too_far"):format( minigameDef.displayName )

    elseif  status == eMinigameCreateStatus.ERR_REQUIREMENTS_NOT_MET then

        local requirementsItemsTexts = table
            .map( minigameDef.requirements.items, function( item )

                local itemName = itemName( item.id )

                return ('%dx %s'):format( item.amount, itemName )
            end)

        local requirementsItemsText = table.concat( requirementsItemsTexts, ' e ' )

        return _t("minigame_status_requirements_not_met"):format( requirementsItemsText )

    elseif status == eMinigameCreateStatus.ERR_MINIGAME_DUPLICATE_FOUND then    

        return _t("minigame_status_duplicate_found")

    elseif status == eMinigameCreateStatus.ERR_INVENTORY_FULL then

        return _t("minigame_status_inventory_full")

    else

        return ('UNHANDLED eMinigameCreateStatus "%s"!'):format( status )
    end
end

---@enum eMinigameStartStatus
---@diagnostic disable-next-line: lowercase-global
eMinigameStartStatus =
{
    OK = 0,

    ERR_DUPLICATE_REQUEST = 1,
    ERR_NOT_ALLOWED = 2,

    ERR_MINIGAMEPOINT_NOT_FOUND = 10,
    ERR_MINIGAMEPOINT_TOO_FAR = 11,

    ERR_REQUIREMENTS_NOT_MET = 12,

    ERR_MINIGAME_DUPLICATE_FOUND = 20,
    ERR_MINIGAME_UI_TASK_FAILED = 21,

    ERR_INVENTORY_FULL = 30,
}

---@alias MinigameId number

---@class MinigameContext
---@field hostPartyNumMembers number

---@class MinigameHooks
---@field onCompleted? fun()
---@field canComplete? fun(): boolean

---@class Minigame
---@field def            MinigameDef
---@field isValid        boolean
---@field id             MinigameId
---@field hostedBySource Source
---@field hostedByPassport Passport | nil
---@field hostedByJobGroup string | nil
---@field originalRoutingBuckets? table<Source, number>
---@field startedAtMs    number     -- local gametime!
---@field enterAtMs      number     -- local gametime!
---@field isProtectionActive boolean
---@field rewards        MinigameRewards
---@field isStarted      boolean
---@field ctx            MinigameContext
---@field hooks          MinigameHooks
---@field volumeDef      MinigameVolumeDef
---@field computeRewardsConfig MinigameComputeRewardsConfig

---@type table<Source, Minigame>
local gMinigameBySource = { }

---@param source Source
---@return Minigame | nil
function GetMinigameBySource( source )

    return gMinigameBySource[ source ]
end

-- TODO:: Remover quando melhorarmos o sx!
while not (sx and sx.packethandler) do
    Wait( 50 )
end

NetworkMinigameCreatedEvent = sx.packethandler.register(
    ---@class NetworkMinigameCreatedEvent
    ---@field minigameId MinigameId
    ---@field minigameDefIndex number
    ---@field startedAtMs number
    ---@field isTempVolume boolean
    ---@field volumeLocalIndex number
    --@field tempVolumePos vector3
    --@field tempVolumeRadius number

    ---@param data NetworkMinigameCreatedEvent
    function( s, data )

        s( data.minigameId )
        s( data.minigameDefIndex )
        s( data.startedAtMs )

        s( data.isTempVolume )

        if not data.isTempVolume then

            s( data.volumeLocalIndex )

        -- else

        --     s( data.tempVolumePos )
        --     s( data.tempVolumeRadius )
        end
    end
, false )

NetworkMinigameResetEvent = sx.packethandler.register(
    ---@class NetworkMinigameResetEvent
    ---@field minigameId MinigameId
    ---@field hasVolumeChanged boolean
    ---@field newVolumeLocalIdx number
    ---@field startAutomatically boolean
    ---@field startedAtMs number
    
    ---@param data NetworkMinigameResetedEvent
    function( s, data )

        s( data.minigameId ) 

        s( data.hasVolumeChanged )

        if data.hasVolumeChanged then

            s( data.newVolumeLocalIdx )
        end

        s( data.startedAtMs )

        s( data.startAutomatically )
    end
, false )

---@param minigame Minigame
function AddMinigame( minigame )

    -- Marcar o minigame como valido novamente, já que ele foi invalidado assim que terminou
    minigame.isValid = true

    gMinigameBySource[ minigame.hostedBySource ] = minigame

    -- print( 'AddMinigame :: IS_SERVER=', IS_SERVER, 'IS_CLIENT=', IS_CLIENT )

    if     IS_SERVER then

        -- if not minigame.clientIsAck then

        --     local packet = NetworkMinigameCreatedEvent({
        --         minigameId = minigame.id,
        --         minigameDefIndex = minigame.def.index,
        --         minigamePointDefIndex = minigame.point.index,
        --     })

        --     TriggerClientEvent( 'minigames.minigame_created', minigame.hostedBySource, packet )
        -- end

        OnMinigameAddedServer( minigame )

    elseif IS_CLIENT then

        OnMinigameAddedClient( minigame )
    end
end

---@param minigame Minigame
local function RemoveMinigame( minigame )

    minigame.isValid = false

    gMinigameBySource[ minigame.hostedBySource ] = nil

    if     IS_SERVER then

        OnMinigameRemovedServer( minigame )
    elseif IS_CLIENT then

        OnMinigameRemovedClient( minigame )
    end
end

---@param minigameDef MinigameDef
---@param volumeDef  MinigameVolumeDef
---@param minigameId     MinigameId
---@param hostedBySource Source
---@param clientIsAck? boolean
---@return Minigame
function CreateMinigame( minigameDef, volumeDef, minigameId, hostedBySource, clientIsAck )

    clientIsAck = clientIsAck == nil and true or clientIsAck

    ---@type Minigame
    local minigame =
    {
        def = minigameDef,

        volumeDef = volumeDef,

        isValid = false,

        id = minigameId,

        hostedBySource = hostedBySource,

        hostedByPassport = IS_SERVER and vRP.Passport( hostedBySource ) or nil,

        hostedByJobGroup = IS_SERVER and vRP.UserGroupByType( vRP.Passport( hostedBySource ), 'Job' ) or nil,

        startedAtMs = math.maxinteger,
        enterAtMs = GetServerTime(),

        isProtectionActive = false,

        rewards =
        {
            items      = { },
            currencies = { },
        },

        isStarted = false,

        ctx = { },

        hooks = { },

        clientIsAck = clientIsAck,

        computeRewardsConfig = { rewardAmountMultiplier = 1.0, buffs = { } }
    }

    return minigame
end

---@param minigame      Minigame
---@param keepAnimation boolean
---@return boolean
function DeleteMinigame( minigame, keepAnimation )

    -- print( ('DeleteMinigame :: minigame.id=%d minigame.def.name="%s" keepAnimation=%s'):format( minigame.id, minigame.def.name, keepAnimation ), minigame.isValid, debug.traceback() )
    -- print(debug.traceback())

    if not minigame.isValid then
        return false
    end

    RemoveMinigame( minigame )

    if IS_CLIENT then

        OnMinigameDeletedClient( minigame, keepAnimation )
    end

    if minigame.volumeDef.index == MINIGAMEVOLUME_DEF_TEMPORARY_INDEX then

        minigame.volumeDef.volume:remove()

    end

    return true
end

---@param minigame Minigame
function ResetMinigameState( minigame )

    -- print('ResetMinigameState :: minigame.startedAtMs=', minigame.startedAtMs)

    minigame.isStarted = false

    minigame.startedAtMs = math.maxinteger

    table.wipe( minigame.rewards.items      )
    table.wipe( minigame.rewards.currencies )

    if minigame.computeRewardsConfig then

        minigame.computeRewardsConfig.rewardAmountMultiplier = 1.0
        table.wipe( minigame.computeRewardsConfig.buffs                  )
    end
end

---@param minigame Minigame
---@param startedAtMs? number
function StartMinigame( minigame, startedAtMs )

    assert( not minigame.isStarted )

    startedAtMs = startedAtMs or GetServerTime()

    minigame.startedAtMs = startedAtMs

    if IS_CLIENT then
        -- Fazer alguns outros processamentos antes de realmente iniciar o minigame!
        local status = OnBeforeMinigameStartedClient( minigame )

        -- print('StartMinigame :: OnBeforeStartMinigameClient.status=',status )

        if status ~= eMinigameStartStatus.OK then

            RequestEndMinigame( minigame )

            return status
        end
    end

    minigame.isStarted = true
end

---@param volume MinigameVolume
---@param position      vector3
---@return boolean
function IsPositionInsideMinigameVolume( volume, position )

    return volume:contains( position )
end

---@param minigame Minigame
---@return number
function GetMinigameMillisecondsUntilCompletionTimeReached( minigame )

    return ( minigame.startedAtMs + ( minigame.def.duration * 1000 ) ) - GetServerTime()
end

---O minigame já chegou no tempo de término?
---@param minigame Minigame
---@return boolean
function HasMinigameReachedCompletionTime( minigame )

    -- print( 'HasMinigameReachedCompletionTime( minigame )', GetServerTime(), minigame.startedAtMs, minigame.def.duration  )

    return GetMinigameMillisecondsUntilCompletionTimeReached( minigame ) <= 0
end

---@enum eMinigameCompleteStatus
---@diagnostic disable-next-line: lowercase-global
eMinigameCompleteStatus =
{
    OK = 0,
    OK_RESETING = 2,

    ERR = 10,
    ERR_MINIGAME_NOT_FOUND = 11,
    ERR_MINIGAME_NOT_VALID = 12,
    ERR_MINIGAME_NOT_STARTED = 13,
    ERR_MINIGAME_COMPLETION_TIME_NOT_REACHED = 14,
    ERR_MINIGAME_TOO_FAR = 15,
    ERR_REQUIREMENTS_NOT_MET = 16,

    ERR_INVENTORY_FULL = 20,
    ERR_CUSTOM_MESSAGE = 21
}

---@param status eMinigameCompleteStatus
---@return string | nil
function GetMinigameCompleteStatusMessage( status )

    if status == eMinigameCompleteStatus.ERR_MINIGAME_NOT_FOUND then

        return 'Você não está em um minigame!'

    elseif status == eMinigameCompleteStatus.ERR_MINIGAME_NOT_VALID then

        return 'Esse minigame já foi encerrado!'

    elseif status == eMinigameCompleteStatus.ERR_MINIGAME_COMPLETION_TIME_NOT_REACHED then

        return 'Você ainda não completou totalmente esse minigame!'

    elseif status == eMinigameCompleteStatus.ERR_MINIGAME_TOO_FAR then

        return 'Você está longe do ponto de minigame!'

    elseif status == eMinigameCompleteStatus.ERR_INVENTORY_FULL then

        return 'Você não tem espaço suficiente no inventário!'

    elseif status == eMinigameCompleteStatus.ERR_REQUIREMENTS_NOT_MET then

        return 'Você não possui os itens necessários para completar o minigame!'

    elseif status == eMinigameCompleteStatus.ERR then

        return 'Não foi possivel completar o minigame!'

    elseif status == eMinigameCompleteStatus.ERR_CUSTOM_MESSAGE then
        return ''
    end

    return nil
end

---@param minigame Minigame
---@return eMinigameCompleteStatus
function CanCompleteMinigame( minigame )
    if not minigame.isValid then

        -- Minigame já foi deletado!

        return eMinigameCompleteStatus.ERR_MINIGAME_NOT_VALID
    end

    if not minigame.isStarted then

        return eMinigameCompleteStatus.ERR_MINIGAME_NOT_STARTED
    end

    if not HasMinigameReachedCompletionTime( minigame ) then

        -- Minigame ainda não terminou!

        return eMinigameCompleteStatus.ERR_MINIGAME_COMPLETION_TIME_NOT_REACHED
    end

    -- local skipDistanceChecks = minigame.def.flags & eMinigameDefFlags.MDF__ON_COMPLETE__GOTO_NEXT_MINIGAME_POINT ~= 0

    -- print('CanCompleteMinigame :: minigame.volumeDef.volume', minigame.def.flags & eMinigameDefFlags.MDF__ON_COMPLETE__GOTO_NEXT_MINIGAME_POINT)

    if not IsPositionInsideMinigameVolume(
            minigame.volumeDef.volume,
            GetEntityCoords(
                IS_CLIENT
                    and PlayerPedId()
                    or GetPlayerPed( minigame.hostedBySource )
                )
            )
    then
        return eMinigameCompleteStatus.ERR_MINIGAME_TOO_FAR
    end

    if IS_SERVER then
        if minigame.hooks.canComplete and not minigame.hooks.canComplete() then
            return eMinigameCompleteStatus.ERR_CUSTOM_MESSAGE
        end

        if not HasMinigameDefRequirements( minigame.def, minigame.hostedByPassport ) then
            return eMinigameCompleteStatus.ERR_REQUIREMENTS_NOT_MET
        end
    end

    return eMinigameCompleteStatus.OK
end
--

AddEventHandler( 'onResourceStop', function ( resourceName )

    if resourceName == GetCurrentResourceName() then

        for _, minigame in pairs( gMinigameBySource ) do

            DeleteMinigame( minigame, false )
        end
    end
end)
