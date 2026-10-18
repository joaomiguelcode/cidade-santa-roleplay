---@alias FeatureFlagAdapter<TValueType> fun( opts: { key: string, defaultValue: TValueType }  ): TValueType
---@class FeatureFlag<TValueType>
---@overload fun(): TValueType
---@field assert fun(message?: string): true

-- sx.featureflag is both callable (creates a flag) and indexable (`.adapters`).
sx.featureflag = setmetatable(
    {
        adapters = { },
    },
    {
        ---@generic TValueType
        ---@param definition { key: string, defaultValue: TValueType, decide?: fun( opts: { key: string, defaultValue: TValueType } ): TValueType }
        ---@param adapter?    FeatureFlagAdapter<TValueType>
        ---@return FeatureFlag<TValueType>
        __call = function( _, definition, adapter )

            assert( not ( definition.decide and adapter ), 'Não é possivel ter um "decide" e um "adapter" ao mesmo tempo' )

            local decide = definition.decide or adapter

            assert( decide, 'featureflag requer um "decide" ou um "adapter"' )

            local function readFlag()

                return decide({ key = definition.key, defaultValue = definition.defaultValue })
            end

            return setmetatable( {
                assert = function( message )
                    -- Natives BOOL (ex.: GetConvarBool) retornam 1 em vez de true no Lua do FiveM.
                    local value = readFlag()
                    return assert( value == true or value == 1, message or ('Feature flag "%s" is not enabled'):format( definition.key ) )
                end,
            }, { __call = readFlag } )
        end,
    }
)

sx.featureflags = sx.featureflags or { }
