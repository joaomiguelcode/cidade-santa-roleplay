---@enum ePlayerAttachmentState
local ePlayerAttachmentState =
{
    Ok = 0,

    Err = 1,

    ErrDead = 2,

    ErrPendingAttachmentTimeout = 5,

    ErrOtherPlayerInvalid     = 10,
    ErrOtherPlayerInvalidPed  = 11,
    ErrOtherPlayerNotAttached = 12,
    ErrOtherPlayerTooFar      = 13,

    -- "Causado" pelo servidor por dar clear no attachment pós já ter aplicado attachment
    ErrServerDetachment = 20,
    ErrServerPendingAttachmentAborted = 21,
}


-- Configuration for error handling (time-based to avoid frame spam)
local ERROR_THRESHOLD = 3 -- Number of consecutive errors before triggering
local ERROR_WINDOW_MS = 300 -- Time window to count consecutive errors (300ms)

---@type PlayerAttachment | nil
local gPlayerAttachment = nil

--[[
ASCII representation of the error window logic:

The system uses a fixed-start time window to tolerate short bursts of errors.

Time (ms):   0    50    100   150   200   250   300   350
             |.....|.....|.....|.....|.....|.....|.....|
Event:      E1          E2          E3          (OK)
Window:     [---------- 300ms Window Starts ----------]
Count:      1           2           3             0 (resets)
Trigger:                            ✓

Legend:
- E1, E2, E3: Errors occurring.
- (OK): A successful tick with no errors.
- Window: A 300ms timer that starts ONLY on the first error (E1).
- Count: Number of errors that occur within the 300ms window.
- Trigger: Action is taken if the error count reaches the threshold (3) within the window.
- Reset: If the 300ms window expires, the error count is reset to 0 on the next successful tick. The window start time is NOT reset until the entire attachment is cleared.

Key Behavior:
1.  **Window Starts on First Error**: A 300ms countdown begins the moment the first error is detected after an attachment is created.
2.  **Burst Tolerance**: Any errors within this 300ms window are counted. If the count hits the threshold (3), the error is triggered.
3.  **Count Reset**: If the 300ms window passes without the threshold being met, the error count is reset to 0.
4.  **One-Shot Window**: The window's start time is locked to the first error. Subsequent errors that occur after the initial window has expired will NOT start a new window and are unlikely to trigger a detachment, making the system tolerant of later, isolated issues.
--]]

-- Generic error tracking for all attachment errors
local gPlayerAttachmentErrorCount = 0
local gPlayerAttachmentErrorCountResetAt = nil

---@type TickAbortSignal | nil
local gProcessPlayerAttachmentTickAbortSignal = nil

local function GetLocalPlayerAttachmentState()

    -- print( ('GetLocalPlayerAttachmentState -> LOCALPLAYER_SOURCE=%s sx.player.attachment.getAttachmentState( LOCALPLAYER_SOURCE )=%s'):format( LOCALPLAYER_SOURCE, json.encode( sx.player.attachment.getAttachmentState( LOCALPLAYER_SOURCE ) ) ) )

    return sx.player.attachment.getAttachmentState( LOCALPLAYER_SOURCE )
end

---@return boolean
local function HasLocalPlayerAttachment()

    return gPlayerAttachment ~= nil
end

---@return PlayerAttachment
local function GetLocalPlayerAttachment()

    assert( HasLocalPlayerAttachment() )

    return gPlayerAttachment
end

---@param attachmentState NetworkPlayerAttachmentState
local function SetLocalPlayerAttachmentState( attachmentState )

    sx.player.attachment.setAttachmentState( LOCALPLAYER_SOURCE, attachmentState )
end

local function ClearLocalPlayerIsPendingAttachmentStateFlag()

    local attachmentState = GetLocalPlayerAttachmentState()

    assert( attachmentState, 'attachmentState is nil' )

    attachmentState[ 3 ] &= ~ePlayerAttachmentFlags.IsPending

    SetLocalPlayerAttachmentState( attachmentState )
end

---@return boolean
local function IsLocalPlayerAttached()

    if not HasLocalPlayerAttachment() then

        return false
    end

    local attachment = GetLocalPlayerAttachment()

    if attachment.relationKind ~= ePlayerAttachmentRelationKind.Child then

        return false
    end

    return true
end

