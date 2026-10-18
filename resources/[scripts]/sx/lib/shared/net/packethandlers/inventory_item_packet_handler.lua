
---@class net.packet.InventoryItemPacketData
---@field name string
---@field age number
---@field isOwned boolean
---@field ownedBy? number
---@field itemId number
---@field isEquipped boolean
---@field equippedBy? number
---@field isLocked boolean
---@field lockedBy? number
---@field isBroken boolean
---@field brokenBy? number

---@alias net.packet.InventoryItemPacket net.Packet<net.packet.InventoryItemPacketData>

InventoryItemPacket = sx.packethandler.register(
    ---@param data net.packet.InventoryItemPacketData
    function( serialize, data )

        serialize( data.name )
        serialize( data.age )

        serialize( data.isOwned )

        if data.isOwned then

            serialize( data.ownedBy )
        end

        serialize( data.itemId )

        serialize( data.isEquipped )

        if data.isEquipped then

            serialize( data.equippedBy )
        end

        serialize( data.isLocked )

        if data.isLocked then

            serialize( data.lockedBy )
        end

        serialize( data.isBroken )

        if data.isBroken then

            serialize( data.brokenBy )
        end
    end,
    true
)

---@class battleroyale.SafezoneTransitionStartedPacketData
---@field transitionStartedAt           number
---@field transitionStateFromPosition   vector3
---@field transitionStateFromRadius     number
---@field transitionStateToPosition     vector3
---@field transitionStateToRadius       number
---@field transitionDuration            number

---@alias battleroyale.SafezoneTransitionStartedPacket net.Packet<battleroyale.SafezoneTransitionStartedPacketData>

BattleroyaleSafezoneTransitionStartedPacket = sx.packethandler.register(

    ---@param data battleroyale.SafezoneTransitionStartedPacketData
    function( serialize, data )

        serialize( data.transitionStartedAt )

        serialize:ivector3( data.transitionStateFromPosition )
        serialize( data.transitionStateFromRadius )

        serialize:ivector3( data.transitionStateToPosition )
        serialize( data.transitionStateToRadius )

        serialize( data.transitionDuration )
    end
)