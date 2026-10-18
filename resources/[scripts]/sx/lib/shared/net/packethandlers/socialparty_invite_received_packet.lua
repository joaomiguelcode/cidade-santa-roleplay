---@class (exact) socialparty.InviteReceivedPacketData
--@field title                  string
--@field subtitle               string
---@field kind      eSocialpartyKind
---@field position  vector3
---@field subtitle  string
---@field body      string
---@field createdBy     string
---@field socialpartyId number -- server-assigned id for this broadcast; echoed back on accept for validation

---@alias socialparty.InviteReceivedPacket net.Packet<socialparty.InviteReceivedPacketData>

SocialpartyInviteReceivedPacket = sx.packethandler.register(

    ---@param data socialparty.InviteReceivedPacketData
    function( serializer, data )

        -- serializer( data.title )

        -- serializer( data.subtitle )

        serializer( data.kind )

        serializer:ivector3( data.position )

        serializer( data.body )

        serializer( data.createdBy )

        serializer( data.socialpartyId )
    end,
    true
)