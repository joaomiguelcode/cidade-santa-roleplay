local utils = require 'imports.utils'
local store = require 'imports.store'
local dui = require 'imports.dui'
local config = require 'imports.config'
local indicator = config.defaultIndicatorSprite
local drawLoopRunning = false
local BuilderLoopRunning = false
local nerbyInteractions = {}
cameraStatus = true

LocalPlayer.state.interactBusy = false

lib.addKeybind({
    name = 'sleepless_interact:action',
    description = 'Interact',
    defaultKey = 'E',
    onPressed = function(self)
        if store.activeInteraction then
            store.activeInteraction:handleInteract()
        end
    end,
})

store.hidePerKeybind = false
local defaultShowKeyBind = config.defaultShowKeyBind
local showKeyBindBehavior = config.showKeyBindBehavior
local useShowKeyBind = config.useShowKeyBind
if useShowKeyBind then
    store.hidePerKeybind = true
    lib.addKeybind({
        name = 'sleepless_interact:toggle',
        description = 'show interactions',
        defaultKey = defaultShowKeyBind,
        onPressed = function(self)
            if cache.vehicle then return end
            if showKeyBindBehavior == "toggle" then
                store.hidePerKeybind = not store.hidePerKeybind
                if store.hidePerKeybind then
                    BuilderLoopRunning = false
                else
                    BuilderLoop()
                end
            else
                store.hidePerKeybind = false
                BuilderLoop()
            end
        end,
        onReleased = function(self)
            if showKeyBindBehavior == "toggle" or cache.vehicle then return end
            store.hidePerKeybind = true
            BuilderLoopRunning = false
        end
    })
end

local drawPrint = false

-- Padrao de interacao para todos os tipos de interacoes, os players temm padrao INTERACT_PRIORITY_MEDIUM
local DEFAULT_INTERACTION_PRIORITY          = 2    -- eInteractionPriority.HIGH
local INTERACTION_PRIORITY_DISTANCE_RATIO   = 0.15
local INTERACTION_PRIORITY_MIN_THRESHOLD    = 1.5
local PRIORITY_ACTIVE_DISTANCE_BONUS        = 0.5  -- metros extras de activeDistance por nivel de priority

local function drawLoop()
    lib.requestStreamedTextureDict(indicator.dict)

    CreateThread(function()
        while next(store.nearby) do
            for i = 1, #store.nearby do
                local interaction = store.nearby[i]
                utils.checkOptions(interaction)
            end
            Wait(100)
        end
    end)


    while next(store.nearby) do
        ---@type Interaction | nil
        local newActive = nil
        local newActivePriority = -1

        local focusPos = sx.client.player.getFocusPosition()

        -- Pre-scan: find highest priority interaction within effective active distance
        for i = 1, #store.nearby do
            local interaction = store.nearby[i]
            if not interaction.isDisabled then
                local priority = interaction.priority or DEFAULT_INTERACTION_PRIORITY
                local effectiveActiveDistance = interaction.activeDistance + priority * PRIORITY_ACTIVE_DISTANCE_BONUS
                if interaction.currentDistance <= effectiveActiveDistance and priority > newActivePriority then
                    newActivePriority = priority
                    newActive = interaction
                end
            end
        end

        -- Update menu if active interaction changed
        if newActive then
            if not store.activeInteraction or newActive.id ~= store.activeInteraction.id then
                store.menuBusy = true
                dui.updateMenu('updateInteraction', { id = newActive.id, options = newActive.DuiOptions })
                SetTimeout(100, function()
                    store.menuBusy = false
                end)
            end
            dui.handleDuiControls()
        end

        -- Draw pass: update isActive flags and draw sprites
        for i = 1, #store.nearby do
            local interaction = store.nearby[i]
            local active = newActive ~= nil and interaction.id == newActive.id

            if interaction.isActive ~= active then
                interaction.isActive = active
            end
            if cameraStatus then
                interaction:drawSprite( focusPos )
            end
        end

        if (not newActive and store.activeInteraction) or (newActive and store.activeInteraction and store.activeInteraction.id ~= newActive.id) then
            store.activeInteraction.isActive = false
        end

        if store.activeInteraction and not newActive then
            dui.updateMenu('updateInteraction', nil)
        end

        store.activeInteraction = newActive

        if drawPrint then
            drawPrint = false
        end
        Wait(0)
    end
    SetStreamedTextureDictAsNoLongerNeeded(indicator.dict)
    store.activeInteraction = nil
    drawLoopRunning = false
end

local builderPrint = false

local function getPlayerFocusPosition()
    if sx and sx.client and sx.client.player and sx.client.player.getFocusPosition then
        return sx.client.player.getFocusPosition()
    end
    return GetEntityCoords(PlayerPedId())
end

