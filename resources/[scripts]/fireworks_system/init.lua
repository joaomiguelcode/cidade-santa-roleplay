Tunnel = module('vrp', 'lib/Tunnel')
Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
resource = GetCurrentResourceName()

cache = {}

city = string.lower(GetConvar("cityName", ""))
language = GetConvar('language', 'pt-br') or 'pt-br'

local scope = IsDuplicityVersion() and 'server' or 'client'


config = {}

---@generic T
---@param base T?
---@return T
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

if (scope == 'client') then
    DecorRegister('ptfx', 3)

    CreateThread(function()
        local ped      = PlayerPedId()
        local hasDecor = DecorExistOn(ped, 'ptfx')

        if (hasDecor) then
            DecorRemove(ped, 'ptfx')
        end

        local objectpool = GetGamePool('CObject')

        for _, object in pairs(objectpool) do
            local pumpkin = GetEntityArchetypeName(object) == config.gifts.model

            if (pumpkin) then
                SetEntityAsMissionEntity(object, true, true)
                DeleteObject(object)
            end
        end

        TriggerEvent('hud:syncConfig') -- reset weaether and time after leaving cemetery

        local helpers = utils()
        helpers:blockControls(false)

        LocalPlayer["state"]:set("potion_active",false,true)
    end)
end

if (scope == 'server') then
    rpc = {}
    vRPC = Tunnel.getInterface('vRP')
    Tunnel.bindInterface(resource, rpc)
end