local NOCLIP_STATEBAG_KEY = 'psnc'
local ATTACHMENT_COLLISION_SUPPRESSED_STATEBAG_KEY = 'attachment-collision-suppressed'

local function ResetLocalPlayerPedPhysicsAfterCarry()

    if LocalPlayer.state[NOCLIP_STATEBAG_KEY] then
        return
    end

    LocalPlayer.state:set(ATTACHMENT_COLLISION_SUPPRESSED_STATEBAG_KEY, false, false)

    CreateThread(function()

        local pedId = PlayerPedId()

        FreezeEntityPosition(pedId, true)

        for _ = 1, 20 do

            if not DoesEntityExist(pedId) then
                return
            end

            SetLocalPlayerAsGhost(false)
            SetPedCanRagdoll(pedId, true)

            local coords = GetEntityCoords(pedId)

            RequestCollisionAtCoord(coords.x, coords.y, coords.z)

            SetEntityCollision(pedId, true, true)

            local found, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z + 2.0, false)

            if found then
                SetEntityCoords(pedId, coords.x, coords.y, groundZ + 0.05, false, false, false, false)
            end

            Wait(0)
        end

        FreezeEntityPosition(pedId, false)
    end)
end

local function DetachLocalPlayer()

    local attachment = GetLocalPlayerAttachment()

    assert(attachment.relationKind == ePlayerAttachmentRelationKind.Child)

    DetachEntity(PlayerPedId())

    SetPlayerControl(PlayerId(), true, 0)

    ResetPlayerInputGait(PlayerId())
end

---@param attachment PlayerAttachment
---@return string, string, number
local function GetPlayerAttachmentAnimation( attachment )

    local animDict = nil
    local animName = nil
    local animFlags = 0 --[[ eAnimationFlags.AF_DEFAULT ]]

    -- print( 'attachment.flags', attachment.flags, attachment.flags & ePlayerAttachmentFlags.OnShoulders )

    local childPedId = attachment.relationKind == ePlayerAttachmentRelationKind.Child
        and PlayerPedId()
        or  GetPlayerPed( GetPlayerFromServerId( attachment.otherSource ) )

    -- local isChildInHandcuffs = 
    -- local isStartingHandcuffing = isChildInHandcuffs and not IsEntityPlayingAnim( childPedId, 'mp_arresting', 'idle', 3 )

    -- sx.logger:debug( ('GetPlayerAttachmentAnimation -> inHandcuffs: %s isPlayingAnim: %s'):format( isChildInHandcuffs, IsEntityPlayingAnim( childPedId, 'mp_arresting', 'idle', 3 ) ) )
    -- sx.logger:debug( ('GetPlayerAttachmentAnimation -> isStartingHandcuffing: %s'):format( isStartingHandcuffing ) )

    -- sx.logger:debug( ('GetPlayerAttachmentAnimation -> attachment.flags: %s'):format( attachment.flags ) )
    -- sx.logger:debug( ('GetPlayerAttachmentAnimation -> attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs: %s'):format( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs ) )
    -- sx.logger:debug( ('GetPlayerAttachmentAnimation -> attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffing: %s'):format( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffing ) )
    
    if      ( attachment.flags & ePlayerAttachmentFlags.ChildInInspect ) ~= 0 then

        -- sx.logger:debug( 'GetPlayerAttachmentAnimation -> ChildInInspect' )

        if      attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

            animDict = 'cpdrevistandopolicial@animations'
            animName = 'gndrevistandopolicial_clip'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]

        elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Child then

            animDict = 'cpdanimacaomaonacabeca@animations'
            animName = 'gndanimacaomaonacabeca_clip'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
        end

    elseif  ( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs ) ~= 0 then

        -- sx.logger:debug( 'GetPlayerAttachmentAnimation -> ChildInHandcuffs' )

        if      attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

            animDict   = 'amb@code_human_wander_drinking@male@base'
            animName   = 'static'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
            animFlags |= 16 --[[ eAnimationFlags.AF_UPPERBODY ]]
            animFlags |= 32 --[[ eAnimationFlags.AF_SECONDARY ]]

        elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Child then

            animDict = 'mp_arresting'
            animName = 'idle'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
            animFlags |= 16 --[[ eAnimationFlags.AF_UPPERBODY ]]
            animFlags |= 32 --[[ eAnimationFlags.AF_SECONDARY ]]
        end

    elseif ( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffing ) ~= 0 then

        -- sx.logger:debug( 'GetPlayerAttachmentAnimation -> ChildInHandcuffing' )

        if      attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

            animDict = 'mp_arrest_paired'
            animName = 'cop_p2_back_left'

        elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Child then

            animDict = 'mp_arrest_paired'
            animName = 'crook_p2_back_left'
        end

    elseif  ( attachment.flags & ePlayerAttachmentFlags.IsThrowing ) ~= 0 then

        if attachment.relationKind == ePlayerAttachmentRelationKind.Parent then
            
            animDict = 'missminuteman_1ig_2'
            animName = 'handsup_base'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
            animFlags |= 16 --[[ eAnimationFlags.AF_UPPERBODY ]]
            animFlags |= 32 --[[ eAnimationFlags.AF_SECONDARY ]] 

        elseif attachment.relationKind == ePlayerAttachmentRelationKind.Child then

            animDict = 'move_fall'
            animName = 'fall_high'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING ]]
        
        end
        
    elseif ( attachment.flags & ePlayerAttachmentFlags.NoAnimation ) ~= 0 then

        return nil, nil, 0
        
    elseif  ( attachment.flags & ePlayerAttachmentFlags.OnShoulders ) ~= 0 then

        if      attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

            animDict = 'missfinale_c2mcs_1'
            animName = 'fin_c2_mcs_1_camman'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING ]]
            animFlags |= 16 --[[ eAnimationFlags.AF_UPPERBODY ]]
            animFlags |= 32 --[[ eAnimationFlags.AF_SECONDARY ]]

        elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Child  then

            animDict = 'nm'
            animName = 'firemans_carry'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
        end
    else

        if      attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

            animDict   = 'amb@code_human_wander_drinking@male@base'
            animName   = 'static'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
            animFlags |= 16 --[[ eAnimationFlags.AF_UPPERBODY ]]
            animFlags |= 32 --[[ eAnimationFlags.AF_SECONDARY ]]

        elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Child then

            -- sx.logger:debug( ('GetPlayerAttachmentAnimation -> attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs: %s'):format( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs ) )

            animDict = 'move_f@multiplayer'
            animName = 'idle'
            animFlags |= 1  --[[ eAnimationFlags.AF_LOOPING   ]]
            animFlags |= 16 --[[ eAnimationFlags.AF_UPPERBODY ]]
            animFlags |= 32 --[[ eAnimationFlags.AF_SECONDARY ]]
        end
    end

    return animDict, animName, animFlags
