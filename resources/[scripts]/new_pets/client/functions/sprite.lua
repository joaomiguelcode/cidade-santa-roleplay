local dict = 'pets_txd'
local txd = CreateRuntimeTxd(dict)

---@type table
config.textures = {
    ['track'] = {
        dict = dict,
        texture = 'track',
        width = 0.025,
        height = 0.025,
        r = 255,
        g = 255,
        b = 255,
        a = 200,
        offset = {
            x = 0.0,
            y = 0.0,
            z = 0.6
        }
    },
}

for name in pairs(config.textures) do
    local path    = ('assets/%s.png'):format(name)
    local success = CreateRuntimeTextureFromImage(txd, name, path)

    if (success == 0) then 
        print('Texture não existe no caminho:', path)
    else
        -- print('Textura criada com sucesso:', name, 'no TXD:', txd)
    end
end

---@param texture table
---@return void
---@diagnostic disable-next-line: lowercase-global
loadTexture = function(texture)
    RequestStreamedTextureDict(texture.dict)
    repeat Wait(1) until HasStreamedTextureDictLoaded(texture.dict)
    SetStreamedTextureDictAsNoLongerNeeded(texture.dict)
end


---@param texture table
---@param coords vector3
---@return void
---@diagnostic disable-next-line: lowercase-global
renderSprite = function(texture, coords)
    local offset = texture.offset or { x = 0.0, y = 0.0, z = 0.0 }

    SetDrawOrigin(coords.x + offset.x, coords.y + offset.y, coords.z + offset.z, 0)
    DrawSprite(texture.dict, texture.texture,  0, 0, texture.width, texture.height* GetAspectRatio(true),0, texture.r,texture.g,texture.b, texture.a)
    ClearDrawOrigin()
end

---@param texture table
---@param ped number
---@param entity number
---@param taskId number
---@param oldTaskId number
---@param isOwner boolean
---@return void
---@diagnostic disable-next-line: lowercase-global
setSpriteRunning = function(texture, ped, entity, taskId, oldTaskId, isOwner)
    CreateThread(function()
        local lastCoords = nil
        while DoesEntityExist(entity) and Entity(entity).state.pet_task == taskId do
            if Entity(entity).state.pet_temporary then
                return
            end

            local entityCoords = GetEntityCoords(entity)

            lastCoords = entityCoords
            
            local pedCoords = GetEntityCoords(ped)
            local dist = #(entityCoords - pedCoords)
            
            if (dist > 15.0) then
                renderSprite(texture, entityCoords)
            end

            Wait(1)
        end

        local exists = DoesEntityExist(entity)
        if (not exists) then
            setPetLost(entity, petName, lastCoords)
        end

        -- print('sprite running ended')
    end)

end