function BuilderLoop()
    if BuilderLoopRunning then return end
    BuilderLoopRunning = true
    CreateThread(function()
        while BuilderLoopRunning do
            local coords = getPlayerFocusPosition()
            if coords and not (coords.x == 0.0 and coords.y == 0.0 and coords.z == 0.0) then
                utils.checkEntities( coords )
                local nearby = {}
                for i = 1, #store.Interactions do
                    local interaction = store.Interactions[i]
                    if interaction and interaction:getDistance( coords ) <= 100.0 then
                        nearby[#nearby + 1] = interaction
                    end
                end
                nerbyInteractions = nearby
            end
            Wait(1500)
        end
    end)
    while BuilderLoopRunning do
        if utils.shouldHideInteractions() then
            store.nearby = {}
        else
            local coords = getPlayerFocusPosition()
            if not coords or (coords.x == 0.0 and coords.y == 0.0 and coords.z == 0.0) then
                Wait(500)
                goto continue
            end
            local nearby = {}
            for i = 1, #nerbyInteractions do
                local interaction = nerbyInteractions[i]
                if interaction and interaction:shouldRender( coords ) and utils.checkOptions(interaction) then
                    nearby[#nearby + 1] = interaction
                end
            end

            table.sort(nearby, function(a, b)

                local priorityA = a.priority or DEFAULT_INTERACTION_PRIORITY
                local priorityB = b.priority or DEFAULT_INTERACTION_PRIORITY

                local distanceBetweenAandB = #( a:getCoords() - b:getCoords() )
                local avgDistance = (a.currentDistance + b.currentDistance) / 2
                local threshold = math.max(INTERACTION_PRIORITY_MIN_THRESHOLD, avgDistance * INTERACTION_PRIORITY_DISTANCE_RATIO)

                -- If interactions are very close relative to the player's distance, sort by priority instead
                if ( priorityA ~= priorityB ) and ( distanceBetweenAandB <= threshold ) then

                    return priorityA > priorityB -- Higher priority first
                end

                -- Otherwise, sort by distance (closer first)
                return a.currentDistance < b.currentDistance
            end)

            store.nearby = nearby

            if #store.nearby > 0 and not drawLoopRunning then
                drawLoopRunning = true
                CreateThread(drawLoop)
            end

            if builderPrint then
                builderPrint = false
            end
        end
        ::continue::
        Wait(500)
    end
    store.nearby = {}
end

RegisterNetEvent('onResourceStop', function(resourceName)
    for i = #store.globalVehicle, 1, -1 do
        local data = store.globalVehicle[i]
        if data.resource == resourceName then
            store.globalIds[data.id] = nil
            table.remove(store.globalVehicle, i)
        end
    end
end)


RegisterCommand('checkInteractions', function(source, args, raw)
    print('==========================================================================================')
    lib.print.info('number of ALL interactions:', #store.Interactions)
    lib.print.info('number of NEARBY interactions:', #store.nearby)
    lib.print.info('is builder running?', BuilderLoopRunning)
    builderPrint = true
    Wait(1000)
    lib.print.info('is draw running?', drawLoopRunning)
    drawPrint = true
    lib.print.info(msgpack.unpack(msgpack.pack(store)))
    print('==========================================================================================')
end)

AddEventHandler('playerSpawned', function ()
    TriggerEvent('sleepless_interact:LoadDui')
    BuilderLoop()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1000)
        BuilderLoop()
    end
end)

function getDuiStatus()
    return store.activeInteraction
end

exports('getDuiStatus', getDuiStatus)




local isDev = GetConvar("Development", "")
if (isDev == "false") then
    return
end

print('sleepless_interact: test code loaded')

CreateThread(function()
    local interactions_coords = {
        vec4(174.28,-1022.83,29.37,49.10),
        vec4(173.46, -1023.76, 29.37, 141.60)
    }
    --[[
        eInteractionPriority =
        {
            LOW       = 0,
            MEDIUM    = 1, -- Players
            HIGH      = 2,
            VERY_HIGH = 3, -- Objetos, garagens, etc...
            CRITICAL  = 4,
        }
    ]]

    -- interação "objeto" mais próxima, priority padrão
    interact.addCoords({
        id = "awda:1",
        coords = vec3(interactions_coords[1].x, interactions_coords[1].y, interactions_coords[1].z),
        priority = 2, -- padrão
        options = {{
            label = "Objeto 1 (mais perto)",
            icon = "box",
            onSelect = function() end,
            canInteract = function() return true end
        }},
        renderDistance = 5.0,
        activeDistance = 1.5,
    })

    -- interação "Papai Noel" ligeiramente mais longe, priority maior
    interact.addCoords({
        id = "awda:2",
        coords = vec3(interactions_coords[2].x, interactions_coords[2].y, interactions_coords[2].z),
        priority = 3, -- maior priority
        options = {{
            label = "Objeto 2 (mais longe, priority maior)",
            icon = "star",
            onSelect = function() end,
            canInteract = function() return true end
        }},
        renderDistance = 5.0,
        activeDistance = 1.5,
    })
end)