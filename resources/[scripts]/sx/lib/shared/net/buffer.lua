---              { cursor: number, data: ISerializable }
---@alias net.Buffer { [1]   : number, [2] : net.ISerializable }

local msgpack_new = msgpack.new
local msgpack_unpack = msgpack.unpack

---@param data? string
---@return net.Buffer
function CreateBuffer( data )

    local isWriter = data == nil
    local isReader = not isWriter

    local ud = msgpack_new()

    local _ = ud .. data

    local unpacked = nil

    if isReader then

        unpacked = { msgpack_unpack( tostring( ud ) ) }
    end

    local buffer =
    {
        0,
        ud,
        unpacked,
    }

    return buffer
end

function BufferWrite( buffer, data )

    local ud = buffer[ 2 ]

    buffer[ 1 ] += 1

    local cursor = buffer[ 1 ]

    -- Encode and append data to buffer's userdata
    ud( data )

    buffer[ 1 /* cursor */ ] = cursor

    -- print( 'BufferWrite', '->', cursor, tostring( uc ), data )
end

function BufferRead( buffer )

    -- local ud = buffer[ 2 ]

    buffer[ 1 ] += 1

    local cursor = buffer[ 1 ]

    local unpacked = buffer[ 3 ]

    local data = unpacked[ cursor ]

    -- print( 'BufferRead', cursor, json.encode( unpacked ), data )

    return data
end
