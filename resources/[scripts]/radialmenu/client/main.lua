-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")

game = {}
game.menuEntries = {}

game.currentEntityTarget = nil

RadialDebug = false
Debug = function(...)
    if not RadialDebug then return end
    local info = debug.getinfo(2, "Sl") 
    local side = IsDuplicityVersion() and "SERVER" or "CLIENT"
    local debugMsg = string.format("[%s] %s:%d", side, info.short_src, info.currentline)
    debugMsg = debugMsg:gsub("@", "")
    print(debugMsg, ...)
end

local GroupCache = GlobalState[ 'GROUP_CACHE' ] or {}
AddStateBagChangeHandler( 'GROUP_CACHE', 'global', 
    function( _, _, value )
        GroupCache = value or {}
    end
)

function game.start()
    game.registerRadialMenu()
    -- exampleRadialMenu()
end

function game.stop()
    
    SetNuiFocus(false, false)
    game.clearRadialItems()
    game.hideRadial()
end

function game.registerRadialMenu()
    Debug("registerRadialMenu ->> ")
    game.addRadialItem(game.menuEntries["general"])
    
    for menuIndex, menu in pairs( game.menuEntries ) do
        if menuIndex ~= "general" then
            game.registerRadial({
                id = menuIndex,
                items = menu,
            })
        end
    end
end

AddEventHandler("onResourceStart", function(resName)
    if resName == GetCurrentResourceName() then
        game.start()
    end
end)

AddEventHandler("onResourceStop", function(resName)
    if resName == GetCurrentResourceName() then
        game.stop()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteractionCore()
    end
    
    if resource == GetCurrentResourceName() then
        StartInteractionCore()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartInteractionCore()
end)

openProfile = function(entity, isGame, options)
    local ped = entity and DoesEntityExist(entity) and entity or PlayerPedId()
    local index      = NetworkGetPlayerIndexFromPed(ped)
    local source     = options and options.source or GetPlayerServerId(index)
    local Passport   = options and options.passport or Player(source).state.Passport
    local showPhone  = Player(source).state.showPhone
    local showJob    = Player(source).state.showJob
    local pid        = GetPlayerServerId(PlayerId())
    local myPassport = Player(pid).state.Passport

    SetNuiZindex(9999999)

    local payload = {
        action = 'SHOW_PROFILE',
        data   = {
            display    = true, -- se true, mostra o perfil, se false, esconde
            myPassport = myPassport, -- meu passport
            passport   = Passport, -- passport do jogador que estou olhando
            cityId     = cityName, -- nome da cidade
            isGame     = isGame or false, -- pra visualizar ou pra editar,
            matchCity = options and options.matchCity == true or false,
            matchPresentation = options and options.presentation or nil,
            userProfile = {
                showPhone = showPhone,
                showJob   = showJob,
            }
        }
    }

    SendNUIMessage(payload)
end

exports("openProfile", openProfile)

local gMatchProfileOpen = false
local gMatchProfileFocused = false

exports("focusMatchProfile", function()

    if not gMatchProfileOpen then return false end
    gMatchProfileFocused = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = 'MATCH_PROFILE_FOCUS', data = { focused = true } })
    return true
end)

exports("openMatchProfile", function(source, presentation, passport)
    local player = GetPlayerFromServerId(source)
    local ped = player ~= -1 and GetPlayerPed(player) or nil
    if not passport and (not ped or ped == 0 or not DoesEntityExist(ped)) then return false end

    gMatchProfileOpen = true
    openProfile(ped, true, { matchCity = true, presentation = presentation,
        source = source, passport = tonumber(passport) })
    return true
end)

exports("closeMatchProfile", function()
    closeProfile()
end)

closeProfile = function()

    local wasMatchProfile = gMatchProfileOpen
    gMatchProfileOpen = false
    if gMatchProfileFocused then
        gMatchProfileFocused = false
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
    if wasMatchProfile then TriggerEvent('dminigames:neighbor:profileClosed') end

    SetNuiZindex(88888)

    -- SetNuiZindex(9999999)

    local payload = {
        action = 'SHOW_PROFILE',
        data   = {
            display = false, -- se true, mostra o perfil, se false, esconde
        }
    }

    SendNUIMessage(payload)

end

exports("closeProfile", closeProfile)

RegisterNUICallback('CLOSE_MATCH_PROFILE', function(_, cb)

    if gMatchProfileOpen then closeProfile() end
    cb(true)
end)

AddEventHandler('onClientResourceStop', function(resource)

    if gMatchProfileOpen and (resource == GetCurrentResourceName() or resource == 'dminigames') then
        closeProfile()
    end
end)

local function MatchPartnerSource(entity)

    if LocalPlayer.state['minigame:active'] ~= 'neighbor'
        or LocalPlayer.state['matchcity:house'] ~= true
        or GetResourceState('dminigames') ~= 'started' then return nil end
    local player = NetworkGetPlayerIndexFromPed(entity)
    if player == -1 then return nil end
    local source = GetPlayerServerId(player)
    local ok, partner = pcall(function()
        return exports.dminigames:IsMatchCityPartner(source)
    end)
    return ok and partner and source or nil
