
-- Snapshot compacto do state bag "inventory:dynamicShops".
-- Entradas são arrays posicionais (sem keys repetidas por entrada); campos opcionais usam
-- `false` como sentinela pra não criar buraco de nil no array. Coords em centímetros (int).
-- Producer/consumer: inventory/server/shops/main.lua e inventory/client/shops/main.lua

---@class net.packet.DynamicShopsPacketData
---@field shops  table[] -- { shopKey, name|false, slots|false, shopType|false, text|false, icon|false, list }
---@field points table[] -- { pointId, xCm, yCm, zCm, shopTypes }

---@alias net.packet.DynamicShopsPacket net.Packet<net.packet.DynamicShopsPacketData>

DynamicShopsPacket = sx.packethandler.register(
    ---@param data net.packet.DynamicShopsPacketData
    function( serialize, data )

        serialize( data.shops )

        serialize( data.points )
    end,
    true
)
