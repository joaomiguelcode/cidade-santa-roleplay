---@alias collectibles.CollectibleKey string

---@class collectibles.CollectibleDef
---@field lookupKey collectibles.CollectibleKey
---@field collectionId string?
---@field itemKey string
---@field def collectibles.CollectibleDef

---@type table<collectibles.CollectibleKey, collectibles.CollectibleDef>
local gCollectibleDefsByKey = { }
---@type table<string, collectibles.CollectibleKey>
local gCollectibleDefsByItemKey = { }

---@enum eScriptedInteractionStateFlags
eScriptedInteractionStateFlags =
{
	NONE = 1 << 0,
	STATE_TRANSITION__KEEP_ALL_PROP = 1 << 1,	-- Ao mudar de state, mantem os props que foram criados no state anterior e não tenta criar novos!

	WHEN_FINISHED__DELETE_ALL_PROP = 1 << 10,

	SKIP_IN_WATER_CHECKS = 1 << 11, -- Ignorar as validações quando estiver dentro da água
	SKIP_ALL_CHECKS = 1 << 12, -- Ignorar todas as validações
}

---@param key collectibles.CollectibleKey
function DEFINE_COLLECTIBLE( key, def )

    assert( not gCollectibleDefsByKey[ key ], ('Collectible def already defined with key= "%s"'):format( key ) )

    ---@param def collectibles.CollectibleDef
    return function( def )

        def.lookupKey = key
        def.itemKey = def.itemKey
        def.collectionId = def.collectionId

        if def.scriptedInteraction then

            exports.scripted_interactions:defineScriptedInteraction( key )( def.scriptedInteraction )
            
        end

        DEFINE_ENTITLEMENTFEATURE_DEF ( def.lookupKey ) {

            replicated = true,
        }

        assert( not gCollectibleDefsByItemKey[ def.itemKey ], ('Collectible def already defined with itemKey= "%s"'):format( def.itemKey ) )

        gCollectibleDefsByKey[ key ] = def
        gCollectibleDefsByItemKey[ def.itemKey ] = def
    end
end

---@param key collectibles.CollectibleKey
---@return collectibles.CollectibleDef | nil
function GetCollectibleDefByKey( key )

    return gCollectibleDefsByKey[ key ]
end

exports( 'GetCollectibleDefByKey', GetCollectibleDefByKey )

---@return collectibles.CollectibleKey[]
function GetCollectiblesKeys()
    local keys = { }
    for key, _ in pairs(gCollectibleDefsByKey) do
        table.insert(keys, key)
    end

    return keys
end

exports( 'GetCollectiblesKeys', GetCollectiblesKeys )

---@return collectibles.CollectibleKey[]
function GetCollectibleKeysByCollectionId( collectionId )
    local keys = { }
    for key, def in pairs(gCollectibleDefsByKey) do
        if def.collectionId == collectionId then
            table.insert(keys, key)
        end
    end
    return keys or { }
end

exports( 'GetCollectibleKeysByCollectionId', GetCollectibleKeysByCollectionId )

---@param itemKey string
---@return collectibles.CollectibleKey | nil
function GetCollectibleLookupKeyByItemKey( itemKey )

    return gCollectibleDefsByItemKey[ itemKey ]?.lookupKey
end

exports( 'GetCollectibleLookupKeyByItemKey', GetCollectibleLookupKeyByItemKey )
