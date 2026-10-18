---@alias net.ISerializable table<string, any>

---@alias net.SerializerMethod<T> fun( self: net.Serializer, value?: T, data: net.ISerializable, key: string ): T

---@class net.Serializer
---@field private   buffer      net.Buffer
---@field           int         net.SerializerMethod<integer>
---@field           vector3     net.SerializerMethod<vector3>
---@field           ivector3    net.SerializerMethod<vector3>
---@overload                    net.SerializerMethod<any>

-- # Writer

---@class net.Serializer
serializer_writer = { }

function serializer_writer.new( buffer )

    local o = setmetatable({
        buffer = buffer
    },
    { __index = serializer_writer, __call = serializer_writer.__call })

    return o
end

--@alias primitive number | string | boolean

serializer_writer.__call = function( self, value )

    -- print('self__call', self, self.buffer, value )

    BufferWrite( self.buffer, value )

    return value
end

function serializer_writer:int( value, data, key )

    self( math.floor( value ) )

    return value
end

function serializer_writer:vector3( value, data, key )

    self( value.x )
    self( value.y )
    self( value.z )

    return value
end

function serializer_writer:ivector3( value, data, key )

    self:int( value.x )
    self:int( value.y )
    self:int( value.z )

    return value
end

-- # Reader

---@class net.Serializer
serializer_reader = { }

function serializer_reader.new( buffer )

    local o = setmetatable({
        buffer = buffer
    },
    { __index = serializer_reader, __call = serializer_reader.__call })

    return o
end

serializer_reader.__call = function( self, value, data, key )

    value = BufferRead( self.buffer )

    data[ key ] = value

    return value
end

function serializer_reader:int( value, data, key )

    self( value, data, key )

    return value
end

function serializer_reader:vector3( value, data, key )

    data[ key ] = vector3(
        self( value?.x, data, key ),
        self( value?.y, data, key ),
        self( value?.z, data, key )
    )

    return value
end

function serializer_reader:ivector3( value, data, key )

    -- print('ivector3', self, value, data, key )

    return self:vector3( value, data, key )
end