end

---@param attachment PlayerAttachment
local function PlayPlayerAttachmentAnimation( attachment )

    local animDict, animName, animFlags = GetPlayerAttachmentAnimation( attachment )

    if not animDict or not animName then
        return
    end

    local pedId = PlayerPedId()

    if IsEntityPlayingAnim( pedId, animDict, animName, 3 ) then
        return
    end

    if not HasAnimDictLoaded( animDict ) then

        RequestAnimDict( animDict )
    end

    ClearPedTasks( pedId )

    -- vRP.playAnim( false, { animDict, animName }, true )
    TaskPlayAnim( pedId, animDict, animName, 8.0, 8.0, -1, animFlags, 0, 0, 0, 0 )

    -- sx.logger:debug( ('PlayPlayerAttachmentAnimation -> flags: %s animDict: %s animName: %s animFlags: %s'):format( attachment.flags, animDict, animName, animFlags ) )

    return true
end

local function ClearLocalPlayerAttachment()

    local attachment = GetLocalPlayerAttachment()
    local hadSuppressedCollision = LocalPlayer.state[ATTACHMENT_COLLISION_SUPPRESSED_STATEBAG_KEY]

    -- print( ('ClearLocalPlayerAttachment -> attachment.relationKind: %s'):format( attachment.relationKind ) )

    if      attachment.relationKind == ePlayerAttachmentRelationKind.Child then

        DetachLocalPlayer()

    elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

    end

    local animDict, animName, animFlags = GetPlayerAttachmentAnimation( attachment )

    if animDict and animName then

        RemoveAnimDict( animDict )

        local pedId = PlayerPedId()

        if IsEntityPlayingAnim( pedId, animDict, animName, 3 ) then

            ClearPedTasks( pedId )
        end
    end

    gPlayerAttachment = nil

    -- Reset error tracking when attachment is cleared
    gPlayerAttachmentErrorCount = 0
    gPlayerAttachmentErrorCountResetAt = nil

    sx.logger:debug( 'ClearLocalPlayerAttachment -> gPlayerAttachment=nil' )

    AttemptAbortProcessPlayerAttachmentThread()

    if hadSuppressedCollision then
        ResetLocalPlayerPedPhysicsAfterCarry()
    end
