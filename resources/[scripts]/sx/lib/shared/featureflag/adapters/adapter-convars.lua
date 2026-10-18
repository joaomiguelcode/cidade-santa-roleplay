local function createConvarsFeatureFlagAdapter()

    return {

        ---@return FeatureFlagAdapter<boolean>
        boolean = function()

            return function( opts )

                return GetConvarBool( opts.key, opts.defaultValue )
            end
        end,

        ---@return FeatureFlagAdapter<string>
        string = function()

            return function( opts )

                return GetConvar( opts.key, opts.defaultValue )
            end
        end,
    }
end

sx.featureflag.adapters.convars = createConvarsFeatureFlagAdapter()
