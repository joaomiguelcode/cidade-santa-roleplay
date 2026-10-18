-- Aqui você pode colocar as adaptações
-- Ex:
-- Summerz = true

-- CreateObject é pelo "vRP:createObjects"

-- Necessario para que o script use a native "CreateObject" para criar objetos
MODE_CACHE = 'auto'

local PHONE_MODEL_HASH = `prop_amb_phone`

local PLACEHOLDER_ENTITY_ID = -1

local orig_SendNUIMessage = SendNUIMessage
local orig_SetNuiFocus = SetNuiFocus
local orig_DisableControlAction = DisableControlAction
local orig_DisableAllControlActions = DisableAllControlActions
local orig_DisablePlayerFiring = DisablePlayerFiring
local orig_SetCurrentPedWeapon = SetCurrentPedWeapon
local orig_SetPedCurrentWeaponVisible = SetPedCurrentWeaponVisible
local orig_HidePedWeaponForScriptedCutscene = HidePedWeaponForScriptedCutscene
local WEAPON_UNARMED_HASH = `WEAPON_UNARMED`
-- Ícone embutido para o app não depender do carregamento de um arquivo NUI separado.
local MATCH_SOCIAL_ICON = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA2NCA2NCI+DQogIDxyZWN0IHdpZHRoPSI2NCIgaGVpZ2h0PSI2NCIgcng9IjE0IiBmaWxsPSIjZmFjYzE1Ii8+DQogIDxyZWN0IHg9IjEyIiB5PSIxNyIgd2lkdGg9IjMzIiBoZWlnaHQ9IjM5IiByeD0iNCIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMWExNDAwIiBzdHJva2Utd2lkdGg9IjUiIHRyYW5zZm9ybT0icm90YXRlKC0xMCAyOC41IDM2LjUpIi8+CiAgPHJlY3QgeD0iMjEiIHk9IjEwIiB3aWR0aD0iMzMiIGhlaWdodD0iMzkiIHJ4PSI0IiBmaWxsPSIjMWExNDAwIiB0cmFuc2Zvcm09InJvdGF0ZSgxMCAzNy41IDI5LjUpIi8+Cjwvc3ZnPg0K'

local function IsMatchCityEnabled()
    if GetResourceState('dminigames') ~= 'started' then return false end
    local ok, enabled = pcall(function() return exports.dminigames:IsMatchCityEnabled() end)
    return ok and enabled == true
end

local function IsMinigameActive()

    local state = LocalPlayer and LocalPlayer.state
    local active = state and state['minigame:active']
    -- A casa social permite celular; os outros minigames continuam bloqueados.
    return active and not (active == 'neighbor' and state['matchcity:house'] == true)
end

local function IsWeaponUnarmed( weaponHash )
    return weaponHash and ( weaponHash & 0xFFFFFFFF ) == ( WEAPON_UNARMED_HASH & 0xFFFFFFFF )
end

function SendNUIMessage( message )
    if type( message ) == 'table' and message.event == 'open' and IsMinigameActive() then
        return
    end

    local result = orig_SendNUIMessage( message )
    if type( message ) == 'table' and message.event == 'open'
        and IsMatchCityEnabled() then
        orig_SendNUIMessage({ event = 'pusher', args = { 'CREATE_APP', {
            id = 'match-social', name = _t('matchSocial.appName'),
            icon = MATCH_SOCIAL_ICON,
            url = 'https://cfx-nui-smartphone/dist/match-social.html',
        } } })
    end
    return result
end

RegisterNUICallback('matchSocialOpen', function(_, cb)
    cb({ ok = true })
    if not IsMatchCityEnabled() then return end
    orig_SendNUIMessage({ event = 'close', args = { true } })
    orig_SetNuiFocus(false, false)
    CreateThread(function()
        local affiliateBusy = false
        if GetResourceState('dashboard') == 'started' then
            local ok, active = pcall(function()
                return exports.dashboard:IsAffiliateCommercialActive()
            end)
            affiliateBusy = ok and active == true
        end
        Wait(250)
        TriggerServerEvent('dminigames:neighbor:openFromApp', affiliateBusy)
    end)
end)

function SetNuiFocus( hasFocus, hasCursor )
    if hasFocus and IsMinigameActive() then
        return
    end

    return orig_SetNuiFocus( hasFocus, hasCursor )
end

function DisableControlAction( padIndex, control, disable )
    if disable and IsMinigameActive() then
        return
    end

    return orig_DisableControlAction( padIndex, control, disable )
end

function DisableAllControlActions( padIndex )
    if IsMinigameActive() then
        return
    end

    return orig_DisableAllControlActions( padIndex )
end

function DisablePlayerFiring( player, toggle )
    if toggle and IsMinigameActive() then
        return
    end

    return orig_DisablePlayerFiring( player, toggle )
end

function SetCurrentPedWeapon( ped, weaponHash, equipNow )
    if IsMinigameActive() and IsWeaponUnarmed( weaponHash ) then
        return
    end

    return orig_SetCurrentPedWeapon( ped, weaponHash, equipNow )