end

---Distancia alta por conta de problemas de syncronizacao/lag entre players
---@type number
DEFAULT_ATTACHMENT_MAX_DISTANCE_BETWEEN_PLAYERS = 8.0

---@param attachment PlayerAttachment
---@param options? { maxDistanceBetweenPlayers?: number }
---@return boolean
local function ValidateAttachmentHasValidPhysicalAttachment( attachment, options )

    options = options or { }
    options.maxDistanceBetweenPlayers = options.maxDistanceBetweenPlayers or DEFAULT_ATTACHMENT_MAX_DISTANCE_BETWEEN_PLAYERS

    local pedId = PlayerPedId()

    local otherPlayerIdx = GetPlayerFromServerId(attachment.otherSource)
    local otherPlayerPedId = GetPlayerPed(otherPlayerIdx)

    if otherPlayerIdx == -1 then

        return ePlayerAttachmentState.ErrOtherPlayerInvalid
    end

    if otherPlayerPedId == 0 then

        return ePlayerAttachmentState.ErrOtherPlayerInvalidPed
    end

    local parentPedId = attachment.relationKind == ePlayerAttachmentRelationKind.Parent and pedId or otherPlayerPedId

    -- Hack para evitar que os players que estão sendo carregados
    -- por outro player que está no noclip não sejam dettached enquanto voam
    -- TODO: Melhorar isso em algum momento, creio eu que o problema seja
    -- pelo fato do noclip usar SetEntityCoordsNoOffset
    -- e a posição do player ser interpolada meio atrasado
    local maxDistanceBetweenPlayers = IsEntityVisible( parentPedId ) and options.maxDistanceBetweenPlayers or 100.0

    if #( GetEntityCoords( pedId ) - GetEntityCoords( otherPlayerPedId ) ) > maxDistanceBetweenPlayers then

        return ePlayerAttachmentState.ErrOtherPlayerTooFar
    end

    if attachment.relationKind == ePlayerAttachmentRelationKind.Parent and GetEntityAttachedTo( otherPlayerPedId ) ~= pedId then

        -- Garantir que o player a gente ( pai ) está fisicamente attached ao outro player que está sendo carregado ( filho )!

        sx.logger:debug( ('ValidateAttachmentHasValidPhysicalAttachment -> ErrOtherPlayerNotAttached -> attachment.relationKind: %s entityAttachedTo: %s'):format( attachment.relationKind, GetEntityAttachedTo( otherPlayerPedId ) ) )

        return ePlayerAttachmentState.ErrOtherPlayerNotAttached
    end

    if attachment.relationKind == ePlayerAttachmentRelationKind.Child and GetEntityAttachedTo( pedId ) ~= otherPlayerPedId then

        -- Garantir que o player a gente ( filho ) está fisicamente attached ao outro player que está carregando ( pai )!

        sx.logger:debug( ('ValidateAttachmentHasValidPhysicalAttachment -> ErrOtherPlayerNotAttached -> attachment.relationKind: %s entityAttachedTo: %s'):format( attachment.relationKind, GetEntityAttachedTo( pedId ) ) )

        return ePlayerAttachmentState.ErrOtherPlayerNotAttached
    end

    return ePlayerAttachmentState.Ok
end

