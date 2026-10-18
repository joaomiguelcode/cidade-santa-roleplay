
---VisibilityManagerHost é responsável por "hostear" o gerenciamento de
---uma "sessão" de visibilidade, então, somente uma instancia desse classe pode
---existir por vez no client/servidor.

---@class VisibilityManagerHost
---@field eventHandlerCookies           number[]
---@field stateBagChangeHandlerCookies  number[]
---@field updateAbortSignal             TickAbortSignal
---@field cachedExcludePlayerIds        number[]
local VISIBILITY_MANAGER_HOST = { }

---@param cb fun( playerId: number )
function VISIBILITY_MANAGER_HOST:ForAllConcealTargets( cb )

    -- local localPlayerId = PlayerId()

    ---@param playerId number
    ---@return boolean
    local function IsPlayerExcluded( playerId )

        -- Array/ipairs é mais rápido que hashmap quando temos poucos valores!
        for _, excludedPlayerId in ipairs( self.cachedExcludePlayerIds ) do

            if excludedPlayerId == playerId then

                return true
            end
        end

        return false
    end

    for _, playerId in ipairs( GetActivePlayers() ) do

        if not IsPlayerExcluded( playerId ) then

            cb( playerId )
        end
    end
end

---@param playerId number
---@param focusPos vector3
function VISIBILITY_MANAGER_HOST:UpdateVisiblity( playerId, focusPos )

    local pedId = GetPlayerPed( playerId )

    -- local isVisible = IsEntityVisible( pedId ) ~= false

    local shouldBeVisible = #( focusPos - GetEntityCoords( pedId ) ) >= 10.0

    -- sx.logger:debug( 'Update: playerId: %d, isVisible: %s, shouldBeVisible: %s distance: %f', playerId, isVisible, shouldBeVisible, #( focusPos - GetEntityCoords( pedId ) ) )

    if      --[[ isVisible and --]] not shouldBeVisible then

        SetEntityLocallyInvisible( pedId )

        -- print( ('Player %d is now invisible'):format( playerId ) )

    elseif  --[[ not isVisible and --]] shouldBeVisible then

        -- NetworkConcealPlayer( playerId, false )
    end
end

function VISIBILITY_MANAGER_HOST:UpdateAllVisiblity()

    local focusPos = GetFinalRenderedCamCoord()

    self:ForAllConcealTargets(
        function( playerId )

            self:UpdateVisiblity( playerId, focusPos )
        end
    )
end

function VISIBILITY_MANAGER_HOST:Update()

    -- Executar a cada 10 frames!
    -- if GetFrameCount() % 10 == 0 then

    -- sx.logger:debug( 'Updating all visiblity' )

        self:UpdateAllVisiblity()
    -- end
end

--- Inicializar uma instancia de VisibilityManagerHost
--- gerencia quais players devem estar em conceal ou não
--- e quando a sessão deve ser iniciada/terminada
function VISIBILITY_MANAGER_HOST:Initialize()

    sx.logger:info( 'Initializing local conceal session manager' )

    self.stateBagChangeHandlerCookies =
    {
        -- TODO: Achar uma formar melhor e talvez tipada
        -- de receber os valores daqui!
        AddStateBagChangeHandler( 'visibility:hasOverride' --[[ parametro em sx.client.visibility.state.hasOverride ]], 'global', function( _, __, value )

            -- sx.logger:debug( ('State bag change handler for hasOverride: "%s"'):format( value ) )

            if value ~= true then

                Wait( 0 )

                gVisibilityManagerHost:Terminate()

                gVisibilityManagerHost = nil
            end
        end),

        AddStateBagChangeHandler( 'visibility:excludePlayerIds' --[[ parametro em sx.client.visibility.state.excludePlayerIds ]], 'global', function( _, __, value )

            -- sx.logger:debug( ('State bag change handler for excludePlayerIds: "%s"'):format( json.encode( value ) ) )

            self.cachedExcludePlayerIds = value or { }
        end),
    }

    self.eventHandlerCookies =
    {
        AddEventHandler( 'onResourceStop', function( resourceName )

            if resourceName == GetCurrentResourceName() then

                sx.client.visibility.endVisibilityOverride()
            end
        end),

        --[[
        RegisterNetEvent( 'onPlayerJoining', function( source )

            sx.logger:debug( 'onPlayerJoining event handler for resource: %s', resourceName )

            -- Tentar dar conceal imediatamente num player quando ele entra em escopo!

            AttemptPlayerConceal( source, GetEntityCoords( GetPlayerPed( source ) ) )
        end),
        --]]
    }

    self.updateAbortSignal = sx.script.setTick(
        function()

            self:Update()
        end
    )

    self:UpdateAllVisiblity()
end

function VISIBILITY_MANAGER_HOST:Terminate()

    sx.logger:info( 'Terminating local conceal session manager' )

    for _, cookie in ipairs( self.stateBagChangeHandlerCookies ) do

        RemoveStateBagChangeHandler( cookie )
    end

    -- Remover os eventhandlers dos eventos que usamos!
    for _, cookie in ipairs( self.eventHandlerCookies ) do

        RemoveEventHandler( cookie )
    end

    self.updateAbortSignal()

    -- local focusPos = GetFinalRenderedCamCoord()

    -- Unconceal todos os players
    -- self:ForAllConcealTargets(
    --     function( playerId )

    --         self:UpdateVisiblity( playerId, focusPos )
    --     end
    -- )
end

function CreateVisibilityManagerHost()

    ---@type VisibilityManagerHost
    local self =
    {
        eventHandlerCookies = { },
        updateAbortSignal = nil,
        cachedExcludePlayerIds = sx.client.visibility.state.excludePlayerIds or { },
    }

    setmetatable( self, { __index = VISIBILITY_MANAGER_HOST })

    return self
end