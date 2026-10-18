---@alias net.PackethandlerId number

---@alias net.PackethandlerSerialize<T> fun( serialize: net.Serializer, data: T )

---@alias net.Packethandler<T> { __packetMT: table, id: net.PackethandlerId, serialize: fun( serializer: net.Serializer, packet: net.AnyPacket ): nil }

---@alias net.AnyPackethandler net.Packethandler<any>

local PROXY_TABLE = { }

---@type table<net.PackethandlerId, net.AnyPackethandler>
local gPacketHandlerRegistry = { }

---@type net.PackethandlerId
local gNextPackethandlerId = 1

---@return net.PackethandlerId
local function GetNextId( isCommon )

    gNextPackethandlerId = gNextPackethandlerId + 1

    local id =
        isCommon
            and gNextPackethandlerId
            or  0xFFFFFFFF - gNextPackethandlerId

    return id
end

---@param packethandler net.Packethandler
local function MakePackethandlerPacketMetatable( packethandlerOuter )

---@diagnostic disable-next-line: inject-field
    packethandlerOuter.__packetMT =
    {
        __ext = EXT_NET_PACKET,

        __packethandler = packethandlerOuter,

        ---@param self net.AnyPacket
        __pack = function( self, tag )

            local packet = self

            -- print( '__pack -> packet=', json.encode( packet ) )

            ---@type net.AnyPackethandler
            local packethandler = getmetatable( self ).__packethandler

            local buffer = CreateBuffer()

            BufferWrite( buffer, packethandler.id )

            -- print('after packeridwrite')

            local serializer = serializer_writer.new( buffer )

            packethandler.serialize( serializer, packet )

            local payload = tostring( buffer[ 2 /* data */ ] )

            -- print( '__pack -> payload=', #payload )

            return payload or ''
        end,

        __unpack = function( payload, tag )

            -- print( '__unpack -> payload=', #payload )

            local buffer = CreateBuffer( payload )

            -- print( '__unpack -> buffer=', buffer, buffer[ 2 /* data */ ] )

            local packethandlerId = BufferRead( buffer )

            -- print('after read', packethandlerId)

            local packethandler = sx.packethandler.get( packethandlerId )

            local packet = sx.packet.create( packethandler )

            local serializer = serializer_reader.new( buffer )

            -- print('unpack=', serializer)

            packethandler.serialize( serializer, packet )

            -- print( '__unpack -> packet=', json.encode( packet ) )

            return packet
        end,
    }
end

sx.packethandler = { }

---@generic T
---@param serialize net.PackethandlerSerialize<T>
---@param isCommon?  boolean
---@return net.PacketFactory<T>
function sx.packethandler.register( serialize, isCommon )

    ---@type net.PackethandlerId
    local id = GetNextId( isCommon )
    ---@type net.Packethandler<any>
    local packetType =
    {
        id = id,

        serialize = function( serializer, packet )

            -- ProfilerEnterScope( 'PacketType.serialize' )

            -- print('serializer=', serializer)

            ---@class net.SerializeState
            ---@field nextPacketKey     string | nil
            ---@field nextPacketValue   any | nil

            ---@type net.SerializeState
            local state = { nextPacketKey = nil, nextPacketValue = nil }

            local proxySerializer = setmetatable({ }, {

                ---@type 
                __index = function( _, key )

                    -- print('__index_', _, key )

                    -- TODO: "nextPacketKey" deveria ser uma lista de keys ( igual o tRPC )
                    -- eg; "data.position.x", "data.user.id"
                    --
                    -- [ 'position', 'x' ], [ 'user', 'id' ]

                    local s = serializer[ key ]

                    return function()

                        -- print("_value", nextPacketValue, packet, nextPacketKey)

                        s( serializer, state.nextPacketValue, packet, state.nextPacketKey )
                    end
                end,

                __call = function( t, ... )

                    serializer( state.nextPacketValue, packet, state.nextPacketKey )
                end
            })

            local proxyPacket = setmetatable( PROXY_TABLE, {
                __index = function( t, key )

                    -- ProfilerEnterScope( 'PacketType.proxy.__index' )

                    local value = packet[ key ]

                    -- __index não aceita MRV, então a gente usa
                    -- outra variavel pra saber qual vai ser a key usada!
                    state.nextPacketKey   = key
                    state.nextPacketValue = value

                    -- ProfilerExitScope()

---@diagnostic disable-next-line: redundant-return-value
                    return value
                end,
            })

            serialize(
                proxySerializer,
                proxyPacket
            )
        end
    }

    MakePackethandlerPacketMetatable( packetType )

    msgpack.extend( packetType.__packetMT )

    gPacketHandlerRegistry[ id ] = packetType

    return function( data )

        return sx.packet.create( packetType, data )
    end
end

---@param id net.PackethandlerId
---@return net.AnyPackethandler
function sx.packethandler.get( id )

    local packetType = gPacketHandlerRegistry[ id ]

    fast_assert( packetType ~= nil or ('PacketHandler not found with id="%s"'):format( id ) )

    return packetType
end