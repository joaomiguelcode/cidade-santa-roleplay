
---@type vector3 | nil
local lastMouseRotation = nil

---@type number | nil
local lastActivityTime = nil

---@type number | nil
local lastCursorPosition = nil

---@type boolean
local isAFK = false

---@type boolean
local afkSystemInitialized = false

---@type boolean
local gAfkFeedbackActive = false

---@type number (em milissegundos)
local AFK_THRESHOLD = (1 * 60 * 1000) -- 1 minuto

local gAfkAnimationDict = 'mp_sleep'
local gAfkAnimationName = 'sleep_loop'

local function CanShowAfkFeedback()

    return not LocalPlayer.state.FirstLogin
        and LocalPlayer.state.Route == 1
        and not LocalPlayer.state.InGames
end

local function StartAfkFeedback()

    gAfkFeedbackActive = true
    TriggerEvent( 'Notify2', '#AFK' )
end

local function MaintainAfkAnimation()

    local ped = PlayerPedId()
    local isPlaying = IsEntityPlayingAnim( ped, gAfkAnimationDict, gAfkAnimationName, 3 )
    local hasScriptedInteraction = exports.scripted_interactions:isRunningAnyScriptedInteraction()

    if isPlaying or hasScriptedInteraction then
        return
    end

    if not HasAnimDictLoaded( gAfkAnimationDict ) then
        RequestAnimDict( gAfkAnimationDict )

        while not HasAnimDictLoaded( gAfkAnimationDict ) do
            Wait( 10 )
        end
    end

    if not isAFK or not gAfkFeedbackActive or not CanShowAfkFeedback() then
        RemoveAnimDict( gAfkAnimationDict )
        return
    end

    TaskPlayAnim( ped, gAfkAnimationDict, gAfkAnimationName, 8.0, 8.0, -1, 49, 0.0, false, false, false )
    RemoveAnimDict( gAfkAnimationDict )
end

local function StopAfkFeedback()

    TriggerEvent( 'Notify2', '#naoAFK' )

    local ped = PlayerPedId()

    if IsEntityPlayingAnim( ped, gAfkAnimationDict, gAfkAnimationName, 3 ) then
        StopAnimTask( ped, gAfkAnimationDict, gAfkAnimationName, 8.0 )
    end

    gAfkFeedbackActive = false
end

local function HasCursorMoved( cursorPos, lastCursorPosition )
    if not lastCursorPosition then
        return true
    end

    if not IsNuiFocused() then

        --[[

            NOTE: Não esta com foco em alguma interface ?
            então não vamos retornar se o cursor se moveu
            pois a native `GetNuiCursorPosition` pega do browser
            do jogo em si, então temos que fazer essa validação se esta
            com foco em alguma interface de fato para validar se mexeu ou
            não o cursor.

            - @TkzDev
        ]]

        return
    end

	return ( cursorPos ~= lastCursorPosition )
end

---@param currentMousePosition { number, number }
---@param lastMousePosition { number, number }
---@return boolean
local function HasMouseMoved( currentMousePosition, lastMousePosition )

    if not lastMousePosition then
        return true
    end

	local diffX = math.abs( currentMousePosition[ 1 ] - lastMousePosition[ 1 ] )
	local diffY = math.abs( currentMousePosition[ 2 ] - lastMousePosition[ 2 ] )
	
	return ( diffX > 0.5 or diffY > 0.5 )
end

local function InitAfkSystem()
    -- Evita múltiplas inicializações
    if afkSystemInitialized then
        return
    end
    
    afkSystemInitialized = true
    
    CreateThread(function()
        while true do
            
            local currentTime = GetNetworkTimeAccurate()
            local cursorPos = GetNuiCursorPosition()
        
            local xNormal = GetDisabledControlNormal( 0, 220 )
            local yNormal = GetDisabledControlNormal( 0, 221 )

            local hasMouseMoved = HasMouseMoved( { xNormal, yNormal }, lastMouseRotation )
            local hasCursorMoved = HasCursorMoved( cursorPos, lastCursorPosition )
            local isPlayerTalking = MumbleIsPlayerTalking( PlayerId() ) == 1
            local timeLastInput = GetTimeSinceLastInput( 0 )
            
            if timeLastInput <= 500 --[[ 500ms last input pressed ]] or hasMouseMoved or hasCursorMoved or isPlayerTalking then
                lastActivityTime = currentTime
                
                if isAFK then
                    isAFK = false
                    LocalPlayer.state:set( AFK_PLAYER_STATEBAG_KEY, { false, 0 }, true )

                    if gAfkFeedbackActive then
                        StopAfkFeedback()
                    end

                    TriggerEvent( 'afk:stopped' )
                end
                
                lastMouseRotation = { xNormal, yNormal }
                lastCursorPosition = cursorPos
            else
                if not lastActivityTime then
                    lastActivityTime = currentTime
                end
                
                local inactiveTime = currentTime - lastActivityTime
                    
                if (inactiveTime >= AFK_THRESHOLD) and not isAFK then
                    isAFK = true
                    LocalPlayer.state:set( AFK_PLAYER_STATEBAG_KEY, { true, GetNetworkTimeAccurate() }, true )

                    if CanShowAfkFeedback() then
                        StartAfkFeedback()
                    end

                    TriggerEvent( 'afk:started' )
                end
            end

            if isAFK and gAfkFeedbackActive then
                MaintainAfkAnimation()
            end

            Wait(1000)
        end
    end)
end

RegisterNetEvent('vRP:Active')
AddEventHandler('vRP:Active', function()
    -- Tá com um personagem ativo!
    InitAfkSystem()
end)

-- Script iniciou e já tá com um personagem ativo?
if LocalPlayer.state.Active then
    InitAfkSystem()
end

---@param playerServerId SourceLike
---@return boolean
local function IsAfk( playerServerId )
    
    local state = Player( playerServerId ).state[ AFK_PLAYER_STATEBAG_KEY ]

    if not state then
        return false
    end

    return state[ 1 ] == true
end

exports( 'IsAfk', IsAfk )