---@param pendingAttachment PlayerAttachment
---@return boolean, ePlayerAttachmentState
local function AttemptLocalPlayerAttachment( pendingAttachment )

    if GetServerTime() - pendingAttachment.createdAt > 3000 then

        return false, ePlayerAttachmentState.ErrPendingAttachmentTimeout
    end

    local state = ValidateAttachmentHasValidPhysicalAttachment( pendingAttachment )

    if state ~= ePlayerAttachmentState.Ok then

        -- Error?!

        -- Ignorar se o outro player não está fisicamente attached ao player a gente!
        --
        -- Isso porque estamos *tentando* fazer o attachment fisico ainda...
        if state ~= ePlayerAttachmentState.ErrOtherPlayerNotAttached then

            return false, state
        end
    end

    local pedId = PlayerPedId()

    local otherPlayerIdx = GetPlayerFromServerId( pendingAttachment.otherSource )
    local otherPlayerPedId = GetPlayerPed( otherPlayerIdx )

    assert( otherPlayerIdx ~= -1 )
    assert( otherPlayerPedId ~= 0 )

    if      pendingAttachment.relationKind == ePlayerAttachmentRelationKind.Child then

        -- Priorizar flags de estado (algemado, revistando) sobre OnShoulders
        if      ( pendingAttachment.flags & ePlayerAttachmentFlags.ChildInInspect ) ~= 0 then

            -- Player sendo revistado fica na frente do policial

            AttachEntityToEntity( pedId, otherPlayerPedId, 11816, 0.0, 0.02, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true )

        elseif  ( pendingAttachment.flags & ePlayerAttachmentFlags.ChildInHandcuffing ) ~= 0 then

            -- Player em handcuffs ficam a frente do player que está carregando

            AttachEntityToEntity( pedId, otherPlayerPedId, 11816,  -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 2, true )

        elseif  ( pendingAttachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs ) ~= 0 then

            -- Player em handcuffs ficam a frente do player que está carregando

            AttachEntityToEntity( pedId, otherPlayerPedId, 11816, 0.25, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, true, 2, true )

        elseif  ( pendingAttachment.flags & ePlayerAttachmentFlags.IsThrowing ) ~= 0 then

            -- Player que está sendo agarrado - atravessado entre as duas mãos, seguindo movimento durante animações

            AttachEntityToEntity( pedId, otherPlayerPedId, GetPedBoneIndex( otherPlayerPedId, 11816 ), -1.0300, 0.10000, -0.1000, 0.0000, 180.0000, 80.0000, false, false, false, true, 2, true )

        elseif ( pendingAttachment.flags & ePlayerAttachmentFlags.OnShoulders ) ~= 0 then

            AttachEntityToEntity( pedId, otherPlayerPedId, 0, 0.20, 0.12,0.63, 0.5, 0.5, 0.0, false, false, false, false, 2, false )

        else

            -- Player padrao ficam ao lado do player que está carregando

            AttachEntityToEntity( pedId, otherPlayerPedId, 0x60F0, 0.30, 0.30, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true )
        end

    elseif  pendingAttachment.relationKind == ePlayerAttachmentRelationKind.Parent then

        -- print( 'AttemptLocalPlayerAttachment -> Parent', GetServerTime() )

        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release

            OnesyncEnableRemoteAttachmentSanitization( false )
        end

        if GetEntityAttachedTo( otherPlayerPedId ) ~= pedId then

            return false, ePlayerAttachmentState.Ok
        end

        if OnesyncEnableRemoteAttachmentSanitization then -- Remover validação quando essa native for para release

            OnesyncEnableRemoteAttachmentSanitization( true )
        end

        print( 'AttemptLocalPlayerAttachment -> Parent -> ClearLocalPlayerIsPendingAttachmentStateFlag' )

        -- Remover a flag de IsPending
        ClearLocalPlayerIsPendingAttachmentStateFlag()
    end

    return true, ePlayerAttachmentState.Ok
end

