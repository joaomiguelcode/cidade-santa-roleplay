---@type collectibles.Collectible[] | nil
local gCollectibles = nil

-- ---@type promise
-- local gCollectiblesQueryResponsePromise  = nil
-- local gCollectiblesQueryLoadingPromise = nil

-- function QueryCollectibles()

--     if not gCollectibles then

--         if not gCollectiblesQueryLoadingPromise then

--             gCollectiblesQueryResponsePromise = promise.new()
--             gCollectiblesQueryLoadingPromise  = sx.async.withTimeout( gCollectiblesQueryResponsePromise, 1000 )
--             gCollectiblesQueryLoadingPromise:next(
--                 function()
--                     gCollectiblesQueryLoadingPromise = nil
--                 end
--             )

--             TriggerServerEvent( 'net.collectibles.me.listCollectibles' )
--         end

--         Citizen.Await( gCollectiblesQueryLoadingPromise )
--     end

--     return gCollectibles
-- end

-- NUI callback 'requestShop' no script 'inventory' executa essa funcao para saber
-- quais items devem ter na 'loja'

function InvalidateCollectiblesShopInventory()
    gMeCollectiblesCollection.hasData = false
    TriggerEvent("inventory:Close")
end

---@param cannotShowCollectionsIds? table<string, boolean>
function GetCollectiblesShopInventory( cannotShowCollectionsIds )

    while not gMeCollectiblesCollection do
        Wait( 0 )
    end

    local meCollectibles = gMeCollectiblesCollection:data()



    local shopItems = { }

    for _, collectible in ipairs( meCollectibles ) do
        xpcall(
            function()

                local collectibleDef = GetCollectibleDefByKey( collectible.lookupKey )

                assert( collectibleDef, ('Collectible def not found with lookupKey= "%s"'):format( collectible.lookupKey ) )

                local collectionId = collectibleDef.collectionId

                if not collectionId or not cannotShowCollectionsIds or not cannotShowCollectionsIds[ collectionId ] then
                    table.insert( shopItems, {
                        key   = collectibleDef.itemKey,
                        price = 0,
                        index = collectibleDef.itemKey,
                    })
                end
            end,
            function( error )

                sx.logger:error( ('Error getting collectible "%s" def!\n%s'):format( collectible.lookupKey, error ) )
            end
        )
    end

    sx.logger:info( 'shopItems', json.encode( shopItems, { indent = true } ) )

    return shopItems
end

exports( 'GetCollectiblesShopInventory', GetCollectiblesShopInventory )
exports( 'InvalidateCollectiblesShopInventory', InvalidateCollectiblesShopInventory )

RegisterNetEvent( 'net.santa_radio.collectibles.invalidateShopInventory', InvalidateCollectiblesShopInventory )

RegisterCommand( 'collectibles', function()

	exports.inventory:openShop({
        tag = 'Collectibles',
        type = 'Buy'
    } --[[ @as inventory.OpenShopParams ]])
end )
