---@class NetFreecam
---@field source number
---@field pos vector3

---@type NetFreecam[]
local gNetFreecams = {}

---@type table<number, NetFreecam>
local gNetFreecamBySource = {}

---@type number?
local gLocalSource = nil

--- Source local, calculada uma vez (lazy) na primeira chamada.
---@return number
local function GetLocalSource()

    if not gLocalSource then
        gLocalSource = ToSource(GetPlayerServerId(PlayerId()))
    end

    return gLocalSource
end

WallClient.Freecam = {}

--- Lista todas as netfreecams ativas.
---@return NetFreecam[]
function WallClient.Freecam.List()
    return gNetFreecams
end

--- Diz se existe uma netfreecam pra essa source.
---@param source number
---@return boolean
function WallClient.Freecam.Has(source)
    return gNetFreecamBySource[source] ~= nil
end

--- Remove a netfreecam da source, se existir (no-op caso contrário).
---@param source number
---@return nil
function WallClient.Freecam.Remove(source)

    local netfreecam = gNetFreecamBySource[source]
    if not netfreecam then
        return
    end

    for index, entry in pairs(gNetFreecams) do

        if entry.source == source then
            table.remove(gNetFreecams, index)
            break
        end
    end

    gNetFreecamBySource[source] = nil
end

--- Limpa todas as netfreecams.
---@return nil
function WallClient.Freecam.Clear()
    table.wipe(gNetFreecams)
    table.wipe(gNetFreecamBySource)
end

--- Adiciona uma netfreecam nova.
---@param source number
---@param pos vector3
---@return nil
local function AddNetFreecam(source, pos)

    ---@type NetFreecam
    local netfreecam = {
        source = source,
        pos = pos,
    }

    table.insert(gNetFreecams, netfreecam)

    gNetFreecamBySource[source] = netfreecam
end

RegisterNetEvent('net.net_freecam.remove', function(source)

    if WallClient.Freecam.Has(source) then
        WallClient.Freecam.Remove(source)
    end
end)

---@class NetFreecamPositionUpdate
---@field [1] number
---@field [2] vector3

---@param positionUpdatesStr string
RegisterNetEvent('net.net_freecam.position_updates', function(positionUpdatesStr)

    local cursor = 1
    local localSource = GetLocalSource()

    while cursor < #positionUpdatesStr do

        local source = string.unpack('>I2', positionUpdatesStr, cursor)
        cursor = cursor + 2 -- 1 uint16

        local worldlimitsposition = sx.msgpackextensions.unpackers.worldlimitsvector3(positionUpdatesStr, cursor)
        cursor = cursor + 6 -- 3 int16

        -- A source é 0 quando o update da NetFreecam é invalidado
        -- que ocorre quando um update já foi enviado porém o player saiu do freecam
        if source ~= 0 and source ~= localSource then

            local netfreecam = gNetFreecamBySource[source]

            if not netfreecam then
                AddNetFreecam(source, worldlimitsposition)
            else
                netfreecam.pos = worldlimitsposition
            end
        end
    end
end)
