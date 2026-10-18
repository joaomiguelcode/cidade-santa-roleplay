--[[
    Destino + linha de GPS apenas no minimapa (blip com SetBlipRoute).
]]

local resourceName = GetCurrentResourceName()

local DEFAULTS = {
    blipSprite = 480,
    blipColour = 3,
    blipScale = 0.9,
    blipShortRange = false,
}

local state = {
    active = false,
    def = nil,
    blip = 0,
}

local function mergeDef(base)
    local out = {}
    for k, v in pairs(DEFAULTS) do
        out[k] = v
    end
    if type(base) == 'table' then
        for k, v in pairs(base) do
            out[k] = v
        end
    end
    return out
end

local function getPresetById(id)
    if type(id) ~= 'string' or type(GUIDED_ROUTE_PRESETS) ~= 'table' then
        return nil
    end
    return GUIDED_ROUTE_PRESETS[id]
end

local function clearRoute()
    state.active = false
    state.def = nil
    if state.blip ~= 0 then
        if DoesBlipExist(state.blip) then
            SetBlipRoute(state.blip, false)
            RemoveBlip(state.blip)
        end
        state.blip = 0
    end
end

local function startRoute(def)
    if not def or not def.destination then
        sx.logger:warn('guided_route: startRoute missing destination')
        return false
    end

    clearRoute()
    state.def = def

    local c = def.destination
    local blip = AddBlipForCoord(c.x, c.y, c.z)
    SetBlipSprite(blip, def.blipSprite)
    SetBlipColour(blip, def.blipColour)
    SetBlipScale(blip, def.blipScale)
    SetBlipAsShortRange(blip, def.blipShortRange == true)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName('STRING')
    local label = def.labelFallback or 'Destino'
    if def.labelTranslationKey and _t then
        label = _t(def.labelTranslationKey) or label
    end
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)

    state.blip = blip
    state.active = true

    sx.logger:debug(('guided_route: minimap route started id=%s'):format(tostring(def.id or 'custom')))
    return true
end

function GuidedRouteStart(defOrId)
    local raw = defOrId
    if type(defOrId) == 'string' then
        raw = getPresetById(defOrId)
        if not raw then
            sx.logger:warn(('guided_route: unknown preset %s'):format(defOrId))
            return false
        end
    end
    if type(raw) ~= 'table' then
        return false
    end
    return startRoute(mergeDef(raw))
end

function GuidedRouteStop()
    sx.logger:debug('guided_route: stopped')
    clearRoute()
end

function GuidedRouteIsActive()
    return state.active == true
end

function GuidedRouteGetActivePresetId()
    if state.active and state.def and state.def.id then
        return state.def.id
    end
    return nil
end

exports('GuidedRouteStart', GuidedRouteStart)
exports('GuidedRouteStop', GuidedRouteStop)
exports('GuidedRouteIsActive', GuidedRouteIsActive)
exports('GuidedRouteGetActivePresetId', GuidedRouteGetActivePresetId)

RegisterCommand('testguidedroute', function(_, args)
    local a1 = args[1]
    if type(a1) == 'string' then
        local lower = string.lower(a1)
        if lower == 'stop' or lower == 'off' then
            GuidedRouteStop()
            TriggerEvent('Notify', 'Confirmed', 'Guided route: parado.', 3000)
            return
        end
    end

    if type(a1) == 'string' and string.lower(a1) == 'preset' and args[2] then
        if GuidedRouteStart(args[2]) then
            TriggerEvent('Notify', 'Confirmed', ('Guided route: preset %s.'):format(args[2]), 4000)
        else
            TriggerEvent('Notify', 'Denied', ('Preset inválido: %s'):format(args[2]), 4000)
        end
        return
    end

    local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    local destination
    if x and y and z then
        destination = vector3(x, y, z)
    else
        destination = CONNECT_ONBOARDING_DOCUMENTO_COORDS
    end
    if not destination or destination.x == nil then
        TriggerEvent('Notify', 'Denied', 'Destino inválido.', 4000)
        return
    end

    GuidedRouteStart({
        id = 'dev_test',
        destination = destination,
        labelFallback = 'Teste rota guiada',
    })
    TriggerEvent('Notify', 'Confirmed', 'Guided route: rota no minimapa.', 4000)
end, false)

AddEventHandler('onResourceStop', function(res)
    if res == resourceName then
        clearRoute()
    end
end)