end

function SetPedCurrentWeaponVisible( ped, visible, deselectWeapon, p3, p4 )
    if IsMinigameActive() and not visible then
        return
    end

    return orig_SetPedCurrentWeaponVisible( ped, visible, deselectWeapon, p3, p4 )
end

function HidePedWeaponForScriptedCutscene( ped, toggle )
    if IsMinigameActive() and toggle then
        return
    end

    return orig_HidePedWeaponForScriptedCutscene( ped, toggle )
end

function CreateObject( modelHash, x, y, z, isNetwork, netMissionEntity, doorFlag )
    
    modelHash = type( modelHash ) == 'string' and GetHashKey( modelHash ) or modelHash

    assert( modelHash == PHONE_MODEL_HASH, ('CreateObject :: Object model %s is not PHONE_MODEL_HASH %s'):format( modelHash, PHONE_MODEL_HASH ) )

    -- print('CreateObject :: exports.scripted_interactions:isRunningScriptedInteraction=', exports.scripted_interactions:isRunningScriptedInteraction( 'cellphone' ))

    -- if not exports.scripted_interactions:isRunningScriptedInteraction( 'cellphone' ) then
    
    --     exports.scripted_interactions:startScriptedInteraction( 'cellphone' )
    -- end
    
    -- Retornar um object invalido para que o script possa
    -- funcionar normalmente!
    return PLACEHOLDER_ENTITY_ID
end

function DeleteEntity( entityId )

    -- print('DeleteEntity :: exports.scripted_interactions:isRunningScriptedInteraction=', entityId, exports.scripted_interactions:isRunningScriptedInteraction( 'cellphone' ))

    if not DoesEntityExist( entityId ) then
        return
    end

    local modelHash = GetEntityModel( entityId ) & 0xFFFFFFFF

    -- print('DeleteEntity :: continuing')

    assert( entityId == PLACEHOLDER_ENTITY_ID or modelHash == PHONE_MODEL_HASH, ('DeleteEntity :: Object model %s is not PHONE_MODEL_HASH %s'):format( modelHash, PHONE_MODEL_HASH ) )

    -- print('DeleteEntity :: after continuing=', entityId, exports.scripted_interactions:isRunningScriptedInteraction( 'cellphone' ))

    if exports.scripted_interactions:isRunningScriptedInteraction( 'cellphone' ) then

        local interactionStateName = exports.scripted_interactions:getScriptedInteractionState( 'cellphone' )

        -- "text_out" é quando o jogador está guardando o celular, então a gente quer
        -- que o ScriptedInteraction lide com deletar a entidade!
        if interactionStateName ~= 'text_out' and interactionStateName ~= 'car_text_out' then

            exports.scripted_interactions:stopScriptedInteraction({ interactionName = 'cellphone' })
        end
    end
end

local orig_DoesEntityExist = DoesEntityExist

function DoesEntityExist( entityId )

    -- O script precisa que essa native retorne true ao menos
    -- 1 vez para que "DeleteEntity" seja executado quando o celular é fechado!

    if entityId == PLACEHOLDER_ENTITY_ID and exports.scripted_interactions:isRunningScriptedInteraction( 'cellphone' ) then

        -- Entidade é nossa!

        -- print( ('DoesEntityExist returned truee!') )

        return true
    end

    return orig_DoesEntityExist( entityId )
end

function TaskPlayAnim( entityId, animDictionary, animName, ... )

    -- Não queremos que o script execute a animação

    -- print( ('TaskPlayAnim entityId=%s animDictionary="%s" animName="%s"'):format( entityId, animDictionary, animName ) )

    if IsMinigameActive() then
        return
    end

    local interactionStatePrefix =
        animDictionary == 'anim@cellphone@in_car@ps'
        and 'car_'
        or  ''

    if     animName == 'cellphone_text_in' then

        exports.scripted_interactions:startScriptedInteraction( 'cellphone', { state = interactionStatePrefix .. 'idle' } )

    elseif animName == 'cellphone_text_out' then

        exports.scripted_interactions:startScriptedInteraction( 'cellphone', { state = interactionStatePrefix .. 'text_out' } )

    elseif animName == 'cellphone_text_to_call' then

        exports.scripted_interactions:startScriptedInteraction( 'cellphone', { state = interactionStatePrefix .. 'text_to_call' } )

    elseif animName == 'cellphone_call_to_text' then

        exports.scripted_interactions:startScriptedInteraction( 'cellphone', { state = interactionStatePrefix .. 'call_to_text' } )

    elseif animName == 'cellphone_call_out' then

        exports.scripted_interactions:startScriptedInteraction( 'cellphone', { state = interactionStatePrefix .. 'call_out' } )
    end
end

MinimumHealth = 101

RegisterNetEvent('smartphone:contactSaved', function(contact)

    if type(contact) ~= 'table' or not contact.id or type(contact.phone) ~= 'string' or type(contact.name) ~= 'string' then return end
    SendNUIMessage({ event = 'externalContactSaved', args = { contact } })
end)
