---@param normalizedModel string
---@return boolean
local function IsNativePedModel( normalizedModel )
    local prefixes = gPedEditorConfig.nativeModelPrefixes

    for i = 1, #prefixes do
        if normalizedModel:sub( 1, #prefixes[ i ] ) == prefixes[ i ] then
            return true
        end
    end

    return false
end

---@param skinModel any
---@return boolean
function IsPedEditorSkinDefined( skinModel )
    if type( skinModel ) ~= 'string' then
        return false
    end

    local normalizedModel = skinModel:lower()

    for _, definition in pairs( gPedEditorConfig.redeem.catalog ) do
        if definition.model:lower() == normalizedModel then
            return true
        end
    end

    return IsNativePedModel( normalizedModel )
end

---@param skinsList SkinDef[]
---@return FormattedSkinsData
function FormatSkinsForClient( skinsList )
    ---@type FormattedSkinsData
    local formatted = {}
    local now = os.time()

    for i = 1, #skinsList do
        local skin = skinsList[ i ]
        local expiresAt = skin.expiresAt

        if IsPedEditorSkinDefined( skin.model ) and (not expiresAt or expiresAt > now) then
            local category = skin.category

            if not formatted[ category ] then
                formatted[ category ] = {}
            end

            formatted[ category ][ #formatted[ category ] + 1 ] = {
                id         = skin.model,
                name       = skin.name,
                favorite   = skin.isFavorite,
                isActive   = skin.isActive,
                status     = expiresAt and 'temporary' or 'permanent',
                daysLeft   = expiresAt and math.ceil( (expiresAt - now) / 86400 ) or nil,
            }
        end
    end

    return formatted
end

---@param dbRow SkinDbRow
---@param index number
---@return SkinDef
function ParseSkinFromDb( dbRow, index )
    return {
        id         = index,
        name       = dbRow.skin_name,
        model      = dbRow.skin_model,
        category   = dbRow.skin_category,
        isFavorite = dbRow.is_favorite == 1,
        isActive   = dbRow.is_active == 1,
        expiresAt  = dbRow.expires_at and tonumber( dbRow.expires_at ) or nil,
    }
end

---@param value any
---@param expectedType string
---@param paramName string
---@return boolean
function ValidateParam( value, expectedType, paramName )
    if type( value ) ~= expectedType then
        sx.logger:error( ('Invalid parameter "%s": expected %s, got %s'):format(
            paramName,
            expectedType,
            type( value )
        ))
        return false
    end

    return true
end