---@return ePlayerAttachmentState
local function ProcessPlayerAttachment()

    local pedId = PlayerPedId()

    -- Estamos mortos?
    --[[
    if GetEntityHealth(pedId) <= 100 then

        return ePlayerAttachmentState.ErrDead
    end
    --]]

    if not gPendingAttachment and not HasLocalPlayerAttachment() then

        sx.logger:debug( 'ProcessPlayerAttachment -> no pending attachment and no attachment? networkState=%s', GetLocalPlayerAttachmentState() )

        return ePlayerAttachmentState.Ok
    end

    local pendingAttachment = gPendingAttachment

    if pendingAttachment then

        sx.logger:info( ('ProcessPlayerAttachment -> hasPendingAttachment=%s'):format( pendingAttachment ~= nil ) )

        -- TODO: Implementar um timeout para o attachment pendente!
        -- somente o parent vai poder enviar um timeout!

        local success, state = AttemptLocalPlayerAttachment( pendingAttachment )

        if state ~= ePlayerAttachmentState.Ok then

            sx.logger:error( ('ProcessPlayerAttachment -> cant process pending attachment -> state: %s'):format( state ) )

            return state
        end

        if success then

            sx.logger:info( 'ProcessPlayerAttachment -> Fullfiling pending attachment!', pendingAttachment )

            gPlayerAttachment = pendingAttachment

            -- Reset error tracking when attachment is successfully established
            gPlayerAttachmentErrorCount = 0
            gPlayerAttachmentErrorCountResetAt = nil

            ClearLocalPlayerPendingAttachment()
        end
    end

    if HasLocalPlayerAttachment() then

        local time = GetServerTime()

        local attachment = GetLocalPlayerAttachment()

        -- Tanto o Filho e o Pai podem cancelar o Attachment
        --
        -- Quando o Filho cancelar o attachment localmente, ele vai fazer um dettachment ( native DetachPlayer )
        -- e o player vai receber esse update do ped, e vai cancelar o attachment com o servidor
        -- e também tentar buscar o motivo do detach! ( distancia, ped não existe, etc... )
        -- se não conseguir descobrir o motivo, o motivo vai ser "ErrOtherPlayerNotAttached"
        local state = ValidateAttachmentHasValidPhysicalAttachment( attachment )

        if state ~= ePlayerAttachmentState.Ok then

            -- Increment error count and update timestamps
            gPlayerAttachmentErrorCount   = gPlayerAttachmentErrorCount + 1
            gPlayerAttachmentErrorCountResetAt = gPlayerAttachmentErrorCountResetAt or time

            -- Check if we're within the error window
            local isWithinErrorWindow = ( time - gPlayerAttachmentErrorCountResetAt ) <= ERROR_WINDOW_MS

            sx.logger:debug( ('EnsureProcessPlayerAttachmentThread -> isWithinErrorWindow=%s currentTime=%s gPlayerAttachmentFirstErrorAt=%s'):format( isWithinErrorWindow, time, gPlayerAttachmentErrorCountResetAt ) )

            -- Only detach if we have enough consecutive errors within the window
            if gPlayerAttachmentErrorCount >= ERROR_THRESHOLD and isWithinErrorWindow then
                return state
            end

            sx.logger:debug( ('EnsureProcessPlayerAttachmentThread -> Tracking error: %s (count: %d/%d, window: %s)'):format( state, gPlayerAttachmentErrorCount, ERROR_THRESHOLD, isWithinErrorWindow and 'within' or 'outside' ) )
        end

        -- Reset error count if we're in a good state
        if gPlayerAttachmentErrorCount > 0 then

            if time - gPlayerAttachmentErrorCountResetAt > ERROR_WINDOW_MS then

                gPlayerAttachmentErrorCount = 0
                sx.logger:debug( 'EnsureProcessPlayerAttachmentThread -> Reset error count due to time without errors' )
            end
        end

        if      attachment.relationKind == ePlayerAttachmentRelationKind.Parent then


        elseif  attachment.relationKind == ePlayerAttachmentRelationKind.Child then

            -- ENG-504: manter colisão desligada enquanto Child está attached e a flag está ativa.
            if LocalPlayer.state[ATTACHMENT_COLLISION_SUPPRESSED_STATEBAG_KEY] and not LocalPlayer.state[NOCLIP_STATEBAG_KEY] then

                SetEntityCollision(PlayerPedId(), false, false)
            end

            -- Não pode mudar para a primeira pessoa enquanto está attached ou processando um attachment pendente!
            DisableFirstPersonCamThisFrame()

            -- Desabilitar todos os controles do player, menos o movimento da camera!
            SetPlayerControl( PlayerId(), false, 0 | 1 << 9 | 1 << 8 --[[ SPC_LEAVE_CAMERA_CONTROL_ON ]] )

            DisablePlayerFiring( PlayerId(), true )

            -- Somente simular o movimento se não estiver no ombro!
            if ( attachment.flags & ePlayerAttachmentFlags.OnShoulders ) == 0 then

                local parentPedId = GetPlayerPed( GetPlayerFromServerId( attachment.otherSource ) )

                local heading = GetEntityHeading( parentPedId )

                SimulatePlayerInputGait(PlayerId(), GetPedDesiredMoveBlendRatio( parentPedId ), -1, heading, false, true )
            end
        end

        -- if GetEntityHealth( PlayerPedId() ) > 100 then

            PlayPlayerAttachmentAnimation( attachment )
        -- end
    end

    -- if not HasLocalPlayerAttachment() and not gPendingAttachment then

    --     return ePlayerAttachmentState.ErrServerDetachment
    -- end

    return ePlayerAttachmentState.Ok
