---@alias net.Packet<T> T

---@alias net.AnyPacket net.Packet<any>

EXT_NET_PACKET = 31

msgpack.extend_clear( EXT_NET_PACKET )

---@alias net.PacketFactory<T> fun( data: T ): net.Packet<T>

sx.packet = { }

---@generic T
---@param packetType net.Packethandler<`T`>
---@param data?      T
---@return net.Packet<T>
function sx.packet.create( packetType, data )

    data = data or { }

    ---@type net.Packet
    local packet = setmetatable( data, packetType.__packetMT )

    return packet
end