end

function StartInteractionCore()
    interact.addGlobalPlayer({
        id = "interactionsPlayer",
        options = {
            {
                label = _t("interact_player"),
                icon = "hand",
                onSelect = function(data)
                    local matchSource = MatchPartnerSource(data.entity)
                    if not matchSource and not exports.admin:SafeguardAccountHasDiscordAccountLink() then
                        return
                    end

                    if LocalPlayer["state"]["minigame:active"] and not matchSource then
                        return
                    end

                    if matchSource then
                        game.currentEntityTarget = data.entity
                        game.registerRadialMenu()
                        CreateThread(function()
                            Wait(150)
                            SetNuiFocus(false, false)
                            SetNuiFocusKeepInput(false)
                            game.openRadialMenu()
                        end)
                        return
                    end

                    if cityName == "Universo" then
                        local discordLink = exports.register:isDiscordValidated()
                        if discordLink then
                            TriggerEvent("register:openNewDiscordValidation")
                            return
                        end
                    end

                    game.currentEntityTarget = data.entity

                    openProfile(data.entity, true)

                    game.registerRadialMenu()
                    game.openRadialMenu()
                end,
                canInteract = function(entity, distance, coords, id)
                    local ped = PlayerPedId()
                    local entityState = Entity(entity).state

                    if GetEntityHealth(ped) <= 100 then
                        return false
                    end

                    if entityState.recording then
                        
                        return false
                    end


                    local isVisible = IsEntityVisible(entity)
                    local hasLos = HasEntityClearLosToEntity(ped, entity, 17)
                    local isAttached = IsEntityAttached(entity)
                    local isAttachedToPlayer = IsEntityAttachedToEntity(entity, ped) or IsEntityAttachedToEntity(ped, entity)
                    local isInMinigame = LocalPlayer["state"]["minigame:active"]
                    return isVisible and hasLos and not isAttached and not isAttachedToPlayer
                        and (not isInMinigame or MatchPartnerSource(entity) ~= nil)
                end
            },
            {
                label = _t('matchcity_add_contact'),
                icon = 'address-book',
                onSelect = function(data)

                    local source = MatchPartnerSource(data.entity)
                    if source then TriggerEvent('dminigames:neighbor:requestContactFromInteraction', source) end
                end,
                canInteract = function(entity)

                    return MatchPartnerSource(entity) ~= nil
                end,
            },
            {
                label = _t("recruit_interaction"),
                icon = "handshake",
                onSelect = function(data)
                    TriggerEvent("net.painel.reqHireClosest")
                end,
                canInteract = function(entity, distance, coords, id)

                    if not LocalPlayer.state.isFactionRecruiter then

                        -- sx.logger:debug( ('StartInteraction :: isFactionRecruiter: %s'):format( LocalPlayer.state.isFactionRecruiter ))
                        
                        return
                    end

                    local job = LocalPlayer.state.Job

                    if not WithoutRangeVerification[ job ] then
                        local closest = exports.survival:GetClosestRisk()
                        local jobQG   = GroupCache[ job ]

                        if closest ~= job and closest ~= jobQG then

                            -- sx.logger:debug( ('StartInteraction :: Job: %s | Closest: %s | jobQG: %s'):format( job, tostring( closest ), tostring( jobQG ) ) )

                            return
                        end
                    end

                    if Entity( entity ).state.Iniciante ~= true then

                        -- sx.logger:debug( ('StartInteraction :: Iniciante: %s'):format( Entity( entity ).state.Iniciante ))

                        return
                    end

                    return true
                end
            }
        },
        -- offset = vec3(0, 0, 1.0),
        bone = "SKEL_Pelvis",
        renderDistance = 1.7,
        activeDistance = 1.3,
        cooldown = 1500
    })
    
end

-- Event handler para mostrar modal de confirmação de relacionamento
RegisterNetEvent('relationship:showConfirmationModal', function(data)
    local options = {
        {
            label = "Pedir em namoro mesmo assim",
            action = function()
                TriggerServerEvent('relationship:confirmSteal', {
                    receiver_id = data.receiver_id,
                    partner_id = data.partner_id
                })
            end
        },
        {
            label = "Fechar o modal",
            action = function()
                TriggerServerEvent('relationship:cancelSteal')
            end
        }
    }
    
    -- Usar o sistema de request do vRP para mostrar o modal
    local confirm = exports["vrp"]:Request("Confirmação", data.message, 30)
    if confirm then
        TriggerServerEvent('relationship:confirmSteal', {
            receiver_id = data.receiver_id,
            partner_id = data.partner_id
        })
    else
        TriggerServerEvent('relationship:cancelSteal')
    end
end)

function HasPermission(group)
    local playerGroups = vRP.GetPlayerGroups() or {}

    if playerGroups[group] ~= nil then
        return true
    end

    -- Considera grupos pais (mesma semântica de vRP.HasGroup no server).
    local groupData = Groups[group]
    if groupData then
        for parent in pairs(groupData["Parent"] or {}) do
            if playerGroups[parent] ~= nil then
                print(parent)
                return true
            end
        end
    end

    print(group, "false")

    return false
end