end

function AttemptAbortProcessPlayerAttachmentThread()

    sx.logger:debug( 'AttemptAbortProcessPlayerAttachmentThread -> gPlayerAttachment=%s gPendingAttachment=%s', gPlayerAttachment, gPendingAttachment )

    if gPlayerAttachment or gPendingAttachment then
        return
    end

    -- assert( gProcessPlayerAttachmentTickAbortSignal )

    if gProcessPlayerAttachmentTickAbortSignal then

        gProcessPlayerAttachmentTickAbortSignal()
        gProcessPlayerAttachmentTickAbortSignal = nil

        sx.logger:debug( 'AbortProcessPlayerAttachmentThread -> Aborted!')

        -- Esse statebag é usado em alguns outros scripts
        -- para verificar se o jogador está carregando/sendo carregado
        -- Vamos só setar no client porque não tem necessidade de replicar esse statebag!
        if LocalPlayer.state[ 'Carregar' ] then

            LocalPlayer.state:set( 'Carregar', false, false )
        end
    end
end

local gLastDetachRequestAt = 0

local function EnsureProcessPlayerAttachmentThread()

    if not gProcessPlayerAttachmentTickAbortSignal then

        print( 'EnsureProcessPlayerAttachmentThread -> Creating thread!' )

        gProcessPlayerAttachmentTickAbortSignal = SetTick(
            function()

                local state = ProcessPlayerAttachment()

                if state == ePlayerAttachmentState.Ok then
                    return
                end

                print( ('EnsureProcessPlayerAttachmentThread -> error! state: %s HasLocalPlayerAttachment=%s hasPendingAttachment=%s'):format( state, HasLocalPlayerAttachment(), gPendingAttachment ~= nil ) )

                local pendingAttachment = gPendingAttachment

                local attachment = HasLocalPlayerAttachment() and GetLocalPlayerAttachment() or pendingAttachment

                if attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

                    -- Esse error foi "causado" pelo servidor?
                    -- então o servidor provavelmente não precisa ser avisado de que
                    -- o attachment precisa ser quebrado...
                    local isServerCausedError = state >= ePlayerAttachmentState.ErrServerDetachment

                    sx.logger:debug( ('EnsureProcessPlayerAttachmentThread -> isServerCausedError: %s'):format( isServerCausedError ) )

                    if not isServerCausedError then

                        if GetServerTime() - gLastDetachRequestAt <= 2000 then

                            -- Ratelimiter

                            return
                        end

                        -- TriggerServerEvent( 'sx.player_attachment.request_detach_child_or_parent' )

                        print( 'ProcessPlayerAttachment -> DetachLocalPlayer' )

                        -- Gambiarra para limpar corretamente state de attachment e as tabelas "Carry"
                        -- no inventário, que são usadas ainda!
                        if (attachment.flags & ePlayerAttachmentFlags.OnShoulders ) ~= 0 then

                            -- Temos a flag OnShoulders!

                            TriggerServerEvent( 'net.inventory.attempt_on_shoulders_attachment_or_detachment' )
                        else

                            ExecuteCommand( 'carry' )
                        end

                        gLastDetachRequestAt = GetServerTime()
                    end
                end

                ClearLocalPlayerPendingAttachment()

                if HasLocalPlayerAttachment() then

                    -- O Filho pode fazer o detach localmente e o pai se encarrega
                    -- de fazer localmente no lado dele e enviar para o servidor!
                    ClearLocalPlayerAttachment()
                end

                AttemptAbortProcessPlayerAttachmentThread()
            end
        )
    end
end

---TODO: Mover TICKS para outro local quando possivel!
---@alias Tick unknown

---@param fn fun(): any
---@return Tick
function SetTick( fn )

    local alive = true

    local tick = function()

        alive = false
    end

    CreateThread(function ()

        while alive do

            fn()

            Wait( 0 )
        end
    end)

    return tick
end

function ClearLocalPlayerPendingAttachment()

    if gPendingAttachment then

        local animDict, animName, animFlags = GetPlayerAttachmentAnimation( gPendingAttachment )

        if animDict and animName then

            RemoveAnimDict( animDict )
        end
    end

    gPendingAttachment = nil
    OnesyncEnableRemoteAttachmentSanitization( true )

    -- Reset error tracking when pending attachment is cleared
    gPlayerAttachmentErrorCount = 0
    gPlayerAttachmentErrorCountResetAt = nil

    sx.logger:debug( 'ClearLocalPlayerPendingAttachment' )
