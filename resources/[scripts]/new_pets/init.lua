Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP      = Proxy.getInterface('vRP')
scope    = IsDuplicityVersion() and 'server' or 'client'
resource = GetCurrentResourceName()

local gModelByVaultItemId = {}

for model, settings in pairs(config.modelSettings) do
    local vaultItemId = settings.vaultItemId

    if vaultItemId then
        assert(not gModelByVaultItemId[vaultItemId], ("duplicate vault item id=%s"):format(vaultItemId))
        gModelByVaultItemId[vaultItemId] = model
    end
end

---@return table modelSettings
exports('GetModelSettings', function()
    return config.modelSettings
end)

---@param vaultItemId string
---@return string? model
exports('GetModelByVaultItemId', function(vaultItemId)
    if type(vaultItemId) ~= 'string' then
        return nil
    end

    return gModelByVaultItemId[vaultItemId]
end)

cityName = GetConvar('cityName', '')
city = string.lower(cityName)
lang = GetConvar('language', 'pt-br') or 'pt-br'

---@return string
---@diagnostic disable-next-line: lowercase-global
getUnixTimestampMillis = function()
    local seconds = os.time()
    local millis = seconds * 1000
    return string.format("%.1f", millis)  -- retorna como string com .0 no final
end

---@param base table
---@return table
---@diagnostic disable-next-line: lowercase-global
class = function(base)
    local cls = {}
    cls.__index = cls
    cls.__base = base
    setmetatable(
        cls,
        {
            __call = function(_, ...)
                local instance = setmetatable({}, cls)
                if cls.__init then
                    cls.__init(instance, ...)
                end
                return instance
            end,
            __index = base
        }
    )
    return cls
end

if (scope == 'server') then
    rpc = {}
    vRPC = Tunnel.getInterface('vRP')
    Tunnel.bindInterface(resource, rpc)
    vCLIENT = Tunnel.getInterface(resource)
    mysql = exports['oxmysql']
else
    rpc = {}
    Tunnel.bindInterface(resource, rpc)
    vSERVER = Tunnel.getInterface(resource)

    RegisterNUICallback = RegisterNUICallback
    PlaySoundFrontend = PlaySoundFrontend
    GetGameTimer = GetGameTimer
    GetNetworkTime = GetNetworkTime
    Wait = Wait
    SetNuiFocus = SetNuiFocus
    SendNUIMessage = SendNUIMessage
    DoesEntityExist = DoesEntityExist
    Entity = Entity
    NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId
    NetworkGetNetworkIdFromEntity = NetworkGetNetworkIdFromEntity
    GetEntityFromStateBagName = GetEntityFromStateBagName
    GetEntityArchetypeName = GetEntityArchetypeName
    GetGamePool = GetGamePool
    LocalPlayer = LocalPlayer
    PlayerPedId = PlayerPedId
    RegisterNetEvent = RegisterNetEvent
    TriggerServerEvent = TriggerServerEvent
    AddStateBagChangeHandler = AddStateBagChangeHandler
    IS_ADMIN = false
    repeat Wait(100) until config.interactions
end

tasks = {} -- table to store task ids for easy access
local id = 1

for _, interaction in ipairs(config.interactions) do
    local task = { id = id, action = interaction.action, data = interaction, closeUI = interaction.closeUI }
    tasks[id] = task
    tasks[interaction.action] = task
    id = id + 1
end

for _, interaction in ipairs(config.ownerInteractions) do
    local task = { id = id, action = interaction.action, data = interaction, ownerOnly = true, closeUI = interaction.closeUI }
    tasks[id] = task
    tasks[interaction.action] = task

    id = id + 1
end
