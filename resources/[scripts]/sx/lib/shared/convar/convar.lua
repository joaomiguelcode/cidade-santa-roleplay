---@alias sx.ConvarClientGetter<T> fun( varName: string, defaultValue: T ): T

local function createConvarsClient()

    return {

        ---@type sx.ConvarClientGetter<boolean>
        boolean = function( varName, defaultValue )

            local value = GetConvarBool( varName, defaultValue )

            return value == true or value == 1
        end,

        ---@type sx.ConvarClientGetter<string>
        string = function( varName, defaultValue )

            return GetConvar( varName, defaultValue )
        end,
    }
end

---@class ConvarInner
---@field public value  any
---@field public cookie number
---@field public onChangedCallbacks fun( value: any )[]

---@class ConvaPrivateInner : ConvarInner
---@field private cookie number
---@field private onChangedCallbacks fun( value: any )[]
---@field private __call fun(): ConvarInner

---@alias Convar<T> { onChanged: fun( self, callback: fun( value: T ) ) } | ConvaPrivateInner | fun(): T

sx.convar = sx.lazy(
    function()

        local client = createConvarsClient()

        ---@generic T
        ---@param varName string
        ---@param defaultValue T
        ---@param getter sx.ConvarClientGetter<T>
        ---@return Convar<T>
        local function createConvar( varName, defaultValue, getter )

            ---@type ConvarInner
            local convar =
            {
                value  = getter( varName, defaultValue ),
                cookie = nil,
                onChangedCallbacks = { },
                onChanged = function( self, callback )

                    table.insert( self.onChangedCallbacks, callback )
                end,
            }

            convar.cookie = AddConvarChangeListener( varName, function()

                convar.value = getter( varName, defaultValue )

                for _, callback in ipairs( convar.onChangedCallbacks ) do

                    callback( convar.value )
                end
            end)

            return setmetatable( convar, {

                __call = function( self )

                    return self.value
                end,

                __gc = function( self )

                    RemoveConvarChangeListener( self.cookie )
                end,
            })
        end

        return {

            ---@param varName       string
            ---@param defaultValue  boolean
            boolean = function( varName, defaultValue )

                return createConvar( varName, defaultValue, client.boolean )
            end,

            ---@param varName       string
            ---@param defaultValue  string
            string = function( varName, defaultValue )

                return createConvar( varName, defaultValue, client.string )
            end,
        }
    end
)