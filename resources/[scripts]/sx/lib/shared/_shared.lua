
sx = WithLazyholder(
    { }
)

local LIB_RESOURCE_NAME = GlobalState['sxlib_resource_name']

function sx.getLibraryResourceName()
    return LIB_RESOURCE_NAME
end

---@param eval true | any
---@diagnostic disable-next-line: lowercase-global
function fast_assert( eval )
	return eval == true or error( eval )
end

---@param value any
---@return boolean | nil
function toboolean( value )

    if value == 'true'  or value == 1 or value == true  then

        return true
    end

    if value == 'false' or value == 0 or value == false then

        return false
    end

    return nil
end

---@param timestamp? number Optional timestamp in seconds, uses current time if nil
---@return string iso8601
function to_iso8601( timestamp )
    -- Use current time if no timestamp provided
    timestamp = timestamp or os.time()

    -- Format with UTC timezone (Z)
    return os.date( '!%Y-%m-%dT%H:%M:%SZ', timestamp )
end

sx.msgpackextensions = { }

sx.msgpackextensions.packers = { }

---@param buffer any[]
---@param v      vector3
---@param offset? number
function sx.msgpackextensions.packers.worldlimitsvector3( buffer, v, offset )

    offset = offset or #buffer + 1

    buffer[ offset ] = string.pack( '>i2', tonumber( string.format( '%.0f', v.x ) ) )
    offset += 1
    buffer[ offset ] = string.pack( '>i2', tonumber( string.format( '%.0f', v.y ) ) )
    offset += 1
    buffer[ offset ] = string.pack( '>i2', tonumber( string.format( '%.0f', v.z ) ) )
end

sx.msgpackextensions.unpackers = { }

---@param str    string
---@param offset number
---@return vector3
function sx.msgpackextensions.unpackers.worldlimitsvector3( str, offset )

    local x = string.unpack( '>i2', str, offset )
    local y = string.unpack( '>i2', str, offset + 2 )
    local z = string.unpack( '>i2', str, offset + 4 )

    return vector3( x, y, z )
end

if GetConvarBool( 'sv_lan', false ) then

    local MOCK_IDENTIFIERS =
    {
        "license:f8b7e66d7c86ceedb22ecfd85d10358e0b053e6d",
        "xbl:2533274964552707",
        "live:1829581945124598",
        "discord:211697261636222979",
        "fivem:744311",
        "license2:3862e57e4b71f9c5adccda7d33476d59cd596e8c",
        "ip:26.131.27.3"
    }

    GetPlayerIdentifierByType = function( playerSrc, identifierType )

        return sx.table.find( MOCK_IDENTIFIERS, function ( identifier )

            return identifier:sub( 1, identifierType:len() ) == identifierType
        end)
    end

    GetPlayerIdentifiers = function( playerSrc )

        return MOCK_IDENTIFIERS
    end
end