---@type entitlements.EntitlementFeatureDef[]
local gEntitlementFeatureDefs = { }

---@type table<entitlements.EntitlementFeatureKey, entitlements.EntitlementFeatureDef>
local gEntitlementFeatureDefsByKey = { }

---@alias entitlements.EntitlementFeatureKey string

---@class entitlements.EntitlementFeatureDef
---@field lookupKey entitlements.EntitlementFeatureKey
---@field replicated? boolean

---@param lookupKey entitlements.EntitlementFeatureKey
function DEFINE_ENTITLEMENTFEATURE_DEF( lookupKey, def )

    assert( not gEntitlementFeatureDefsByKey[ lookupKey ], ('Entitlement feature def already defined with key= "%s"'):format( lookupKey ) )

    ---@param def entitlements.EntitlementFeatureDef
    return function( def )

        def.lookupKey = lookupKey
        def.replicated = def.replicated or false

        gEntitlementFeatureDefs[ #gEntitlementFeatureDefs + 1 ] = def
        gEntitlementFeatureDefsByKey[ lookupKey ] = def

        -- sx.logger:info( 'DEFINE_ENTITLEMENTFEATURE_DEF', lookupKey, json.encode( def ) )
    end
end

function GetEntitlementFeatureDefs()

    return gEntitlementFeatureDefs
end

---@param key entitlements.EntitlementFeatureKey
---@return entitlements.EntitlementFeatureDef | nil
function GetEntitlementFeatureDefByKey( key )

    return gEntitlementFeatureDefsByKey[ key ]
end