end

---@param attachment PlayerAttachment
function SetLocalPlayerPendingAttachment( attachment )

    gPendingAttachment = attachment

    local animDict, animName, animFlags = GetPlayerAttachmentAnimation( gPendingAttachment )

    if animDict and animName then

        RequestAnimDict( animDict )
    end

    EnsureProcessPlayerAttachmentThread()

    if attachment.relationKind == ePlayerAttachmentRelationKind.Parent then

        -- Esse statebag é usado em alguns outros scripts
        -- para verificar se o jogador está carregando
        -- Vamos só setar no client porque não tem necessidade de replicar esse statebag!
        LocalPlayer.state:set( 'Carregar', true, false )
    end
end

local function OnNetworkPlayerAttachmentStateChanged()

    local state = GetLocalPlayerAttachmentState()

    sx.logger:debug( ('OnNetworkPlayerAttachmentStateChanged -> state: %s'):format( json.encode( state ) ) )

    if          state then

        local newAttachment = sx.player.attachment.getAttachmentFromState( state, LOCALPLAYER_SOURCE )

        if  HasLocalPlayerAttachment() then

            local attachment = GetLocalPlayerAttachment()

            if  attachment.otherSource  == state[ 2 ] and
                attachment.relationKind == state[ 1 ] and 
                -- attachment.flags        == state[ 3 ] and 
                attachment.createdAt    == state[ 4 ]
            then

                gPlayerAttachment = newAttachment

                return
            end
        end

        SetLocalPlayerPendingAttachment( newAttachment )

    elseif  not state then

        -- É um detach!

        ClearLocalPlayerPendingAttachment()

        if HasLocalPlayerAttachment() then

            ClearLocalPlayerAttachment()
        end

        AttemptAbortProcessPlayerAttachmentThread()
    end
end

---@type PlayerAttachment
local gPendingAttachment = nil

CreateThread(
    function()

        print( 'Esperando PLAYER_ATTACHMENT_STATE_KEY' )

        -- TIRAR ESSA MERDA QUANDO A GENTE CONSEGUIR CARREGAR O SX EM ORDEM, CORRETAMENTE!
        while not PLAYER_ATTACHMENT_STATE_KEY do

            Wait( 0 )
        end

        print( 'PLAYER_ATTACHMENT_STATE_KEY encontrado' )

        AddStateBagChangeHandler( PLAYER_ATTACHMENT_STATE_KEY, ('player:%s'):format( LOCALPLAYER_SOURCE ), function( _, _, value, reserved, replicated )

            Wait( 0 )

            if not replicated then -- Veio do servidor?

                OnNetworkPlayerAttachmentStateChanged()
            end
        end)

        OnNetworkPlayerAttachmentStateChanged()

        AddStateBagChangeHandler(NOCLIP_STATEBAG_KEY, nil, function(bagName, _, value)

            if value ~= false then
                return
            end

            if not HasLocalPlayerAttachment() then
                return
            end

            local attachment = GetLocalPlayerAttachment()

            if attachment.relationKind ~= ePlayerAttachmentRelationKind.Child then
                return
            end

            if bagName ~= ('player:%s'):format(attachment.otherSource) then
                return
            end

            local pedId = PlayerPedId()

            SetEntityCollision(pedId, false, false)
            LocalPlayer.state:set(ATTACHMENT_COLLISION_SUPPRESSED_STATEBAG_KEY, true, false)

            local coords = GetEntityCoords(pedId)

            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            SetEntityCoords(pedId, coords.x, coords.y, coords.z, false, false, false, false)
        end)
    end
)

RegisterNetEvent('sx.player_attachment.reset_ped_physics', function()

    if LocalPlayer.state[ATTACHMENT_COLLISION_SUPPRESSED_STATEBAG_KEY] then
        ResetLocalPlayerPedPhysicsAfterCarry()
    end
end)

AddEventHandler( 'onResourceStop', function( resource )

    if resource == GetCurrentResourceName() then

        if HasLocalPlayerAttachment() then

            ClearLocalPlayerAttachment()
        end
    end
end)