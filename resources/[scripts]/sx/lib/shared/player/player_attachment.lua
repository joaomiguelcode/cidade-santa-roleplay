---@class NetworkPlayerAttachmentState
---@field [1] ePlayerAttachmentRelationKind -- relationKind
---@field [2] Source                        -- otherSource
---@field [3] number | nil                  -- syncedFlags
---@field [4] ServerTime                    -- createdAt

PLAYER_ATTACHMENT_STATE_KEY = 'attch'

---@enum ePlayerAttachmentFlags
ePlayerAttachmentFlags = { }

ePlayerAttachmentFlags.None                  = 0
-- Flags que vão ser sincronizadas para os clients envolvidos
ePlayerAttachmentFlags.IsPending    = 1 << 0
ePlayerAttachmentFlags.OnShoulders  = 1 << 1
ePlayerAttachmentFlags.IsThrowing  = 1 << 2
ePlayerAttachmentFlags.NoAnimation  = 1 << 3
-- Flags que não são enviadas via statebags para sincronização
-- porque a gente consegue deduzir essa flag a partir de outro dado
ePlayerAttachmentFlags.NoSync       = 1 << 4
-- * A PRIMEIRA FLAG TEM QUE SER O MESMO VALOR DE NOSYNC *
-- A gente consegue saber se essa flag está ativa quando o player tem o statebag "Handcuff"
ePlayerAttachmentFlags.ChildInHandcuffing  = 1 << 4
ePlayerAttachmentFlags.ChildInHandcuffs  = 1 << 5
ePlayerAttachmentFlags.ChildInInspect  = 1 << 6

---@enum ePlayerAttachmentRelationKind
ePlayerAttachmentRelationKind =
{
    Invalid = 0,

    Parent = 1,

    Child = 2,
}

sx.player.attachment = { }

---@param source Source
---@return NetworkPlayerAttachmentState | nil
function sx.player.attachment.getAttachmentState( source )

    return Player( source ).state[ PLAYER_ATTACHMENT_STATE_KEY ]
end

---@param source          Source
---@param attachmentState NetworkPlayerAttachmentState
function sx.player.attachment.setAttachmentState( source, attachmentState )

    -- print( ('setAttachmentState -> "%s" source=%s t=%s attachmentState=%s'):format( PLAYER_ATTACHMENT_STATE_KEY, source, type( source ), json.encode( attachmentState ) ), debug.traceback() )

    Player( source ).state:set( PLAYER_ATTACHMENT_STATE_KEY, attachmentState, true )
end

---Retorna *true* quando o jogador está carregando ou sendo carregado por outro jogador
---@param source Source
---@return boolean
function sx.player.attachment.hasAttachment( source )

    return sx.player.attachment.getAttachmentState( source ) ~= nil
end

---@param attachmentState NetworkPlayerAttachmentState
---@return boolean
function sx.player.attachment.isAttachmentPending( attachmentState )

    return ( attachmentState[ 3 ] & ePlayerAttachmentFlags.IsPending ) ~= 0
end

---Retorna *true* quando o jogador está aguardando a attachment ser processada
---@param source Source
---@return boolean
function sx.player.attachment.hasPendingAttachment( source )

    if not sx.player.attachment.hasAttachment( source ) then
        return false
    end

    local attachmentState = sx.player.attachment.getAttachmentState( source )

    assert( attachmentState )

    return sx.player.attachment.isAttachmentPending( attachmentState )
end

---Retorna *true* quando o jogador está carregando ou sendo carregado por outro jogador
---ou aguardando a attachment ser processada
---@param source Source
---@return boolean
function sx.player.attachment.hasAttachmentOrPendingAttachment( source )
    if GetCurrentResourceName() == 'vrp' then
        -- Não podemos reiniciar o vrp :(

        -- Quando a pessoa em noclip tá carregando alguem
        return sx.player.attachment.getAttachment( source )?.relationKind == ePlayerAttachmentRelationKind.Child
    end

    return sx.player.attachment.hasAttachment( source ) or sx.player.attachment.hasPendingAttachment( source )
end

---@param attachmentState NetworkPlayerAttachmentState
---@param source Source
---@return PlayerAttachment
function sx.player.attachment.getAttachmentFromState( attachmentState, source )

    ---@type PlayerAttachment
    local attachment =
    {
        relationKind    = attachmentState[ 1 ],
        otherSource = attachmentState[ 2 ],
        flags = attachmentState[ 3 ] or ePlayerAttachmentFlags.None,
        createdAt = attachmentState[ 4 ],
    }

    local childSource = attachment.relationKind == ePlayerAttachmentRelationKind.Child
        and source
        or  attachment.otherSource

    -- sx.logger:debug( ('getAttachmentFromState -> childSource: %s'):format( childSource ), type( childSource ) )

    -- sx.logger:debug( ('getAttachmentFromState -> Player( childSource ).state[ "HandcuffCarry" ]: %s'):format( Player( childSource ).state[ 'HandcuffCarry' ] ) )
    -- sx.logger:debug( ('getAttachmentFromState -> Player( childSource ).state[ "Handcuff" ]: %s'):format( Player( childSource ).state[ 'Handcuff' ] ) )

    if Player( childSource ).state[ 'HandcuffCarry' ] then

        attachment.flags |= ePlayerAttachmentFlags.ChildInHandcuffing
    end

    if Player( childSource ).state[ 'Handcuff' ] then

        attachment.flags |= ePlayerAttachmentFlags.ChildInHandcuffs
    end

    if Player( childSource ).state[ 'Inspect' ] then

        attachment.flags |= ePlayerAttachmentFlags.ChildInInspect
    end

    -- sx.logger:debug( ('getAttachmentFromState -> attachment.flags: %s'):format( attachment.flags ) )
    -- sx.logger:debug( ('getAttachmentFromState -> attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs: %s'):format( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffs ) )
    -- sx.logger:debug( ('getAttachmentFromState -> attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffing: %s'):format( attachment.flags & ePlayerAttachmentFlags.ChildInHandcuffing ) )

    return attachment
end

---Retorna o outro jogador que está carregando *source*
---@param source Source
---@return PlayerAttachment | nil
function sx.player.attachment.getAttachment( source )

    ---@type NetworkPlayerAttachmentState | nil
    local attachmentState = sx.player.attachment.getAttachmentState( source )

    if not attachmentState then
        return nil
    end

    return sx.player.attachment.getAttachmentFromState( attachmentState, source )
end

---Retorna o outro jogador que está sendo carregado por *source*
---@param source Source
---@return Source | nil
function sx.player.attachment.getAttachmentChild( source )

    local attachment = sx.player.attachment.getAttachment( source )

    if not attachment then
        return nil
    end

    if attachment.relationKind ~= ePlayerAttachmentRelationKind.Parent then
        return nil
    end

    return attachment.otherSource
end

---Retorna o outro jogador que está carregando *source*
---@param source Source
---@return Source | nil
function sx.player.attachment.getAttachmentParent( source )

    local attachment = sx.player.attachment.getAttachment( source )

    if not attachment then
        return nil
    end

    if attachment.relationKind ~= ePlayerAttachmentRelationKind.Child then
        return nil
    end

    return attachment.otherSource
end

---Retorna *true* quando o jogador está carregando ou sendo carregado por outro jogador
---@param source Source
---@return boolean
function sx.player.attachment.isAttachedToAnyPlayer( source )

    return sx.player.attachment.getAttachmentParent( source ) ~= nil
end

---@class ServerTime : number

---@type fun(): ServerTime
GetServerTime =
    GetGameName() == 'fxserver'
        and GetGameTimer
        or  GetNetworkTimeAccurate